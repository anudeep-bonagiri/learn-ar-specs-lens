/**
 * BenchCoachDoneCardUI — step 7 halfway card: completion line, elapsed time,
 * "Next skill" line, BtnContinue ("Fit the new tube", primary) and BtnTryAgain
 * (labeled "Start over"; the object name stays for the tests).
 * Owns: only its view. setElapsed() pushes the time in. Emits onContinue, onTryAgain.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addColumnText, addLabelButton, backPlatePanel, flexChild, flexColumn, flexRow} from "./UIHelpers"

const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture
const ICON_FORWARD: Texture = requireAsset("../../Icons/arrow_forward.png") as Texture

@component
export class BenchCoachDoneCardUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachDoneCardUI – step 7 halfway card</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Panel width in cm")
  @widget(new SliderWidget(12, 40, 0.5))
  panelWidth: number = 24

  @input
  @hint("Panel height in cm")
  @widget(new SliderWidget(8, 30, 0.5))
  panelHeight: number = 14

  @input
  @hint("Viewing distance in cm; scales the type size")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 90

  @input
  @hint("Completion line")
  doneText: string = "Tube out, cause found. Ready for the new tube."

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
  private _onTryAgain = new Event<void>()
  onTryAgain: PublicApi<void> = this._onTryAgain.publicApi()
  private _onContinue = new Event<void>()
  onContinue: PublicApi<void> = this._onContinue.publicApi()

  setElapsed(seconds: number): void {
    const s = Math.max(0, Math.floor(seconds))
    const m = Math.floor(s / 60)
    const r = s % 60
    if (this.timeText) this.timeText.text = `Time ${m}:${r < 10 ? "0" : ""}${r}`
  }

  onAwake(): void {
    const d = this.viewDistanceCm
    this.sceneObject.createComponent(Billboard.getTypeName())
    const panel = backPlatePanel(this.sceneObject, this.panelWidth, this.panelHeight)
    const col = flexColumn(panel.content, this.panelWidth, this.panelHeight, {
      gap: 0.4,
      padX: 1.0,
      padY: 0.8,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    addColumnText(col, "DoneText", this.doneText, "Body", 2.2, {distanceCm: d})
    this.timeText = addColumnText(col, "TimeText", "Time 0:00", "Headline2", 2.6, {distanceCm: d})
    addColumnText(col, "NextSkill", this.nextSkillText, "Caption", 1.6, {
      distanceCm: d,
      color: new vec4(1, 1, 1, 0.6),
    })
    const rowW = this.panelWidth - 2
    flexChild(col, {w: rowW, h: 4.5, name: "Buttons"}, (child) => {
      const row = flexRow(child, rowW, 4.5, {gap: 0.8, justify: FlexJustify.Center, align: FlexAlign.Center})
      addLabelButton(row, "BtnContinue", this.continueLabel, ICON_FORWARD, 12.4, 4.5, d, () => {
        this._onContinue.invoke()
      }, "Primary")
      addLabelButton(row, "BtnTryAgain", this.restartLabel, ICON_REPLAY, 8.8, 4.5, d, () => {
        this._onTryAgain.invoke()
      })
    })
  }
}
