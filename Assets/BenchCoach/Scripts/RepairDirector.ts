/**
 * RepairDirector — watch mode (pass 10). play() runs the whole repair from the
 * current step to the Finish card, one WATCH_BEATS beat per step: wait on the step
 * so its label can be read, then act through the step's own public controls (a valve
 * or bead pinch without a hand, a lever flying into its socket, the rim sweep, the
 * tube pull, the cause found, RefitSteps.demo). The step's own events advance
 * RepairManager; the director never touches its private state. If a step does not
 * advance within its budget the director calls next() and counts a fallback.
 * Stops on: stop() (UIBindings calls it before every button press, so any control-bar
 * press, Back, Start over or Restart), a lever / tube end / new tube end grabbed by a
 * hand, and reaching LAST_STEP (onFinished). While playing, IdleHint and RunStats are
 * suspended and What's this? is turned off.
 * Owns: the beat cursor and timers. Must not: author UI or change step state directly.
 * Expects: @inputs as listed (all on BenchCoach and the wheel parts).
 * Pass V: a beat's wait also lasts until the voice coach has said its line (at most
 * voiceHoldMaxSec more), so watch mode, the video's main take, never cuts a line off.
 * Known limit: a tube pull or lever flight already under way finishes after stop()
 * (they are short); a sweep and the refit demos stop where they are.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {LAST_STEP, LOOSEN_BEADS} from "./StepDefinitions"
import {
  WATCH_BEAD_GAP_SEC,
  WATCH_BEATS,
  WATCH_PLACE_SEC,
  WATCH_PULL_SEC,
  WATCH_SWEEP_SEC,
  WATCH_TIMEOUT_PAD_SEC,
  WatchBeat,
} from "./WatchPlan"
import {RepairManager} from "./RepairManager"
import {WheelTargets} from "./WheelTargets"
import {LeverPlacement} from "./LeverPlacement"
import {RimDrag} from "./RimDrag"
import {TubePull} from "./TubePull"
import {ThornHotspot} from "./ThornHotspot"
import {RefitSteps} from "./RefitSteps"
import {TubeFit} from "./TubeFit"
import {IdleHint} from "./IdleHint"
import {RunStats} from "./RunStats"
import {PartInfo} from "./PartInfo"
import {VoiceCoach} from "./VoiceCoach"

type Phase = "wait" | "act"

@component
export class RepairDirector extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">RepairDirector – watch mode, steps 1 to 11</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine (read step, next() on the halfway card)")
  manager: RepairManager

  @input
  @hint("Valve and bead pinch targets (pinchValve / pinchBead)")
  wheelTargets: WheelTargets

  @input
  @hint("Lever A (flies into socket A on step 3)")
  leverA: LeverPlacement

  @input
  @hint("Lever B (flies into socket B on step 4, then sweeps)")
  leverB: LeverPlacement

  @input
  @hint("Rim drag on lever B (playSweep)")
  rimDrag: RimDrag

  @input
  @hint("Tube pull on TubeEnd (playPull)")
  tubePull: TubePull

  @input
  @hint("Flat-cause hotspot (flash, findInstant)")
  thorn: ThornHotspot

  @input
  @hint("Steps 8..10 module (demo, stopDemo)")
  refit: RefitSteps

  @input
  @hint("New tube end: a hand grab stops watch mode")
  tubeFit: TubeFit

  @input
  @allowUndefined
  @hint("Idle hints: suspended while playing")
  idle: IdleHint

  @input
  @allowUndefined
  @hint("Run counters: suspended while playing")
  stats: RunStats

  @input
  @allowUndefined
  @hint("What's this? mode: turned off when watch mode starts")
  partInfo: PartInfo

  @input
  @allowUndefined
  @hint("Voice coach: each beat waits for its line to finish (pass V)")
  voice: VoiceCoach
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Multiplies every beat's reading pause (1 = about 60 s end to end)")
  @widget(new SliderWidget(0.25, 3, 0.05))
  waitScale: number = 1

  @input
  @hint("Most extra seconds a beat waits for the voice coach's line")
  @widget(new SliderWidget(0, 8, 0.5))
  voiceHoldMaxSec: number = 4

  @input
  @hint("Print beats to the log")
  debugLogs: boolean = true
  @ui.group_end

  /** True while watch mode runs. */
  playing: boolean = false
  /** Index into WATCH_BEATS of the current beat (its step), -1 before the first. */
  beatIndex: number = -1
  /** Times a step did not advance on its own and the director called next(). Should stay 0. */
  fallbacks: number = 0
  playCount: number = 0
  /** getTime() of the last play() (tests check the Watch press latency). */
  lastPlayTime: number = 0
  stopCount: number = 0
  /** Why the last run ended: "finished", "stop", "grab". */
  lastStopReason: string = ""

  private _onFinished = new Event<void>()
  onFinished: PublicApi<void> = this._onFinished.publicApi()

  private beatStep = -1
  private phase: Phase = "wait"
  private timer = 0
  private actBudget = 0
  private beadQueue: number[] = []
  private beadTimer = 0
  private sweepStarted = false

  onAwake(): void {
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Start (or resume) watch mode from the current step; on the start card it presses Found it first. */
  play(): void {
    if (!this.ready()) return
    if (this.playing) return
    const step = this.manager.getState().step
    if (step >= LAST_STEP) return
    if (this.partInfo) this.partInfo.setActive(false)
    if (step === 0) this.manager.foundIt()
    this.playing = true
    this.playCount += 1
    this.lastPlayTime = getTime()
    this.beatStep = -1
    this.setSuspended(true)
    this.log(`play from step ${this.manager.getState().step}`)
  }

  /** Stop watch mode where it is; the user carries on by hand. */
  stop(): void {
    this.halt("stop")
  }

  private halt(reason: string): void {
    if (!this.playing) return
    this.playing = false
    this.stopCount += 1
    this.lastStopReason = reason
    this.beadQueue = []
    this.rimDrag.stopSweep()
    this.refit.stopDemo()
    this.setSuspended(false)
    this.log(`stopped (${reason}) on step ${this.manager.getState().step}`)
  }

  private finish(): void {
    this.halt("finished")
    this._onFinished.invoke()
  }

  private setSuspended(on: boolean): void {
    if (this.idle) {
      this.idle.suspended = on
      if (!on) this.idle.touch()
    }
    if (this.stats) this.stats.suspended = on
  }

  private ready(): boolean {
    const ok =
      this.manager && this.wheelTargets && this.leverA && this.leverB && this.rimDrag && this.tubePull && this.thorn && this.refit && this.tubeFit
    if (!ok) print("[RepairDirector] ERROR: missing @input refs")
    return !!ok
  }

  private userGrabbed(): boolean {
    return this.leverA.grabbed || this.leverB.grabbed || this.tubePull.isHeld() || this.tubeFit.grabbed
  }

  private tick(): void {
    if (!this.playing) return
    if (this.userGrabbed()) {
      this.halt("grab")
      return
    }
    const step = this.manager.getState().step
    if (step >= LAST_STEP) {
      this.finish()
      return
    }
    if (step !== this.beatStep) this.beginBeat(step)
    const beat = WATCH_BEATS[this.beatIndex]
    this.timer += getDeltaTime()
    if (this.phase === "wait") {
      const wait = beat.waitSec * this.waitScale
      const voiceHold = !!this.voice && this.voice.isBusy() && this.timer - wait < this.voiceHoldMaxSec
      if (this.timer >= wait && !voiceHold) {
        this.phase = "act"
        this.timer = 0
        this.act(beat)
      }
      return
    }
    this.continueAct(beat)
    if (this.timer > this.actBudget + WATCH_TIMEOUT_PAD_SEC) {
      this.fallbacks += 1
      print(`[RepairDirector] WARNING: step ${step} did not advance after ${this.timer.toFixed(1)} s; calling next()`)
      this.beatStep = -1
      this.manager.next()
    }
  }

  private beginBeat(step: number): void {
    this.beatStep = step
    this.beatIndex = Math.max(0, Math.min(WATCH_BEATS.length - 1, step))
    this.phase = "wait"
    this.timer = 0
    this.beadQueue = []
    this.sweepStarted = false
    const beat = WATCH_BEATS[this.beatIndex]
    // The search step: the glint flashes while the label is read, then it is found.
    if (beat.action === "find") this.thorn.flash()
    this.log(`beat ${this.beatIndex}: ${beat.action} after ${(beat.waitSec * this.waitScale).toFixed(1)} s`)
  }

  private act(beat: WatchBeat): void {
    this.actBudget = beat.actSec
    switch (beat.action) {
      case "next":
        this.manager.next()
        break
      case "valve":
        this.wheelTargets.pinchValve()
        break
      case "beads": {
        const done = this.manager.getLoosenedBeads()
        this.beadQueue = LOOSEN_BEADS.filter((i) => done.indexOf(i) < 0)
        this.beadTimer = WATCH_BEAD_GAP_SEC
        break
      }
      case "hookA":
        this.leverA.playPlace(WATCH_PLACE_SEC)
        break
      case "sweep":
        this.leverB.playPlace(WATCH_PLACE_SEC)
        break
      case "pull":
        this.tubePull.playPull(WATCH_PULL_SEC)
        break
      case "find":
        this.thorn.findInstant()
        break
      case "demo":
        this.actBudget = Math.max(beat.actSec, this.refit.demo(beat.step))
        break
      default:
        break
    }
  }

  private continueAct(beat: WatchBeat): void {
    if (beat.action === "beads" && this.beadQueue.length > 0) {
      this.beadTimer += getDeltaTime()
      if (this.beadTimer >= WATCH_BEAD_GAP_SEC) {
        this.beadTimer = 0
        this.wheelTargets.pinchBead(this.beadQueue.shift())
      }
    } else if (beat.action === "sweep" && !this.sweepStarted && this.rimDrag.armed && !this.rimDrag.complete) {
      // Lever B is hooked (its onPlaced armed the rim drag): slide it round.
      this.sweepStarted = this.rimDrag.playSweep(WATCH_SWEEP_SEC)
    }
  }

  private log(msg: string): void {
    if (this.debugLogs) print(`[RepairDirector] ${msg}`)
  }
}
