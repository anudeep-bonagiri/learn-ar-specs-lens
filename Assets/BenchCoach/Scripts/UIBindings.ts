/**
 * UIBindings — subscribes to every UI module's button events and calls
 * RepairManager, and wires the learning-layer events into RunStats (hints from
 * IdleHint.onHint, mistakes from CoachFeedback.onMistake) and BtnWhatsThis into
 * PartInfo. Owns: nothing but the subscriptions.
 * Plays the tick cue from the pressed panel; every press touches IdleHint and
 * first stops watch mode (RepairDirector.stop()); the start card's Watch button
 * presses Found it and then starts watch mode. Pass 12: BtnAsk toggles AskCoach;
 * Ask and What's this? are mutually exclusive (turning one on turns the other off).
 * Pass D2: pushes the dock's progress ("4 / 10") on every step, shows the watch pill
 * while watch mode plays (its Stop is a press like any other), closes the More popover
 * on a step change, and keeps the start card's floor line in step with FloorLevel
 * ("Look down at your work spot" until it decides, then found or fallback).
 * Expects: @inputs manager, startCard, controlBar, doneCard, finishCard, audio (wired in the scene).
 */
import {RepairManager} from "./RepairManager"
import {BenchCoachStartCardUI} from "./BenchCoachStartCardUI"
import {BenchCoachControlBarUI} from "./BenchCoachControlBarUI"
import {BenchCoachDoneCardUI} from "./BenchCoachDoneCardUI"
import {BenchCoachFinishCardUI} from "./BenchCoachFinishCardUI"
import {BenchCoachWatchBadgeUI} from "./BenchCoachWatchBadgeUI"
import {VoiceCoach} from "./VoiceCoach"
import {BenchCoachAudio} from "./BenchCoachAudio"
import {IdleHint} from "./IdleHint"
import {RunStats} from "./RunStats"
import {PartInfo} from "./PartInfo"
import {CoachFeedback} from "./CoachFeedback"
import {RepairDirector} from "./RepairDirector"
import {AskCoach} from "./AskCoach"
import {FloorLevel} from "./FloorLevel"

