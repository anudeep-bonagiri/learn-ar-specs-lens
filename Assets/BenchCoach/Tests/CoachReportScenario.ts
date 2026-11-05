import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {ScenarioConfig} from "Leaf.lspkg/Scenarios/scenario/ScenarioConfig"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {LeverPlacement} from "../Scripts/LeverPlacement"
import {PRACTICE_CLEAN, RunStats} from "../Scripts/RunStats"
import {LAST_STEP, MISTAKE_TIPS, STEPS} from "../Scripts/StepDefinitions"

/**
 * Pass 11 (feature D): the coach report on the Finish card. A real run with one
 * bead-before-deflate pinch and two lever A drops 10 cm from the ghost (LEAF dragTo,
 * as lever-snap does), so the most frequent mistake is leverTooFar; lever A then
 * snaps for real, a Back + Next adds the second visit to step 3's time, and Next
 * runs the rest to the Finish card. The practice line is
 * MISTAKE_TIPS.leverTooFar, the time row lists three steps with m:ss, step 3 (the
 * lever drops) is the slowest, and jumpToStep records nothing. Then the two
 * fallbacks: no mistakes gives the slowest-step line, nothing at all the clean line.
 * Parameter `stay` = 1 stops after the Finish card checks and leaves the card up (screenshots).
 */
