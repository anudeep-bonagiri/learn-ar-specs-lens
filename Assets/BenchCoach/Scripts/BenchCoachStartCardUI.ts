/**
 * BenchCoachStartCardUI — the step 0 card (pass D2: the shared card component): the
 * "Fix a flat" title, one instruction line, a floor status line and two big buttons,
 * BtnFoundIt (primary; the preview stand-in for recognising the real wheel in the
 * stand) and BtnWatch ("Watch first", pass 10: auto-plays the whole repair).
 * setFloorStatus() shows "Look down at your work spot" until FloorLevel decides from
 * real hits, then "Floor found" (green), or "Using a standard floor height" (amber)
 * on the fallback. The stand-in note is logged, never shown.
 * Pass A: from the second run on, setRunLine() shows one more line under the floor line
 * (AdaptiveCoach: "Run 2. I'll go quiet on ..."), display only. Body type if it fits on
 * two lines, else one role smaller (secondary). The plate keeps its width and grows by
 * the line; with no line the card is exactly as before.
 * Owns: only its view. Emits onFoundIt, onWatch. Holds no repair state.
 * Expects: to sit on the StartCard SceneObject facing the user at about 85 cm.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {FlexLayout} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexLayout"
import {FlexItem} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexItem"
import {COLOR, Card, UIRole, addUIText, buildCard, grid, lineCm, linesFor, uiSize} from "./UIHelpers"

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
  /** Pass A: the run line as given ("" for none); tests read it. */
  runLine: string = ""
  /** Pass A: the role the run line is shown in ("" while hidden). */
  runRole: UIRole | "" = ""
  private card: Card | null = null
  private col: SceneObject | null = null
  private runText: Text | null = null
  private runShown = false
  private awaitingInit = false
  private innerW = 0

  /**
   * Pass A: the line under the floor line from the second run on ("" hides it). The
   * plate grows by the line's height (and the gap above it) and shrinks back without it.
   */
  setRunLine(text: string): void {
    this.runLine = text
    if (!this.card || !this.col || !this.runText) return
    const flex = this.col.getComponent(FlexLayout.getTypeName()) as FlexLayout
    const holder = this.runText.getSceneObject()
    const item = holder.getComponent(FlexItem.getTypeName()) as FlexItem
    const d = this.viewDistanceCm
    let extra = 0
    if (!text) {
      if (this.runShown) flex.removeItems([item])
      holder.enabled = false
      this.runShown = false
      this.runRole = ""
    } else {
      const role: UIRole = linesFor(text, "body", this.innerW, d) <= 2 ? "body" : "secondary"
      const h = lineCm(role, d) * linesFor(text, role, this.innerW, d)
      this.runText.text = text
      this.runText.size = uiSize(role, d)
      this.runText.textFill.color = role === "secondary" ? COLOR.textSecondary : COLOR.text
      this.runText.layoutRect = Rect.create(-this.innerW / 2, this.innerW / 2, -h / 2, h / 2)
      item.overrideHeight = h
      this.runRole = role
      extra = h + grid(d).gap
      if (!this.runShown) {
        holder.enabled = true
        flex.addItems([item])
        // Under the floor line, above the buttons (the last item).
        const order = flex.items.filter((it) => it !== item)
        order.splice(order.length - 1, 0, item)
        flex.reorderItems(order)
        this.runShown = true
      }
    }
    const h = this.card.height + extra
    this.card.plate.setHeight(h)
    flex.height = h
    const colItem = this.col.getComponent(FlexItem.getTypeName()) as FlexItem
    if (colItem) colItem.overrideHeight = h
    // In this frame, not the next LateUpdate: otherwise the line shows for a frame at the
    // column's centre, over the subtitle, and the buttons outside the new plate.
    if (flex["_initialized"]) flex.forceLayout()
    else if (!this.awaitingInit) {
      // The flex's own first setup puts its authored height back: apply the line again after it.
      this.awaitingInit = true
      flex.onInitialized.add(() => this.setRunLine(this.runLine))
    }
  }

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
        {name: "BtnFoundIt", label: this.buttonLabel, icon: ICON_CHECK, kind: "primary", width: 11.2, onClick: () => this._onFoundIt.invoke()},
        {name: "BtnWatch", label: this.watchLabel, icon: ICON_PLAY, kind: "neutral", width: 11.2, onClick: () => this._onWatch.invoke()},
      ],
    })
    this.floorLine = card.texts["FloorStatus"]
    this.setFloorStatus(this.floorStatus)
    // Pass A: the run line, built hidden (setRunLine shows it).
    this.card = card
    this.col = card.plate.content.getChild(0)
    this.innerW = card.width - 2 * grid(d).pad * 1.3
    this.runText = addUIText(this.col, "RunLine", "", "body", this.innerW, lineCm("body", d), d, {wrap: true})
    this.runText.verticalAlignment = VerticalAlignment.Top
    const flex = this.col.getComponent(FlexLayout.getTypeName()) as FlexLayout
    flex.removeItems([this.runText.getSceneObject().getComponent(FlexItem.getTypeName()) as FlexItem])
    this.runText.getSceneObject().enabled = false
    if (this.runLine) this.setRunLine(this.runLine)
    print("[StartCard] preview stand-in: Found it places the wheel (on Specs this is where the real wheel is recognised)")
  }
}
