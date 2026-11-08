/**
 * BenchCoachStepLabelUI — the step callout (pass D2; replaces the floating step label).
 * A small kicker line ("Step 4 of 10"), then the instruction (LabelText, up to two
 * lines), on the design-system plate, turned to the user (yaw only), with a thin
 * accent leader line from the plate edge to the marker.
 * States: normal (setText), found (setFound: green kicker), mistake (showMistake: amber
 * edge and kicker), idle hint (showHint: the edge pulses in the accent). Pass P: the
 * hint no longer replaces the instruction (someone who looked away could not read what
 * the step is): the plate grows by a "Hint" kicker and the hint line under it. Only where
 * the hint already states the whole step (WHOLE_STEP_HINTS) does it replace the line.
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
 *  - Pass B, Ask takes the slot (setSlot): while Ask is open its chips or answer stand where
 *   the plate stands, same width and anchor, so there is one plate on the part. The plate
 *   hides (setSlot), the ring and the leader stay, and the box placed is the Ask panel's.
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
import {COLOR, LAYOUT_Z_LIFT, LeaderLine, Plate, addUIText, flexColumn, imageOn, lineCm, linesFor, makePlate, plateEdgePoint, plateCm, keepTogether, uiTextOn} from "./UIHelpers"

/** Pass G3 (Sujeeth), on D2's amber state: a mistake carries a warning badge, not only amber. */
const ICON_WARNING: Texture = requireAsset("../../Icons/warning.png") as Texture

/**
 * Pass P: steps whose idle hint already states the whole step, so it replaces the
 * instruction as before: 4 ("Hook the second lever on the ghost, then slide it down."),
 * 6 ("Look for a glint on the tire. Pinch it.") and 10 ("Pinch the valve and keep holding.").
 */
export const WHOLE_STEP_HINTS = [4, 6, 10]

