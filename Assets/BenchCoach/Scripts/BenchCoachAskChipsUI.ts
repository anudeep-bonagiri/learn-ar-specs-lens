/**
 * BenchCoachAskChipsUI — "Ask the coach" chips: a header and three UIKit Buttons
 * (AskChip_0..2) with the current step's preset questions, on a light BackPlate,
 * billboarded. AskCoach places it beside the step label.
 * Owns: only its view. setQuestions() pushes the step's questions in ([] shows the
 * empty note and hides the chips). Emits onChip(index).
 * Must not: hold repair state or call the LLM.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addColumnText, addTextButton, backPlatePanel, flexChild, flexColumn} from "./UIHelpers"

export const ASK_CHIP_COUNT = 3

@component
export class BenchCoachAskChipsUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachAskChipsUI – preset question chips</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Panel width in cm")
  @widget(new SliderWidget(12, 30, 0.5))
  panelWidth: number = 15

  @input
  @hint("Chip height in cm")
  @widget(new SliderWidget(2.4, 6, 0.1))
  chipHeight: number = 3.6

  @input
  @hint("Gap between chips in cm")
  @widget(new SliderWidget(0.2, 2, 0.1))
  gap: number = 1.6

  @input
  @hint("Header text")
  headerText: string = "Ask the coach"

  @input
  @hint("Header text on a card with no questions")
  emptyText: string = "Ask on a repair step."

  @input
  @hint("Viewing distance in cm; scales the type size")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 90
  @ui.group_end

  private _onChip = new Event<number>()
  /** A chip was pinched (its index). */
  onChip: PublicApi<number> = this._onChip.publicApi()

  /** Panel height in cm (set in onAwake; AskCoach aligns the panel's bottom edge). */
  height: number = 0
  /** Questions currently on the chips. */
  questions: string[] = []

  private header: Text | null = null
  private chipTexts: Text[] = []
  private chipsRoot: SceneObject | null = null
  private chipFullSize = 0

  setQuestions(list: string[]): void {
    this.questions = list.slice(0, ASK_CHIP_COUNT)
    const empty = this.questions.length === 0
    if (this.header) this.header.text = empty ? this.emptyText : this.headerText
    for (let i = 0; i < this.chipTexts.length; i++) {
      const q = i < this.questions.length ? this.questions[i] : ""
      this.chipTexts[i].text = q
      this.chipTexts[i].size = this.chipFullSize * Math.min(1, 34 / Math.max(1, q.length))
    }
    if (this.chipsRoot && this.chipsRoot.enabled === empty) this.chipsRoot.enabled = !empty
  }

  onAwake(): void {
    this.sceneObject.createComponent(Billboard.getTypeName())
    const pad = 0.8
    const headerH = 2.2
    const chipsH = ASK_CHIP_COUNT * this.chipHeight + (ASK_CHIP_COUNT - 1) * this.gap
    const h = 2 * pad + headerH + this.gap + chipsH
    this.height = h
    const panel = backPlatePanel(this.sceneObject, this.panelWidth, h)
    const col = flexColumn(panel.content, this.panelWidth, h, {
      padX: pad,
      padY: pad,
      gap: this.gap,
      justify: FlexJustify.Start,
      align: FlexAlign.Center,
    })
    this.header = addColumnText(col, "AskHeader", this.headerText, "Subheadline", headerH, {
      distanceCm: this.viewDistanceCm,
    })
    const chipW = this.panelWidth - 2 * pad
    this.chipsRoot = flexChild(col, {w: chipW, h: chipsH, name: "AskChipRows"}, (holder) => {
      const chips = flexColumn(holder, chipW, chipsH, {gap: this.gap, justify: FlexJustify.Start, align: FlexAlign.Center})
      for (let i = 0; i < ASK_CHIP_COUNT; i++) {
        const idx = i
        const chip = addTextButton(chips, `AskChip_${i}`, "When does the valve come out?", chipW, this.chipHeight, this.viewDistanceCm, () =>
          this._onChip.invoke(idx)
        )
        this.chipTexts.push(chip.label)
      }
    })
    if (this.chipTexts.length > 0) this.chipFullSize = this.chipTexts[0].size
  }
}
