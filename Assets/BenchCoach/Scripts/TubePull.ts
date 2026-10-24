/**
 * TubePull — the tube-end grab on step 5. Adds a collider, Interactable and
 * InteractableManipulation to TubeEnd (this SceneObject). While armed, the pull
 * distance past the rim drives the tube out segment by segment, starting at the
 * tube end and working round to the valve (order PULL_ORDER): segment k-th in
 * order has progress clamp((d - k * segmentLagCm) / segmentRunCm). Once the tube
 * end is pullDistanceCm beyond the rim the staggered finish tweens every segment
 * the rest of the way out (down and toward the user), then lifts the Valve out
 * last and emits onPullComplete. restore() puts everything back (Back / reset).
 * Refit (step 8, pass 9): removeForRefit() takes the old tube away (segments off,
 * tube-end and valve visuals hidden); refit() brings the SAME TubeSeg_i back home
 * one by one from the valve round (REFIT_ORDER), valve first, then emits
 * onRefitComplete; refitInstant() / unrefit() are the Next / Back versions.
 * Owns: TubeSeg_i, TubeEnd and Valve positions (and the segments' enabled state)
 * during and after the pull and the refit.
 * Expects: @input wheel, tube (group holding TubeSeg_0..7), valve.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {InteractableManipulation} from "SpectaclesInteractionKit.lspkg/Components/Interaction/InteractableManipulation/InteractableManipulation"

/** TubeSeg indices in the order they leave the tire: from the tube end (6 o'clock) round to the valve. */
const PULL_ORDER = [4, 3, 5, 2, 6, 1, 7, 0]

