/**
 * BenchCoachAskChipsUI — "Ask the coach" chips (pass D2: the shared plate, attached
 * under the step callout by AskCoach): a header row ("Ask the coach" and BtnAskClose)
 * and three chips (AskChip_0..2) with the current step's preset questions, billboarded.
 * Owns: only its view. setQuestions() pushes the step's questions in ([] shows the
 * empty note and hides the chips). Emits onChip(index), onClose.
 * Must not: hold repair state or call the LLM.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addIconButton, addTextButton, addUIText, flexChild, flexColumn, flexRow, grid, lineCm, makePlate} from "./UIHelpers"

const ICON_CLOSE: Texture = requireAsset("../../Icons/close.png") as Texture

export const ASK_CHIP_COUNT = 3

@component
export class BenchCoachAskChipsUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachAskChipsUI – preset question chips</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Panel width in cm (the step callout's width, so the two read as one)")
  @widget(new SliderWidget(12, 30, 0.5))
  panelWidth: number = 21

  @input
  @hint("Chip height in cm")
  @widget(new SliderWidget(2, 6, 0.1))
  chipHeight: number = 2.7

  @input
  @hint("Gap between chips in cm")
  @widget(new SliderWidget(0.2, 2, 0.1))
  gap: number = 0.35

  @input
  @hint("Header text")
  headerText: string = "Ask the coach"

  @input
  @hint("Header text on a card with no questions")
  emptyText: string = "Ask on a repair step."

  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 90
  @ui.group_end

  private _onChip = new Event<number>()
  /** A chip was pinched (its index). */
  onChip: PublicApi<number> = this._onChip.publicApi()
  private _onClose = new Event<void>()
  /** The close button was pinched. */
  onClose: PublicApi<void> = this._onClose.publicApi()

  /** Panel height in cm (set in onAwake; AskCoach hangs it under the callout). */
  height: number = 0
  /** Questions currently on the chips. */
  questions: string[] = []

  private header: Text | null = null
  private chipTexts: Text[] = []
  private chipsRoot: SceneObject | null = null

  setQuestions(list: string[]): void {
    this.questions = list.slice(0, ASK_CHIP_COUNT)
    const empty = this.questions.length === 0
    if (this.header) this.header.text = empty ? this.emptyText : this.headerText
    for (let i = 0; i < this.chipTexts.length; i++) {
      this.chipTexts[i].text = i < this.questions.length ? this.questions[i] : ""
    }
    if (this.chipsRoot && this.chipsRoot.enabled === empty) this.chipsRoot.enabled = !empty
  }

  onAwake(): void {
    this.sceneObject.createComponent(Billboard.getTypeName())
    const d = this.viewDistanceCm
    const g = grid(d)
    const headerH = Math.max(lineCm("secondary", d), 2.2)
    const chipsH = ASK_CHIP_COUNT * this.chipHeight + (ASK_CHIP_COUNT - 1) * this.gap
    const h = 2 * g.pad * 0.8 + headerH + this.gap + chipsH
    this.height = h
    const plate = makePlate(this.sceneObject, this.panelWidth, h, d)
    const innerW = this.panelWidth - 2 * g.pad * 0.8
    const col = flexColumn(plate.content, this.panelWidth, h, {
      padX: g.pad * 0.8,
      padY: g.pad * 0.8,
      gap: this.gap,
      justify: FlexJustify.Start,
      align: FlexAlign.Center,
    })
    flexChild(col, {w: innerW, h: headerH, name: "AskHeaderRow"}, (holder) => {
      const row = flexRow(holder, innerW, headerH, {gap: g.gap, justify: FlexJustify.SpaceBetween, align: FlexAlign.Center})
      this.header = addUIText(row, "AskHeader", this.headerText, "secondary", innerW - headerH - g.gap, headerH, d)
      addIconButton(row, "BtnAskClose", ICON_CLOSE, headerH, () => this._onClose.invoke(), d)
    })
    this.chipsRoot = flexChild(col, {w: innerW, h: chipsH, name: "AskChipRows"}, (holder) => {
      const chips = flexColumn(holder, innerW, chipsH, {gap: this.gap, justify: FlexJustify.Start, align: FlexAlign.Center})
      for (let i = 0; i < ASK_CHIP_COUNT; i++) {
        const idx = i
        const chip = addTextButton(chips, `AskChip_${i}`, "When does the valve come out?", innerW, this.chipHeight, d, () =>
          this._onChip.invoke(idx)
        )
        this.chipTexts.push(chip.label)
      }
    })
  }
}
