import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {ScenarioConfig} from "Leaf.lspkg/Scenarios/scenario/ScenarioConfig"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {getRepairManager} from "./BenchCoachLeafInteractor"
import {RefitSteps} from "../Scripts/RefitSteps"

/**
 * Helper, not a criterion: jumps the Lens to step `step` (parameter, default 5)
 * with the model state of every earlier step applied, and leaves it there — for
 * screenshots, demo recording and manual checks of a single step. Prints where
 * the levers, marker and edge arrow ended up. On step 5, parameter `pullCm` > 0
 * holds the tube end that far past the rim (segment-by-segment pull, mid-way).
 * On step 8, `fit` = 1 runs the live fit (new tube back in the tire) but stays on
 * step 8; on step 10, `inflate` (0..1) holds the tire part-inflated.
 */
@component
export class JumpToStepScenario extends Scenario {
  async run(config?: ScenarioConfig): Promise<void> {
    const step = config?.getNumber("step") ?? 5
    const pullCm = config?.getNumber("pullCm") ?? 0
    const fit = config?.getNumber("fit") ?? 0
    const inflate = config?.getNumber("inflate") ?? 0
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
    const refit = findSceneObjectByName("BenchCoach").getComponent(RefitSteps.getTypeName()) as RefitSteps
    if (step === 8 && fit > 0 && refit) {
      refit.advanceOnFit = false
      refit.fitNow()
      await sleep(2500)
      refit.advanceOnFit = true
    }
    if (step === 10 && inflate > 0 && refit) {
      refit.setInflateProgress(inflate)
      await sleep(200)
    }
    for (const name of ["LeverA", "LeverB", "StepMarker", "TubeEnd", "EdgeArrow", "NewTubeEnd"]) {
      const so = findSceneObjectByName(name)
      if (!so) continue
      const p = so.getTransform().getWorldPosition()
      print(`[JumpToStep] ${name} enabled=${so.isEnabledInHierarchy} at (${p.x.toFixed(1)}, ${p.y.toFixed(1)}, ${p.z.toFixed(1)})`)
    }
    // Screen position (0..1, top-left origin) of the step's touch target, for injected mouse checks.
    const cam = findSceneObjectByName("Camera Object")
    const camera = cam ? (cam.getComponent("Component.Camera") as Camera) : null
    for (const name of ["Valve", "BtnFoundIt", "NewTubeEnd", "ValveSocket"]) {
      const so = findSceneObjectByName(name)
      if (!camera || !so || !so.isEnabledInHierarchy) continue
      const sp = camera.worldSpaceToScreenSpace(so.getTransform().getWorldPosition())
      print(`[JumpToStep] ${name} on screen at (${sp.x.toFixed(3)}, ${sp.y.toFixed(3)})`)
    }
  }
}
