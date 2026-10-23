import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {LeverPlacement} from "../Scripts/LeverPlacement"

/**
 * Criterion 3: dropping lever A 10 cm from the ghost rejects it (back to the
 * tray); dropping it on the ghost snaps it, locks it, lifts Bead_0 and moves the
 * ghost on to the second socket (step 4).
 */
@component
export class LeverSnapScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    manager.reset()
    await sleep(300)

    const interactor = new BenchCoachLeafInteractor()
    await interactor.tap("BtnFoundIt")
    await interactor.tap("BtnNext")
    await interactor.tap("BtnNext")
    expect(manager.getState().step, "step 3 via Next").toBe(3)
    await sleep(900) // let the ghost animation finish

    const socket = findSceneObjectByName("LeverSocket")
    const ghost = findSceneObjectByName("GhostLever")
    const bead0 = findSceneObjectByName("Bead_0")
    expect(ghost.enabled, "ghost visible at step 3").toBe(true)

    const lever = findInteractablesByName("LeverA", undefined, true)[0]
    expect(lever, "LeverA interactable enabled").toBeTruthy()
    const leverObj = lever.getSceneObject()
    const placement = leverObj.getComponent(LeverPlacement.getTypeName()) as LeverPlacement
    expect(placement, "LeverPlacement on LeverA").toBeTruthy()
    const home = placement.getHomePosition()
    const socketPos = socket.getTransform().getWorldPosition()

    // Reject: release 10 cm to the right of the socket.
    const farGoal = socketPos.add(new vec3(10, 0, 0))
    await interactor.dragTo(lever, farGoal, 1.0, 8000, 0.5)
    await sleep(1000)
    const afterReject = leverObj.getTransform().getWorldPosition().distance(home)
    print(`[LeverSnapScenario] after reject: ${afterReject.toFixed(2)} cm from tray`)
    expect(placement.isLocked, "lever not locked after reject").toBe(false)
    expect(afterReject, "lever returned to the tray").toBeLessThan(1.0)
    expect(manager.getState().step, "still step 3 after reject").toBe(3)

    // Snap: release within 4 cm of the socket.
    const bead0Before = bead0.getTransform().getWorldPosition()
    await interactor.dragTo(lever, socketPos.add(new vec3(1.5, 0, 0)), 1.0, 8000, 0.5)
    await sleep(800)
    const toSocket = leverObj.getTransform().getWorldPosition().distance(socketPos)
    print(`[LeverSnapScenario] after snap: ${toSocket.toFixed(2)} cm from socket`)
    expect(toSocket, "lever sits on the socket").toBeLessThan(0.5)
    expect(placement.isLocked, "lever locked").toBe(true)
    const lift = bead0.getTransform().getWorldPosition().sub(bead0Before)
    print(`[LeverSnapScenario] Bead_0 lift (${lift.x.toFixed(2)}, ${lift.y.toFixed(2)}, ${lift.z.toFixed(2)})`)
    expect(lift.length, "Bead_0 lifted 1 cm radially").toBeCloseTo(1.0, 1)
    expect(lift.y, "Bead_0 y raised").toBeGreaterThan(0.8)
    // Step 4 re-shows the ghost at the second socket (5 cm along the rim), so it
    // must have left socket A rather than vanished.
    expect(ghost.enabled, "ghost re-shown for the second lever").toBe(true)
    const ghostFromSocketA = ghost.getTransform().getWorldPosition().distance(socketPos)
    print(`[LeverSnapScenario] ghost now ${ghostFromSocketA.toFixed(2)} cm from socket A`)
    expect(ghostFromSocketA, "ghost moved on to socket B").toBeGreaterThan(3.0)
    expect(manager.getState().step, "advanced to step 4").toBe(4)
  }
}
