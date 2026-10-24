import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {ScenarioConfig} from "Leaf.lspkg/Scenarios/scenario/ScenarioConfig"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {getRepairManager} from "./BenchCoachLeafInteractor"

/**
 * Helper, not a criterion: jumps the Lens to step `step` (parameter, default 5)
 * with the model state of every earlier step applied, and leaves it there — for
 * screenshots, demo recording and manual checks of a single step. Prints where
 * the levers, marker and edge arrow ended up. On step 5, parameter `pullCm` > 0
 * holds the tube end that far past the rim (segment-by-segment pull, mid-way).
 */
@component
export class JumpToStepScenario extends Scenario {
  async run(config?: ScenarioConfig): Promise<void> {
    const step = config?.getNumber("step") ?? 5
    const pullCm = config?.getNumber("pullCm") ?? 0
    await sleep(500)
    const manager = getRepairManager()
    manager.jumpToStep(step)
    await sleep(1200)
    expect(manager.getState().step, `landed on step ${step}`).toBe(step)
    if (step === 5 && pullCm > 0) {
      // TubePull reads the tube end's position each frame while armed; place it straight down from the hub.
      const wheel = findSceneObjectByName("Wheel").getTransform().getWorldPosition()
      const tube = findSceneObjectByName("Tube")
      const rimCm = 33.4 * tube.getTransform().getWorldScale().x
      findSceneObjectByName("TubeEnd").getTransform().setWorldPosition(wheel.add(new vec3(0, -(rimCm + pullCm), 0)))
      await sleep(300)
    }
    for (const name of ["LeverA", "LeverB", "StepMarker", "TubeEnd", "EdgeArrow"]) {
      const so = findSceneObjectByName(name)
      if (!so) continue
      const p = so.getTransform().getWorldPosition()
      print(`[JumpToStep] ${name} enabled=${so.isEnabledInHierarchy} at (${p.x.toFixed(1)}, ${p.y.toFixed(1)}, ${p.z.toFixed(1)})`)
    }
  }
}
