/**
 * TubePull — the tube-end grab on step 5. Adds a collider, Interactable and
 * InteractableManipulation to TubeEnd (this SceneObject). While armed, once the
 * tube end is pullDistanceCm beyond the rim it tweens every TubeSeg_i out of the
 * tire (down and toward the user, staggered), then lifts the Valve out last and
 * emits onPullComplete. restore() puts everything back (Back / reset).
 * Owns: TubeSeg_i, TubeEnd and Valve positions during and after the pull.
 * Expects: @input wheel, tube (group holding TubeSeg_0..7), valve.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {InteractableManipulation} from "SpectaclesInteractionKit.lspkg/Components/Interaction/InteractableManipulation/InteractableManipulation"

@component
export class TubePull extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">TubePull – pull the tube out of the tire</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Wheel root (its center is the pull-distance origin)")
  wheel: SceneObject

  @input
  @hint("Tube group holding TubeSeg_0..7")
  tube: SceneObject

  @input
  @hint("Valve stem (lifts out last)")
  valve: SceneObject
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Grab box on the tube end, in world cm")
  colliderSizeCm: vec3 = new vec3(7, 7, 7)

  @input
  @hint("How far beyond the rim the tube end must be pulled, in cm")
  @widget(new SliderWidget(5, 40, 0.5))
  pullDistanceCm: number = 15

  @input
  @hint("Tube major radius in cm (matches the TubeSeg_i TorusArc). Literal: @input defaults cannot reference imported constants.")
  @widget(new SliderWidget(10, 60, 0.1))
  rimRadiusCm: number = 33.4

  @input
  @hint("How far each segment drops (wheel -Y) when the tube comes out, in cm")
  @widget(new SliderWidget(5, 40, 0.5))
  segmentDropCm: number = 22

  @input
  @hint("How far each segment moves toward the user (wheel +Z), in cm")
  @widget(new SliderWidget(0, 30, 0.5))
  segmentOutCm: number = 10

  @input
  @hint("Delay between consecutive segments, in seconds")
  @widget(new SliderWidget(0, 0.5, 0.01))
  staggerSec: number = 0.1

  @input
  @hint("Per-segment tween length, in seconds")
  @widget(new SliderWidget(0.1, 2, 0.05))
  tweenSec: number = 0.5

  @input
  @hint("Valve lift after the tube is out, in cm (wheel +Y)")
  @widget(new SliderWidget(0, 20, 0.5))
  valveLiftCm: number = 6

  @input
  @hint("Valve lift tween length, in seconds")
  @widget(new SliderWidget(0.1, 2, 0.05))
  valveTweenSec: number = 0.4

  @input
  @hint("Print pull progress to the log")
  debugLogs: boolean = false
  @ui.group_end

  armed: boolean = false
  pulled: boolean = false
  animating: boolean = false

  private manipulation: InteractableManipulation | null = null
  private segments: SceneObject[] = []
  private segmentHomes: vec3[] = []
  private endHome = vec3.zero()
  private valveHome = vec3.zero()
  private homesRecorded = false
  private elapsed = 0

  private _onPullComplete = new Event<void>()
  onPullComplete: PublicApi<void> = this._onPullComplete.publicApi()

  onAwake(): void {
    const scale = this.sceneObject.getTransform().getLocalScale()
    let collider = this.sceneObject.getComponent("Physics.ColliderComponent") as ColliderComponent | null
    if (!collider) {
      collider = this.sceneObject.createComponent("Physics.ColliderComponent") as ColliderComponent
      const shape = Shape.createBoxShape()
      shape.size = new vec3(
        this.colliderSizeCm.x / Math.max(0.01, scale.x),
        this.colliderSizeCm.y / Math.max(0.01, scale.y),
        this.colliderSizeCm.z / Math.max(0.01, scale.z)
      )
      collider.shape = shape
    }
    this.sceneObject.createComponent(Interactable.getTypeName()) as Interactable
    const manipulation = this.sceneObject.createComponent(
      InteractableManipulation.getTypeName()
    ) as InteractableManipulation
    manipulation.setCanRotate(false)
    manipulation.setCanScale(false)
    this.manipulation = manipulation
    this.setManipulationEnabled(false)

    this.createEvent("OnStartEvent").bind(() => this.recordHomes())
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Step 5 entry: let the user grab the tube end. */
  arm(): void {
    if (this.pulled || this.animating) return
    this.recordHomes()
    this.armed = true
    this.setManipulationEnabled(true)
  }

  disarm(): void {
    this.armed = false
    this.setManipulationEnabled(false)
  }

  /** Back / reset: tube, tube end and valve back in the tire. */
  restore(): void {
    this.armed = false
    this.animating = false
    this.pulled = false
    this.setManipulationEnabled(false)
    if (!this.homesRecorded) return
    for (let i = 0; i < this.segments.length; i++) {
      this.segments[i].getTransform().setLocalPosition(this.segmentHomes[i])
    }
    this.sceneObject.getTransform().setLocalPosition(this.endHome)
    if (this.valve) this.valve.getTransform().setLocalPosition(this.valveHome)
  }

  /** Jump to the pulled state without animating or emitting (jumpToStep / Next). */
  completeInstant(): void {
    this.recordHomes()
    this.armed = false
    this.animating = false
    this.setManipulationEnabled(false)
    for (let i = 0; i < this.segments.length; i++) {
      this.segments[i].getTransform().setLocalPosition(this.segmentHomes[i].add(this.segmentOffset()))
    }
    this.sceneObject.getTransform().setLocalPosition(this.endHome.add(new vec3(0, -(this.pullDistanceCm + 2), 0)))
    if (this.valve) this.valve.getTransform().setLocalPosition(this.valveHome.add(new vec3(0, this.valveLiftCm, 0)))
    this.pulled = true
  }

  /** Distance of the tube end from the wheel center, in world cm. */
  distanceFromCenter(): number {
    if (!this.wheel) return 0
    return this.sceneObject.getTransform().getWorldPosition().distance(this.wheel.getTransform().getWorldPosition())
  }

  private recordHomes(): void {
    if (this.homesRecorded) return
    if (!this.tube) {
      print("[TubePull] ERROR: tube not assigned")
      return
    }
    this.segments = []
    this.segmentHomes = []
    const n = this.tube.getChildrenCount()
    for (let c = 0; c < n; c++) {
      const child = this.tube.getChild(c)
      if (child.name.indexOf("TubeSeg_") === 0) {
        this.segments.push(child)
        this.segmentHomes.push(child.getTransform().getLocalPosition())
      }
    }
    this.endHome = this.sceneObject.getTransform().getLocalPosition()
    if (this.valve) this.valveHome = this.valve.getTransform().getLocalPosition()
    this.homesRecorded = true
  }

  private tick(): void {
    if (this.animating) {
      this.animate()
      return
    }
    if (!this.armed || this.pulled || !this.wheel) return
    const tubeScale = this.tube ? this.tube.getTransform().getWorldScale().x : 1
    const threshold = this.rimRadiusCm * tubeScale + this.pullDistanceCm
    if (this.distanceFromCenter() >= threshold) this.startPull()
  }

  private startPull(): void {
    this.armed = false
    this.setManipulationEnabled(false)
    this.animating = true
    this.elapsed = 0
    this.log(`pull started at ${this.distanceFromCenter().toFixed(1)} cm from the hub`)
  }

  private animate(): void {
    this.elapsed += getDeltaTime()
    const offset = this.segmentOffset()
    const n = this.segments.length
    for (let i = 0; i < n; i++) {
      const t = Math.max(0, Math.min(1, (this.elapsed - i * this.staggerSec) / Math.max(0.01, this.tweenSec)))
      this.segments[i].getTransform().setLocalPosition(this.segmentHomes[i].add(offset.uniformScale(this.ease(t))))
    }
    const segmentsDone = Math.max(0, n - 1) * this.staggerSec + this.tweenSec
    const vt = Math.max(0, Math.min(1, (this.elapsed - segmentsDone) / Math.max(0.01, this.valveTweenSec)))
    if (this.valve) {
      this.valve.getTransform().setLocalPosition(this.valveHome.add(new vec3(0, this.valveLiftCm * this.ease(vt), 0)))
    }
    if (vt >= 1) {
      this.animating = false
      this.pulled = true
      this.log("tube out, valve lifted")
      this._onPullComplete.invoke()
    }
  }

  private segmentOffset(): vec3 {
    return new vec3(0, -this.segmentDropCm, this.segmentOutCm)
  }

  private ease(t: number): number {
    return t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2
  }

  private setManipulationEnabled(on: boolean): void {
    if (!this.manipulation) return
    this.manipulation.enabled = on
    this.manipulation.setCanTranslate(on)
  }

  private log(msg: string): void {
    if (this.debugLogs) print(`[TubePull] ${msg}`)
  }
}
