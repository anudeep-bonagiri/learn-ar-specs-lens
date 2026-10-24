/**
 * UIBindings — subscribes to every UI module's button events and calls
 * RepairManager. Owns: nothing but the subscriptions.
 * Plays the tick cue from the pressed panel.
 * Expects: @inputs manager, startCard, controlBar, doneCard, audio (wired in the scene).
 */
import {RepairManager} from "./RepairManager"
import {BenchCoachStartCardUI} from "./BenchCoachStartCardUI"
import {BenchCoachControlBarUI} from "./BenchCoachControlBarUI"
import {BenchCoachDoneCardUI} from "./BenchCoachDoneCardUI"
import {BenchCoachAudio} from "./BenchCoachAudio"

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
  @hint("Done card (Try again)")
  doneCard: BenchCoachDoneCardUI

  @input
  @hint("Cue player (tick)")
  audio: BenchCoachAudio
  @ui.group_end

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => {
      if (!this.manager || !this.startCard || !this.controlBar || !this.doneCard) {
        print("[UIBindings] ERROR: missing @input refs")
        return
      }
      this.startCard.onFoundIt.add(() => this.press(this.startCard, () => this.manager.foundIt()))
      this.controlBar.onBack.add(() => this.press(this.controlBar, () => this.manager.back()))
      this.controlBar.onNext.add(() => this.press(this.controlBar, () => this.manager.next()))
      this.controlBar.onReplay.add(() => this.press(this.controlBar, () => this.manager.replay()))
      this.doneCard.onTryAgain.add(() => this.press(this.doneCard, () => this.manager.reset()))
    })
  }

  private press(panel: BaseScriptComponent, action: () => void): void {
    if (this.audio) this.audio.playTickAt(panel.sceneObject.getTransform().getWorldPosition())
    action()
  }
}
