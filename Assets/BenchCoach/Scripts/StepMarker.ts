/**
 * StepMarker — pulses the glowing ring on the StepMarker SceneObject.
 * Owns: the pulse animation only. RepairManager positions and enables the object.
 * Expects: a TorusArc on the same SceneObject building the 3 cm ring.
 */
@component
export class StepMarker extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">StepMarker – pulsing ring</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Pulses per second")
  @widget(new SliderWidget(0.2, 5, 0.1))
  pulseHz: number = 1.5

  @input
  @hint("Scale swing of the pulse (0.15 = 85% to 115%)")
  @widget(new SliderWidget(0, 0.5, 0.01))
  pulseAmount: number = 0.15
  @ui.group_end

  onAwake(): void {
    this.createEvent("UpdateEvent").bind(() => {
      const s = 1 + this.pulseAmount * Math.sin(getTime() * this.pulseHz * 2 * Math.PI)
      this.sceneObject.getTransform().setLocalScale(new vec3(s, s, s))
    })
  }
}
