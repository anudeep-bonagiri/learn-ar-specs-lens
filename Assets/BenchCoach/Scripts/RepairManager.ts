/**
 * RepairManager — the step machine (steps 0..7) for the flat-fix procedure.
 * Owns: state {step, subStep, startTime}, which authored objects are visible per
 * step, the StepMarker / StepLabel placement, and every model change (tire
 * deflate, bead push, bead lift) plus its undo on Back / reset.
 * Reads: StepDefinitions. Listens to: WheelTargets, LeverPlacement.
 * Must not: author UI — cards and labels are passive views driven via setters.
 * Note: step-0 visibility is applied on the first Update so every authored
 * component (UIKit plates, buttons, levers) initializes while enabled.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {LAST_STEP, LOOSEN_BEADS, STEPS, StepDef, SOCKET_ANGLE_DEG} from "./StepDefinitions"
import {WheelTargets} from "./WheelTargets"
import {LeverPlacement} from "./LeverPlacement"
import {GhostAnimator} from "./GhostAnimator"
import {BenchCoachStepLabelUI} from "./BenchCoachStepLabelUI"
import {BenchCoachDoneCardUI} from "./BenchCoachDoneCardUI"

export interface RepairState {
  step: number
  subStep: number
  startTime: number
  elapsedSec: number
}

@component
export class RepairManager extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">RepairManager – step machine 0..7</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Wheel assembly root (hidden until Found it)")
  wheel: SceneObject

  @input
  @hint("Repair stand root (hidden until Found it)")
  stand: SceneObject

  @input
  @hint("Tire group holding Bead_0..7 (scaled 4% down on deflate)")
  tire: SceneObject

  @input
  @hint("Valve stem (step 1 marker anchor)")
  valve: SceneObject

  @input
  @hint("Pinch targets on the valve and beads")
  wheelTargets: WheelTargets

  @input
  @hint("StartCard root (step 0 only)")
  startCard: SceneObject

  @input
  @hint("The single StepMarker ring")
  stepMarker: SceneObject

  @input
  @hint("Step label panel")
  stepLabel: BenchCoachStepLabelUI

  @input
  @hint("ToolTray root (levers inside), shown from step 3")
  toolTray: SceneObject

  @input
  @hint("Ghost lever animator (step 3)")
  ghost: GhostAnimator

  @input
  @hint("LeverSocket: snap target on the bead at the valve")
  leverSocket: SceneObject

  @input
  @hint("Lever A placement controller")
  leverA: LeverPlacement

  @input
  @hint("Done card (step 7 stub)")
  doneCard: BenchCoachDoneCardUI
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Bead major radius in cm (matches the Bead_i TorusArc)")
  @widget(new SliderWidget(10, 60, 0.1))
  beadRadiusCm: number = 33.4

  @input
  @hint("Marker stand-off in front of the part, in cm")
  @widget(new SliderWidget(0, 10, 0.5))
  markerStandoffCm: number = 1.5

  @input
  @hint("Label distance from its marker, in cm")
  @widget(new SliderWidget(4, 30, 0.5))
  labelOffsetCm: number = 10

  @input
  @hint("Tire scale after deflating (0.96 = 4% smaller)")
  @widget(new SliderWidget(0.8, 1, 0.01))
  deflateScale: number = 0.96

  @input
  @hint("How far each loosened bead shifts toward the rim center, in cm")
  @widget(new SliderWidget(0.1, 3, 0.1))
  beadPushCm: number = 0.5

  @input
  @hint("How far Bead_0 lifts radially outward when lever A hooks, in cm")
  @widget(new SliderWidget(0.2, 5, 0.1))
  beadLiftCm: number = 1

  @input
  @hint("Print step transitions to the log")
  debugLogs: boolean = true
  @ui.group_end

  private step = 0
  private subStep = 0
  private startTime = 0
  private loosened: number[] = []
  private leverPlaced = false
  private initialized = false

  private _onStepChanged = new Event<number>()
  onStepChanged: PublicApi<number> = this._onStepChanged.publicApi()

  getState(): RepairState {
    return {
      step: this.step,
      subStep: this.subStep,
      startTime: this.startTime,
      elapsedSec: this.startTime > 0 ? getTime() - this.startTime : 0,
    }
  }

  getLoosenedBeads(): number[] {
    return this.loosened.slice()
  }

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => this.onStart())
    this.createEvent("UpdateEvent").bind(() => {
      if (!this.initialized) {
        this.initialized = true
        this.applyStep()
      }
    })
  }

  private onStart(): void {
    const missing: string[] = []
    const refs: Array<[string, unknown]> = [
      ["wheel", this.wheel],
      ["stand", this.stand],
      ["tire", this.tire],
      ["valve", this.valve],
      ["wheelTargets", this.wheelTargets],
      ["startCard", this.startCard],
      ["stepMarker", this.stepMarker],
      ["stepLabel", this.stepLabel],
      ["toolTray", this.toolTray],
      ["ghost", this.ghost],
      ["leverSocket", this.leverSocket],
      ["leverA", this.leverA],
      ["doneCard", this.doneCard],
    ]
    for (const [name, value] of refs) if (!value) missing.push(name)
    if (missing.length > 0) {
      print(`[RepairManager] ERROR: missing @input refs: ${missing.join(", ")}`)
      return
    }
    this.wheelTargets.onValvePinched.add(() => this.onValvePinched())
    this.wheelTargets.onBeadPinched.add((i) => this.onBeadPinched(i))
    this.leverA.onPlaced.add(() => this.onLeverPlaced())
  }

  // ── Public actions (UIBindings + tests) ────────────────────────────────────
  foundIt(): void {
    if (this.step !== 0) return
    this.startTime = getTime()
    this.goTo(1)
  }

  next(): void {
    if (this.step === 0) {
      this.foundIt()
      return
    }
    if (this.step >= LAST_STEP) return
    this.goTo(this.step + 1)
  }

  back(): void {
    if (this.step <= 0) return
    this.undoStep(this.step - 1)
    this.goTo(this.step - 1)
  }

  replay(): void {
    if (this.step === 3 && this.ghost) this.ghost.play()
  }

  reset(): void {
    for (let s = LAST_STEP; s >= 0; s--) this.undoStep(s)
    this.startTime = 0
    this.goTo(0)
  }

  // ── Completion handlers ────────────────────────────────────────────────────
  private onValvePinched(): void {
    if (this.step !== 1) return
    this.setDeflated(true)
    this.log("valve pinched: tire deflated")
    this.goTo(2)
  }

  private onBeadPinched(i: number): void {
    if (this.step !== 2) return
    if (LOOSEN_BEADS.indexOf(i) < 0 || this.loosened.indexOf(i) >= 0) return
    this.setBeadOffset(i, -this.beadPushCm)
    this.loosened.push(i)
    this.subStep = this.loosened.length
    this.log(`bead ${i} pushed (${this.loosened.length}/${LOOSEN_BEADS.length})`)
    if (this.loosened.length >= LOOSEN_BEADS.length) {
      this.goTo(3)
    } else {
      this.placeMarkerAndLabel()
    }
  }

  private onLeverPlaced(): void {
    if (this.step !== 3) return
    this.leverPlaced = true
    this.setBeadOffset(0, this.beadLiftCm - (this.loosened.indexOf(0) >= 0 ? this.beadPushCm : 0))
    if (this.ghost) this.ghost.sceneObject.enabled = false
    this.log("lever A placed: Bead_0 lifted")
    this.goTo(4)
  }

  // ── Step transitions ───────────────────────────────────────────────────────
  private goTo(step: number): void {
    this.step = Math.max(0, Math.min(LAST_STEP, step))
    this.subStep = 0
    this.applyStep()
    this._onStepChanged.invoke(this.step)
  }

  /** Undo the model change that completing `step` produced. */
  private undoStep(step: number): void {
    switch (step) {
      case 0:
        this.startTime = 0
        break
      case 1:
        this.setDeflated(false)
        break
      case 2:
        for (const i of LOOSEN_BEADS) this.setBeadOffset(i, 0)
        this.loosened = []
        break
      case 3:
        if (this.leverPlaced) {
          this.setBeadOffset(0, this.loosened.indexOf(0) >= 0 ? -this.beadPushCm : 0)
          this.leverPlaced = false
        }
        if (this.leverA) this.leverA.returnHome(true)
        break
      default:
        break
    }
  }

  private applyStep(): void {
    const def = STEPS[this.step]
    this.setEnabled(this.startCard, def.showStartCard)
    this.setEnabled(this.wheel, def.showWheel)
    this.setEnabled(this.stand, def.showWheel)
    this.setEnabled(this.toolTray, def.showTray)
    if (this.ghost) this.setEnabled(this.ghost.sceneObject, def.showGhost)
    if (this.doneCard) this.setEnabled(this.doneCard.sceneObject, def.showDoneCard)
    if (def.showDoneCard && this.doneCard) this.doneCard.setElapsed(this.getState().elapsedSec)

    const showMarker = def.markerAnchor !== "none"
    this.setEnabled(this.stepMarker, showMarker)
    if (this.stepLabel) this.setEnabled(this.stepLabel.sceneObject, showMarker)
    if (showMarker) {
      this.stepLabel.setText(def.label)
      this.placeMarkerAndLabel()
    }
    if (def.showGhost && this.ghost) this.ghost.play()
    this.log(`step ${this.step} (${def.name})`)
  }

  // ── Marker and label placement ─────────────────────────────────────────────
  private placeMarkerAndLabel(): void {
    const def = STEPS[this.step]
    const wheelTr = this.wheel.getTransform()
    const wheelMat = wheelTr.getWorldTransform()
    const center = wheelTr.getWorldPosition()
    let angleDeg = def.markerAngleDeg
    let radius = this.beadRadiusCm * this.tire.getTransform().getLocalScale().x
    if (def.markerAnchor === "bead" && this.step === 2) {
      const nextBead = LOOSEN_BEADS.filter((i) => this.loosened.indexOf(i) < 0)[0]
      angleDeg = nextBead === undefined ? def.markerAngleDeg : nextBead * 45 + 22.5
    }
    let markerPos: vec3
    if (def.markerAnchor === "valve") {
      markerPos = this.valve.getTransform().getWorldPosition().add(new vec3(0, 0, this.markerStandoffCm))
      const local = this.valve.getTransform().getLocalPosition()
      radius = local.length
      angleDeg = 0
    } else if (def.markerAnchor === "socket") {
      angleDeg = SOCKET_ANGLE_DEG
      markerPos = wheelMat.multiplyPoint(this.radial(angleDeg, radius, this.markerStandoffCm + 2))
    } else {
      markerPos = wheelMat.multiplyPoint(this.radial(angleDeg, radius, this.markerStandoffCm + 2))
    }
    this.stepMarker.getTransform().setWorldPosition(markerPos)

    const dir = new vec3(Math.sin((angleDeg * Math.PI) / 180), Math.cos((angleDeg * Math.PI) / 180), 0)
    const labelPos = center.add(dir.uniformScale(radius + this.labelOffsetCm)).add(new vec3(0, 0, 4))
    this.stepLabel.sceneObject.getTransform().setWorldPosition(labelPos)
  }

  /** Deflate shrinks the tire AND the tube together so the tube stays inside the tire. */
  private setDeflated(on: boolean): void {
    const k = on ? this.deflateScale : 1
    if (this.tire) this.tire.getTransform().setLocalScale(new vec3(k, k, k))
    const tube = this.findChild(this.wheel, "Tube")
    if (tube) tube.getTransform().setLocalScale(new vec3(k, k, k))
  }

  private radial(angleDeg: number, radius: number, z: number): vec3 {
    const a = (angleDeg * Math.PI) / 180
    return new vec3(Math.sin(a) * radius, Math.cos(a) * radius, z)
  }

  private setBeadOffset(i: number, radialCm: number): void {
    const bead = this.findChild(this.tire, `Bead_${i}`)
    if (!bead) return
    const mid = ((i * 45 + 22.5) * Math.PI) / 180
    bead.getTransform().setLocalPosition(new vec3(Math.sin(mid) * radialCm, Math.cos(mid) * radialCm, 0))
  }

  private findChild(parent: SceneObject, name: string): SceneObject | null {
    const n = parent.getChildrenCount()
    for (let c = 0; c < n; c++) {
      const child = parent.getChild(c)
      if (child.name === name) return child
    }
    return null
  }

  private setEnabled(so: SceneObject | null, on: boolean): void {
    if (so && so.enabled !== on) so.enabled = on
  }

  private log(msg: string): void {
    if (this.debugLogs) print(`[RepairManager] ${msg}`)
  }
}
