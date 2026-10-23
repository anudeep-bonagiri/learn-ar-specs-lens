/**
 * EdgeHint — the far-side cue. Every frame it projects the current StepMarker
 * into the camera; when the marker is outside the safe rectangle (or behind the
 * user) it shows EdgeArrow — a 3 cm cyan chevron parented to the camera, placed at
 * the view edge and aimed at the marker — and plays the chime once per step from
 * the marker's world position. Inside the safe rectangle the arrow hides.
 * Owns: EdgeArrow's mesh and pose, the once-per-step chime flag.
 * Expects: @inputs camera, marker (StepMarker), edgeArrow (child of the camera
 * object), arrowMaterial, audio, manager (for step changes).
 */
import {RepairManager} from "./RepairManager"
import {BenchCoachAudio} from "./BenchCoachAudio"

@component
export class EdgeHint extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">EdgeHint – edge arrow + far-side chime</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The user's camera")
  camera: Camera

  @input
  @hint("The StepMarker ring (only one is ever enabled)")
  marker: SceneObject

  @input
  @hint("EdgeArrow: an empty child of the camera object; the chevron mesh is built here")
  edgeArrow: SceneObject

  @input
  @hint("Unlit cyan material for the arrow (no black on the additive display)")
  arrowMaterial: Material

  @input
  @hint("Cue player (chime)")
  audio: BenchCoachAudio

  @input
  @hint("Step machine (resets the once-per-step chime)")
  manager: RepairManager
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Fraction of the view (centered) that counts as 'in view'; outside it the arrow shows")
  @widget(new SliderWidget(0.3, 1, 0.05))
  safeFraction: number = 0.8

  @input
  @hint("Distance from the camera to the arrow, in cm")
  @widget(new SliderWidget(20, 120, 1))
  arrowDistanceCm: number = 45

  @input
  @hint("Where along the half-view the arrow sits (1 = exactly at the edge)")
  @widget(new SliderWidget(0.5, 1, 0.05))
  edgeInset: number = 0.85

  @input
  @hint("Arrow length in cm")
  @widget(new SliderWidget(1, 10, 0.5))
  arrowLengthCm: number = 3

  @input
  @hint("Play the chime from the marker when it first leaves the view each step")
  chimeEnabled: boolean = true
  @ui.group_end

  arrowVisible: boolean = false
  private chimed = false

  onAwake(): void {
    if (this.edgeArrow) {
      this.buildArrow(this.edgeArrow)
      this.edgeArrow.enabled = false
    }
    this.createEvent("OnStartEvent").bind(() => {
      if (this.manager) this.manager.onStepChanged.add(() => (this.chimed = false))
    })
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  private tick(): void {
    if (!this.camera || !this.marker || !this.edgeArrow) return
    if (!this.marker.isEnabledInHierarchy) {
      this.setArrow(false)
      return
    }
    const markerPos = this.marker.getTransform().getWorldPosition()
    const camTr = this.camera.getTransform()
    const inv = camTr.getInvertedWorldTransform()
    const local = inv.multiplyPoint(markerPos)
    const behind = local.z > 0
    let inside = false
    if (!behind) {
      const s = this.camera.worldSpaceToScreenSpace(markerPos)
      const m = (1 - this.safeFraction) / 2
      inside = s.x >= m && s.x <= 1 - m && s.y >= m && s.y <= 1 - m
    }
    if (inside) {
      this.setArrow(false)
      return
    }

    // Direction to the marker in the camera's XY plane.
    let dx = local.x
    let dy = local.y
    const len = Math.sqrt(dx * dx + dy * dy)
    if (len < 0.001) {
      dx = 0
      dy = -1
    } else {
      dx /= len
      dy /= len
    }
    // View half-extents at the arrow depth, from the camera itself.
    const D = this.arrowDistanceCm
    const corner = inv.multiplyPoint(this.camera.screenSpaceToWorldSpace(new vec2(1, 1), D))
    const halfW = Math.abs(corner.x) * this.edgeInset
    const halfH = Math.abs(corner.y) * this.edgeInset
    const kx = Math.abs(dx) > 0.0001 ? halfW / Math.abs(dx) : Number.POSITIVE_INFINITY
    const ky = Math.abs(dy) > 0.0001 ? halfH / Math.abs(dy) : Number.POSITIVE_INFINITY
    const k = Math.min(kx, ky)
    const arrowTr = this.edgeArrow.getTransform()
    arrowTr.setLocalPosition(new vec3(dx * k, dy * k, -D))
    arrowTr.setLocalRotation(quat.angleAxis(Math.atan2(dy, dx), new vec3(0, 0, 1)))
    this.setArrow(true)

    if (this.chimeEnabled && !this.chimed && this.audio) {
      this.chimed = true
      this.audio.playChimeAt(markerPos)
    }
  }

  private setArrow(on: boolean): void {
    this.arrowVisible = on
    if (this.edgeArrow.enabled !== on) this.edgeArrow.enabled = on
  }

  /** Flat chevron pointing +X in the local XY plane, both windings so it reads from either side. */
  private buildArrow(so: SceneObject): void {
    const L = this.arrowLengthCm
    const builder = new MeshBuilder([
      {name: "position", components: 3},
      {name: "normal", components: 3, normalized: true},
      {name: "texture0", components: 2},
    ])
    builder.topology = MeshTopology.Triangles
    builder.indexType = MeshIndexType.UInt16
    const pts: number[][] = [
      [-L / 2, -L * 0.12],
      [L * 0.1, -L * 0.12],
      [L * 0.1, L * 0.12],
      [-L / 2, L * 0.12],
      [L * 0.05, -L * 0.35],
      [L / 2, 0],
      [L * 0.05, L * 0.35],
    ]
    const verts: number[] = []
    for (const p of pts) verts.push(p[0], p[1], 0, 0, 0, 1, 0.5 + p[0] / L, 0.5 + p[1] / L)
    const tris = [
      [0, 1, 2],
      [0, 2, 3],
      [4, 5, 6],
    ]
    const indices: number[] = []
    for (const t of tris) indices.push(t[0], t[1], t[2], t[0], t[2], t[1])
    builder.appendVerticesInterleaved(verts)
    builder.appendIndices(indices)
    let rmv = so.getComponent("Component.RenderMeshVisual") as RenderMeshVisual | null
    if (!rmv) rmv = so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
    rmv.mesh = builder.getMesh()
    if (this.arrowMaterial) rmv.mainMaterial = this.arrowMaterial
    builder.updateMesh()
  }
}
