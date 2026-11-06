/**
 * VoiceCoach — the coach's spoken lines (pass V). Thirty pre-generated clips, one per id
 * in StepDefinitions.voiceLines() (Assets/BenchCoach/Voice/<id>.mp3, ElevenLabs voice
 * "River"), played from one non-spatial AudioComponent: the coach in your ear.
 * When it speaks:
 *  - step-NN about 0.4 s after a step (1..10) becomes active, after the step's own cue;
 *    step 7 says "halfway" instead, step 11 says "finish";
 *  - mistake-<code> when CoachFeedback reports that mistake (it cuts off whatever plays);
 *  - idle-step-NN when IdleHint shows the step's hint;
 *  - floor-found once, when the start card's floor line turns to "Floor found";
 *  - the step's line again on Replay (RepairManager.onReplay).
 * Rules: one line at a time (a new line stops the old one); never the same line twice
 * within repeatGuardSec; nothing starts while ScanReveal sweeps (a queued line waits for
 * the heads to meet); while a line plays BenchCoachAudio ducks hiss, pump and zipper.
 * Voice off (the dock's More popover) stops the current line at once.
 * Logs `[Voice] <id> ms=<Date.now()> dur=<s>` when a line starts and
 * `[Voice] stop <id> ms=...` when one is cut off, so a silent screen recording's
 * soundtrack can be rebuilt offline.
 * Owns: the speaker, the queue, history. Must not: change steps or show UI.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {voiceLines, LAST_STEP, HALFWAY_STEP} from "./StepDefinitions"
import {RepairManager} from "./RepairManager"
import {BenchCoachAudio} from "./BenchCoachAudio"
import {CoachFeedback} from "./CoachFeedback"
import {IdleHint} from "./IdleHint"
import {ScanReveal} from "./ScanReveal"
import {BenchCoachStartCardUI} from "./BenchCoachStartCardUI"

interface Pending {
  id: string
  at: number
  why: string
}

export interface VoiceEvent {
  id: string
  /** getTime() when it started. */
  t: number
  /** Date.now() when it started. */
  ms: number
  why: string
}

function pad2(n: number): string {
  return n < 10 ? `0${n}` : `${n}`
}

