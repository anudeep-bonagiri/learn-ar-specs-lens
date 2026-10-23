import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, countEnabledByName, getRepairManager} from "./BenchCoachLeafInteractor"

/**
 * Criterion 2: steps 1 and 2 complete by pinching the valve and the four lit
 * bead segments, and only the current step's marker is visible.
 */
@component
export class DeflateLoosenScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    manager.reset()
    await sleep(300)

    const interactor = new BenchCoachLeafInteractor()
    await interactor.tap("BtnFoundIt")
    expect(manager.getState().step, "step 1 after Found it").toBe(1)

    const tire = findSceneObjectByName("Tire")
    const scaleBefore = tire.getTransform().getLocalScale().x
    await interactor.tap("Valve")
    await sleep(200)
    expect(manager.getState().step, "step 2 after pinching the valve").toBe(2)
    const scaleAfter = tire.getTransform().getLocalScale().x
    expect(scaleAfter, "tire shrank about 4%").toBeCloseTo(scaleBefore * 0.96, 2)
    expect(countEnabledByName("StepMarker"), "one marker at step 2").toBe(1)

    const marker = findSceneObjectByName("StepMarker")
    const wheel = findSceneObjectByName("Wheel")
    const wheelMat = wheel.getTransform().getWorldTransform()
    const beadMid = (i: number): vec3 => {
      const a = ((i * 45 + 22.5) * Math.PI) / 180
      return wheelMat.multiplyPoint(new vec3(Math.sin(a) * 33.4, Math.cos(a) * 33.4, 0))
    }
    const bead2 = findSceneObjectByName("Bead_2")
    const bead2Before = bead2.getTransform().getLocalPosition()

    // Any order: 2, 6, 0, 4
    for (const i of [2, 6, 0, 4]) {
      const beadObj = findSceneObjectByName(`Bead_${i}`)
      await interactor.tap(`Bead_${i}`)
      await sleep(150)
      expect(countEnabledByName("StepMarker"), `exactly one marker after bead ${i}`).toBe(1)
      expect(manager.getLoosenedBeads().indexOf(i) >= 0, `bead ${i} recorded as loosened`).toBe(true)
      if (manager.getState().step === 2) {
        const markerPos = marker.getTransform().getWorldPosition()
        for (const done of manager.getLoosenedBeads()) {
          expect(markerPos.distance(beadMid(done)), `marker is not on loosened bead ${done}`).toBeGreaterThan(5)
        }
        const unlit = [0, 2, 4, 6].filter((b) => manager.getLoosenedBeads().indexOf(b) < 0)
        const nearest = Math.min(...unlit.map((b) => markerPos.distance(beadMid(b))))
        expect(nearest, `marker sits on an unlit bead after bead ${i}`).toBeLessThan(6)
      }
      print(`[DeflateLoosenScenario] bead ${i} pinched, step=${manager.getState().step}, ${beadObj.name}`)
    }

    const bead2After = bead2.getTransform().getLocalPosition()
    const shift = bead2After.distance(bead2Before)
    expect(shift, "Bead_2 shifted 0.5 cm").toBeCloseTo(0.5, 1)
    const a2 = ((2 * 45 + 22.5) * Math.PI) / 180
    const radial2 = new vec3(Math.sin(a2), Math.cos(a2), 0)
    const offset2 = bead2After.sub(bead2Before)
    expect(offset2.dot(radial2), "Bead_2 offset points toward the rim center (inward)").toBeLessThan(-0.4)
    expect(manager.getState().step, "step 3 after all four beads").toBe(3)
    expect(countEnabledByName("StepMarker"), "one marker at step 3").toBe(1)
    expect(findSceneObjectByName("ToolTray").enabled, "tool tray shown at step 3").toBe(true)
  }
}
