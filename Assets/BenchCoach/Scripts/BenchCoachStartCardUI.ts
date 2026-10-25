/**
 * BenchCoachStartCardUI — step 0 card: "Fix a flat" title, the big Found it
 * button (BtnFoundIt) with the Watch button (BtnWatch, pass 10: auto-plays the
 * whole repair) beside it, and the stand-in badge (StandInBadge).
 * Owns: only its view. Emits onFoundIt, onWatch. Holds no repair state.
 * Expects: to sit on the StartCard SceneObject facing the user at ~85 cm.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addColumnText, addLabelButton, backPlatePanel, flexChild, flexColumn, flexRow} from "./UIHelpers"

const ICON_CHECK: Texture = requireAsset("../../Icons/check.png") as Texture
const ICON_PLAY: Texture = requireAsset("../../Icons/play_arrow.png") as Texture

@component
export class BenchCoachStartCardUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachStartCardUI – step 0 start card</span>')
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
  viewDistanceCm: number = 85

  @input
  @hint("Card title")
  title: string = "Fix a flat"

  @input
  @hint("One-line instruction under the title")
  subtitle: string = "Pinch Found it when your wheel is in the stand."

  @input
  @hint("Label on the big button")
  buttonLabel: string = "Found it"

  @input
  @hint("Label on the watch-mode button (plays the whole repair)")
  watchLabel: string = "Watch"

  @input
  @hint("Stand-in badge text in the card corner")
  badgeText: string = "stand-in: wheel placed by pinch"
  @ui.group_end

  private _onFoundIt = new Event<void>()
  onFoundIt: PublicApi<void> = this._onFoundIt.publicApi()
  private _onWatch = new Event<void>()
  onWatch: PublicApi<void> = this._onWatch.publicApi()

  onAwake(): void {
    const d = this.viewDistanceCm
    const panel = backPlatePanel(this.sceneObject, this.panelWidth, this.panelHeight)
    const col = flexColumn(panel.content, this.panelWidth, this.panelHeight, {
      gap: 0.5,
      padX: 1.2,
      padY: 0.8,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    addColumnText(col, "Title", this.title, "Title2", 3.2, {distanceCm: d})
    addColumnText(col, "Subtitle", this.subtitle, "Caption", 1.8, {
      distanceCm: d,
      color: new vec4(1, 1, 1, 0.75),
    })
    // Found it (the main action) and Watch side by side, same height as the old single button.
    const rowW = this.panelWidth - 2.4
    flexChild(col, {w: rowW, h: 6, name: "Buttons"}, (child) => {
      const row = flexRow(child, rowW, 6, {gap: 0.8, justify: FlexJustify.Center, align: FlexAlign.Center})
      addLabelButton(row, "BtnFoundIt", this.buttonLabel, ICON_CHECK, 12, 6, d, () => {
        this._onFoundIt.invoke()
      })
      addLabelButton(row, "BtnWatch", this.watchLabel, ICON_PLAY, 8.6, 6, d, () => {
        this._onWatch.invoke()
      })
    })
    addColumnText(col, "StandInBadge", this.badgeText, "Caption", 1.6, {
      distanceCm: d,
      color: new vec4(0.6, 0.95, 1, 0.8),
    })
  }
}
