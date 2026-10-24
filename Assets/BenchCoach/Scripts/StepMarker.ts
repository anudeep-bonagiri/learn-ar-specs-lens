/**
 * StepMarker — pulses the glowing ring on the StepMarker SceneObject.
 * Owns: the pulse animation only. RepairManager positions and enables the object.
 * pulseBoost(sec) makes the pulse bigger and faster for a while (IdleHint uses it
 * so the ring calls attention to where the work is).
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

  @input
  @hint("During a boost the swing and rate are multiplied by this")
  @widget(new SliderWidget(1, 4, 0.1))
  boostFactor: number = 2.5
  @ui.group_end

  /** getTime() until which the pulse is boosted (0 = not boosted). */
  boostUntil: number = 0
  boostCount: number = 0

  /** Bigger, faster pulse for `seconds` (idle hint). */
  pulseBoost(seconds: number): void {
    this.boostUntil = getTime() + Math.max(0, seconds)
    this.boostCount += 1
  }

  isBoosted(): boolean {
    return getTime() < this.boostUntil
  }

  onAwake(): void {
    this.createEvent("UpdateEvent").bind(() => {
      const k = this.isBoosted() ? this.boostFactor : 1
      const s = 1 + this.pulseAmount * k * Math.sin(getTime() * this.pulseHz * Math.min(k, 2) * 2 * Math.PI)
      this.sceneObject.getTransform().setLocalScale(new vec3(s, s, s))
    })
  }
}
