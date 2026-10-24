/**
 * BenchCoachControlBarUI — the always-on control bar: BtnWhatsThis, BtnBack,
 * BtnNext and BtnReplay as icon-only UIKit Buttons in one row, with a strip under the
 * row for the progress rail (ControlBar/ProgressRail sits in it).
 * BtnWhatsThis is a UIKit toggle, so its latched look shows while What's this? is on.
 * Owns: only its view. Emits onBack / onNext / onReplay / onWhatsThis(on).
 * setWhatsThisLatched() syncs the toggle look. Holds no repair state.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Button} from "SpectaclesUIKit.lspkg/Scripts/Components/Button/Button"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addIconButton, backPlatePanel, flexRow} from "./UIHelpers"

const ICON_BACK: Texture = requireAsset("../../Icons/arrow_back.png") as Texture
const ICON_NEXT: Texture = requireAsset("../../Icons/arrow_forward.png") as Texture
const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture
const ICON_INFO: Texture = requireAsset("../../Icons/info.png") as Texture

@component
export class BenchCoachControlBarUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachControlBarUI – Back / Next / Replay / What\'s this?</span>')
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
  @hint("What's this? button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  whatsThisSize: number = 5

  @input
  @hint("Gap between buttons in cm")
  @widget(new SliderWidget(0.5, 5, 0.5))
  gap: number = 2

  @input
  @hint("Panel padding around the buttons in cm")
  @widget(new SliderWidget(0.5, 4, 0.25))
  padding: number = 1.25

  @input
  @hint("Height of the strip under the buttons for the progress rail, in cm (0 = none)")
  @widget(new SliderWidget(0, 4, 0.1))
  railStripCm: number = 1.6
  @ui.group_end

  private _onBack = new Event<void>()
  private _onNext = new Event<void>()
  private _onReplay = new Event<void>()
  private _onWhatsThis = new Event<boolean>()
  onBack: PublicApi<void> = this._onBack.publicApi()
  onNext: PublicApi<void> = this._onNext.publicApi()
  onReplay: PublicApi<void> = this._onReplay.publicApi()
  /** The What's this? toggle changed (by a press or by setWhatsThisLatched). */
  onWhatsThis: PublicApi<boolean> = this._onWhatsThis.publicApi()

  /** Current latched state of BtnWhatsThis. */
  whatsThisOn: boolean = false

  private whatsThis: Button | null = null

  /** Show the What's this? toggle as on or off (no-op if it already is). */
  setWhatsThisLatched(on: boolean): void {
    if (this.whatsThis && this.whatsThis.isOn !== on) this.whatsThis.isOn = on
  }

  onAwake(): void {
    const w = this.backSize + this.nextSize + this.replaySize + this.whatsThisSize + 3 * this.gap + 2 * this.padding
    const rowH = this.nextSize + 2 * this.padding
    const h = rowH + this.railStripCm
    const panel = backPlatePanel(this.sceneObject, w, h)
    const row = flexRow(panel.content, w, rowH, {
      gap: this.gap,
      padX: this.padding,
      padY: this.padding,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    // The row sits in the top part of the panel; the rail strip is underneath.
    const rp = row.getTransform().getLocalPosition()
    row.getTransform().setLocalPosition(new vec3(rp.x, rp.y + this.railStripCm / 2, rp.z))
    // What's this? sits at the left end (the tool tray is on the right); the scene
    // places the bar so Back / Next / Replay keep their pass 5 positions.
    const btn = addIconButton(row, "BtnWhatsThis", ICON_INFO, this.whatsThisSize, () => {})
    addIconButton(row, "BtnBack", ICON_BACK, this.backSize, () => this._onBack.invoke())
    addIconButton(row, "BtnNext", ICON_NEXT, this.nextSize, () => this._onNext.invoke())
    addIconButton(row, "BtnReplay", ICON_REPLAY, this.replaySize, () => this._onReplay.invoke())
    btn.onInitialized.add(() => btn.setIsToggleable(true))
    btn.onValueChange.add((v) => {
      this.whatsThisOn = v === 1
      this._onWhatsThis.invoke(this.whatsThisOn)
    })
    this.whatsThis = btn
  }
}
