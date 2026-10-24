import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {StepTicks} from "../Scripts/StepTicks"
import {LAST_STEP} from "../Scripts/StepDefinitions"

/** Ticks expected on step n: completed steps 1..n-1, minus the halfway card (7). */
function expectedTicks(n: number): number {
  let count = 0
  for (let s = 1; s < n; s++) if (s !== 7) count++
  return count
}

function closestOf(positions: vec3[], label: (i: number) => number): {d: number; pair: string} {
  let d = Number.MAX_VALUE
  let pair = ""
  for (let i = 0; i < positions.length; i++) {
    for (let j = i + 1; j < positions.length; j++) {
      const dist = positions[i].distance(positions[j])
      if (dist < d) {
        d = dist
        pair = `${label(i)}/${label(j)}`
      }
    }
  }
  return {d, pair}
}

/**
 * Plan Section 4: completed steps leave a small dim tick on their part. On step n
 * there is one tick per completed step 1..n-1 that has an anchor (step 7, the
 * halfway card, has none), none with the wheel hidden on step 0: 6 on step 8 and 9
 * on step 11. On the halfway card the six ticks sit apart (no stacking), the
 * inspect tick is on the thorn and the deflate tick on the valve; on step 11 all
 * nine sit apart. Back drops the tick of the step it undoes, and reset clears them all.
 */
@component
export class TickMarksScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const ticksObj = findSceneObjectByName("StepTicks")
    expect(ticksObj, "StepTicks exists").toBeTruthy()
    const ticks = ticksObj.getComponent(StepTicks.getTypeName()) as StepTicks
    expect(ticks, "StepTicks script").toBeTruthy()

    // ── One tick per completed step ───────────────────────────────────────────
    for (let n = 0; n <= LAST_STEP; n++) {
      manager.jumpToStep(n)
      await sleep(300)
      const expected = expectedTicks(n)
      print(`[TickMarksScenario] step ${n}: ${ticks.visibleCount} ticks (expected ${expected})`)
      expect(ticks.visibleCount, `tick count on step ${n}`).toBe(expected)
    }

    // ── Step 11: nine ticks, none stacked ────────────────────────────────────
    expect(manager.getState().step, "on the Finish step").toBe(LAST_STEP)
    expect(ticks.visibleCount, "nine ticks on step 11").toBe(9)
    const all: vec3[] = []
    for (let i = 0; i < 9; i++) all.push(ticks.getTickPosition(i))
    const tickStep = (i: number): number => (i < 6 ? i + 1 : i + 2) // tick i belongs to step 1..6, 8..10
    const closestAll = closestOf(all, tickStep)
    print(`[TickMarksScenario] step 11 closest ticks: steps ${closestAll.pair}, ${closestAll.d.toFixed(2)} cm apart`)
    expect(closestAll.d, `no stacked ticks on step 11 (closest steps ${closestAll.pair})`).not.toBeLessThan(3.0)

    // ── On the halfway card the ticks sit apart, on their parts ──────────────
    manager.jumpToStep(7)
    await sleep(300)
    expect(manager.getState().step, "on the halfway step").toBe(7)
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
    print(`[TickMarksScenario] closest ticks: steps ${closestPair}, ${closest.toFixed(2)} cm apart`)
    expect(closest, `no stacked ticks (closest steps ${closestPair})`).not.toBeLessThan(3.0)

    const thornPos = findSceneObjectByName("ThornHotspot").getTransform().getWorldPosition()
    const toThorn = positions[5].distance(thornPos)
    print(`[TickMarksScenario] inspect tick ${toThorn.toFixed(2)} cm from the thorn`)
    expect(toThorn, "inspect tick on the thorn").toBeLessThan(3.0)

    const valvePos = findSceneObjectByName("Valve").getTransform().getWorldPosition()
    const toValve = positions[0].distance(valvePos)
    print(`[TickMarksScenario] deflate tick ${toValve.toFixed(2)} cm from the valve`)
    expect(toValve, "deflate tick on the valve").toBeLessThan(4.0)

    // ── Back drops the undone step's tick ───────────────────────────────────
    manager.jumpToStep(5)
    await sleep(300)
    await interactor.tap("BtnBack")
    await sleep(300)
    print(`[TickMarksScenario] Back from 5: step ${manager.getState().step}, ${ticks.visibleCount} ticks`)
    expect(manager.getState().step, "Back from 5 lands on 4").toBe(4)
    expect(ticks.visibleCount, "three ticks after Back from 5").toBe(3)

    // ── Reset clears them ────────────────────────────────────────────────────
    manager.reset()
    await sleep(300)
    print(`[TickMarksScenario] after reset: ${ticks.visibleCount} ticks`)
    expect(ticks.visibleCount, "no ticks after reset").toBe(0)
  }
}
