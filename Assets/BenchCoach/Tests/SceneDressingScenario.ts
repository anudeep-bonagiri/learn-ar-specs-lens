import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {Highlighter} from "../Scripts/Highlighter"
import {BenchCoachAudio} from "../Scripts/BenchCoachAudio"
import {RearTriangle} from "../Scripts/RearTriangle"

/**
 * Pass 7 scene dressing (code half, 7a): the Tube is hidden until a bead lifts
 * (off on step 2, on from step 4); the valve pinch on step 1 plays the hiss; the
 * Highlighter glows the valve on step 1 and exactly the not-yet-loosened beads on
 * step 2, and nothing once the step moves on.
 * Scene half (7b): Environment and Stand/BikeFrame are hidden on step 0 and shown
 * after Found it; the rear triangle's dropouts sit on the hub (within 1 cm).
 */
@component
export class SceneDressingScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const tube = findSceneObjectByName("Tube")
    expect(tube, "Tube exists").toBeTruthy()
    const highlighter = findSceneObjectByName("BenchCoach").getComponent(Highlighter.getTypeName()) as Highlighter
    expect(highlighter, "Highlighter on BenchCoach").toBeTruthy()
    const audio = findSceneObjectByName("Audio").getComponent(BenchCoachAudio.getTypeName()) as BenchCoachAudio
    expect(audio, "BenchCoachAudio on Audio").toBeTruthy()

    // ── Tube hidden until a bead lifts ──────────────────────────────────────
    manager.jumpToStep(2)
    await sleep(300)
    expect(tube.enabled, "Tube hidden on step 2").toBe(false)
    manager.jumpToStep(4)
    await sleep(300)
    expect(tube.enabled, "Tube shown on step 4").toBe(true)
    manager.jumpToStep(3)
    await sleep(300)
    expect(tube.enabled, "Tube hidden again on step 3 before lever A hooks").toBe(false)

    // ── Step 1: the valve glows, its pinch hisses ───────────────────────────
    manager.jumpToStep(1)
    await sleep(300)
    print(`[SceneDressingScenario] step 1 highlight: ${JSON.stringify(highlighter.current)}`)
    expect(JSON.stringify(highlighter.current), "valve highlighted on step 1").toBe(JSON.stringify(["Valve"]))
    const hissBefore = audio.hissPlays
    await interactor.tap("Valve")
    await sleep(200)
    expect(manager.getState().step, "valve pinch deflates (step 2)").toBe(2)
    expect(audio.hissPlays, "hiss played once on the valve pinch").toBe(hissBefore + 1)

    // ── Step 2: the beads still to loosen glow ──────────────────────────────
    const sorted = (a: string[]): string => JSON.stringify(a.slice().sort())
    print(`[SceneDressingScenario] step 2 highlight: ${JSON.stringify(highlighter.current)}`)
    expect(sorted(highlighter.current), "four loosen beads highlighted on step 2").toBe(
      sorted(["Bead_0", "Bead_2", "Bead_4", "Bead_6"])
    )
    await interactor.tap("Bead_2")
    await sleep(200)
    print(`[SceneDressingScenario] after Bead_2: ${JSON.stringify(highlighter.current)}`)
    expect(sorted(highlighter.current), "three remaining beads highlighted after Bead_2").toBe(
      sorted(["Bead_0", "Bead_4", "Bead_6"])
    )

    // ── Later steps: nothing glows ──────────────────────────────────────────
    manager.jumpToStep(3)
    await sleep(300)
    expect(highlighter.current.length, "no highlight on step 3").toBe(0)

    // ── Pass 7b: workshop environment and bike frame ───────────────────────
    const environment = findSceneObjectByName("Environment")
    const bikeFrame = findSceneObjectByName("BikeFrame")
    const hub = findSceneObjectByName("Hub")
    expect(environment, "Environment exists").toBeTruthy()
    expect(bikeFrame, "BikeFrame exists").toBeTruthy()
    expect(hub, "Hub exists").toBeTruthy()
    manager.reset()
    await sleep(300)
    expect(manager.getState().step, "reset returns to step 0").toBe(0)
    expect(environment.isEnabledInHierarchy, "Environment hidden on step 0").toBe(false)
    expect(bikeFrame.isEnabledInHierarchy, "BikeFrame hidden on step 0").toBe(false)
    await interactor.tap("BtnFoundIt")
    await sleep(300)
    expect(manager.getState().step, "Found it enters step 1").toBe(1)
    expect(environment.isEnabledInHierarchy, "Environment shown after Found it").toBe(true)
    expect(bikeFrame.isEnabledInHierarchy, "BikeFrame shown after Found it").toBe(true)
    const frame = bikeFrame.getComponent(RearTriangle.getTypeName()) as RearTriangle
    expect(frame, "RearTriangle on BikeFrame").toBeTruthy()
    const dropoutToHub = frame.dropoutWorldPos().distance(hub.getTransform().getWorldPosition())
    print(`[SceneDressingScenario] dropout to hub ${dropoutToHub.toFixed(2)} cm`)
    expect(dropoutToHub, "rear dropouts within 1 cm of the hub").toBeLessThan(1.0)

    manager.reset()
    await sleep(300)
    expect(highlighter.current.length, "no highlight after reset").toBe(0)
  }
}
