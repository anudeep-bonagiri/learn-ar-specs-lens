/**
 * BenchCoachToolTrayUI — the tool tray panel (pass D2: the shared plate) with a small
 * "Tools" label in its top-left corner.
 * Owns: only the panel surface and the label. The levers and the new tube coil are
 * sibling SceneObjects (LeverA, LeverB, NewTube) authored under ToolTray, not children
 * of this panel; the panel sits 2 cm low (ToolTrayPanel y -2) so the coil fits under
 * the levers, and is sized so the 12 cm levers and the coil sit inside it.
 */
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addUIText, flexColumn, lineCm, makePlate} from "./UIHelpers"

@component
export class BenchCoachToolTrayUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachToolTrayUI – tool tray panel</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Panel width in cm")
  @widget(new SliderWidget(10, 40, 0.5))
  panelWidth: number = 17

  @input
  @hint("Panel height in cm")
  @widget(new SliderWidget(5, 20, 0.5))
  panelHeight: number = 14

  @input
  @hint("Label in the top-left corner")
  headerText: string = "Tools"

  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(30, 120, 1))
  viewDistanceCm: number = 52
  @ui.group_end

  onAwake(): void {
    const d = this.viewDistanceCm
    const plate = makePlate(this.sceneObject, this.panelWidth, this.panelHeight, d)
    const col = flexColumn(plate.content, this.panelWidth, this.panelHeight, {
      padX: plate.g.pad,
      padY: plate.g.pad * 0.7,
      justify: FlexJustify.Start,
      align: FlexAlign.Start,
    })
    addUIText(col, "TrayHeader", this.headerText, "secondary", this.panelWidth - 2 * plate.g.pad, lineCm("secondary", d), d)
  }
}
