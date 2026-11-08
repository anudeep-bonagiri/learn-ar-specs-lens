/**
 * ScanReveal — the "sees what you see" moment.
 * When Found it brings the wheel in (step 0 to 1) an outline traces the tire: two bright
 * heads leave 6 o'clock, run up both sides hugging the tread and meet at the valve,
 * where step 1's marker is. The trail stays as a thin accent ring, flashes once as the
 * heads meet ("locked on"), holds, then fades. As a head passes a part, its label pops
 * on in the info-callout look (D2 plate, title role, neutral edge that flashes the
 * accent as it appears, grey leader to the part): Rim, then Valve as the heads meet,
 * then Hub. Step 1 runs underneath the whole time, so nothing waits on it.
 * Label spots are inside the rim: from the start eye the view (about 53 x 66 cm at the
 * wheel) leaves only 4 cm above the tire and cuts its sides, so the labels sit beside
 * the valve marker above step 1's callout, at the left inside the rim, and right of the
 * hub; none covers the callout, the marker ring or the tire.
 * Owns: the outline segments, the labels, playing / phase / labelsShown / plays.
 * Must not: change steps or move the wheel. The outline lives in the wheel's frame;
 * the labels are placed from it every frame, so a re-anchor carries everything.
 * Expects: @inputs manager, wheel, valve, boxMesh, markerMaterial; optional audio.
 */
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import WorldCameraFinderProvider from "SpectaclesInteractionKit.lspkg/Providers/CameraProvider/WorldCameraFinderProvider"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {RepairManager} from "./RepairManager"
import {BenchCoachAudio} from "./BenchCoachAudio"
import {COLOR, LeaderLine, Plate, addUIText, charCm, flexColumn, lineCm, makePlate, plateEdgePoint} from "./UIHelpers"

/** One part label: where its plate sits and what its leader points at, in the wheel's frame. */
interface ScanLabelSpec {
  name: string
  title: string
  /** Plate center, wheel-local cm (x to the user's right, y up). */
  plate: vec2
  /** Leader end, wheel-local cm; null = the valve object's position. */
  target: vec2 | null
  /** When it pops: the heads' progress (0..1); above 1 is after they meet. */
  at: number
}

const LABELS: ScanLabelSpec[] = [
  // The rim at about 10:30; the plate inside it, left of and below step 1's callout.
  {name: "ScanLabel_Rim", title: "Rim", plate: new vec2(-16.5, 9), target: new vec2(-21.9, 19.8), at: 0.74},
  // The valve, where the heads meet; the plate right of the marker ring, above the callout.
  {name: "ScanLabel_Valve", title: "Valve", plate: new vec2(8.6, 24), target: null, at: 1.0},
  // The hub, last: the plate to its right, below step 1's callout.
  {name: "ScanLabel_Hub", title: "Hub", plate: new vec2(13.5, -1), target: new vec2(3.6, 0), at: 1.12},
]

interface ScanLabel {
  spec: ScanLabelSpec
  root: SceneObject
  plate: Plate
  leader: LeaderLine
  width: number
  height: number
  shownAt: number
}

