/**
 * BenchCoachStepLabelUI — the step callout (pass D2; replaces the floating step label).
 * A small kicker line ("Step 4 of 10"), then the instruction (LabelText, up to two
 * lines), on the design-system plate, turned to the user (yaw only), with a thin
 * accent leader line from the plate edge to the marker.
 * States: normal (setText), found (setFound: green kicker), mistake (showMistake: amber
 * edge and kicker), idle hint (showHint: "Hint" kicker, the edge pulses in the accent).
 * Placement (setAnchor, re-applied every frame):
 *  - inside (the default): inside the rim, moved from the marker toward the hub until
 *    its near edge clears the ring by markerGapCm, then pulled in until every corner
 *    is inside the clear circle. It never covers the tire, a bead, the valve or a lever
 *    handle (handles stand up out of the tire), and stays near eye level.
 *  - With something attached underneath (setStack: Ask chips or answer, the What's this?
 *    prompt) callout and stack go inside the rim together when they fit as one box (same
 *    search, every corner in the clear circle; pass M, Sujeeth's G5: above the tire the
 *    stack's top sat 24 to 27 degrees above the eye, past Specs' top edge). Otherwise
 *    the callout goes above the tire (marker in the upper half; shifted to the side away
 *    from the marker, clear of any lever handle) or below it (lower half), with the
 *    stack between it and the tire / under it.
 * It keeps its apparent size: closer than viewDistanceCm it scales down (to minScale),
 * so from step 5's far side (about 35 cm away) it still fits in the view.
 * The plate stands off the wheel toward the user (or the far side on step 5). From the
 * live eye it never covers the ring: if the ring's screen point falls inside the
 * plate's screen rectangle, the plate keeps moving toward the hub (parallax: from step
 * 5's far side the user looks steeply down past the plate at the tube end).
 * Owns: only its view and its placement. RepairManager pushes the anchor and the text.
 */
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import WorldCameraFinderProvider from "SpectaclesInteractionKit.lspkg/Providers/CameraProvider/WorldCameraFinderProvider"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {COLOR, LeaderLine, Plate, addUIText, flexColumn, imageOn, lineCm, makePlate, plateEdgePoint, plateCm, keepTogether} from "./UIHelpers"

/** Pass G3 (Sujeeth), on D2's amber state: a mistake carries a warning badge, not only amber. */
const ICON_WARNING: Texture = requireAsset("../../Icons/warning.png") as Texture

/** Where the callout hangs: the marker (or null), the wheel and which side the user works from. */
export interface CalloutAnchor {
  target: vec3 | null
  hub: vec3
  /** Tire bead radius (cm); the tire's outer edge and the clear space inside the rim follow from it. */
  radius: number
  /** +1: in front of the wheel (toward the start eye); -1: behind it (step 5's far side). */
  side: number
  /** How far the plate stands off the wheel plane, in cm. */
  standOff: number
}

export type CalloutZone = "top" | "bottom" | "inside" | "none"

