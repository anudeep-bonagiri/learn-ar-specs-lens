import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {ScenarioConfig} from "Leaf.lspkg/Scenarios/scenario/ScenarioConfig"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {LeverPlacement} from "../Scripts/LeverPlacement"
import {RunStats} from "../Scripts/RunStats"
import {VoiceCoach} from "../Scripts/VoiceCoach"
import {BenchCoachFinishCardUI} from "../Scripts/BenchCoachFinishCardUI"
import {LAST_STEP, MISTAKE_STEPS, STEPS} from "../Scripts/StepDefinitions"

/**
 * Criterion 22, pass S2 (Practise it now): the Finish card's Practise button drills the
 * step of the run's most frequent mistake three times and reports the reps and the best time.
 * Setup as coach-report: a real run with one bead before deflating and two lever A drops
 * 10 cm from the ghost (leverTooFar is the most frequent mistake, so step 3), then Next to
 * the Finish card. The button reads "Practise lever A"; a ray press puts lever A back in
 * the tray on step 3 with the kicker "Practise, rep 1 of 3". Lever A is snapped with the
 * simulated hand three times (one drop too far in rep 2, counted), reps 2 and 3 show their
 * kickers and say no step line. Then the Finish card is back, compact, with the run's own
 * counts and the line "Practised lever A: 3 reps, best 0:0x, 1 mistake"; the button reads
 * "Practise again". A press starts rep 1 again, and Next ends the drill with "0 of 3 reps".
 * Parameter `stay` (screenshots): 1 stops on the Finish card before the press, 2 on rep 1,
 * 3 on the Finish card with the practised line.
 */
