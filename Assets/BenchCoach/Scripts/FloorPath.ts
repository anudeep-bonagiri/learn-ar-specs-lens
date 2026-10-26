/**
 * FloorPath — pass 11 (feature E). When step 5 (pull the tube from the far side)
 * starts going forward, a chain of flat chevron arrows lies on the floor mat from
 * in front of the stand, round the wheel's right side (+X, clear of the stand's
 * tripod at -X), to a spot behind the wheel
 * facing the tube end at 6 o'clock. The arrows lie on the floor mat at the
 * measured floor height (FloorLevel); the spots' own y is ignored when it is wired. A brightness wave travels along the chain toward the far side.
 * The path hides when the user arrives (camera within arriveRadiusCm of the far
 * spot on the floor plane), on any step change (so also when the pull ends step 5),
 * on Back, and whenever watch mode is playing (watch mode never walks).
 * Arrival does not complete the step; the pull still does.
 * Lives on Environment/FloorPath, so it shows and hides with the environment.
 * Owns: the arrow meshes, their per-arrow material clones, visible / arrived.
 * Expects: @inputs manager, director, camera, arrowMaterial (MarkerMat).
 * Must not: change steps or touch any other part of the repair.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {RepairManager} from "./RepairManager"
import {RepairDirector} from "./RepairDirector"
import {MeshKit} from "./MeshKit"
import {FloorLevel} from "./FloorLevel"

/** Step that shows the path (the far-side tube pull). */
const PATH_STEP = 5
/** Chevron size: length along the path, width across it, arm thickness (cm). */
const ARROW_LEN_CM = 12
const ARROW_WIDTH_CM = 11
const ARROW_ARM_CM = 3.4
/** Height of the arrows above the floor spots (the mat's top face is at the spot's y). */
const FLOOR_LIFT_CM = 0.3
/** Arrow colors: the wave's low and high points, both light (no dark on the additive display). */
const LOW_TINT = new vec3(0.5, 0.92, 1.0)
const HIGH_TINT = new vec3(0.92, 1.0, 1.0)

