/**
 * RunStats — counts for the Finish card. leverMisses comes from the levers'
 * onRejected (a lever released away from its socket); hintsUsed counts
 * IdleHint.onHint; mistakes counts CoachFeedback.onMistake except the lever codes
 * (leverTooFar, leverBBeforeA), which are already lever misses.
 * UIBindings subscribes the two learning-layer events and calls noteHint() /
 * noteMistake(code), which keeps this script free of imports that would loop back
 * through RepairManager.
 * Not counted while `suspended` (watch mode).
 * Pass 11 (coach report): per-code mistake counts (lever codes included, for the
 * practice tip only), and seconds per repair step 1..10 from step entry to a
 * forward completion (RepairManager.goTo calls noteStep(from, to)), summed over
 * visits; a visit left by Back is not counted, jumpToStep never records, and entering step 0 clears the times. stepSeconds(),
 * slowestStep(), slowestSteps(k), practiceTip().
 * Owns: the counters only. RepairManager calls reset() on reset / Start over.
 * Must not: show anything — the Finish card is a passive view.
 * Expects: @inputs leverA, leverB (subscribed in OnStart).
 */
import {LeverPlacement} from "./LeverPlacement"
import {LAST_STEP, MISTAKE_STEPS, MISTAKE_TIPS, STEPS} from "./StepDefinitions"

/** Seconds as m:ss. */
export function formatMSS(seconds: number): string {
  const s = Math.max(0, Math.round(seconds))
  const m = Math.floor(s / 60)
  const r = s % 60
  return `${m}:${r < 10 ? "0" : ""}${r}`
}

/** Shown when the run had no mistakes and no timed step. */
export const PRACTICE_CLEAN = "Practice next: nothing stands out. Try a run with no hints."

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
  /** Watch mode (RepairDirector) sets this: the demo's actions are not the user's misses or hints. */
  suspended: boolean = false
  /** Coached mistakes per code this run, lever codes included (practice tip only). */
  mistakeCounts: {[code: string]: number} = {}
  /** Seconds per step (index = step id), -1 = not completed going forward this run. */
  private stepSec: number[] = []
  private stepEntry = 0

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => {
      if (this.leverA) this.leverA.onRejected.add(() => this.noteLeverMiss())
      if (this.leverB) this.leverB.onRejected.add(() => this.noteLeverMiss())
    })
  }

  private noteLeverMiss(): void {
    if (!this.suspended) this.leverMisses += 1
  }

  /** An idle hint was shown (IdleHint.onHint). */
  noteHint(): void {
    if (this.suspended) return
    this.hintsUsed += 1
  }

  /** A coached mistake (CoachFeedback.onMistake); lever codes are counted as lever misses instead. */
  noteMistake(code: string = ""): void {
    if (this.suspended) return
    if (code) this.mistakeCounts[code] = (this.mistakeCounts[code] ?? 0) + 1
    if (code.indexOf("lever") === 0) return
    this.mistakes += 1
  }

  /**
   * RepairManager.goTo: the step changed from `from` to `to`. A forward completion
   * (to = from + 1) of a repair step 1..10 records its time since entry; entering
   * step 0 clears the times. Every change restarts the entry clock.
   */
  noteStep(from: number, to: number): void {
    const now = getTime()
    if (to === 0) this.clearTimes()
    else if (!this.suspended && to === from + 1 && from >= 1 && from < LAST_STEP && this.stepEntry > 0) {
      // Accumulates over forward visits (Back, then Next again, adds the second visit).
      this.stepSec[from] = Math.max(0, this.stepSeconds(from)) + (now - this.stepEntry)
    }
    this.stepEntry = now
  }

  /** Seconds spent on `step` this run (summed over visits that ended going forward), or -1 if never completed going forward. */
  stepSeconds(step: number): number {
    const v = this.stepSec[step]
    return v === undefined ? -1 : v
  }

  /** The `k` slowest recorded work steps (rail-dot steps; the halfway card is reading, not work), slowest first. */
  slowestSteps(k: number): number[] {
    const ids: number[] = []
    for (const d of STEPS) if (d.railDot && this.stepSeconds(d.id) >= 0) ids.push(d.id)
    ids.sort((a, b) => this.stepSeconds(b) - this.stepSeconds(a))
    return ids.slice(0, Math.max(0, k))
  }

  /** The slowest recorded work step, or -1. */
  slowestStep(): number {
    const s = this.slowestSteps(1)
    return s.length > 0 ? s[0] : -1
  }

  /** The most frequent mistake code this run (first reached wins a tie), or "". */
  topMistake(): string {
    let best = ""
    let n = 0
    for (const code of Object.keys(this.mistakeCounts)) {
      if (this.mistakeCounts[code] > n) {
        best = code
        n = this.mistakeCounts[code]
      }
    }
    return best
  }

  /**
   * Pass S2: the step the Finish card's Practise button drills. The step of the most
   * frequent mistake (MISTAKE_STEPS), else the slowest timed step, else -1 (nothing
   * was timed, as in a Watch run from the start card: no button).
   */
  practiseStep(): number {
    const code = this.topMistake()
    if (code && MISTAKE_STEPS[code] !== undefined) return MISTAKE_STEPS[code]
    return this.slowestStep()
  }

  /** One line: the tip for the most frequent mistake, else the slowest step, else a positive line. */
  practiceTip(): string {
    const code = this.topMistake()
    if (code && MISTAKE_TIPS[code]) return MISTAKE_TIPS[code]
    const slow = this.slowestStep()
    if (slow >= 0) return `Practice next: ${STEPS[slow].name}, your slowest step at ${formatMSS(this.stepSeconds(slow))}`
    return PRACTICE_CLEAN
  }

  reset(): void {
    this.leverMisses = 0
    this.hintsUsed = 0
    this.mistakes = 0
    this.mistakeCounts = {}
    this.clearTimes()
  }

  private clearTimes(): void {
    this.stepSec = []
    this.stepEntry = 0
  }

  snapshot(): RunStatsSnapshot {
    return {leverMisses: this.leverMisses, hintsUsed: this.hintsUsed, mistakes: this.mistakes}
  }
}
