/**
 * BenchCoachControlBarUI — the always-on control bar: BtnWhatsThis, BtnAsk, BtnBack,
 * BtnNext and BtnReplay as icon-only UIKit Buttons in one row, with a strip under the
 * row for the progress rail (ControlBar/ProgressRail sits in it).
 * BtnWhatsThis and BtnAsk are UIKit toggles, so their latched look shows while the mode is on.
 * Owns: only its view. Emits onBack / onNext / onReplay / onWhatsThis(on) / onAsk(on).
 * setWhatsThisLatched() / setAskLatched() sync the toggle looks. Holds no repair state.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Button} from "SpectaclesUIKit.lspkg/Scripts/Components/Button/Button"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addIconButton, backPlatePanel, flexRow} from "./UIHelpers"

const ICON_BACK: Texture = requireAsset("../../Icons/arrow_back.png") as Texture
const ICON_NEXT: Texture = requireAsset("../../Icons/arrow_forward.png") as Texture
const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture
const ICON_INFO: Texture = requireAsset("../../Icons/info.png") as Texture
const ICON_ASK: Texture = requireAsset("../../Icons/help.png") as Texture

@component
export class BenchCoachControlBarUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachControlBarUI – What\'s this? / Ask / Back / Next / Replay</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Back button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  backSize: number = 3.9

  @input
  @hint("Next button size in cm (the brightest, largest target)")
  @widget(new SliderWidget(3, 10, 0.5))
  nextSize: number = 6

  @input
  @hint("Replay button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  replaySize: number = 3.9

  @input
  @hint("What's this? button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  whatsThisSize: number = 3.9

  @input
  @hint("Ask button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  askSize: number = 3.9

  @input
  @hint("Gap between buttons in cm")
  @widget(new SliderWidget(0.4, 5, 0.1))
  gap: number = 0.5

  @input
  @hint("Panel padding above and below the buttons in cm")
  @widget(new SliderWidget(0.5, 4, 0.25))
  padding: number = 1

  @input
  @hint("Panel padding left and right of the buttons in cm")
  @widget(new SliderWidget(0.25, 4, 0.25))
  padX: number = 0.75

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
  private _onAsk = new Event<boolean>()
  /** The Ask toggle changed (by a press or by setAskLatched). */
  onAsk: PublicApi<boolean> = this._onAsk.publicApi()

  /** Current latched state of BtnAsk. */
  askOn: boolean = false

  /** Current latched state of BtnWhatsThis. */
  whatsThisOn: boolean = false

  private whatsThis: Button | null = null
  private ask: Button | null = null

  /** Show the Ask toggle as on or off (no-op if it already is). */
  setAskLatched(on: boolean): void {
    if (this.ask && this.ask.isOn !== on) this.ask.isOn = on
  }

  /** Show the What's this? toggle as on or off (no-op if it already is). */
  setWhatsThisLatched(on: boolean): void {
    if (this.whatsThis && this.whatsThis.isOn !== on) this.whatsThis.isOn = on
  }

  onAwake(): void {
    const w =
      this.backSize + this.nextSize + this.replaySize + this.whatsThisSize + this.askSize + 4 * this.gap + 2 * this.padX
    const rowH = this.nextSize + 2 * this.padding
    const h = rowH + this.railStripCm
    const panel = backPlatePanel(this.sceneObject, w, h)
    const row = flexRow(panel.content, w, rowH, {
      gap: this.gap,
      padX: this.padX,
      padY: this.padding,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    // The row sits in the top part of the panel; the rail strip is underneath.
    const rp = row.getTransform().getLocalPosition()
    row.getTransform().setLocalPosition(new vec3(rp.x, rp.y + this.railStripCm / 2, rp.z))
    // What's this? and Ask sit at the left end (the tool tray is on the right). F4 (pass 10)
    // kept the bar at 25.1 cm so, looking 32 degrees down, every button and the rail are in
    // view and the right end clears the tray; pass 12 fits BtnAsk in the same 25.1 cm
    // (secondary buttons 3.9 cm, gap 0.5, side padding 0.75; Next stays 6 cm).
    const btn = addIconButton(row, "BtnWhatsThis", ICON_INFO, this.whatsThisSize, () => {})
    const askBtn = addIconButton(row, "BtnAsk", ICON_ASK, this.askSize, () => {})
    addIconButton(row, "BtnBack", ICON_BACK, this.backSize, () => this._onBack.invoke())
    addIconButton(row, "BtnNext", ICON_NEXT, this.nextSize, () => this._onNext.invoke())
    addIconButton(row, "BtnReplay", ICON_REPLAY, this.replaySize, () => this._onReplay.invoke())
    btn.onInitialized.add(() => btn.setIsToggleable(true))
    btn.onValueChange.add((v) => {
      this.whatsThisOn = v === 1
      this._onWhatsThis.invoke(this.whatsThisOn)
    })
    this.whatsThis = btn
    askBtn.onInitialized.add(() => askBtn.setIsToggleable(true))
    askBtn.onValueChange.add((v) => {
      this.askOn = v === 1
      this._onAsk.invoke(this.askOn)
    })
    this.ask = askBtn
  }
}
