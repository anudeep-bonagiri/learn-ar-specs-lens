/**
 * ScanReveal — the "sees what you see" moment (Nov 1 audit, section 6 item 4).
 * When Found it brings the wheel in (step 0 to 1) a thin scan line sweeps across it
 * from the user's left to right; as the line passes the valve and the rim their
 * labels snap on with a tick, hold for a moment, then fade. Step 1 runs underneath
 * the whole time, so nothing waits on it. The start card's stand-in badge is untouched.
 * Owns: the line, the two labels, playing / phase / labelsShown. Must not: change
 * steps or move the wheel (its children live in the wheel's frame and follow it).
 * Expects: @inputs manager, wheel, valve, boxMesh, markerMaterial; optional audio.
 */
import {RepairManager} from "./RepairManager"
import {BenchCoachAudio} from "./BenchCoachAudio"

interface ScanLabel {
  so: SceneObject
  text: Text
  /** Wheel-local x the line must pass before this label shows. */
  x: number
  shownAt: number
}

@component
export class ScanReveal extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">ScanReveal – scan line and labels when the wheel appears</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine (plays on step 0 to 1)")
  manager: RepairManager

  @input
  @hint("Wheel root: the line and labels live in its XY plane, in front of it")
  wheel: SceneObject

  @input
  @hint("Valve object (its label sits just outside it)")
  valve: SceneObject

  @input
  @hint("Unit box mesh for the scan line")
  boxMesh: RenderMesh

  @input
  @hint("Marker material; the line uses a blended copy")
  markerMaterial: Material

  @input
  @hint("Cue player (a tick as each label snaps on); optional")
  @allowUndefined
  audio: BenchCoachAudio
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Outer radius of the tire in cm; the line is a little taller and sweeps a little wider")
  @widget(new SliderWidget(20, 60, 0.5))
  wheelRadiusCm: number = 38

  @input
  @hint("Seconds for the line to cross the wheel")
  @widget(new SliderWidget(0.4, 4, 0.1))
  sweepSec: number = 1.2

  @input
  @hint("Seconds the labels hold after the sweep")
  @widget(new SliderWidget(0, 10, 0.5))
  holdSec: number = 2.5

  @input
  @hint("Seconds the labels take to fade out")
  @widget(new SliderWidget(0.1, 2, 0.1))
  fadeSec: number = 0.4

  @input
  @hint("Label text size; about 0.036 cm per unit on a world object (the step label's 33 is 1.2 cm tall), so 80 is 3 cm letters")
  @widget(new SliderWidget(20, 160, 1))
  labelSize: number = 80

  @input
  @hint("How far outside the tire the Rim label sits, in cm")
  @widget(new SliderWidget(2, 20, 0.5))
  labelOutCm: number = 4

  @input
  @hint("Where the Rim label sits, degrees clockwise from 12 o'clock (330 = 11 o'clock: inside the preview's and Specs' view from the start pose)")
  @widget(new SliderWidget(0, 359, 1))
  rimLabelAngleDeg: number = 330

  @input
  @hint("Valve label offset along the rim from the valve, in cm (to the user's right); the step label panel sits straight above the valve")
  @widget(new SliderWidget(4, 20, 0.5))
  valveLabelAlongCm: number = 12

  @input("vec4", "{0.6, 1, 1, 1}")
  @hint("Line and label colour (cyan, like the highlights)")
  @widget(new ColorWidget())
  color: vec4
  @ui.group_end

  /** True from Found it until the labels have faded. */
  playing: boolean = false
  /** "sweep", "hold", "fade" or "" while idle. */
  phase: string = ""
  /** Labels snapped on during the current play (2 when the sweep is done). */
  labelsShown: number = 0
  /** How many times the reveal has played. */
  plays: number = 0

  private line: SceneObject | null = null
  private lineMat: Material | null = null
  private labels: ScanLabel[] = []
  private t0 = 0
  private lastStep = -1

  onAwake(): void {
    if (!this.manager || !this.wheel || !this.valve || !this.boxMesh || !this.markerMaterial) {
      print("[ScanReveal] ERROR: missing @input refs")
      return
    }
    this.lineMat = this.markerMaterial.clone()
    this.lineMat.mainPass.blendMode = BlendMode.Normal
    this.lineMat.mainPass.baseColor = this.color
    this.line = global.scene.createSceneObject("ScanLine")
    this.line.setParent(this.wheel)
    const lineVis = this.line.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
    lineVis.mesh = this.boxMesh
    lineVis.mainMaterial = this.lineMat
    this.line.getTransform().setLocalScale(new vec3(0.6, 2 * this.wheelRadiusCm + 10, 0.5))
    this.line.enabled = false
    this.labels = [this.buildLabel("ScanLabel_Valve", "Valve"), this.buildLabel("ScanLabel_Rim", "Rim")]

    this.createEvent("OnStartEvent").bind(() => {
      this.lastStep = this.manager.getState().step
      this.manager.onStepChanged.add((s) => {
        if (s === 1 && this.lastStep === 0) this.play()
        this.lastStep = s
      })
      this.manager.onReset.add(() => this.stop())
    })
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Start the sweep now (Found it does this; exposed for screenshots). */
  play(): void {
    if (!this.line) return
    this.plays += 1
    this.playing = true
    this.phase = "sweep"
    this.labelsShown = 0
    this.t0 = getTime()
    // Label spots in the wheel's frame. Valve: beside the marker along the rim's tangent
    // (straight above it is where the step label panel sits). Rim: outside the tire at rimLabelAngleDeg.
    const inv = this.wheel.getTransform().getInvertedWorldTransform()
    const v = inv.multiplyPoint(this.valve.getTransform().getWorldPosition())
    const vr = Math.max(1, Math.sqrt(v.x * v.x + v.y * v.y))
    const tangent = new vec3(v.y / vr, -v.x / vr, 0) // clockwise = the user's right at 12 o'clock
    const vp = new vec3(v.x, v.y, 0).add(tangent.uniformScale(this.valveLabelAlongCm))
    this.placeLabel(this.labels[0], new vec3(vp.x, vp.y, 4))
    const a = (this.rimLabelAngleDeg * Math.PI) / 180
    const r = this.wheelRadiusCm + this.labelOutCm
    this.placeLabel(this.labels[1], new vec3(Math.sin(a) * r, Math.cos(a) * r, 4))
    this.setLineX(-this.wheelRadiusCm - 6)
    this.line.enabled = true
  }

  /** Hide everything (reset, or the fade finished). */
  stop(): void {
    this.playing = false
    this.phase = ""
    if (this.line) this.line.enabled = false
    for (const l of this.labels) l.so.enabled = false
  }

  private tick(): void {
    if (!this.playing || !this.line) return
    const t = getTime() - this.t0
    if (t < this.sweepSec) {
      this.phase = "sweep"
      const span = 2 * this.wheelRadiusCm + 12
      const x = -this.wheelRadiusCm - 6 + (span * t) / this.sweepSec
      this.setLineX(x)
      for (const l of this.labels) {
        if (l.shownAt < 0 && l.x <= x) {
          l.shownAt = getTime()
          l.so.enabled = true
          this.labelsShown += 1
          if (this.audio) this.audio.playTickAt(l.so.getTransform().getWorldPosition())
        }
      }
    } else if (t < this.sweepSec + this.holdSec) {
      if (this.phase === "sweep") {
        // The line has crossed: any label it should have passed is on; the line goes.
        for (const l of this.labels) {
          if (l.shownAt < 0) {
            l.shownAt = getTime()
            l.so.enabled = true
            this.labelsShown += 1
          }
        }
        this.line.enabled = false
      }
      this.phase = "hold"
    } else if (t < this.sweepSec + this.holdSec + this.fadeSec) {
      this.phase = "fade"
      const k = 1 - (t - this.sweepSec - this.holdSec) / this.fadeSec
      for (const l of this.labels) this.setLabelAlpha(l, Math.max(0, k))
    } else {
      this.stop()
      return
    }
    // Pop each label in over 0.15 s after it snaps on.
    for (const l of this.labels) {
      if (l.shownAt < 0) continue
      const p = Math.min(1, (getTime() - l.shownAt) / 0.15)
      const s = 0.4 + 0.6 * (1 - Math.pow(1 - p, 3))
      l.so.getTransform().setLocalScale(new vec3(s, s, s))
    }
  }

  private setLineX(x: number): void {
    if (this.line) this.line.getTransform().setLocalPosition(new vec3(x, 0, 4))
  }

  private buildLabel(name: string, text: string): ScanLabel {
    const so = global.scene.createSceneObject(name)
    so.setParent(this.wheel)
    const t = so.createComponent("Component.Text") as Text
    t.text = text
    t.size = this.labelSize
    t.depthTest = true
    t.horizontalAlignment = HorizontalAlignment.Center
    t.verticalAlignment = VerticalAlignment.Center
    t.horizontalOverflow = HorizontalOverflow.Overflow
    t.verticalOverflow = VerticalOverflow.Overflow
    t.textFill.color = this.color
    so.enabled = false
    return {so, text: t, x: 0, shownAt: -1}
  }

  private placeLabel(l: ScanLabel, local: vec3): void {
    l.so.getTransform().setLocalPosition(local)
    l.so.getTransform().setLocalScale(new vec3(0.4, 0.4, 0.4))
    l.x = local.x
    l.shownAt = -1
    l.so.enabled = false
    this.setLabelAlpha(l, 1)
  }

  private setLabelAlpha(l: ScanLabel, a: number): void {
    const c = this.color
    l.text.textFill.color = new vec4(c.x, c.y, c.z, a)
  }
}
