/**
 * AdaptiveCoach — when a step is completed its score moves 40% of the way toward a reward target (1 clean, 0.5 one slip or slow, 0 two or more slips), and the score's level sets how much the coach helps on that step next time.
 *
 * Scores for repair steps 1..10 start at 0.5. A completion is a forward step change
 * n -> n+1 (Next included) or a Practise rep (onRepDone). Slips are RunStats' lever misses,
 * mistakes and hints on the step; slow is past STEPS[n].parSec. Back, Replay and Watch mode
 * change nothing. Mastered at s >= 0.75, struggling at s <= 0.35. On entering a step:
 * the idle hint delay (6 / 12 / 24 s), the ghost lever (struggling loops until placed,
 * mastered hides 3 s in) and whether the idle hint is spoken (not on mastered steps).
 * Scores and the run count (+1 per run on reaching the Finish card) are stored under
 * bc.adapt.* in the persistent store, else in a session map. Must not: change steps.
 */
import {RepairManager} from "./RepairManager"
import {RunStats} from "./RunStats"
import {IdleHint} from "./IdleHint"
import {GhostAnimator} from "./GhostAnimator"
import {VoiceCoach} from "./VoiceCoach"
import {BenchCoachStartCardUI} from "./BenchCoachStartCardUI"
import {BenchCoachFinishCardUI} from "./BenchCoachFinishCardUI"
import {LAST_STEP, PRACTISE_NAMES, STEPS} from "./StepDefinitions"

export type CoachLevel = "mastered" | "normal" | "struggling"

const FIRST = 1
const LAST = 10
const START_SCORE = 0.5
const RATE = 0.4
const KEY = "bc.adapt."
/** Idle hint delays (s) on a struggling and a mastered step; seconds before a mastered step's ghost goes. */
const STRUGGLE_HINT_SEC = 6
const MASTERED_HINT_SEC = 24
const MASTERED_GHOST_SEC = 3
/** Used when the persistent store is not available: kept for the session only. */
const SESSION: {[key: string]: number} = {}