@component
export class UIBindings extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">UIBindings – buttons to RepairManager</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine")
  manager: RepairManager

  @input
  @hint("Start card (Found it)")
  startCard: BenchCoachStartCardUI

  @input
  @hint("Control bar (Back / Next / Replay)")
  controlBar: BenchCoachControlBarUI

  @input
  @hint("Done card (Continue, Start over)")
  doneCard: BenchCoachDoneCardUI

  @input
  @allowUndefined
  @hint("Finish card (Restart)")
  finishCard: BenchCoachFinishCardUI

  @input
  @hint("Cue player (tick)")
  audio: BenchCoachAudio

  @input
  @allowUndefined
  @hint("Idle hints: every press starts a new quiet spell; each hint counts on RunStats")
  idle: IdleHint

  @input
  @allowUndefined
  @hint("Run counters (hints from IdleHint.onHint, mistakes from CoachFeedback.onMistake)")
  stats: RunStats

  @input
  @allowUndefined
  @hint("What's this? mode (BtnWhatsThis toggles it)")
  partInfo: PartInfo

  @input
  @allowUndefined
  @hint("Mistake feedback (each mistake counts on RunStats and starts a new idle spell)")
  feedback: CoachFeedback

  @input
  @allowUndefined
  @hint("Watch mode: every press stops it first; BtnWatch starts it")
  director: RepairDirector

  @input
  @allowUndefined
  @hint("Ask the coach: BtnAsk toggles it; exclusive with What's this?")
  askCoach: AskCoach

  @input
  @allowUndefined
  @hint("Floor measurement: the start card's floor line follows it")
  floorLevel: FloorLevel

  @input
  @allowUndefined
  @hint("Voice coach: BtnVoice in the More popover turns it on and off (pass V)")
  voice: VoiceCoach

  @input
  @allowUndefined
  @hint("Pass V: the in-frame 'Watching' badge above the wheel (its Stop is a press like the pill's)")
  watchBadge: BenchCoachWatchBadgeUI
  @ui.group_end

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => {
      if (!this.manager || !this.startCard || !this.controlBar || !this.doneCard) {
        print("[UIBindings] ERROR: missing @input refs")
        return
      }
      this.startCard.onFoundIt.add(() => this.press(this.startCard, "BtnFoundIt", () => this.manager.foundIt()))
      if (this.director) {
        this.startCard.onWatch.add(() =>
          this.press(this.startCard, "BtnWatch", () => {
            this.manager.foundIt()
            this.director.play()
          })
        )
      }
      this.controlBar.onBack.add(() => this.press(this.controlBar, "BtnBack", () => this.manager.back()))
      this.controlBar.onNext.add(() => this.press(this.controlBar, "BtnNext", () => this.manager.next()))
      this.controlBar.onReplay.add(() => this.press(this.controlBar, "BtnReplay", () => this.manager.replay()))
      this.doneCard.onTryAgain.add(() => this.press(this.doneCard, "BtnTryAgain", () => this.manager.reset()))
      this.doneCard.onContinue.add(() => this.press(this.doneCard, "BtnContinue", () => this.manager.next()))
      if (this.idle && this.stats) this.idle.onHint.add(() => this.stats.noteHint())
      if (this.feedback) {
        this.feedback.onMistake.add((m) => {
          if (this.stats) this.stats.noteMistake(m.code)
          if (this.idle) this.idle.touch()
        })
      }
      if (this.partInfo) {
        // The toggle look follows the mode (it may switch late while a lever is held).
        this.partInfo.onActiveChanged.add((on) => {
          this.controlBar.setWhatsThisLatched(on)
          if (on && this.askCoach) this.askCoach.setOpen(false)
        })
        this.controlBar.onWhatsThis.add((on) => {
          if (on === this.partInfo.wanted) return // a sync from setWhatsThisLatched, not a press
          this.press(this.controlBar, `BtnWhatsThis (${on ? "on" : "off"})`, () => this.partInfo.setActive(on))
          this.closeMore()
        })
      }
      if (this.askCoach) {
        this.askCoach.onOpenChanged.add((on) => {
          this.controlBar.setAskLatched(on)
          if (on && this.partInfo) this.partInfo.setActive(false)
        })
        this.controlBar.onAsk.add((on) => {
          if (on === this.askCoach.open) return // a sync from setAskLatched, not a press
          this.press(this.controlBar, `BtnAsk (${on ? "on" : "off"})`, () => this.askCoach.setOpen(on))
          this.closeMore()
        })
      }
      if (this.voice) {
        this.voice.onEnabledChanged.add((on) => this.controlBar.setVoiceLatched(on))
        this.controlBar.setVoiceLatched(this.voice.enabled)
        this.controlBar.onVoice.add((on) => {
          if (on === this.voice.enabled) return // a sync from setVoiceLatched, not a press
          this.press(this.controlBar, `BtnVoice (${on ? "on" : "off"})`, () => this.voice.setEnabled(on))
          this.closeMore()
        })
      }
      if (this.finishCard) {
        this.finishCard.onRestart.add(() => this.press(this.finishCard, "BtnRestart", () => this.manager.reset()))
      }
      // Pass D2: the dock's progress, the watch pill's Stop, the floor line.
      this.controlBar.onMore.add((on) => this.press(this.controlBar, `BtnMore (${on ? "open" : "closed"})`, () => {}))
      if (this.askCoach) {
        this.askCoach.chips.onClose.add(() => this.press(this.askCoach.chips, "BtnAskClose", () => {}))
        this.askCoach.answerPanel.onClose.add(() => this.press(this.askCoach.answerPanel, "BtnAnswerClose", () => {}))
      }
      this.controlBar.onStopWatch.add(() => this.press(this.controlBar, "BtnStopWatch", () => print("[UIBindings] watch mode stopped by Stop")))
      if (this.watchBadge) {
        this.watchBadge.onStop.add(() => this.press(this.watchBadge, "BtnBadgeStop", () => print("[UIBindings] watch mode stopped by the badge's Stop")))
      }
      this.controlBar.setProgress(this.manager.getState().step)
      this.manager.onStepChanged.add((step) => {
        this.controlBar.setProgress(step)
        if (this.controlBar.moreOpen) this.controlBar.setMoreOpen(false)
      })
      this.createEvent("UpdateEvent").bind(() => this.tick())
    })
  }

  private lastFloor = ""

  private tick(): void {
    if (this.director) {
      this.controlBar.setWatching(this.director.playing)
      if (this.watchBadge && this.watchBadge.watching !== this.director.playing) this.watchBadge.setWatching(this.director.playing)
    }
    if (this.floorLevel) {
      const status = !this.floorLevel.ready ? "pending" : this.floorLevel.source === "fallback" ? "fallback" : "found"
      if (status !== this.lastFloor) {
        this.lastFloor = status
        this.startCard.setFloorStatus(status)
        print(`[UIBindings] floor line: ${status} (${this.floorLevel.source})`)
      }
    }
  }

  /**
   * Pass V: a choice in the More popover closes it (the taller popover reached into the
   * recording frame from the dock while Ask was open). The toggles keep their state.
   */
  private closeMore(): void {
    if (this.controlBar.moreOpen) this.controlBar.setMoreOpen(false)
  }

  /** Every button press goes through here; the log line names the button (pass F). */
  private press(panel: BaseScriptComponent, name: string, action: () => void): void {
    print(`[UIBindings] press ${name}`)
    if (this.audio) this.audio.playTickAt(panel.sceneObject.getTransform().getWorldPosition())
    if (this.director) this.director.stop()
    if (this.idle) this.idle.touch()
    action()
  }
}
