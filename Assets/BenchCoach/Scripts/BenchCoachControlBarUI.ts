/**
 * BenchCoachControlBarUI — the always-on control bar: BtnBack, BtnNext, BtnReplay
 * as icon-only UIKit Buttons in one row.
 * Owns: only its view. Emits onBack / onNext / onReplay. Holds no repair state.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addIconButton, backPlatePanel, flexRow} from "./UIHelpers"

const ICON_BACK: Texture = requireAsset("../../Icons/arrow_back.png") as Texture
const ICON_NEXT: Texture = requireAsset("../../Icons/arrow_forward.png") as Texture
const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture

@component
export class BenchCoachControlBarUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachControlBarUI – Back / Next / Replay</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Back button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  backSize: number = 5

  @input
  @hint("Next button size in cm (the brightest, largest target)")
  @widget(new SliderWidget(3, 10, 0.5))
  nextSize: number = 6

  @input
  @hint("Replay button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  replaySize: number = 5

  @input
  @hint("Gap between buttons in cm")
  @widget(new SliderWidget(0.5, 5, 0.5))
  gap: number = 2

  @input
  @hint("Panel padding around the buttons in cm")
  @widget(new SliderWidget(0.5, 4, 0.25))
  padding: number = 1.25
  @ui.group_end

  private _onBack = new Event<void>()
  private _onNext = new Event<void>()
  private _onReplay = new Event<void>()
  onBack: PublicApi<void> = this._onBack.publicApi()
  onNext: PublicApi<void> = this._onNext.publicApi()
  onReplay: PublicApi<void> = this._onReplay.publicApi()

  onAwake(): void {
    const w = this.backSize + this.nextSize + this.replaySize + 2 * this.gap + 2 * this.padding
    const h = this.nextSize + 2 * this.padding
    const panel = backPlatePanel(this.sceneObject, w, h)
    const row = flexRow(panel.content, w, h, {
      gap: this.gap,
      padX: this.padding,
      padY: this.padding,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    addIconButton(row, "BtnBack", ICON_BACK, this.backSize, () => this._onBack.invoke())
    addIconButton(row, "BtnNext", ICON_NEXT, this.nextSize, () => this._onNext.invoke())
    addIconButton(row, "BtnReplay", ICON_REPLAY, this.replaySize, () => this._onReplay.invoke())
  }
}
