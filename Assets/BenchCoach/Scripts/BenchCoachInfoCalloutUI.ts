/**
 * BenchCoachInfoCalloutUI — the What's this? info callout (pass D2). A small card with
 * the part's name and one line, on the design-system plate, turned to the user, with a
 * light grey leader line to the part. It never rewrites the step callout.
 * showPart(title, line, part): placed beside the part, a little nearer the user, at the
 * first of a few spots (toward the middle of the view, above, below, the diagonals,
 * outward) that stays inside the view and does not overlap the step callout on screen.
 * showPrompt(title, line, at): no leader; PartInfo puts it in the slot under the step
 * callout. hide().
 * Owns: only its view and its placement.
 */
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import WorldCameraFinderProvider from "SpectaclesInteractionKit.lspkg/Providers/CameraProvider/WorldCameraFinderProvider"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {COLOR, LeaderLine, addUIText, flexColumn, lineCm, makePlate, plateEdgePoint} from "./UIHelpers"
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
  showPart(title: string, line: string, part: SceneObject): void {
    this.set(title, line)
    this.part = part
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
   * Beside the part, nearer the user: the first candidate spot that stays inside the
   * safe part of the view and does not overlap the step callout on screen.
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
    const dirs = [inward, up, up.uniformScale(-1), inward.add(up).normalize(), inward.sub(up).normalize(), inward.uniformScale(-1)]
    const toEye = eye.sub(p).normalize()
    const avoid = this.stepRect(camera)
    let best: vec3 | null = null
    for (const dir of dirs) {
      const reach = Math.abs(dir.dot(this.flatRight(eye, p))) * this.panelWidth / 2 + Math.abs(dir.y) * this.panelHeight / 2
      let c = p.add(dir.uniformScale(reach + this.partGapCm)).add(toEye.uniformScale(this.towardUserCm))
      c = this.intoView(c, camera, centerAtDepth, depth)
      if (!best) best = c
      if (!avoid || !this.overlaps(this.rectOf(camera, c, eye), avoid)) return c
    }
    return best as vec3
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
    if (!sc || !sc.sceneObject.isEnabledInHierarchy) return null
    const cam = WorldCameraFinderProvider.getInstance()
    const eye = cam ? cam.getWorldPosition() : vec3.zero()
    return this.rectOf(camera, sc.sceneObject.getTransform().getWorldPosition(), eye, sc.scaledWidth(), sc.scaledHeight())
  }

  private overlaps(a: number[], b: number[]): boolean {
    const m = 0.01
    return a[0] < b[1] + m && a[1] > b[0] - m && a[2] < b[3] + m && a[3] > b[2] - m
  }
}
