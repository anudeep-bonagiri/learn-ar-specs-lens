/**
 * GhostAnimator — plays the ghost lever's hooking motion: from a raised, tilted
 * approach pose into the exact socket pose over `durationSec` with ease-in-out.
 * Owns: the ghost's transform while playing. play() is called on step entry and Replay.
 * Expects: @input socket = LeverSocket (the target pose); RepairManager retargets it
 * with setSocket() for the second socket.
 * SetLoop(true) repeats the motion (with loopHoldSec at the socket between
 * passes) until the ghost is hidden; AdaptiveCoach sets it on a step the user struggled with.
 */
@component
export class GhostAnimator extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">GhostAnimator – ghost lever hooking motion</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("LeverSocket: the pose the ghost animates into")
  socket: SceneObject
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Length of the hooking motion in seconds")
  @widget(new SliderWidget(0.2, 3, 0.1))
  durationSec: number = 0.8

  @input
  @hint("How far outward (along the lever) the motion starts, in cm")
  @widget(new SliderWidget(0, 20, 0.5))
  approachOffsetCm: number = 8

  @input
  @hint("Extra tilt toward the user at the start of the motion, in degrees")
  @widget(new SliderWidget(0, 80, 1))
  approachTiltDeg: number = 35

  @input
  @hint("Seconds the looping ghost rests in the socket between passes")
  @widget(new SliderWidget(0, 3, 0.1))
  loopHoldSec: number = 0.7
  @ui.group_end

  playCount: number = 0

  /** Retarget the ghost (socket A for step 3, socket B for step 4) before play(). */
  setSocket(socket: SceneObject): void {
    this.socket = socket
  }

  /** Repeat the motion until the ghost is hidden. */
  loop: boolean = false

  setLoop(on: boolean): void {
    this.loop = on
  }

  private playing = false
  private elapsed = 0
  private startPos = vec3.zero()
  private startRot = quat.quatIdentity()
  private endPos = vec3.zero()
  private endRot = quat.quatIdentity()

  onAwake(): void {
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  play(): void {
    if (!this.socket) {
      print("[GhostAnimator] ERROR: socket not assigned")
      return
    }
    const st = this.socket.getTransform()
    this.endPos = st.getWorldPosition()
    this.endRot = st.getWorldRotation()
    const outward = this.endRot.multiplyVec3(new vec3(1, 0, 0))
    this.startPos = this.endPos.add(outward.uniformScale(this.approachOffsetCm)).add(new vec3(0, 0, 3))
    const tilt = quat.angleAxis((-this.approachTiltDeg * Math.PI) / 180, new vec3(0, 1, 0))
    this.startRot = this.endRot.multiply(tilt)
    this.elapsed = 0
    this.playing = true
    this.playCount += 1
    this.apply(0)
  }

  isPlayingNow(): boolean {
    return this.playing
  }

  private tick(): void {
    if (!this.playing) return
    this.elapsed += getDeltaTime()
    const dur = Math.max(0.01, this.durationSec)
    const t = Math.min(1, this.elapsed / dur)
    this.apply(t)
    if (t < 1) return
    if (!this.loop) this.playing = false
    else if (this.elapsed >= dur + this.loopHoldSec) this.elapsed = 0
  }

  private apply(t: number): void {
    const e = t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2
    const tr = this.sceneObject.getTransform()
    tr.setWorldPosition(vec3.lerp(this.startPos, this.endPos, e))
    tr.setWorldRotation(quat.slerp(this.startRot, this.endRot, e))
  }
}
