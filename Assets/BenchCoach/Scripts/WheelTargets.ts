/**
 * WheelTargets — makes the Valve and all eight beads pinchable. Adds a
 * child box collider (fitted to each bead's chord / the valve stem) and an SIK
 * Interactable on the named part itself, so LEAF and the mouse find "Valve" and
 * "Bead_i" by name.
 * Owns: colliders + Interactables. Emits onValvePinched / onBeadPinched(i), and
 * onValveDown / onValveUp for the pinch-and-hold inflate (step 10).
 * Must not: decide anything about steps — RepairManager / RefitSteps do, through setActive().
 * A valve target switched off while a hand still holds it stays on until the
 * release (turning an Interactable off under a held pinch strands the pinch).
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {LOOSEN_BEADS} from "./StepDefinitions"

const ALL_BEADS = [0, 1, 2, 3, 4, 5, 6, 7]

@component
export class WheelTargets extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">WheelTargets – pinch targets on valve and beads</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Tire group holding Bead_0..7")
  tire: SceneObject

  @input
  @hint("Valve stem object")
  valve: SceneObject
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Bead major radius in cm (matches the Bead_i TorusArc)")
  @widget(new SliderWidget(10, 60, 0.1))
  beadRadiusCm: number = 33.4

  @input
  @hint("Sweep of each bead segment in degrees")
  @widget(new SliderWidget(10, 90, 1))
  beadSweepDeg: number = 45

  @input
  @hint("Bead hit box thickness (radial and depth) in cm")
  @widget(new SliderWidget(2, 12, 0.5))
  beadHitThicknessCm: number = 6

  @input
  @hint("Valve hit box size in world cm")
  valveHitSizeCm: vec3 = new vec3(5, 7, 5)
  @ui.group_end

  private _onValvePinched = new Event<void>()
  private _onBeadPinched = new Event<number>()
  private _onValveDown = new Event<void>()
  private _onValveUp = new Event<void>()
  onValvePinched: PublicApi<void> = this._onValvePinched.publicApi()
  onBeadPinched: PublicApi<number> = this._onBeadPinched.publicApi()
  /** Valve pinch starts (hold-to-inflate). */
  onValveDown: PublicApi<void> = this._onValveDown.publicApi()
  /** Valve pinch ends or is cancelled. */
  onValveUp: PublicApi<void> = this._onValveUp.publicApi()

  /** True while a hand holds the valve. */
  valveHeld: boolean = false

  private valveTarget: Interactable | null = null
  private valveWanted = false
  private beadTargets: Interactable[] = []
  private beadIndices: number[] = []

  /**
   * Only the current step's parts take pinches. A live bead hit box elsewhere
   * swallows pinches meant for what is behind or inside it (the thorn sits in Bead_2's).
   * `beads`: true = the four loosen beads (step 2), false = none, or an explicit list.
   */
  setActive(valve: boolean, beads: boolean | number[]): void {
    this.valveWanted = valve
    this.applyValve()
    const list = beads === true ? LOOSEN_BEADS : beads === false ? [] : beads
    for (let k = 0; k < this.beadTargets.length; k++) {
      this.beadTargets[k].enabled = list.indexOf(this.beadIndices[k]) >= 0
    }
  }

  private applyValve(): void {
    if (!this.valveTarget) return
    if (!this.valveWanted && this.valveHeld) return
    this.valveTarget.enabled = this.valveWanted
  }

  private valveReleased(): void {
    if (!this.valveHeld) return
    this.valveHeld = false
    this._onValveUp.invoke()
    this.applyValve()
  }

  onAwake(): void {
    if (!this.tire || !this.valve) {
      print("[WheelTargets] ERROR: tire / valve not assigned")
      return
    }
    // Valve: the Valve object is scaled (0.8, 4, 0.8); size the child box in local units.
    const vs = this.valve.getTransform().getLocalScale()
    this.addHit(
      this.valve,
      "ValveHit",
      vec3.zero(),
      quat.quatIdentity(),
      new vec3(this.valveHitSizeCm.x / vs.x, this.valveHitSizeCm.y / vs.y, this.valveHitSizeCm.z / vs.z)
    )
    const valveInteractable = this.valve.createComponent(Interactable.getTypeName()) as Interactable
    valveInteractable.onTriggerStart.add(() => {
      this.valveHeld = true
      this._onValveDown.invoke()
    })
    valveInteractable.onTriggerEnd.add(() => {
      this._onValvePinched.invoke()
      this.valveReleased()
    })
    valveInteractable.onTriggerCanceled.add(() => this.valveReleased())
    // A pinch that drifts off the valve before letting go ends outside: still a release.
    valveInteractable.onTriggerEndOutside.add(() => this.valveReleased())
    this.valveTarget = valveInteractable

    const chord = 2 * this.beadRadiusCm * Math.sin((this.beadSweepDeg * Math.PI) / 360)
    for (const i of ALL_BEADS) {
      const bead = this.findChild(this.tire, `Bead_${i}`)
      if (!bead) {
        print(`[WheelTargets] ERROR: Bead_${i} not found under ${this.tire.name}`)
        continue
      }
      const mid = ((i * this.beadSweepDeg + this.beadSweepDeg / 2) * Math.PI) / 180
      const center = new vec3(Math.sin(mid) * this.beadRadiusCm, Math.cos(mid) * this.beadRadiusCm, 0)
      // local +X along the tangent at the mid angle
      const rot = quat.angleAxis(-mid, new vec3(0, 0, 1))
      this.addHit(bead, `Bead_${i}_Hit`, center, rot, new vec3(chord, this.beadHitThicknessCm, this.beadHitThicknessCm))
      const interactable = bead.createComponent(Interactable.getTypeName()) as Interactable
      const index = i
      interactable.onTriggerEnd.add(() => this._onBeadPinched.invoke(index))
      interactable.enabled = false
      this.beadTargets.push(interactable)
      this.beadIndices.push(index)
    }
  }

  private addHit(parent: SceneObject, name: string, localPos: vec3, localRot: quat, size: vec3): void {
    const hit = global.scene.createSceneObject(name)
    hit.setParent(parent)
    const tr = hit.getTransform()
    tr.setLocalPosition(localPos)
    tr.setLocalRotation(localRot)
    const collider = hit.createComponent("Physics.ColliderComponent") as ColliderComponent
    const shape = Shape.createBoxShape()
    shape.size = size
    collider.shape = shape
  }

  private findChild(parent: SceneObject, name: string): SceneObject | null {
    const n = parent.getChildrenCount()
    for (let c = 0; c < n; c++) {
      const child = parent.getChild(c)
      if (child.name === name) return child
    }
    return null
  }
}
