/**
 * ProgressRail — a row of small dots on the control bar, one per step that has
 * `railDot` in StepDefinitions (the cards 0, 7 and 11 have none). Done steps are
 * small bright ticks (pass G3: shape as well as brightness, for anyone who can't
 * tell two cyans apart), the current step is a pulsing dot, steps ahead are dim
 * dots in a copy of the marker material (dim cyan, never dark on the additive display).
 * Owns: the dot children of this SceneObject. Reads the step from RepairManager.
 * Must not: change steps. Lives on ControlBar/ProgressRail, so it body-follows with the bar.
 * Expects: @inputs manager, dotMesh (unit sphere), material (MarkerMat).
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
  @hint("Dot diameter in cm")
  @widget(new SliderWidget(0.3, 2, 0.05))
  dotSizeCm: number = 0.8

  @input
  @hint("Distance between dot centers in cm")
  @widget(new SliderWidget(0.8, 4, 0.1))
  spacingCm: number = 2

  @input
  @hint("Brightness of the dots ahead, relative to the marker (dim, never dark)")
  @widget(new SliderWidget(0.1, 1, 0.05))
  dimBrightness: number = 0.5

  @input
  @hint("Width of the tick that replaces a done step's dot, in cm (shape, not only brightness, says done)")
  @widget(new SliderWidget(0.5, 3, 0.1))
  tickSizeCm: number = 1.4

  @input
  @hint("Pulses per second of the current step's dot")
  @widget(new SliderWidget(0.2, 4, 0.1))
  pulseHz: number = 1.5
  @ui.group_end

  /** Dots on the rail (one per railDot step). */
  dotCount: number = 0
  /** Dots for completed steps. */
  litCount: number = 0
  /** Index of the pulsing dot, or -1 on a card step. */
  currentIndex: number = -1

  /** Done steps shown as ticks (pass G3: never brightness alone). */
  tickCount: number = 0

  private dots: SceneObject[] = []
  private ticks: SceneObject[] = []
  private visuals: RenderMeshVisual[] = []
  private steps: number[] = []
  private dimMat: Material | null = null
  /** Runtime clone of `material` for lit dots, so the rail can fade with the control bar. */
  private litMat: Material | null = null
  private lastStep = -1
  /** Current dot opacity (0..1), set by the control bar fade. */
  opacity: number = 1

  onAwake(): void {
    if (!this.dotMesh || !this.material) {
      print("[ProgressRail] ERROR: dotMesh / material not assigned")
      return
    }
    this.steps = railSteps()
    this.litMat = this.material.clone()
    this.dimMat = this.material.clone()
    const c = this.material.mainPass.baseColor
    const b = this.dimBrightness
    this.dimMat.mainPass.baseColor = new vec4(c.x * b, c.y * b, c.z * b, 1)
    // MarkerMat has blending off; the clones blend so setOpacity() can fade the dots with the bar.
    this.litMat.mainPass.blendMode = BlendMode.Normal
    this.dimMat.mainPass.blendMode = BlendMode.Normal
    const n = this.steps.length
    for (let i = 0; i < n; i++) {
      const so = global.scene.createSceneObject(`RailDot_${i}`)
      so.setParent(this.sceneObject)
      so.getTransform().setLocalPosition(new vec3((i - (n - 1) / 2) * this.spacingCm, 0, 0))
      const rmv = so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
      rmv.mesh = this.dotMesh
      rmv.mainMaterial = this.dimMat
      this.dots.push(so)
      this.visuals.push(rmv)
      const tick = this.buildTick(`RailTick_${i}`, so.getTransform().getLocalPosition())
      tick.enabled = false
      this.ticks.push(tick)
    }
    this.dotCount = n
    this.createEvent("OnStartEvent").bind(() => {
      if (this.manager) this.manager.onStepChanged.add((s) => this.setStep(s))
    })
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Light the dots of the steps before `step`, pulse the dot of `step`, dim the rest. */
  setStep(step: number): void {
    this.lastStep = step
    let lit = 0
    this.currentIndex = -1
    for (let i = 0; i < this.steps.length; i++) {
      const s = this.steps[i]
      if (s < step) lit++
      if (s === step) this.currentIndex = i
      this.visuals[i].mainMaterial = s <= step ? this.litMat : this.dimMat
      // A done step is a tick, not a brighter dot: shape carries the state as well as brightness.
      this.ticks[i].enabled = s < step
      this.dots[i].enabled = s >= step
      this.dots[i].getTransform().setLocalScale(vec3.one().uniformScale(this.dotSizeCm))
    }
    this.litCount = lit
    this.tickCount = lit
  }

  /**
   * A small check mark from two stretched spheres (the rail has no box mesh), in the
   * StepTicks proportions: short stroke down-right into the corner, long stroke up-right.
   */
  private buildTick(name: string, at: vec3): SceneObject {
    const tick = global.scene.createSceneObject(name)
    tick.setParent(this.sceneObject)
    tick.getTransform().setLocalPosition(at)
    const s = this.tickSizeCm
    const t = s * 0.22
    this.stroke(tick, new vec3(-s * 0.3, -s * 0.05, 0), -45, s * 0.45, t)
    this.stroke(tick, new vec3(s * 0.12, s * 0.1, 0), 55, s * 0.8, t)
    return tick
  }

  private stroke(parent: SceneObject, pos: vec3, angleDeg: number, length: number, thick: number): void {
    const so = global.scene.createSceneObject("Stroke")
    so.setParent(parent)
    const tr = so.getTransform()
    tr.setLocalPosition(pos)
    tr.setLocalRotation(quat.angleAxis((angleDeg * Math.PI) / 180, new vec3(0, 0, 1)))
    tr.setLocalScale(new vec3(length, thick, thick))
    const rmv = so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
    rmv.mesh = this.dotMesh
    rmv.mainMaterial = this.litMat
  }

  /** Fade the dots (0..1); the control bar calls this with its own opacity. */
  setOpacity(o: number): void {
    if (o === this.opacity || !this.litMat || !this.dimMat) return
    this.opacity = o
    for (const m of [this.litMat, this.dimMat]) {
      const c = m.mainPass.baseColor
      m.mainPass.baseColor = new vec4(c.x, c.y, c.z, o)
    }
  }

  private tick(): void {
    if (this.dots.length === 0) return
    if (this.manager && this.manager.getState().step !== this.lastStep) this.setStep(this.manager.getState().step)
    if (this.currentIndex < 0) return
    const s = this.dotSizeCm * (1.25 + 0.25 * Math.sin(getTime() * this.pulseHz * 2 * Math.PI))
    this.dots[this.currentIndex].getTransform().setLocalScale(new vec3(s, s, s))
  }
}
