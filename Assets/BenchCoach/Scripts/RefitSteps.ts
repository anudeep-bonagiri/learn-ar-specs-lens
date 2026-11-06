/**
 * RefitSteps — the StepModule for the second half of the repair (steps 8..10).
 * RepairManager stays the only step machine: it calls apply() on every step
 * change, delegates complete / undo / markerAnchor for steps 8..10 here, and
 * advances when onStepComplete fires.
 *  8 Fit the new tube: entry tweens both levers home to the tray, takes the old
 *    tube away and shows NewTube; TubeFit.onFitted hides the coil and asks
 *    TubePull to refit the same TubeSeg_i; the refit finishing completes 8.
 *  9 Seat the bead: each pinch on Bead_0..3 sets its offset back to 0; the rest
 *    stay highlighted; all four complete 9.
 * 10 Inflate: hold the valve; hold time grows Tire and Tube from deflateScale to
 *    1 over inflateHoldSec with the pump loop playing; full completes 10.
 * The step-8 model change lives in apply(8) / undo(8), not in step 7, so
 * jumpToStep(7) still has the levers on the wheel and the old tube hanging out.
 * Owns: entered / fitted / seated / inflate state and the parts it moves.
 * Must not: change steps itself or author UI.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {SEAT_BEADS, SOCKET_B_ANGLE_DEG, STEPS, StepModule} from "./StepDefinitions"
import {beadMidDeg, findBead, setBeadOffset} from "./WheelMath"
import {LeverPlacement} from "./LeverPlacement"
import {RimDrag} from "./RimDrag"
import {TubePull} from "./TubePull"
import {TubeFit} from "./TubeFit"
import {WheelTargets} from "./WheelTargets"
import {Highlighter} from "./Highlighter"
import {BenchCoachAudio} from "./BenchCoachAudio"
import {CoachFeedback} from "./CoachFeedback"

const FIT_STEP = 8
const SEAT_STEP = 9
const INFLATE_STEP = 10

@component
export class RefitSteps extends BaseScriptComponent implements StepModule {
  @ui.label('<span style="color: #60A5FA;">RefitSteps – steps 8..10: fit, seat, inflate</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Wheel root (marker math is in its local space)")
  wheel: SceneObject

  @input
  @hint("Tire group holding Bead_0..7 (seated on step 9, inflated on step 10)")
  tire: SceneObject

  @input
  @hint("Tube group (inflated with the tire)")
  tube: SceneObject

  @input
  @hint("Valve stem (step 10 hold target)")
  valve: SceneObject

  @input
  @hint("Wheel/ValveSocket: the valve hole the new tube's valve end goes into")
  valveSocket: SceneObject

  @input
  @hint("ToolTray/NewTube: the coiled new tube (hidden once fitted)")
  newTube: SceneObject

  @input
  @hint("Grab handle on the new tube's valve end")
  tubeFit: TubeFit

  @input
  @hint("Tube pull / refit controller on TubeEnd")
  tubePull: TubePull

  @input
  @hint("Lever A (tweens home on step 8)")
  leverA: LeverPlacement

  @input
  @hint("Lever B (tweens home on step 8)")
  leverB: LeverPlacement

  @input
  @hint("Rim drag on lever B (re-posed at 5 o'clock when step 8 is undone)")
  rimDrag: RimDrag

  @input
  @hint("LeverSocketB (rim drag start)")
  leverSocketB: SceneObject

  @input
  @hint("Pinch targets on the valve and beads")
  wheelTargets: WheelTargets

  @input
  @hint("Pulsing glow on the parts the step wants touched")
  highlighter: Highlighter

  @input
  @hint("Cue player (click, nope, pump loop)")
  audio: BenchCoachAudio

  @input
  @allowUndefined
  @hint("Mistake feedback: a new tube end released away from the valve hole")
  feedback: CoachFeedback
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Bead major radius in cm (matches the Bead_i TorusArc)")
  @widget(new SliderWidget(10, 60, 0.1))
  beadRadiusCm: number = 33.4

  @input
  @hint("Marker stand-off in front of the part, in cm")
  @widget(new SliderWidget(0, 10, 0.5))
  markerStandoffCm: number = 1.5

  @input
  @hint("Tire and tube scale while flat (matches RepairManager's deflate)")
  @widget(new SliderWidget(0.8, 1, 0.01))
  deflateScale: number = 0.96

  @input
  @hint("Seconds of valve hold to inflate fully")
  @widget(new SliderWidget(0.5, 8, 0.1))
  inflateHoldSec: number = 2.5

  @input
  @hint("Print refit progress to the log")
  debugLogs: boolean = true
  @ui.group_end

  /** Step the manager last applied. */
  current: number = 0
  /** Step 8 entered: levers went home and the old tube was removed. */
  entered: boolean = false
  fitted: boolean = false
  /** 0..1 on step 10. */
  inflateProgress: number = 0
  inflated: boolean = false
  holding: boolean = false
  /** Tests / screenshots: false keeps the Lens on step 8 after the refit. */
  advanceOnFit: boolean = true

  /** Watch mode: beads still to seat by demo(9), one every demoSeatGapSec. */
  private demoQueue: number[] = []
  private demoTimer = 0
  private readonly demoSeatGapSec = 0.7
  private seated: number[] = []
  private seatFrom: vec3[] = []
  private paused = false

  private _onStepComplete = new Event<number>()
  onStepComplete: PublicApi<number> = this._onStepComplete.publicApi()
  /** Partial progress inside a step (a bead seated): the manager moves the ring. */
  private _onSubStep = new Event<number>()
  onSubStep: PublicApi<number> = this._onSubStep.publicApi()

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => this.onStart())
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  private onStart(): void {
    const refs: Array<[string, unknown]> = [
      ["wheel", this.wheel], ["tire", this.tire], ["tube", this.tube], ["valve", this.valve],
      ["valveSocket", this.valveSocket], ["newTube", this.newTube], ["tubeFit", this.tubeFit],
      ["tubePull", this.tubePull], ["leverA", this.leverA], ["leverB", this.leverB],
      ["rimDrag", this.rimDrag], ["leverSocketB", this.leverSocketB], ["wheelTargets", this.wheelTargets],
      ["highlighter", this.highlighter], ["audio", this.audio],
    ]
    const missing = refs.filter(([, v]) => !v).map(([n]) => n)
    if (missing.length > 0) {
      print(`[RefitSteps] ERROR: missing @input refs: ${missing.join(", ")}`)
      return
    }
    this.tubeFit.onFitted.add(() => this.onFitted())
    this.tubeFit.onRejected.add(() => {
      const pos = this.tubeFit.sceneObject.getTransform().getWorldPosition()
      if (this.feedback) this.feedback.mistake("tubeFitMiss", pos)
      else this.audio.playNopeAt(pos)
    })
    this.tubePull.onRefitComplete.add(() => this.onRefitDone())
    this.wheelTargets.onBeadPinched.add((i) => this.onBeadPinched(i))
    this.wheelTargets.onValveDown.add(() => this.onValveDown())
    this.wheelTargets.onValveUp.add(() => this.stopHolding())
  }

  // ── StepModule ────────────────────────────────────────────────────────────
  ownsStep(step: number): boolean {
    return step >= FIT_STEP && step <= INFLATE_STEP
  }

  apply(step: number, paused: boolean, instant: boolean = false): void {
    this.current = step
    this.paused = paused
    if (step !== INFLATE_STEP) this.stopHolding()
    if (step === FIT_STEP && !this.entered) this.enter(instant)
    if (this.tubeFit) this.tubeFit.setArmed(step === FIT_STEP && !this.fitted && !paused)
    this.setEnabled(this.newTube, STEPS[step].showNewTube && !this.fitted)
    // Step 9: the valve is live too, so pinching it before the beads are seated is caught (inflateBeforeSeat).
    if (step === SEAT_STEP) this.wheelTargets.setActive(!paused, paused ? [] : SEAT_BEADS)
    if (step === INFLATE_STEP) this.wheelTargets.setActive(!paused && !this.inflated, false)
    this.applyHighlight()
  }

  complete(step: number): void {
    switch (step) {
      case FIT_STEP:
        if (!this.entered) this.enter(true)
        this.fitted = true
        this.tubeFit.returnHome(true)
        this.setEnabled(this.newTube, false)
        this.tubePull.refitInstant()
        break
      case SEAT_STEP:
        for (const i of SEAT_BEADS) if (this.seated.indexOf(i) < 0) this.seat(i)
        break
      case INFLATE_STEP:
        this.stopHolding()
        this.inflateProgress = 1
        this.inflated = true
        this.applyInflate()
        break
      default:
        break
    }
  }

  undo(step: number): void {
    switch (step) {
      case FIT_STEP:
        if (!this.entered && !this.fitted) break
        this.tubePull.unrefit()
        if (this.entered) {
          this.leverA.placeInstant()
          this.leverB.placeInstant()
          this.rimDrag.completeInstant(this.leverSocketB, SOCKET_B_ANGLE_DEG)
        }
        this.tubeFit.returnHome(true)
        this.tubeFit.setArmed(false)
        this.setEnabled(this.newTube, false)
        this.entered = false
        this.fitted = false
        break
      case SEAT_STEP:
        for (let k = this.seated.length - 1; k >= 0; k--) {
          const bead = findBead(this.tire, this.seated[k])
          if (bead) bead.getTransform().setLocalPosition(this.seatFrom[k])
        }
        this.seated = []
        this.seatFrom = []
        break
      case INFLATE_STEP:
        this.stopHolding()
        if (this.inflateProgress > 0 || this.inflated) {
          this.inflateProgress = 0
          this.inflated = false
          this.applyInflate()
        }
        break
      default:
        break
    }
  }

  markerAnchor(step: number, live: boolean): {pos: vec3; angleDeg: number; radius: number} | null {
    if (!live || !this.wheel) return null
    const wheelMat = this.wheel.getTransform().getWorldTransform()
    const standoff = new vec3(0, 0, this.markerStandoffCm)
    if (step === FIT_STEP && this.valveSocket) {
      const p = this.valveSocket.getTransform().getLocalPosition()
      return {
        pos: this.valveSocket.getTransform().getWorldPosition().add(standoff),
        angleDeg: 0,
        radius: Math.sqrt(p.x * p.x + p.y * p.y),
      }
    }
    if (step === SEAT_STEP) {
      const next = SEAT_BEADS.filter((i) => this.seated.indexOf(i) < 0)[0]
      const angleDeg = beadMidDeg(next !== undefined ? next : SEAT_BEADS[SEAT_BEADS.length - 1])
      const radius = this.beadRadiusCm * this.tire.getTransform().getLocalScale().x
      const a = (angleDeg * Math.PI) / 180
      const local = new vec3(Math.sin(a) * radius, Math.cos(a) * radius, this.markerStandoffCm + 2)
      return {pos: wheelMat.multiplyPoint(local), angleDeg, radius}
    }
    if (step === INFLATE_STEP && this.valve) {
      const p = this.valve.getTransform().getLocalPosition()
      return {pos: this.valve.getTransform().getWorldPosition().add(standoff), angleDeg: 0, radius: Math.sqrt(p.x * p.x + p.y * p.y)}
    }
    return null
  }

  replay(step: number): boolean {
    return false
  }

  /**
   * Watch mode (pass 10): animate the step through its own completion path and return
   * roughly how long it takes. 8 flies the new tube end onto the valve socket (onFitted,
   * then the refit, then onStepComplete); 9 seats the lifted beads one by one; 10 holds
   * the valve until the tire is full. stopDemo() halts 9 and 10 where they are.
   */
  demo(step: number): number {
    if (step !== this.current || this.paused) return 0
    if (step === FIT_STEP) {
      if (this.fitted || !this.tubeFit) return 0
      this.tubeFit.playFit(1.0)
      // Pass P: the refit's own timing (the feed is slower and ends with the seated moment).
      const tp = this.tubePull
      return 1.0 + tp.valveTweenSec + 7 * tp.refitStaggerSec + tp.refitTweenSec + tp.refitSeatSec
    }
    if (step === SEAT_STEP) {
      this.demoQueue = SEAT_BEADS.filter((i) => this.seated.indexOf(i) < 0)
      this.demoTimer = 0
      return this.demoQueue.length * this.demoSeatGapSec
    }
    if (step === INFLATE_STEP) {
      if (this.inflated) return 0
      this.onValveDown()
      return (1 - this.inflateProgress) * this.inflateHoldSec
    }
    return 0
  }

  /** Watch mode stopped: drop queued bead seats and let go of the valve. */
  stopDemo(): void {
    this.demoQueue = []
    if (this.holding && !(this.wheelTargets && this.wheelTargets.valveHeld)) this.stopHolding()
  }

  // ── Public helpers (tests, screenshots) ──────────────────────────────────
  getSeatedBeads(): number[] {
    return this.seated.slice()
  }

  /** Run the live fit path as if NewTubeEnd had just snapped into the socket. */
  fitNow(): void {
    if (this.current !== FIT_STEP || this.fitted) return
    this.tubeFit.fitInstant()
    this.onFitted()
  }

  /** Hold the inflate at a fraction (screenshots of a half-pumped tire). */
  setInflateProgress(p: number): void {
    if (this.current !== INFLATE_STEP || this.inflated) return
    this.inflateProgress = Math.max(0, Math.min(0.99, p))
    this.applyInflate()
  }

  // ── Step 8 ────────────────────────────────────────────────────────────────
  private enter(instant: boolean): void {
    this.leverA.returnHome(instant)
    this.leverB.returnHome(instant)
    this.tubePull.removeForRefit()
    this.entered = true
    this.log(`step 8 entered (${instant ? "instant" : "levers tween home"})`)
  }

  private onFitted(): void {
    if (this.current !== FIT_STEP || this.fitted) return
    this.fitted = true
    this.audio.playClickAt(this.valveSocket.getTransform().getWorldPosition())
    this.tubeFit.returnHome(true)
    this.tubeFit.setArmed(false)
    this.setEnabled(this.newTube, false)
    this.applyHighlight()
    this.tubePull.refit()
    this.log("new tube fitted at the valve: refitting")
  }

  private onRefitDone(): void {
    if (this.current !== FIT_STEP || !this.fitted) return
    this.log("new tube in")
    if (this.advanceOnFit) this._onStepComplete.invoke(FIT_STEP)
  }

  // ── Step 9 ────────────────────────────────────────────────────────────────
  private onBeadPinched(i: number): void {
    if (this.current !== SEAT_STEP || this.paused) return
    if (SEAT_BEADS.indexOf(i) < 0 || this.seated.indexOf(i) >= 0) return
    this.seat(i)
    const bead = findBead(this.tire, i)
    if (bead) this.audio.playClickAt(bead.getTransform().getWorldPosition())
    this.log(`Bead_${i} seated (${this.seated.length}/${SEAT_BEADS.length})`)
    if (this.seated.length >= SEAT_BEADS.length) {
      this._onStepComplete.invoke(SEAT_STEP)
    } else {
      this.applyHighlight()
      this._onSubStep.invoke(this.seated.length)
    }
  }

  private seat(i: number): void {
    const bead = findBead(this.tire, i)
    if (!bead) return
    this.seated.push(i)
    this.seatFrom.push(bead.getTransform().getLocalPosition())
    setBeadOffset(this.tire, i, 0)
  }

  // ── Step 10 ───────────────────────────────────────────────────────────────
  private onValveDown(): void {
    if (this.current !== INFLATE_STEP || this.inflated || this.paused || this.holding) return
    this.holding = true
    this.audio.startPumpAt(this.valve.getTransform().getWorldPosition())
    this.log(`valve held: pumping from ${(this.inflateProgress * 100).toFixed(0)}%`)
  }

  private stopHolding(): void {
    if (!this.holding) return
    this.holding = false
    if (this.audio) this.audio.stopPump()
    this.log(`valve released at ${(this.inflateProgress * 100).toFixed(0)}%`)
  }

  private tick(): void {
    if (this.demoQueue.length > 0) {
      if (this.current !== SEAT_STEP) {
        this.demoQueue = []
      } else {
        this.demoTimer += getDeltaTime()
        if (this.demoTimer >= this.demoSeatGapSec) {
          this.demoTimer = 0
          this.onBeadPinched(this.demoQueue.shift())
        }
      }
    }
    if (!this.holding) return
    if (this.current !== INFLATE_STEP || this.inflated) {
      this.stopHolding()
      return
    }
    this.inflateProgress = Math.min(1, this.inflateProgress + getDeltaTime() / Math.max(0.1, this.inflateHoldSec))
    this.applyInflate()
    if (this.inflateProgress >= 1) {
      this.inflated = true
      this.stopHolding()
      this.log("inflated")
      this._onStepComplete.invoke(INFLATE_STEP)
    }
  }

  private applyInflate(): void {
    const k = this.deflateScale + (1 - this.deflateScale) * this.inflateProgress
    const s = new vec3(k, k, k)
    if (this.tire) this.tire.getTransform().setLocalScale(s)
    if (this.tube) this.tube.getTransform().setLocalScale(s)
  }

  // ── Shared ────────────────────────────────────────────────────────────────
  private applyHighlight(): void {
    if (!this.highlighter || !this.ownsStep(this.current)) return
    if (this.current === FIT_STEP) {
      if (!this.fitted && this.newTube) this.highlighter.set([this.newTube])
      else this.highlighter.clear()
    } else if (this.current === SEAT_STEP) {
      const parts: SceneObject[] = []
      for (const i of SEAT_BEADS) {
        if (this.seated.indexOf(i) >= 0) continue
        const bead = findBead(this.tire, i)
        if (bead) parts.push(bead)
      }
      this.highlighter.set(parts)
    } else if (this.current === INFLATE_STEP) {
      if (!this.inflated) this.highlighter.set([this.valve])
      else this.highlighter.clear()
    }
  }

  private setEnabled(so: SceneObject | null, on: boolean): void {
    if (so && so.enabled !== on) so.enabled = on
  }

  private log(msg: string): void {
    if (this.debugLogs) print(`[RefitSteps] ${msg}`)
  }
}
