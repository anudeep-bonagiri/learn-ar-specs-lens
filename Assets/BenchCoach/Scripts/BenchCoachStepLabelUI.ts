/**
 * BenchCoachStepLabelUI — the one-line step label on a light panel, billboarded.
 * Owns: only its view. setText() pushes the current step's label in.
 * Expects: RepairManager to position its SceneObject 10 cm off the marker.
 */
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addColumnText, backPlatePanel, flexColumn} from "./UIHelpers"

@component
export class BenchCoachStepLabelUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachStepLabelUI – one-line step label</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Panel width in cm")
  @widget(new SliderWidget(8, 30, 0.5))
  panelWidth: number = 16

  @input
  @hint("Panel height in cm")
  @widget(new SliderWidget(2, 12, 0.5))
  panelHeight: number = 5

  @input
  @hint("Viewing distance in cm; scales the type size")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 90

  @input
  @hint("Characters that fit on one line at full type size; longer labels shrink to stay on one line")
  @widget(new SliderWidget(10, 60, 1))
  fitChars: number = 32

  @input
  @hint("Turn to face the user (SIK Billboard, yaw only)")
  billboard: boolean = true
  @ui.group_end

  private label: Text | null = null
  private fullSize = 0

  setText(msg: string): void {
    if (!this.label) return
    this.label.text = msg
    this.label.size = this.fullSize * Math.min(1, this.fitChars / Math.max(1, msg.length))
  }

  onAwake(): void {
    if (this.billboard) this.sceneObject.createComponent(Billboard.getTypeName())
    const panel = backPlatePanel(this.sceneObject, this.panelWidth, this.panelHeight)
    const col = flexColumn(panel.content, this.panelWidth, this.panelHeight, {
      padX: 0.8,
      padY: 0.6,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    this.label = addColumnText(col, "LabelText", "", "Headline2", this.panelHeight - 1.2, {
      distanceCm: this.viewDistanceCm,
    })
    this.fullSize = this.label.size
  }
}
