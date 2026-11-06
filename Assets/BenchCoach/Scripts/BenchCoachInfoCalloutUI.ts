/**
 * BenchCoachInfoCalloutUI — the What's this? info callout (pass D2). A small card with
 * the part's name and one line, on the design-system plate, turned to the user, with a
 * light grey leader line to the part. It never rewrites the step callout.
 * showPart(title, line, part, keepClear): placed beside the part, a little nearer the
 * user. Pass P: the spot is searched in 12 directions round the part (the one toward the
 * middle of the view first) and at growing distances; it must stay inside the view and,
 * on screen, keep off the part's own pinch box, the step marker ring, the step callout
 * and (if any spot allows it) the neighbouring parts in keepClear, such as a hooked
 * lever. A spot that still passes is kept, so the card does not hop between frames.
 * showPrompt(title, line, at): no leader; PartInfo puts it in the slot under the step
 * callout. hide().
 * Owns: only its view and its placement.
 */
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import WorldCameraFinderProvider from "SpectaclesInteractionKit.lspkg/Providers/CameraProvider/WorldCameraFinderProvider"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {COLOR, LeaderLine, addUIText, flexColumn, lineCm, makePlate, plateEdgePoint, plateCm} from "./UIHelpers"
import {BenchCoachStepLabelUI} from "./BenchCoachStepLabelUI"

