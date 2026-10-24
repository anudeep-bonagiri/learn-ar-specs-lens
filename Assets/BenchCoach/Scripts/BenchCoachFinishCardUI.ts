/**
 * BenchCoachFinishCardUI — the final card (step 11), billboarded above the
 * wheel: "Flat fixed.", the time from Found it, a stats line ("Lever misses 1 ·
 * Hints 0 · Cause: thorn"), a prevention tip, and BtnRestart.
 * Owns: only its view. setResult() pushes time, stats and tip in. Emits onRestart.
 * Must not: hold repair state or count anything (RunStats counts, RepairManager pushes).
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addColumnText, addLabelButton, backPlatePanel, flexColumn} from "./UIHelpers"

const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture

@component
export class BenchCoachFinishCardUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachFinishCardUI – step 11 finish card</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Panel width in cm")
  @widget(new SliderWidget(12, 40, 0.5))
  panelWidth: number = 26

  @input
  @hint("Panel height in cm")
  @widget(new SliderWidget(8, 30, 0.5))
  panelHeight: number = 16

  @input
  @hint("Viewing distance in cm; scales the type size")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 90

  @input
  @hint("Headline")
  titleText: string = "Flat fixed."

  @input
  @hint("Label on the restart button")
  restartLabel: string = "Start over"
  @ui.group_end

  private timeText: Text | null = null
  private statsText: Text | null = null
  private tipText: Text | null = null
  private _onRestart = new Event<void>()
  onRestart: PublicApi<void> = this._onRestart.publicApi()

  /** Time from Found it, the stats line and the prevention tip. */
  setResult(seconds: number, statsLine: string, tip: string): void {
    const s = Math.max(0, Math.floor(seconds))
    const m = Math.floor(s / 60)
    const r = s % 60
    if (this.timeText) this.timeText.text = `Time ${m}:${r < 10 ? "0" : ""}${r}`
    if (this.statsText) this.statsText.text = statsLine
    if (this.tipText) this.tipText.text = `Next time: ${tip}`
  }

  onAwake(): void {
    const d = this.viewDistanceCm
    this.sceneObject.createComponent(Billboard.getTypeName())
    const panel = backPlatePanel(this.sceneObject, this.panelWidth, this.panelHeight)
    const col = flexColumn(panel.content, this.panelWidth, this.panelHeight, {
      gap: 0.5,
      padX: 1.0,
      padY: 0.8,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    addColumnText(col, "FinishTitle", this.titleText, "Title2", 3.2, {distanceCm: d})
    this.timeText = addColumnText(col, "FinishTime", "Time 0:00", "Headline2", 2.6, {distanceCm: d})
    this.statsText = addColumnText(col, "FinishStats", "Lever misses 0 · Hints 0 · Cause: thorn", "Caption", 1.8, {
      distanceCm: d,
    })
    this.tipText = addColumnText(col, "FinishTip", "Next time: run a hand round inside the tire.", "Caption", 1.6, {
      distanceCm: d,
      color: new vec4(0.75, 0.97, 1, 0.85),
    })
    addLabelButton(col, "BtnRestart", this.restartLabel, ICON_REPLAY, 13, 4.5, d, () => {
      this._onRestart.invoke()
    })
  }
}
