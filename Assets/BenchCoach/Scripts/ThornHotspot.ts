/**
 * ThornHotspot — the inspect step's search target: a 1 cm glint in the tire at
 * 4 o'clock that twinkles only while armed (step 6). Pinching it reveals the
 * thorn (a short spike pointing out of the tire) and fires onFound.
 * Owns: the Glint and Thorn child meshes, a pinch collider sized for the mouse,
 * the Interactable on this SceneObject (LEAF finds "ThornHotspot" by name).
 * Must not: change steps or labels — RepairManager does.
 * Expects: this SceneObject authored under Tire at the thorn's pose (local +Y
 * points radially outward), @inputs glintMesh, glintMaterial, thornMesh, thornMaterial.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"

@component
export class ThornHotspot extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">ThornHotspot – inspect step glint and thorn</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Unit sphere mesh for the glint")
  glintMesh: RenderMesh

  @input
  @hint("Bright unlit material for the glint (no black on the additive display)")
  glintMaterial: Material

  @input
  @hint("Unit cylinder mesh for the thorn spike")
  thornMesh: RenderMesh

  @input
  @hint("Material for the revealed thorn")
  thornMaterial: Material
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Glint diameter in cm")
  @widget(new SliderWidget(0.3, 4, 0.1))
  glintSizeCm: number = 1

  @input
  @hint("Pinch hit box edge in cm (larger than the glint so the mouse can find it)")
  @widget(new SliderWidget(1, 10, 0.5))
  hitSizeCm: number = 5

  @input
  @hint("Twinkles per second while armed")
  @widget(new SliderWidget(0.2, 4, 0.1))
  twinkleHz: number = 0.7

  @input
  @hint("Thorn spike length and thickness in cm")
  thornSizeCm: vec2 = new vec2(1.8, 0.3)
  @ui.group_end

  armed: boolean = false
  found: boolean = false
  flashCount: number = 0

  private glint: SceneObject | null = null
  private thorn: SceneObject | null = null
  private collider: ColliderComponent | null = null
  private interactable: Interactable | null = null
  private flashTime = -1

  private _onFound = new Event<void>()
  onFound: PublicApi<void> = this._onFound.publicApi()

  onAwake(): void {
    this.glint = this.addPart("Glint", this.glintMesh, this.glintMaterial)
    this.thorn = this.addPart("Thorn", this.thornMesh, this.thornMaterial)
    if (this.thorn) {
      const tr = this.thorn.getTransform()
      tr.setLocalPosition(new vec3(0, this.thornSizeCm.x / 2 - 0.3, 0))
      tr.setLocalScale(new vec3(this.thornSizeCm.y, this.thornSizeCm.x, this.thornSizeCm.y))
    }

    // The hit box overlaps Bead_2's, so it only exists while the inspect step is armed.
    this.collider = this.sceneObject.createComponent("Physics.ColliderComponent") as ColliderComponent
    const shape = Shape.createBoxShape()
    shape.size = new vec3(this.hitSizeCm, this.hitSizeCm, this.hitSizeCm)
    this.collider.shape = shape
    this.interactable = this.sceneObject.createComponent(Interactable.getTypeName()) as Interactable
    this.interactable.onTriggerEnd.add(() => this.pinched())

    this.applyVisibility()
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** Step 6 entry: the glint starts twinkling and the pinch counts. */
  arm(): void {
    this.armed = true
    this.applyVisibility()
  }

  disarm(): void {
    this.armed = false
    this.applyVisibility()
  }

  /** Show the revealed thorn without the pinch (jumpToStep / Next). */
  revealInstant(): void {
    this.found = true
    this.armed = false
    this.applyVisibility()
  }

  /** Back / reset: hide the thorn again. */
  reset(): void {
    this.found = false
    this.armed = false
    this.applyVisibility()
  }

  /** Replay hint on the inspect step: one bright, slow twinkle. */
  flash(): void {
    if (!this.armed) return
    this.flashCount += 1
    this.flashTime = 0
  }

  private pinched(): void {
    if (!this.armed || this.found) return
    this.found = true
    this.armed = false
    this.applyVisibility()
    this._onFound.invoke()
  }

  private applyVisibility(): void {
    if (this.glint) this.glint.enabled = this.armed
    if (this.thorn) this.thorn.enabled = this.found
    if (this.collider) this.collider.enabled = this.armed
    if (this.interactable) this.interactable.enabled = this.armed
    this.flashTime = -1
  }

  private tick(): void {
    if (!this.glint || !this.armed) return
    // A sharp twinkle: mostly small, briefly bright, like light catching glass.
    const phase = (getTime() * this.twinkleHz) % 1
    let s = 0.6 + 0.8 * Math.pow(Math.max(0, Math.sin(phase * Math.PI * 2)), 6)
    if (this.flashTime >= 0) {
      this.flashTime += getDeltaTime()
      const f = this.flashTime / 0.8
      if (f >= 1) this.flashTime = -1
      else s = Math.max(s, 1 + 1.5 * Math.sin(f * Math.PI))
    }
    const d = this.glintSizeCm * s
    this.glint.getTransform().setLocalScale(new vec3(d, d, d))
  }

  private addPart(name: string, mesh: RenderMesh, material: Material): SceneObject | null {
    if (!mesh || !material) {
      print(`[ThornHotspot] ERROR: ${name} mesh / material not assigned`)
      return null
    }
    const so = global.scene.createSceneObject(name)
    so.setParent(this.sceneObject)
    const rmv = so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
    rmv.mesh = mesh
    rmv.mainMaterial = material
    return so
  }
}
