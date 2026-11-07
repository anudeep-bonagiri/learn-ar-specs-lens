import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {ScenarioConfig} from "Leaf.lspkg/Scenarios/scenario/ScenarioConfig"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {AdaptiveCoach} from "../Scripts/AdaptiveCoach"
import {IdleHint} from "../Scripts/IdleHint"
import {GhostAnimator} from "../Scripts/GhostAnimator"
import {VoiceCoach} from "../Scripts/VoiceCoach"
import {BenchCoachStartCardUI} from "../Scripts/BenchCoachStartCardUI"
import {BenchCoachFinishCardUI} from "../Scripts/BenchCoachFinishCardUI"
import {LAST_STEP} from "../Scripts/StepDefinitions"

/**
 * Pass A, the coach adapts: per-step scores change how much the coach helps on the next run.
 * Run 1: steps 1 and 2 clean and quick, twice (Back, Back, then again: one clean completion
 * moves a score from 0.5 to 0.70, the second to 0.82, mastered from 0.75); step 3 with two
 * lever A drops 10 cm off the ghost, then the snap (0.5 to 0.30, struggling); jumpToStep to
 * the Finish card. The run count is 1 and the More view's last line names lever A as
 * needing help. Run 2 (reset, memory kept): the start card's "Run 2." line; step 1 waits
 * 24 s for its hint and does not speak it; step 3 waits 6 s and its ghost is still looping
 * 4 s in. Then forget() and reset: no run line, step 1 back to 12 s.
 * Parameter `stay` (captures): 1 stops on the More view, 2 on the run 2 start card, 3 on
 * run 2's step 3 once its hint shows (6.5 s), 4 on run 2's step 1 after 15 s quiet.
 */
