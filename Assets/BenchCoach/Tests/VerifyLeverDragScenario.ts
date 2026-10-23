import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {sleep} from "Leaf.lspkg/Utils/common/Utils"
import {DefaultLeafInteractor} from "Leaf.lspkg/Interactors/interactor/DefaultLeafInteractor"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {GrabbableLever} from "../Scripts/GrabbableLever"

/**
 * Section 9 verification 4: LEAF drag moves a lever that uses Interactable + InteractableManipulation.
 */
@component
export class VerifyLeverDragScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)

    const lever = findInteractablesByName("LeverA", undefined, true)[0]
    expect(lever, "LeverA interactable found and enabled").toBeTruthy()

    const leverObj = lever.getSceneObject()
    const script = leverObj.getComponent(GrabbableLever.getTypeName()) as GrabbableLever
    expect(script, "GrabbableLever component exists").toBeTruthy()

    const transform = leverObj.getTransform()
    const before = transform.getWorldPosition()
    const grabsBefore = script.grabCount
    const releasesBefore = script.releaseCount

    const interactor = new DefaultLeafInteractor()
    await interactor.drag(lever, new vec3(10, 6, 0), 800)
    await sleep(400)

    const after = transform.getWorldPosition()
    const moved = after.distance(before)
    print(`[VerifyLeverDragScenario] LeverA moved ${moved.toFixed(2)} cm`)

    expect(moved, "lever moved at least 3 cm").toBeGreaterThan(3)
    expect(script.grabCount, "manipulation start fired").toBe(grabsBefore + 1)
    expect(script.releaseCount, "manipulation end fired").toBe(releasesBefore + 1)
  }
}
