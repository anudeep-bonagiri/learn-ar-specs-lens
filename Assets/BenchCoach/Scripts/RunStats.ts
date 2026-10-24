/**
 * RunStats — counts for the Finish card. leverMisses comes from the levers'
 * onRejected (a lever released away from its socket); hintsUsed counts
 * IdleHint.onHint; mistakes counts CoachFeedback.onMistake except the lever codes
 * (leverTooFar, leverBBeforeA), which are already lever misses.
 * UIBindings subscribes the two learning-layer events and calls noteHint() /
 * noteMistake(code), which keeps this script free of imports that would loop back
 * through RepairManager.
 * Owns: the counters only. RepairManager calls reset() on reset / Start over.
 * Must not: show anything — the Finish card is a passive view.
 * Expects: @inputs leverA, leverB (subscribed in OnStart).
 */
import {LeverPlacement} from "./LeverPlacement"

export interface RunStatsSnapshot {
  leverMisses: number
  hintsUsed: number
  mistakes: number
}

@component
export class RunStats extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">RunStats – counts for the Finish card</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Lever A placement (its misses count)")
  leverA: LeverPlacement

  @input
  @hint("Lever B placement (its misses count)")
  leverB: LeverPlacement
  @ui.group_end

  leverMisses: number = 0
  hintsUsed: number = 0
  mistakes: number = 0

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => {
      if (this.leverA) this.leverA.onRejected.add(() => (this.leverMisses += 1))
      if (this.leverB) this.leverB.onRejected.add(() => (this.leverMisses += 1))
    })
  }

  /** An idle hint was shown (IdleHint.onHint). */
  noteHint(): void {
    this.hintsUsed += 1
  }

  /** A coached mistake (CoachFeedback.onMistake); lever codes are counted as lever misses instead. */
  noteMistake(code: string = ""): void {
    if (code.indexOf("lever") === 0) return
    this.mistakes += 1
  }

  reset(): void {
    this.leverMisses = 0
    this.hintsUsed = 0
    this.mistakes = 0
  }

  snapshot(): RunStatsSnapshot {
    return {leverMisses: this.leverMisses, hintsUsed: this.hintsUsed, mistakes: this.mistakes}
  }
}
