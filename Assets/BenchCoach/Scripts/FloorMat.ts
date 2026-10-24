import {MeshKit} from "./MeshKit"

/**
 * FloorMat builds a rounded-rectangle shop mat (top face plus a thin skirt) with
 * MeshBuilder: a light grey field and a pale blue border, as two RenderMeshVisuals
 * on this SceneObject so each part keeps its own material. Lies in local XZ,
 * top face at local y = 0, facing +Y. It is the shadow receiver for the bench scene.
 * Expects: `fieldMaterial` and `borderMaterial` (both light).
 * Must not: cast shadows or carry colliders (it never takes input).
 */
@component
export class FloorMat extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">FloorMat – rounded mat, the shadow receiver</span>')
  @ui.separator
  @ui.group_start("References")
  @input
  @hint("Material for the mat's field (light grey)")
  fieldMaterial: Material

  @input
  @hint("Material for the border band and skirt (pale blue)")
  borderMaterial: Material
  @ui.group_end

  @ui.separator
  @ui.group_start("Settings")
  @input
  @hint("Mat width along X, in cm")
  @widget(new SliderWidget(60, 300, 1))
  widthCm: number = 180

  @input
  @hint("Mat depth along Z, in cm")
  @widget(new SliderWidget(60, 300, 1))
  depthCm: number = 120

  @input
  @hint("Corner radius, in cm")
  @widget(new SliderWidget(0, 30, 0.5))
  cornerRadiusCm: number = 10

  @input
  @hint("Border band width, in cm")
  @widget(new SliderWidget(1, 20, 0.5))
  borderCm: number = 7

  @input
  @hint("Mat thickness (skirt height below the top face), in cm")
  @widget(new SliderWidget(0.1, 3, 0.1))
  thicknessCm: number = 0.6

  @input
  @hint("Receive shadows from the wheel, stand and frame")
  receiveShadows: boolean = true
  @ui.group_end

  private tris = 0

  onAwake(): void {
    this.build()
  }

  triangleCount(): number {
    return this.tris
  }

  /** Rounded-rectangle outline (clockwise seen from +Y), inset by `inset`. */
  private outline(inset: number, perCorner: number): vec3[] {
    const hw = this.widthCm / 2 - inset
    const hd = this.depthCm / 2 - inset
    const r = Math.max(0.01, Math.min(this.cornerRadiusCm - inset, hw, hd))
    const centers = [
      new vec3(hw - r, 0, hd - r),
      new vec3(hw - r, 0, -hd + r),
      new vec3(-hw + r, 0, -hd + r),
      new vec3(-hw + r, 0, hd - r),
    ]
    // Clockwise seen from +Y: each corner sweeps a quarter turn toward the next one.
    const startAngles = [Math.PI / 2, 0, -Math.PI / 2, -Math.PI]
    const pts: vec3[] = []
    for (let c = 0; c < 4; c++) {
      for (let i = 0; i <= perCorner; i++) {
        const a = startAngles[c] - (Math.PI / 2) * (i / perCorner)
        pts.push(centers[c].add(new vec3(Math.cos(a) * r, 0, Math.sin(a) * r)))
      }
    }
    return pts
  }

  private build(): void {
    const up = vec3.up()
    const per = 8
    const outer = this.outline(0, per)
    const inner = this.outline(this.borderCm, per)
    const n = outer.length

    // Field: fan from the center over the inner outline
    const field = new MeshKit()
    const c = field.add(vec3.zero(), up, 0.5, 0.5)
    const ring: number[] = inner.map((p) => field.add(p, up, 0.5 + p.x / this.widthCm, 0.5 + p.z / this.depthCm))
    for (let i = 0; i < n; i++) field.tri(c, ring[i], ring[(i + 1) % n], up)

    // Border band (top) and skirt (outer side)
    const border = new MeshKit()
    const lift = 0.02 // keeps the band from z-fighting the field edge
    const bi: number[] = inner.map((p) => border.add(new vec3(p.x, lift, p.z), up))
    const bo: number[] = outer.map((p) => border.add(new vec3(p.x, lift, p.z), up))
    for (let i = 0; i < n; i++) {
      const j = (i + 1) % n
      border.quad(bi[i], bo[i], bo[j], bi[j], up)
    }
    for (let i = 0; i < n; i++) {
      const j = (i + 1) % n
      const mid = outer[i].add(outer[j]).uniformScale(0.5)
      const out = new vec3(mid.x, 0, mid.z).normalize()
      const t0 = border.add(new vec3(outer[i].x, lift, outer[i].z), out)
      const t1 = border.add(new vec3(outer[j].x, lift, outer[j].z), out)
      const b1 = border.add(new vec3(outer[j].x, -this.thicknessCm, outer[j].z), out)
      const b0 = border.add(new vec3(outer[i].x, -this.thicknessCm, outer[i].z), out)
      border.quad(t0, t1, b1, b0, out)
    }

    const mode = this.receiveShadows ? MeshShadowMode.Receiver : MeshShadowMode.None
    const fieldChild = global.scene.createSceneObject("FloorMatField")
    fieldChild.setParent(this.sceneObject)
    const borderChild = global.scene.createSceneObject("FloorMatBorder")
    borderChild.setParent(this.sceneObject)
    field.toVisual(fieldChild, null, this.fieldMaterial).meshShadowMode = mode
    border.toVisual(borderChild, null, this.borderMaterial).meshShadowMode = mode
    this.tris = field.triangleCount() + border.triangleCount()
    print(`[FloorMat] built ${this.tris} tris`)
  }
}
