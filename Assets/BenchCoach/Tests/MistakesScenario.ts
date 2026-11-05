import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {BenchCoachStepLabelUI} from "../Scripts/BenchCoachStepLabelUI"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {CoachFeedback} from "../Scripts/CoachFeedback"
import {RunStats} from "../Scripts/RunStats"
import {BenchCoachAudio} from "../Scripts/BenchCoachAudio"
import {MISTAKES, STEPS} from "../Scripts/StepDefinitions"

/**
 * Pass 8, mistake feedback: each mistake plays nope, puts its reason on the label
 * for 2.5 s (then the step label comes back) and leaves the step unchanged.
 * Covered: a bead before deflating, the valve again after deflating, lever B on
 * step 3, a lever dropped too far, the tube end before the peel, the new tube
 * end away from the valve hole, the valve before seating the bead. RunStats
 * counts the non-lever ones as mistakes; lever ones stay lever misses.
 */
@component
export class MistakesScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const fb = root.getComponent(CoachFeedback.getTypeName()) as CoachFeedback
    const stats = root.getComponent(RunStats.getTypeName()) as RunStats
    const audio = findSceneObjectByName("Audio").getComponent(BenchCoachAudio.getTypeName()) as BenchCoachAudio
    const label = findSceneObjectByName("LabelText").getComponent("Component.Text") as Text
    const callout = findSceneObjectByName("StepLabel").getComponent(BenchCoachStepLabelUI.getTypeName()) as BenchCoachStepLabelUI
    expect(fb, "CoachFeedback script").toBeTruthy()

    const check = (code: string, step: number, countBefore: number, nopeBefore: number) => {
      print(`[MistakesScenario] ${code}: "${label.text}" (step ${manager.getState().step})`)
      expect(fb.mistakeCount, `${code} counted`).toBe(countBefore + 1)
      expect(fb.lastCode, `${code} is the last code`).toBe(code)
      expect(label.text, `${code} reason on the label`).toBe(MISTAKES[code])
      expect(callout.mode, `${code}: callout in its amber mistake state`).toBe("mistake")
      expect(audio.nopePlays, `${code} plays nope`).toBe(nopeBefore + 1)
      expect(manager.getState().step, `${code} leaves step ${step}`).toBe(step)
    }

    // ── Step 1: a bead before deflating ────────────────────────────────────
    manager.reset()
    await sleep(300)
    await interactor.tap("BtnFoundIt")
    let c = fb.mistakeCount
    let n = audio.nopePlays
    await interactor.tap("Bead_3")
    check("beadBeforeDeflate", 1, c, n)
    expect(stats.mistakes, "RunStats counts it").toBe(1)
    await sleep(2800)
    expect(fb.showing, "reason gone after 2.5 s").toBe(false)
    expect(label.text, "step 1 label back").toBe(STEPS[1].label)
    expect(callout.mode, "callout back to normal").toBe("normal")

    // ── Step 2: the valve again ────────────────────────────────────────────
    await interactor.tap("Valve")
    expect(manager.getState().step, "valve deflates: step 2").toBe(2)
    c = fb.mistakeCount
    n = audio.nopePlays
    await interactor.tap("Valve")
    check("valveAlreadyDeflated", 2, c, n)
    expect(stats.mistakes, "two mistakes").toBe(2)
    // Next replaces the reason with the next step's label.
    manager.next()
    await sleep(200)
    expect(fb.showing, "Next clears the reason").toBe(false)
    expect(label.text, "step 3 label after Next").toBe(STEPS[3].label)

    // ── Step 3: lever B first, lever A too far ─────────────────────────────
    manager.jumpToStep(3)
    await sleep(900)
    const socketA = findSceneObjectByName("LeverSocket").getTransform().getWorldPosition()
    const socketB = findSceneObjectByName("LeverSocketB").getTransform().getWorldPosition()
    c = fb.mistakeCount
    n = audio.nopePlays
    const missesBefore = stats.leverMisses
    const leverB = findInteractablesByName("LeverB", undefined, true)[0]
    await interactor.dragTo(leverB, socketB.add(new vec3(1, 0, 0)), 1.0, 8000, 0.5)
    await sleep(300)
    check("leverBBeforeA", 3, c, n)
    await sleep(800)
    c = fb.mistakeCount
    n = audio.nopePlays
    const leverA = findInteractablesByName("LeverA", undefined, true)[0]
    await interactor.dragTo(leverA, socketA.add(new vec3(10, 0, 0)), 1.0, 8000, 0.5)
    await sleep(300)
    check("leverTooFar", 3, c, n)
    expect(stats.leverMisses, "two lever misses").toBe(missesBefore + 2)
    expect(stats.mistakes, "lever codes are not counted as mistakes").toBe(0)
    await sleep(800)

    // ── Step 4: the tube end before the peel ───────────────────────────────
    manager.jumpToStep(4)
    await sleep(900)
    const tubeEnd = findSceneObjectByName("TubeEnd")
    const endBefore = tubeEnd.getTransform().getWorldPosition()
    c = fb.mistakeCount
    n = audio.nopePlays
    await interactor.tap("TubeEnd")
    check("tubeBeforePeel", 4, c, n)
    expect(tubeEnd.getTransform().getWorldPosition().distance(endBefore), "tube end did not move").toBeLessThan(0.1)

    // ── Step 8: the new tube end away from the valve hole ──────────────────
    manager.jumpToStep(8)
    await sleep(600)
    const valveSocket = findSceneObjectByName("ValveSocket").getTransform().getWorldPosition()
    const handle = findInteractablesByName("NewTubeEnd", undefined, true)[0]
    c = fb.mistakeCount
    n = audio.nopePlays
    await interactor.dragTo(handle, valveSocket.add(new vec3(12, 0, 0)), 1.0, 8000, 0.5)
    await sleep(300)
    check("tubeFitMiss", 8, c, n)
    expect(stats.mistakes, "tube miss counted").toBe(1)
    await sleep(800)

    // ── Step 9: the valve before seating ───────────────────────────────────
    manager.jumpToStep(9)
    await sleep(500)
    c = fb.mistakeCount
    n = audio.nopePlays
    await interactor.tap("Valve")
    check("inflateBeforeSeat", 9, c, n)

    manager.reset()
    await sleep(300)
  }
}