@component
export class BenchCoachInfoCalloutUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachInfoCalloutUI – What\'s this? info callout</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @allowUndefined
  @hint("The step callout: the info callout never overlaps it")
  stepCallout: BenchCoachStepLabelUI

  @input
  @hint("Plate width in cm")
  @widget(new SliderWidget(10, 30, 0.5))
  panelWidth: number = 18

  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 85

  @input
  @hint("Gap between the part and the plate's near edge, in cm")
  @widget(new SliderWidget(1, 12, 0.5))
  partGapCm: number = 4

  @input
  @hint("How far the plate comes toward the user from the part, in cm")
  @widget(new SliderWidget(0, 20, 0.5))
  towardUserCm: number = 6

  @input
  @hint("Fraction of the view the whole plate must stay inside")
  @widget(new SliderWidget(0.5, 1, 0.01))
  safeFraction: number = 0.9
  @ui.group_end

  /** Plate height in cm (set in onAwake). */
  panelHeight: number = 0
  /** Title and line on the card now. */
  titleText: string = ""
  lineText: string = ""

  private title: Text | null = null
  private line: Text | null = null
  private leader: LeaderLine | null = null
  private part: SceneObject | null = null
  private at: vec3 | null = null
  private keepClear: SceneObject[] = []
  /** The spot in use, as an offset from the part (null: search again), and how many soft rects it covers. */
  private pick: vec3 | null = null
  private pickSoft = 0
  /** Pass P, for tests: the card keeps off its part and the step callout / off the marker ring. */
  clearOfPart: boolean = true
  clearOfRing: boolean = true
  private hiddenOnce = false
  private wantVisible = false

  /** The prompt (no part yet), centered at `at`. */
  showPrompt(title: string, line: string, at: vec3): void {
    this.set(title, line)
    this.part = null
    this.at = at
    this.show()
  }

  /** A part's name and fact, beside the part. */
  showPart(title: string, line: string, part: SceneObject, keepClear: SceneObject[] = []): void {
    this.set(title, line)
    this.part = part
    this.keepClear = keepClear
    this.pick = null
    this.at = null
    this.show()
  }

  /** Moves the prompt (the step callout's slot moves with it). */
  moveTo(at: vec3): void {
    if (!this.part) this.at = at
  }

  hide(): void {
    this.wantVisible = false
    this.part = null
    this.at = null
    if (this.hiddenOnce) this.sceneObject.enabled = false
  }

  onAwake(): void {
    this.sceneObject.createComponent(Billboard.getTypeName())
    const d = this.viewDistanceCm
    // Pass V: the plate grows with the type scale (UIHelpers.plateCm).
    this.panelWidth = plateCm(this.panelWidth, d)
    const titleH = lineCm("instruction", d)
    const lineH = lineCm("body", d) * 2
    const k = d / 90
    const h = 2 * 1.1 * k + titleH + 0.3 * k + lineH
    this.panelHeight = h
    const plate = makePlate(this.sceneObject, this.panelWidth, h, d)
    const innerW = this.panelWidth - 2 * plate.g.pad
    const col = flexColumn(plate.content, this.panelWidth, h, {
      gap: 0.3 * k,
      padX: plate.g.pad,
      padY: plate.g.pad,
      justify: FlexJustify.Center,
      align: FlexAlign.Start,
    })
    this.title = addUIText(col, "InfoTitle", "", "instruction", innerW, titleH, d)
    this.line = addUIText(col, "InfoLine", "", "body", innerW, lineH, d, {wrap: true})
    this.leader = new LeaderLine(this.sceneObject, "InfoLeader", 0.1, COLOR.edge)
    this.createEvent("LateUpdateEvent").bind(() => this.tick())
  }

  private set(title: string, line: string): void {
    this.titleText = title
    this.lineText = line
    if (this.title) this.title.text = title
    if (this.line) this.line.text = line
  }

  private show(): void {
    this.wantVisible = true
    this.sceneObject.enabled = true
    this.tick()
  }

  private tick(): void {
    if (!this.hiddenOnce) {
      // First frame: the plate has initialized while enabled; now start hidden unless asked.
      this.hiddenOnce = true
      this.sceneObject.enabled = this.wantVisible
      if (!this.wantVisible) return
    }
    if (!this.leader) return
    const tr = this.sceneObject.getTransform()
    if (!this.part) {
      if (this.at) tr.setWorldPosition(this.at)
      this.leader.setEnabled(false)
      return
    }
    const p = this.part.getTransform().getWorldPosition()
    const c = this.placeBeside(p)
    tr.setWorldPosition(c)
    const cam = WorldCameraFinderProvider.getInstance()
    const eye = cam ? cam.getWorldPosition() : c.add(new vec3(0, 0, 100))
    const flat = new vec3(eye.x - c.x, 0, eye.z - c.z).normalize()
    const right = new vec3(flat.z, 0, -flat.x)
    const from = plateEdgePoint(c, right, this.panelWidth, this.panelHeight, p)
    this.leader.set(from, p)
  }

  /**
   * Beside the part, nearer the user (pass P). Before, the candidates were toward the
   * view centre, up, down and the diagonals, and intoView() slid each one back toward
   * the centre: with the valve at the top of the frame "up" came back down onto the
   * valve and lever A, and nothing checked the part itself. Now every spot is checked
   * against the part's pinch box, the marker ring, the step callout and the neighbours.
   */
  private placeBeside(p: vec3): vec3 {
    const cam = WorldCameraFinderProvider.getInstance()
    if (!cam) return p.add(new vec3(0, this.panelHeight, 4))
    const camera = cam.getComponent()
    const eye = cam.getWorldPosition()
    // The camera looks down its local -Z (Transform.forward is +Z).
    const fwd = cam.getTransform().getWorldRotation().multiplyVec3(new vec3(0, 0, -1))
    const depth = Math.max(20, p.sub(eye).dot(fwd))
    const centerAtDepth = eye.add(fwd.uniformScale(depth))
    let inward = centerAtDepth.sub(p)
    inward = inward.sub(fwd.uniformScale(inward.dot(fwd)))
    inward = inward.length < 1 ? vec3.up() : inward.normalize()
    const up = vec3.up()
    const right = this.flatRight(eye, p)
    const toEye = eye.sub(p).normalize()
    const must: number[][] = []
    const step = this.stepRect(camera)
    if (step) must.push(step)
    if (this.part) must.push(this.boxRect(camera, this.part))
    // Kept clear when any spot allows it: the marker ring first, then the neighbours (on
    // step 1 the Hub has no spot clear of all: valve ring at the top, the callout in the
    // middle, the hub low in the frame).
    const soft: number[][] = []
    const ring = this.stepCallout ? this.stepCallout.markerAt() : null
    const ringRect = ring ? this.rectOf(camera, ring, eye, 5.6, 5.6) : null
    if (ringRect) soft.push(ringRect)
    for (const so of this.keepClear) if (so && so.isEnabledInHierarchy) soft.push(this.boxRect(camera, so))
    // A spot outside the view counts as one more thing it must avoid (intoView only estimates).
    const clear = (c: vec3, rects: number[][]): number => {
      const r = this.rectOf(camera, c, eye)
      let n = 0
      for (const a of rects) if (this.overlaps(r, a)) n++
      if (rects === must && (r[0] < 0.01 || r[1] > 0.99 || r[2] < 0.01 || r[3] > 0.99)) n++
      return n
    }
    // The spot in use stays while it is still as good as when it was picked.
    if (this.pick) {
      const c = this.inFront(this.intoView(p.add(this.pick), camera, centerAtDepth, depth))
      if (clear(c, must) === 0 && clear(c, soft) + (step && this.leaderCrosses(camera, c, p, step) ? 1 : 0) <= this.pickSoft) return c
    }
    // 12 directions in the plate's plane, nearest to "toward the view centre" first.
    const a0 = Math.atan2(inward.dot(up), inward.dot(right))
    const dirs: vec3[] = []
    for (let i = 0; i < 12; i++) {
      const a = a0 + (i % 2 === 0 ? 1 : -1) * Math.ceil(i / 2) * (Math.PI / 6)
      dirs.push(right.uniformScale(Math.cos(a)).add(up.uniformScale(Math.sin(a))))
    }
    // The nearest spot (by distance step, then direction) with nothing it must avoid and
    // the fewest of the rest; further steps are tried only while that is not zero.
    let best: vec3 | null = null
    let bestScore = 1e9
    for (const k of [1, 1.4, 1.8, 2.6, 3.6, 4.8, 6]) {
      for (const dir of dirs) {
        const reach = Math.abs(dir.dot(right)) * this.panelWidth / 2 + Math.abs(dir.y) * this.panelHeight / 2
        let c = p.add(dir.uniformScale(k * reach + this.partGapCm)).add(toEye.uniformScale(this.towardUserCm))
        c = this.inFront(this.intoView(c, camera, centerAtDepth, depth))
        const score = 100 * clear(c, must) + clear(c, soft) + (step && this.leaderCrosses(camera, c, p, step) ? 1 : 0)
        if (score < bestScore) {
          bestScore = score
          best = c
        }
        if (score === 0) break
      }
      if (bestScore === 0) break
    }
    const c = best as vec3
    this.pick = c.sub(p)
    this.pickSoft = bestScore % 100
    this.clearOfPart = bestScore < 100
    this.clearOfRing = !ringRect || !this.overlaps(this.rectOf(camera, c, eye), ringRect)
    return c
  }

  /** Pass P: on screen, the line from the card's centre to the part crosses the step callout's rectangle. */
  private leaderCrosses(camera: Camera, c: vec3, p: vec3, r: number[]): boolean {
    const a = camera.worldSpaceToScreenSpace(c)
    const b = camera.worldSpaceToScreenSpace(p)
    for (let i = 1; i < 16; i++) {
      const t = i / 16
      const x = a.x + (b.x - a.x) * t
      const y = a.y + (b.y - a.y) * t
      if (x > r[0] && x < r[1] && y > r[2] && y < r[3]) return true
    }
    return false
  }

  /** Pass P: no nearer the wheel than the step callout's plane (the axle end poked through the card). */
  private inFront(c: vec3): vec3 {
    const z = this.stepCallout ? this.stepCallout.frontZ() : null
    return z !== null && c.z < z ? new vec3(c.x, c.y, z) : c
  }

  /** Screen rectangle of a pinch box (its box collider, from its world transform). */
  private boxRect(camera: Camera, so: SceneObject): number[] {
    const col = so.getComponent("Physics.ColliderComponent") as ColliderComponent
    const box = col ? (col.shape as BoxShape) : null
    const s = box && box.size ? box.size : new vec3(4, 4, 4)
    const m = so.getTransform().getWorldTransform()
    let x0 = 2
    let x1 = -1
    let y0 = 2
    let y1 = -1
    for (const sx of [-0.5, 0.5]) {
      for (const sy of [-0.5, 0.5]) {
        for (const sz of [-0.5, 0.5]) {
          const q = camera.worldSpaceToScreenSpace(m.multiplyPoint(new vec3(sx * s.x, sy * s.y, sz * s.z)))
          x0 = Math.min(x0, q.x)
          x1 = Math.max(x1, q.x)
          y0 = Math.min(y0, q.y)
          y1 = Math.max(y1, q.y)
        }
      }
    }
    return [x0, x1, y0, y1]
  }

  private flatRight(eye: vec3, c: vec3): vec3 {
    const flat = new vec3(eye.x - c.x, 0, eye.z - c.z)
    if (flat.length < 1e-3) return vec3.right()
    const n = flat.normalize()
    return new vec3(n.z, 0, -n.x)
  }

  /** Slides `c` toward the view center until the whole plate is inside the safe rectangle. */
  private intoView(c: vec3, camera: Camera, centerAtDepth: vec3, depth: number): vec3 {
    const m = (1 - this.safeFraction) / 2
    for (let i = 0; i < 12; i++) {
      const s = camera.worldSpaceToScreenSpace(c)
      const ex = (this.panelWidth / 2 / depth) * 1.9
      const ey = (this.panelHeight / 2 / depth) * 1.6
      const out = s.x - ex < m || s.x + ex > 1 - m || s.y - ey < m || s.y + ey > 1 - m
      if (!out) break
      c = c.add(centerAtDepth.sub(c).uniformScale(0.15))
    }
    return c
  }

  /** Screen rectangle of a w x h plate centered at c, turned to the eye. */
  private rectOf(camera: Camera, c: vec3, eye: vec3, w: number = this.panelWidth, h: number = this.panelHeight): number[] {
    const right = this.flatRight(eye, c)
    let x0 = 2
    let x1 = -1
    let y0 = 2
    let y1 = -1
    for (const sx of [-1, 1]) {
      for (const sy of [-1, 1]) {
        const q = camera.worldSpaceToScreenSpace(c.add(right.uniformScale((sx * w) / 2)).add(new vec3(0, (sy * h) / 2, 0)))
        x0 = Math.min(x0, q.x)
        x1 = Math.max(x1, q.x)
        y0 = Math.min(y0, q.y)
        y1 = Math.max(y1, q.y)
      }
    }
    return [x0, x1, y0, y1]
  }

  private stepRect(camera: Camera): number[] | null {
    const sc = this.stepCallout
    if (!sc || !sc.sceneObject.isEnabledInHierarchy || sc.throughWheel) return null
    const cam = WorldCameraFinderProvider.getInstance()
    const eye = cam ? cam.getWorldPosition() : vec3.zero()
    return this.rectOf(camera, sc.sceneObject.getTransform().getWorldPosition(), eye, sc.scaledWidth(), sc.scaledHeight())
  }

  private overlaps(a: number[], b: number[]): boolean {
    const m = 0.01
    return a[0] < b[1] + m && a[1] > b[0] - m && a[2] < b[3] + m && a[3] > b[2] - m
  }
}
