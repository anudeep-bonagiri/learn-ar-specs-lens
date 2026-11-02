/**
 * RepairManager — the step machine (steps 0..11) for the flat-fix procedure.
 * Owns: state {step, subStep, startTime}, which authored objects are visible per
 * step, the StepMarker / StepLabel placement, and every model change (tire
 * deflate, bead push, bead lift, bead peel, thorn reveal) plus its undo on Back /
 * reset, and which cue (click, nope, done) plays when. The tube pull animation is
 * owned by TubePull and the glint by ThornHotspot; this script arms and restores them.
 * Reads: StepDefinitions. Listens to: WheelTargets, LeverPlacement (A and B),
 * RimDrag, TubePull, ThornHotspot. Next and jumpToStep() apply a step's model state directly.
 * Also drives the Highlighter (valve on step 1, unloosened beads on step 2) and
 * keeps the Tube hidden until a bead lifts (lever A placed, or step 4 onward).
 * Must not: author UI — cards and labels are passive views driven via setters.
 * Size note: above 400 lines on purpose — the per-step complete / undo / apply
 * tables are one state machine and are easier to audit side by side than split.
 * Note: step-0 visibility is applied on the first Update so every authored
 * component (UIKit plates, buttons, levers) initializes while enabled.
 * Pass 9 seam: steps 8..10 belong to a StepModule (RefitSteps). The manager
 * delegates them through the default branches of completeStep / undoStep, one
 * call in applyStep (refit.apply, every step) and one in markerAnchorFor, and
 * advances on refit.onStepComplete. Step 7 (halfway card) plays the Done cue;
 * LAST_STEP (11, Finish card with time and RunStats) plays the Finish cue.
 * Pass 8: a flat cause per run (foundIt() picks one at random unless forceCause
 * is set; reset / jumpToStep use forceCause or the default causeId, so tests are
 * deterministic), ThornHotspot.setCause places it; mistakes go to CoachFeedback
 * with a reason code; setInteractionsPaused(on) re-applies the step with every
 * arm gated off (What's this?); refreshLabel() gives the label back after a hint,
 * a mistake reason or a part fact.
 * Pass 11: goTo reports each step change to RunStats.noteStep (step times), and
 * the Finish card also gets the slowest-steps row and RunStats.practiceTip().
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {FLAT_CAUSE_IDS, FLAT_CAUSES, LAST_STEP, LOOSEN_BEADS, STEPS, SOCKET_B_ANGLE_DEG, STEP_SHORT_NAMES} from "./StepDefinitions"
import {beadMidDeg, findChild, setBeadOffset} from "./WheelMath"
import {WheelTargets} from "./WheelTargets"
import {LeverPlacement} from "./LeverPlacement"
import {GhostAnimator} from "./GhostAnimator"
import {RimDrag} from "./RimDrag"
import {TubePull} from "./TubePull"
import {ThornHotspot} from "./ThornHotspot"
import {BenchCoachAudio} from "./BenchCoachAudio"
import {BenchCoachStepLabelUI} from "./BenchCoachStepLabelUI"
import {BenchCoachDoneCardUI} from "./BenchCoachDoneCardUI"
import {StepTicks} from "./StepTicks"
import {Highlighter} from "./Highlighter"
import {RefitSteps} from "./RefitSteps"
import {BenchCoachFinishCardUI} from "./BenchCoachFinishCardUI"
import {RunStats, formatMSS} from "./RunStats"
import {CoachFeedback} from "./CoachFeedback"

const ALL_BEADS = [0, 1, 2, 3, 4, 5, 6, 7]

export interface RepairState {
  step: number
  subStep: number
  startTime: number
  elapsedSec: number
}

@component
export class RepairManager extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">RepairManager – step machine 0..11</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Wheel assembly root (hidden until Found it)")
  wheel: SceneObject

  @input
  @hint("Repair stand root (hidden until Found it)")
  stand: SceneObject

  @input
  @allowUndefined
  @hint("Workshop dressing root (floor mat, floor path); shown with the wheel")
  environment: SceneObject

  @input
  @hint("Tire group holding Bead_0..7 (scaled 4% down on deflate)")
  tire: SceneObject

  @input
  @hint("Valve stem (step 1 marker anchor)")
  valve: SceneObject

  @input
  @hint("Pinch targets on the valve and beads")
  wheelTargets: WheelTargets

  @input
  @hint("StartCard root (step 0 only)")
  startCard: SceneObject

  @input
  @hint("The single StepMarker ring")
  stepMarker: SceneObject

  @input
  @hint("Step label panel")
  stepLabel: BenchCoachStepLabelUI

  @input
  @hint("ToolTray root (levers inside), shown from step 3")
  toolTray: SceneObject

  @input
  @hint("Ghost lever animator (step 3)")
  ghost: GhostAnimator

  @input
  @hint("LeverSocket: snap target on the bead at the valve")
  leverSocket: SceneObject

  @input
  @hint("Lever A placement controller")
  leverA: LeverPlacement

  @input
  @hint("LeverSocketB: snap target 5 cm along the rim from socket A")
  leverSocketB: SceneObject

  @input
  @hint("Lever B placement controller")
  leverB: LeverPlacement

  @input
  @hint("Rim drag controller on lever B")
  rimDrag: RimDrag

  @input
  @hint("Tube pull controller on TubeEnd")
  tubePull: TubePull

  @input
  @hint("TubeEnd (step 5 marker anchor)")
  tubeEnd: SceneObject

  @input
  @hint("ThornHotspot in the tire (step 6 search target)")
  thorn: ThornHotspot

  @input
  @hint("Cue player (zipper, click, nope, done)")
  audio: BenchCoachAudio

  @input
  @hint("Done card (step 7)")
  doneCard: BenchCoachDoneCardUI

  @input
  @hint("Dim ticks left on the parts of completed steps")
  @allowUndefined
  ticks: StepTicks

  @input
  @hint("Pulsing glow on the parts the current step wants touched")
  highlighter: Highlighter

  @input
  @hint("Tube group (TubeSeg_0..7 and TubeEnd): hidden until a bead lifts")
  tube: SceneObject

  @input
  @allowUndefined
  @hint("StepModule for steps 8..10 (fit the new tube, seat the bead, inflate)")
  refit: RefitSteps

  @input
  @allowUndefined
  @hint("Finish card (step 11): time, stats, prevention tip")
  finishCard: BenchCoachFinishCardUI

  @input
  @allowUndefined
  @hint("Run counters shown on the Finish card")
  stats: RunStats

  @input
  @allowUndefined
  @hint("Mistake feedback (nope plus a reason on the label)")
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
  @hint("Label distance from its marker, in cm")
  @widget(new SliderWidget(4, 30, 0.5))
  labelOffsetCm: number = 10

  @input
  @hint("Step 5 (far side): lift the label this much above its 6 o'clock spot, so from the start pose it is not behind the body-locked control bar (pass G5, B1)")
  @widget(new SliderWidget(0, 40, 1))
  farSideLabelLiftCm: number = 20

  @input
  @hint("Tire scale after deflating (0.96 = 4% smaller)")
  @widget(new SliderWidget(0.8, 1, 0.01))
  deflateScale: number = 0.96

  @input
  @hint("How far each loosened bead shifts toward the rim center, in cm")
  @widget(new SliderWidget(0.1, 3, 0.1))
  beadPushCm: number = 0.5

  @input
  @hint("How far Bead_0 lifts radially outward when lever A hooks, in cm")
  @widget(new SliderWidget(0.2, 5, 0.1))
  beadLiftCm: number = 1

  @input
  @hint("Seconds the found thorn and its label stay up before the Done card")
  @widget(new SliderWidget(0, 6, 0.1))
  thornRevealSec: number = 2.5

  @input
  @hint("Default flat cause after reset / jumpToStep (Found it picks one at random)")
  causeId: string = "thorn"

  @input
  @hint("Force this flat cause every run (thorn, glass, snakebite); empty = random on Found it")
  forceCause: string = ""

  @input
  @hint("Print step transitions to the log")
  debugLogs: boolean = true
  @ui.group_end

  private step = 0
  private subStep = 0
  private startTime = 0
  private loosened: number[] = []
  private peeled: number[] = []
  private leverPlaced = false
  private leverBPlaced = false
  private thornFound = false
  /** Bumped whenever step 6 is undone, so a pending thorn-to-Done delay is dropped. */
  private thornGeneration = 0
  private initialized = false
  /** True during Back / reset / jumpToStep: module entry changes snap instead of tweening. */
  private instant = false

  /** What's this? mode: every step interaction is gated off (setInteractionsPaused). */
  interactionsPaused: boolean = false

  /** The current run's flat cause (FLAT_CAUSES key). */
  private cause = "thorn"

  /** Times Replay did something on the current step (ghost, chime or glint flash). */
  replayCount: number = 0
  /** What the last Replay showed (pass F; logged and read by tests), or "nothing". */
  lastReplay: string = ""

  private _onStepChanged = new Event<number>()
  onStepChanged: PublicApi<number> = this._onStepChanged.publicApi()
  /** reset() finished (Start over, Restart, jumpToStep): What's this? turns itself off. */
  private _onReset = new Event<void>()
  onReset: PublicApi<void> = this._onReset.publicApi()

  getState(): RepairState {
    return {
      step: this.step,
      subStep: this.subStep,
      startTime: this.startTime,
      elapsedSec: this.startTime > 0 ? getTime() - this.startTime : 0,
    }
  }

  getLoosenedBeads(): number[] {
    return this.loosened.slice()
  }

  getPeeledBeads(): number[] {
    return this.peeled.slice()
  }

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => this.onStart())
    this.createEvent("UpdateEvent").bind(() => {
      if (!this.initialized) {
        this.initialized = true
        this.applyStep()
      }
    })
  }

  private onStart(): void {
    const missing: string[] = []
    const refs: Array<[string, unknown]> = [
      ["wheel", this.wheel],
      ["stand", this.stand],
      ["tire", this.tire],
      ["valve", this.valve],
      ["wheelTargets", this.wheelTargets],
      ["startCard", this.startCard],
      ["stepMarker", this.stepMarker],
      ["stepLabel", this.stepLabel],
      ["toolTray", this.toolTray],
      ["ghost", this.ghost],
      ["leverSocket", this.leverSocket],
      ["leverA", this.leverA],
      ["leverSocketB", this.leverSocketB],
      ["leverB", this.leverB],
      ["rimDrag", this.rimDrag],
      ["tubePull", this.tubePull],
      ["tubeEnd", this.tubeEnd],
      ["thorn", this.thorn],
      ["audio", this.audio],
      ["doneCard", this.doneCard],
      ["highlighter", this.highlighter],
      ["tube", this.tube],
    ]
    for (const [name, value] of refs) if (!value) missing.push(name)
    if (missing.length > 0) {
      print(`[RepairManager] ERROR: missing @input refs: ${missing.join(", ")}`)
      return
    }
    this.wheelTargets.onValvePinched.add(() => this.onValvePinched())
    this.wheelTargets.onBeadPinched.add((i) => this.onBeadPinched(i))
    this.leverA.onPlaced.add(() => this.onLeverPlaced())
    this.leverB.onPlaced.add(() => this.onLeverBPlaced())
    this.rimDrag.onSegmentPassed.add((i) => this.onSegmentPeeled(i))
    this.rimDrag.onPeelComplete.add(() => this.onPeelComplete())
    this.tubePull.onPullComplete.add(() => this.onTubePulled())
    this.thorn.onFound.add(() => this.onThornFound())
    this.leverA.onRejected.add(() => this.onLeverRejected(this.leverA, false))
    this.leverB.onRejected.add(() => this.onLeverRejected(this.leverB, true))
    this.tubePull.onEarlyPinch.add(() => {
      if (this.step === 4) this.mistake("tubeBeforePeel", this.tubeEnd.getTransform().getWorldPosition())
    })
    if (this.feedback) this.feedback.restoreLabel = () => this.refreshLabel()
    this.cause = this.defaultCause()
    this.thorn.setCause(this.cause)
    if (this.refit) {
      this.refit.onStepComplete.add((s) => {
        if (s === this.step) this.goTo(this.step + 1)
      })
      this.refit.onSubStep.add((n) => {
        this.subStep = n
        this.placeMarkerAndLabel()
      })
    }
  }

  // ── Public actions (UIBindings + tests) ────────────────────────────────────
  foundIt(): void {
    if (this.step !== 0) return
    this.startTime = getTime()
    this.setCause(this.forceCause ? this.forceCause : FLAT_CAUSE_IDS[Math.floor(Math.random() * FLAT_CAUSE_IDS.length)])
    this.goTo(1)
  }

  /** The current run's flat cause id. */
  getCause(): string {
    return this.cause
  }

  /** Set the flat cause (moves the hotspot); only takes effect before it is found. */
  setCause(id: string): void {
    this.cause = FLAT_CAUSES[id] ? id : "thorn"
    if (this.thorn) this.thorn.setCause(this.cause)
    if (this.initialized && STEPS[this.step].markerAnchor === "inspect") this.placeMarkerAndLabel()
    this.log(`flat cause: ${this.cause}`)
  }

  /**
   * What's this? mode: re-apply the current step with every interaction gated off
   * (pinch targets, snapping, the tube end, the glint, the new tube) or back on.
   */
  setInteractionsPaused(on: boolean): void {
    if (this.interactionsPaused === on) return
    this.interactionsPaused = on
    this.applyStep()
  }

  /** Next applies the current step's model change (as if the user did it), then advances. */
  next(): void {
    if (this.step === 0) {
      this.foundIt()
      return
    }
    if (this.step >= LAST_STEP) return
    this.completeStep(this.step)
    this.goTo(this.step + 1)
  }

  /** Back drops any partial work on the current step, then undoes the previous one. */
  back(): void {
    if (this.step <= 0) return
    this.instant = true
    this.undoStep(this.step)
    this.undoStep(this.step - 1)
    this.goTo(this.step - 1)
    this.instant = false
  }

  /**
   * Replay re-shows how to do the current step: the ghost's hooking motion on
   * the lever steps, a bright glint flash on the inspect step, the done cue on
   * the Done card, and elsewhere a chime from the marker so the user can hear
   * where the work is.
   */
  replay(): void {
    const def = STEPS[this.step]
    let what: string
    if (this.refit && this.refit.ownsStep(this.step) && this.refit.replay(this.step)) {
      what = "the step module's demo" // the module showed it
    } else if (def.showGhost && this.ghost && this.ghost.sceneObject.enabled) {
      this.ghost.play()
      what = "the ghost lever's hooking motion"
    } else if (def.markerAnchor === "inspect" && !this.thornFound) {
      this.thorn.flash()
      what = "the glint flash on the tire"
    } else if (this.stepMarker.enabled) {
      this.audio.playChimeAt(this.stepMarker.getTransform().getWorldPosition())
      what = "the chime from the marker"
    } else if (def.showDoneCard) {
      this.audio.playDoneAt(this.doneCard.sceneObject.getTransform().getWorldPosition())
      what = "the done cue"
    } else if (def.showFinishCard && this.finishCard) {
      this.audio.playFinishAt(this.finishCard.sceneObject.getTransform().getWorldPosition())
      what = "the finish cue"
    } else {
      this.lastReplay = "nothing"
      this.log(`replay on step ${this.step} (${def.name}): nothing to replay`)
      return
    }
    this.replayCount += 1
    this.lastReplay = what
    this.log(`replay on step ${this.step} (${def.name}): ${what} (replay ${this.replayCount} on this step)`)
  }

  reset(): void {
    const wasInstant = this.instant
    this.instant = true
    for (let s = LAST_STEP; s >= 0; s--) this.undoStep(s)
    this.startTime = 0
    if (this.stats) this.stats.reset()
    this.setCause(this.defaultCause())
    this.goTo(0)
    this._onReset.invoke()
    this.instant = wasInstant
  }

  /** Debug / test entry: reset, apply the model state of steps 0..n-1, enter step n. */
  jumpToStep(n: number): void {
    this.instant = true
    this.reset()
    const target = Math.max(0, Math.min(LAST_STEP, n))
    for (let s = 0; s < target; s++) this.completeStep(s)
    this.goTo(target)
    this.instant = false
  }

  /** Put the current step's own label back (after a hint, a mistake reason or a part fact). */
  refreshLabel(): void {
    const def = STEPS[this.step]
    if (!this.stepLabel || def.markerAnchor === "none" || this.interactionsPaused) return
    this.stepLabel.setText(this.currentLabel())
  }

  private currentLabel(): string {
    const def = STEPS[this.step]
    return def.markerAnchor === "inspect" && this.thornFound ? this.causeDef().foundLabel : def.label
  }

  private causeDef() {
    return FLAT_CAUSES[this.cause] ? FLAT_CAUSES[this.cause] : FLAT_CAUSES["thorn"]
  }

  private defaultCause(): string {
    if (this.forceCause && FLAT_CAUSES[this.forceCause]) return this.forceCause
    return FLAT_CAUSES[this.causeId] ? this.causeId : "thorn"
  }

  private mistake(code: string, pos: vec3): void {
    if (this.feedback) this.feedback.mistake(code, pos)
    else if (this.audio) this.audio.playNopeAt(pos)
  }

  /** A lever released away from its socket: the reason depends on the step. */
  private onLeverRejected(lever: LeverPlacement, isB: boolean): void {
    const pos = lever.sceneObject.getTransform().getWorldPosition()
    if (this.step === 3) this.mistake(isB ? "leverBBeforeA" : "leverTooFar", pos)
    else if (this.step === 4 && isB) this.mistake("leverTooFar", pos)
    else this.playNope(lever)
  }

  // ── Completion handlers ────────────────────────────────────────────────────
  private onValvePinched(): void {
    if (this.step === 2) this.mistake("valveAlreadyDeflated", this.valve.getTransform().getWorldPosition())
    if (this.step === 9) this.mistake("inflateBeforeSeat", this.valve.getTransform().getWorldPosition())
    if (this.step !== 1) return
    if (this.audio) this.audio.playHissAt(this.valve.getTransform().getWorldPosition())
    this.setDeflated(true)
    this.log("valve pinched: tire deflated")
    this.goTo(2)
  }

  private onBeadPinched(i: number): void {
    if (this.step === 1) {
      const bead = findChild(this.tire, `Bead_${i}`)
      this.mistake("beadBeforeDeflate", bead ? bead.getTransform().getWorldPosition() : this.valve.getTransform().getWorldPosition())
      return
    }
    if (this.step !== 2) return
    if (LOOSEN_BEADS.indexOf(i) < 0 || this.loosened.indexOf(i) >= 0) return
    this.setBeadOffset(i, -this.beadPushCm)
    this.loosened.push(i)
    this.subStep = this.loosened.length
    this.log(`bead ${i} pushed (${this.loosened.length}/${LOOSEN_BEADS.length})`)
    if (this.loosened.length >= LOOSEN_BEADS.length) {
      this.goTo(3)
    } else {
      this.placeMarkerAndLabel()
      this.applyHighlight()
    }
  }

  private onLeverPlaced(): void {
    if (this.step !== 3) return
    this.playClick(this.leverA)
    this.applyLeverA()
    this.log("lever A placed: Bead_0 lifted")
    this.goTo(4)
  }

  private onLeverBPlaced(): void {
    if (this.step !== 4 || this.leverBPlaced) return
    this.leverBPlaced = true
    this.subStep = 1
    this.playClick(this.leverB)
    if (this.ghost) this.ghost.sceneObject.enabled = false
    this.rimDrag.arm(this.leverSocketB, SOCKET_B_ANGLE_DEG)
    this.log("lever B hooked: slide it round")
  }

  private onSegmentPeeled(i: number): void {
    if (this.step !== 4) return
    this.liftBead(i)
    if (this.peeled.indexOf(i) < 0) this.peeled.push(i)
    this.subStep = 1 + this.peeled.length
    if (this.audio && this.leverB) this.audio.playZipperAt(this.leverB.sceneObject.getTransform().getWorldPosition())
    this.log(`Bead_${i} peeled`)
  }

  private onPeelComplete(): void {
    if (this.step !== 4) return
    this.log("bead peeled to 5 o'clock")
    this.goTo(5)
  }

  private onTubePulled(): void {
    if (this.step !== 5) return
    this.log("tube out")
    this.goTo(6)
  }

  /** The thorn is found: show it with its label for a moment, then the Done card. */
  private onThornFound(): void {
    if (this.step !== 6 || this.thornFound) return
    this.thornFound = true
    this.subStep = 1
    this.playClick(this.thorn)
    this.stepLabel.setText(this.causeDef().foundLabel)
    this.placeMarkerAndLabel()
    this.log("thorn found")
    const generation = this.thornGeneration
    const delay = this.createEvent("DelayedCallbackEvent")
    delay.bind(() => {
      if (this.step === 6 && this.thornFound && generation === this.thornGeneration) this.goTo(7)
    })
    delay.reset(this.thornRevealSec)
  }

  private playClick(source: BaseScriptComponent): void {
    if (this.audio) this.audio.playClickAt(source.sceneObject.getTransform().getWorldPosition())
  }

  private playNope(source: BaseScriptComponent): void {
    if (this.audio) this.audio.playNopeAt(source.sceneObject.getTransform().getWorldPosition())
  }

  // ── Model changes shared by user actions, Next and jumpToStep ─────────────
  private applyLeverA(): void {
    this.leverPlaced = true
    this.liftBead(0)
    if (this.ghost) this.ghost.sceneObject.enabled = false
  }

  /** Raise Bead_i 1 cm radially outward (on top of its loosen push, if any). */
  private liftBead(i: number): void {
    this.setBeadOffset(i, this.beadLiftCm - (this.loosened.indexOf(i) >= 0 ? this.beadPushCm : 0))
  }

  private lowerBead(i: number): void {
    this.setBeadOffset(i, this.loosened.indexOf(i) >= 0 ? -this.beadPushCm : 0)
  }

  /** Apply the model state that completing `step` produces, without the user action. */
  private completeStep(step: number): void {
    switch (step) {
      case 0:
        if (this.startTime === 0) this.startTime = getTime()
        break
      case 1:
        this.setDeflated(true)
        break
      case 2:
        for (const i of LOOSEN_BEADS) {
          if (this.loosened.indexOf(i) < 0) {
            this.setBeadOffset(i, -this.beadPushCm)
            this.loosened.push(i)
          }
        }
        break
      case 3:
        if (!this.leverPlaced) {
          if (this.leverA) this.leverA.placeInstant()
          this.applyLeverA()
        }
        break
      case 4:
        if (!this.leverBPlaced) {
          if (this.leverB) this.leverB.placeInstant()
          this.leverBPlaced = true
          if (this.ghost) this.ghost.sceneObject.enabled = false
        }
        if (this.rimDrag) {
          this.rimDrag.completeInstant(this.leverSocketB, SOCKET_B_ANGLE_DEG)
          for (const i of this.rimDrag.getPassedSegments()) {
            this.liftBead(i)
            if (this.peeled.indexOf(i) < 0) this.peeled.push(i)
          }
        }
        break
      case 5:
        if (this.tubePull) this.tubePull.completeInstant()
        break
      case 6:
        this.thornFound = true
        if (this.thorn) this.thorn.revealInstant()
        break
      default:
        if (this.refit && this.refit.ownsStep(step)) this.refit.complete(step)
        break
    }
  }

  // ── Step transitions ───────────────────────────────────────────────────────
  private goTo(step: number): void {
    const from = this.step
    this.step = Math.max(0, Math.min(LAST_STEP, step))
    this.subStep = 0
    this.replayCount = 0
    this.lastReplay = ""
    if (this.feedback) this.feedback.cancel()
    // Pass 11: step times (before applyStep, so step 10's time is in when the Finish card fills).
    if (this.stats) this.stats.noteStep(from, this.step)
    this.applyStep()
    if (this.step !== from && STEPS[this.step].showDoneCard && this.audio && this.doneCard) {
      this.audio.playDoneAt(this.doneCard.sceneObject.getTransform().getWorldPosition())
    }
    if (this.step === LAST_STEP && from !== LAST_STEP && this.audio && this.finishCard) {
      this.audio.playFinishAt(this.finishCard.sceneObject.getTransform().getWorldPosition())
    }
    this._onStepChanged.invoke(this.step)
  }

  /** Undo the model change that completing `step` produced. */
  private undoStep(step: number): void {
    switch (step) {
      case 0:
        this.startTime = 0
        break
      case 1:
        this.setDeflated(false)
        break
      case 2:
        for (const i of LOOSEN_BEADS) this.setBeadOffset(i, 0)
        this.loosened = []
        break
      case 3:
        if (this.leverPlaced) {
          this.lowerBead(0)
          this.leverPlaced = false
        }
        if (this.leverA) this.leverA.returnHome(true)
        break
      case 4:
        if (this.rimDrag) this.rimDrag.disarm()
        for (const i of this.peeled) this.lowerBead(i)
        this.peeled = []
        this.leverBPlaced = false
        if (this.leverB) this.leverB.returnHome(true)
        break
      case 5:
        if (this.tubePull) this.tubePull.restore()
        break
      case 6:
        this.thornFound = false
        this.thornGeneration += 1
        if (this.thorn) this.thorn.reset()
        break
      default:
        if (this.refit && this.refit.ownsStep(step)) this.refit.undo(step)
        break
    }
  }

  private applyStep(): void {
    const def = STEPS[this.step]
    this.setEnabled(this.startCard, def.showStartCard)
    this.setEnabled(this.wheel, def.showWheel)
    this.setEnabled(this.stand, def.showWheel)
    if (this.environment) this.setEnabled(this.environment, def.showWheel)
    this.setEnabled(this.toolTray, def.showTray)
    if (this.ghost) this.setEnabled(this.ghost.sceneObject, def.showGhost)
    if (this.doneCard) this.setEnabled(this.doneCard.sceneObject, def.showDoneCard)
    if (def.showDoneCard && this.doneCard) this.doneCard.setElapsed(this.getState().elapsedSec)
    if (this.finishCard) this.setEnabled(this.finishCard.sceneObject, def.showFinishCard)
    if (def.showFinishCard && this.finishCard) this.pushFinishCard()

    // Lever A only snaps up to step 3 (back home in the tray from step 8 it must not re-hook);
    // lever B only during step 4 (before it is hooked); the tube end only pulls in step 5.
    // While paused (What's this?) every arm is gated off; un-pausing re-applies the step.
    const live = !this.interactionsPaused
    if (this.leverA) this.leverA.snapEnabled = live && this.step <= 3
    if (this.leverB) this.leverB.snapEnabled = live && this.step === 4 && !this.leverBPlaced
    if (this.rimDrag && this.step !== 4) this.rimDrag.disarm()
    if (this.tubePull) {
      if (this.step === 5 && live) this.tubePull.arm()
      else this.tubePull.disarm()
      // Step 4: a pinch on the tube end before the peel is a mistake (tubeBeforePeel).
      this.tubePull.setEarlyPinch(this.step === 4 && live)
    }
    if (this.thorn) {
      if (this.step === 6 && !this.thornFound && live) this.thorn.arm()
      else this.thorn.disarm()
    }
    // Step 1 catches a bead pinch (bead before deflate); step 2 a second valve pinch.
    if (this.wheelTargets) {
      if (!live) this.wheelTargets.setActive(false, false)
      else this.wheelTargets.setActive(this.step === 1 || this.step === 2, this.step === 1 ? ALL_BEADS : this.step === 2)
    }
    // The tube shows once a bead lifts; TubePull keeps its homes while the group is off.
    this.setEnabled(this.tube, this.step >= 4 || this.leverPlaced)
    this.applyHighlight()
    // Every step (owned or not): the module arms / disarms its parts and may override targets and glow.
    if (this.refit) this.refit.apply(this.step, this.interactionsPaused, this.instant)

    const showLabel = def.markerAnchor !== "none"
    if (this.stepLabel) this.setEnabled(this.stepLabel.sceneObject, showLabel)
    if (!showLabel && this.feedback) this.feedback.cancel()
    if (showLabel) {
      this.stepLabel.setText(this.currentLabel())
      this.placeMarkerAndLabel()
    } else {
      this.setEnabled(this.stepMarker, false)
    }
    this.placeTicks()
    if (def.showGhost && this.ghost) {
      this.ghost.setSocket(def.ghostSocket === "B" ? this.leverSocketB : this.leverSocket)
      this.ghost.play()
    }
    this.log(`step ${this.step} (${def.name})`)
  }

  /** Pushes time, stats and the cause into the Finish card (step 11). */
  private pushFinishCard(): void {
    const cause = this.causeDef()
    const s = this.stats ? this.stats.snapshot() : {leverMisses: 0, hintsUsed: 0, mistakes: 0}
    this.finishCard.setResult(
      this.getState().elapsedSec,
      `Lever misses ${s.leverMisses} · Mistakes ${s.mistakes} · Hints ${s.hintsUsed}`,
      `Cause: ${cause.label}`,
      cause.tip
    )
    // Pass 11 coach report: the three slowest work steps and one practice line.
    if (this.stats) {
      const slow = this.stats.slowestSteps(3)
      const parts = slow.map((id) => `${STEP_SHORT_NAMES[id] ?? STEPS[id].name} ${formatMSS(this.stats.stepSeconds(id))}`)
      this.finishCard.setReport(parts.length > 0 ? `Slowest: ${parts.join(" · ")}` : "Slowest: no timed steps", this.stats.practiceTip())
    }
  }

  /** Step 1 lights the valve, step 2 the beads still to loosen; every other step none (RefitSteps lights 8..10). */
  private applyHighlight(): void {
    if (!this.highlighter) return
    if (this.step === 1) {
      this.highlighter.set([this.valve])
    } else if (this.step === 2) {
      const parts: SceneObject[] = []
      for (const i of LOOSEN_BEADS) {
        if (this.loosened.indexOf(i) >= 0) continue
        const bead = findChild(this.tire, `Bead_${i}`)
        if (bead) parts.push(bead)
      }
      this.highlighter.set(parts)
    } else {
      this.highlighter.clear()
    }
  }

  // ── Marker and label placement ─────────────────────────────────────────────
  /** Places the ring and its label; on the inspect step the ring only appears on a found thorn. */
  private placeMarkerAndLabel(): void {
    const def = STEPS[this.step]
    this.setEnabled(this.stepMarker, def.markerAnchor !== "inspect" || this.thornFound)
    const anchor = this.markerAnchorFor(this.step, true)
    this.stepMarker.getTransform().setWorldPosition(anchor.pos)

    // Searching: the label sits above the wheel, not next to the answer.
    const angleDeg = def.markerAnchor === "inspect" && !this.thornFound ? 0 : anchor.angleDeg
    const dir = new vec3(Math.sin((angleDeg * Math.PI) / 180), Math.cos((angleDeg * Math.PI) / 180), 0)
    // Once the thorn is found the label sits by it, in front of the pulled tube that hangs 10 cm
    // off the wheel; while searching it is above the wheel at the usual depth (pass G5, B1: 16 cm
    // nearer made the Ask chips clip the view's left edge). Step 5's label lifts clear of the bar.
    const forward = def.markerAnchor === "inspect" && this.thornFound ? 16 : 4
    const lift = def.markerAnchor === "tubeEnd" ? this.farSideLabelLiftCm : 0
    const labelPos = this.wheel
      .getTransform()
      .getWorldPosition()
      .add(dir.uniformScale(anchor.radius + this.labelOffsetCm))
      .add(new vec3(0, lift, forward))
    this.stepLabel.sceneObject.getTransform().setWorldPosition(labelPos)
  }

  /** A small dim tick on the part of every completed step that has one. */
  private placeTicks(): void {
    if (!this.ticks) return
    const positions: vec3[] = []
    for (let s = 1; s < this.step; s++) {
      if (STEPS[s].markerAnchor !== "none") positions.push(this.markerAnchorFor(s, false).pos)
    }
    this.ticks.setTicks(this.wheel.enabled ? positions : [])
  }

  /**
   * Where a step's ring goes, and the wheel angle / radius its label hangs off.
   * `live` follows the step's moving parts (the next lit bead, the pulled tube end);
   * a completed step's tick stays where the work was done.
   */
  private markerAnchorFor(step: number, live: boolean): {pos: vec3; angleDeg: number; radius: number} {
    const def = STEPS[step]
    if (def.markerAnchor === "module" && live && this.refit) {
      const fromModule = this.refit.markerAnchor(step, live)
      if (fromModule) return fromModule
    }
    const wheelMat = this.wheel.getTransform().getWorldTransform()
    let angleDeg = def.markerAngleDeg
    let radius = this.beadRadiusCm * this.tire.getTransform().getLocalScale().x
    if (def.markerAnchor === "valve") {
      // The valve lifts out with the tube in step 5; the deflate tick stays at the rim where the valve was.
      const valveLocal = this.valve.getTransform().getLocalPosition()
      const valveRadius = Math.sqrt(valveLocal.x * valveLocal.x + valveLocal.y * valveLocal.y)
      const pos = live
        ? this.valve.getTransform().getWorldPosition().add(new vec3(0, 0, this.markerStandoffCm))
        : wheelMat.multiplyPoint(new vec3(0, valveRadius, valveLocal.z + this.markerStandoffCm))
      return {pos, angleDeg: 0, radius: valveRadius}
    }
    if (def.markerAnchor === "tubeEnd" && this.tubeEnd && live) {
      // Step 5 is worked from the far side of the stand (-Z), so the ring stands off toward the user there.
      const pos = this.tubeEnd.getTransform().getWorldPosition().add(new vec3(0, 0, -this.markerStandoffCm))
      return {pos, angleDeg: 180, radius}
    }
    if (def.markerAnchor === "inspect" && this.thorn) {
      const pos = this.thorn.sceneObject.getTransform().getWorldPosition().add(new vec3(0, 0, this.markerStandoffCm))
      return {pos, angleDeg: this.thorn.currentAngleDeg, radius}
    }
    if (!live && def.tickAngleDeg !== undefined) angleDeg = def.tickAngleDeg
    if (def.markerAnchor === "bead" && step === 2 && live) {
      const nextBead = LOOSEN_BEADS.filter((i) => this.loosened.indexOf(i) < 0)[0]
      if (nextBead !== undefined) angleDeg = beadMidDeg(nextBead)
    }
    return {pos: wheelMat.multiplyPoint(this.radial(angleDeg, radius, this.markerStandoffCm + 2)), angleDeg, radius}
  }

  /** Deflate shrinks the tire AND the tube together so the tube stays inside the tire. */
  private setDeflated(on: boolean): void {
    const k = on ? this.deflateScale : 1
    if (this.tire) this.tire.getTransform().setLocalScale(new vec3(k, k, k))
    const tube = this.tube ? this.tube : findChild(this.wheel, "Tube")
    if (tube) tube.getTransform().setLocalScale(new vec3(k, k, k))
  }

  private radial(angleDeg: number, radius: number, z: number): vec3 {
    const a = (angleDeg * Math.PI) / 180
    return new vec3(Math.sin(a) * radius, Math.cos(a) * radius, z)
  }

  private setBeadOffset(i: number, radialCm: number): void {
    setBeadOffset(this.tire, i, radialCm)
  }

  private setEnabled(so: SceneObject | null, on: boolean): void {
    if (so && so.enabled !== on) so.enabled = on
  }

  private log(msg: string): void {
    if (this.debugLogs) print(`[RepairManager] ${msg}`)
  }
}
