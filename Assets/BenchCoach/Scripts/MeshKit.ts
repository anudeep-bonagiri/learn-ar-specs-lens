/**
 * MeshKit: tiny MeshBuilder helpers shared by FloorMat, FloorPath, WheelParts and WheelStand.
 * Owns: vertex/index accumulation with position + normal + uv, and triangles
 * whose winding is fixed from an outward hint, so (v1 - v0) x (v2 - v0) always
 * points outward (the convention TorusArc and LeverMesh use).
 * Must not: touch the scene beyond the RenderMeshVisual it is asked to fill.
 */
export class MeshKit {
  verts: number[] = []
  indices: number[] = []

  vertexCount(): number {
    return this.verts.length / 8
  }

  add(p: vec3, n: vec3, u: number = 0, v: number = 0): number {
    this.verts.push(p.x, p.y, p.z, n.x, n.y, n.z, u, v)
    return this.vertexCount() - 1
  }

  private pos(i: number): vec3 {
    return new vec3(this.verts[i * 8], this.verts[i * 8 + 1], this.verts[i * 8 + 2])
  }

  /** Triangle a, b, c wound so its face normal agrees with `outward`. */
  tri(a: number, b: number, c: number, outward: vec3): void {
    const pa = this.pos(a)
    const n = this.pos(b).sub(pa).cross(this.pos(c).sub(pa))
    if (n.dot(outward) >= 0) this.indices.push(a, b, c)
    else this.indices.push(a, c, b)
  }

  /** Quad a, b, c, d (in order around the edge) facing `outward`. */
  quad(a: number, b: number, c: number, d: number, outward: vec3): void {
    this.tri(a, b, c, outward)
    this.tri(a, c, d, outward)
  }

  /** Capped round tube from p0 to p1 with radii r0 and r1. */
  tube(p0: vec3, p1: vec3, r0: number, r1: number, sides: number = 10): void {
    const axis = p1.sub(p0)
    const len = axis.length
    if (len < 1e-4) return
    const w = axis.uniformScale(1 / len)
    const ref = Math.abs(w.y) < 0.9 ? vec3.up() : vec3.right()
    const u = w.cross(ref).normalize()
    const v = w.cross(u).normalize()
    const ring0: number[] = []
    const ring1: number[] = []
    for (let i = 0; i <= sides; i++) {
      const a = (2 * Math.PI * i) / sides
      const n = u.uniformScale(Math.cos(a)).add(v.uniformScale(Math.sin(a)))
      ring0.push(this.add(p0.add(n.uniformScale(r0)), n, i / sides, 0))
      ring1.push(this.add(p1.add(n.uniformScale(r1)), n, i / sides, 1))
    }
    for (let i = 0; i < sides; i++) {
      const a = (2 * Math.PI * (i + 0.5)) / sides
      const n = u.uniformScale(Math.cos(a)).add(v.uniformScale(Math.sin(a)))
      this.quad(ring0[i], ring0[i + 1], ring1[i + 1], ring1[i], n)
    }
    this.disc(p0, w.uniformScale(-1), u, v, r0, sides)
    this.disc(p1, w, u, v, r1, sides)
  }

  /** Flat disc at c facing n (u, v span the plane). */
  disc(c: vec3, n: vec3, u: vec3, v: vec3, r: number, sides: number): void {
    const center = this.add(c, n, 0.5, 0.5)
    const ring: number[] = []
    for (let i = 0; i <= sides; i++) {
      const a = (2 * Math.PI * i) / sides
      const d = u.uniformScale(Math.cos(a)).add(v.uniformScale(Math.sin(a)))
      ring.push(this.add(c.add(d.uniformScale(r)), n, 0.5 + 0.5 * Math.cos(a), 0.5 + 0.5 * Math.sin(a)))
    }
    for (let i = 0; i < sides; i++) this.tri(center, ring[i], ring[i + 1], n)
  }

