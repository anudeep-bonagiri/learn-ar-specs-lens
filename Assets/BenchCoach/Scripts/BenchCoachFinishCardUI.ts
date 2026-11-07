/**
 * BenchCoachFinishCardUI — the final card (step 11).
 * Pass S1, progressive disclosure. By default the card is compact: a green "Repair
 * complete" kicker, "Flat fixed" with the time on the same row, the "Next time" tip, and
 * two buttons, More (BtnFinishMore) and Start over (BtnRestart). More grows the same card
 * downward (its top edge stays put) to show the list (cause, lever misses, mistakes,
 * hints, slowest steps) and the practice line; the button then reads Less, which
 * collapses it again. The card is placed so the expanded state is centred where the
 * card is authored, so both states stay in the view. Every show starts compact.
 * Buttons are at least minButtonDeg tall at the viewing distance (the dock's buttons are
 * 4 cm at 48 cm, about 4.8 degrees).
 * Owns: only its view and its compact / expanded state. setResult() pushes time, stats,
 * cause and tip in; setReport() the slowest steps and the practice line. Emits onRestart.
 * Must not: hold repair state or count anything (RunStats counts, RepairManager pushes).
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {
  COLOR,
  Plate,
  addLabelButton,
  addUIText,
  flexChild,
  flexColumn,
  flexRow,
  grid,
  lineCm,
  linesFor,
  makePlate,
  obj,
  plateCm,
  targetCm,
} from "./UIHelpers"

const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture

export interface FinishStats {
  leverMisses: number
  mistakes: number
  hintsUsed: number
}

/** The list rows behind More: value Text name, label. The label Text is `${name}Label`. */
const PAIRS: {name: string; label: string; value: string}[] = [
  {name: "FinishCause", label: "Cause", value: "Thorn"},
  {name: "FinishLeverMisses", label: "Lever misses", value: "0"},
  {name: "FinishMistakes", label: "Mistakes", value: "0"},
  {name: "FinishHints", label: "Hints", value: "0"},
  {name: "FinishTimes", label: "Slowest", value: "Pull 0:00 · Peel 0:00 · Lever A 0:00"},
]