@component
export class AdaptiveCoachScenario extends Scenario {
  async run(config?: ScenarioConfig): Promise<void> {
    const stay = config?.getNumber("stay") ?? 0
    await sleep(500)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const coach = root.getComponent(AdaptiveCoach.getTypeName()) as AdaptiveCoach
    const idle = root.getComponent(IdleHint.getTypeName()) as IdleHint
    const voice = root.getComponent(VoiceCoach.getTypeName()) as VoiceCoach
    const ghostSo = findSceneObjectByName("GhostLever")
    const ghost = ghostSo.getComponent(GhostAnimator.getTypeName()) as GhostAnimator
    const start = findSceneObjectByName("StartCard").getComponent(BenchCoachStartCardUI.getTypeName()) as BenchCoachStartCardUI
    const finish = findSceneObjectByName("FinishCard").getComponent(BenchCoachFinishCardUI.getTypeName()) as BenchCoachFinishCardUI
    expect(coach, "AdaptiveCoach on BenchCoach").toBeTruthy()
    coach.forget()
    manager.reset()
    await sleep(300)
    expect(start.runLine, "first run: no run line").toBe("")

    // ── Run 1: steps 1 and 2 clean and quick, twice ──────────────────────────
    await interactor.tap("BtnFoundIt")
    const deflateLoosen = async () => {
      await interactor.tap("Valve")
      await sleep(200)
      expect(manager.getState().step, "step 2 after the valve").toBe(2)
      for (const i of [2, 6, 0, 4]) {
        await interactor.tap(`Bead_${i}`)
        await sleep(150)
      }
      expect(manager.getState().step, "step 3 after four beads").toBe(3)
    }
    await deflateLoosen()
    print(`[AdaptiveCoachScenario] after one pass: step 1 ${coach.scoreOf(1).toFixed(2)}, step 2 ${coach.scoreOf(2).toFixed(2)}`)
    await interactor.tap("BtnBack")
    await interactor.tap("BtnBack")
    expect(manager.getState().step, "Back twice: step 1").toBe(1)
    expect(coach.scoreOf(1), "Back does not change a score").toBeCloseTo(0.7, 2)
    await deflateLoosen()
    print(`[AdaptiveCoachScenario] after two passes: step 1 ${coach.scoreOf(1).toFixed(2)}, step 2 ${coach.scoreOf(2).toFixed(2)}`)
    expect(coach.scoreOf(1) >= 0.75, "step 1 mastered").toBe(true)
    expect(coach.scoreOf(2) >= 0.75, "step 2 mastered").toBe(true)

    // ── Step 3: two drops away from the socket, then the snap ────────────────
    const socketPos = findSceneObjectByName("LeverSocket").getTransform().getWorldPosition()
    const lever = findInteractablesByName("LeverA", undefined, true)[0]
    expect(lever, "LeverA interactable").toBeTruthy()
    for (let k = 0; k < 2; k++) {
      await interactor.dragTo(lever, socketPos.add(new vec3(10, 0, 0)), 1.0, 8000, 0.5)
      await sleep(700)
    }
    await interactor.dragTo(lever, socketPos.add(new vec3(1.5, 0, 0)), 1.0, 8000, 0.5)
    await sleep(200)
    expect(manager.getState().step, "step 4 after the snap").toBe(4)
    print(`[AdaptiveCoachScenario] step 3 score ${coach.scoreOf(3).toFixed(2)} (${coach.levelOf(3)})`)
    expect(coach.scoreOf(3) <= 0.35, "step 3 score at most 0.35").toBe(true)
    expect(coach.levelOf(3), "step 3 struggling").toBe("struggling")

    // ── The Finish card, the More view ───────────────────────────────────────
    manager.jumpToStep(LAST_STEP)
    await sleep(300)
    expect(coach.runCount(), "one run").toBe(1)
    await interactor.tap("BtnFinishMore")
    await sleep(300)
    expect(finish.expanded, "More view").toBe(true)
    const memory = finish.textOf("FinishMemory")
    print(`[AdaptiveCoachScenario] More view: "${memory}"`)
    expect(memory.indexOf("Coach memory:") === 0, "the coach memory line").toBe(true)
    expect(memory.indexOf("lever A needs help") >= 0, "lever A needs help").toBe(true)
    expect(findSceneObjectByName("FinishMemory").isEnabledInHierarchy, "the line shows").toBe(true)
    if (stay === 1) return

    // ── Run 2: the memory is kept across a reset ─────────────────────────────
    manager.reset()
    await sleep(300)
    print(`[AdaptiveCoachScenario] start card: "${start.runLine}" (${start.runRole})`)
    expect(start.runLine.indexOf("Run 2. ") === 0, "the Run 2 line").toBe(true)
    expect(findSceneObjectByName("RunLine").isEnabledInHierarchy, "the run line shows").toBe(true)
    if (stay === 2) return
    await interactor.tap("BtnFoundIt")
    expect(manager.getState().step, "run 2, step 1").toBe(1)
    expect(idle.effectiveDelay(), "step 1 mastered: hint after 24 s").toBe(24)
    expect(voice.quietIdleHint, "step 1 mastered: the hint is not spoken").toBe(true)
    if (stay === 4) {
      await sleep(15000)
      expect(idle.showing, "no hint at 15 s").toBe(false)
      return
    }
    manager.jumpToStep(3)
    expect(idle.effectiveDelay(), "step 3 struggling: hint after 6 s").toBe(6)
    expect(voice.quietIdleHint, "step 3 struggling: the hint is spoken").toBe(false)
    await sleep(4000)
    expect(ghostSo.enabled, "ghost shown 4 s in").toBe(true)
    expect(ghost.isPlayingNow(), "ghost still playing 4 s in").toBe(true)
    if (stay === 3) {
      await sleep(2500)
      expect(idle.showing, "the hint shows at 6 s").toBe(true)
      return
    }

    // ── A fresh memory: no run line, step 1 back to normal ───────────────────
    coach.forget()
    manager.reset()
    await sleep(300)
    expect(start.runLine, "no run line after forget").toBe("")
    expect(findSceneObjectByName("RunLine").isEnabledInHierarchy, "the run line is hidden").toBe(false)
    await interactor.tap("BtnFoundIt")
    expect(idle.effectiveDelay(), "step 1 normal: hint after 12 s").toBe(12)
    manager.reset()
    await sleep(300)
  }
}