@component
export class PractiseStepScenario extends Scenario {
  async run(config?: ScenarioConfig): Promise<void> {
    const stay = config?.getNumber("stay") ?? 0
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const stats = root.getComponent(RunStats.getTypeName()) as RunStats
    const voice = root.getComponent(VoiceCoach.getTypeName()) as VoiceCoach
    const card = findSceneObjectByName("FinishCard").getComponent(BenchCoachFinishCardUI.getTypeName()) as BenchCoachFinishCardUI
    const kicker = findSceneObjectByName("StepKicker").getComponent("Component.Text") as Text
    const label = findSceneObjectByName("LabelText").getComponent("Component.Text") as Text
    manager.reset()
    await sleep(300)

    // ── A run whose most frequent mistake is leverTooFar ─────────────────────
    await interactor.tap("BtnFoundIt")
    await interactor.tap("Bead_3") // beadBeforeDeflate
    await sleep(300)
    await interactor.tap("Valve")
    await interactor.tap("BtnNext")
    expect(manager.getState().step, "step 3").toBe(3)
    const socketPos = findSceneObjectByName("LeverSocket").getTransform().getWorldPosition()
    const lever = findInteractablesByName("LeverA", undefined, true)[0]
    expect(lever, "LeverA interactable").toBeTruthy()
    const placement = lever.getSceneObject().getComponent(LeverPlacement.getTypeName()) as LeverPlacement
    const home = placement.getHomePosition()
    const drop = async () => {
      await interactor.dragTo(lever, socketPos.add(new vec3(10, 0, 0)), 1.0, 8000, 0.5)
      await sleep(700)
    }
    const snap = async () => {
      await interactor.dragTo(lever, socketPos.add(new vec3(1.5, 0, 0)), 1.0, 8000, 0.5)
      await sleep(200)
    }
    await drop()
    await drop()
    expect(stats.topMistake(), "most frequent: leverTooFar").toBe("leverTooFar")
    expect(MISTAKE_STEPS["leverTooFar"], "leverTooFar belongs to step 3").toBe(3)
    await snap()
    expect(manager.getState().step, "step 4 after the snap").toBe(4)
    while (manager.getState().step < LAST_STEP) await interactor.tap(manager.getState().step === 7 ? "BtnContinue" : "BtnNext")
    await sleep(400)
    expect(manager.getState().step, "on the Finish card").toBe(LAST_STEP)
    const misses = card.textOf("FinishLeverMisses")
    const time = card.textOf("FinishTime")

    // ── The button names the mistake's step; a ray press starts rep 1 ────────
    expect(manager.practiseStep(), "practise step 3").toBe(3)
    expect(card.practiseText(), "the button names the step").toBe("Practise lever A")
    expect(findSceneObjectByName("BtnFinishPractise").isEnabledInHierarchy, "Practise button shows").toBe(true)
    if (stay === 1) return
    const tStart = getTime()
    await interactor.tap("BtnFinishPractise")
    await sleep(400)
    // Started or dropped by the repeat guard: either way the coach tried to say it.
    const step3Lines = () => voice.history.filter((h) => h.id === "step-03").length + voice.skipped.filter((s) => s === "step-03").length
    const checkRep = (rep: number) => {
      print(`[PractiseStepScenario] rep ${rep}: kicker "${kicker.text}", step ${manager.getState().step}, lever ${placement.sceneObject.getTransform().getWorldPosition().distance(home).toFixed(2)} cm from the tray`)
      expect(kicker.text, `rep ${rep} kicker`).toBe(`Practise, rep ${rep} of 3`)
      expect(manager.getState().step, `rep ${rep} on step 3`).toBe(3)
      expect(label.text, `rep ${rep}: the step's instruction`).toBe(STEPS[3].label)
      expect(placement.isLocked, `rep ${rep}: lever A not placed`).toBe(false)
      expect(placement.sceneObject.getTransform().getWorldPosition().distance(home), `rep ${rep}: lever A back in the tray`).toBeLessThan(1.0)
      expect(findSceneObjectByName("FinishCard").isEnabledInHierarchy, `rep ${rep}: the Finish card is away`).toBe(false)
    }
    checkRep(1)
    if (stay === 2) return

    // ── Three reps with the simulated hand ───────────────────────────────────
    let linesAtRep2 = 0
    for (let rep = 1; rep <= 3; rep++) {
      if (rep === 2) {
        linesAtRep2 = step3Lines()
        await drop() // a mistake in the drill: coached, counted
        expect(manager.drill ? manager.drill.mistakes : -1, "the drill counts the drop").toBe(1)
      }
      await snap()
      print(`[PractiseStepScenario] rep ${rep} done: kicker "${kicker.text}"`)
      expect(kicker.text.indexOf(`Rep ${rep} of 3 done in 0:0`) === 0, `rep ${rep}: done shows with its time`).toBe(true)
      await sleep(1000)
      if (rep < 3) checkRep(rep + 1)
    }
    await sleep(300)

    // ── Back on the Finish card with the practised line ──────────────────────
    expect(manager.getState().step, "back on the Finish card").toBe(LAST_STEP)
    expect(manager.drill, "the drill ended").toBe(null)
    const r = manager.lastDrill
    expect(r ? r.reps : 0, "3 reps").toBe(3)
    print(`[PractiseStepScenario] best rep ${r ? r.best.toFixed(2) : "?"} s; practised "${card.practisedLine}"`)
    expect(r !== null && r.best < 10, "best rep under 10 s").toBe(true)
    expect(card.expanded, "the card is compact").toBe(false)
    expect(findSceneObjectByName("FinishPractised").isEnabledInHierarchy, "the practised line shows").toBe(true)
    expect(/^Practised lever A: 3 reps, best 0:0\d, 1 mistake$/.test(card.practisedLine), "the practised line").toBe(true)
    expect(card.practiseText(), "the button reads Practise again").toBe("Practise again")
    expect(card.textOf("FinishLeverMisses"), "the run's lever misses are kept").toBe(misses)
    expect(card.textOf("FinishTime"), "the run's time is kept").toBe(time)
    expect(step3Lines(), "reps 2 and 3 say no step line").toBe(linesAtRep2)
    print(`[PractiseStepScenario] step-03 lines since the press: ${voice.history.filter((h) => h.id === "step-03" && h.t >= tStart).length}`)
    if (stay === 3) return

    // ── Practise again starts rep 1; Next ends it with the reps so far ───────
    await interactor.tap("BtnFinishPractise")
    await sleep(400)
    checkRep(1)
    await interactor.tap("BtnNext")
    await sleep(400)
    expect(manager.getState().step, "Next ends the drill on the Finish card").toBe(LAST_STEP)
    print(`[PractiseStepScenario] after Next: "${card.practisedLine}"`)
    expect(card.practisedLine, "the reps done so far").toBe("Practised lever A: 0 of 3 reps, no mistakes")
    manager.reset()
    await sleep(300)
  }
}
