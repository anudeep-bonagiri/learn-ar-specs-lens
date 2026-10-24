/**
 * BenchCoachToolTrayUI — the tool tray panel (20 x 14 cm) with a small header.
 * Owns: only the panel surface and header text. The levers and the new tube coil
 * are sibling SceneObjects (LeverA, LeverB, NewTube) authored under ToolTray, not
 * children of this panel. The panel sits 2 cm low (ToolTrayPanel y -2) so the
 * coil fits under the levers without moving them.
 */
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addColumnText, backPlatePanel, flexColumn} from "./UIHelpers"

@component
export class BenchCoachToolTrayUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachToolTrayUI – tool tray panel</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Panel width in cm")
  @widget(new SliderWidget(10, 40, 0.5))
  panelWidth: number = 20

  @input
  @hint("Panel height in cm")
  @widget(new SliderWidget(5, 20, 0.5))
  panelHeight: number = 14

  @input
  @hint("Header text along the top edge")
  headerText: string = "Tools"

  @input
  @hint("Viewing distance in cm; scales the type size")
  @widget(new SliderWidget(30, 120, 1))
  viewDistanceCm: number = 45
  @ui.group_end

  onAwake(): void {
    const panel = backPlatePanel(this.sceneObject, this.panelWidth, this.panelHeight)
    const col = flexColumn(panel.content, this.panelWidth, this.panelHeight, {
      padX: 0.8,
      padY: 0.5,
      justify: FlexJustify.Start,
      align: FlexAlign.Center,
    })
    addColumnText(col, "TrayHeader", this.headerText, "Caption", 1.6, {
      distanceCm: this.viewDistanceCm,
      color: new vec4(1, 1, 1, 0.7),
    })
  }
}
