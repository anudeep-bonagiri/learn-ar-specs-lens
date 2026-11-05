/**
 * ProgressRail — the dock's thin progress bar (pass D2; it was a row of dots): one
 * flat rounded segment per step that has `railDot` in StepDefinitions (the cards 0, 7
 * and 11 have none). Done segments are the accent, the current one glows brighter and
 * breathes, segments ahead use a dim copy of the marker material (dim cyan, never dark
 * on the additive display). The dock sets the bar's length (setLength) and position.
 * Owns: the segment children of this SceneObject. Reads the step from RepairManager.
 * Must not: change steps. Lives on ControlBar/ProgressRail, so it body-follows with the dock.
 * Expects: @inputs manager, dotMesh (unit sphere, squashed into a segment), material (MarkerMat).
 */
import {RepairManager} from "./RepairManager"
import {railSteps} from "./StepDefinitions"

@component
export class ProgressRail extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">ProgressRail – step dots on the control bar</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine")
  manager: RepairManager

  @input
  @hint("Unit sphere mesh for the dots")
  dotMesh: RenderMesh

  @input
  @hint("Marker material: done dots use it, ahead dots a dimmed copy")
  material: Material
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Bar thickness in cm")
  @widget(new SliderWidget(0.1, 1, 0.02))
  dotSizeCm: number = 0.32

  @input
  @hint("Gap between segments in cm")
  @widget(new SliderWidget(0.05, 1, 0.05))
  spacingCm: number = 0.25

  @input
  @hint("Bar length in cm (the dock sets it to fit its progress line)")
  @widget(new SliderWidget(4, 40, 0.5))
  lengthCm: number = 18

  @input
  @hint("Brightness of the dots ahead, relative to the marker (dim, never dark)")
  @widget(new SliderWidget(0.1, 1, 0.05))
  dimBrightness: number = 0.5

  @input
  @hint("Pulses per second of the current step's dot")
  @widget(new SliderWidget(0.2, 4, 0.1))
  pulseHz: number = 1.5
  @ui.group_end

  /** Dots on the rail (one per railDot step). */
  dotCount: number = 0
  /** Dots for completed steps. */
  litCount: number = 0
  /** Index of the pulsing segment, or -1 on a card step. */
  currentIndex: number = -1
  /** Segment length in cm (from lengthCm). */
  segmentCm: number = 0

  private dots: SceneObject[] = []
  private visuals: RenderMeshVisual[] = []
  private steps: number[] = []
  private dimMat: Material | null = null
  private lastStep = -1

  onAwake(): void {
    if (!this.dotMesh || !this.material) {
      print("[ProgressRail] ERROR: dotMesh / material not assigned")
      return
    }
    this.steps = railSteps()
    this.dimMat = this.material.clone()
    const c = this.material.mainPass.baseColor
    const b = this.dimBrightness
    this.dimMat.mainPass.baseColor = new vec4(c.x * b, c.y * b, c.z * b, 1)
    const n = this.steps.length
    for (let i = 0; i < n; i++) {
      const so = global.scene.createSceneObject(`RailDot_${i}`)
      so.setParent(this.sceneObject)
      const rmv = so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
      rmv.mesh = this.dotMesh
      rmv.mainMaterial = this.dimMat
      this.dots.push(so)
      this.visuals.push(rmv)
    }
    this.layout()
    this.dotCount = n
    this.createEvent("OnStartEvent").bind(() => {
      if (this.manager) this.manager.onStepChanged.add((s) => this.setStep(s))
    })
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Fit the bar to `cm` (the dock's progress line). */
  setLength(cm: number): void {
    this.lengthCm = cm
    this.layout()
  }

  private layout(): void {
    const n = this.dots.length
    if (n === 0) return
    this.segmentCm = (this.lengthCm - (n - 1) * this.spacingCm) / n
    for (let i = 0; i < n; i++) {
      const x = -this.lengthCm / 2 + this.segmentCm / 2 + i * (this.segmentCm + this.spacingCm)
      const tr = this.dots[i].getTransform()
      tr.setLocalPosition(new vec3(x, 0, 0))
      tr.setLocalScale(this.segmentScale(1))
    }
  }

  private segmentScale(k: number): vec3 {
    return new vec3(this.segmentCm, this.dotSizeCm * k, this.dotSizeCm * 0.5)
  }

  /** Light the segments of the steps before `step`, pulse the one of `step`, dim the rest. */
  setStep(step: number): void {
    this.lastStep = step
    let lit = 0
    this.currentIndex = -1
    for (let i = 0; i < this.steps.length; i++) {
      const s = this.steps[i]
      if (s < step) lit++
      if (s === step) this.currentIndex = i
      this.visuals[i].mainMaterial = s <= step ? this.material : this.dimMat
      this.dots[i].getTransform().setLocalScale(this.segmentScale(1))
    }
    this.litCount = lit
  }

  private tick(): void {
    if (this.dots.length === 0) return
    if (this.manager && this.manager.getState().step !== this.lastStep) this.setStep(this.manager.getState().step)
    if (this.currentIndex < 0) return
    const k = 1.5 + 0.35 * Math.sin(getTime() * this.pulseHz * 2 * Math.PI)
    this.dots[this.currentIndex].getTransform().setLocalScale(this.segmentScale(k))
  }
}