@component
export class BenchCoachFinishCardUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachFinishCardUI – step 11 finish card</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Card width in cm (the height follows the content)")
  @widget(new SliderWidget(16, 40, 0.5))
  panelWidth: number = 29

  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 82

  @input
  @hint("Headline")
  titleText: string = "Flat fixed"

  @input
  @hint("Label on the restart button")
  restartLabel: string = "Start over"

  @input
  @hint("Smallest button height in degrees at the viewing distance (the dock's buttons are about 4.8)")
  @widget(new SliderWidget(2, 8, 0.1))
  minButtonDeg: number = 4.8
  @ui.group_end

  /** Pass S1: true while the list and the practice line show (More pressed). */
  expanded: boolean = false
  /** Plate width and the height of each state, in cm (tests read them). */
  width: number = 0
  compactHeight: number = 0
  expandedHeight: number = 0
  /** Height of the buttons in cm. */
  buttonHeight: number = 0

  private texts: {[name: string]: Text} = {}
  private plate: Plate | null = null
  private head: SceneObject | null = null
  private details: SceneObject | null = null
  private buttons: SceneObject | null = null
  private moreLabel: Text | null = null
  private basePos: vec3 = vec3.zero()
  private pad = 0
  private gap = 0
  private headH = 0
  private detailsH = 0
  private _onRestart = new Event<void>()
  onRestart: PublicApi<void> = this._onRestart.publicApi()

  /** Time from Found it, the run's counts, the cause and its prevention tip. */
  setResult(seconds: number, stats: FinishStats, causeLabel: string, tip: string): void {
    const s = Math.max(0, Math.floor(seconds))
    const m = Math.floor(s / 60)
    const r = s % 60
    this.set("FinishTime", `${m}:${r < 10 ? "0" : ""}${r}`)
    this.set("FinishCause", causeLabel.length > 0 ? causeLabel.charAt(0).toUpperCase() + causeLabel.substring(1) : causeLabel)
    this.set("FinishLeverMisses", `${stats.leverMisses}`)
    this.set("FinishMistakes", `${stats.mistakes}`)
    this.set("FinishHints", `${stats.hintsUsed}`)
    this.set("FinishTip", `Next time: ${tip}`)
  }

  /** Pass 11: the slowest steps ("Pull 0:12 · Peel 0:09") and the practice line. */
  setReport(slowest: string, practiceLine: string): void {
    this.set("FinishTimes", slowest)
    this.set("FinishPractice", practiceLine)
  }

  /** Text on a named line ("" if there is none), for tests. */
  textOf(name: string): string {
    return this.texts[name] ? this.texts[name].text : ""
  }

  /** Pass S1: show (true) or hide the list and the practice line. */
  setExpanded(on: boolean): void {
    this.expanded = on
    this.layout()
  }

  private set(name: string, text: string): void {
    if (this.texts[name]) this.texts[name].text = text
  }

  onAwake(): void {
    this.sceneObject.createComponent(Billboard.getTypeName())
    this.basePos = this.sceneObject.getTransform().getLocalPosition()
    this.build()
    this.layout()
    // Every show starts compact (RepairManager only enables the card).
    this.createEvent("OnEnableEvent").bind(() => this.setExpanded(false))
  }

  private build(): void {
    const d = this.viewDistanceCm
    const g = grid(d)
    const width = plateCm(this.panelWidth, d)
    const pad = g.pad * 1.3
    const innerW = width - 2 * pad
    const btnH = Math.max(4.4 * (d / 80), lineCm("button", d) * 2.6, targetCm(d, this.minButtonDeg))
    const kickerH = lineCm("secondary", d)
    const titleH = lineCm("title", d)
    const tipH = lineCm("body", d) * 2
    this.headH = kickerH + titleH + tipH + 2 * g.gap
    const labelW = innerW * 0.34
    const valueW = innerW - labelW - g.gap
    // A row holds as many lines as its sample value needs (the slowest steps take two).
    const pairLines = (v: string) => linesFor(v, "body", valueW, d)
    const pairH = (v: string) => lineCm("body", d) * pairLines(v)
    const listH = PAIRS.reduce((a, p) => a + pairH(p.value), 0) + (PAIRS.length - 1) * g.gap * 0.4
    const practiceH = lineCm("secondary", d) * 2
    this.detailsH = listH + g.gap + practiceH
    this.pad = pad
    this.gap = g.gap
    this.width = width
    this.buttonHeight = btnH
    // Compact: head, a wider gap, the buttons. Expanded: the details between them.
    this.compactHeight = 2 * pad + this.headH + 2 * g.gap + btnH
    this.expandedHeight = this.compactHeight + this.detailsH + 2 * g.gap
    this.plate = makePlate(this.sceneObject, width, this.compactHeight, d)

    // ── Head: kicker, "Flat fixed" with the time, the tip ──
    this.head = obj(this.plate.content, "Head")
    const col = flexColumn(this.head, innerW, this.headH, {gap: g.gap, justify: FlexJustify.Start, align: FlexAlign.Start})
    this.texts["FinishKicker"] = addUIText(col, "FinishKicker", "Repair complete", "secondary", innerW, kickerH, d, {color: COLOR.green})
    flexChild(col, {w: innerW, h: titleH, name: "TitleRow"}, (holder) => {
      const row = flexRow(holder, innerW, titleH, {gap: g.gap, justify: FlexJustify.Start, align: FlexAlign.Center})
      const timeW = innerW * 0.3
      this.texts["FinishTitle"] = addUIText(row, "FinishTitle", this.titleText, "title", innerW - timeW - g.gap, titleH, d)
      this.texts["FinishTime"] = addUIText(row, "FinishTime", "0:00", "title", timeW, titleH, d, {align: HorizontalAlignment.Right})
    })
    const tip = addUIText(col, "FinishTip", "Next time: run a hand round inside the tire before fitting a tube.", "body", innerW, tipH, d, {wrap: true})
    tip.verticalAlignment = VerticalAlignment.Top
    this.texts["FinishTip"] = tip

    // ── Details (behind More): the list and the practice line ──
    this.details = obj(this.plate.content, "Details")
    const dcol = flexColumn(this.details, innerW, this.detailsH, {gap: g.gap, justify: FlexJustify.Start, align: FlexAlign.Start})
    flexChild(dcol, {w: innerW, h: listH, name: "List"}, (holder) => {
      const list = flexColumn(holder, innerW, listH, {gap: g.gap * 0.4, justify: FlexJustify.Start, align: FlexAlign.Start})
      for (const p of PAIRS) {
        const ph = pairH(p.value)
        const wrap = pairLines(p.value) > 1
        flexChild(list, {w: innerW, h: ph, name: `${p.name}Row`}, (rowSo) => {
          const r = flexRow(rowSo, innerW, ph, {gap: g.gap, justify: FlexJustify.Start, align: FlexAlign.Start})
          this.texts[`${p.name}Label`] = addUIText(r, `${p.name}Label`, p.label, "secondary", labelW, lineCm("body", d), d)
          this.texts[p.name] = addUIText(r, p.name, p.value, "body", valueW, ph, d, {wrap})
          // Level with its label on the first line.
          if (wrap) this.texts[p.name].verticalAlignment = VerticalAlignment.Top
        })
      }
    })
    // Sized for the longest line it can get (RunStats.practiceTip()).
    const practice = addUIText(dcol, "FinishPractice", "Practice next: Second lever and peel, your slowest step at 10:00", "secondary", innerW, practiceH, d, {wrap: true})
    practice.verticalAlignment = VerticalAlignment.Top
    this.texts["FinishPractice"] = practice

    // ── Buttons: More / Less and Start over ──
    this.buttons = obj(this.plate.content, "Buttons")
    const btnGap = Math.max(g.gap * 1.5, targetCm(d, 1))
    const brow = flexRow(this.buttons, innerW, btnH, {gap: btnGap, justify: FlexJustify.Center, align: FlexAlign.Center})
    const moreW = (innerW - btnGap) * 0.4
    const restartW = innerW - btnGap - moreW
    const more = addLabelButton(brow, "BtnFinishMore", "More", null, moreW, btnH, d, () => this.setExpanded(!this.expanded))
    this.moreLabel = firstText(more.getSceneObject())
    addLabelButton(brow, "BtnRestart", this.restartLabel, ICON_REPLAY, restartW, btnH, d, () => this._onRestart.invoke(), "primary")
  }

  /** Places the sections for the current state and keeps the card's top edge where it is. */
  private layout(): void {
    if (!this.plate || !this.head || !this.details || !this.buttons) return
    const h = this.expanded ? this.expandedHeight : this.compactHeight
    this.plate.setHeight(h)
    const top = h / 2 - this.pad
    this.head.getTransform().setLocalPosition(new vec3(0, top - this.headH / 2, 0))
    this.details.getTransform().setLocalPosition(new vec3(0, top - this.headH - 2 * this.gap - this.detailsH / 2, 0))
    if (this.details.enabled !== this.expanded) this.details.enabled = this.expanded
    this.buttons.getTransform().setLocalPosition(new vec3(0, -h / 2 + this.pad + this.buttonHeight / 2, 0))
    if (this.moreLabel) this.moreLabel.text = this.expanded ? "Less" : "More"
    // The expanded card is centred where the card is authored; the compact one shares its top edge.
    const lift = (this.expandedHeight - h) / 2
    this.sceneObject.getTransform().setLocalPosition(new vec3(this.basePos.x, this.basePos.y + lift, this.basePos.z))
  }
}

/** The first Text under `so` (depth first), or null. */
function firstText(so: SceneObject): Text | null {
  const t = so.getComponent("Component.Text") as Text
  if (t) return t
  for (let i = 0; i < so.getChildrenCount(); i++) {
    const found = firstText(so.getChild(i))
    if (found) return found
  }
  return null
}