@component
export class VoiceCoach extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">VoiceCoach – the spoken lines (pass V)</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine (step changes, Replay)")
  manager: RepairManager

  @input
  @hint("Speech player: a non-spatial AudioComponent (Audio/Voice)")
  speaker: AudioComponent

  @input
  @hint("The 30 voice clips (Assets/BenchCoach/Voice), matched to voiceLines() ids by asset name")
  tracks: AudioTrackAsset[]

  @input
  @allowUndefined
  @hint("Cue player: ducked while a line plays")
  audio: BenchCoachAudio

  @input
  @allowUndefined
  @hint("Mistakes (onMistake)")
  feedback: CoachFeedback

  @input
  @allowUndefined
  @hint("Idle hints (onHint)")
  idleHint: IdleHint

  @input
  @allowUndefined
  @hint("Scan reveal: nothing speaks during its sweep")
  scanReveal: ScanReveal

  @input
  @allowUndefined
  @hint("Start card: floor-found when its floor line turns to found")
  startCard: BenchCoachStartCardUI
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Speech volume (above the cues, which play at 0.25 to 0.5)")
  @widget(new SliderWidget(0, 1, 0.05))
  volume: number = 1.0

  @input
  @hint("Seconds after a step change before its line (after the step's own cue)")
  @widget(new SliderWidget(0, 2, 0.05))
  stepDelaySec: number = 0.4

  @input
  @hint("Seconds after the nope cue before a mistake's line")
  @widget(new SliderWidget(0, 1, 0.05))
  mistakeDelaySec: number = 0.25

  @input
  @hint("Seconds after the idle hint's chime before its line")
  @widget(new SliderWidget(0, 2, 0.05))
  hintDelaySec: number = 0.4

  @input
  @hint("A line never plays again within this many seconds of its last start")
  @widget(new SliderWidget(0, 20, 0.5))
  repeatGuardSec: number = 6

  @input
  @hint("Cue volume factor for hiss, pump and zipper while a line plays")
  @widget(new SliderWidget(0, 1, 0.05))
  duckFactor: number = 0.5

  @input
  @hint("Print a line for every start, stop and skip")
  debugLogs: boolean = true
  @ui.group_end

  /** Voice on (the More popover's toggle). */
  enabled: boolean = true
  /** The line playing now, or "". */
  speaking: string = ""
  /** Every line that started, in order (tests read it). */
  history: VoiceEvent[] = []
  /** Lines cut off early, in order. */
  stops: string[] = []
  /** Lines dropped by the repeat guard, in order. */
  skipped: string[] = []
  /** Ids from voiceLines() with no track (logged as an error at start). */
  missing: string[] = []

  private byId: {[id: string]: AudioTrackAsset} = {}
  private lastStart: {[id: string]: number} = {}
  private pending: Pending | null = null
  private startedAt = 0
  private ducked = false
  private floorSpoken = false
  private lastFloor = ""

  private _onEnabledChanged = new Event<boolean>()
  /** Voice turned on or off (by setEnabled). */
  onEnabledChanged: PublicApi<boolean> = this._onEnabledChanged.publicApi()

  onAwake(): void {
    this.indexTracks()
    if (this.speaker) {
      this.speaker.playbackMode = Audio.PlaybackMode.LowLatency
      this.speaker.volume = this.volume
      this.speaker.spatialAudio.enabled = false
    }
    this.createEvent("OnStartEvent").bind(() => this.onStart())
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  private onStart(): void {
    if (!this.manager || !this.speaker) {
      print("[VoiceCoach] ERROR: missing @input refs (manager, speaker)")
      return
    }
    this.manager.onStepChanged.add((s) => this.onStep(s))
    this.manager.onReplay.add((s) => this.onReplay(s))
    this.manager.onReset.add(() => this.cut("reset"))
    if (this.feedback) this.feedback.onMistake.add((m) => this.onMistake(m.code))
    if (this.idleHint) this.idleHint.onHint.add((s) => this.say(`idle-step-${pad2(s)}`, this.hintDelaySec, "idle hint"))
    // The wall clock and the Lens clock together, once: lets a recording's timeline be lined up.
    print(`[Sync] ms=${Date.now()} lensTime=${getTime().toFixed(3)}`)
  }

  /** Voice on or off; off stops the current line at once and drops the queue. */
  setEnabled(on: boolean): void {
    if (this.enabled === on) return
    this.enabled = on
    if (!on) this.cut("voice off")
    this.log(`voice ${on ? "on" : "off"}`)
    this._onEnabledChanged.invoke(on)
  }

  /** A line is playing or queued (watch mode holds its beat for it). */
  isBusy(): boolean {
    return this.speaking !== "" || this.pending !== null
  }

  /** The step's own line: step-NN, "halfway" on the halfway card, "finish" on the Finish card. */
  lineForStep(step: number): string {
    if (step === HALFWAY_STEP) return "halfway"
    if (step === LAST_STEP) return "finish"
    if (step >= 1 && step < LAST_STEP) return `step-${pad2(step)}`
    return ""
  }

  /** Speaks a line by id after `delaySec` (replacing anything queued). */
  say(id: string, delaySec: number = 0, why: string = ""): void {
    if (!this.enabled) return
    if (!this.byId[id]) {
      print(`[VoiceCoach] ERROR: no track for "${id}"`)
      return
    }
    this.pending = {id, at: getTime() + delaySec, why}
  }

  private onStep(step: number): void {
    const id = this.lineForStep(step)
    if (!id) {
      // Back on the start card: nothing to say; drop a queued line.
      this.pending = null
      return
    }
    this.say(id, this.stepDelaySec, `step ${step}`)
  }

  private onReplay(step: number): void {
    const id = this.lineForStep(step)
    if (id) this.say(id, 0, "replay")
  }

  private onMistake(code: string): void {
    if (!this.enabled) return
    // A mistake interrupts: the old line stops now, the reason follows the nope cue.
    this.cut("mistake")
    this.say(`mistake-${code}`, this.mistakeDelaySec, "mistake")
  }

  private tick(): void {
    // Floor found, once, while the start card shows it.
    if (this.startCard && !this.floorSpoken) {
      const status = this.startCard.floorStatus
      if (status !== this.lastFloor) {
        this.lastFloor = status
        if (status === "found") {
          this.floorSpoken = true
          if (this.startCard.sceneObject.isEnabledInHierarchy) this.say("floor-found", 0, "floor found")
        }
      }
    }
    // The current line ended by itself.
    if (this.speaking && getTime() - this.startedAt > 0.1 && !this.speaker.isPlaying()) {
      this.speaking = ""
    }
    // Start the queued line when its time comes, unless the scan reveal is sweeping.
    if (this.pending && getTime() >= this.pending.at && !this.sweeping()) {
      const p = this.pending
      this.pending = null
      this.start(p.id, p.why)
    }
    this.setDuck(this.speaking !== "")
  }

  private sweeping(): boolean {
    return !!this.scanReveal && this.scanReveal.playing && this.scanReveal.phase === "sweep"
  }

  private start(id: string, why: string): void {
    if (!this.enabled) return
    const now = getTime()
    const last = this.lastStart[id]
    if (last !== undefined && now - last < this.repeatGuardSec) {
      this.skipped.push(id)
      this.log(`skip ${id}: said ${(now - last).toFixed(1)} s ago (${why})`)
      return
    }
    if (this.speaking) this.cut(`new line ${id}`)
    const track = this.byId[id]
    this.speaker.audioTrack = track
    this.speaker.volume = this.volume
    this.speaker.play(1)
    this.speaking = id
    this.startedAt = now
    this.lastStart[id] = now
    const ms = Date.now()
    this.history.push({id, t: now, ms, why})
    print(`[Voice] ${id} ms=${ms} dur=${this.speaker.duration.toFixed(2)}`)
    if (this.debugLogs && why) print(`[VoiceCoach] ${id}: ${why}`)
  }

  /** Stops the line now (logged as a stop) and drops the queue. */
  private cut(why: string): void {
    this.pending = null
    if (!this.speaking) return
    const id = this.speaking
    this.speaking = ""
    if (this.speaker.isPlaying()) this.speaker.stop(false)
    this.stops.push(id)
    print(`[Voice] stop ${id} ms=${Date.now()}`)
    this.log(`stopped ${id}: ${why}`)
    // Pass P: the duck is lifted by tick() on the next update, never from here (cut() can
    // run inside another script's callback; under load the volume call timed out there).
  }

  /** Applied only from tick() (UpdateEvent), and only when the state changes. */
  private setDuck(on: boolean): void {
    if (on === this.ducked) return
    this.ducked = on
    if (this.audio) this.audio.setDuck(on ? this.duckFactor : 1)
  }

  private indexTracks(): void {
    const list = this.tracks ? this.tracks : []
    for (const t of list) if (t) this.byId[t.name] = t
    const ids = voiceLines().map((l) => l.id)
    this.missing = ids.filter((id) => !this.byId[id])
    if (this.missing.length > 0) print(`[VoiceCoach] ERROR: no voice track for ${this.missing.join(", ")}`)
    else this.log(`${ids.length} voice tracks, one per line`)
  }

  private log(msg: string): void {
    if (this.debugLogs) print(`[VoiceCoach] ${msg}`)
  }
}