@component
export class ScanReveal extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">ScanReveal – the outline trace and part labels when the wheel appears</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine (plays on step 0 to 1)")
  manager: RepairManager

  @input
  @hint("Wheel root: the outline lives in its XY plane")
  wheel: SceneObject

  @input
  @hint("Valve object (the heads meet at it; its label's leader ends on it)")
  valve: SceneObject

  @input
  @hint("Unit box mesh for the outline segments")
  boxMesh: RenderMesh

  @input
  @hint("Marker material; the outline uses blended copies")
  markerMaterial: Material

  @input
  @hint("Cue player (a tick as each label pops on, a chime as the heads meet); optional")
  @allowUndefined
  audio: BenchCoachAudio
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Outer radius of the tire in cm (bead radius 33.4 + tube 1.2, with the tread); the outline hugs it")
  @widget(new SliderWidget(20, 60, 0.1))
  wheelRadiusCm: number = 34.6

  @input
  @hint("Gap between the tread and the outline, in cm")
  @widget(new SliderWidget(0, 4, 0.1))
  outlineGapCm: number = 0.6

  @input
  @hint("Outline thickness in cm (0.45 is about 0.3 degrees at 90 cm: a fine line)")
  @widget(new SliderWidget(0.1, 2, 0.05))
  outlineCm: number = 0.45

  @input
  @hint("Seconds for the two heads to run from 6 o'clock to the valve")
  @widget(new SliderWidget(0.4, 4, 0.1))
  sweepSec: number = 1.4

  @input
  @hint("Seconds the outline and labels hold after the heads meet")
  @widget(new SliderWidget(0, 10, 0.5))
  holdSec: number = 2.5

  @input
  @hint("Seconds the outline and labels take to go")
  @widget(new SliderWidget(0.1, 2, 0.1))
  fadeSec: number = 0.4

  @input
  @hint("Viewing distance the labels' type and grid are sized for, in cm")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 90
  @ui.group_end

  /** True from Found it until the outline and labels have gone. */
  playing: boolean = false
  /** "sweep", "hold", "fade" or "" while idle. */
  phase: string = ""
  /** Labels popped on during the current play (LABELS.length once the heads have met). */
  labelsShown: number = 0
  /** Lit outline segments now (tests read it). */
  litSegments: number = 0
  /** How many times the reveal has played. */
  plays: number = 0

  private outline: SceneObject | null = null
  private segs: RenderMeshVisual[] = []
  /** Each segment's angular distance from 6 o'clock, 0..180 degrees. */
  private segFromBottom: number[] = []
  private headMat: Material | null = null
  private trailMat: Material | null = null
  private labels: ScanLabel[] = []
  private t0 = 0
  private lastStep = -1
  private met = false
  private hiddenOnce = false

  private static readonly SEGMENTS = 120
  /** The bright head covers this many degrees behind each tip. */
  private static readonly HEAD_DEG = 10
  private static readonly HEAD = new vec4(0.8, 1, 1, 1)

  onAwake(): void {
    if (!this.manager || !this.wheel || !this.valve || !this.boxMesh || !this.markerMaterial) {
      print("[ScanReveal] ERROR: missing @input refs")
      return
    }
    this.headMat = this.markerMaterial.clone()
    this.headMat.mainPass.blendMode = BlendMode.Normal
    this.headMat.mainPass.baseColor = ScanReveal.HEAD
    this.trailMat = this.markerMaterial.clone()
    this.trailMat.mainPass.blendMode = BlendMode.Normal
    this.setTrailAlpha(0.85)
    this.buildOutline()
    for (const spec of LABELS) this.labels.push(this.buildLabel(spec))

    this.createEvent("OnStartEvent").bind(() => {
      this.lastStep = this.manager.getState().step
      this.manager.onStepChanged.add((s) => {
        if (s === 1 && this.lastStep === 0) this.play()
        this.lastStep = s
      })
      this.manager.onReset.add(() => this.stop())
    })
    this.createEvent("LateUpdateEvent").bind(() => this.tick())
  }

  /** Start the reveal now (Found it does this; jumpToStep(1) replays it). */
  play(): void {
    if (!this.outline) return
    this.plays += 1
    this.playing = true
    this.phase = "sweep"
    this.labelsShown = 0
    this.met = false
    this.t0 = getTime()
    this.setTrailAlpha(0.85)
    for (const s of this.segs) s.sceneObject.enabled = false
    for (const l of this.labels) {
      l.shownAt = -1
      l.root.enabled = false
      l.leader.setEnabled(false)
    }
    this.outline.enabled = true
    this.litSegments = 0
  }

  /** Hide everything (reset, or the fade finished). */
  stop(): void {
    this.playing = false
    this.phase = ""
    this.litSegments = 0
    if (this.outline) this.outline.enabled = false
    for (const l of this.labels) {
      l.root.enabled = false
      l.leader.setEnabled(false)
    }
  }

  private tick(): void {
    if (!this.hiddenOnce) {
      // First frame: the UIKit plates have initialized while enabled; now start hidden.
      this.hiddenOnce = true
      if (!this.playing) this.stop()
    }
    if (!this.playing || !this.outline) return
    const t = getTime() - this.t0
    const u = Math.min(1, t / this.sweepSec)
    // Fast out of 6 o'clock (below the view), slowing into the valve.
    const p = 1 - Math.pow(1 - u, 2.2)
    const tip = p * 180
    let lit = 0
    for (let i = 0; i < this.segs.length; i++) {
      const on = this.segFromBottom[i] <= tip
      const vis = this.segs[i]
      if (vis.sceneObject.enabled !== on) vis.sceneObject.enabled = on
      if (!on) continue
      lit++
      const head = u < 1 && tip - this.segFromBottom[i] < ScanReveal.HEAD_DEG
      vis.mainMaterial = head ? this.headMat : this.trailMat
    }
    this.litSegments = lit
    // Progress past 1 runs on in time, so the last label can follow the meeting.
    const prog = u < 1 ? p : 1 + (t - this.sweepSec) / this.sweepSec
    for (const l of this.labels) {
      if (l.shownAt < 0 && prog >= l.spec.at) {
        l.shownAt = getTime()
        l.root.enabled = true
        this.labelsShown += 1
        if (this.audio) this.audio.playTickAt(this.labelWorld(l))
      }
    }
    if (u >= 1 && !this.met) {
      this.met = true
      if (this.audio) this.audio.playChimeAt(this.valve.getTransform().getWorldPosition())
    }

    const holdEnd = this.sweepSec + this.holdSec
    if (t < this.sweepSec) {
      this.phase = "sweep"
    } else if (t < holdEnd) {
      this.phase = "hold"
      // Locked on: the ring flashes once, then settles a little dimmer.
      const k = Math.min(1, (t - this.sweepSec) / 0.5)
      this.setTrailAlpha(1 - 0.45 * k)
    } else if (t < holdEnd + this.fadeSec) {
      this.phase = "fade"
      this.setTrailAlpha(0.55 * (1 - (t - holdEnd) / this.fadeSec))
    } else {
      this.stop()
      return
    }
    for (const l of this.labels) if (l.shownAt >= 0) this.placeLabel(l, t, holdEnd)
  }

  // ── Outline ─────────────────────────────────────────────────────────────────
  private buildOutline(): void {
    this.outline = global.scene.createSceneObject("ScanOutline")
    this.outline.setParent(this.wheel)
    const n = ScanReveal.SEGMENTS
    const r = this.wheelRadiusCm + this.outlineGapCm
    // Exact chords: an overlap shows as a brighter tick at each joint once the ring is blended.
    const chord = 2 * r * Math.sin(Math.PI / n)
    for (let i = 0; i < n; i++) {
      // Angle clockwise from 12 o'clock, as TorusArc and the step code use.
      const deg = ((i + 0.5) * 360) / n
      const a = (deg * Math.PI) / 180
      const so = global.scene.createSceneObject(`ScanSeg_${i}`)
      so.setParent(this.outline)
      const tr = so.getTransform()
      tr.setLocalPosition(new vec3(Math.sin(a) * r, Math.cos(a) * r, 0))
      tr.setLocalRotation(quat.angleAxis(-a, new vec3(0, 0, 1)))
      tr.setLocalScale(new vec3(chord, this.outlineCm, this.outlineCm))
      const vis = so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
      vis.mesh = this.boxMesh
      vis.mainMaterial = this.trailMat
      so.enabled = false
      this.segs.push(vis)
      this.segFromBottom.push(Math.abs(180 - deg))
    }
    this.outline.enabled = false
  }

  private setTrailAlpha(a: number): void {
    if (!this.trailMat) return
    const c = COLOR.accent
    this.trailMat.mainPass.baseColor = new vec4(c.x, c.y, c.z, a)
  }

  // ── Labels (the info callout's look) ────────────────────────────────────────
  private buildLabel(spec: ScanLabelSpec): ScanLabel {
    const d = this.viewDistanceCm
    const titleH = lineCm("instruction", d)
    const k = d / 90
    const pad = 1.1 * k
    const w = charCm("instruction", d) * (spec.title.length + 1.5) + 2 * pad
    const h = titleH + 2 * pad * 0.8
    const root = global.scene.createSceneObject(spec.name)
    root.setParent(this.sceneObject)
    root.createComponent(Billboard.getTypeName())
    const plate = makePlate(root, w, h, d)
    const col = flexColumn(plate.content, w, h, {
      padX: pad,
      padY: pad * 0.8,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    addUIText(col, spec.name + "_Title", spec.title, "instruction", w - 2 * pad, titleH, d, {align: HorizontalAlignment.Center})
    const leader = new LeaderLine(this.sceneObject, spec.name + "_Leader", 0.1, COLOR.edge)
    return {spec, root, plate, leader, width: w, height: h, shownAt: -1}
  }

  private labelWorld(l: ScanLabel): vec3 {
    const p = l.spec.plate
    return this.wheel.getTransform().getWorldTransform().multiplyPoint(new vec3(p.x, p.y, 2))
  }

  private targetWorld(l: ScanLabel): vec3 {
    if (!l.spec.target) return this.valve.getTransform().getWorldPosition()
    const p = l.spec.target
    return this.wheel.getTransform().getWorldTransform().multiplyPoint(new vec3(p.x, p.y, 0.5))
  }

  /** Pop in (0.6 to 1 with a small overshoot), edge flash from the accent, pop out in the fade. */
  private placeLabel(l: ScanLabel, t: number, holdEnd: number): void {
    const age = getTime() - l.shownAt
    const pIn = Math.min(1, age / 0.22)
    const back = 1.70158
    const ease = 1 + (back + 1) * Math.pow(pIn - 1, 3) + back * Math.pow(pIn - 1, 2)
    let s = 0.6 + 0.4 * ease
    if (t > holdEnd) s *= Math.max(0, 1 - (t - holdEnd) / this.fadeSec)
    const c = this.labelWorld(l)
    const tr = l.root.getTransform()
    tr.setWorldPosition(c)
    tr.setLocalScale(new vec3(s, s, s))
    const flash = Math.max(0, 1 - age / 0.6)
    const a = COLOR.accent
    const e = COLOR.edge
    l.plate.setEdge(
      new vec4(e.x + (a.x - e.x) * flash, e.y + (a.y - e.y) * flash, e.z + (a.z - e.z) * flash, e.w + (1 - e.w) * flash)
    )
    if (s < 0.3) {
      l.leader.setEnabled(false)
      return
    }
    const cam = WorldCameraFinderProvider.getInstance()
    const eye = cam ? cam.getWorldPosition() : c.add(new vec3(0, 0, 100))
    const flat = new vec3(eye.x - c.x, 0, eye.z - c.z).normalize()
    const right = new vec3(flat.z, 0, -flat.x)
    const target = this.targetWorld(l)
    l.leader.set(plateEdgePoint(c, right, l.width * s, l.height * s, target), target)
  }
}
