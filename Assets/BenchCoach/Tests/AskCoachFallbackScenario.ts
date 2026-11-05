import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {AskCoach} from "../Scripts/AskCoach"
import {PartInfo} from "../Scripts/PartInfo"
import {IdleHint} from "../Scripts/IdleHint"
import {BenchCoachControlBarUI} from "../Scripts/BenchCoachControlBarUI"
import {BenchCoachStepLabelUI} from "../Scripts/BenchCoachStepLabelUI"
import {COACH_QUESTIONS} from "../Scripts/StepDefinitions"

/**
 * Pass 12, Ask the coach, offline path (never the network): with forceCanned set,
 * BtnAsk opens the chips with step 5's questions (toggle latched, IdleHint
 * suspended); the first chip puts step 5's canned answer on the answer panel next
 * to the step label within 2 s, tagged "offline"; What's this? and Ask exclude each
 * other; BtnAsk closes it. Pass G2 on D2 (pass M): Next closes Ask; the answer hides
 * after answerSec (the chips come back) and at the next sub-step; the chips close Ask
 * after chipsIdleSec with no chip press (both timers shortened for the test).
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
    const callout = labelObj.getComponent(BenchCoachStepLabelUI.getTypeName()) as BenchCoachStepLabelUI
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
    expect(tagText.text, "source tag").toBe("Offline answer")
    expect(answerPanel.enabled, "answer panel shown").toBe(true)
    // Pass D2: the answer takes the chips' slot under the step callout.
    expect(chipsPanel.enabled, "chips give way to the answer").toBe(false)
    const lp = labelObj.getTransform().getWorldPosition()
    const ap = answerPanel.getTransform().getWorldPosition()
    print(`[AskCoachFallbackScenario] answer panel ${ap.distance(lp).toFixed(1)} cm from the step callout, ${(lp.y - ap.y).toFixed(1)} cm below it`)
    expect(ap.distance(lp), "answer hangs from the step callout").toBeLessThan(14)
    expect(lp.y - ap.y > 0, "answer under the callout").toBe(true)
    expect(callout.zone === "top" || callout.zone === "bottom", "with Ask open the callout sits above or below the tire, off the wheel").toBe(true)
    expect(manager.getState().step, "still step 5").toBe(5)

    // ── Answer close: the chips come back; chips close: Ask closes ─────────
    await interactor.tap("BtnAnswerClose")
    await sleep(300)
    expect(answerPanel.enabled, "answer closed").toBe(false)
    expect(chipsPanel.enabled, "chips back after closing the answer").toBe(true)
    expect(ask.open, "Ask still open").toBe(true)
    await interactor.tap("BtnAskClose")
    await sleep(300)
    expect(ask.open, "chips close button closes Ask").toBe(false)
    expect(bar.askOn, "Ask toggle released by the close button").toBe(false)
    await interactor.tap("BtnAsk")
    await sleep(300)
    await interactor.tap("AskChip_0")
    await sleep(300)
    expect(answerPanel.enabled, "answer shown after reopening").toBe(true)

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

    // ── Next: Ask closes on a step change (pass G2 / M) ────────────────────
    await interactor.tap("BtnNext")
    await sleep(300)
    expect(manager.getState().step, "step 6").toBe(6)
    expect(ask.open, "Ask closed by the step change").toBe(false)
    expect(answerPanel.enabled, "answer hidden after the step change").toBe(false)
    expect(chipsPanel.enabled, "chips hidden after the step change").toBe(false)
    expect(ask.lastAnswer, "answer cleared").toBe("")
    expect(bar.askOn, "Ask toggle released by the step change").toBe(false)
    expect(idle.askSuspended, "IdleHint back on").toBe(false)

    // ── Reopen on step 6: its own questions; toggle off ────────────────────
    await interactor.tap("BtnAsk")
    await sleep(300)
    expect(ask.open, "Ask on for step 6").toBe(true)
    expect(ask.chips.questions[0], "chips show step 6's questions").toBe(COACH_QUESTIONS[6][0].q)
    await interactor.tap("BtnAsk")
    await sleep(300)
    expect(ask.open, "Ask off").toBe(false)
    expect(chipsPanel.enabled, "chips hidden").toBe(false)
    expect(bar.askOn, "Ask toggle released").toBe(false)
    expect(idle.askSuspended, "IdleHint back on").toBe(false)

    // ── Timers (pass G2): the answer hides, the chips come back, then Ask closes ──
    const answerSec = ask.answerSec
    const chipsIdleSec = ask.chipsIdleSec
    ask.answerSec = 1
    ask.chipsIdleSec = 1.5
    await interactor.tap("BtnAsk")
    await sleep(300)
    await interactor.tap("AskChip_0")
    await sleep(300)
    expect(answerPanel.enabled, "answer up").toBe(true)
    await sleep(1000)
    expect(answerPanel.enabled, "answer hidden after answerSec").toBe(false)
    expect(chipsPanel.enabled, "chips back after the answer hides").toBe(true)
    expect(ask.open, "Ask still open while the chips' clock runs").toBe(true)
    await sleep(1700)
    expect(ask.open, "Ask closed after chipsIdleSec without a chip press").toBe(false)
    expect(bar.askOn, "Ask toggle released by the timeout").toBe(false)

    // ── The answer hides at the next sub-step (step 2: a bead) ─────────────
    ask.answerSec = 30
    manager.jumpToStep(2)
    await sleep(400)
    await interactor.tap("BtnAsk")
    await sleep(300)
    await interactor.tap("AskChip_0")
    await sleep(300)
    expect(answerPanel.enabled, "step 2 answer up").toBe(true)
    await interactor.tap("Bead_2")
    await sleep(300)
    expect(manager.getState().step, "still step 2 after one bead").toBe(2)
    expect(answerPanel.enabled, "answer hidden at the next sub-step").toBe(false)
    expect(chipsPanel.enabled, "chips back in the slot").toBe(true)
    ask.answerSec = answerSec
    ask.chipsIdleSec = chipsIdleSec
    await interactor.tap("BtnAsk")
    await sleep(300)
    expect(ask.open, "Ask off at the end").toBe(false)

    ask.forceCanned = false
    manager.reset()
    await sleep(300)
  }
}
