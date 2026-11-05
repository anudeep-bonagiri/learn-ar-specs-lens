import {FloorLevel} from "./FloorLevel"
import {WorkspaceAnchor} from "./WorkspaceAnchor"

/**
 * FloorAnchor keeps this object's world y at the measured floor plus an offset
 * (x, z and rotation are left as authored). Used on the floor mat, whose top face
 * sits just above the floor; any later floor-standing prop can reuse it.
 * Expects: @input floorLevel. Must not: move the object in x or z.
 */
@component
export class FloorAnchor extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">FloorAnchor – stands this object on the measured floor</span>')
  @input
  @hint("Measured floor height (single source of truth)")
  floorLevel: FloorLevel

  @input
  @hint("Height of this object's origin above the floor, in cm")
  heightAboveFloorCm: number = 0

  onAwake(): void {
    if (!this.floorLevel) {
      print(`[FloorAnchor] ERROR: floorLevel not wired on ${this.sceneObject.name}`)
      return
    }
    // OnStart: FloorLevel may sit lower in the hierarchy and not be awake yet.
    this.createEvent("OnStartEvent").bind(() => {
      this.apply()
      this.floorLevel.onFloorChanged.add(() => this.apply())
      WorkspaceAnchor.onMoved(() => this.apply())
    })
  }

  apply(): void {
    const tr = this.sceneObject.getTransform()
    const p = tr.getWorldPosition()
    tr.setWorldPosition(new vec3(p.x, this.floorLevel.currentFloorY() + this.heightAboveFloorCm, p.z))
  }
}