  /**
   * Solid of revolution around the unit axis w through c (u, v span the plane
   * across it). `profile` is [r, h] pairs, h along w, wound bottom center -> out ->
   * up -> in -> top center, so each band's outward normal is (dh, -dr). Bands are
   * flat along the profile (crisp shoulders); around the axis they are smooth, or
   * faceted (hex nuts, knurls) when `faceted` is true. `phase` turns the first side.
   */
  lathe(c: vec3, w: vec3, u: vec3, v: vec3, profile: number[][], sides: number, faceted: boolean = false, phase: number = 0): void {
    const dir = (a: number) => u.uniformScale(Math.cos(a)).add(v.uniformScale(Math.sin(a)))
    for (let k = 0; k + 1 < profile.length; k++) {
      const r0 = profile[k][0]
      const h0 = profile[k][1]
      const r1 = profile[k + 1][0]
      const h1 = profile[k + 1][1]
      const dr = r1 - r0
      const dh = h1 - h0
      const len = Math.sqrt(dr * dr + dh * dh)
      if (len < 1e-5) continue
      const nr = dh / len
      const nh = -dr / len
      const normal = (a: number) => dir(a).uniformScale(nr).add(w.uniformScale(nh))
      for (let i = 0; i < sides; i++) {
        const a0 = phase + (2 * Math.PI * i) / sides
        const a1 = phase + (2 * Math.PI * (i + 1)) / sides
        const am = (a0 + a1) / 2
        const n0 = faceted ? normal(am) : normal(a0)
        const n1 = faceted ? normal(am) : normal(a1)
        const p = (a: number, r: number, h: number) => c.add(dir(a).uniformScale(r)).add(w.uniformScale(h))
        const q00 = this.add(p(a0, r0, h0), n0, i / sides, k / profile.length)
        const q01 = this.add(p(a1, r0, h0), n1, (i + 1) / sides, k / profile.length)
        const q11 = this.add(p(a1, r1, h1), n1, (i + 1) / sides, (k + 1) / profile.length)
        const q10 = this.add(p(a0, r1, h1), n0, i / sides, (k + 1) / profile.length)
        const hint = normal(am)
        if (r0 > 1e-5) this.tri(q00, q01, q11, hint)
        if (r1 > 1e-5) this.tri(q00, q11, q10, hint)
      }
    }
  }

  /** Box centered at c with half extents h along the axes ax, ay, az (unit, orthogonal). */
  box(c: vec3, h: vec3, ax: vec3, ay: vec3, az: vec3): void {
    const axes = [ax, ay, az]
    const half = [h.x, h.y, h.z]
    for (let k = 0; k < 3; k++) {
      for (const s of [-1, 1]) {
        const n = axes[k].uniformScale(s)
        const e1 = axes[(k + 1) % 3].uniformScale(half[(k + 1) % 3])
        const e2 = axes[(k + 2) % 3].uniformScale(half[(k + 2) % 3])
        const fc = c.add(n.uniformScale(half[k]))
        const a = this.add(fc.sub(e1).sub(e2), n, 0, 0)
        const b = this.add(fc.add(e1).sub(e2), n, 1, 0)
        const cc = this.add(fc.add(e1).add(e2), n, 1, 1)
        const d = this.add(fc.sub(e1).add(e2), n, 0, 1)
        this.quad(a, b, cc, d, n)
      }
    }
  }

  /** Build into a RenderMeshVisual (created on `so` when missing). */
  toVisual(so: SceneObject, existing: RenderMeshVisual | null, material: Material | null): RenderMeshVisual {
    const builder = new MeshBuilder([
      {name: "position", components: 3},
      {name: "normal", components: 3, normalized: true},
      {name: "texture0", components: 2},
    ])
    builder.topology = MeshTopology.Triangles
    builder.indexType = MeshIndexType.UInt16
    builder.appendVerticesInterleaved(this.verts)
    builder.appendIndices(this.indices)
    const rmv = existing ? existing : (so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual)
    rmv.mesh = builder.getMesh()
    if (material) rmv.mainMaterial = material
    builder.updateMesh()
    return rmv
  }

  triangleCount(): number {
    return this.indices.length / 3
  }
}
