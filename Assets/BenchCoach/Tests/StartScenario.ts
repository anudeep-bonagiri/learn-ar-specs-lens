import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, countEnabledByName, getRepairManager} from "./BenchCoachLeafInteractor"

/**
 * Criterion 1: pinching Found it places the wheel in the stand and step 1's
 * marker sits on the valve.
 */
@component
export class StartScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    manager.reset()
    await sleep(300)

    const wheel = findSceneObjectByName("Wheel")
    const stand = findSceneObjectByName("Stand")
    const startCard = findSceneObjectByName("StartCard")
    const marker = findSceneObjectByName("StepMarker")
    const valve = findSceneObjectByName("Valve")
    expect(wheel, "Wheel exists").toBeTruthy()
    expect(stand, "Stand exists").toBeTruthy()
    expect(startCard, "StartCard exists").toBeTruthy()
    expect(marker, "StepMarker exists").toBeTruthy()
    expect(valve, "Valve exists").toBeTruthy()
    expect(findSceneObjectByName("StandInBadge"), "StandInBadge exists").toBeTruthy()

    expect(manager.getState().step, "starts at step 0").toBe(0)
    expect(wheel.enabled, "Wheel hidden before Found it").toBe(false)
    expect(stand.enabled, "Stand hidden before Found it").toBe(false)
    expect(startCard.enabled, "StartCard visible at step 0").toBe(true)
    expect(marker.enabled, "StepMarker hidden at step 0").toBe(false)

    const interactor = new BenchCoachLeafInteractor()
    await interactor.tap("BtnFoundIt")
    await sleep(300)

    const state = manager.getState()
    expect(state.step, "step is 1 after Found it").toBe(1)
    expect(state.startTime, "timer started").toBeGreaterThan(0)
    expect(wheel.enabled, "Wheel enabled").toBe(true)
    expect(stand.enabled, "Stand enabled").toBe(true)
    expect(startCard.enabled, "StartCard hidden").toBe(false)
    expect(marker.enabled, "StepMarker enabled").toBe(true)
    expect(countEnabledByName("StepMarker"), "exactly one StepMarker enabled").toBe(1)

    const wheelPos = wheel.getTransform().getWorldPosition()
    expect(wheelPos.z, "wheel is ahead of the user (negative z)").toBeLessThan(-60)
    const markerToValve = marker.getTransform().getWorldPosition().distance(valve.getTransform().getWorldPosition())
    print(`[StartScenario] marker to valve ${markerToValve.toFixed(2)} cm`)
    expect(markerToValve, "marker within 2 cm of the valve").toBeLessThan(2.0)
    expect(findSceneObjectByName("StepLabel").enabled, "StepLabel visible").toBe(true)
  }
}
