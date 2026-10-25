import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {AskCoach} from "../Scripts/AskCoach"
import {PartInfo} from "../Scripts/PartInfo"
import {IdleHint} from "../Scripts/IdleHint"
import {BenchCoachControlBarUI} from "../Scripts/BenchCoachControlBarUI"
import {COACH_QUESTIONS} from "../Scripts/StepDefinitions"

/**
 * Pass 12, Ask the coach, offline path (never the network): with forceCanned set,
 * BtnAsk opens the chips with step 5's questions (toggle latched, IdleHint
 * suspended); the first chip puts step 5's canned answer on the answer panel next
 * to the step label within 2 s, tagged "offline"; What's this? and Ask exclude each
 * other; Next hides the answer and refreshes the chips for step 6; BtnAsk closes it.
 */
@component
export class AskCoachFallbackScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const ask = root.getComponent(AskCoach.getTypeName()) as AskCoach
    const info = root.getComponent(PartInfo.getTypeName()) as PartInfo
    const idle = root.getComponent(IdleHint.getTypeName()) as IdleHint
    const bar = findSceneObjectByName("ControlBar").getComponent(BenchCoachControlBarUI.getTypeName()) as BenchCoachControlBarUI
    const chipsPanel = findSceneObjectByName("AskChipsPanel")
    const answerPanel = findSceneObjectByName("AskAnswerPanel")
    const answerText = findSceneObjectByName("AskAnswerText").getComponent("Component.Text") as Text
    const tagText = findSceneObjectByName("AskSourceTag").getComponent("Component.Text") as Text
    const labelObj = findSceneObjectByName("StepLabel")
    expect(ask, "AskCoach on BenchCoach").toBeTruthy()

    ask.forceCanned = true
    manager.jumpToStep(5)
    await sleep(400)
    expect(ask.open, "Ask starts closed").toBe(false)
    expect(chipsPanel.enabled, "chips hidden at first").toBe(false)
    expect(answerPanel.enabled, "answer hidden at first").toBe(false)

    // ── Toggle on: chips with step 5's questions ───────────────────────────
    await interactor.tap("BtnAsk")
    await sleep(300)
    expect(ask.open, "Ask on").toBe(true)
    expect(bar.askOn, "Ask toggle latched").toBe(true)
    expect(chipsPanel.enabled, "chips shown").toBe(true)
    expect(idle.askSuspended, "IdleHint suspended while Ask is open").toBe(true)
    expect(findSceneObjectByName("AskChip_0").isEnabledInHierarchy, "first chip visible").toBe(true)
    const q = COACH_QUESTIONS[5]
    expect(ask.chips.questions.length, "three questions on step 5").toBe(q.length)
    expect(ask.chips.questions[0], "first chip is step 5's first question").toBe(q[0].q)

    // ── First chip: canned answer within 2 s ───────────────────────────────
    const t0 = getTime()
    await interactor.tap("AskChip_0")
    while (ask.lastSource !== "canned" && getTime() - t0 < 2) await sleep(50)
    const ms = Math.round((getTime() - t0) * 1000)
    print(`[AskCoachFallbackScenario] answer after ${ms} ms, source ${ask.lastSource} (${ask.lastFallbackReason}): "${answerText.text}"`)
    expect(ask.lastSource, "canned source").toBe("canned")
    expect(ms, "answer within 2 s").toBeLessThan(2000)
    expect(ask.lastAnswer, "canned answer").toBe(q[0].a)
    expect(answerText.text, "answer label shows the canned answer").toBe(q[0].a)
    expect(tagText.text, "source tag").toBe("offline")
    expect(answerPanel.enabled, "answer panel shown").toBe(true)
    const toLabel = answerPanel.getTransform().getWorldPosition().distance(labelObj.getTransform().getWorldPosition())
    print(`[AskCoachFallbackScenario] answer panel ${toLabel.toFixed(1)} cm from the step label`)
    expect(toLabel, "answer next to the step label (by the part)").toBeLessThan(10)
    expect(manager.getState().step, "still step 5").toBe(5)

    // ── What's this? and Ask exclude each other ────────────────────────────
    await interactor.tap("BtnWhatsThis")
    await sleep(300)
    expect(info.active, "What's this? on").toBe(true)
    expect(ask.open, "Ask closed by What's this?").toBe(false)
    expect(bar.askOn, "Ask toggle released").toBe(false)
    await interactor.tap("BtnAsk")
    await sleep(300)
    expect(ask.open, "Ask on again").toBe(true)
    expect(info.active, "What's this? closed by Ask").toBe(false)
    expect(bar.whatsThisOn, "What's this? toggle released").toBe(false)
    await interactor.tap("AskChip_0")
    await sleep(300)
    expect(answerPanel.enabled, "answer shown again").toBe(true)

    // ── Next: answer hidden, chips follow the step ─────────────────────────
    await interactor.tap("BtnNext")
    await sleep(300)
    expect(manager.getState().step, "step 6").toBe(6)
    expect(answerPanel.enabled, "answer hidden after the step change").toBe(false)
    expect(ask.lastAnswer, "answer cleared").toBe("")
    expect(ask.chips.questions[0], "chips show step 6's questions").toBe(COACH_QUESTIONS[6][0].q)

    // ── Toggle off ─────────────────────────────────────────────────────────
    await interactor.tap("BtnAsk")
    await sleep(300)
    expect(ask.open, "Ask off").toBe(false)
    expect(chipsPanel.enabled, "chips hidden").toBe(false)
    expect(bar.askOn, "Ask toggle released").toBe(false)
    expect(idle.askSuspended, "IdleHint back on").toBe(false)

    ask.forceCanned = false
    manager.reset()
    await sleep(300)
  }
}
