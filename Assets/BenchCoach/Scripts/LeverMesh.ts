/**
 * LeverMesh — builds a tire-lever mesh at runtime with MeshBuilder (TorusArc.ts is
 * the house pattern) and puts it on this SceneObject's RenderMeshVisual (creating
 * one if missing, replacing the mesh if present).
 * Shape: a 12 cm shaft along local X, 2 cm wide (Y), 1 cm thick (Z), bowed gently
 * so both ends curve toward +Z; a thinner, slightly flared spoon tip with a 0.6 cm
 * lip at the -X end, and a spoke-hook notch cut into the +Y edge near the +X
 * (handle) end. Origin at the shaft center, so the sockets and the 12 x 2 x 1
 * collider on the lever root stay valid. Flat shading: per-face normals.
 * Owns: this object's mesh. Must not: move or scale anything (keep scale 1,1,1).
 * Expects: @input material (LeverMat, or GhostMat for the ghost).
 */
@component
export class LeverMesh extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">LeverMesh – curved tire lever (MeshBuilder)</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Lever material (LeverMat blue, GhostMat for the ghost)")
  material: Material
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Overall length along local X, in cm")
  @widget(new SliderWidget(6, 20, 0.5))
  lengthCm: number = 12

  @input
  @hint("Shaft width along local Y, in cm")
  @widget(new SliderWidget(1, 4, 0.1))
  widthCm: number = 2

  @input
  @hint("Shaft thickness along local Z, in cm")
  @widget(new SliderWidget(0.3, 2, 0.05))
  thicknessCm: number = 1

  @input
  @hint("How far the two ends bow toward +Z relative to the center, in cm")
  @widget(new SliderWidget(0, 2, 0.05))
  bowCm: number = 0.5

  @input
  @hint("Height of the hooking lip at the spoon tip (-X end), in cm")
  @widget(new SliderWidget(0, 1.5, 0.05))
  lipCm: number = 0.6
  @ui.group_end

  private rmv: RenderMeshVisual | null = null

  onAwake(): void {
    this.build()
  }

  private build(): void {
    const L = this.lengthCm
    const h = L / 2
    const W = this.widthCm
    const T = this.thicknessCm
    // Cross-section slices along X: [x, yMin, yMax, zBottom, zTop] before the bow.
    // Duplicated x values make crisp steps (lip wall, notch walls).
    const s: number[][] = []
    const spoonEnd = -h + L * 0.22 // spoon runs over the first ~2.6 cm
    const lipEnd = -h + 0.45
    const tipT = T * 0.45
    const tipW = W * 1.15
    // Spoon tip with lip: the lip rises from the thin tip on the +Z face.
    s.push([-h, -tipW / 2 + 0.15, tipW / 2 - 0.15, -tipT / 2, -tipT / 2 + 0.15]) // rounded nose
    s.push([-h + 0.12, -tipW / 2, tipW / 2, -tipT / 2, tipT / 2 + this.lipCm])
    s.push([lipEnd, -tipW / 2, tipW / 2, -tipT / 2, tipT / 2 + this.lipCm])
    s.push([lipEnd, -tipW / 2, tipW / 2, -tipT / 2, tipT / 2])
    // Spoon blends into the shaft.
    const blendSteps = 4
    for (let k = 1; k <= blendSteps; k++) {
      const u = k / blendSteps
      const x = lipEnd + (spoonEnd - lipEnd) * u
      const w = tipW + (W - tipW) * u
      const t = tipT + (T - tipT) * u
      s.push([x, -w / 2, w / 2, -t / 2, t / 2])
    }
    // Shaft, with the spoke-hook notch on the +Y edge near the handle end.
    const notchStart = h - 2.0
    const notchEnd = h - 1.2
    const notchY = W / 2 - W * 0.45 // the notch eats 45% of the width
    const shaftSteps = 8
    for (let k = 1; k <= shaftSteps; k++) {
      const x = spoonEnd + (notchStart - spoonEnd) * (k / shaftSteps)
      s.push([x, -W / 2, W / 2, -T / 2, T / 2])
    }
    s.push([notchStart, -W / 2, notchY, -T / 2, T / 2])
    s.push([notchEnd, -W / 2, notchY, -T / 2, T / 2])
    s.push([notchEnd, -W / 2, W / 2, -T / 2, T / 2])
    // Rounded handle end.
    s.push([h - 0.35, -W / 2, W / 2, -T / 2, T / 2])
    s.push([h - 0.1, -W / 2 + 0.2, W / 2 - 0.2, -T / 2 + 0.05, T / 2 - 0.05])
    s.push([h, -W / 2 + 0.45, W / 2 - 0.45, -T / 2 + 0.15, T / 2 - 0.15])

    const bow = (x: number): number => this.bowCm * (x / h) * (x / h)
    // Corners of a slice in order: (y0,z0) (y1,z0) (y1,z1) (y0,z1).
    const corners = (sl: number[]): vec3[] => {
      const z = bow(sl[0])
      return [
        new vec3(sl[0], sl[1], sl[3] + z),
        new vec3(sl[0], sl[2], sl[3] + z),
        new vec3(sl[0], sl[2], sl[4] + z),
        new vec3(sl[0], sl[1], sl[4] + z),
      ]
    }

    const verts: number[] = []
    const indices: number[] = []
    const center = (sl: number[]): vec3 => new vec3(sl[0], (sl[1] + sl[2]) / 2, (sl[3] + sl[4]) / 2 + bow(sl[0]))

    for (let i = 0; i + 1 < s.length; i++) {
      const a = corners(s[i])
      const b = corners(s[i + 1])
      let mid = center(s[i]).add(center(s[i + 1])).uniformScale(0.5)
      if (Math.abs(s[i + 1][0] - s[i][0]) < 1e-4) {
        // A step wall (lip, notch): the solid lies on the side of the larger cross-section.
        const area = (sl: number[]): number => (sl[2] - sl[1]) * (sl[4] - sl[3])
        mid = mid.add(new vec3(area(s[i]) > area(s[i + 1]) ? -1 : 1, 0, 0))
      }
      for (let e = 0; e < 4; e++) {
        const e2 = (e + 1) % 4
        this.addQuad(verts, indices, a[e], a[e2], b[e2], b[e], mid)
      }
    }
    // End caps.
    const first = corners(s[0])
    const last = corners(s[s.length - 1])
    this.addQuad(verts, indices, first[0], first[1], first[2], first[3], center(s[0]).add(new vec3(1, 0, 0)))
    this.addQuad(verts, indices, last[0], last[1], last[2], last[3], center(s[s.length - 1]).add(new vec3(-1, 0, 0)))

    const builder = new MeshBuilder([
      {name: "position", components: 3},
      {name: "normal", components: 3, normalized: true},
      {name: "texture0", components: 2},
    ])
    builder.topology = MeshTopology.Triangles
    builder.indexType = MeshIndexType.UInt16
    builder.appendVerticesInterleaved(verts)
    builder.appendIndices(indices)

    this.rmv = this.sceneObject.getComponent("Component.RenderMeshVisual") as RenderMeshVisual | null
    if (!this.rmv) this.rmv = this.sceneObject.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
    this.rmv.mesh = builder.getMesh()
    if (this.material) this.rmv.mainMaterial = this.material
    builder.updateMesh()
  }

  /**
   * One flat quad (p0 p1 p2 p3 around its edge). Skips degenerate quads (the
   * zero-area faces at step slices). Winds it CCW seen from outside: the face
   * normal (v1 - v0) x (v2 - v0) must point away from `inside`.
   */
  private addQuad(verts: number[], indices: number[], p0: vec3, p1: vec3, p2: vec3, p3: vec3, inside: vec3): void {
    let n = p1.sub(p0).cross(p2.sub(p0)).add(p2.sub(p0).cross(p3.sub(p0)))
    if (n.length < 1e-5) return
    n = n.normalize()
    const c = p0.add(p1).add(p2).add(p3).uniformScale(0.25)
    let q = [p0, p1, p2, p3]
    if (n.dot(c.sub(inside)) < 0) {
      q = [p0, p3, p2, p1]
      n = n.uniformScale(-1)
    }
    const base = verts.length / 8
    const uv = [
      [0, 0],
      [1, 0],
      [1, 1],
      [0, 1],
    ]
    for (let k = 0; k < 4; k++) verts.push(q[k].x, q[k].y, q[k].z, n.x, n.y, n.z, uv[k][0], uv[k][1])
    indices.push(base, base + 1, base + 2, base, base + 2, base + 3)
  }
}