/** TubeSeg indices in the order the new tube goes back in: from the valve (12 o'clock) round both ways. */
const REFIT_ORDER = [0, 7, 1, 6, 2, 5, 3, 4]

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
  @hint("Pull distance past the rim between one segment starting and the next, in cm")
  @widget(new SliderWidget(0, 5, 0.1))
  segmentLagCm: number = 1.5

  @input
  @hint("Pull distance over which one segment goes from in the tire to fully out, in cm")
  @widget(new SliderWidget(1, 20, 0.5))
  segmentRunCm: number = 6

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
  @hint("Refit: delay between consecutive segments going back in, in seconds")
  @widget(new SliderWidget(0, 0.5, 0.01))
  refitStaggerSec: number = 0.12

  @input
  @hint("Refit: per-segment slide-in length, in seconds")
  @widget(new SliderWidget(0.05, 1, 0.05))
  refitTweenSec: number = 0.3

  @input
  @hint("Refit: how far in front of the tire (wheel +Z) each segment starts its slide in, in cm")
  @widget(new SliderWidget(0, 15, 0.5))
  refitFromCm: number = 4

  @input
  @hint("Print pull progress to the log")
  debugLogs: boolean = false
  @ui.group_end

  armed: boolean = false
  pulled: boolean = false
  animating: boolean = false
  /** The old tube is gone (step 8 before the fit). */
  removed: boolean = false
  /** The new tube is sliding in. */
  refitting: boolean = false

  private manipulation: InteractableManipulation | null = null
  private interactable: Interactable | null = null
  private held = false
  private pinchTargetWanted = false
  private segments: SceneObject[] = []
  private segmentHomes: vec3[] = []
  private endHome = vec3.zero()
  private valveHome = vec3.zero()
  private homesRecorded = false
  private elapsed = 0
  /** Per segment (same order as `segments`): how far out it is, 0..1, from the hand-driven pull. */
  private progress: number[] = []
  /** Progress each segment had when the staggered finish started. */
  private finishFrom: number[] = []

  private refitElapsed = 0
  private valveRefitFrom = vec3.zero()

  private _onPullComplete = new Event<void>()
  onPullComplete: PublicApi<void> = this._onPullComplete.publicApi()
  private _onRefitComplete = new Event<void>()
  onRefitComplete: PublicApi<void> = this._onRefitComplete.publicApi()
  /** Step 4 only: the tube end was pinched before the peel finished (a mistake). */
  private _onEarlyPinch = new Event<void>()
  onEarlyPinch: PublicApi<void> = this._onEarlyPinch.publicApi()
  private earlyPinchWanted = false

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
    this.interactable = this.sceneObject.createComponent(Interactable.getTypeName()) as Interactable
    this.interactable.onTriggerEnd.add(() => {
      if (this.earlyPinchWanted && !this.armed && !this.pulled && !this.removed && !this.refitting) this._onEarlyPinch.invoke()
    })
    const manipulation = this.sceneObject.createComponent(
      InteractableManipulation.getTypeName()
    ) as InteractableManipulation
    manipulation.setCanRotate(false)
    manipulation.setCanScale(false)
    // No Z stretch: SIK clamps the stretch to the interactor's drag range, which
    // yanked the tube end (about 1 m away) ~57 cm toward the user on grab and
    // finished the pull before the hand moved. The pull is a drag past the rim.
    manipulation.enableStretchZ = false
    manipulation.onManipulationStart.add(() => {
      this.held = true
    })
    manipulation.onManipulationEnd.add(() => {
      this.held = false
      this.applyPinchTarget()
    })
    this.manipulation = manipulation
    this.setManipulationEnabled(false)
    this.setPinchTarget(false)

    this.createEvent("OnStartEvent").bind(() => this.recordHomes())
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** True while a hand holds the tube end. */
  isHeld(): boolean {
    return this.held
  }

  /**
   * Step 4: the pinch target is on (no grab) so a pinch on the tube end before
   * the peel can be caught as a mistake. Ignored once the pull is armed or done,
   * or while the old tube is out for the refit; off goes through setPinchTarget,
   * which waits for a held pinch to end.
   */
  setEarlyPinch(on: boolean): void {
    this.earlyPinchWanted = on
    if (this.armed || this.pulled || this.removed || this.refitting || this.animating) return
    this.setPinchTarget(on)
  }

  /** Step 5 entry: let the user grab the tube end. */
  arm(): void {
    if (this.pulled || this.animating) return
    this.recordHomes()
    this.armed = true
    this.setManipulationEnabled(true)
    this.setPinchTarget(true)
  }

  /** Leaving step 5 after the pull: grabbing stops, but the pinch target stays (see setPinchTarget). */
  disarm(): void {
    this.armed = false
    this.setManipulationEnabled(false)
  }

  /** Back / reset: tube, tube end and valve back in the tire. */
  restore(): void {
    this.armed = false
    this.refitting = false
    this.removed = false
    this.animating = false
    this.pulled = false
    this.setManipulationEnabled(false)
    this.setPinchTarget(false)
    this.showTube()
    if (!this.homesRecorded) return
    for (let i = 0; i < this.segments.length; i++) {
      this.segments[i].getTransform().setLocalPosition(this.segmentHomes[i])
      this.progress[i] = 0
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
    this.setPinchTarget(true)
    for (let i = 0; i < this.segments.length; i++) {
      this.segments[i].getTransform().setLocalPosition(this.segmentHomes[i].add(this.segmentOffset()))
      this.progress[i] = 1
    }
    this.sceneObject.getTransform().setLocalPosition(this.endHome.add(new vec3(0, -(this.pullDistanceCm + 2), 0)))
    if (this.valve) this.valve.getTransform().setLocalPosition(this.valveHome.add(new vec3(0, this.valveLiftCm, 0)))
    this.pulled = true
  }

  // ── Refit (pass 9) ─────────────────────────────────────────────────────────
  /** Step 8 entry: the old tube goes in the bin. Segments off, tube-end and valve visuals hidden. */
  removeForRefit(): void {
    this.recordHomes()
    this.refitting = false
    this.removed = true
    this.armed = false
    this.setManipulationEnabled(false)
    this.setPinchTarget(false)
    for (const seg of this.segments) if (seg.enabled) seg.enabled = false
    this.setVisual(this.sceneObject, false)
    if (this.valve) this.setVisual(this.valve, false)
  }

  /** The new tube is in at the valve: valve home first, then the same TubeSeg_i slide back in, staggered. */
  refit(): void {
    this.recordHomes()
    this.removed = false
    this.refitting = true
    this.refitElapsed = 0
    this.animating = false
    this.pulled = false
    if (this.valve) {
      this.valveRefitFrom = this.valve.getTransform().getLocalPosition()
      this.setVisual(this.valve, true)
    }
    this.sceneObject.getTransform().setLocalPosition(this.endHome)
    for (const seg of this.segments) if (seg.enabled) seg.enabled = false
    this.log("refit started")
  }

  /** Jump to the refitted tube (Next / jumpToStep): everything home, visible, no events. */
  refitInstant(): void {
    this.recordHomes()
    this.removed = false
    this.refitting = false
    this.animating = false
    this.pulled = false
    this.armed = false
    this.setManipulationEnabled(false)
    this.setPinchTarget(false)
    for (let i = 0; i < this.segments.length; i++) {
      this.segments[i].getTransform().setLocalPosition(this.segmentHomes[i])
      this.progress[i] = 0
    }
    this.sceneObject.getTransform().setLocalPosition(this.endHome)
    if (this.valve) this.valve.getTransform().setLocalPosition(this.valveHome)
    this.showTube()
  }

  /** Back from step 8: the old tube is out again, hanging where the pull left it (as jumpToStep(7)). */
  unrefit(): void {
    this.removed = false
    this.refitting = false
    this.completeInstant()
    this.showTube()
  }

  /** Largest distance of a TubeSeg_i from its home, in local cm. For tests. */
  segmentHomeError(): number {
    let worst = 0
    for (let i = 0; i < this.segments.length; i++) {
      worst = Math.max(worst, this.segments[i].getTransform().getLocalPosition().distance(this.segmentHomes[i]))
    }
    return worst
  }

  /** Distance of the valve from its home, in local cm. For tests. */
  valveHomeError(): number {
    if (!this.valve) return 0
    return this.valve.getTransform().getLocalPosition().distance(this.valveHome)
  }

  /** Enabled TubeSeg_i count. For tests. */
  enabledSegmentCount(): number {
    let n = 0
    for (const seg of this.segments) if (seg.enabled) n++
    return n
  }

  private showTube(): void {
    for (const seg of this.segments) if (!seg.enabled) seg.enabled = true
    this.setVisual(this.sceneObject, true)
    if (this.valve) this.setVisual(this.valve, true)
  }

  private setVisual(so: SceneObject, on: boolean): void {
    const rmv = so.getComponent("Component.RenderMeshVisual") as RenderMeshVisual | null
    if (rmv && rmv.enabled !== on) rmv.enabled = on
  }

  private animateRefit(): void {
    this.refitElapsed += getDeltaTime()
    const vt = Math.max(0, Math.min(1, this.refitElapsed / Math.max(0.01, this.valveTweenSec)))
    if (this.valve) this.valve.getTransform().setLocalPosition(vec3.lerp(this.valveRefitFrom, this.valveHome, this.ease(vt)))
    const segStart = this.valveTweenSec
    const from = new vec3(0, 0, this.refitFromCm)
    let last = 0
    for (let i = 0; i < this.segments.length; i++) {
      const n = parseInt(this.segments[i].name.substring("TubeSeg_".length))
      const k = REFIT_ORDER.indexOf(n) >= 0 ? REFIT_ORDER.indexOf(n) : i
      const t0 = segStart + k * this.refitStaggerSec
      last = Math.max(last, t0 + this.refitTweenSec)
      if (this.refitElapsed < t0) continue
      if (!this.segments[i].enabled) this.segments[i].enabled = true
      const t = Math.min(1, (this.refitElapsed - t0) / Math.max(0.01, this.refitTweenSec))
      this.segments[i].getTransform().setLocalPosition(this.segmentHomes[i].add(from.uniformScale(1 - this.ease(t))))
      this.progress[i] = 0
    }
    if (this.refitElapsed >= last && vt >= 1) {
      this.refitInstant()
      this.log("refit complete")
      this._onRefitComplete.invoke()
    }
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
        this.progress.push(0)
      }
    }
    this.endHome = this.sceneObject.getTransform().getLocalPosition()
    if (this.valve) this.valveHome = this.valve.getTransform().getLocalPosition()
    this.homesRecorded = true
  }

  private tick(): void {
    if (this.refitting) {
      this.animateRefit()
      return
    }
    if (this.animating) {
      this.animate()
      return
    }
    if (!this.armed || this.pulled || !this.wheel) return
    const tubeScale = this.tube ? this.tube.getTransform().getWorldScale().x : 1
    const pastRim = this.distanceFromCenter() - this.rimRadiusCm * tubeScale
    if (pastRim >= this.pullDistanceCm) {
      this.startPull()
      return
    }
    this.followPull(pastRim)
  }

  /** Index (0..7) of a segment in PULL_ORDER, from its TubeSeg_<n> name. */
  private orderOf(i: number): number {
    const n = parseInt(this.segments[i].name.substring("TubeSeg_".length))
    const k = PULL_ORDER.indexOf(n)
    return k >= 0 ? k : i
  }

  /** Before the threshold, each segment slides out in turn as the tube end is pulled. */
  private followPull(pastRim: number): void {
    const offset = this.segmentOffset()
    for (let i = 0; i < this.segments.length; i++) {
      const p = Math.max(0, Math.min(1, (pastRim - this.orderOf(i) * this.segmentLagCm) / Math.max(0.01, this.segmentRunCm)))
      this.progress[i] = p
      this.segments[i].getTransform().setLocalPosition(this.segmentHomes[i].add(offset.uniformScale(p)))
    }
  }

  /** Progress of segment i, 0 (in the tire) .. 1 (out). For tests. */
  getSegmentProgress(i: number): number {
    return this.progress[i] !== undefined ? this.progress[i] : 0
  }

  private startPull(): void {
    this.armed = false
    this.setManipulationEnabled(false)
    this.animating = true
    this.elapsed = 0
    this.finishFrom = this.progress.slice()
    this.log(`pull started at ${this.distanceFromCenter().toFixed(1)} cm from the hub`)
  }

  private animate(): void {
    this.elapsed += getDeltaTime()
    const offset = this.segmentOffset()
    const n = this.segments.length
    for (let i = 0; i < n; i++) {
      // Staggered in pull order; each segment finishes from wherever the hand left it.
      const t = Math.max(0, Math.min(1, (this.elapsed - this.orderOf(i) * this.staggerSec) / Math.max(0.01, this.tweenSec)))
      const from = this.finishFrom[i] !== undefined ? this.finishFrom[i] : 0
      const p = from + (1 - from) * this.ease(t)
      this.progress[i] = p
      this.segments[i].getTransform().setLocalPosition(this.segmentHomes[i].add(offset.uniformScale(p)))
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

  /**
   * The pinch target is off until step 5: a live 7 cm box at 6 o'clock would
   * swallow pinches on Bead_4 in step 2. It stays on from the pull onward
   * (the pulled end hangs clear of everything) and goes off again only on
   * restore. Turning the Interactable off under a hand that is still pinching
   * strands that pinch, so a disable waits for the release.
   */
  private setPinchTarget(on: boolean): void {
    this.pinchTargetWanted = on
    this.applyPinchTarget()
  }

  private applyPinchTarget(): void {
    if (!this.interactable) return
    if (!this.pinchTargetWanted && this.held) return
    this.interactable.enabled = this.pinchTargetWanted
  }

  private log(msg: string): void {
    if (this.debugLogs) print(`[TubePull] ${msg}`)
  }
}
