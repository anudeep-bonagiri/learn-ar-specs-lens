/**
 * TorusArc builds a partial (or full) torus ring at runtime with MeshBuilder.
 * The arc lies in the local XY plane. Angle 0 is 12 o'clock (+Y) and increases
 * clockwise as seen by a viewer looking down -Z at the front of the wheel.
 * Used for the rim, each tire bead segment, and each tube segment.
 * Tread (tire beads only): with treadDepth > 0 and treadBlocksPerArc > 0, the outer
 * third of the cross-section (the side facing away from the wheel center) carries
 * a square-wave radial bump, treadBlocksPerArc blocks per arc, with about four
 * rings per block; normals are then recomputed from the bumped surface.
 * Box profile (the rim): profile = 1 sweeps a box section instead of a circle,
 * boxDepthCm deep (radially) and boxWidthCm wide, with chamfered edges and a small
 * groove on each sidewall at the inner edge of the braking track; flat normals per
 * face so the edges and the track line read under the lights.
 * Sidewall band (the tire): with a bandMaterial, the cross-section faces whose
 * radial normal is below bandBelowCos (the sides and the bead, not the tread) go
 * into a second RenderMeshVisual on this SceneObject, so the tire is two-tone.
 * Sidewall line (the tire): with a stripeMaterial, the faces whose radial normal
 * lies between stripeFromCos and stripeToCos (one face ring on each sidewall) go into a
 * third RenderMeshVisual: a thin light line round the sidewall that gives the tire its
 * form on the additive display, and moves with the bead (lift, peel, deflate). With
 * stripeMirror the mirrored faces get it too: a second line where the tire meets the rim.
 */
@component
export class TorusArc extends BaseScriptComponent {
  @input
  @hint("Distance from the wheel center to the center of the tube, in cm")
  majorRadius: number = 31

  @input
  @hint("Radius of the tube cross-section, in cm")
  tubeRadius: number = 1.6

  @input
  @hint("Start angle in degrees, 0 = 12 o'clock, clockwise")
  startDeg: number = 0

  @input
  @hint("Sweep in degrees (360 for a full ring)")
  sweepDeg: number = 360

  @input
  ringSegments: number = 24

  @input
  tubeSegments: number = 12

  @input
  material: Material

  @input
  @hint("Tread block height in cm, pushed radially outward on the outer third of the cross-section (0 = smooth)")
  treadDepth: number = 0

  @input
  @hint("Tread blocks along this arc (0 = smooth); ring segments are raised to about 4 per block")
  treadBlocksPerArc: number = 0

  @input
  @hint("Cast shadows onto the floor mat")
  castShadows: boolean = false

  @input
  @hint("Cross-section: 0 = round tube, 1 = box section (rim)")
  @widget(new ComboBoxWidget([new ComboBoxItem("Round", 0), new ComboBoxItem("Box", 1)]))
  profile: number = 0

  @input
  @hint("Box section: radial depth, in cm")
  boxDepthCm: number = 3.2

  @input
  @hint("Box section: width across the wheel (Z), in cm")
  boxWidthCm: number = 2.0

  @input
  @hint("Box section: braking track height on each sidewall, measured in from the outer edge, in cm")
  brakeTrackCm: number = 1.1

  @input
  @allowUndefined
  @hint("Optional second material for the sidewall band (tire gumwall); empty = one material")
  bandMaterial: Material

  @input
  @hint("Faces whose radial normal is below this go to the band (0.38 keeps about 135 degrees of tread)")
  bandBelowCos: number = 0.38

  @input
  @allowUndefined
  @hint("Optional third material: a thin line round each sidewall; empty = none")
  stripeMaterial: Material

  @input
  @hint("Sidewall line: faces whose radial normal is at least this go to the line")
  stripeFromCos: number = 0.1

  @input
  @hint("Sidewall line: faces whose radial normal is at most this go to the line")
  stripeToCos: number = 0.3

  @input
  @hint("Sidewall line: also the mirrored faces (radial normal between -to and -from), a second line by the rim")
  stripeMirror: boolean = false

  private rmv: RenderMeshVisual | null = null
  private bandRmv: RenderMeshVisual | null = null
  private stripeRmv: RenderMeshVisual | null = null

  onAwake(): void {
    this.build()
  }

