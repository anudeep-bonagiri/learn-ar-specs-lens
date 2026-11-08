/**
 * BodyFollow — lazy body-lock for the control bar and the tool tray. The
 * authored pose is read as an offset from the start pose (camera at the world
 * origin facing -Z); each frame the target is that offset carried by the
 * camera's position and yaw. The panel stays put until the user walks or turns
 * past a threshold, then glides to the target, so it never chases small head motion.
 * The thresholds compare the camera with where it was when the panel last
 * settled (walked moveThresholdCm, or turned turnThresholdDeg), not the panel with
 * its moving target: turning the head toward a panel 30 degrees off to the side
 * moved the target past 20 cm, so the dock glided away as you looked at it.
 * It snaps (no glide) when it is enabled again and when it is further than
 * snapDistanceCm from its target: the tray is hidden until step 3, and its first
 * placement can come before the preview's camera pose lands (WorkspaceAnchor), so it
 * would otherwise sweep across the room when it appears.
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
  moveThresholdCm: number = 20

  @input
  @hint("Start gliding once the user has turned this far from the panel, in degrees")
  @widget(new SliderWidget(5, 90, 1))
  turnThresholdDeg: number = 55

  @input
  @hint("Further than this from its target (cm), the panel jumps there instead of gliding")
  @widget(new SliderWidget(30, 500, 10))
  snapDistanceCm: number = 150

  @input
  @hint("Glide speed (higher is snappier)")
  @widget(new SliderWidget(1, 20, 0.5))
  smoothing: number = 6
  @ui.group_end

  following: boolean = false

  private offsetPos = vec3.zero()
  private offsetRot = quat.quatIdentity()
  private initialized = false
  /** Camera position and yaw when the panel last settled. */
  private settledPos = vec3.zero()
  private settledYaw = quat.quatIdentity()

  onAwake(): void {
    // The authored pose is relative to the start pose, which is the world origin facing -Z.
    const tr = this.sceneObject.getTransform()
    this.offsetPos = tr.getWorldPosition()
    this.offsetRot = tr.getWorldRotation()
    this.createEvent("LateUpdateEvent").bind(() => this.tick())
    // Shown again: place it at the user on the next frame, no glide.
    this.createEvent("OnEnableEvent").bind(() => {
      this.initialized = false
      this.following = false
    })
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
      this.settle(camTr.getWorldPosition(), yaw)
      return
    }
    if (this.isHeld()) {
      this.following = false
      return
    }
    if (tr.getWorldPosition().distance(targetPos) > this.snapDistanceCm) {
      tr.setWorldPosition(targetPos)
      tr.setWorldRotation(targetRot)
      this.following = false
      this.settle(camTr.getWorldPosition(), yaw)
      return
    }
    if (!this.following) {
      const cam = camTr.getWorldPosition()
      const walked = new vec3(cam.x - this.settledPos.x, 0, cam.z - this.settledPos.z).length
      const turnDeg = (quat.angleBetween(this.settledYaw, yaw) * 180) / Math.PI
      if (walked > this.moveThresholdCm || turnDeg > this.turnThresholdDeg) this.following = true
      else return
    }
    const pos = tr.getWorldPosition()
    const k = 1 - Math.exp(-this.smoothing * getDeltaTime())
    tr.setWorldPosition(vec3.lerp(pos, targetPos, k))
    tr.setWorldRotation(quat.slerp(tr.getWorldRotation(), targetRot, k))
    if (pos.distance(targetPos) < 0.5) {
      this.following = false
      this.settle(camTr.getWorldPosition(), yaw)
    }
  }

  private settle(cam: vec3, yaw: quat): void {
    this.settledPos = cam
    this.settledYaw = yaw
  }

  /** The camera's heading only: pitch and roll never tilt the panel. */
  private yawOf(camTr: Transform): quat {
    const back = camTr.getWorldRotation().multiplyVec3(new vec3(0, 0, 1))
    return quat.angleAxis(Math.atan2(back.x, back.z), new vec3(0, 1, 0))
  }

  private isHeld(): boolean {
    if (this.tubeFit && this.tubeFit.isBusy()) return true
    if (!this.levers) return false
    for (const lever of this.levers) if (lever && lever.isBusy()) return true
    return false
  }
}
