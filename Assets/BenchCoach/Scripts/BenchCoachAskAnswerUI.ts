/**
 * BenchCoachAskAnswerUI — the coach's answer (pass D2: the shared plate, in the same
 * slot under the step callout as the chips): a header row with the source tag ("Coach"
 * for a live answer, "Offline answer" for a canned one) and BtnAnswerClose, then the
 * answer (wrapped; it shrinks to fit rather than cross the plate edge). Billboarded.
 * Owns: only its view. showThinking() / showAnswer(text, tag) push content in;
 * AskCoach shows and hides the SceneObject. Emits onClose.
 * Must not: hold repair state or call the LLM.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addIconButton, addUIText, flexChild, flexColumn, flexRow, grid, lineCm, makePlate, targetCm, plateCm} from "./UIHelpers"

const ICON_CLOSE: Texture = requireAsset("../../Icons/close.png") as Texture

@component
export class BenchCoachAskAnswerUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachAskAnswerUI – the coach\'s answer</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Panel width in cm (the step callout's width)")
  @widget(new SliderWidget(12, 34, 0.5))
  panelWidth: number = 21

  @input
  @hint("Lines of answer text the panel holds at full size (longer answers shrink)")
  @widget(new SliderWidget(2, 8, 1))
  answerLines: number = 4

  @input
  @hint("Text while the answer is on its way")
  thinkingText: string = "Thinking…"

  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 90
  @ui.group_end

  private _onClose = new Event<void>()
  /** The close button was pinched. */
  onClose: PublicApi<void> = this._onClose.publicApi()

  /** Panel height in cm (set in onAwake). */
  panelHeight: number = 0
  /** Text currently on the answer line. */
  answerText: string = ""
  /** Tag currently shown ("" while thinking). */
  tagText: string = ""

  private answer: Text | null = null
  private tag: Text | null = null

  showThinking(): void {
    this.set(this.thinkingText, "")
  }

  showAnswer(text: string, tag: string): void {
    this.set(text, tag)
  }

  private set(text: string, tag: string): void {
    this.answerText = text
    this.tagText = tag
    if (this.answer) this.answer.text = text
    if (this.tag) this.tag.text = tag
  }

  onAwake(): void {
    this.sceneObject.createComponent(Billboard.getTypeName())
    const d = this.viewDistanceCm
    // Pass V: the plate grows with the type scale (UIHelpers.plateCm).
    this.panelWidth = plateCm(this.panelWidth, d)
    const g = grid(d)
    // The header row holds BtnAnswerClose, so it is at least a 2-degree target (pass M).
    const headerH = Math.max(lineCm("secondary", d), targetCm(d))
    const answerH = lineCm("body", d) * this.answerLines
    const h = 2 * g.pad * 0.8 + headerH + g.gap + answerH
    this.panelHeight = h
    const plate = makePlate(this.sceneObject, this.panelWidth, h, d)
    const innerW = this.panelWidth - 2 * g.pad * 0.8
    const col = flexColumn(plate.content, this.panelWidth, h, {
      padX: g.pad * 0.8,
      padY: g.pad * 0.8,
      gap: g.gap,
      justify: FlexJustify.Start,
      align: FlexAlign.Center,
    })
    flexChild(col, {w: innerW, h: headerH, name: "AskAnswerHeader"}, (holder) => {
      const row = flexRow(holder, innerW, headerH, {gap: g.gap, justify: FlexJustify.SpaceBetween, align: FlexAlign.Center})
      this.tag = addUIText(row, "AskSourceTag", "", "secondary", innerW - headerH - g.gap, headerH, d)
      addIconButton(row, "BtnAnswerClose", ICON_CLOSE, headerH, () => this._onClose.invoke(), d)
    })
    this.answer = addUIText(col, "AskAnswerText", "", "body", innerW, answerH, d, {wrap: true})
  }
}
