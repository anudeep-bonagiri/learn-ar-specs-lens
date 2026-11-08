import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {ProgressRail} from "../Scripts/ProgressRail"
import {BenchCoachControlBarUI} from "../Scripts/BenchCoachControlBarUI"
import {BenchCoachStepLabelUI} from "../Scripts/BenchCoachStepLabelUI"
import {IdleHint} from "../Scripts/IdleHint"
import {StepMarker} from "../Scripts/StepMarker"
import {RunStats} from "../Scripts/RunStats"
import {HALFWAY_STEP, LAST_STEP, STEPS} from "../Scripts/StepDefinitions"

/**
 * Pass 8: the progress rail has one dot per railDot step (9), lights the dots of
 * the steps already done and pulses the current one (3 lit on step 4, all 9 on the
 * Finish card). With idleSec at 1 s, a quiet step shows its hint on the label once
 * (hintCount + 1, marker pulse boosted, RunStats hints + 1); Next takes the hint
 * down and shows the next step's label.
 * Pass B: the rail is hidden on the repair steps (the callout already counts them) and
 * shows only on the halfway and Finish cards, with the done segments lit.
 */
@component
export class ProgressIdleScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const railObj = findSceneObjectByName("ProgressRail")
    expect(railObj, "ProgressRail exists").toBeTruthy()
    const rail = railObj.getComponent(ProgressRail.getTypeName()) as ProgressRail
    const idle = root.getComponent(IdleHint.getTypeName()) as IdleHint
    const stats = root.getComponent(RunStats.getTypeName()) as RunStats
    const marker = findSceneObjectByName("StepMarker").getComponent(StepMarker.getTypeName()) as StepMarker
    expect(rail, "ProgressRail script").toBeTruthy()
    expect(idle, "IdleHint script").toBeTruthy()

    // ── Rail counts ─────────────────────────────────────────────────────────
    const railSteps = STEPS.filter((d) => d.railDot).length
    expect(rail.dotCount, "one dot per railDot step").toBe(railSteps)
    expect(rail.dotCount, "nine dots").toBe(9)
    manager.jumpToStep(0)
    await sleep(300)
    expect(rail.litCount, "no dots lit on the start card").toBe(0)
    manager.jumpToStep(4)
    await sleep(300)
    print(`[ProgressIdleScenario] step 4: lit ${rail.litCount}, current ${rail.currentIndex}`)
    expect(rail.litCount, "three dots lit on step 4").toBe(3)
    expect(rail.currentIndex, "fourth dot pulses on step 4").toBe(3)
    // Pass D2: the dock's counter reads "4 / 10".
    const dock = findSceneObjectByName("ControlBar").getComponent(BenchCoachControlBarUI.getTypeName()) as BenchCoachControlBarUI
    expect(dock.progressText, "dock counter on step 4").toBe("4 / 10")
    manager.jumpToStep(8)
    await sleep(300)
    expect(rail.litCount, "six dots lit on step 8").toBe(6)
    manager.jumpToStep(LAST_STEP)
    await sleep(300)
    expect(rail.litCount, "all dots lit on the Finish card").toBe(9)
    expect(rail.currentIndex, "no pulsing dot on the Finish card").toBe(-1)
    expect(rail.barShown, "the rail shows on the Finish card").toBe(true)
    expect(findSceneObjectByName("RailDot_0").isEnabledInHierarchy, "a rail segment is visible on the Finish card").toBe(true)

    // Pass B: the rail leaves the steps; only the two cards show it.
    for (const s of [1, 2]) {
      manager.jumpToStep(s)
      await sleep(300)
      expect(rail.barShown, `the rail is hidden on step ${s}`).toBe(false)
      expect(findSceneObjectByName("RailDot_0").isEnabledInHierarchy, `no rail segment shows on step ${s}`).toBe(false)
    }
    manager.jumpToStep(HALFWAY_STEP)
    await sleep(300)
    print(`[ProgressIdleScenario] halfway card: rail shown ${rail.barShown}, lit ${rail.litCount}`)
    expect(rail.barShown, "the rail shows on the halfway card").toBe(true)
    expect(findSceneObjectByName("RailDot_0").isEnabledInHierarchy, "a rail segment is visible on the halfway card").toBe(true)
    expect(rail.litCount, "segments 1 to 6 are done on the halfway card").toBe(6)

    // ── Idle hint ───────────────────────────────────────────────────────────
    const savedIdle = idle.idleSec
    try {
      manager.jumpToStep(2)
      await sleep(300)
      const hintsBefore = idle.hintCount
      const statsBefore = stats.hintsUsed
      const boostsBefore = marker.boostCount
      idle.idleSec = 1
      idle.touch()
      await sleep(1600)
      const label = findSceneObjectByName("LabelText").getComponent("Component.Text") as Text
      print(`[ProgressIdleScenario] hint on step 2: "${label.text}" (hints +${idle.hintCount - hintsBefore})`)
      expect(idle.hintCount, "one hint after a quiet second").toBe(hintsBefore + 1)
      expect(idle.showing, "hint showing").toBe(true)
      // Pass P: the instruction stays readable; the hint goes under it with its "Hint" kicker.
      expect(label.text, "the step's instruction stays on the callout").toBe(STEPS[2].label)
      const callout = findSceneObjectByName("StepLabel").getComponent(BenchCoachStepLabelUI.getTypeName()) as BenchCoachStepLabelUI
      expect(callout.mode, "callout in its hint state (pulsing accent edge)").toBe("hint")
      expect(callout.hintText, "the hint shows under the instruction").toBe(STEPS[2].hint)
      const hintText = findSceneObjectByName("HintText")
      expect(hintText && hintText.isEnabledInHierarchy, "hint line visible").toBe(true)
      const hintY = hintText.getTransform().getWorldPosition().y
      expect(hintY < label.getSceneObject().getTransform().getWorldPosition().y, "the hint line is under the instruction").toBe(true)
      expect(marker.boostCount, "marker pulse boosted").toBe(boostsBefore + 1)
      expect(marker.isBoosted(), "marker boosted now").toBe(true)
      expect(stats.hintsUsed, "RunStats counts the hint").toBe(statsBefore + 1)
      await sleep(1500)
      expect(idle.hintCount, "fires once per quiet spell").toBe(hintsBefore + 1)

      await interactor.tap("BtnNext")
      await sleep(300)
      expect(manager.getState().step, "Next to step 3").toBe(3)
      expect(idle.showing, "hint gone after Next").toBe(false)
      expect(callout.hintText, "hint line gone after Next").toBe("")
      expect(label.text, "step 3 label after Next").toBe(STEPS[3].label)
    } finally {
      idle.idleSec = savedIdle
      idle.touch()
    }
    manager.reset()
    await sleep(300)
  }
}
