/**
 * TorusArc builds a partial (or full) torus ring at runtime with MeshBuilder.
 * The arc lies in the local XY plane. Angle 0 is 12 o'clock (+Y) and increases
 * clockwise as seen by a viewer looking down -Z at the front of the wheel.
 * Used for the rim, each tire bead segment, and each tube segment.
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

  private rmv: RenderMeshVisual | null = null

  onAwake(): void {
    this.build()
  }

  private build(): void {
    const builder = new MeshBuilder([
      { name: "position", components: 3 },
      { name: "normal", components: 3, normalized: true },
      { name: "texture0", components: 2 },
    ])
    builder.topology = MeshTopology.Triangles
    builder.indexType = MeshIndexType.UInt16

    const full = Math.abs(this.sweepDeg) >= 359.9
    const rings = Math.max(2, Math.floor(this.ringSegments))
    const tubes = Math.max(3, Math.floor(this.tubeSegments))
    const start = (this.startDeg * Math.PI) / 180
    const sweep = (this.sweepDeg * Math.PI) / 180
    const R = this.majorRadius
    const r = this.tubeRadius

    const verts: number[] = []
    const indices: number[] = []

    // Grid of (rings+1) x (tubes+1) vertices
    for (let i = 0; i <= rings; i++) {
      const theta = start + (sweep * i) / rings
      const sx = Math.sin(theta)
      const cy = Math.cos(theta)
      for (let j = 0; j <= tubes; j++) {
        const phi = (2 * Math.PI * j) / tubes
        const cp = Math.cos(phi)
        const sp = Math.sin(phi)
        // normal = cos(phi) * radial + sin(phi) * z
        const nx = cp * sx
        const ny = cp * cy
        const nz = sp
        verts.push(R * sx + r * nx, R * cy + r * ny, r * nz, nx, ny, nz, i / rings, j / tubes)
      }
    }
    const stride = tubes + 1
    for (let i = 0; i < rings; i++) {
      for (let j = 0; j < tubes; j++) {
        const a = i * stride + j
        const b = (i + 1) * stride + j
        const c = i * stride + j + 1
        const d = (i + 1) * stride + j + 1
        indices.push(a, d, b, a, c, d)
      }
    }

    // End caps for partial arcs so the cut ends are not see-through
    if (!full) {
      this.addCap(verts, indices, start, R, r, tubes, -1)
      this.addCap(verts, indices, start + sweep, R, r, tubes, 1)
    }

    builder.appendVerticesInterleaved(verts)
    builder.appendIndices(indices)

    if (!this.rmv) {
      this.rmv = this.sceneObject.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
    }
    this.rmv.mesh = builder.getMesh()
    if (this.material) {
      this.rmv.mainMaterial = this.material
    }
    builder.updateMesh()
  }

  // dir = -1 for the start cap (faces backward along the arc), +1 for the end cap
  private addCap(
    verts: number[],
    indices: number[],
    theta: number,
    R: number,
    r: number,
    tubes: number,
    dir: number
  ): void {
    const sx = Math.sin(theta)
    const cy = Math.cos(theta)
    // tangent along increasing theta: d/dtheta (R sin, R cos) = (R cos, -R sin)
    const tx = cy * dir
    const ty = -sx * dir
    const base = verts.length / 8
    verts.push(R * sx, R * cy, 0, tx, ty, 0, 0.5, 0.5)
    for (let j = 0; j <= tubes; j++) {
      const phi = (2 * Math.PI * j) / tubes
      const cp = Math.cos(phi)
      const sp = Math.sin(phi)
      verts.push(
        R * sx + r * cp * sx,
        R * cy + r * cp * cy,
        r * sp,
        tx,
        ty,
        0,
        0.5 + 0.5 * cp,
        0.5 + 0.5 * sp
      )
    }
    for (let j = 0; j < tubes; j++) {
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