@component
export class FloorPath extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">FloorPath – arrows to the far side on step 5</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Step machine (step changes show and hide the path)")
  manager: RepairManager

  @input
  @hint("Watch mode: the path stays hidden while it plays")
  director: RepairDirector

  @input
  @hint("The user's camera (arrival is measured from it on the floor plane)")
  camera: Camera

  @input
  @hint("Light cyan unlit material (MarkerMat); each arrow gets its own clone for the wave")
  arrowMaterial: Material

  @input
  @allowUndefined
  @hint("Measured floor height; the arrows lie on the mat top above it")
  floorLevel: FloorLevel
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Height of the mat's top face above the floor, in cm (FloorMat's anchor offset)")
  matTopAboveFloorCm: number = 0.5

  @input
  @hint("Number of arrows in the chain")
  @widget(new SliderWidget(6, 10, 1))
  arrowCount: number = 8

  @input("vec3", "{6, -149.5, -48}")
  @hint("Floor spot where the path starts, in front of the stand (world cm; y = the mat's top)")
  startSpot: vec3 = new vec3(6, -149.5, -48)

  @input("vec3", "{10, -149.5, -124}")
  @hint("Floor spot behind the wheel where the path ends, facing the tube end (world cm)")
  farSpot: vec3 = new vec3(10, -149.5, -124)

  @input
  @hint("How far right (+X, world cm) the curve's handles pull; the curve itself peaks at about 3/4 of this")
  @widget(new SliderWidget(20, 70, 1))
  swingX: number = 45

  @input
  @hint("Arrival radius on the floor plane, in cm")
  @widget(new SliderWidget(10, 60, 1))
  arriveRadiusCm: number = 30

  @input
  @hint("Brightness waves per second travelling along the chain")
  @widget(new SliderWidget(0.2, 3, 0.1))
  pulseHz: number = 0.8
  @ui.group_end

  /** True while the arrows are shown. */
  visible: boolean = false
  /** True once the user reached the far spot during the current step-5 visit. */
  arrived: boolean = false
  /** Arrows built (tests read it). */
  builtCount: number = 0
  /** World positions of the arrow centers, start to far side (tests and screenshots). */
  arrowPositions: vec3[] = []

  private _onArrived = new Event<void>()
  onArrived: PublicApi<void> = this._onArrived.publicApi()

  private arrows: SceneObject[] = []
  private mats: Material[] = []
  private lastStep = -1
  private showTime = 0

  onAwake(): void {
    this.build()
    this.setArrowsEnabled(false)
    this.createEvent("OnStartEvent").bind(() => {
      // FloorLevel may sit lower in the hierarchy, so the arrows settle on the floor here.
      if (this.floorLevel) {
        this.settleOnFloor()
        this.floorLevel.onFloorChanged.add(() => this.settleOnFloor())
      }
      if (!this.manager || !this.camera || !this.arrowMaterial) {
        print("[FloorPath] ERROR: missing @input refs (manager, camera, arrowMaterial)")
        return
      }
      this.lastStep = this.manager.getState().step
      this.manager.onStepChanged.add((s) => this.onStep(s))
    })
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Show the chain (resets arrival). Kept hidden while watch mode plays. */
  show(): void {
    this.arrived = false
    if (this.director && this.director.playing) {
      this.hide()
      return
    }
    this.visible = true
    this.showTime = getTime()
    this.setArrowsEnabled(true)
  }

  hide(): void {
    this.visible = false
    this.setArrowsEnabled(false)
  }

  /**
   * Every step change hides the path; only a forward entry into step 5 (from an
   * earlier step: the peel finishing, Next, or jumpToStep) shows it. Back into 5 does not.
   */
  private onStep(step: number): void {
    const from = this.lastStep
    this.lastStep = step
    this.hide()
    if (step === PATH_STEP && from < PATH_STEP) this.show()
  }

  private tick(): void {
    if (!this.visible || !this.camera) return
    if (this.director && this.director.playing) {
      this.hide()
      return
    }
    const cam = this.camera.getTransform().getWorldPosition()
    const dx = cam.x - this.farSpot.x
    const dz = cam.z - this.farSpot.z
    if (Math.sqrt(dx * dx + dz * dz) <= this.arriveRadiusCm) {
      this.arrived = true
      this.hide()
      print("[FloorPath] arrived at the far side")
      this._onArrived.invoke()
      return
    }
    // A brightness crest runs from the first arrow to the last, then starts again.
    const n = this.mats.length
    const phase = ((getTime() - this.showTime) * this.pulseHz) % 1
    for (let i = 0; i < n; i++) {
      let d = phase * (n + 2) - 1 - i
      d = Math.max(0, 1 - Math.abs(d) / 1.5)
      const w = d * d * (3 - 2 * d)
      const c = vec3.lerp(LOW_TINT, HIGH_TINT, w)
      this.mats[i].mainPass.baseColor = new vec4(c.x, c.y, c.z, 1)
    }
  }

  /** World y of the mat's top face (the arrows sit FLOOR_LIFT_CM above it); the spots' y until FloorLevel is wired. */
  private matTopY(): number {
    return this.floorLevel ? this.floorLevel.currentFloorY() + this.matTopAboveFloorCm : this.startSpot.y
  }

  /** Moves the built arrows onto the current floor. */
  private settleOnFloor(): void {
    const y = this.matTopY() + FLOOR_LIFT_CM
    for (let k = 0; k < this.arrows.length; k++) {
      const tr = this.arrows[k].getTransform()
      const p = tr.getWorldPosition()
      tr.setWorldPosition(new vec3(p.x, y, p.z))
      this.arrowPositions[k] = new vec3(p.x, y, p.z)
    }
  }

  private setArrowsEnabled(on: boolean): void {
    for (const a of this.arrows) if (a.enabled !== on) a.enabled = on
  }

  /** Cubic curve on the floor from startSpot to farSpot, both handles pulled to +X. */
  private curve(t: number): vec3 {
    const p0 = this.startSpot
    const p3 = this.farSpot
    const p1 = new vec3(this.swingX, p0.y, p0.z - 10)
    const p2 = new vec3(this.swingX, p3.y, p3.z + 10)
    const u = 1 - t
    const a = u * u * u
    const b = 3 * u * u * t
    const c = 3 * u * t * t
    const d = t * t * t
    return new vec3(
      a * p0.x + b * p1.x + c * p2.x + d * p3.x,
      a * p0.y + b * p1.y + c * p2.y + d * p3.y,
      a * p0.z + b * p1.z + c * p2.z + d * p3.z
    )
  }

  private build(): void {
    if (!this.arrowMaterial) return
    // Sample the curve by arc length so the arrows sit evenly.
    const samples = 200
    const pts: vec3[] = []
    const acc: number[] = [0]
    for (let i = 0; i <= samples; i++) pts.push(this.curve(i / samples))
    for (let i = 1; i <= samples; i++) acc.push(acc[i - 1] + pts[i].distance(pts[i - 1]))
    const total = acc[samples]
    const n = Math.max(2, Math.round(this.arrowCount))
    const mesh = this.chevronMesh()
    const parentInv = this.sceneObject.getTransform().getInvertedWorldTransform()
    for (let k = 0; k < n; k++) {
      // From one arrow length after the start to one arrow length before the far spot.
      const s = ARROW_LEN_CM * 0.6 + ((total - ARROW_LEN_CM * 1.6) * k) / (n - 1)
      let j = 1
      while (j < samples && acc[j] < s) j++
      const f = (s - acc[j - 1]) / Math.max(1e-4, acc[j] - acc[j - 1])
      const p = vec3.lerp(pts[j - 1], pts[j], f)
      const dir = pts[j].sub(pts[j - 1])
      const so = global.scene.createSceneObject(`PathArrow_${k}`)
      so.setParent(this.sceneObject)
      const world = new vec3(p.x, this.startSpot.y + FLOOR_LIFT_CM, p.z)
      const tr = so.getTransform()
      tr.setLocalPosition(parentInv.multiplyPoint(world))
      // The chevron points along local +X; yaw it onto the path tangent.
      tr.setWorldRotation(quat.angleAxis(Math.atan2(-dir.z, dir.x), vec3.up()))
      const rmv = so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
      rmv.mesh = mesh
      const mat = this.arrowMaterial.clone()
      mat.mainPass.baseColor = new vec4(LOW_TINT.x, LOW_TINT.y, LOW_TINT.z, 1)
      rmv.mainMaterial = mat
      this.arrows.push(so)
      this.mats.push(mat)
      this.arrowPositions.push(world)
    }
    this.builtCount = this.arrows.length
  }

  /** Flat ">" chevron in the XZ plane pointing +X, wound counter-clockwise seen from above (faces +Y). */
  private chevronMesh(): RenderMesh {
    const L = ARROW_LEN_CM
    const W = ARROW_WIDTH_CM
    const t = ARROW_ARM_CM
    const up = vec3.up()
    const kit = new MeshKit()
    const v = (x: number, z: number) => kit.add(new vec3(x, 0, z), up, 0.5 + x / L, 0.5 + z / W)
    const tip = v(L / 2, 0)
    const tipIn = v(L / 2 - t, 0)
    const aOut = v(-L / 2, W / 2)
    const aIn = v(-L / 2 + t, W / 2)
    const bOut = v(-L / 2, -W / 2)
    const bIn = v(-L / 2 + t, -W / 2)
    kit.quad(aOut, aIn, tipIn, tip, up)
    kit.quad(bOut, tip, tipIn, bIn, up)
    const builder = new MeshBuilder([
      {name: "position", components: 3},
      {name: "normal", components: 3, normalized: true},
      {name: "texture0", components: 2},
    ])
    builder.topology = MeshTopology.Triangles
    builder.indexType = MeshIndexType.UInt16
    builder.appendVerticesInterleaved(kit.verts)
    builder.appendIndices(kit.indices)
    builder.updateMesh()
    return builder.getMesh()
  }
}
