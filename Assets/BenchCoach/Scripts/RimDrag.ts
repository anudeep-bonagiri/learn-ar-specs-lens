/**
 * RimDrag — slides the hooked second lever along the rim. While armed it
 * constrains the lever (this SceneObject) to the rim circle in the wheel plane
 * every LateUpdate, keeps it radial / tangent-aligned, computes the clockwise
 * angle, and emits onSegmentPassed(i) as the lever reaches Bead_i's start angle
 * (i * segmentSweepDeg). At peelEndAngleDeg it locks the lever and emits
 * onPeelComplete.
 * Owns: the lever's pose while armed. Must not: move beads — RepairManager does.
 * Expects: a LeverPlacement on the same SceneObject; @input wheel.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {LeverPlacement} from "./LeverPlacement"

@component
export class RimDrag extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">RimDrag – slide the hooked lever along the rim</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Wheel root: the drag circle lies in its local XY plane")
  wheel: SceneObject
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Absolute clockwise angle (deg from 12 o'clock) where the peel completes; 150 = 5 o'clock. Literal: @input defaults cannot reference imported constants.")
  @widget(new SliderWidget(45, 180, 1))
  peelEndAngleDeg: number = 150

  @input
  @hint("Sweep of each bead segment in degrees (Bead_i starts at i * sweep)")
  @widget(new SliderWidget(10, 90, 1))
  segmentSweepDeg: number = 45

  @input
  @hint("Degrees of slack before a segment or the end counts as reached")
  @widget(new SliderWidget(0, 10, 0.5))
  slackDeg: number = 2

  @input
  @hint("Print drag progress to the log")
  debugLogs: boolean = false
  @ui.group_end

  armed: boolean = false
  complete: boolean = false
  /** Watch mode: the lever is being slid round by playSweep(), not by a hand. */
  sweeping: boolean = false
  currentAngleDeg: number = 0
  sweptDeg: number = 0

  private placement: LeverPlacement | null = null
  private socketAngleDeg = 0
  private radiusCm = 36.4
  private socketLocalZ = 0
  private baseRot = quat.quatIdentity()
  private passed: number[] = []
  private sweepElapsed = 0
  private sweepSec = 4
  private sweepFromDeg = 0

  private _onSegmentPassed = new Event<number>()
  private _onPeelComplete = new Event<void>()
  onSegmentPassed: PublicApi<number> = this._onSegmentPassed.publicApi()
  onPeelComplete: PublicApi<void> = this._onPeelComplete.publicApi()

  onAwake(): void {
    this.placement = this.sceneObject.getComponent(LeverPlacement.getTypeName()) as LeverPlacement | null
    if (!this.placement) print("[RimDrag] ERROR: LeverPlacement missing on " + this.sceneObject.name)
    this.createEvent("LateUpdateEvent").bind(() => this.tick())
  }

  /** Start the rim drag from `socket` (already snapped there). */
  arm(socket: SceneObject, socketAngleDeg: number): void {
    if (!this.wheel || !this.placement) return
    const wheelInv = this.wheel.getTransform().getInvertedWorldTransform()
    const local = wheelInv.multiplyPoint(socket.getTransform().getWorldPosition())
    this.radiusCm = Math.sqrt(local.x * local.x + local.y * local.y)
    this.socketLocalZ = local.z
    this.socketAngleDeg = socketAngleDeg
    this.baseRot = socket.getTransform().getWorldRotation()
    this.currentAngleDeg = socketAngleDeg
    this.sweptDeg = 0
    this.passed = []
    this.complete = false
    this.sweeping = false
    this.armed = true
    const m = this.placement.getManipulation()
    if (m) {
      m.setCanRotate(false)
      m.setCanScale(false)
    }
    this.placement.setManipulationActive(true)
    this.log(`armed at ${socketAngleDeg.toFixed(1)} deg, radius ${this.radiusCm.toFixed(1)} cm`)
  }

  /**
   * Stop constraining; the caller decides where the lever goes next. Only an
   * armed drag owns the lever's manipulation — an idle lever in the tray stays grabbable.
   */
  disarm(): void {
    const wasArmed = this.armed
    this.armed = false
    this.sweeping = false
    if (wasArmed && this.placement) this.placement.setManipulationActive(false)
    this.releaseManipulation()
  }

  /** Give rotate and scale back so the lever grabs normally again from the tray (Back / Try again). */
  private releaseManipulation(): void {
    const m = this.placement ? this.placement.getManipulation() : null
    if (m) {
      m.setCanRotate(true)
      m.setCanScale(true)
    }
  }

  /** Jump straight to the completed pose without emitting events (jumpToStep / Next). */
  completeInstant(socket: SceneObject, socketAngleDeg: number): void {
    this.arm(socket, socketAngleDeg)
    this.applyPose(this.peelEndAngleDeg)
    this.currentAngleDeg = this.peelEndAngleDeg
    this.sweptDeg = this.peelEndAngleDeg - socketAngleDeg
    this.passed = this.segmentsUpTo(this.peelEndAngleDeg + this.slackDeg)
    this.complete = true
    this.armed = false
    this.sweeping = false
    this.placement.setManipulationActive(false)
    this.releaseManipulation()
  }

  /**
   * Watch mode: slide the armed lever from where it is to peelEndAngleDeg over `sec`
   * seconds. The pose is set each frame before the normal drag check, so the usual
   * onSegmentPassed / onPeelComplete events fire exactly as for a hand drag.
   */
  playSweep(sec: number): boolean {
    if (!this.armed || this.complete) return false
    this.sweepElapsed = 0
    this.sweepFromDeg = this.currentAngleDeg
    this.sweepSec = Math.max(0.2, sec)
    this.sweeping = true
    return true
  }

  /** Stop a playSweep where it is (the lever stays armed for the hand). */
  stopSweep(): void {
    this.sweeping = false
  }

  getPassedSegments(): number[] {
    return this.passed.slice()
  }

  private tick(): void {
    if (!this.armed || this.complete || !this.wheel) return
    if (this.sweeping) {
      this.sweepElapsed += getDeltaTime()
      const t = Math.min(1, this.sweepElapsed / this.sweepSec)
      const e = t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2
      this.applyPose(this.sweepFromDeg + (this.peelEndAngleDeg - this.sweepFromDeg) * e)
    }
    const tr = this.sceneObject.getTransform()
    const local = this.wheel.getTransform().getInvertedWorldTransform().multiplyPoint(tr.getWorldPosition())
    let angle = (Math.atan2(local.x, local.y) * 180) / Math.PI
    if (angle < 0) angle += 360
    // Relative to the socket, in (-180, 180]; the lever cannot go behind its socket.
    let rel = angle - this.socketAngleDeg
    while (rel > 180) rel -= 360
    while (rel <= -180) rel += 360
    rel = Math.max(0, Math.min(this.peelEndAngleDeg - this.socketAngleDeg, rel))
    const abs = this.socketAngleDeg + rel
    this.currentAngleDeg = abs
    this.sweptDeg = Math.max(this.sweptDeg, rel)

    for (const i of this.segmentsUpTo(abs + this.slackDeg)) {
      if (this.passed.indexOf(i) < 0) {
        this.passed.push(i)
        this.log(`passed Bead_${i} at ${abs.toFixed(1)} deg`)
        this._onSegmentPassed.invoke(i)
      }
    }

    if (abs >= this.peelEndAngleDeg - this.slackDeg) {
      this.log(`complete trigger: raw angle ${angle.toFixed(1)}, local (${local.x.toFixed(1)}, ${local.y.toFixed(1)}, ${local.z.toFixed(1)})`)
      this.applyPose(this.peelEndAngleDeg)
      this.currentAngleDeg = this.peelEndAngleDeg
      this.complete = true
      this.armed = false
      this.sweeping = false
      if (this.placement) this.placement.setManipulationActive(false)
      this.log("peel complete")
      this._onPeelComplete.invoke()
      return
    }
    this.applyPose(abs)
  }

  /** Bead indices (>= 1) whose start angle lies between the socket and `angleDeg`. */
  private segmentsUpTo(angleDeg: number): number[] {
    const out: number[] = []
    const maxIndex = Math.floor(360 / this.segmentSweepDeg)
    for (let i = 1; i < maxIndex; i++) {
      const start = i * this.segmentSweepDeg
      if (start > this.socketAngleDeg && start <= angleDeg && start <= this.peelEndAngleDeg + this.slackDeg) out.push(i)
    }
    return out
  }

  private applyPose(angleDeg: number): void {
    const a = (angleDeg * Math.PI) / 180
    const wheelTr = this.wheel.getTransform()
    const local = new vec3(Math.sin(a) * this.radiusCm, Math.cos(a) * this.radiusCm, this.socketLocalZ)
    const world = wheelTr.getWorldTransform().multiplyPoint(local)
    const axis = wheelTr.getWorldRotation().multiplyVec3(new vec3(0, 0, 1))
    const turn = quat.angleAxis((-(angleDeg - this.socketAngleDeg) * Math.PI) / 180, axis)
    const tr = this.sceneObject.getTransform()
    tr.setWorldPosition(world)
    tr.setWorldRotation(turn.multiply(this.baseRot))
  }

  private log(msg: string): void {
    if (this.debugLogs) print(`[RimDrag] ${msg}`)
  }
}
