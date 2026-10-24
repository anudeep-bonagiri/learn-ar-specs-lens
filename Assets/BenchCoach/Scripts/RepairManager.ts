/**
 * RepairManager — the step machine (steps 0..7) for the flat-fix procedure.
 * Owns: state {step, subStep, startTime}, which authored objects are visible per
 * step, the StepMarker / StepLabel placement, and every model change (tire
 * deflate, bead push, bead lift, bead peel, thorn reveal) plus its undo on Back /
 * reset, and which cue (click, nope, done) plays when. The tube pull animation is
 * owned by TubePull and the glint by ThornHotspot; this script arms and restores them.
 * Reads: StepDefinitions. Listens to: WheelTargets, LeverPlacement (A and B),
 * RimDrag, TubePull, ThornHotspot. Next and jumpToStep() apply a step's model state directly.
 * Also drives the Highlighter (valve on step 1, unloosened beads on step 2) and
 * keeps the Tube hidden until a bead lifts (lever A placed, or step 4 onward).
 * Must not: author UI — cards and labels are passive views driven via setters.
 * Size note: above 400 lines on purpose — the per-step complete / undo / apply
 * tables are one state machine and are easier to audit side by side than split.
 * Note: step-0 visibility is applied on the first Update so every authored
 * component (UIKit plates, buttons, levers) initializes while enabled.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {LAST_STEP, LOOSEN_BEADS, STEPS, SOCKET_B_ANGLE_DEG, THORN_FOUND_LABEL} from "./StepDefinitions"
import {WheelTargets} from "./WheelTargets"
import {LeverPlacement} from "./LeverPlacement"
import {GhostAnimator} from "./GhostAnimator"
import {RimDrag} from "./RimDrag"
import {TubePull} from "./TubePull"
import {ThornHotspot} from "./ThornHotspot"
import {BenchCoachAudio} from "./BenchCoachAudio"
import {BenchCoachStepLabelUI} from "./BenchCoachStepLabelUI"
import {BenchCoachDoneCardUI} from "./BenchCoachDoneCardUI"
import {StepTicks} from "./StepTicks"
import {Highlighter} from "./Highlighter"

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
  @allowUndefined
  @hint("Workshop dressing root (bench, pegboard, mat, props); shown with the wheel")
  environment: SceneObject

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
  @hint("LeverSocketB: snap target 5 cm along the rim from socket A")
  leverSocketB: SceneObject

  @input
  @hint("Lever B placement controller")
  leverB: LeverPlacement

  @input
  @hint("Rim drag controller on lever B")
  rimDrag: RimDrag

  @input
  @hint("Tube pull controller on TubeEnd")
  tubePull: TubePull

  @input
  @hint("TubeEnd (step 5 marker anchor)")
  tubeEnd: SceneObject

  @input
  @hint("ThornHotspot in the tire (step 6 search target)")
  thorn: ThornHotspot

  @input
  @hint("Cue player (zipper, click, nope, done)")
  audio: BenchCoachAudio

  @input
  @hint("Done card (step 7)")
  doneCard: BenchCoachDoneCardUI

  @input
  @hint("Dim ticks left on the parts of completed steps")
  @allowUndefined
  ticks: StepTicks

  @input
  @hint("Pulsing glow on the parts the current step wants touched")
  highlighter: Highlighter

  @input
  @hint("Tube group (TubeSeg_0..7 and TubeEnd): hidden until a bead lifts")
  tube: SceneObject
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
  @hint("Seconds the found thorn and its label stay up before the Done card")
  @widget(new SliderWidget(0, 6, 0.1))
  thornRevealSec: number = 2.5

  @input
  @hint("Print step transitions to the log")
  debugLogs: boolean = true
  @ui.group_end

  private step = 0
  private subStep = 0
  private startTime = 0
  private loosened: number[] = []
  private peeled: number[] = []
  private leverPlaced = false
  private leverBPlaced = false
  private thornFound = false
  /** Bumped whenever step 6 is undone, so a pending thorn-to-Done delay is dropped. */
  private thornGeneration = 0
  private initialized = false

  /** Times Replay did something on the current step (ghost, chime or glint flash). */
  replayCount: number = 0

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

  getPeeledBeads(): number[] {
    return this.peeled.slice()
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
      ["leverSocketB", this.leverSocketB],
      ["leverB", this.leverB],
      ["rimDrag", this.rimDrag],
      ["tubePull", this.tubePull],
      ["tubeEnd", this.tubeEnd],
      ["thorn", this.thorn],
      ["audio", this.audio],
      ["doneCard", this.doneCard],
      ["highlighter", this.highlighter],
      ["tube", this.tube],
    ]
    for (const [name, value] of refs) if (!value) missing.push(name)
    if (missing.length > 0) {
      print(`[RepairManager] ERROR: missing @input refs: ${missing.join(", ")}`)
      return
    }
    this.wheelTargets.onValvePinched.add(() => this.onValvePinched())
    this.wheelTargets.onBeadPinched.add((i) => this.onBeadPinched(i))
    this.leverA.onPlaced.add(() => this.onLeverPlaced())
    this.leverB.onPlaced.add(() => this.onLeverBPlaced())
    this.rimDrag.onSegmentPassed.add((i) => this.onSegmentPeeled(i))
    this.rimDrag.onPeelComplete.add(() => this.onPeelComplete())
    this.tubePull.onPullComplete.add(() => this.onTubePulled())
    this.thorn.onFound.add(() => this.onThornFound())
    this.leverA.onRejected.add(() => this.playNope(this.leverA))
    this.leverB.onRejected.add(() => this.playNope(this.leverB))
  }

  // ── Public actions (UIBindings + tests) ────────────────────────────────────
  foundIt(): void {
    if (this.step !== 0) return
    this.startTime = getTime()
    this.goTo(1)
  }

  /** Next applies the current step's model change (as if the user did it), then advances. */
  next(): void {
    if (this.step === 0) {
      this.foundIt()
      return
    }
    if (this.step >= LAST_STEP) return
    this.completeStep(this.step)
    this.goTo(this.step + 1)
  }

  /** Back drops any partial work on the current step, then undoes the previous one. */
  back(): void {
    if (this.step <= 0) return
    this.undoStep(this.step)
    this.undoStep(this.step - 1)
    this.goTo(this.step - 1)
  }

  /**
   * Replay re-shows how to do the current step: the ghost's hooking motion on
   * the lever steps, a bright glint flash on the inspect step, the done cue on
   * the Done card, and elsewhere a chime from the marker so the user can hear
   * where the work is.
   */
  replay(): void {
    const def = STEPS[this.step]
    if (def.showGhost && this.ghost && this.ghost.sceneObject.enabled) {
      this.ghost.play()
    } else if (def.markerAnchor === "inspect" && !this.thornFound) {
      this.thorn.flash()
    } else if (this.stepMarker.enabled) {
      this.audio.playChimeAt(this.stepMarker.getTransform().getWorldPosition())
    } else if (def.showDoneCard) {
      this.audio.playDoneAt(this.doneCard.sceneObject.getTransform().getWorldPosition())
    } else {
      return
    }
    this.replayCount += 1
  }

  reset(): void {
    for (let s = LAST_STEP; s >= 0; s--) this.undoStep(s)
    this.startTime = 0
    this.goTo(0)
  }

  /** Debug / test entry: reset, apply the model state of steps 0..n-1, enter step n. */
  jumpToStep(n: number): void {
    this.reset()
    const target = Math.max(0, Math.min(LAST_STEP, n))
    for (let s = 0; s < target; s++) this.completeStep(s)
    this.goTo(target)
  }

  // ── Completion handlers ────────────────────────────────────────────────────
  private onValvePinched(): void {
    if (this.step !== 1) return
    if (this.audio) this.audio.playHissAt(this.valve.getTransform().getWorldPosition())
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
      this.applyHighlight()
    }
  }

  private onLeverPlaced(): void {
    if (this.step !== 3) return
    this.playClick(this.leverA)
    this.applyLeverA()
    this.log("lever A placed: Bead_0 lifted")
    this.goTo(4)
  }

  private onLeverBPlaced(): void {
    if (this.step !== 4 || this.leverBPlaced) return
    this.leverBPlaced = true
    this.subStep = 1
    this.playClick(this.leverB)
    if (this.ghost) this.ghost.sceneObject.enabled = false
    this.rimDrag.arm(this.leverSocketB, SOCKET_B_ANGLE_DEG)
    this.log("lever B hooked: slide it round")
  }

  private onSegmentPeeled(i: number): void {
    if (this.step !== 4) return
    this.liftBead(i)
    if (this.peeled.indexOf(i) < 0) this.peeled.push(i)
    this.subStep = 1 + this.peeled.length
    if (this.audio && this.leverB) this.audio.playZipperAt(this.leverB.sceneObject.getTransform().getWorldPosition())
    this.log(`Bead_${i} peeled`)
  }

  private onPeelComplete(): void {
    if (this.step !== 4) return
    this.log("bead peeled to 5 o'clock")
    this.goTo(5)
  }

  private onTubePulled(): void {
    if (this.step !== 5) return
    this.log("tube out")
    this.goTo(6)
  }

  /** The thorn is found: show it with its label for a moment, then the Done card. */
  private onThornFound(): void {
    if (this.step !== 6 || this.thornFound) return
    this.thornFound = true
    this.subStep = 1
    this.playClick(this.thorn)
    this.stepLabel.setText(THORN_FOUND_LABEL)
    this.placeMarkerAndLabel()
    this.log("thorn found")
    const generation = this.thornGeneration
    const delay = this.createEvent("DelayedCallbackEvent")
    delay.bind(() => {
      if (this.step === 6 && this.thornFound && generation === this.thornGeneration) this.goTo(7)
    })
    delay.reset(this.thornRevealSec)
  }

  private playClick(source: BaseScriptComponent): void {
    if (this.audio) this.audio.playClickAt(source.sceneObject.getTransform().getWorldPosition())
  }

  private playNope(source: BaseScriptComponent): void {
    if (this.audio) this.audio.playNopeAt(source.sceneObject.getTransform().getWorldPosition())
  }

  // ── Model changes shared by user actions, Next and jumpToStep ─────────────
  private applyLeverA(): void {
    this.leverPlaced = true
    this.liftBead(0)
    if (this.ghost) this.ghost.sceneObject.enabled = false
  }

  /** Raise Bead_i 1 cm radially outward (on top of its loosen push, if any). */
  private liftBead(i: number): void {
    this.setBeadOffset(i, this.beadLiftCm - (this.loosened.indexOf(i) >= 0 ? this.beadPushCm : 0))
  }

  private lowerBead(i: number): void {
    this.setBeadOffset(i, this.loosened.indexOf(i) >= 0 ? -this.beadPushCm : 0)
  }

  /** Apply the model state that completing `step` produces, without the user action. */
  private completeStep(step: number): void {
    switch (step) {
      case 0:
        if (this.startTime === 0) this.startTime = getTime()
        break
      case 1:
        this.setDeflated(true)
        break
      case 2:
        for (const i of LOOSEN_BEADS) {
          if (this.loosened.indexOf(i) < 0) {
            this.setBeadOffset(i, -this.beadPushCm)
            this.loosened.push(i)
          }
        }
        break
      case 3:
        if (!this.leverPlaced) {
          if (this.leverA) this.leverA.placeInstant()
          this.applyLeverA()
        }
        break
      case 4:
        if (!this.leverBPlaced) {
          if (this.leverB) this.leverB.placeInstant()
          this.leverBPlaced = true
          if (this.ghost) this.ghost.sceneObject.enabled = false
        }
        if (this.rimDrag) {
          this.rimDrag.completeInstant(this.leverSocketB, SOCKET_B_ANGLE_DEG)
          for (const i of this.rimDrag.getPassedSegments()) {
            this.liftBead(i)
            if (this.peeled.indexOf(i) < 0) this.peeled.push(i)
          }
        }
        break
      case 5:
        if (this.tubePull) this.tubePull.completeInstant()
        break
      case 6:
        this.thornFound = true
        if (this.thorn) this.thorn.revealInstant()
        break
      default:
        break
    }
  }

  // ── Step transitions ───────────────────────────────────────────────────────
  private goTo(step: number): void {
    const from = this.step
    this.step = Math.max(0, Math.min(LAST_STEP, step))
    this.subStep = 0
    this.replayCount = 0
    this.applyStep()
    if (this.step === LAST_STEP && from !== LAST_STEP && this.audio && this.doneCard) {
      this.audio.playDoneAt(this.doneCard.sceneObject.getTransform().getWorldPosition())
    }
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
          this.lowerBead(0)
          this.leverPlaced = false
        }
        if (this.leverA) this.leverA.returnHome(true)
        break
      case 4:
        if (this.rimDrag) this.rimDrag.disarm()
        for (const i of this.peeled) this.lowerBead(i)
        this.peeled = []
        this.leverBPlaced = false
        if (this.leverB) this.leverB.returnHome(true)
        break
      case 5:
        if (this.tubePull) this.tubePull.restore()
        break
      case 6:
        this.thornFound = false
        this.thornGeneration += 1
        if (this.thorn) this.thorn.reset()
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
    if (this.environment) this.setEnabled(this.environment, def.showWheel)
    this.setEnabled(this.toolTray, def.showTray)
    if (this.ghost) this.setEnabled(this.ghost.sceneObject, def.showGhost)
    if (this.doneCard) this.setEnabled(this.doneCard.sceneObject, def.showDoneCard)
    if (def.showDoneCard && this.doneCard) this.doneCard.setElapsed(this.getState().elapsedSec)

    // Lever B only snaps during step 4 (before it is hooked); the tube end only pulls in step 5.
    if (this.leverB) this.leverB.snapEnabled = this.step === 4 && !this.leverBPlaced
    if (this.rimDrag && this.step !== 4) this.rimDrag.disarm()
    if (this.tubePull) {
      if (this.step === 5) this.tubePull.arm()
      else this.tubePull.disarm()
    }
    if (this.thorn) {
      if (this.step === 6 && !this.thornFound) this.thorn.arm()
      else this.thorn.disarm()
    }
    if (this.wheelTargets) this.wheelTargets.setActive(this.step === 1, this.step === 2)
    // The tube shows once a bead lifts; TubePull keeps its homes while the group is off.
    this.setEnabled(this.tube, this.step >= 4 || this.leverPlaced)
    this.applyHighlight()

    const showLabel = def.markerAnchor !== "none"
    if (this.stepLabel) this.setEnabled(this.stepLabel.sceneObject, showLabel)
    if (showLabel) {
      this.stepLabel.setText(def.markerAnchor === "inspect" && this.thornFound ? THORN_FOUND_LABEL : def.label)
      this.placeMarkerAndLabel()
    } else {
      this.setEnabled(this.stepMarker, false)
    }
    this.placeTicks()
    if (def.showGhost && this.ghost) {
      this.ghost.setSocket(def.ghostSocket === "B" ? this.leverSocketB : this.leverSocket)
      this.ghost.play()
    }
    this.log(`step ${this.step} (${def.name})`)
  }

  /** Step 1 lights the valve, step 2 the beads still to loosen; every other step none. */
  private applyHighlight(): void {
    if (!this.highlighter) return
    if (this.step === 1) {
      this.highlighter.set([this.valve])
    } else if (this.step === 2) {
      const parts: SceneObject[] = []
      for (const i of LOOSEN_BEADS) {
        if (this.loosened.indexOf(i) >= 0) continue
        const bead = this.findChild(this.tire, `Bead_${i}`)
        if (bead) parts.push(bead)
      }
      this.highlighter.set(parts)
    } else {
      this.highlighter.clear()
    }
  }

  // ── Marker and label placement ─────────────────────────────────────────────
  /** Places the ring and its label; on the inspect step the ring only appears on a found thorn. */
  private placeMarkerAndLabel(): void {
    const def = STEPS[this.step]
    this.setEnabled(this.stepMarker, def.markerAnchor !== "inspect" || this.thornFound)
    const anchor = this.markerAnchorFor(this.step, true)
    this.stepMarker.getTransform().setWorldPosition(anchor.pos)

    // Searching: the label sits above the wheel, not next to the answer.
    const angleDeg = def.markerAnchor === "inspect" && !this.thornFound ? 0 : anchor.angleDeg
    const dir = new vec3(Math.sin((angleDeg * Math.PI) / 180), Math.cos((angleDeg * Math.PI) / 180), 0)
    const labelPos = this.wheel
      .getTransform()
      .getWorldPosition()
      .add(dir.uniformScale(anchor.radius + this.labelOffsetCm))
      .add(new vec3(0, 0, 4))
    this.stepLabel.sceneObject.getTransform().setWorldPosition(labelPos)
  }

  /** A small dim tick on the part of every completed step that has one. */
  private placeTicks(): void {
    if (!this.ticks) return
    const positions: vec3[] = []
    for (let s = 1; s < this.step; s++) {
      if (STEPS[s].markerAnchor !== "none") positions.push(this.markerAnchorFor(s, false).pos)
    }
    this.ticks.setTicks(this.wheel.enabled ? positions : [])
  }

  /**
   * Where a step's ring goes, and the wheel angle / radius its label hangs off.
   * `live` follows the step's moving parts (the next lit bead, the pulled tube end);
   * a completed step's tick stays where the work was done.
   */
  private markerAnchorFor(step: number, live: boolean): {pos: vec3; angleDeg: number; radius: number} {
    const def = STEPS[step]
    const wheelMat = this.wheel.getTransform().getWorldTransform()
    let angleDeg = def.markerAngleDeg
    let radius = this.beadRadiusCm * this.tire.getTransform().getLocalScale().x
    if (def.markerAnchor === "valve") {
      // The valve lifts out with the tube in step 5; the deflate tick stays at the rim where the valve was.
      const valveLocal = this.valve.getTransform().getLocalPosition()
      const valveRadius = Math.sqrt(valveLocal.x * valveLocal.x + valveLocal.y * valveLocal.y)
      const pos = live
        ? this.valve.getTransform().getWorldPosition().add(new vec3(0, 0, this.markerStandoffCm))
        : wheelMat.multiplyPoint(new vec3(0, valveRadius, valveLocal.z + this.markerStandoffCm))
      return {pos, angleDeg: 0, radius: valveRadius}
    }
    if (def.markerAnchor === "tubeEnd" && this.tubeEnd && live) {
      const pos = this.tubeEnd.getTransform().getWorldPosition().add(new vec3(0, 0, this.markerStandoffCm))
      return {pos, angleDeg: 180, radius}
    }
    if (def.markerAnchor === "inspect" && this.thorn) {
      const pos = this.thorn.sceneObject.getTransform().getWorldPosition().add(new vec3(0, 0, this.markerStandoffCm))
      return {pos, angleDeg, radius}
    }
    if (!live && def.tickAngleDeg !== undefined) angleDeg = def.tickAngleDeg
    if (def.markerAnchor === "bead" && step === 2 && live) {
      const nextBead = LOOSEN_BEADS.filter((i) => this.loosened.indexOf(i) < 0)[0]
      if (nextBead !== undefined) angleDeg = nextBead * 45 + 22.5
    }
    return {pos: wheelMat.multiplyPoint(this.radial(angleDeg, radius, this.markerStandoffCm + 2)), angleDeg, radius}
  }

  /** Deflate shrinks the tire AND the tube together so the tube stays inside the tire. */
  private setDeflated(on: boolean): void {
    const k = on ? this.deflateScale : 1
    if (this.tire) this.tire.getTransform().setLocalScale(new vec3(k, k, k))
    const tube = this.tube ? this.tube : this.findChild(this.wheel, "Tube")
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
