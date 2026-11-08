/**
 * BenchCoachStartCardUI — the step 0 card (The shared card component): the
 * "Fix a flat" title, one instruction line, a floor status line and two big buttons,
 * BtnFoundIt (primary; the preview stand-in for recognising the real wheel in the
 * stand) and BtnWatch ("Watch first", pass 10: auto-plays the whole repair).
 * setFloorStatus() shows "Look down at your work spot" until FloorLevel decides from
 * real hits, then "Floor found" (green), or "Using a standard floor height" (amber)
 * on the fallback. The stand-in note is logged, never shown.
 * From the second run on, setRunLine() shows one more line under the floor line
 * (AdaptiveCoach: "Run 2. I'll go quiet on ..."), display only. Body type if it fits on
 * two lines, else one role smaller (secondary). The plate keeps its width and grows by
 * the line; with no line the card is exactly as before.
 * In the editor only, one more line under the floor line says what Found it does
 * there (PreviewNote: the preview has no real wheel to recognise). Display only, nothing
 * spoken; on Specs the row is not built, so the card is as before.
 * Owns: only its view. Emits onFoundIt, onWatch. Holds no repair state.
 * Expects: to sit on the StartCard SceneObject facing the user at about 85 cm.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {FlexLayout} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexLayout"
import {FlexItem} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexItem"
import {COLOR, Card, UIRole, addUIText, buildCard, grid, lineCm, linesFor, uiSize} from "./UIHelpers"

const ICON_CHECK: Texture = requireAsset("../../Icons/check.png") as Texture
const ICON_PLAY: Texture = requireAsset("../../Icons/play_arrow.png") as Texture

/** The honest line, editor only. */
export const PREVIEW_NOTE = "In this preview, Found it stands a wheel in for yours."

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
  /** The run line as given ("" for none); tests read it. */
  runLine: string = ""
  /** The role the run line is shown in ("" while hidden). */
  runRole: UIRole | "" = ""
  private card: Card | null = null
  private col: SceneObject | null = null
  private runText: Text | null = null
  /** The run line is in the layout and visible. */
  runLineShown: boolean = false
  /** The plate height for the current run line; the line waits to be shown until the layout can place it. */
  private targetH = 0
  private pendingReveal = false
  private innerW = 0

  /**
   * The line under the floor line from the second run on ("" hides it). The
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
      if (this.runLineShown) flex.removeItems([item])
      holder.getTransform().setLocalScale(vec3.zero())
      this.runLineShown = false
      this.pendingReveal = false
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
      if (!this.runLineShown) {
        // Under the floor line, above the buttons (the last item); revealed once placed.
        flex.addItems([item])
        const order = flex.items.filter((it) => it !== item)
        order.splice(order.length - 1, 0, item)
        flex.reorderItems(order)
        this.runLineShown = true
        this.pendingReveal = true
      }
    }
    this.targetH = this.card.height + extra
    this.card.plate.setHeight(this.targetH)
    this.applyColumn(flex)
    this.reveal()
  }

  /** The column at the plate's height, laid out now when it can be (not in the next LateUpdate). */
  private applyColumn(flex: FlexLayout): void {
    flex.height = this.targetH
    const colItem = (this.col as SceneObject).getComponent(FlexItem.getTypeName()) as FlexItem
    if (colItem) colItem.overrideHeight = this.targetH
    if (flex["_initialized"]) flex.forceLayout()
  }

  /**
   * Shows a new run line once the column and the line's own FlexItem are set up, right after
   * a layout pass placed it (the layout does not scale a Text item, so it stays at zero until
   * here). Called from setRunLine and every LateUpdate while one waits; never shown at the
   * column's centre over the subtitle.
   */
  private reveal(): void {
    if (!this.pendingReveal || !this.col || !this.runText) return
    const flex = this.col.getComponent(FlexLayout.getTypeName()) as FlexLayout
    const holder = this.runText.getSceneObject()
    const item = holder.getComponent(FlexItem.getTypeName()) as FlexItem
    if (!flex["_initialized"] || !item.initialized) return
    // The flex's own first setup puts its authored height back: apply ours again.
    this.applyColumn(flex)
    holder.getTransform().setLocalScale(vec3.one())
    this.pendingReveal = false
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
        ...(global.deviceInfoSystem.isEditor() ? [{name: "PreviewNote", text: PREVIEW_NOTE, role: "secondary" as UIRole}] : []),
      ],
      buttons: [
        {name: "BtnFoundIt", label: this.buttonLabel, icon: ICON_CHECK, kind: "primary", width: 11.2, onClick: () => this._onFoundIt.invoke()},
        {name: "BtnWatch", label: this.watchLabel, icon: ICON_PLAY, kind: "neutral", width: 11.2, onClick: () => this._onWatch.invoke()},
      ],
    })
    this.floorLine = card.texts["FloorStatus"]
    this.setFloorStatus(this.floorStatus)
    // The run line, built hidden (setRunLine shows it). It stays enabled, out of the
    // layout and at zero scale: a FlexItem that was off at Lens start is not placed by the
    // layout in the frame it is turned on, so it would show a frame at the column's centre.
    // The column is set up once (the flex's own first setup), then always laid out at once.
    this.card = card
    this.col = card.plate.content.getChild(0)
    this.innerW = card.width - 2 * grid(d).pad * 1.3
    this.runText = addUIText(this.col, "RunLine", "", "body", this.innerW, lineCm("body", d), d, {wrap: true})
    this.runText.verticalAlignment = VerticalAlignment.Top
    const flex = this.col.getComponent(FlexLayout.getTypeName()) as FlexLayout
    flex.removeItems([this.runText.getSceneObject().getComponent(FlexItem.getTypeName()) as FlexItem])
    this.runText.getSceneObject().getTransform().setLocalScale(vec3.zero())
    if (this.runLine) this.setRunLine(this.runLine)
    this.createEvent("LateUpdateEvent").bind(() => this.reveal())
    print("[StartCard] preview stand-in: Found it places the wheel (on Specs this is where the real wheel is recognised)")
  }
}
