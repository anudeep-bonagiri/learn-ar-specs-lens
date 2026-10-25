import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {RepairDirector} from "../Scripts/RepairDirector"
import {IdleHint} from "../Scripts/IdleHint"
import {RunStats} from "../Scripts/RunStats"
import {LAST_STEP} from "../Scripts/StepDefinitions"

/**
 * Pass 10: watch mode. BtnWatch presses Found it and starts the director (playing,
 * step 1, within 0.5 s); it plays on its own until lever B has peeled Bead_1..3 and
 * the tube is ready to pull (step >= 5, three peeled beads); BtnNext stops it and
 * advances exactly one step; play() resumes and runs to the Finish card with
 * IdleHint back on, no lever misses or hints counted, and no fallback next() calls.
 * Every wait is a poll with a hard timeout, so a stall fails an assertion instead of hanging.
 */
@component
export class WatchModeScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const director = root.getComponent(RepairDirector.getTypeName()) as RepairDirector
    const idle = root.getComponent(IdleHint.getTypeName()) as IdleHint
    const stats = root.getComponent(RunStats.getTypeName()) as RunStats
    expect(director, "RepairDirector on BenchCoach").toBeTruthy()
    expect(idle, "IdleHint on BenchCoach").toBeTruthy()
    expect(stats, "RunStats on BenchCoach").toBeTruthy()

    manager.reset()
    await sleep(500)
    expect(manager.getState().step, "start card").toBe(0)
    const fallbacksBefore = director.fallbacks
    const t0 = getTime()

    // ── Watch starts it ─────────────────────────────────────────────────────
    await interactor.tap("BtnWatch")
    const tapMs = (director.lastPlayTime - t0) * 1000
    print(`[WatchModeScenario] after BtnWatch (${tapMs.toFixed(0)} ms): playing ${director.playing}, step ${manager.getState().step}, cause ${manager.getCause()}`)
    expect(director.playing, "playing after BtnWatch").toBe(true)
    expect(manager.getState().step, "step 1 after BtnWatch").toBe(1)
    expect(director.lastPlayTime > t0 && tapMs <= 500, "watch mode started within 0.5 s of the tap").toBe(true)
    expect(idle.suspended, "idle hints suspended while playing").toBe(true)
    expect(stats.suspended, "RunStats suspended while playing").toBe(true)

    // ── Plays on its own to the pull ─────────────────────────────────────────
    const ready = await this.pollUntil(40, () => manager.getState().step >= 5 && manager.getPeeledBeads().length === 3)
    const atReady = manager.getState().step
    print(`[WatchModeScenario] ready after ${(getTime() - t0).toFixed(1)} s: step ${atReady}, peeled ${manager.getPeeledBeads().length}`)
    expect(ready, "watch mode reached step 5 with three peeled beads within 40 s").toBe(true)
    expect(director.playing, "still playing at the pull").toBe(true)

    // ── Next stops it and advances once ──────────────────────────────────────
    const before = manager.getState().step
    await interactor.tap("BtnNext")
    await sleep(500)
    print(`[WatchModeScenario] after BtnNext: playing ${director.playing} (${director.lastStopReason}), step ${before} -> ${manager.getState().step}`)
    expect(director.playing, "Next stops watch mode").toBe(false)
    expect(director.lastStopReason, "stopped by a press").toBe("stop")
    expect(manager.getState().step, "Next advanced exactly one step").toBe(before + 1)
    expect(idle.suspended, "idle hints back on after the stop").toBe(false)
    await sleep(1500)
    expect(manager.getState().step, "nothing advances by itself after the stop").toBe(before + 1)

    // ── Resume to the Finish card ────────────────────────────────────────────
    const t1 = getTime()
    director.play()
    expect(director.playing, "play() resumes").toBe(true)
    const finished = await this.pollUntil(90, () => manager.getState().step === LAST_STEP && !director.playing)
    const finishCard = findSceneObjectByName("FinishCard")
    print(
      `[WatchModeScenario] resume: ${(getTime() - t1).toFixed(1)} s to step ${manager.getState().step}; ` +
        `reason ${director.lastStopReason}; fallbacks ${director.fallbacks - fallbacksBefore}; ` +
        `misses ${stats.leverMisses}, hints ${stats.hintsUsed}, mistakes ${stats.mistakes}`
    )
    expect(finished, "watch mode reached LAST_STEP within 90 s").toBe(true)
    expect(manager.getState().step, "on the Finish card step").toBe(LAST_STEP)
    expect(finishCard && finishCard.isEnabledInHierarchy, "FinishCard enabled").toBe(true)
    expect(director.lastStopReason, "ended by finishing").toBe("finished")
    expect(idle.suspended, "idle hints not suspended at the end").toBe(false)
    expect(stats.suspended, "RunStats not suspended at the end").toBe(false)
    expect(stats.leverMisses, "no lever misses counted").toBe(0)
    expect(stats.hintsUsed, "no hints counted").toBe(0)
    expect(director.fallbacks - fallbacksBefore, "every step advanced on its own events").toBe(0)

    manager.reset()
    await sleep(300)
  }

  /** Poll every 250 ms until `cond` holds or `timeoutSec` passes; returns whether it held. */
  private async pollUntil(timeoutSec: number, cond: () => boolean): Promise<boolean> {
    const end = getTime() + timeoutSec
    while (getTime() < end) {
      if (cond()) return true
      await sleep(250)
    }
    return cond()
  }
}
