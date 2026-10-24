/**
 * StepTicks — the small dim check marks that completed steps leave on their part.
 * Builds a pool of ticks (two thin boxes each) in a dimmed copy of the marker
 * material; setTicks() shows one per position and hides the rest.
 * Owns: the tick children of this SceneObject. Must not: decide which steps are
 * done or where their parts are — RepairManager passes the positions.
 * Expects: @inputs boxMesh, markerMaterial.
 */
@component
export class StepTicks extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">StepTicks – dim ticks on completed steps</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Unit box mesh for the two strokes")
  boxMesh: RenderMesh

  @input
  @hint("Marker material; ticks use a dimmed copy")
  markerMaterial: Material
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Tick width in cm (the long stroke is about this long)")
  @widget(new SliderWidget(0.5, 5, 0.1))
  sizeCm: number = 1.6

  @input
  @hint("Brightness relative to the marker (dim, but never dark on the additive display)")
  @widget(new SliderWidget(0.1, 1, 0.05))
  brightness: number = 0.45

  @input
  @hint("Most ticks shown at once")
  poolSize: number = 9
  @ui.group_end

  private ticks: SceneObject[] = []
  visibleCount: number = 0

  onAwake(): void {
    if (!this.boxMesh || !this.markerMaterial) {
      print("[StepTicks] ERROR: boxMesh / markerMaterial not assigned")
      return
    }
    const mat = this.markerMaterial.clone()
    const c = mat.mainPass.baseColor
    mat.mainPass.baseColor = new vec4(c.x * this.brightness, c.y * this.brightness, c.z * this.brightness, 1)
    for (let i = 0; i < this.poolSize; i++) this.ticks.push(this.buildTick(`Tick_${i}`, mat))
    this.setTicks([])
  }

  /** One tick per world position, in order; the rest are hidden. */
  setTicks(positions: vec3[]): void {
    this.visibleCount = Math.min(positions.length, this.ticks.length)
    for (let i = 0; i < this.ticks.length; i++) {
      const on = i < this.visibleCount
      this.ticks[i].enabled = on
      if (on) this.ticks[i].getTransform().setWorldPosition(positions[i])
    }
  }

  getTickPosition(i: number): vec3 {
    return this.ticks[i].getTransform().getWorldPosition()
  }

  private buildTick(name: string, mat: Material): SceneObject {
    const tick = global.scene.createSceneObject(name)
    tick.setParent(this.sceneObject)
    const s = this.sizeCm
    const t = s * 0.18
    // Short stroke down-right into the corner, long stroke up-right out of it.
    this.stroke(tick, new vec3(-s * 0.3, -s * 0.05, 0), -45, s * 0.45, t, mat)
    this.stroke(tick, new vec3(s * 0.12, s * 0.1, 0), 55, s * 0.8, t, mat)
    return tick
  }

  private stroke(parent: SceneObject, pos: vec3, angleDeg: number, length: number, thick: number, mat: Material): void {
    const so = global.scene.createSceneObject("Stroke")
    so.setParent(parent)
    const tr = so.getTransform()
    tr.setLocalPosition(pos)
    tr.setLocalRotation(quat.angleAxis((angleDeg * Math.PI) / 180, new vec3(0, 0, 1)))
    tr.setLocalScale(new vec3(length, thick, thick))
    const rmv = so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
    rmv.mesh = this.boxMesh
    rmv.mainMaterial = mat
  }
}
