import {MeshKit} from "./MeshKit"

/**
 * RearTriangle builds a bicycle rear triangle around the wheel with MeshBuilder,
 * parametric from the hub so the dropouts sit on the hub by construction.
 * Owns: chain stays, seat stays, seat tube, BB shell, dropout plates and the axle,
 * all in one mesh on this SceneObject (built once in onAwake, in local space).
 * Bike forward is -X: the BB and seat tube sit to the user's left of the wheel,
 * in the wheel plane; the stays straddle the wheel at +/- stayOffsetCm in Z.
 * Expects: `hub` wired, a light frame material.
 * Must not: move the hub or the wheel; it only reads the hub position.
 */
@component
export class RearTriangle extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">RearTriangle – code-built rear frame around the hub</span>')
  @ui.separator
  @ui.group_start("References")
  @input
  @hint("Wheel hub; the dropouts are placed on its world position")
  hub: SceneObject

  @input
  @hint("Frame material (light, saturated so it reads on the additive display)")
  material: Material
  @ui.group_end

  @ui.separator
  @ui.group_start("Geometry")
  @input
  @hint("Chain stay length, hub to bottom bracket, in cm")
  @widget(new SliderWidget(35, 50, 0.5))
  chainStayCm: number = 42

  @input
  @hint("How far the bottom bracket sits below the hub, in cm")
  @widget(new SliderWidget(0, 12, 0.5))
  bbDropCm: number = 7

  @input
  @hint("Seat tube length, bottom bracket to seat cluster, in cm")
  @widget(new SliderWidget(35, 60, 0.5))
  seatTubeCm: number = 50

  @input
  @hint("Seat tube angle from horizontal, in degrees (leans back toward the wheel)")
  @widget(new SliderWidget(65, 80, 0.5))
  seatAngleDeg: number = 73

  @input
  @hint("Half the spacing between the left and right dropouts, in cm")
  @widget(new SliderWidget(4, 9, 0.1))
  stayOffsetCm: number = 6
  @ui.group_end

  @ui.separator
  @ui.group_start("Settings")
  @input
  @hint("Cast shadows onto the floor mat")
  castShadows: boolean = true
  @ui.group_end

  private dropoutLocal: vec3 = vec3.zero()
  private bbLocal: vec3 = vec3.zero()
  private clusterLocal: vec3 = vec3.zero()
  private rmv: RenderMeshVisual | null = null
  private tris = 0

  onAwake(): void {
    this.build()
  }

  /** Midpoint of the two dropouts, in world space (equals the hub by construction). */
  dropoutWorldPos(): vec3 {
    return this.getTransform().getWorldTransform().multiplyPoint(this.dropoutLocal)
  }

  /** Point along the seat tube (t = 0 at the BB, 1 at the seat cluster), in world space. */
  seatTubeWorldPos(t: number): vec3 {
    const p = this.bbLocal.add(this.clusterLocal.sub(this.bbLocal).uniformScale(t))
    return this.getTransform().getWorldTransform().multiplyPoint(p)
  }

  triangleCount(): number {
    return this.tris
  }

  private build(): void {
    if (!this.hub) {
      print("[RearTriangle] ERROR: hub not wired")
      return
    }
    const toLocal = this.getTransform().getInvertedWorldTransform()
    const hub = toLocal.multiplyPoint(this.hub.getTransform().getWorldPosition())
    const fwd = new vec3(-1, 0, 0)
    const up = vec3.up()
    const side = new vec3(0, 0, 1)
    const horiz = Math.sqrt(Math.max(1, this.chainStayCm * this.chainStayCm - this.bbDropCm * this.bbDropCm))
    const bb = hub.add(fwd.uniformScale(horiz)).add(up.uniformScale(-this.bbDropCm))
    const a = (this.seatAngleDeg * Math.PI) / 180
    const seatDir = up.uniformScale(Math.sin(a)).add(fwd.uniformScale(-Math.cos(a)))
    const cluster = bb.add(seatDir.uniformScale(this.seatTubeCm))
    this.dropoutLocal = hub
    this.bbLocal = bb
    this.clusterLocal = cluster

    const k = new MeshKit()
    const o = this.stayOffsetCm
    for (const s of [-1, 1]) {
      const drop = hub.add(side.uniformScale(s * o))
      // chain stay: hub dropout to the BB shell end
      k.tube(drop, bb.add(side.uniformScale(s * 3.2)), 0.8, 1.1, 10)
      // seat stay: dropout to just below the seat cluster
      k.tube(drop, cluster.sub(seatDir.uniformScale(3)).add(side.uniformScale(s * 1.4)), 0.65, 0.8, 10)
      // dropout plate, flat in the wheel plane, at the hub
      k.box(drop, new vec3(2.4, 2.0, 0.3), fwd, up, side)
    }
    // axle / skewer through both dropouts and the hub
    k.tube(hub.add(side.uniformScale(-o - 0.8)), hub.add(side.uniformScale(o + 0.8)), 0.5, 0.5, 10)
    // seat tube, BB to slightly above the cluster
    k.tube(bb, cluster.add(seatDir.uniformScale(2)), 1.5, 1.5, 14)
    // BB shell across the frame
    k.tube(bb.add(side.uniformScale(-3.5)), bb.add(side.uniformScale(3.5)), 2.1, 2.1, 14)

    this.rmv = k.toVisual(this.sceneObject, this.rmv, this.material)
    this.rmv.meshShadowMode = this.castShadows ? MeshShadowMode.Caster : MeshShadowMode.None
    this.tris = k.triangleCount()

    // Seat tube clearance from the hub, in the wheel plane (tire outer radius is about 35.3 cm)
    let minD = 1e9
    for (let i = 0; i <= 50; i++) {
      const p = bb.add(cluster.sub(bb).uniformScale(i / 50))
      minD = Math.min(minD, Math.hypot(p.x - hub.x, p.y - hub.y))
    }
    print(
      `[RearTriangle] built ${this.tris} tris, ${k.vertexCount()} verts; seat tube min ${minD.toFixed(1)} cm from the hub axis`
    )
  }
}