@component
export class CoachReportScenario extends Scenario {
  async run(config?: ScenarioConfig): Promise<void> {
    const stay = config?.getNumber("stay") ?? 0
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const stats = root.getComponent(RunStats.getTypeName()) as RunStats
    expect(stats, "RunStats on BenchCoach").toBeTruthy()

    manager.reset()
    await sleep(400)
    expect(stats.slowestStep(), "no times after reset").toBe(-1)

    // ── Steps 1 and 2 with one mistake ──────────────────────────────────────
    await interactor.tap("BtnFoundIt")
    await interactor.tap("Bead_3") // beadBeforeDeflate
    await sleep(800)
    await interactor.tap("Valve")
    expect(manager.getState().step, "valve: step 2").toBe(2)
    await sleep(600)
    await interactor.tap("BtnNext")
    expect(manager.getState().step, "step 3").toBe(3)
    await sleep(900)

    // ── Two lever misses, then the snap ─────────────────────────────────────
    const socketPos = findSceneObjectByName("LeverSocket").getTransform().getWorldPosition()
    const lever = findInteractablesByName("LeverA", undefined, true)[0]
    expect(lever, "LeverA interactable").toBeTruthy()
    const placement = lever.getSceneObject().getComponent(LeverPlacement.getTypeName()) as LeverPlacement
    for (let i = 0; i < 2; i++) {
      await interactor.dragTo(lever, socketPos.add(new vec3(10, 0, 0)), 1.0, 8000, 0.5)
      await sleep(1000)
    }
    print(`[CoachReportScenario] after two drops: counts ${JSON.stringify(stats.mistakeCounts)}, lever misses ${stats.leverMisses}`)
    expect(stats.mistakeCounts["leverTooFar"], "two leverTooFar from real drops").toBe(2)
    expect(stats.mistakeCounts["beadBeforeDeflate"], "one beadBeforeDeflate").toBe(1)
    expect(stats.topMistake(), "most frequent: leverTooFar").toBe("leverTooFar")
    await interactor.dragTo(lever, socketPos.add(new vec3(1.5, 0, 0)), 1.0, 8000, 0.5)
    await sleep(800)
    expect(placement.isLocked, "lever A snapped").toBe(true)
    expect(manager.getState().step, "step 4 after the snap").toBe(4)

    // ── A Back mid-run records nothing new ──────────────────────────────────
    const s3 = stats.stepSeconds(3)
    await interactor.tap("BtnBack")
    await interactor.tap("BtnNext")
    expect(manager.getState().step, "back on step 4").toBe(4)
    print(`[CoachReportScenario] step 3 ${s3.toFixed(2)} s before Back, ${stats.stepSeconds(3).toFixed(2)} s after Back + Next`)
    expect(s3 > 3, "step 3 took the lever drops (> 3 s)").toBe(true)
    expect(stats.stepSeconds(3) >= s3, "the second visit adds to step 3, never replaces it").toBe(true)

    // ── Next through to the Finish card ─────────────────────────────────────
    while (manager.getState().step < LAST_STEP) {
      await sleep(300)
      await interactor.tap(manager.getState().step === 7 ? "BtnContinue" : "BtnNext")
    }
    await sleep(500)
    expect(manager.getState().step, "on the Finish card").toBe(LAST_STEP)
    const times = this.text("FinishTimes")
    const practice = this.text("FinishPractice")
    print(`[CoachReportScenario] FinishTimes "${times}"`)
    print(`[CoachReportScenario] FinishPractice "${practice}"`)
    for (let s = 1; s < LAST_STEP; s++) print(`[CoachReportScenario]   step ${s} ${STEPS[s].name}: ${stats.stepSeconds(s).toFixed(2)} s`)
    expect(practice, "practice line is the leverTooFar tip").toBe(MISTAKE_TIPS["leverTooFar"])
    expect(stats.practiceTip(), "practiceTip() matches").toBe(MISTAKE_TIPS["leverTooFar"])
    // Pass D2: the card is a two-column list; "Slowest" is the row's label, the steps its value.
    expect(this.text("FinishTimesLabel"), "time row label").toBe("Slowest")
    const entries = times.split(" · ")
    expect(entries.length, "three entries in the time row").toBe(3)
    for (const e of entries) expect(/\d+:\d\d$/.test(e), `"${e}" ends in m:ss`).toBe(true)
    expect(stats.slowestStep(), "step 3 is the slowest").toBe(3)
    for (let s = 1; s < LAST_STEP; s++) expect(stats.stepSeconds(s) >= 0, `step ${s} timed`).toBe(true)
    expect(this.text("FinishCauseLabel"), "cause row label").toBe("Cause")
    expect(this.text("FinishCause").length > 0, "cause row has the cause").toBe(true)
    expect(this.text("FinishLeverMisses"), "lever misses row (2 lever misses)").toBe("2")
    expect(this.text("FinishTip").indexOf("Next time:") === 0, "tip line kept").toBe(true)
    if (stay > 0) return

    // ── No mistakes: the slowest step ───────────────────────────────────────
    manager.reset()
    await sleep(300)
    expect(stats.slowestStep(), "reset clears the times").toBe(-1)
    expect(stats.practiceTip(), "nothing recorded: clean line").toBe(PRACTICE_CLEAN)
    await interactor.tap("BtnFoundIt")
    await sleep(1500)
    await interactor.tap("BtnNext")
    await interactor.tap("BtnNext")
    const tip = stats.practiceTip()
    print(`[CoachReportScenario] no-mistake tip "${tip}"`)
    expect(stats.slowestStep(), "deflate is the slowest").toBe(1)
    expect(tip.indexOf(`Practice next: ${STEPS[1].name}, your slowest step at 0:0`) === 0, "slowest-step line").toBe(true)

    // ── jumpToStep records nothing ──────────────────────────────────────────
    manager.jumpToStep(LAST_STEP)
    await sleep(300)
    expect(stats.slowestStep(), "jumpToStep records no times").toBe(-1)
    expect(this.text("FinishPractice"), "clean line after a jump").toBe(PRACTICE_CLEAN)
    expect(this.text("FinishTimes"), "no timed steps after a jump").toBe("no timed steps")

    manager.reset()
    await sleep(300)
  }

  private text(name: string): string {
    const so = findSceneObjectByName(name)
    if (!so) throw new Error(`${name} not found`)
    const t = so.getComponent("Component.Text") as Text
    return t ? t.text : ""
  }
}
