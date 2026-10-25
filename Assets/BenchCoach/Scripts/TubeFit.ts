/**
 * TubeFit — the grab handle on the new tube (ToolTray/NewTube/NewTubeEnd, the
 * valve end of the coiled tube). Same pattern as LeverPlacement: adds a box
 * collider, Interactable and InteractableManipulation at runtime; on release
 * within snapRadiusCm of the socket (Wheel/ValveSocket, the valve hole at 12
 * o'clock) it tweens onto the socket and fires onFitted, otherwise it tweens back
 * to the coil and fires onRejected.
 * Owns: NewTubeEnd's own transform while armed. Must not: move the tube
 * segments or change steps — RefitSteps hides the coil and asks TubePull to refit.
 * Expects: @input socket. RefitSteps arms it on step 8 only (setArmed).
 * Z stretch is off: SIK clamps the stretch to the interactor's drag range, which
 * can yank a far grab toward the user (the pass 7a tube-end finding).
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {InteractableManipulation} from "SpectaclesInteractionKit.lspkg/Components/Interaction/InteractableManipulation/InteractableManipulation"

@component
export class TubeFit extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">TubeFit – feed the new tube in at the valve</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("ValveSocket: where the valve end of the new tube goes (the valve hole at 12 o'clock)")
  socket: SceneObject
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Grab box size in cm (generous: the stem itself is under 1 cm wide)")
  colliderSize: vec3 = new vec3(3, 4, 3)

  @input
  @hint("Release within this distance of the socket fits the tube, in cm")
  @widget(new SliderWidget(1, 10, 0.5))
  snapRadiusCm: number = 5

  @input
  @hint("Seconds for the return-to-coil tween after a miss")
  @widget(new SliderWidget(0.1, 2, 0.05))
  returnDurationSec: number = 0.4

  @input
  @hint("Seconds for the snap-into-socket tween")
  @widget(new SliderWidget(0.05, 1, 0.05))
  snapDurationSec: number = 0.15
  @ui.group_end

  armed: boolean = false
  grabbed: boolean = false
  fitted: boolean = false
  grabCount: number = 0

  private manipulation: InteractableManipulation | null = null
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
  private fitOnArrive = false

  private _onFitted = new Event<void>()
  private _onRejected = new Event<void>()
  onFitted: PublicApi<void> = this._onFitted.publicApi()
  onRejected: PublicApi<void> = this._onRejected.publicApi()

  onAwake(): void {
    let collider = this.sceneObject.getComponent("Physics.ColliderComponent") as ColliderComponent | null
    if (!collider) {
      collider = this.sceneObject.createComponent("Physics.ColliderComponent") as ColliderComponent
      const shape = Shape.createBoxShape()
      shape.size = this.colliderSize
      collider.shape = shape
    }
    this.sceneObject.createComponent(Interactable.getTypeName())
    const manipulation = this.sceneObject.createComponent(
      InteractableManipulation.getTypeName()
    ) as InteractableManipulation
    manipulation.setCanRotate(false)
    manipulation.setCanScale(false)
    manipulation.enableStretchZ = false
    this.manipulation = manipulation
    this.recordHome()
    this.applyManipulation()

    this.createEvent("OnStartEvent").bind(() => {
      manipulation.onManipulationStart.add(() => {
        this.grabCount += 1
        this.grabbed = true
      })
      manipulation.onManipulationEnd.add(() => {
        this.grabbed = false
        this.onReleased()
      })
    })
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Step 8 (before the fit) only. Disarming never touches the Interactable, so a held pinch is not stranded. */
  setArmed(on: boolean): void {
    this.armed = on
    this.applyManipulation()
  }

  /** Grabbed or mid-tween: the body-following tray must hold still. */
  isBusy(): boolean {
    return this.grabbed || this.tweening
  }

  distanceToSocket(): number {
    if (!this.socket) return Number.POSITIVE_INFINITY
    return this.sceneObject.getTransform().getWorldPosition().distance(this.socket.getTransform().getWorldPosition())
  }

  getHomePosition(): vec3 {
    const parent = this.sceneObject.getParent()
    if (!parent) return this.homeLocalPos
    return parent.getTransform().getWorldTransform().multiplyPoint(this.homeLocalPos)
  }

  distanceToHome(): number {
    return this.sceneObject.getTransform().getWorldPosition().distance(this.getHomePosition())
  }

  /** Jump onto the socket without the tween or onFitted (tests, demo). */
  fitInstant(): void {
    if (!this.socket) return
    const st = this.socket.getTransform()
    const tr = this.sceneObject.getTransform()
    tr.setWorldPosition(st.getWorldPosition())
    tr.setWorldRotation(st.getWorldRotation())
    this.tweening = false
    this.fitted = true
    this.applyManipulation()
  }

  /** Watch mode: fly the end onto the socket over `sec` seconds; onFitted fires on arrival. */
  playFit(sec: number): void {
    if (!this.socket || this.fitted || this.tweening || this.grabbed) return
    const st = this.socket.getTransform()
    this.startTween(st.getWorldPosition(), st.getWorldRotation(), sec, true)
  }

  /** Back to the coil (after a fit the coil is hidden; Back shows it again with the end in place). */
  returnHome(instant: boolean = false): void {
    this.fitted = false
    this.grabbed = false
    if (instant || !this.homeRecorded) {
      const tr = this.sceneObject.getTransform()
      tr.setLocalPosition(this.homeLocalPos)
      tr.setLocalRotation(this.homeLocalRot)
      this.tweening = false
      this.applyManipulation()
      return
    }
    this.startTween(this.getHomePosition(), this.homeWorldRotation(), this.returnDurationSec, false)
  }

  private recordHome(): void {
    const tr = this.sceneObject.getTransform()
    this.homeLocalPos = tr.getLocalPosition()
    this.homeLocalRot = tr.getLocalRotation()
    this.homeRecorded = true
  }

  private homeWorldRotation(): quat {
    const parent = this.sceneObject.getParent()
    return parent ? parent.getTransform().getWorldRotation().multiply(this.homeLocalRot) : this.homeLocalRot
  }

  private onReleased(): void {
    if (!this.armed || this.fitted || this.tweening) return
    const d = this.distanceToSocket()
    if (this.socket && d <= this.snapRadiusCm) {
      const st = this.socket.getTransform()
      this.startTween(st.getWorldPosition(), st.getWorldRotation(), this.snapDurationSec, true)
      print(`[TubeFit] fitted (${d.toFixed(1)} cm from the valve socket)`)
    } else {
      this.startTween(this.getHomePosition(), this.homeWorldRotation(), this.returnDurationSec, false)
      print(`[TubeFit] missed (${d.toFixed(1)} cm from the valve socket), back to the coil`)
      this._onRejected.invoke()
    }
  }

  private startTween(pos: vec3, rot: quat, duration: number, fit: boolean): void {
    const tr = this.sceneObject.getTransform()
    this.fromPos = tr.getWorldPosition()
    this.fromRot = tr.getWorldRotation()
    this.toPos = pos
    this.toRot = rot
    this.tweenDuration = Math.max(0.01, duration)
    this.tweenElapsed = 0
    this.fitOnArrive = fit
    this.tweening = true
    this.applyManipulation()
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
      if (this.fitOnArrive) {
        this.fitted = true
        this.applyManipulation()
        this._onFitted.invoke()
      } else {
        this.applyManipulation()
      }
    }
  }

  private applyManipulation(): void {
    if (!this.manipulation) return
    const on = this.armed && !this.fitted && !this.tweening
    this.manipulation.enabled = on
    this.manipulation.setCanTranslate(on)
  }
}