/** Pass P: screen margin (fraction of the frame) a callout keeps inside the view. */
export const VIEW_MARGIN = 0.02

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
  /** Pass B: height of the Ask panel standing in the plate's place (0 = the plate shows). */
  private slotH = 0
  /** Pass B: the plate is hidden because Ask took its slot; tests read it. */
  plateHidden: boolean = false
  private shownHide = false
  private step = 0
  private pulse = false
  private badge: SceneObject | null = null
  private bb: Billboard | null = null
  private pitchFollow = false
  /** The mistake state shows its warning badge (pass G3 / M); tests read it. */
  warning: boolean = false
  /**
   * Pass P: step 5 from the near side. The far-side callout would be read through the
   * spokes, so while the line from the eye to it crosses the wheel disc the plate turns
   * into the near-side note (nearNote: "Step 5 of 10" and the step's nearSideLine, on the
   * near side, no leader) beside the edge arrow and the floor path; the full callout comes
   * back once the user has come round far enough to see it clear of the wheel, or stands
   * behind the wheel. Not while something hangs under it (Ask, What's this?).
   */
  throughWheel: boolean = false
  /** Pass P: while throughWheel, the plate shows the near-side note (kicker and nearSideLine, no leader) on the near side. */
  nearNote: boolean = false
  private nearLine = ""
  /** Pass S2: the drill's kicker ("" outside a drill). */
  private kickerLine = ""
  /** What the current mode puts on LabelText (the note replaces it while nearNote). */
  private labelText = ""
  /** The idle hint line the hint mode wants (shown once the full callout is back). */
  private hintWanted: string | null = null
  /** Pass P: the hint line under the instruction ("" while none shows); tests read it. */
  hintText: string = ""
  private baseHeight = 0
  private column: SceneObject | null = null
  private hintRoot: SceneObject | null = null
  private hintKicker: Text | null = null
  private hintLabel: Text | null = null
  private kickerH = 0
  private lineH = 0
  private innerW = 0

  /** Normal state: the instruction, with "Step N of 10" above it. */
  setText(msg: string): void {
    this.setMode("normal", this.stepLine(), COLOR.textSecondary, COLOR.edge)
    this.setLabel(msg)
  }

  /** Pass P: the step's near-side note line ("" for none); RepairManager pushes it with the step. */
  setNearSideLine(line: string): void {
    this.nearLine = line
    if (!line && this.nearNote) this.setThroughWheel(false, false)
  }

  private setLabel(text: string): void {
    this.labelText = text
    if (this.label) this.label.text = keepTogether(this.nearNote ? this.nearLine : text)
  }

  /**
   * Pass S2: during a Practise drill the kicker reads `line` ("Practise, rep 1 of 3")
   * instead of "Step N of 10"; "" gives the step count back. Shown on the next setText.
   */
  setKickerLine(line: string): void {
    this.kickerLine = line
    if (this.mode === "normal" && this.kicker) this.kicker.text = this.stepLine()
  }

  /** Pass S2: a drill rep is done (green kicker, "Rep 1 of 3 done in 0:06"); the instruction stays. */
  showRepDone(kicker: string): void {
    this.setMode("found", kicker, COLOR.green, COLOR.edge)
    this.setLabel(this.labelText)
  }

  /** The cause is found (green kicker). */
  setFound(msg: string): void {
    this.setMode("found", "Found it", COLOR.green, COLOR.edge)
    this.setLabel(msg)
  }

  /** A mistake: amber edge and kicker, the reason as the line (CoachFeedback restores it). */
  showMistake(reason: string): void {
    this.setMode("mistake", "Not quite", COLOR.amber, COLOR.amber)
    this.setLabel(reason)
  }

  /**
   * The idle hint: the edge pulses gently in the accent. Pass P: the instruction stays and
   * the hint goes under it with its "Hint" kicker; on a WHOLE_STEP_HINTS step the hint
   * replaces the line ("Hint" kicker), as before.
   */
  showHint(text: string): void {
    if (WHOLE_STEP_HINTS.indexOf(this.step) >= 0) {
      this.setMode("hint", "Hint", COLOR.accent, COLOR.accent)
      this.setLabel(text)
      return
    }
    this.setMode("hint", this.stepLine(), COLOR.textSecondary, COLOR.accent)
    this.hintWanted = text
    if (!this.nearNote) this.setHintLine(text)
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

  /**
   * Pass B: while Ask is open, its panel (chips or answer, heightCm tall) stands in the
   * plate's place: the plate and its text hide, the leader stays. 0 gives the plate back.
   */
  setSlot(heightCm: number): void {
    this.slotH = Math.max(0, heightCm)
    this.plateHidden = this.slotH > 0
    this.applyPlateVisible()
    this.place()
  }

  /** World point at the top center of the stack slot under the plate (gap and plate at the current scale). */
  stackTop(gapCm: number): vec3 {
    const c = this.sceneObject.getTransform().getWorldPosition()
    return c.add(new vec3(0, -(this.panelHeight / 2 + gapCm) * this.scale, 0))
  }

  /**
   * Pass P: the world z of the callout's plane (the wheel plane plus its stand-off toward
   * the user), or null; the info card keeps at least this far out so the axle end and the
   * hub never poke through it.
   */
  frontZ(): number | null {
    const a = this.anchor
    return a && a.side > 0 ? a.hub.z + a.standOff : null
  }

  /** Pass P: the marker ring's centre while the leader points at it (null when there is none). */
  markerAt(): vec3 | null {
    return this.leaderTo && this.anchor && this.anchor.target ? this.anchor.target : null
  }

  /** Plate size in cm at the current scale. */
  scaledWidth(): number {
    return this.panelWidth * this.scale
  }

  /** Height of the box the callout occupies: the plate, or the Ask panel standing in for it. */
  scaledHeight(): number {
    return (this.slotH > 0 ? this.slotH : this.panelHeight) * this.scale
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
    // Pass P: the hint block under the instruction, placed by hand (setHintLine), off until a hint shows.
    this.baseHeight = probe.h
    this.column = col
    this.kickerH = kickerH
    this.lineH = lineH
    this.innerW = innerW
    this.hintRoot = global.scene.createSceneObject("StepHint")
    this.hintRoot.setParent(this.plate.content)
    this.hintRoot.getTransform().setLocalPosition(new vec3(0, 0, 2 * LAYOUT_Z_LIFT))
    const hk = global.scene.createSceneObject("HintKicker")
    hk.setParent(this.hintRoot)
    this.hintKicker = uiTextOn(hk, "Hint", "secondary", innerW, kickerH, d, {color: COLOR.accent})
    const hl = global.scene.createSceneObject("HintText")
    hl.setParent(this.hintRoot)
    this.hintLabel = uiTextOn(hl, "", "body", innerW, 2 * lineH, d, {wrap: true})
    this.hintRoot.enabled = false
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
    if (this.kickerLine) return this.kickerLine
    return this.step > 0 ? `Step ${this.step} of ${this.totalSteps}` : ""
  }

  /**
   * Pass P: shows `text` under the instruction (null hides it). The plate grows downward
   * by the hint's kicker and its one or two lines; the instruction block keeps its place
   * at the plate's top, and the placement reads the new panelHeight.
   */
  private setHintLine(text: string | null): void {
    if (!this.plate || !this.hintRoot || !this.column || !this.hintLabel || !this.hintKicker) return
    const g = this.plate.g
    let H = this.baseHeight
    if (text) {
      const lines = Math.min(2, linesFor(text, "body", this.innerW, this.viewDistanceCm))
      const hH = lines * this.lineH
      const gap2 = g.gap * 0.3
      H = this.baseHeight + this.kickerH + gap2 + hH + g.pad
      const top = H / 2 - this.baseHeight
      this.hintKicker.getSceneObject().getTransform().setLocalPosition(new vec3(0, top - this.kickerH / 2, 0))
      this.hintLabel.getSceneObject().getTransform().setLocalPosition(new vec3(0, top - this.kickerH - gap2 - hH / 2, 0))
      this.hintLabel.layoutRect = Rect.create(-this.innerW / 2, this.innerW / 2, -hH / 2, hH / 2)
      this.hintLabel.text = keepTogether(text)
      this.hintText = text
    } else {
      this.hintText = ""
    }
    if (this.hintRoot.enabled !== !!text) this.hintRoot.enabled = !!text
    this.panelHeight = H
    this.plate.setHeight(H)
    const ct = this.column.getTransform()
    const cp = ct.getLocalPosition()
    ct.setLocalPosition(new vec3(cp.x, (H - this.baseHeight) / 2, cp.z))
  }

  private setMode(mode: string, kicker: string, kickerColor: vec4, edge: vec4): void {
    if (mode !== "hint" || this.hintText) this.setHintLine(null)
    this.hintWanted = null
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
    const w = this.panelWidth * this.scale
    const h = this.scaledHeight()
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
    // Pass B: the Ask panel standing in the plate's place is placed the same way, with nothing under it.
    const boxed = this.stackH > 0 || this.slotH > 0
    const stackIn = boxed ? this.insideSpot(a, dx, dy, w, h + this.stackH * this.scale) : null
    if (stackIn) {
      cx = stackIn.x
      cy = stackIn.y + (this.stackH * this.scale) / 2
    } else if (boxed) {
      const stack = this.stackH > 0 ? this.stackH * this.scale + gap : 0
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
    let pos = a.hub.add(new vec3(cx, cy, a.side * a.standOff))
    const through = a.side < 0 && !boxed && this.seenThroughWheel(pos, a, w)
    // Pass P: the near-side note in the normal and hint states (a mistake or "found" keeps its text).
    const note = through && !!this.nearLine && (this.mode === "normal" || this.mode === "hint")
    this.setThroughWheel(through, note)
    if (note) pos = this.nearSpot(a, w, h)
    this.followPitch(a.side < 0 && !note)
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
    this.drawLeader(pos, this.nearNote ? null : a.target)
  }

  /**
   * Pass P: where the near-side note goes: on the near side of the wheel, at the first spot
   * straight above (then below) the hub with every corner inside the clear circle and in
   * the view. No marker on this side, so no leader and no ring to keep clear.
   */
  private nearSpot(a: CalloutAnchor, w: number, h: number): vec3 {
    const inner = a.radius - 6.5
    const z = a.standOff
    let fallback: vec3 | null = null
    for (let k = 0; k <= inner; k += 0.5) {
      for (const sy of [1, -1]) {
        const fy = k + h / 2
        if ((w / 2) * (w / 2) + fy * fy > inner * inner) continue
        const at = a.hub.add(new vec3(0, sy * k, z))
        if (!fallback) fallback = at
        if (this.inView(at, a.hub, w, h)) return at
      }
    }
    return fallback ?? a.hub.add(new vec3(0, 0, z))
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
    // Pass P: a spot that clears the ring but leaves the view (step 2 on beads 3 and 4 at
    // the wheel pose ran off the frame's bottom edge) is kept only as a fallback; the search
    // goes on toward the hub for one that is fully in view.
    let clearOfRing: vec2 | null = null
    for (let i = 0; i < 120; i++) {
      cx = dx + ux * t
      cy = dy + uy * t
      const fx = Math.abs(cx) + w / 2
      const fy = Math.abs(cy) + h / 2
      if (!fits) fits = fx * fx + fy * fy <= inner * inner
      if (t > len) break
      const at = a.hub.add(new vec3(cx, cy, a.side * a.standOff))
      if (fits && !(a.target && this.coversOnScreen(at, a.target, w, h))) {
        if (this.inView(at, a.hub, w, h)) return new vec2(cx, cy)
        if (!clearOfRing) clearOfRing = new vec2(cx, cy)
      }
      t += 0.5
    }
    // Second pass (pass P): none of those is in view (from Sunlit Room's default pose the
    // hub sits at the frame's bottom edge), so try straight above and below the hub, inside
    // the clear circle and clear of the ring.
    if (clearOfRing) {
      for (let k = 0; k <= inner; k += 0.5) {
        for (const sy of [1, -1]) {
          const fy = k + h / 2
          if ((w / 2) * (w / 2) + fy * fy > inner * inner) continue
          const at = a.hub.add(new vec3(0, sy * k, a.side * a.standOff))
          if (a.target && this.coversOnScreen(at, a.target, w, h)) continue
          if (this.inView(at, a.hub, w, h)) return new vec2(0, sy * k)
        }
      }
      return clearOfRing
    }
    return always ? new vec2(cx, cy) : null
  }

  /**
   * Pass P: from the live eye, every corner of a w x h plate centered at `c` is inside the
   * view with VIEW_MARGIN to spare. Only while the hub is in view, i.e. the user looks at
   * the wheel (when they look elsewhere the callout does not chase the frame edge). The
   * marker itself may be out of view (step 2's beads 3 and 4 at the wheel pose).
   */
  private inView(c: vec3, hub: vec3, w: number, h: number): boolean {
    const cam = WorldCameraFinderProvider.getInstance()
    if (!cam) return true
    const camera = cam.getComponent()
    const m = VIEW_MARGIN
    const hp = camera.worldSpaceToScreenSpace(hub)
    if (!camera.isSphereVisible(hub, 0.1) || hp.x < 0 || hp.x > 1 || hp.y < 0 || hp.y > 1) return true
    const right = this.rightVector(c)
    for (const sx of [-1, 1]) {
      for (const sy of [-1, 1]) {
        const p = camera.worldSpaceToScreenSpace(c.add(right.uniformScale((sx * w) / 2)).add(new vec3(0, (sy * h) / 2, 0)))
        if (p.x < m || p.x > 1 - m || p.y < m || p.y > 1 - m) return false
      }
    }
    return true
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

  /**
   * From the live eye, the plate centered at `c` (w wide) is seen through the wheel: the
   * eye is in front of the wheel plane and the sight line meets that plane inside the
   * tire's outer edge plus half the plate (2 cm of hysteresis once hidden).
   */
  private seenThroughWheel(c: vec3, a: CalloutAnchor, w: number): boolean {
    const cam = WorldCameraFinderProvider.getInstance()
    if (!cam) return false
    const eye = cam.getWorldPosition()
    if (eye.z <= a.hub.z || eye.z <= c.z) return false
    const t = (eye.z - a.hub.z) / (eye.z - c.z)
    const hit = eye.add(c.sub(eye).uniformScale(t))
    const d = Math.sqrt((hit.x - a.hub.x) * (hit.x - a.hub.x) + (hit.y - a.hub.y) * (hit.y - a.hub.y))
    return d < a.radius + 3.2 + w / 2 + (this.throughWheel ? 2 : 0)
  }

  /**
   * `on`: the far-side callout would be read through the wheel. With `note` the same plate
   * shows the near-side note (one plate, so never both; the text swaps in one frame on a
   * column that is already laid out); without it the plate hides, as before.
   */
  private setThroughWheel(on: boolean, note: boolean): void {
    if (!this.plate) return
    note = on && note
    if (on === this.throughWheel && note === this.nearNote) return
    this.throughWheel = on
    const wasNote = this.nearNote
    this.nearNote = note
    this.applyPlateVisible()
    if (note !== wasNote) {
      if (this.label) this.label.text = keepTogether(note ? this.nearLine : this.labelText)
      // The idle hint's line waits for the full callout.
      if (note && this.hintText) this.setHintLine(null)
      else if (!note && this.mode === "hint" && this.hintWanted) this.setHintLine(this.hintWanted)
    }
  }

  /** The plate shows unless the far-side callout would be read through the wheel or Ask has its slot. */
  private applyPlateVisible(): void {
    if (!this.plate) return
    const hide = (this.throughWheel && !this.nearNote) || this.plateHidden
    if (hide === this.shownHide) return
    this.shownHide = hide
    this.plate.content.enabled = !hide
    for (const r of this.sceneObject.getComponents("Component.RenderMeshVisual") as RenderMeshVisual[]) r.enabled = !hide
  }

  private drawLeader(c: vec3, target: vec3 | null): void {
    if (!this.leader) return
    if (!target || !this.sceneObject.isEnabledInHierarchy || (this.throughWheel && !this.nearNote)) {
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
