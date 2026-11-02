/**
 * BodyFollow — lazy body-lock for the control bar and the tool tray. The
 * authored pose is read as an offset from the start pose (camera at the world
 * origin facing -Z); each frame the target is that offset carried by the
 * camera's position and yaw. The panel stays put until the user walks or turns
 * past a threshold, then glides to the target, so it never chases small head motion.
 * Thresholds 35 cm / 45 degrees (pass G6): the tray sits 35 degrees to the right, and
 * with 20 cm / 35 degrees a 26 degree turn already moved its yaw-carried target 20 cm,
 * so the tray slid away whenever the user turned to look at it. The bar and the tray
 * use the same numbers so they keep their layout (a bar that follows under a tray
 * that stays overlaps it).
 * Owns: this SceneObject's world pose. Holds still while any listed lever, or the
 * new tube end, is grabbed or tweening, so nothing is moved out from under the hand.
 * Expects: @input camera; optional @input levers (LeverPlacement on the tray's
 * levers) and tubeFit (the new tube end in the tray).
 */
import {LeverPlacement} from "./LeverPlacement"
import {TubeFit} from "./TubeFit"

@component
export class BodyFollow extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BodyFollow – lazy body-locked panel</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The user's camera")
  camera: Camera

  @input
  @hint("Levers to wait for: no following while one is grabbed or tweening")
  @allowUndefined
  levers: LeverPlacement[] = []

  @input
  @hint("New tube end in the tray: no following while it is grabbed or tweening")
  @allowUndefined
  tubeFit: TubeFit
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Start gliding once the target is this far from the panel, in cm")
  @widget(new SliderWidget(2, 80, 1))
  moveThresholdCm: number = 35

  @input
  @hint("Start gliding once the user has turned this far from the panel, in degrees")
  @widget(new SliderWidget(5, 90, 1))
  turnThresholdDeg: number = 45

  @input
  @hint("Glide speed (higher is snappier)")
  @widget(new SliderWidget(1, 20, 0.5))
  smoothing: number = 6
  @ui.group_end

  following: boolean = false

  private offsetPos = vec3.zero()
  private offsetRot = quat.quatIdentity()
  private initialized = false

  onAwake(): void {
    // The authored pose is relative to the start pose, which is the world origin facing -Z.
    const tr = this.sceneObject.getTransform()
    this.offsetPos = tr.getWorldPosition()
    this.offsetRot = tr.getWorldRotation()
    this.createEvent("LateUpdateEvent").bind(() => this.tick())
  }

  private tick(): void {
    if (!this.camera) return
    const camTr = this.camera.getTransform()
    const yaw = this.yawOf(camTr)
    const targetPos = camTr.getWorldPosition().add(yaw.multiplyVec3(this.offsetPos))
    const targetRot = yaw.multiply(this.offsetRot)
    const tr = this.sceneObject.getTransform()

    if (!this.initialized) {
      // First frame: place at the user without a glide (the preview camera may not start at the origin).
      this.initialized = true
      if (!this.isHeld()) {
        tr.setWorldPosition(targetPos)
        tr.setWorldRotation(targetRot)
      }
      return
    }
    if (this.isHeld()) {
      this.following = false
      return
    }
    const pos = tr.getWorldPosition()
    const dist = pos.distance(targetPos)
    if (!this.following) {
      const turnDeg = (quat.angleBetween(tr.getWorldRotation(), targetRot) * 180) / Math.PI
      if (dist > this.moveThresholdCm || turnDeg > this.turnThresholdDeg) this.following = true
      else return
    }
    const k = 1 - Math.exp(-this.smoothing * getDeltaTime())
    tr.setWorldPosition(vec3.lerp(pos, targetPos, k))
    tr.setWorldRotation(quat.slerp(tr.getWorldRotation(), targetRot, k))
    if (dist < 0.5) this.following = false
  }

  /** The camera's heading only: pitch and roll never tilt the panel. */
  private yawOf(camTr: Transform): quat {
    const back = camTr.getWorldRotation().multiplyVec3(new vec3(0, 0, 1))
    return quat.angleAxis(Math.atan2(back.x, back.z), new vec3(0, 1, 0))
  }

  /** A lever or the tube end is grabbed or tweening (public for the control bar fade). */
  isHeld(): boolean {
    if (this.tubeFit && this.tubeFit.isBusy()) return true
    if (!this.levers) return false
    for (const lever of this.levers) if (lever && lever.isBusy()) return true
    return false
  }
}
