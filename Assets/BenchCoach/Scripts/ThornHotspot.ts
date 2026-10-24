/**
 * ThornHotspot — the inspect step's search target: a 1 cm glint in the tire that
 * twinkles only while armed (step 6). Pinching it reveals the flat cause and
 * fires onFound. setCause(id) moves the hotspot round the tire to the cause's
 * angle (FLAT_CAUSES: thorn 120, glass 240, snakebite 300 degrees) and picks the
 * reveal shape: a spike (thorn), a thin tilted shard (glass) or two dots side by
 * side (snakebite). The object keeps its name for LEAF and the tests.
 * Owns: the Glint, Thorn, Shard and Bite child meshes, a pinch collider sized for
 * the mouse, the Interactable on this SceneObject (LEAF finds "ThornHotspot" by name).
 * Must not: change steps or labels — RepairManager does.
 * Expects: this SceneObject authored under Tire at the thorn's pose (local +Y
 * points radially outward), @inputs glintMesh, glintMaterial, thornMesh, thornMaterial.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {FLAT_CAUSES} from "./StepDefinitions"

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

  @input
  @hint("Unit box mesh for the glass shard")
  shardMesh: RenderMesh

  @input
  @hint("Unlit material for the glass shard; a runtime copy is tinted with shardTint")
  shardMaterial: Material
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

  @input
  @hint("Radius of the hotspot from the wheel center, in cm (on the tire)")
  @widget(new SliderWidget(25, 40, 0.1))
  radiusCm: number = 34.2

  @input
  @hint("Depth of the hotspot in front of the tire center, in cm")
  @widget(new SliderWidget(0, 5, 0.1))
  depthCm: number = 2

  @input("vec4", "{0.85, 0.97, 1.0, 1.0}")
  @hint("Glass shard color (pale and bright: dark vanishes on the additive display)")
  @widget(new ColorWidget())
  shardTint: vec4 = new vec4(0.85, 0.97, 1.0, 1.0)

  @input("vec4", "{1.0, 0.8, 0.5, 1.0}")
  @hint("Snakebite dot color (bright warm; drawn with a tinted copy of shardMaterial)")
  @widget(new ColorWidget())
  biteTint: vec4 = new vec4(1.0, 0.8, 0.5, 1.0)

  @input
  @hint("Diameter of each snakebite dot, in cm")
  @widget(new SliderWidget(0.2, 2, 0.05))
  biteDotCm: number = 0.9

  @input
  @hint("Distance between the two snakebite dots, in cm")
  @widget(new SliderWidget(0.5, 4, 0.1))
  biteGapCm: number = 1.8
  @ui.group_end

  armed: boolean = false
  found: boolean = false
  flashCount: number = 0
  /** Current flat cause id (FLAT_CAUSES key). */
  causeId: string = "thorn"
  /** Clockwise angle from 12 o'clock of the hotspot, in degrees. */
  currentAngleDeg: number = 120

  private glint: SceneObject | null = null
  private thorn: SceneObject | null = null
  private shard: SceneObject | null = null
  private bite: SceneObject | null = null
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

    this.buildShard()
    this.buildBite()
    this.setCause(this.causeId)

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

  /**
   * Move the hotspot to the cause's angle on the tire (this object's local +Y
   * points radially out) and use the cause's reveal shape.
   */
  setCause(id: string): void {
    const cause = FLAT_CAUSES[id] ? FLAT_CAUSES[id] : FLAT_CAUSES["thorn"]
    this.causeId = FLAT_CAUSES[id] ? id : "thorn"
    this.currentAngleDeg = cause.angleDeg
    const a = (cause.angleDeg * Math.PI) / 180
    const tr = this.sceneObject.getTransform()
    tr.setLocalPosition(new vec3(Math.sin(a) * this.radiusCm, Math.cos(a) * this.radiusCm, this.depthCm))
    tr.setLocalRotation(quat.angleAxis(-a, new vec3(0, 0, 1)))
    this.applyVisibility()
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
    const shape = (FLAT_CAUSES[this.causeId] || FLAT_CAUSES["thorn"]).shape
    if (this.thorn) this.thorn.enabled = this.found && shape === "spike"
    if (this.shard) this.shard.enabled = this.found && shape === "shard"
    if (this.bite) this.bite.enabled = this.found && shape === "dots"
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

  /** Glass: a thin pale sliver standing out of the tread, tilted, with a smaller chip beside it. */
  private buildShard(): void {
    if (!this.shardMesh || !this.shardMaterial) {
      print("[ThornHotspot] ERROR: shard mesh / material not assigned")
      return
    }
    this.shard = global.scene.createSceneObject("Shard")
    this.shard.setParent(this.sceneObject)
    const mat = this.shardMaterial.clone()
    mat.mainPass.baseColor = this.shardTint
    this.addPiece(this.shard, this.shardMesh, mat, new vec3(0.15, 1.0, 0.3), 22, new vec3(1.5, 2.6, 0.2))
    this.addPiece(this.shard, this.shardMesh, mat, new vec3(-1.0, 0.5, 0.4), -30, new vec3(0.8, 1.2, 0.18))
  }

  /** Snakebite: two dots side by side along the tire (local X is the tangent). */
  private buildBite(): void {
    if (!this.glintMesh || !this.shardMaterial) return
    this.bite = global.scene.createSceneObject("Bite")
    this.bite.setParent(this.sceneObject)
    const mat = this.shardMaterial.clone()
    mat.mainPass.baseColor = this.biteTint
    const d = this.biteDotCm
    for (const side of [-1, 1]) {
      this.addPiece(this.bite, this.glintMesh, mat, new vec3((side * this.biteGapCm) / 2, 0.1, 0.6), 0, new vec3(d, d * 0.6, d))
    }
  }

  private addPiece(parent: SceneObject, mesh: RenderMesh, mat: Material, pos: vec3, rollDeg: number, scale: vec3): void {
    const so = global.scene.createSceneObject("Piece")
    so.setParent(parent)
    const tr = so.getTransform()
    tr.setLocalPosition(pos)
    tr.setLocalRotation(quat.angleAxis((rollDeg * Math.PI) / 180, new vec3(0, 0, 1)))
    tr.setLocalScale(scale)
    const rmv = so.createComponent("Component.RenderMeshVisual") as RenderMeshVisual
    rmv.mesh = mesh
    rmv.mainMaterial = mat
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