@component
export class BenchCoachStepLabelUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachStepLabelUI – the step callout</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Plate width in cm (sized for the longest instruction on two lines)")
  @widget(new SliderWidget(12, 30, 0.5))
  panelWidth: number = 21

  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 90

  @input
  @hint("Steps in the repair (the kicker reads 'Step N of this')")
  totalSteps: number = 10

  @input
  @hint("Gap between the tire's outer edge and the plate, in cm")
  @widget(new SliderWidget(0.5, 8, 0.5))
  tireGapCm: number = 2.5

  @input
  @hint("Clear gap between the plate's near edge and the marker ring's center, in cm")
  @widget(new SliderWidget(2, 10, 0.5))
  markerGapCm: number = 4.5

  @input
  @hint("Furthest the plate center moves sideways from the hub in the top / bottom zones (keeps it in view)")
  @widget(new SliderWidget(0, 25, 0.5))
  maxSideCm: number = 12

  @input
  @hint("Smallest scale when the eye is close (the callout keeps its apparent size up to here)")
  @widget(new SliderWidget(0.2, 1, 0.05))
  minScale: number = 0.45

  @input
  @hint("Leader line thickness in cm")
  @widget(new SliderWidget(0.05, 0.5, 0.01))
  leaderCm: number = 0.14

  @input
  @hint("Turn to face the user (SIK Billboard, yaw only)")
  billboard: boolean = true
  @ui.group_end

  /** Plate height in cm (set in onAwake). */
  panelHeight: number = 0
  /** The zone the callout sits in now. */
  zone: CalloutZone = "none"
  /** "normal", "found", "mistake" or "hint". */
  mode: string = "normal"
  /** Current scale (1 at viewDistanceCm or further; smaller when the eye is close). */
  scale: number = 1
  /** Leader line end points (world), for tests; null while hidden. */
  leaderFrom: vec3 | null = null
  leaderTo: vec3 | null = null

  private plate: Plate | null = null
  private kicker: Text | null = null
  private label: Text | null = null
  private leader: LeaderLine | null = null
  private anchor: CalloutAnchor | null = null
  private stackH = 0
  private step = 0
  private pulse = false
  private badge: SceneObject | null = null
  private bb: Billboard | null = null
  private pitchFollow = false
  /** The mistake state shows its warning badge (pass G3 / M); tests read it. */
  warning: boolean = false

  /** Normal state: the instruction, with "Step N of 10" above it. */
  setText(msg: string): void {
    this.setMode("normal", this.stepLine(), COLOR.textSecondary, COLOR.edge)
    if (this.label) this.label.text = keepTogether(msg)
  }

  /** The cause is found (green kicker). */
  setFound(msg: string): void {
    this.setMode("found", "Found it", COLOR.green, COLOR.edge)
    if (this.label) this.label.text = keepTogether(msg)
  }

  /** A mistake: amber edge and kicker, the reason as the line (CoachFeedback restores it). */
  showMistake(reason: string): void {
    this.setMode("mistake", "Not quite", COLOR.amber, COLOR.amber)
    if (this.label) this.label.text = keepTogether(reason)
  }

  /** The idle hint: "Hint" kicker, the edge pulses gently in the accent. */
  showHint(text: string): void {
    this.setMode("hint", "Hint", COLOR.accent, COLOR.accent)
    if (this.label) this.label.text = keepTogether(text)
  }

  /** The step the kicker counts ("Step N of 10"); shown on the next setText. */
  setStepNumber(step: number): void {
    this.step = step
    if (this.mode === "normal" && this.kicker) this.kicker.text = this.stepLine()
  }

  /** Where to hang (re-applied every frame, so moving parts are followed). */
  setAnchor(anchor: CalloutAnchor): void {
    this.anchor = anchor
    this.place()
  }

  /** Height of what hangs under the callout (Ask chips / answer, What's this? prompt); 0 = nothing. */
  setStack(heightCm: number): void {
    this.stackH = Math.max(0, heightCm)
    this.place()
  }

  /** World point at the top center of the stack slot under the plate (gap and plate at the current scale). */
  stackTop(gapCm: number): vec3 {
    const c = this.sceneObject.getTransform().getWorldPosition()
    return c.add(new vec3(0, -(this.panelHeight / 2 + gapCm) * this.scale, 0))
  }

  /** Plate size in cm at the current scale. */
  scaledWidth(): number {
    return this.panelWidth * this.scale
  }

  scaledHeight(): number {
    return this.panelHeight * this.scale
  }

  onAwake(): void {
    if (this.billboard) this.bb = this.sceneObject.createComponent(Billboard.getTypeName()) as Billboard
    const d = this.viewDistanceCm
    // Pass V: the plate grows with the type scale (UIHelpers.plateCm).
    this.panelWidth = plateCm(this.panelWidth, d)
    const w = this.panelWidth
    const kickerH = lineCm("secondary", d)
    const lineH = lineCm("instruction", d)
    const probe = makePlateHeight(d, kickerH, 2 * lineH)
    this.panelHeight = probe.h
    this.plate = makePlate(this.sceneObject, w, probe.h, d)
    const g = this.plate.g
    const innerW = w - 2 * g.pad
    const col = flexColumn(this.plate.content, w, probe.h, {
      gap: g.gap * 0.6,
      padX: g.pad,
      padY: g.pad,
      justify: FlexJustify.Center,
      align: FlexAlign.Start,
    })
    this.kicker = addUIText(col, "StepKicker", this.stepLine(), "secondary", innerW, kickerH, d)
    this.label = addUIText(col, "LabelText", "", "instruction", innerW, 2 * lineH, d, {wrap: true})
    this.leader = new LeaderLine(this.sceneObject, "StepLeader", this.leaderCm, null)
    // Warning badge (pass G3 on D2): sits on the plate's left edge, centred on the kicker
    // line, like a tab on the amber edge. Half of it is inside the padding, so it never
    // touches the text; it shows only in the mistake state.
    const badgeCm = Math.min(g.pad * 1.8, kickerH * 1.5)
    this.badge = global.scene.createSceneObject("WarnBadge")
    this.badge.setParent(this.plate.content)
    this.badge.getTransform().setLocalPosition(new vec3(-w / 2, probe.h / 2 - g.pad - kickerH / 2, 0.3))
    const badgeImg = imageOn(this.badge, ICON_WARNING, badgeCm)
    badgeImg.mainMaterial.mainPass.baseColor = COLOR.amber
    this.badge.enabled = false
    this.createEvent("LateUpdateEvent").bind(() => this.tick())
  }

  /**
   * Pass V: on the far side (step 5) the eye looks steeply down at the callout, so a
   * yaw-only plate was seen edge-on and its type shrank to about 60% of its height in the
   * video frame. There the billboard also follows pitch; in front it is upright again.
   */
  private followPitch(on: boolean): void {
    if (!this.bb || on === this.pitchFollow) return
    this.pitchFollow = on
    this.bb.xAxisEnabled = on
    if (!on) this.sceneObject.getTransform().setWorldRotation(quat.quatIdentity())
  }

  private stepLine(): string {
    return this.step > 0 ? `Step ${this.step} of ${this.totalSteps}` : ""
  }

  private setMode(mode: string, kicker: string, kickerColor: vec4, edge: vec4): void {
    this.mode = mode
    this.pulse = mode === "hint"
    this.warning = mode === "mistake"
    if (this.badge) this.badge.enabled = this.warning
    if (this.kicker) {
      this.kicker.text = kicker
      this.kicker.textFill.color = kickerColor
    }
    if (this.plate) this.plate.setEdge(edge)
  }

  private tick(): void {
    this.place()
    if (this.pulse && this.plate) {
      const a = 0.55 + 0.45 * Math.sin(getTime() * 2 * Math.PI * 0.9)
      const c = COLOR.accent
      this.plate.setEdge(new vec4(c.x, c.y, c.z, 0.35 + 0.65 * a))
    }
  }

  /** Puts the plate in its zone and draws the leader to the marker. */
  private place(): void {
    const a = this.anchor
    if (!a) return
    this.followPitch(a.side < 0)
    const w = this.panelWidth * this.scale
    const h = this.panelHeight * this.scale
    const tireOuter = a.radius + 3.2
    const gap = this.tireGapCm
    let dx = 0
    let dy = a.radius
    if (a.target) {
      dx = a.target.x - a.hub.x
      dy = a.target.y - a.hub.y
    }
    let cx = 0
    let cy = 0
    let zone: CalloutZone = "inside"
    // Pass M (Sujeeth's G5 on D2): with a stack hung under the callout, callout and stack go
    // inside the rim together when they fit, as one box, clear of the ring. Above the tire
    // the stack's top sat 24 to 27 degrees above the eye, past Specs' top edge (about 18.5);
    // inside the rim it is near eye level and covers only spokes and hub, never worked.
    const stackIn = this.stackH > 0 ? this.insideSpot(a, dx, dy, w, h + this.stackH * this.scale) : null
    if (stackIn) {
      cx = stackIn.x
      cy = stackIn.y + (this.stackH * this.scale) / 2
    } else if (this.stackH > 0) {
      const stack = this.stackH * this.scale + gap
      if (dy >= -a.radius * 0.5) {
        zone = "top"
        // Away from the marker's side, so lever handles above the tire stay clear.
        const away = Math.abs(dx) < 2 ? 0 : -Math.sign(dx) * (w / 2 - 2)
        cx = clamp(away, -this.maxSideCm, this.maxSideCm)
        cy = tireOuter + gap + stack + h / 2
      } else {
        zone = "bottom"
        cx = clamp(dx, -this.maxSideCm, this.maxSideCm)
        cy = -(tireOuter + gap + h / 2)
      }
    } else {
      const spot = this.insideSpot(a, dx, dy, w, h, true)
      cx = spot ? spot.x : 0
      cy = spot ? spot.y : 0
    }
    this.zone = zone
    const pos = a.hub.add(new vec3(cx, cy, a.side * a.standOff))
    const tr = this.sceneObject.getTransform()
    tr.setWorldPosition(pos)
    // Keep the apparent size: scale for the next frame from this frame's distance.
    const cam = WorldCameraFinderProvider.getInstance()
    if (cam) {
      const k = clamp(pos.distance(cam.getWorldPosition()) / this.viewDistanceCm, this.minScale, 1)
      if (Math.abs(k - this.scale) > 0.01) {
        this.scale = k
        tr.setLocalScale(new vec3(k, k, k))
      }
    }
    this.drawLeader(pos, a.target)
  }

  /**
   * From the marker toward the hub: the first center for a w x h box (callout, or callout
   * and stack) that clears the ring, has every corner inside the clear circle (bead radius
   * - 6.5 cm) and, from the live eye, does not hide the ring. Null if no spot fits, unless
   * `always` (the lone callout takes the last spot tried, as before).
   */
  private insideSpot(a: CalloutAnchor, dx: number, dy: number, w: number, h: number, always: boolean = false): vec2 | null {
    const inner = a.radius - 6.5
    let ux = -dx
    let uy = -dy
    const len = Math.sqrt(ux * ux + uy * uy)
    if (len < 1e-3) {
      ux = 0
      uy = -1
    } else {
      ux /= len
      uy /= len
    }
    const extent = Math.abs(ux) * (w / 2) + Math.abs(uy) * (h / 2)
    let t = this.markerGapCm + extent
    let fits = false
    let cx = 0
    let cy = 0
    for (let i = 0; i < 120; i++) {
      cx = dx + ux * t
      cy = dy + uy * t
      const fx = Math.abs(cx) + w / 2
      const fy = Math.abs(cy) + h / 2
      if (!fits) fits = fx * fx + fy * fy <= inner * inner
      if (t > len) break
      if (fits && !(a.target && this.coversOnScreen(a.hub.add(new vec3(cx, cy, a.side * a.standOff)), a.target, w, h))) {
        return new vec2(cx, cy)
      }
      t += 0.5
    }
    return always ? new vec2(cx, cy) : null
  }

  /** From the live eye, the plate centered at `c` hides the ring at `target` (with a margin of the ring's size). */
  private coversOnScreen(c: vec3, target: vec3, boxW: number = this.scaledWidth(), boxH: number = this.scaledHeight()): boolean {
    const cam = WorldCameraFinderProvider.getInstance()
    if (!cam) return false
    const camera = cam.getComponent()
    const eye = cam.getWorldPosition()
    // Only when the plate is between the eye and the ring.
    if (c.distance(eye) > target.distance(eye)) return false
    const right = this.rightVector(c)
    const up = vec3.up()
    let x0 = 2
    let x1 = -1
    let y0 = 2
    let y1 = -1
    for (const sx of [-1, 1]) {
      for (const sy of [-1, 1]) {
        const p = camera.worldSpaceToScreenSpace(c.add(right.uniformScale((sx * boxW) / 2)).add(up.uniformScale((sy * boxH) / 2)))
        x0 = Math.min(x0, p.x)
        x1 = Math.max(x1, p.x)
        y0 = Math.min(y0, p.y)
        y1 = Math.max(y1, p.y)
      }
    }
    const m = camera.worldSpaceToScreenSpace(target)
    const r = m.distance(camera.worldSpaceToScreenSpace(target.add(right.uniformScale(2.8))))
    return m.x > x0 - r && m.x < x1 + r && m.y > y0 - r && m.y < y1 + r
  }

  private drawLeader(c: vec3, target: vec3 | null): void {
    if (!this.leader) return
    if (!target || !this.sceneObject.isEnabledInHierarchy) {
      this.leader.setEnabled(false)
      this.leaderFrom = null
      this.leaderTo = null
      return
    }
    const right = this.rightVector(c)
    // With a stack hung underneath, the line leaves the outline of callout and stack together.
    const stack = this.stackH > 0 ? this.stackH * this.scale + this.tireGapCm * 0.2 : 0
    const box = c.add(new vec3(0, -stack / 2, 0))
    const from = plateEdgePoint(box, right, this.scaledWidth(), this.scaledHeight() + stack, target)
    // Stop short of the ring (outer radius about 2.2 cm with its pulse).
    const d = target.sub(from)
    const len = d.length
    const to = len > 2.6 ? from.add(d.uniformScale((len - 2.6) / len)) : from
    this.leader.set(from, to)
    this.leaderFrom = from
    this.leaderTo = to
  }

  /** The plate's right vector: the billboard faces the camera on the yaw axis. */
  private rightVector(c: vec3): vec3 {
    const cam = WorldCameraFinderProvider.getInstance()
    const eye = cam ? cam.getWorldPosition() : c.add(new vec3(0, 0, 100))
    const toEye = new vec3(eye.x - c.x, 0, eye.z - c.z)
    if (toEye.length < 1e-3) return vec3.right()
    const n = toEye.normalize()
    return new vec3(n.z, 0, -n.x)
  }
}

function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v))
}

/** The callout's plate height from the grid at distance d: padding, kicker, gap, text. */
function makePlateHeight(d: number, kickerH: number, textH: number): {h: number} {
  const k = d / 90
  return {h: 2 * 1.1 * k + kickerH + 0.5 * k * 0.6 + textH}
}
