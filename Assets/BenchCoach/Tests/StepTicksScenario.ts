import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {StepTicks} from "../Scripts/StepTicks"

/**
 * Plan Section 4: completed steps leave a small dim tick on their part. On step n
 * there is one tick per completed step 1..n-1 (all six have an anchor), none with
 * the wheel hidden on step 0. On Done the six ticks sit apart (no stacking), the
 * inspect tick is on the thorn and the deflate tick on the valve. Back drops the
 * tick of the step it undoes, and reset clears them all.
 */
@component
export class StepTicksScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const ticksObj = findSceneObjectByName("StepTicks")
    expect(ticksObj, "StepTicks exists").toBeTruthy()
    const ticks = ticksObj.getComponent(StepTicks.getTypeName()) as StepTicks
    expect(ticks, "StepTicks script").toBeTruthy()

    // ── One tick per completed step ───────────────────────────────────────────
    for (let n = 0; n <= 7; n++) {
      manager.jumpToStep(n)
      await sleep(300)
      const expected = Math.min(6, Math.max(0, n - 1))
      print(`[StepTicksScenario] step ${n}: ${ticks.visibleCount} ticks (expected ${expected})`)
      expect(ticks.visibleCount, `tick count on step ${n}`).toBe(expected)
    }

    // ── On Done the ticks sit apart, on their parts ──────────────────────────
    expect(manager.getState().step, "on the Done step").toBe(7)
    const positions: vec3[] = []
    for (let i = 0; i < 6; i++) positions.push(ticks.getTickPosition(i))
    let closest = Number.MAX_VALUE
    let closestPair = ""
    for (let i = 0; i < positions.length; i++) {
      for (let j = i + 1; j < positions.length; j++) {
        const d = positions[i].distance(positions[j])
        if (d < closest) {
          closest = d
          closestPair = `${i + 1}/${j + 1}`
        }
      }
    }
    print(`[StepTicksScenario] closest ticks: steps ${closestPair}, ${closest.toFixed(2)} cm apart`)
    expect(closest, `no stacked ticks (closest steps ${closestPair})`).not.toBeLessThan(3.0)

    const thornPos = findSceneObjectByName("ThornHotspot").getTransform().getWorldPosition()
    const toThorn = positions[5].distance(thornPos)
    print(`[StepTicksScenario] inspect tick ${toThorn.toFixed(2)} cm from the thorn`)
    expect(toThorn, "inspect tick on the thorn").toBeLessThan(3.0)

    const valvePos = findSceneObjectByName("Valve").getTransform().getWorldPosition()
    const toValve = positions[0].distance(valvePos)
    print(`[StepTicksScenario] deflate tick ${toValve.toFixed(2)} cm from the valve`)
    expect(toValve, "deflate tick on the valve").toBeLessThan(4.0)

    // ── Back drops the undone step's tick ───────────────────────────────────
    manager.jumpToStep(5)
    await sleep(300)
    await interactor.tap("BtnBack")
    await sleep(300)
    print(`[StepTicksScenario] Back from 5: step ${manager.getState().step}, ${ticks.visibleCount} ticks`)
    expect(manager.getState().step, "Back from 5 lands on 4").toBe(4)
    expect(ticks.visibleCount, "three ticks after Back from 5").toBe(3)

    // ── Reset clears them ────────────────────────────────────────────────────
    manager.reset()
    await sleep(300)
    print(`[StepTicksScenario] after reset: ${ticks.visibleCount} ticks`)
    expect(ticks.visibleCount, "no ticks after reset").toBe(0)
  }
}
