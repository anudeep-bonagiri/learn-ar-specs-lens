import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {InteractableManipulation} from "SpectaclesInteractionKit.lspkg/Components/Interaction/InteractableManipulation/InteractableManipulation"

/**
 * Section 9 verification 4: a tire lever the user can grab, move and release.
 * Adds a box collider, an Interactable and an InteractableManipulation at runtime
 * and counts grabs and releases so tests can read them.
 */
@component
export class GrabbableLever extends BaseScriptComponent {
  @input
  @hint("Box collider size in cm, in this object's local space")
  colliderSize: vec3 = new vec3(12, 2, 1)

  grabCount: number = 0
  releaseCount: number = 0

  onAwake(): void {
    let collider = this.sceneObject.getComponent("Physics.ColliderComponent") as ColliderComponent | null
    if (!collider) {
      collider = this.sceneObject.createComponent("Physics.ColliderComponent") as ColliderComponent
      const shape = Shape.createBoxShape()
      shape.size = this.colliderSize
      collider.shape = shape
    }

    this.sceneObject.createComponent(Interactable.getTypeName()) as Interactable
    const manipulation = this.sceneObject.createComponent(
      InteractableManipulation.getTypeName()
    ) as InteractableManipulation

    this.createEvent("OnStartEvent").bind(() => {
      manipulation.onManipulationStart.add(() => {
        this.grabCount += 1
        print(`[GrabbableLever] ${this.sceneObject.name} grabbed, count=${this.grabCount}`)
      })
      manipulation.onManipulationEnd.add(() => {
        this.releaseCount += 1
        const p = this.sceneObject.getTransform().getWorldPosition()
        print(
          `[GrabbableLever] ${this.sceneObject.name} released at (${p.x.toFixed(1)}, ${p.y.toFixed(1)}, ${p.z.toFixed(1)}), count=${this.releaseCount}`
        )
      })
    })
  }
}
