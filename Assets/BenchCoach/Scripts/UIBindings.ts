/**
 * UIBindings — subscribes to every UI module's button events and calls
 * RepairManager, and wires the learning-layer events into RunStats (hints from
 * IdleHint.onHint, mistakes from CoachFeedback.onMistake) and BtnWhatsThis into
 * PartInfo. Owns: nothing but the subscriptions.
 * Plays the tick cue from the pressed panel; every press touches IdleHint and
 * first stops watch mode (RepairDirector.stop()); the start card's Watch button
 * presses Found it and then starts watch mode.
 * Expects: @inputs manager, startCard, controlBar, doneCard, finishCard, audio (wired in the scene).
 */
import {RepairManager} from "./RepairManager"
import {BenchCoachStartCardUI} from "./BenchCoachStartCardUI"
import {BenchCoachControlBarUI} from "./BenchCoachControlBarUI"
import {BenchCoachDoneCardUI} from "./BenchCoachDoneCardUI"
import {BenchCoachFinishCardUI} from "./BenchCoachFinishCardUI"
import {BenchCoachAudio} from "./BenchCoachAudio"
import {IdleHint} from "./IdleHint"
import {RunStats} from "./RunStats"
import {PartInfo} from "./PartInfo"
import {CoachFeedback} from "./CoachFeedback"
import {RepairDirector} from "./RepairDirector"

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
  @ui.group_end

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => {
      if (!this.manager || !this.startCard || !this.controlBar || !this.doneCard) {
        print("[UIBindings] ERROR: missing @input refs")
        return
      }
      this.startCard.onFoundIt.add(() => this.press(this.startCard, () => this.manager.foundIt()))
      if (this.director) {
        this.startCard.onWatch.add(() =>
          this.press(this.startCard, () => {
            this.manager.foundIt()
            this.director.play()
          })
        )
      }
      this.controlBar.onBack.add(() => this.press(this.controlBar, () => this.manager.back()))
      this.controlBar.onNext.add(() => this.press(this.controlBar, () => this.manager.next()))
      this.controlBar.onReplay.add(() => this.press(this.controlBar, () => this.manager.replay()))
      this.doneCard.onTryAgain.add(() => this.press(this.doneCard, () => this.manager.reset()))
      this.doneCard.onContinue.add(() => this.press(this.doneCard, () => this.manager.next()))
      if (this.idle && this.stats) this.idle.onHint.add(() => this.stats.noteHint())
      if (this.feedback) {
        this.feedback.onMistake.add((m) => {
          if (this.stats) this.stats.noteMistake(m.code)
          if (this.idle) this.idle.touch()
        })
      }
      if (this.partInfo) {
        // The toggle look follows the mode (it may switch late while a lever is held).
        this.partInfo.onActiveChanged.add((on) => this.controlBar.setWhatsThisLatched(on))
        this.controlBar.onWhatsThis.add((on) => {
          if (on === this.partInfo.wanted) return // a sync from setWhatsThisLatched, not a press
          this.press(this.controlBar, () => this.partInfo.setActive(on))
        })
      }
      if (this.finishCard) {
        this.finishCard.onRestart.add(() => this.press(this.finishCard, () => this.manager.reset()))
      }
    })
  }

  private press(panel: BaseScriptComponent, action: () => void): void {
    if (this.audio) this.audio.playTickAt(panel.sceneObject.getTransform().getWorldPosition())
    if (this.director) this.director.stop()
    if (this.idle) this.idle.touch()
    action()
  }
}