  /**
   * Cross-section loop as [dr, dz, nr, nz] per point (offset from the tube center
   * along the radial direction and Z, plus the normal in that plane), wound from
   * the outward radial side toward +Z. The last point closes onto the first.
   */
  private section(): number[][] {
    const pts: number[][] = []
    if (this.profile !== 1) {
      const tubes = Math.max(3, Math.floor(this.tubeSegments))
      for (let j = 0; j <= tubes; j++) {
        const phi = (2 * Math.PI * j) / tubes
        const cp = Math.cos(phi)
        const sp = Math.sin(phi)
        pts.push([this.tubeRadius * cp, this.tubeRadius * sp, cp, sp])
      }
      return pts
    }
    // Box section: outer bed, chamfer, braking track, groove, lower sidewall,
    // chamfer, spoke bed; then the mirror image on the -Z side. Flat faces.
    const ro = this.boxDepthCm / 2
    const ri = -this.boxDepthCm / 2
    const hw = this.boxWidthCm / 2
    const rt = ro - Math.max(0.3, this.brakeTrackCm)
    const g = 0.06 // groove depth
    const gh = 0.16 // groove height
    const half: number[][] = [
      [ro, 0],
      [ro, hw - 0.12],
      [ro - 0.12, hw],
      [rt, hw],
      [rt, hw - g],
      [rt - gh, hw - g],
      [rt - gh, hw],
      [ri + 0.45, hw - 0.06],
      [ri, hw - 0.45],
      [ri, 0],
    ]
    const loop = half.concat(half.slice(1, half.length - 1).reverse().map((q) => [q[0], -q[1]])).concat([[ro, 0]])
    for (let k = 0; k + 1 < loop.length; k++) {
      const a = loop[k]
      const b = loop[k + 1]
      const dr = b[0] - a[0]
      const dz = b[1] - a[1]
      const len = Math.sqrt(dr * dr + dz * dz)
      if (len < 1e-5) continue
      // Outward normal of the face: the loop runs counter-clockwise in (r, z).
      const nr = dz / len
      const nz = -dr / len
      pts.push([a[0], a[1], nr, nz], [b[0], b[1], nr, nz])
    }
    return pts
  }

  private build(): void {
    const full = Math.abs(this.sweepDeg) >= 359.9
    const blocks = Math.max(0, Math.floor(this.treadBlocksPerArc))
    const box = this.profile === 1
    const tread = !box && this.treadDepth > 0 && blocks > 0
    const rings = Math.max(2, Math.floor(this.ringSegments), tread ? blocks * 4 : 0)
    const sec = this.section()
    const cols = sec.length - 1
    const start = (this.startDeg * Math.PI) / 180
    const sweep = (this.sweepDeg * Math.PI) / 180
    const R = this.majorRadius

    const verts: number[] = []
    const main: number[] = []
    const band: number[] = []
    const stripe: number[] = []

    // Grid of (rings+1) x (cols+1) vertices
    for (let i = 0; i <= rings; i++) {
      const theta = start + (sweep * i) / rings
      const sx = Math.sin(theta)
      const cy = Math.cos(theta)
      for (let j = 0; j <= cols; j++) {
        const [dr, dz, nr, nz] = sec[j]
        // Tread: square wave along the arc (blocks centered in each period, so both
        // arc ends are low and the end caps still fit), only where the cross-section
        // faces away from the wheel center (cos(phi) > 0.6, the outer third).
        let bump = 0
        if (tread && nr > 0.6) {
          const f = ((i * blocks) / rings) % 1
          if (f >= 0.25 - 1e-6 && f < 0.75 - 1e-6) bump = this.treadDepth
        }
        verts.push((R + dr + bump) * sx, (R + dr + bump) * cy, dz, nr * sx, nr * cy, nz, i / rings, j / cols)
      }
    }
    const stride = cols + 1
    if (tread) this.recomputeNormals(verts, rings, cols)
    const useBand = !!this.bandMaterial
    const useStripe = !!this.stripeMaterial && !box
    for (let j = 0; j < cols; j++) {
      // Box faces come in vertex pairs; skip the zero-width joins between faces.
      if (box && j % 2 === 1) continue
      const midNr = (sec[j][2] + sec[j + 1][2]) / 2
      const inBand = (v: number) => v >= this.stripeFromCos && v <= this.stripeToCos
      const inStripe = useStripe && (inBand(midNr) || (this.stripeMirror && inBand(-midNr)))
      const target = inStripe ? stripe : useBand && midNr < this.bandBelowCos ? band : main
      for (let i = 0; i < rings; i++) {
        const a = i * stride + j
        const b = (i + 1) * stride + j
        const c = i * stride + j + 1
        const d = (i + 1) * stride + j + 1
        target.push(a, d, b, a, c, d)
      }
    }

    // End caps for partial arcs so the cut ends are not see-through
    if (!full) {
      this.addCap(verts, main, start, R, sec, -1)
      this.addCap(verts, main, start + sweep, R, sec, 1)
    }

    if (!this.rmv) {
      this.rmv = this.sceneObject.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
    }
    this.fill(this.rmv, verts, main, this.material)
    if (useBand) {
      if (!this.bandRmv) this.bandRmv = this.sceneObject.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
      this.fill(this.bandRmv, verts, band, this.bandMaterial)
    }
    if (useStripe && stripe.length > 0) {
      if (!this.stripeRmv) this.stripeRmv = this.sceneObject.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
      this.fill(this.stripeRmv, verts, stripe, this.stripeMaterial)
    }
  }

