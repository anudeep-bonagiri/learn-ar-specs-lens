/**
 * WorkspaceAnchor — places the workspace (wheel, stand, mat, floor path, cards,
 * lights) relative to where the user's eye is when the Lens starts.
 * The scene is authored with the start eye at the world origin facing -Z. On Specs
 * the Lens starts there, so the offset is zero and nothing moves. In the Lens
 * Studio preview the world is the simulated room and the preview camera can start
 * anywhere in it; this shifts the listed roots by the start eye's position so the
 * whole set lands in front of the user wherever the recording pose is.
 * Translation only (the heading stays -Z), so every "+Z is toward the user" rule
 * in the step code still holds.
 * For the first settleSec the preview can still report the room's spawn point before
 * the camera pose lands; if the eye then jumps by more than settleCm the roots move
 * again by the difference and onMoved listeners refresh what they cached.
 * Owns: the offset (WorkspaceAnchor.offset(), zero until OnStart). Moves `roots` once.
 * Expects: to sit on the Camera Object, the first root, so its OnStart runs before
 * every other OnStart (scripts that place things in world space wait for OnStart). Readers of world-space constants
 * (FloorPath's spots, FloorLevel's probe center, tests) add offset().
 */
let ANCHOR_OFFSET = vec3.zero()
const MOVED: Array<() => void> = []

@component
export class WorkspaceAnchor extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">WorkspaceAnchor – the workspace follows the start eye</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Workspace roots authored relative to the start eye (origin facing -Z); each is moved by the start eye's position")
  roots: SceneObject[] = []
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Follow the start eye's height too (off: only x and z move)")
  followHeight: boolean = true

  @input
  @hint("Seconds after start during which a jump of the eye re-anchors the workspace")
  @widget(new SliderWidget(0, 5, 0.1))
  settleSec: number = 1.5

  @input
  @hint("Eye jump (cm) that re-anchors during the settle window")
  @widget(new SliderWidget(1, 50, 1))
  settleCm: number = 5
  @ui.group_end

  /** Times the workspace was placed (1 = at start; more = re-anchored while settling). */
  anchorCount: number = 0

  /** The start eye's position: what every authored world position is offset by. */
  static offset(): vec3 {
    return ANCHOR_OFFSET
  }

  /** Called after the workspace moves again while settling (cached world positions are stale). */
  static onMoved(cb: () => void): void {
    MOVED.push(cb)
  }

  /** An authored world position (start eye at the origin) in the live world. */
  static place(authored: vec3): vec3 {
    return authored.add(ANCHOR_OFFSET)
  }

  onAwake(): void {
    MOVED.length = 0
    ANCHOR_OFFSET = vec3.zero()
    // Device tracking places the camera after onAwake; by OnStart it is there. This script sits
    // on the Camera Object (the first root), so its OnStart runs before every other OnStart.
    this.createEvent("OnStartEvent").bind(() => {
      this.anchorTo(this.eye())
      const t0 = getTime()
      const watch = this.createEvent("UpdateEvent")
      watch.bind(() => {
        if (getTime() - t0 > this.settleSec) {
          watch.enabled = false
          return
        }
        const e = this.eye()
        if (e.distance(ANCHOR_OFFSET) > this.settleCm) {
          this.anchorTo(e)
          for (const cb of MOVED) cb()
        }
      })
    })
  }

  private eye(): vec3 {
    const p = this.sceneObject.getTransform().getWorldPosition()
    return new vec3(p.x, this.followHeight ? p.y : 0, p.z)
  }

  /** Moves the roots so they sit relative to `eye` (by the difference from the last anchor). */
  private anchorTo(eye: vec3): void {
    const delta = eye.sub(ANCHOR_OFFSET)
    ANCHOR_OFFSET = eye
    this.anchorCount += 1
    const moved: string[] = []
    if (delta.length > 0.01) {
      for (const root of this.roots) {
        if (!root) continue
        const tr = root.getTransform()
        tr.setWorldPosition(tr.getWorldPosition().add(delta))
        moved.push(root.name)
      }
    }
    const o = ANCHOR_OFFSET
    print(
      `[WorkspaceAnchor] ${this.anchorCount > 1 ? "re-anchored to" : "start eye"} (${o.x.toFixed(1)}, ${o.y.toFixed(1)}, ${o.z.toFixed(1)})` +
        (moved.length > 0 ? `: moved ${moved.join(", ")}` : ": nothing moved")
    )
  }
}
