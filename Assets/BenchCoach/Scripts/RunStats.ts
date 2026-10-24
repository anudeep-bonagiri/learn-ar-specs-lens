/**
 * RunStats — counts for the Finish card. leverMisses comes from the levers'
 * onRejected (a lever released away from its socket); hintsUsed is bumped by
 * RepairManager when Replay shows a step again (pass 8's idle hints add to it);
 * mistakes counts other misses (a new-tube end released away from the valve; pass
 * 8's CoachFeedback adds its mistake codes).
 * Owns: the counters only. RepairManager calls reset() on reset / Start over.
 * Must not: show anything — the Finish card is a passive view.
 * Expects: @inputs leverA, leverB, tubeFit (subscribed in OnStart).
 */
import {LeverPlacement} from "./LeverPlacement"
import {TubeFit} from "./TubeFit"

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

  @input
  @hint("New-tube fit handle (a miss counts as a mistake)")
  @allowUndefined
  tubeFit: TubeFit
  @ui.group_end

  leverMisses: number = 0
  hintsUsed: number = 0
  mistakes: number = 0

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => {
      if (this.leverA) this.leverA.onRejected.add(() => (this.leverMisses += 1))
      if (this.leverB) this.leverB.onRejected.add(() => (this.leverMisses += 1))
      if (this.tubeFit) this.tubeFit.onRejected.add(() => (this.mistakes += 1))
    })
  }

  noteHint(): void {
    this.hintsUsed += 1
  }

  noteMistake(): void {
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
