/**
 * PartInfo — "What's this?" mode. setActive(true) pauses every step interaction
 * (RepairManager.setInteractionsPaused) and turns on one pinch box per
 * StepDefinitions.PART_FACTS entry (InfoHit_<id>, under BenchCoach/InfoHits, each
 * following its part every frame and a little larger than any collider it encloses,
 * so it takes the ray first). The prompt shows on the info callout in the slot
 * under the step callout; a pinch shows the part's name and fact on the info callout
 * beside the part, with a leader line. The step callout is never rewritten.
 * setActive(false) hides the boxes and the info callout and gives the step back. A reset (Start over,
 * jumpToStep) turns the mode off.
 * Never switches while a lever, the new tube end or the tube end is held or
 * tweening: the request waits until they are free (an Interactable turned off
 * under a held pinch strands that pinch).
 * Owns: the InfoHit boxes, active / lastPart. Emits onActiveChanged(on).
 * Must not: change steps.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {FLAT_CAUSES, PART_FACTS, PartFact} from "./StepDefinitions"
import {RepairManager} from "./RepairManager"
import {BenchCoachStepLabelUI} from "./BenchCoachStepLabelUI"
import {BenchCoachInfoCalloutUI} from "./BenchCoachInfoCalloutUI"
import {ThornHotspot} from "./ThornHotspot"
import {LeverPlacement} from "./LeverPlacement"
import {TubeFit} from "./TubeFit"
import {TubePull} from "./TubePull"
import {BenchCoachAudio} from "./BenchCoachAudio"

interface InfoHit {
  fact: PartFact
  so: SceneObject
  target: SceneObject | null
}

@component
export class PartInfo extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">PartInfo – What\'s this? part facts</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine (pause, label restore, current cause)")
  manager: RepairManager

  @input
  @hint("Step callout: the prompt hangs in the slot under it")
  stepLabel: BenchCoachStepLabelUI

  @input
  @hint("Info callout (the prompt, then the part's name and fact)")
  infoCallout: BenchCoachInfoCalloutUI

  @input
  @hint("Wheel root: parts are found by name under it, the stand and the tray")
  wheel: SceneObject

  @input
  @hint("Stand root (StandPost)")
  stand: SceneObject

  @input
  @hint("Tool tray root (levers while they are in the tray)")
  toolTray: SceneObject

  @input
  @hint("Flat-cause hotspot: its box exists only once the cause is found")
  thorn: ThornHotspot

  @input
  @hint("Lever A: wait while it is grabbed or tweening")
  leverA: LeverPlacement

  @input
  @hint("Lever B: wait while it is grabbed or tweening")
  leverB: LeverPlacement

  @input
  @hint("New tube end: wait while it is held")
  tubeFit: TubeFit

  @input
  @hint("Tube end: wait while it is held")
  tubePull: TubePull

  @input
  @hint("Cue player (click on a part)")
  audio: BenchCoachAudio
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Prompt title while the mode is on and no part is picked")
  promptText: string = "What's this?"

  @input
  @hint("Prompt line under the title")
  promptLine: string = "Pinch any part to learn what it is."

  @input
  @hint("Gap between the step callout and the prompt hanging under it, in cm")
  @widget(new SliderWidget(0, 4, 0.1))
  stackGapCm: number = 0.6
  @ui.group_end

  /** What's this? mode is on (boxes live, step paused). */
  active: boolean = false
  /** Requested state (differs from `active` while waiting for a held part). */
  wanted: boolean = false
  /** id of the last part pinched ("" = none since the mode turned on). */
  lastPart: string = ""
  /** Text the last pinch put on the label. */
  lastText: string = ""
  pinchCount: number = 0

  private _onActiveChanged = new Event<boolean>()
  onActiveChanged: PublicApi<boolean> = this._onActiveChanged.publicApi()

  private root: SceneObject | null = null
  private hits: InfoHit[] = []
  private picked: InfoHit | null = null

  onAwake(): void {
    this.root = global.scene.createSceneObject("InfoHits")
    this.root.setParent(this.sceneObject)
    for (const fact of PART_FACTS) {
      const so = global.scene.createSceneObject(`InfoHit_${fact.id}`)
      so.setParent(this.root)
      const collider = so.createComponent("Physics.ColliderComponent") as ColliderComponent
      const shape = Shape.createBoxShape()
      shape.size = new vec3(fact.size[0], fact.size[1], fact.size[2])
      collider.shape = shape
      const interactable = so.createComponent(Interactable.getTypeName()) as Interactable
      const hit: InfoHit = {fact, so, target: null}
      interactable.onTriggerEnd.add(() => this.pinched(hit))
      this.hits.push(hit)
    }
    this.root.enabled = false
    this.createEvent("OnStartEvent").bind(() => {
      if (this.manager) {
        this.manager.onReset.add(() => this.setActive(false))
        this.manager.onStepChanged.add(() => {
          this.picked = null
          if (this.active) this.showPrompt()
        })
      }
    })
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Turn What's this? on or off (applied as soon as nothing is held). */
  setActive(on: boolean): void {
    this.wanted = on
    this.tryApply()
  }

  /** Something the user holds (or a tween) would be stranded by a switch now. */
  isBusy(): boolean {
    if (this.leverA && this.leverA.isBusy()) return true
    if (this.leverB && this.leverB.isBusy()) return true
    if (this.tubeFit && this.tubeFit.isBusy()) return true
    if (this.tubePull && this.tubePull.isHeld()) return true
    return false
  }

  private tryApply(): void {
    if (this.wanted === this.active || this.isBusy()) return
    this.active = this.wanted
    this.picked = null
    if (this.active) {
      this.lastPart = ""
      this.lastText = ""
      this.placeHits()
    }
    if (this.root) this.root.enabled = this.active
    if (this.manager) this.manager.setInteractionsPaused(this.active)
    if (this.active) this.showPrompt()
    else {
      if (this.infoCallout) this.infoCallout.hide()
      if (this.stepLabel) this.stepLabel.setStack(0)
    }
    print(`[PartInfo] What's this? ${this.active ? "on" : "off"}`)
    this._onActiveChanged.invoke(this.active)
  }

  private showPrompt(): void {
    if (!this.infoCallout || !this.stepLabel) return
    if (this.stepLabel.sceneObject.isEnabledInHierarchy) this.stepLabel.setStack(this.infoCallout.panelHeight + this.stackGapCm)
    this.infoCallout.showPrompt(this.promptText, this.promptLine, this.promptAt())
  }

  /** Center of the prompt: in the slot under the step callout (above the wheel on the cards). */
  private promptAt(): vec3 {
    if (!this.stepLabel.sceneObject.isEnabledInHierarchy && this.wheel) {
      return this.wheel.getTransform().getWorldPosition().add(new vec3(0, 44, 6))
    }
    return this.stepLabel.stackTop(this.stackGapCm).add(new vec3(0, (-this.infoCallout.panelHeight / 2) * this.stepLabel.scale, 0))
  }

  private pinched(hit: InfoHit): void {
    if (!this.active) return
    const fact = this.factText(hit.fact)
    const text = `${hit.fact.title}: ${fact}`
    this.lastPart = hit.fact.id
    this.lastText = text
    this.pinchCount += 1
    this.picked = hit
    if (this.stepLabel) this.stepLabel.setStack(0)
    if (this.infoCallout) {
      this.infoCallout.sceneObject.getTransform().setLocalScale(vec3.one())
      // The parts around it stay visible too when a spot allows it: the valve and the
      // levers within 40 cm (the card used to cover them), any other part within 18 cm.
      const here = hit.so.getTransform().getWorldPosition()
      const near = this.hits
        .filter((h) => {
          if (h === hit || !h.so.enabled || h.fact.cause || h.fact.size[1] >= 40) return false
          const d = h.so.getTransform().getWorldPosition().distance(here)
          return d < 18 || (d < 40 && ["Valve", "LeverA", "LeverB"].indexOf(h.fact.id) >= 0)
        })
        .map((h) => h.so)
      this.infoCallout.showPart(hit.fact.title, capitalize(fact), hit.so, near)
    }
    if (this.audio) this.audio.playClickAt(hit.so.getTransform().getWorldPosition())
    print(`[PartInfo] ${text}`)
  }

  private factText(fact: PartFact): string {
    if (!fact.cause) return fact.fact
    const id = this.manager ? this.manager.getCause() : "thorn"
    const cause = FLAT_CAUSES[id] ? FLAT_CAUSES[id] : FLAT_CAUSES["thorn"]
    // The cause fact reads "Thorn: went through ..."; drop the repeated title.
    const k = cause.fact.indexOf(": ")
    return k >= 0 ? cause.fact.substring(k + 2) : cause.fact
  }

  private tick(): void {
    if (this.wanted !== this.active) this.tryApply()
    if (!this.active) return
    this.placeHits()
    if (!this.picked && this.infoCallout && this.stepLabel) {
      // The prompt owns the slot under the step callout while it shows.
      if (this.stepLabel.sceneObject.isEnabledInHierarchy) this.stepLabel.setStack(this.infoCallout.panelHeight + this.stackGapCm)
      this.infoCallout.moveTo(this.promptAt())
      const k = this.stepLabel.sceneObject.isEnabledInHierarchy ? this.stepLabel.scale : 1
      this.infoCallout.sceneObject.getTransform().setLocalScale(new vec3(k, k, k))
    }
  }

  /** Each box follows its part; boxes of hidden parts (and an unfound cause) are off. */
  private placeHits(): void {
    for (const hit of this.hits) {
      if (!hit.target || !hit.target.isEnabledInHierarchy) hit.target = this.findTarget(hit.fact.target)
      let on = !!hit.target && hit.target.isEnabledInHierarchy
      if (hit.fact.cause) on = on && !!this.thorn && this.thorn.found
      if (hit.so.enabled !== on) hit.so.enabled = on
      if (!on) continue
      const ttr = hit.target.getTransform()
      const tr = hit.so.getTransform()
      const rot = ttr.getWorldRotation()
      const o = hit.fact.offset
      tr.setWorldPosition(ttr.getWorldPosition().add(rot.multiplyVec3(new vec3(o[0], o[1], o[2]))))
      tr.setWorldRotation(rot)
    }
  }

  private findTarget(name: string): SceneObject | null {
    if (this.wheel && this.wheel.name === name) return this.wheel
    for (const root of [this.wheel, this.stand, this.toolTray]) {
      const found = root ? this.findIn(root, name) : null
      if (found) return found
    }
    return null
  }

  private findIn(parent: SceneObject, name: string): SceneObject | null {
    const n = parent.getChildrenCount()
    for (let i = 0; i < n; i++) {
      const c = parent.getChild(i)
      if (c.name === name) return c
      const deeper = this.findIn(c, name)
      if (deeper) return deeper
    }
    return null
  }
}

function capitalize(t: string): string {
  return t.length > 0 ? t.charAt(0).toUpperCase() + t.substring(1) : t
}