@component
export class AdaptiveCoach extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">AdaptiveCoach – the coach adapts per step</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine (step changes, drill reps)")
  manager: RepairManager
  @input
  @hint("Run counters (slips per step)")
  stats: RunStats
  @input
  @allowUndefined
  @hint("Idle hint (its delay per step)")
  idleHint: IdleHint
  @input
  @allowUndefined
  @hint("Ghost lever (loop or hide per step)")
  ghost: GhostAnimator
  @input
  @allowUndefined
  @hint("Voice (idle hint spoken or not)")
  voice: VoiceCoach
  @input
  @allowUndefined
  @hint("Start card (the run line)")
  startCard: BenchCoachStartCardUI
  @input
  @allowUndefined
  @hint("Finish card (the coach memory line)")
  finishCard: BenchCoachFinishCardUI
  @ui.group_end

  /** True when the scores live in the persistent store (false: the session map). */
  persistent: boolean = false

  private scores: number[] = []
  private runs = 0
  private store: GeneralDataStore | null = null
  private lastStep = 0
  private enteredAt = 0
  private slipsAtEntry = 0
  private countedRun = false
  private hideGhostAt = 0

  onAwake(): void {
    this.openStore()
    this.load()
    this.createEvent("OnStartEvent").bind(() => {
      if (!this.manager || !this.stats) {
        print("[AdaptiveCoach] ERROR: missing @input refs (manager, stats)")
        return
      }
      this.manager.onStepChanged.add((s) => this.onStep(s))
      this.manager.onRepDone.add((s) => this.complete(s))
      this.lastStep = this.manager.getState().step
      this.pushRunLine()
    })
    this.createEvent("UpdateEvent").bind(() => {
      // A mastered step: the ghost goes once it has shown the motion (also after a re-apply).
      if (this.hideGhostAt > 0 && getTime() >= this.hideGhostAt && this.ghost && this.ghost.sceneObject.enabled) {
        this.ghost.sceneObject.enabled = false
      }
    })
  }

  scoreOf(step: number): number {
    return step >= FIRST && step <= LAST ? this.scores[step] : START_SCORE
  }
  levelOf(step: number): CoachLevel {
    const s = this.scoreOf(step)
    return s >= 0.75 ? "mastered" : s <= 0.35 ? "struggling" : "normal"
  }

  runCount(): number {
    return this.runs
  }
  /** "lever A needs help; deflate and loosen are yours." or "nothing stands out yet." */
  summary(): string {
    const help: string[] = []
    const yours: string[] = []
    for (let s = FIRST; s <= LAST; s++) {
      const name = PRACTISE_NAMES[s]
      if (!name) continue
      if (this.levelOf(s) === "struggling") help.push(name)
      else if (this.levelOf(s) === "mastered") yours.push(name)
    }
    const parts: string[] = []
    if (help.length > 0) parts.push(`${joinNames(help)} ${help.length === 1 ? "needs" : "need"} help`)
    if (yours.length > 0) parts.push(`${joinNames(yours)} ${yours.length === 1 ? "is" : "are"} yours`)
    return parts.length > 0 ? `${parts.join("; ")}.` : "nothing stands out yet."
  }

  /** Every score back to 0.5 and the run count to 0 (stored). */
  forget(): void {
    for (let s = FIRST; s <= LAST; s++) this.scores[s] = START_SCORE
    this.runs = 0
    this.countedRun = false
    this.save()
    this.applyLevel(this.manager ? this.manager.getState().step : 0)
    this.pushRunLine()
    print("[AdaptiveCoach] coach memory cleared")
  }

  private onStep(step: number): void {
    const from = this.lastStep
    this.lastStep = step
    if (step === from + 1) this.complete(from)
    // A new run starts on the start card (a drill's own resets pass through it too).
    if (step === 0 && !this.manager.drill && !this.manager.quietStep) {
      this.countedRun = false
      this.pushRunLine()
    }
    if (step === LAST_STEP && !this.manager.quietStep && !this.countedRun) {
      this.countedRun = true
      this.runs += 1
      this.save()
      print(`[AdaptiveCoach] run ${this.runs} finished`)
    }
    if (step === LAST_STEP && this.finishCard) this.finishCard.setMemory(`Coach memory: ${this.summary()}`)
    this.enteredAt = getTime()
    this.slipsAtEntry = this.slips()
    this.applyLevel(step)
  }

  /** Step `step` was completed: move its score toward the reward target. */
  private complete(step: number): void {
    if (step < FIRST || step > LAST || this.stats.suspended) return
    const slips = Math.max(0, this.slips() - this.slipsAtEntry)
    const secs = getTime() - this.enteredAt
    const par = STEPS[step].parSec ?? 15
    const target = slips >= 2 ? 0 : slips === 1 || secs > par ? 0.5 : 1
    const before = this.scores[step]
    this.scores[step] = before + RATE * (target - before)
    this.save()
    print(`[AdaptiveCoach] step ${step}: ${slips} slips, ${secs.toFixed(1)} s (par ${par}), target ${target}, score ${before.toFixed(2)} -> ${this.scores[step].toFixed(2)} (${this.levelOf(step)})`)
  }

  private slips(): number {
    return this.stats.leverMisses + this.stats.mistakes + this.stats.hintsUsed
  }

  /** The three settings for the step just entered (normal on cards and steps without a score). */
  private applyLevel(step: number): void {
    const level = step >= FIRST && step <= LAST ? this.levelOf(step) : "normal"
    const def = STEPS[step]
    if (this.idleHint) {
      this.idleHint.setEffectiveDelay(level === "struggling" ? STRUGGLE_HINT_SEC : level === "mastered" ? MASTERED_HINT_SEC : 0)
    }
    if (this.voice) this.voice.quietIdleHint = level === "mastered"
    if (this.ghost) this.ghost.setLoop(level === "struggling" && def.showGhost)
    this.hideGhostAt = level === "mastered" && def.showGhost ? getTime() + MASTERED_GHOST_SEC : 0
    if (level !== "normal") print(`[AdaptiveCoach] step ${step} is ${level} (score ${this.scoreOf(step).toFixed(2)})`)
  }

  private pushRunLine(): void {
    if (!this.startCard) return
    const n = this.runs + 1
    this.startCard.setRunLine(n >= 2 ? `Run ${n}. I'll go quiet on the steps you've got and help sooner where you struggled.` : "")
  }

  private openStore(): void {
    try {
      this.store = global.persistentStorageSystem ? global.persistentStorageSystem.store : null
    } catch (e) {
      this.store = null
    }
    this.persistent = this.store !== null
    if (!this.persistent) print("[AdaptiveCoach] no persistent store here: coach memory is kept for this session only")
  }

  private load(): void {
    for (let s = FIRST; s <= LAST; s++) {
      this.scores[s] = Math.max(0, Math.min(1, this.read(`${KEY}s${s}`, false) ?? START_SCORE))
    }
    this.runs = Math.max(0, Math.round(this.read(`${KEY}runs`, true) ?? 0))
    const list = this.scores.slice(FIRST).map((v) => v.toFixed(2)).join(" ")
    print(`[AdaptiveCoach] loaded (${this.persistent ? "persistent store" : "session"}): runs ${this.runs}, scores ${list}`)
  }

  private read(key: string, isInt: boolean): number | null {
    try {
      if (this.store) return !this.store.has(key) ? null : isInt ? this.store.getInt(key) : this.store.getFloat(key)
    } catch (e) {
      this.fallBack(e)
    }
    return SESSION[key] !== undefined ? SESSION[key] : null
  }

  private save(): void {
    for (let s = FIRST; s <= LAST; s++) SESSION[`${KEY}s${s}`] = this.scores[s]
    SESSION[`${KEY}runs`] = this.runs
    if (!this.store) return
    try {
      for (let s = FIRST; s <= LAST; s++) this.store.putFloat(`${KEY}s${s}`, this.scores[s])
      this.store.putInt(`${KEY}runs`, this.runs)
    } catch (e) {
      this.fallBack(e)
    }
  }

  private fallBack(e: unknown): void {
    this.store = null
    this.persistent = false
    print(`[AdaptiveCoach] persistent store failed (${e}): coach memory is kept for this session only`)
  }
}

/** "a", "a and b", "a, b and c". */
function joinNames(names: string[]): string {
  if (names.length <= 1) return names.join("")
  return `${names.slice(0, -1).join(", ")} and ${names[names.length - 1]}`
}
