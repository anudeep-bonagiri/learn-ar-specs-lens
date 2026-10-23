import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {ScenarioConfig} from "Leaf.lspkg/Scenarios/scenario/ScenarioConfig"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {getRepairManager} from "./BenchCoachLeafInteractor"

/**
 * Helper, not a criterion: jumps the Lens to step `step` (parameter, default 5)
 * with the model state of every earlier step applied, and leaves it there — for
 * screenshots, demo recording and manual checks of a single step. Prints where
 * the levers, marker and edge arrow ended up.
 */
@component
export class JumpToStepScenario extends Scenario {
  async run(config?: ScenarioConfig): Promise<void> {
    const step = config?.getNumber("step") ?? 5
    await sleep(500)
    const manager = getRepairManager()
    manager.jumpToStep(step)
    await sleep(1200)
    expect(manager.getState().step, `landed on step ${step}`).toBe(step)
    for (const name of ["LeverA", "LeverB", "StepMarker", "TubeEnd", "EdgeArrow"]) {
      const so = findSceneObjectByName(name)
      if (!so) continue
      const p = so.getTransform().getWorldPosition()
      print(`[JumpToStep] ${name} enabled=${so.isEnabledInHierarchy} at (${p.x.toFixed(1)}, ${p.y.toFixed(1)}, ${p.z.toFixed(1)})`)
    }
  }
}
