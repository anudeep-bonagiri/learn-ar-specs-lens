import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {Highlighter} from "../Scripts/Highlighter"
import {BenchCoachAudio} from "../Scripts/BenchCoachAudio"

/**
 * Pass 7 scene dressing (code half, 7a): the Tube is hidden until a bead lifts
 * (off on step 2, on from step 4); the valve pinch on step 1 plays the hiss; the
 * Highlighter glows the valve on step 1 and exactly the not-yet-loosened beads on
 * step 2, and nothing once the step moves on.
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

    // pass 7b: Environment and BikeFrame assertions go here

    manager.reset()
    await sleep(300)
    expect(highlighter.current.length, "no highlight after reset").toBe(0)
  }
}
