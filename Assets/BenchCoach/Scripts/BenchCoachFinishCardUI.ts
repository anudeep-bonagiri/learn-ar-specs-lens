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
 * Pass S2, Practise it now: a third button, Practise <step> (BtnFinishPractise, between
 * More and Start over), drills one step three times (RepairManager.practise()). It shows
 * only when setPractise() gets a label. After a drill the compact card has one more
 * line under the tip (FinishPractised: "Practised lever A: 3 reps, best 0:06, 1 mistake")
 * and the button reads "Practise again". The buttons are placed by hand in one row, each
 * at least minButtonDeg tall and as wide as it is tall.
 * Owns: only its view and its compact / expanded state. setResult() pushes time, stats,
 * cause and tip in; setReport() the slowest steps and the practice line; setPractise() and
 * setPractised() the drill's button and line. Emits onRestart and onPractise.
 * Must not: hold repair state or count anything (RunStats counts, RepairManager pushes).
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {
  COLOR,
  Plate,
  addLabelButton,
  LAYOUT_Z_LIFT,
  addUIText,
  flexChild,
  flexColumn,
  flexRow,
  grid,
  liftInZ,
  lineCm,
  linesFor,
  makePlate,
  obj,
  plateCm,
  targetCm,
  uiTextOn,
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
  private practiseLabel: Text | null = null
  /** Button holders (More, Practise, Start over) and their widths, placed by layout(). */
  private holders: SceneObject[] = []
  private holderW: number[] = []
  private btnGap = 0
  private practised: SceneObject | null = null
  private practisedText: Text | null = null
  private practisedH = 0
  private lineH = 0
  private innerW = 0
  /** Pass S2: the Practise button shows (setPractise got a label). */
  practiseShown: boolean = false
  private basePos: vec3 = vec3.zero()
  private pad = 0
  private gap = 0
  private headH = 0
  private detailsH = 0
  private _onRestart = new Event<void>()
  onRestart: PublicApi<void> = this._onRestart.publicApi()
  private _onPractise = new Event<void>()
  /** Pass S2: the Practise button was pressed. */
  onPractise: PublicApi<void> = this._onPractise.publicApi()

  /** Pass S2: the Practise button's label ("Practise lever A", "Practise again"); "" hides it. */
  setPractise(label: string): void {
    this.practiseShown = label.length > 0
    if (this.practiseLabel && label) this.practiseLabel.text = label
    this.layout()
  }

  /** Pass S2: the line under the tip after a drill, as given ("" for none); tests read it. */
  practisedLine: string = ""

  /**
   * Pass S2: the line under the tip after a drill ("" for none). When it needs two lines it
   * breaks after the step name ("Practised lever A:" / "3 reps, best 0:06, 1 mistake"), so
   * the numbers stay together.
   */
  setPractised(line: string): void {
    if (!this.practisedText) return
    this.practisedLine = line
    const lines = line ? Math.min(2, linesFor(line, "body", this.innerW, this.viewDistanceCm)) : 0
    const colon = line.indexOf(": ")
    this.practisedText.text = lines > 1 && colon > 0 ? `${line.substring(0, colon + 1)}\n${line.substring(colon + 2)}` : line
    this.practisedH = lines * this.lineH
    this.practisedText.layoutRect = Rect.create(-this.innerW / 2, this.innerW / 2, -this.practisedH / 2, this.practisedH / 2)
    this.layout()
  }

  /** Pass S2: the Practise button's label ("" while hidden), for tests. */
  practiseText(): string {
    return this.practiseShown && this.practiseLabel ? this.practiseLabel.text : ""
  }

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
    this.lineH = lineCm("body", d)
    this.innerW = innerW
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

    // ── Pass S2: the practised line, under the tip (shown after a drill) ──
    this.practised = obj(this.plate.content, "Practised")
    liftInZ(this.practised, 2 * LAYOUT_Z_LIFT)
    const pt = obj(this.practised, "FinishPractised")
    this.practisedText = uiTextOn(pt, "", "body", innerW, 2 * this.lineH, d, {wrap: true})
    this.practisedText.verticalAlignment = VerticalAlignment.Top
    this.texts["FinishPractised"] = this.practisedText
    this.practised.enabled = false

    // ── Buttons: More / Less, Practise <step> and Start over, in one row ──
    // Each holder is its own one-item row, so a hidden Practise button leaves no gap.
    this.buttons = obj(this.plate.content, "Buttons")
    this.btnGap = Math.max(g.gap * 1.5, targetCm(d, 1))
    const moreW = btnH
    const restartW = Math.max(btnH, (innerW - 2 * this.btnGap - moreW) * 0.46)
    const practiseW = innerW - 2 * this.btnGap - moreW - restartW
    const holder = (name: string, w: number): SceneObject => {
      const so = obj(this.buttons as SceneObject, name)
      this.holders.push(so)
      this.holderW.push(w)
      return flexRow(so, w, btnH, {justify: FlexJustify.Center, align: FlexAlign.Center})
    }
    const more = addLabelButton(holder("MoreHolder", moreW), "BtnFinishMore", "More", null, moreW, btnH, d, () => this.setExpanded(!this.expanded))
    this.moreLabel = firstText(more.getSceneObject())
    // Sized for the longest label it can get ("Practise fit tube").
    const practise = addLabelButton(holder("PractiseHolder", practiseW), "BtnFinishPractise", "Practise fit tube", null, practiseW, btnH, d, () => this._onPractise.invoke())
    this.practiseLabel = firstText(practise.getSceneObject())
    addLabelButton(holder("RestartHolder", restartW), "BtnRestart", this.restartLabel, ICON_REPLAY, restartW, btnH, d, () => this._onRestart.invoke(), "primary")
  }

  /**
   * Places the sections for the current state and keeps the card's top edge where it is:
   * head, the practised line (after a drill), the details (expanded), the buttons.
   */
  private layout(): void {
    if (!this.plate || !this.head || !this.details || !this.buttons || !this.practised) return
    const g = this.gap
    const extra = this.practisedH > 0 ? this.practisedH + g : 0
    this.compactHeight = 2 * this.pad + this.headH + extra + 2 * g + this.buttonHeight
    this.expandedHeight = this.compactHeight + this.detailsH + 2 * g
    const h = this.expanded ? this.expandedHeight : this.compactHeight
    this.plate.setHeight(h)
    const top = h / 2 - this.pad
    this.head.getTransform().setLocalPosition(new vec3(0, top - this.headH / 2, 0))
    if (this.practised.enabled !== extra > 0) this.practised.enabled = extra > 0
    this.practised.getTransform().setLocalPosition(new vec3(0, top - this.headH - g - this.practisedH / 2, 2 * LAYOUT_Z_LIFT))
    this.details.getTransform().setLocalPosition(new vec3(0, top - this.headH - extra - 2 * g - this.detailsH / 2, 0))
    if (this.details.enabled !== this.expanded) this.details.enabled = this.expanded
    this.buttons.getTransform().setLocalPosition(new vec3(0, -h / 2 + this.pad + this.buttonHeight / 2, 0))
    // The row: More, Practise (when shown), Start over, centred.
    const shown = [0, 1, 2].filter((i) => i !== 1 || this.practiseShown)
    const total = shown.reduce((a, i) => a + this.holderW[i], 0) + (shown.length - 1) * this.btnGap
    let x = -total / 2
    for (let i = 0; i < this.holders.length; i++) {
      const on = shown.indexOf(i) >= 0
      if (this.holders[i].enabled !== on) this.holders[i].enabled = on
      if (!on) continue
      this.holders[i].getTransform().setLocalPosition(new vec3(x + this.holderW[i] / 2, 0, 0))
      x += this.holderW[i] + this.btnGap
    }
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
