/**
 * BenchCoachStartCardUI — the step 0 card (pass D2: the shared card component): the
 * "Fix a flat" title, one instruction line, a floor status line and two big buttons,
 * BtnFoundIt (primary; the preview stand-in for recognising the real wheel in the
 * stand) and BtnWatch ("Watch first", pass 10: auto-plays the whole repair).
 * setFloorStatus() shows "Look down at your work spot" until FloorLevel decides from
 * real hits, then "Floor found" (green), or "Using a standard floor height" (amber)
 * on the fallback. The stand-in note is logged, never shown.
 * Owns: only its view. Emits onFoundIt, onWatch. Holds no repair state.
 * Expects: to sit on the StartCard SceneObject facing the user at about 85 cm.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {COLOR, buildCard} from "./UIHelpers"

const ICON_CHECK: Texture = requireAsset("../../Icons/check.png") as Texture
const ICON_PLAY: Texture = requireAsset("../../Icons/play_arrow.png") as Texture

export type FloorStatus = "pending" | "found" | "fallback"

@component
export class BenchCoachStartCardUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachStartCardUI – step 0 start card</span>')
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
  viewDistanceCm: number = 85

  @input
  @hint("Card title")
  title: string = "Fix a flat"

  @input
  @hint("One-line instruction under the title")
  subtitle: string = "Put your wheel in the stand, then pinch Found it."

  @input
  @hint("Label on the primary button")
  buttonLabel: string = "Found it"

  @input
  @hint("Label on the watch-mode button (plays the whole repair)")
  watchLabel: string = "Watch first"

  @input
  @hint("Floor line while FloorLevel has not decided from real hits")
  floorPendingText: string = "Look down at your work spot"

  @input
  @hint("Floor line once the floor is measured")
  floorFoundText: string = "Floor found"

  @input
  @hint("Floor line when FloorLevel falls back to the standard height")
  floorFallbackText: string = "Using a standard floor height"
  @ui.group_end

  private _onFoundIt = new Event<void>()
  onFoundIt: PublicApi<void> = this._onFoundIt.publicApi()
  private _onWatch = new Event<void>()
  onWatch: PublicApi<void> = this._onWatch.publicApi()

  /** The floor line's state and text now. */
  floorStatus: FloorStatus = "pending"
  floorText: string = ""

  private floorLine: Text | null = null

  /** The floor line: pending (grey), found (green) or fallback (amber). */
  setFloorStatus(status: FloorStatus): void {
    this.floorStatus = status
    this.floorText =
      status === "found" ? this.floorFoundText : status === "fallback" ? this.floorFallbackText : this.floorPendingText
    if (!this.floorLine) return
    this.floorLine.text = this.floorText
    this.floorLine.textFill.color = status === "found" ? COLOR.green : status === "fallback" ? COLOR.amber : COLOR.textSecondary
  }

  onAwake(): void {
    const d = this.viewDistanceCm
    const card = buildCard(this.sceneObject, {
      width: this.panelWidth,
      distanceCm: d,
      title: {name: "Title", text: this.title},
      rows: [
        {name: "Subtitle", text: this.subtitle, role: "body"},
        {name: "FloorStatus", text: this.floorPendingText, role: "secondary"},
      ],
      buttons: [
        {name: "BtnFoundIt", label: this.buttonLabel, icon: ICON_CHECK, kind: "primary", width: 11.5, onClick: () => this._onFoundIt.invoke()},
        {name: "BtnWatch", label: this.watchLabel, icon: ICON_PLAY, kind: "neutral", width: 11.5, onClick: () => this._onWatch.invoke()},
      ],
    })
    this.floorLine = card.texts["FloorStatus"]
    this.setFloorStatus(this.floorStatus)
    print("[StartCard] preview stand-in: Found it places the wheel (on Specs this is where the real wheel is recognised)")
  }
}
