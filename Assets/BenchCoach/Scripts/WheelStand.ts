import {MeshKit} from "./MeshKit"
import {FloorLevel} from "./FloorLevel"
import {WorkspaceAnchor} from "./WorkspaceAnchor"

/**
 * WheelStand builds the repair stand with MeshBuilder (MeshKit) and stands it on
 * the measured floor (FloorLevel), reaching up to the hub wherever the floor is:
 * - StandBase: tripod collar, three legs and rubber feet on the floor.
 * - StandPost: lower tube, height-adjust collar with a knob, upper tube, top cap
 *   and the arm collar. Its origin is the post's middle (the What's this? box).
 * - StandClamp: a horizontal arm behind the wheel plane from the post to the hub,
 *   a clamp head gripping the back axle stub, and a quick-release lever.
 * The Stand root is moved to (hub x, floor y, hub z); the three children get
 * unit scale and no rotation, and their meshes are rebuilt when the floor changes.
 * Expects: @inputs hub, floorLevel, base, post, clamp (existing objects with a
 * RenderMeshVisual and StandMat).
 * Must not: move the wheel.
 */
@component
export class WheelStand extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">WheelStand – code-built repair stand on the measured floor</span>')
  @ui.separator
  @ui.group_start("References")
  @input
  @hint("Wheel hub (the clamp grips its back axle stub)")
  hub: SceneObject

  @input
  @allowUndefined
  @hint("Measured floor height; without it the stand uses fallbackFloorY")
  floorLevel: FloorLevel

  @input
  base: SceneObject

  @input
  post: SceneObject

  @input
  clamp: SceneObject
  @ui.group_end

  @ui.separator
  @ui.group_start("Settings")
  @input
  @hint("Floor height used when no FloorLevel is wired (world y, cm)")
  fallbackFloorY: number = -150

  @input
  @hint("Post position relative to the hub: x (to the user's left is negative), in cm")
  postOffsetX: number = -47

  @input
  @hint("Arm plane relative to the hub along Z (behind the wheel is negative), in cm")
  armOffsetZ: number = -8.2

  @input
  @hint("Tripod foot radius around the post, in cm")
  legSpreadCm: number = 40

  @input
  @hint("Cast shadows onto the floor mat")
  castShadows: boolean = true
  @ui.group_end

  /** World y of the floor the stand was last built on (tests read it). */
  builtFloorY: number = NaN
  tris: number = 0

  onAwake(): void {
    if (!this.hub || !this.base || !this.post || !this.clamp) {
      print("[WheelStand] ERROR: hub, base, post or clamp not wired")
      return
    }
    // OnStart: FloorLevel may sit lower in the hierarchy and not be awake yet.
    this.createEvent("OnStartEvent").bind(() => {
      this.rebuild()
      if (this.floorLevel) this.floorLevel.onFloorChanged.add(() => this.rebuild())
      WorkspaceAnchor.onMoved(() => this.rebuild())
    })
  }

  private floorY(): number {
    return this.floorLevel ? this.floorLevel.currentFloorY() : this.fallbackFloorY
  }

  rebuild(): void {
    const floor = this.floorY()
    const hubW = this.hub.getTransform().getWorldPosition()
    const root = this.sceneObject.getTransform()
    root.setWorldPosition(new vec3(hubW.x, floor, hubW.z))
    root.setWorldRotation(quat.quatIdentity())
    root.setWorldScale(vec3.one())
    const H = hubW.y - floor // hub height above the floor
    const px = this.postOffsetX
    const pz = this.armOffsetZ
    this.tris = 0
    this.buildBase(new vec3(px, 0, pz))
    this.buildPost(new vec3(px, H / 2, pz), H)
    this.buildClamp(new vec3(0, H, pz), px)
    this.builtFloorY = floor
    print(`[WheelStand] built on floor y ${floor.toFixed(1)} cm, hub ${H.toFixed(1)} cm above it, ${this.tris} tris`)
  }

  private place(so: SceneObject, local: vec3): void {
    const tr = so.getTransform()
    tr.setLocalPosition(local)
    tr.setLocalRotation(quat.quatIdentity())
    tr.setLocalScale(vec3.one())
  }

  private finish(so: SceneObject, kit: MeshKit): void {
    const existing = so.getComponent("Component.RenderMeshVisual") as RenderMeshVisual | null
    const rmv = kit.toVisual(so, existing, null)
    rmv.meshShadowMode = this.castShadows ? MeshShadowMode.Caster : MeshShadowMode.None
    this.tris += kit.triangleCount()
  }

  /** Tripod: collar on the post foot, three legs, rubber feet. Local origin = post foot on the floor. */
  private buildBase(origin: vec3): void {
    this.place(this.base, origin)
    const kit = new MeshKit()
    const up = vec3.up()
    const x = vec3.right()
    const z = vec3.forward()
    kit.lathe(vec3.zero(), up, x, z, [[0, 14], [2.9, 14], [2.9, 26], [0, 26]], 16)
    for (const deg of [0, 120, 240]) {
      const a = (deg * Math.PI) / 180
      const d = new vec3(Math.cos(a), 0, Math.sin(a))
      const top = d.uniformScale(2.4).add(new vec3(0, 20, 0))
      const foot = d.uniformScale(this.legSpreadCm).add(new vec3(0, 1.6, 0))
      kit.tube(top, foot, 1.1, 0.9, 10)
      kit.lathe(d.uniformScale(this.legSpreadCm), up, x, z, [[0, 0], [1.8, 0], [1.6, 1.4], [0, 1.4]], 12)
    }
    this.finish(this.base, kit)
  }

  /** Telescoping post with a height collar and knob, an arm collar and a top cap. Local origin = post middle. */
  private buildPost(origin: vec3, H: number): void {
    this.place(this.post, origin)
    const kit = new MeshKit()
    const up = vec3.up()
    const x = vec3.right()
    const z = vec3.forward()
    const y0 = -H / 2 // floor, in post-local
    const joint = y0 + H * 0.55
    const top = y0 + H + 6
    kit.lathe(vec3.zero(), up, x, z, [[0, y0 + 24], [2.2, y0 + 24], [2.2, joint], [0, joint]], 18)
    kit.lathe(vec3.zero(), up, x, z, [[0, joint], [1.7, joint], [1.7, top], [1.95, top], [1.95, top + 1.2], [0, top + 1.2]], 18)
    // Height-adjust collar and its T-knob toward +X
    kit.lathe(vec3.zero(), up, x, z, [[0, joint - 1.5], [2.7, joint - 1.5], [2.7, joint + 2], [0, joint + 2]], 18)
    kit.tube(new vec3(2.5, joint + 0.25, 0), new vec3(5.2, joint + 0.25, 0), 0.45, 0.45, 8)
    kit.tube(new vec3(5.2, joint - 1.6, 0), new vec3(5.2, joint + 2.1, 0), 0.55, 0.55, 8)
    // Arm collar at hub height
    kit.lathe(vec3.zero(), up, x, z, [[0, y0 + H - 3], [2.5, y0 + H - 3], [2.5, y0 + H + 3], [0, y0 + H + 3]], 18)
    this.finish(this.post, kit)
  }

  /** Arm from the post to the hub behind the wheel plane, clamp head on the axle stub, QR lever. Local origin = clamp head. */
  private buildClamp(origin: vec3, postX: number): void {
    this.place(this.clamp, origin)
    const kit = new MeshKit()
    const x = vec3.right()
    const y = vec3.up()
    const z = vec3.forward()
    // Arm: from the post collar to the clamp head
    kit.tube(new vec3(postX + 2.2, 0, 0), new vec3(-1.6, 0, 0), 1.25, 1.25, 14)
    // Clamp head: body, two jaws around the axle stub, and an end plate
    kit.box(new vec3(0, 0, -0.6), new vec3(1.9, 2.3, 1.5), x, y, z)
    kit.box(new vec3(0, 1.05, 1.55), new vec3(1.5, 0.6, 0.6), x, y, z)
    kit.box(new vec3(0, -1.05, 1.55), new vec3(1.5, 0.6, 0.6), x, y, z)
    // Quick-release lever: pivot boss on the side, then the lever folded back along the arm
    kit.lathe(new vec3(1.9, 0, -0.6), x, y, z, [[0, 0], [0.75, 0], [0.75, 0.6], [0, 0.6]], 12)
    kit.box(new vec3(2.75, -2.4, -0.6), new vec3(0.3, 2.6, 0.55), x, y, z)
    kit.lathe(new vec3(2.75, -5.1, -0.6), y, x, z, [[0, -0.6], [0.6, -0.6], [0.6, 0.6], [0, 0.6]], 10)
    this.finish(this.clamp, kit)
  }
}
