/**
 * BenchCoachAskAnswerUI — the coach's answer on a light BackPlate next to the part:
 * the answer (wrapped, up to two short sentences) and a small source tag
 * ("coach" for a live answer, "offline" for a canned one). Billboarded; AskCoach
 * places it next to the step label.
 * Owns: only its view. showThinking() / showAnswer(text, tag) push content in;
 * AskCoach shows and hides the SceneObject.
 * Must not: hold repair state or call the LLM.
 */
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {FlexAlign, FlexAlignSelf, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {FlexItem} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexItem"
import {addColumnText, backPlatePanel, flexChild, flexColumn, textOn} from "./UIHelpers"

@component
export class BenchCoachAskAnswerUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachAskAnswerUI – the coach\'s answer</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Panel width in cm")
  @widget(new SliderWidget(12, 34, 0.5))
  panelWidth: number = 17

  @input
  @hint("Panel height in cm")
  @widget(new SliderWidget(4, 14, 0.5))
  panelHeight: number = 7

  @input
  @hint("Text while the answer is on its way")
  thinkingText: string = "Thinking…"

  @input
  @hint("Characters that fit at full type size; longer answers shrink")
  @widget(new SliderWidget(60, 300, 5))
  fitChars: number = 130

  @input("vec4", "{0.55, 0.85, 1, 1}")
  @hint("Source tag color (light blue; never dark on the additive display)")
  @widget(new ColorWidget())
  tagColor: vec4

  @input
  @hint("Viewing distance in cm; scales the type size")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 110
  @ui.group_end

  /** Text currently on the answer line. */
  answerText: string = ""
  /** Tag currently shown ("" while thinking). */
  tagText: string = ""

  private answer: Text | null = null
  private tag: Text | null = null
  private fullSize = 0

  showThinking(): void {
    this.set(this.thinkingText, "")
  }

  showAnswer(text: string, tag: string): void {
    this.set(text, tag)
  }

  private set(text: string, tag: string): void {
    this.answerText = text
    this.tagText = tag
    if (this.answer) {
      this.answer.text = text
      this.answer.size = this.fullSize * Math.min(1, Math.sqrt(this.fitChars / Math.max(1, text.length)))
    }
    if (this.tag) this.tag.text = tag
  }

  onAwake(): void {
    this.sceneObject.createComponent(Billboard.getTypeName())
    const pad = 0.7
    const tagH = 1.3
    const gap = 0.2
    const answerH = this.panelHeight - 2 * pad - tagH - gap
    const textW = this.panelWidth - 2 * pad
    const panel = backPlatePanel(this.sceneObject, this.panelWidth, this.panelHeight)
    const col = flexColumn(panel.content, this.panelWidth, this.panelHeight, {
      padX: pad,
      padY: pad,
      gap,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    flexChild(col, {w: textW, h: answerH, name: "AskAnswerText"}, (so) => {
      const t = textOn(so, "", "Body", textW, answerH, {distanceCm: this.viewDistanceCm})
      t.horizontalOverflow = HorizontalOverflow.Wrap
      t.verticalOverflow = VerticalOverflow.Shrink
      this.answer = t
      const item = so.getComponent(FlexItem.getTypeName()) as FlexItem
      if (item) item.alignSelf = FlexAlignSelf.Center
    })
    this.tag = addColumnText(col, "AskSourceTag", "", "Caption", tagH, {
      distanceCm: this.viewDistanceCm,
      color: this.tagColor,
    })
    if (this.answer) this.fullSize = this.answer.size
  }
}
