/**
 * BenchCoachDoneCardUI — the step 7 halfway card (The shared card component):
 * a green "Halfway" kicker, the title, the next step, a two-column list (time, cause),
 * the next-skill teaser, and BtnContinue ("Fit the new tube", primary) with BtnTryAgain
 * (labeled "Start over"; the object name stays for the tests).
 * Owns: only its view. setElapsed() / setCause() push values in. Emits onContinue, onTryAgain.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {COLOR, buildCard} from "./UIHelpers"

const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture
const ICON_FORWARD: Texture = requireAsset("../../Icons/arrow_forward.png") as Texture

@component
export class BenchCoachDoneCardUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachDoneCardUI – step 7 halfway card</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Card width in cm (the height follows the content)")
  @widget(new SliderWidget(16, 40, 0.5))
  panelWidth: number = 27

  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 82

  @input
  @hint("Title")
  doneText: string = "Tube out, cause found"

  @input
  @hint("Line under the title")
  nextStepText: string = "Next: fit the new tube and pump it up."

  @input
  @hint("Next-skill line (not clickable in v1)")
  nextSkillText: string = "Next skill: brake pads"

  @input
  @hint("Label on the primary button (on to step 8)")
  continueLabel: string = "Fit the new tube"

  @input
  @hint("Label on the restart button (BtnTryAgain)")
  restartLabel: string = "Start over"
  @ui.group_end

  private timeText: Text | null = null
  private causeText: Text | null = null
  private _onTryAgain = new Event<void>()
  onTryAgain: PublicApi<void> = this._onTryAgain.publicApi()
  private _onContinue = new Event<void>()
  onContinue: PublicApi<void> = this._onContinue.publicApi()

  setElapsed(seconds: number): void {
    const s = Math.max(0, Math.floor(seconds))
    const m = Math.floor(s / 60)
    const r = s % 60
    if (this.timeText) this.timeText.text = `${m}:${r < 10 ? "0" : ""}${r}`
  }

  /** The flat cause found on step 6 ("thorn"). */
  setCause(label: string): void {
    if (this.causeText) this.causeText.text = label.length > 0 ? label.charAt(0).toUpperCase() + label.substring(1) : label
  }

  onAwake(): void {
    this.sceneObject.createComponent(Billboard.getTypeName())
    const card = buildCard(this.sceneObject, {
      width: this.panelWidth,
      distanceCm: this.viewDistanceCm,
      title: {name: "DoneText", text: this.doneText, kicker: {name: "DoneKicker", text: "Halfway", color: COLOR.green}},
      rows: [{name: "DoneNext", text: this.nextStepText, role: "body"}],
      pairs: [
        {name: "TimeText", label: "Time", value: "0:00"},
        {name: "DoneCause", label: "Cause", value: "Thorn"},
      ],
      rowsAfter: [{name: "NextSkill", text: this.nextSkillText, role: "secondary"}],
      buttons: [
        {name: "BtnContinue", label: this.continueLabel, icon: ICON_FORWARD, kind: "primary", width: 12.6, onClick: () => this._onContinue.invoke()},
        {name: "BtnTryAgain", label: this.restartLabel, icon: ICON_REPLAY, kind: "neutral", width: 10, onClick: () => this._onTryAgain.invoke()},
      ],
    })
    this.timeText = card.texts["TimeText"]
    this.causeText = card.texts["DoneCause"]
  }
}
