import {MeshKit} from "./MeshKit"

/**
 * WheelParts builds the wheel's small parts with MeshBuilder (MeshKit), into the
 * RenderMeshVisuals already on the named objects, so every name, transform and
 * material that scripts and tests use stays as it was:
 * - Hub: round hub body, two flanges, hex locknuts and an axle stub along the
 *   wheel's Z axis (the stand's arm clamps the back stub).
 * - Spoke_i: a thin spoke from a flange hole to the rim's spoke bed, alternating
 *   flange sides, with a nipple at the rim. Each spoke is built in its own object's
 *   frame, so the What's this? box on Spoke_2 still sits on a spoke.
 * - Valve: a Presta valve along the Valve's local +Y (toward the rim): knurled tip
 *   locknut, thin core, threaded stem and a hex rim nut against the spoke bed.
 * - Tire marking: "700x25c" in light text on the sidewall at about 3 o'clock.
 * The hub, spokes and valve objects must have unit scale (the mesh is in cm).
 * Expects: @inputs hub, spokes (parent of Spoke_0..n), valve, markingBead.
 * Must not: move any part; it only replaces meshes.
 */
@component
export class WheelParts extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">WheelParts – code-built hub, spokes, valve and tire marking</span>')
  @ui.separator
  @ui.group_start("References")
  @input
  @hint("Hub object (unit scale; its RenderMeshVisual gets the hub mesh)")
  hub: SceneObject

  @input
  @hint("Parent of Spoke_0..n (each child's RenderMeshVisual gets a spoke)")
  spokes: SceneObject

  @input
  @hint("Valve object (unit scale; local +Y points out toward the rim)")
  valve: SceneObject

  @input
  @allowUndefined
  @hint("Tire bead that carries the size marking (the one covering 3 o'clock)")
  markingBead: SceneObject
  @ui.group_end

  @ui.separator
  @ui.group_start("Settings")
  @input
  @hint("Spoke radius, in cm")
  spokeRadiusCm: number = 0.12

  @input
  @hint("Radius of the rim's spoke bed (where the nipples sit), in cm")
  spokeBedRadiusCm: number = 28.4

  @input
  @hint("Flange hole circle radius, in cm")
  flangeHoleRadiusCm: number = 2.15

  @input
  @hint("Flange distance from the wheel plane, in cm")
  flangeOffsetCm: number = 2.9

  @input
  @hint("Sidewall marking text")
  markingText: string = "700x25c"

  @input
  @hint("Marking angle, degrees clockwise from 12 o'clock")
  markingAngleDeg: number = 96

  @input
  @hint("Marking radius on the sidewall, in cm")
  markingRadiusCm: number = 32.9

  @input
  @hint("Marking text size")
  markingSize: number = 12

  @input("vec4", "{0.96, 0.94, 0.88, 1}")
  @widget(new ColorWidget())
  markingColor: vec4 = new vec4(0.96, 0.94, 0.88, 1)
  @ui.group_end

  /** Triangles built (hub, spokes, valve), for the log and tests. */
  tris: number = 0

  onAwake(): void {
    if (!this.hub || !this.spokes || !this.valve) {
      print("[WheelParts] ERROR: hub, spokes or valve not wired")
      return
    }
    this.buildHub()
    this.buildSpokes()
    this.buildValve()
    this.buildMarking()
    print(`[WheelParts] built ${this.tris} tris`)
  }

  private visualOf(so: SceneObject): RenderMeshVisual {
    const rmv = so.getComponent("Component.RenderMeshVisual") as RenderMeshVisual | null
    return rmv ? rmv : (so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual)
  }

  private finish(so: SceneObject, kit: MeshKit): void {
    const rmv = this.visualOf(so)
    kit.toVisual(so, rmv, null)
    this.tris += kit.triangleCount()
  }

  /** Hub along local Z: axle stub, hex locknuts, shoulders, flanges, waisted body. */
  private buildHub(): void {
    const kit = new MeshKit()
    const c = vec3.zero()
    const w = vec3.forward()
    const u = vec3.right()
    const v = vec3.up()
    const f = this.flangeOffsetCm
    kit.lathe(
      c,
      w,
      u,
      v,
      [
        [0, -6.3],
        [0.45, -6.3],
        [0.45, -4.3],
        [1.25, -4.3],
        [1.25, -f - 0.2],
        [2.6, -f - 0.2],
        [2.6, -f + 0.2],
        [1.45, -f + 0.2],
        [1.7, 0],
        [1.45, f - 0.2],
        [2.6, f - 0.2],
        [2.6, f + 0.2],
        [1.25, f + 0.2],
        [1.25, 4.3],
        [0.45, 4.3],
        [0.45, 6.3],
        [0, 6.3],
      ],
      24
    )
    // Hex locknuts outside the shoulders
    for (const s of [-1, 1]) {
      const h0 = s < 0 ? -5.1 : 4.3
      kit.lathe(c, w, u, v, [[0, h0], [0.95, h0], [0.95, h0 + 0.8], [0, h0 + 0.8]], 6, true, Math.PI / 6)
    }
    this.finish(this.hub, kit)
  }

  /** One spoke per child, flange hole to spoke bed, alternating flanges, with a nipple. */
  private buildSpokes(): void {
    const parentWorld = this.spokes.getTransform().getWorldTransform()
    const n = this.spokes.getChildrenCount()
    for (let i = 0; i < n; i++) {
      const spoke = this.spokes.getChild(i)
      const tr = spoke.getTransform()
      // Direction from the hub to this spoke's authored midpoint, in the wheel plane.
      const mid = tr.getLocalPosition()
      const d = new vec3(mid.x, mid.y, 0)
      if (d.length < 1e-3) continue
      const dir = d.normalize()
      const side = i % 2 === 0 ? 1 : -1
      const hubEnd = dir.uniformScale(this.flangeHoleRadiusCm).add(new vec3(0, 0, side * this.flangeOffsetCm))
      const rimEnd = dir.uniformScale(this.spokeBedRadiusCm)
      const nippleStart = dir.uniformScale(this.spokeBedRadiusCm - 1.1)
      const toLocal = tr.getInvertedWorldTransform().mult(parentWorld)
      const kit = new MeshKit()
      kit.tube(toLocal.multiplyPoint(hubEnd), toLocal.multiplyPoint(rimEnd), this.spokeRadiusCm, this.spokeRadiusCm, 6)
      kit.tube(toLocal.multiplyPoint(nippleStart), toLocal.multiplyPoint(rimEnd.add(dir.uniformScale(0.1))), 0.2, 0.2, 8)
      this.finish(spoke, kit)
    }
  }

  /** Presta valve along local +Y; local 0 is the authored valve center (rim spoke bed at about +1.4). */
  private buildValve(): void {
    const kit = new MeshKit()
    const c = vec3.zero()
    const w = vec3.up()
    const u = vec3.right()
    const v = vec3.forward().uniformScale(-1)
    // Threaded stem from the core into the tire
    kit.lathe(c, w, u, v, [[0, -1.7], [0.3, -1.7], [0.3, 3.0], [0, 3.0]], 14)
    // Thin core and the knurled tip locknut
    kit.lathe(c, w, u, v, [[0, -2.75], [0.11, -2.75], [0.11, -1.7], [0, -1.7]], 8)
    kit.lathe(c, w, u, v, [[0, -2.55], [0.24, -2.55], [0.24, -2.2], [0, -2.2]], 12, true)
    // Hex rim nut seated against the spoke bed
    kit.lathe(c, w, u, v, [[0, 0.75], [0.58, 0.75], [0.58, 1.35], [0, 1.35]], 6, true, Math.PI / 6)
    this.finish(this.valve, kit)
  }

  /** "700x25c" on the sidewall, reading along the tire with the letters' tops outward. */
  private buildMarking(): void {
    if (!this.markingBead || !this.markingText) return
    const so = global.scene.createSceneObject("SizeMarking")
    so.setParent(this.markingBead)
    const a = (this.markingAngleDeg * Math.PI) / 180
    const tr = so.getTransform()
    tr.setLocalPosition(new vec3(Math.sin(a) * this.markingRadiusCm, Math.cos(a) * this.markingRadiusCm, 1.65))
    // Text runs along local +X; turn it onto the clockwise tangent with "up" pointing outward.
    tr.setLocalRotation(quat.angleAxis(-a, vec3.forward()))
    const t = so.createComponent("Component.Text") as Text
    t.text = this.markingText
    t.size = this.markingSize
    t.depthTest = true
    t.horizontalAlignment = HorizontalAlignment.Center
    t.verticalAlignment = VerticalAlignment.Center
    t.horizontalOverflow = HorizontalOverflow.Overflow
    t.verticalOverflow = VerticalOverflow.Overflow
    t.textFill.color = this.markingColor
  }
}
