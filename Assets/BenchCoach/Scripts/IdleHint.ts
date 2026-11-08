/**
 * IdleHint — when nothing has happened for idleSec on a step with a label, shows
 * the step's `hint` on the label, boosts the marker pulse and chimes from the
 * marker. Fires once per quiet spell; any progress starts a new one.
 * Resets on a step or sub-step change, on touch() (UIBindings calls it on every
 * control-bar press, and on a mistake), and while anything is held or tweening (a
 * lever, the new tube end, the tube end), so a slow drag never counts as idle.
 * Suspended while `suspended` is set (watch mode, pass 10), while `askSuspended` is
 * set (Ask the coach is open, pass 12) or step interactions are paused (What's this?).
 * Owns: the idle timer and the hint counters. Emits onHint(step).
 * SetEffectiveDelay() sets the delay for the current step (AdaptiveCoach: 6 s
 * where the user struggled, 24 s where they have it); 0 or less goes back to idleSec.
 * Must not: change steps. The label goes back to the step label through
 * RepairManager.refreshLabel().
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {RepairManager} from "./RepairManager"
import {BenchCoachStepLabelUI} from "./BenchCoachStepLabelUI"
import {StepMarker} from "./StepMarker"
import {BenchCoachAudio} from "./BenchCoachAudio"
import {LeverPlacement} from "./LeverPlacement"
import {TubeFit} from "./TubeFit"
import {TubePull} from "./TubePull"
import {STEPS} from "./StepDefinitions"

@component
export class IdleHint extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">IdleHint – a hint after a quiet spell</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine (step, sub-step, label restore)")
  manager: RepairManager

  @input
  @hint("Step label panel (shows the hint)")
  stepLabel: BenchCoachStepLabelUI

  @input
  @hint("Marker ring (pulse boost)")
  stepMarker: StepMarker

  @input
  @hint("Cue player (chime at the marker)")
  audio: BenchCoachAudio

  @input
  @hint("Lever A: no idle while it is grabbed or tweening")
  leverA: LeverPlacement

  @input
  @hint("Lever B: no idle while it is grabbed or tweening")
  leverB: LeverPlacement

  @input
  @hint("New tube end: no idle while it is held")
  tubeFit: TubeFit

  @input
  @hint("Tube end: no idle while it is held")
  tubePull: TubePull
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Seconds without progress before the hint shows")
  @widget(new SliderWidget(1, 60, 1))
  idleSec: number = 12

  @input
  @hint("Seconds the marker pulses bigger after a hint")
  @widget(new SliderWidget(0, 10, 0.5))
  boostSec: number = 4
  @ui.group_end

  /** Hints shown since the Lens started (tests read deltas). */
  hintCount: number = 0
  /** True while the hint text is on the label. */
  showing: boolean = false
  /** Watch mode (pass 10) sets this; no hints while true. */
  suspended: boolean = false
  /** Ask the coach (pass 12) sets this while it is open; no hints while true. */
  askSuspended: boolean = false
  /** Step the last hint fired on (-1 = none). */
  lastHintStep: number = -1

  private _onHint = new Event<number>()
  onHint: PublicApi<number> = this._onHint.publicApi()

  private quietSince = 0
  private fired = false
  /** Seconds set by setEffectiveDelay (0 = use idleSec). */
  private delayOverride = 0
  private lastStep = -1
  private lastSub = -1

  onAwake(): void {
    this.quietSince = getTime()
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** The delay before the hint on this step; 0 or less restores idleSec. */
  setEffectiveDelay(sec: number): void {
    this.delayOverride = sec > 0 ? sec : 0
  }

  /** The seconds of quiet the current step waits before its hint. */
  effectiveDelay(): number {
    return this.delayOverride > 0 ? this.delayOverride : this.idleSec
  }

  /** Something happened: start a new quiet spell (and take a shown hint down). */
  touch(): void {
    this.quietSince = getTime()
    this.fired = false
    if (this.showing) {
      this.showing = false
      if (this.manager) this.manager.refreshLabel()
    }
  }

  private tick(): void {
    if (!this.manager) return
    const state = this.manager.getState()
    if (state.step !== this.lastStep) {
      // The manager rewrote the label for the new step.
      this.lastStep = state.step
      this.lastSub = state.subStep
      this.showing = false
      this.quietSince = getTime()
      this.fired = false
      return
    }
    if (state.subStep !== this.lastSub) {
      this.lastSub = state.subStep
      this.touch()
      return
    }
    if (this.suspended || this.askSuspended || this.manager.interactionsPaused || this.anyBusy() || !this.eligible(state.step)) {
      this.quietSince = getTime()
      return
    }
    if (!this.fired && getTime() - this.quietSince >= this.effectiveDelay()) this.fire(state.step)
  }

  /** Only steps with a visible step label get hints (the cards have their own buttons). */
  private eligible(step: number): boolean {
    const def = STEPS[step]
    return def.markerAnchor !== "none" && !!this.stepLabel && this.stepLabel.sceneObject.isEnabledInHierarchy
  }

  private fire(step: number): void {
    this.fired = true
    this.showing = true
    this.hintCount += 1
    this.lastHintStep = step
    this.stepLabel.showHint(STEPS[step].hint)
    if (this.stepMarker) {
      this.stepMarker.pulseBoost(this.boostSec)
      if (this.audio && this.stepMarker.sceneObject.enabled) {
        this.audio.playChimeAt(this.stepMarker.sceneObject.getTransform().getWorldPosition())
      }
    }
    print(`[IdleHint] step ${step}: "${STEPS[step].hint}"`)
    this._onHint.invoke(step)
  }

  private anyBusy(): boolean {
    if (this.leverA && this.leverA.isBusy()) return true
    if (this.leverB && this.leverB.isBusy()) return true
    if (this.tubeFit && this.tubeFit.isBusy()) return true
    if (this.tubePull && this.tubePull.isHeld()) return true
    return false
  }
}