  private fill(rmv: RenderMeshVisual, verts: number[], indices: number[], material: Material | null): void {
    const builder = new MeshBuilder([
      { name: "position", components: 3 },
      { name: "normal", components: 3, normalized: true },
      { name: "texture0", components: 2 },
    ])
    builder.topology = MeshTopology.Triangles
    builder.indexType = MeshIndexType.UInt16
    builder.appendVerticesInterleaved(verts)
    builder.appendIndices(indices)
    rmv.mesh = builder.getMesh()
    if (material) rmv.mainMaterial = material
    rmv.meshShadowMode = this.castShadows ? MeshShadowMode.Caster : MeshShadowMode.None
    builder.updateMesh()
  }

  /**
   * Normals from the bumped grid: cross of the cross-section and arc directions
   * (central differences), flipped to agree with the smooth tube normal.
   */
  private recomputeNormals(verts: number[], rings: number, tubes: number): void {
    const stride = tubes + 1
    const pos = (i: number, j: number): vec3 => {
      const k = (i * stride + j) * 8
      return new vec3(verts[k], verts[k + 1], verts[k + 2])
    }
    const out: number[] = []
    for (let i = 0; i <= rings; i++) {
      for (let j = 0; j <= tubes; j++) {
        const along = pos(Math.min(rings, i + 1), j).sub(pos(Math.max(0, i - 1), j))
        const jp = j === tubes ? 1 : j + 1
        const jm = j === 0 ? tubes - 1 : j - 1
        const around = pos(i, jp).sub(pos(i, jm))
        let n = around.cross(along)
        const k = (i * stride + j) * 8
        const smooth = new vec3(verts[k + 3], verts[k + 4], verts[k + 5])
        if (n.length < 1e-6) n = smooth
        n = n.normalize()
        if (n.dot(smooth) < 0) n = n.uniformScale(-1)
        out.push(n.x, n.y, n.z)
      }
    }
    for (let v = 0; v < out.length / 3; v++) {
      verts[v * 8 + 3] = out[v * 3]
      verts[v * 8 + 4] = out[v * 3 + 1]
      verts[v * 8 + 5] = out[v * 3 + 2]
    }
  }

  // dir = -1 for the start cap (faces backward along the arc), +1 for the end cap
  private addCap(verts: number[], indices: number[], theta: number, R: number, sec: number[][], dir: number): void {
    const sx = Math.sin(theta)
    const cy = Math.cos(theta)
    // tangent along increasing theta: d/dtheta (R sin, R cos) = (R cos, -R sin)
    const tx = cy * dir
    const ty = -sx * dir
    const base = verts.length / 8
    verts.push(R * sx, R * cy, 0, tx, ty, 0, 0.5, 0.5)
    for (let j = 0; j < sec.length; j++) {
      const [dr, dz] = sec[j]
      verts.push((R + dr) * sx, (R + dr) * cy, dz, tx, ty, 0, 0.5 + 0.5 * dr, 0.5 + 0.5 * dz)
    }
    for (let j = 0; j + 1 < sec.length; j++) {
      const p = base + 1 + j
      const q = base + 1 + j + 1
      if (dir > 0) {
        indices.push(base, p, q)
      } else {
        indices.push(base, q, p)
      }
    }
  }
}
