/**
 * LeverPlacement — a grabbable tire lever. Adds the box collider, Interactable and
 * InteractableManipulation at runtime; on release measures the distance to the
 * socket: within snapRadiusCm it snaps to the socket pose, locks, and fires
 * onPlaced; otherwise it tweens back to its tray (home) pose.
 * Owns: the lever's own transform, lock state. Must not: change the wheel.
 * Expects: @input socket (LeverSocket for A, LeverSocketB for B). RepairManager
 * gates snapping with `snapEnabled`; RimDrag re-activates manipulation after a
 * lock via setManipulationActive(true) to drag the hooked lever along the rim.
 * A locked lever is reparented to the socket's parent (the Wheel) so the tray can
 * follow the user without carrying hooked levers along; its home pose is kept in
 * the tray's local space for the same reason.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {InteractableManipulation} from "SpectaclesInteractionKit.lspkg/Components/Interaction/InteractableManipulation/InteractableManipulation"

@component
export class LeverPlacement extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">LeverPlacement – grab, snap or return</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("LeverSocket: snap target pose. Leave empty for a lever with no socket yet.")
  @allowUndefined
  socket: SceneObject
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Box collider size in cm (lever is 12 x 2 x 1)")
  colliderSize: vec3 = new vec3(12, 2, 1)

  @input
  @hint("Release within this distance of the socket snaps the lever, in cm")
  @widget(new SliderWidget(1, 10, 0.5))
  snapRadiusCm: number = 4

  @input
  @hint("Seconds for the return-to-tray tween after a rejected release")
  @widget(new SliderWidget(0.1, 2, 0.05))
  returnDurationSec: number = 0.4

  @input
  @hint("Seconds for the snap-into-socket tween")
  @widget(new SliderWidget(0.05, 1, 0.05))
  snapDurationSec: number = 0.15
  @ui.group_end

  isLocked: boolean = false
  /** When false a release never snaps (lever B outside step 4): it always returns home. */
  snapEnabled: boolean = true
  grabCount: number = 0
  releaseCount: number = 0
  grabbed: boolean = false

  private manipulation: InteractableManipulation | null = null
  private homeParent: SceneObject | null = null
  private homeLocalPos = vec3.zero()
  private homeLocalRot = quat.quatIdentity()
  private homeRecorded = false

  private tweening = false
  private tweenElapsed = 0
  private tweenDuration = 0.3
  private fromPos = vec3.zero()
  private fromRot = quat.quatIdentity()
  private toPos = vec3.zero()
  private toRot = quat.quatIdentity()
  private lockOnArrive = false

  private _onPlaced = new Event<void>()
  private _onRejected = new Event<void>()
  onPlaced: PublicApi<void> = this._onPlaced.publicApi()
  onRejected: PublicApi<void> = this._onRejected.publicApi()

  getHomePosition(): vec3 {
    if (!this.homeParent) return this.homeLocalPos
    return this.homeParent.getTransform().getWorldTransform().multiplyPoint(this.homeLocalPos)
  }

  getHomeRotation(): quat {
    if (!this.homeParent) return this.homeLocalRot
    return this.homeParent.getTransform().getWorldRotation().multiply(this.homeLocalRot)
  }

  distanceToHome(): number {
    return this.sceneObject.getTransform().getWorldPosition().distance(this.getHomePosition())
  }

  /** Grabbed or mid-tween: a body-following tray must hold still. */
  isBusy(): boolean {
    return this.grabbed || this.tweening
  }

  distanceToSocket(): number {
    if (!this.socket) return Number.POSITIVE_INFINITY
    return this.sceneObject.getTransform().getWorldPosition().distance(this.socket.getTransform().getWorldPosition())
  }

  onAwake(): void {
    let collider = this.sceneObject.getComponent("Physics.ColliderComponent") as ColliderComponent | null
    if (!collider) {
      collider = this.sceneObject.createComponent("Physics.ColliderComponent") as ColliderComponent
      const shape = Shape.createBoxShape()
      shape.size = this.colliderSize
      collider.shape = shape
    }
    this.sceneObject.createComponent(Interactable.getTypeName()) as Interactable
    const manipulation = this.sceneObject.createComponent(
      InteractableManipulation.getTypeName()
    ) as InteractableManipulation
    this.manipulation = manipulation

    this.createEvent("OnStartEvent").bind(() => {
      this.recordHome()
      manipulation.onManipulationStart.add(() => {
        this.grabCount += 1
        this.grabbed = true
      })
      manipulation.onManipulationEnd.add(() => {
        this.releaseCount += 1
        this.grabbed = false
        this.onReleased()
      })
    })
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Remember the current pose as the tray pose (called once at start; Phase A authored it). */
  recordHome(): void {
    const tr = this.sceneObject.getTransform()
    this.homeParent = this.sceneObject.getParent()
    this.homeLocalPos = tr.getLocalPosition()
    this.homeLocalRot = tr.getLocalRotation()
    this.homeRecorded = true
  }

  /** Snap to the socket immediately, locked, without firing onPlaced (jumpToStep / Next). */
  placeInstant(): void {
    if (!this.socket) return
    const st = this.socket.getTransform()
    const tr = this.sceneObject.getTransform()
    tr.setWorldPosition(st.getWorldPosition())
    tr.setWorldRotation(st.getWorldRotation())
    this.tweening = false
    this.isLocked = true
    this.setManipulationEnabled(false)
    this.attachToSocketParent()
  }

  /** Let another controller (RimDrag) re-enable or disable grabbing while locked. */
  setManipulationActive(on: boolean): void {
    this.setManipulationEnabled(on)
  }

  getManipulation(): InteractableManipulation | null {
    return this.manipulation
  }

  /** Back / reset: unlock and return the lever to the tray. */
  returnHome(instant: boolean = false): void {
    this.isLocked = false
    this.grabbed = false
    if (this.homeParent && this.sceneObject.getParent() !== this.homeParent) {
      this.sceneObject.setParentPreserveWorldTransform(this.homeParent)
    }
    if (instant) {
      const tr = this.sceneObject.getTransform()
      tr.setLocalPosition(this.homeLocalPos)
      tr.setLocalRotation(this.homeLocalRot)
      this.tweening = false
      this.setManipulationEnabled(true)
      return
    }
    this.startTween(this.getHomePosition(), this.getHomeRotation(), this.returnDurationSec, false)
  }

  private onReleased(): void {
    // SIK fires onManipulationEnd several times per release; only the first one decides
    // (the snap / return tween is running for the rest), so a miss counts once.
    if (this.isLocked || this.tweening || !this.homeRecorded) return
    const d = this.distanceToSocket()
    if (this.socket && this.snapEnabled && d <= this.snapRadiusCm) {
      const st = this.socket.getTransform()
      this.startTween(st.getWorldPosition(), st.getWorldRotation(), this.snapDurationSec, true)
      print(`[LeverPlacement] ${this.sceneObject.name} snapped (${d.toFixed(1)} cm from socket)`)
    } else {
      this.startTween(this.getHomePosition(), this.getHomeRotation(), this.returnDurationSec, false)
      print(`[LeverPlacement] ${this.sceneObject.name} rejected (${d.toFixed(1)} cm from socket), returning to tray`)
      this._onRejected.invoke()
    }
  }

  private startTween(pos: vec3, rot: quat, duration: number, lock: boolean): void {
    const tr = this.sceneObject.getTransform()
    this.fromPos = tr.getWorldPosition()
    this.fromRot = tr.getWorldRotation()
    this.toPos = pos
    this.toRot = rot
    this.tweenDuration = Math.max(0.01, duration)
    this.tweenElapsed = 0
    this.lockOnArrive = lock
    this.tweening = true
    this.setManipulationEnabled(false)
  }

  private tick(): void {
    if (!this.tweening) return
    this.tweenElapsed += getDeltaTime()
    const t = Math.min(1, this.tweenElapsed / this.tweenDuration)
    const e = t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2
    const tr = this.sceneObject.getTransform()
    tr.setWorldPosition(vec3.lerp(this.fromPos, this.toPos, e))
    tr.setWorldRotation(quat.slerp(this.fromRot, this.toRot, e))
    if (t >= 1) {
      this.tweening = false
      if (this.lockOnArrive) {
        this.isLocked = true
        this.setManipulationEnabled(false)
        this.attachToSocketParent()
        this._onPlaced.invoke()
      } else {
        this.setManipulationEnabled(true)
      }
    }
  }

  /** Hooked levers belong to the wheel, not the (body-following) tray. */
  private attachToSocketParent(): void {
    const target = this.socket ? this.socket.getParent() : null
    if (target && this.sceneObject.getParent() !== target) this.sceneObject.setParentPreserveWorldTransform(target)
  }

  private setManipulationEnabled(on: boolean): void {
    if (!this.manipulation) return
    this.manipulation.enabled = on
    this.manipulation.setCanTranslate(on)
  }
}
