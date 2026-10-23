import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {DefaultLeafInteractor} from "Leaf.lspkg/Interactors/interactor/DefaultLeafInteractor"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {VerifyButtonUI} from "../Scripts/VerifyButtonUI"

/**
 * Section 9 verification 3: trigger one UIKit button and confirm its press counter moves.
 */
@component
export class VerifyButtonScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)

    const uiObj = findSceneObjectByName("VerifyButton")
    expect(uiObj, "VerifyButton scene object exists").toBeTruthy()
    const ui = uiObj.getComponent(VerifyButtonUI.getTypeName()) as VerifyButtonUI
    expect(ui, "VerifyButtonUI component exists").toBeTruthy()

    const before = ui.pressCount
    const button = findInteractablesByName("BtnVerify", undefined, true)[0]
    expect(button, "BtnVerify interactable found and enabled").toBeTruthy()

    const interactor = new DefaultLeafInteractor()
    await interactor.trigger(button)
    await sleep(300)

    expect(ui.pressCount, "press count increments by one").toBe(before + 1)
  }
}
