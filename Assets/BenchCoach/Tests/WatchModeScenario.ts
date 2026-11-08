import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {RepairDirector} from "../Scripts/RepairDirector"
import {IdleHint} from "../Scripts/IdleHint"
import {RunStats} from "../Scripts/RunStats"
import {LAST_STEP} from "../Scripts/StepDefinitions"
import {FloorPath} from "../Scripts/FloorPath"
import {BenchCoachWatchBadgeUI} from "../Scripts/BenchCoachWatchBadgeUI"

/**
 * Pass 10: watch mode. BtnWatch presses Found it and starts the director (playing,
 * step 1, within 0.5 s); it plays on its own until lever B has peeled Bead_1..3 and
 * the tube is ready to pull (step 5, three peeled beads); after the walk and the pull
 * (pass S1, below) BtnNext stops it and advances exactly one step; play() resumes and runs to the Finish card with
 * IdleHint back on, no lever misses or hints counted, and no fallback next() calls.
 * Every wait is a poll with a hard timeout, so a stall fails an assertion instead of hanging.
 * Pass P: the run had grown to 59.8 s, at the MCP call's limit, so play() resumes from
 * step 8, the refit module's own demos; the Lens's Watch timings are unchanged. Watch's
 * steps 6 and 7 (the glint found, the halfway card continuing) are not played here.
 * Pass S1: Watch walks. On step 5 the floor path shows and the pull waits; the eye is
 * walked to the far spot over 3 s (set every poll, as floor-path does) as soon as step 5
 * starts, the arrival hides the path and the pull starts within 2 s of it. Next then stops Watch on
 * step 6 and advances to the halfway card; one more Next reaches step 8.
 * Pass B: the Watching badge is brief: sampled during the normal run (no extra waiting),
 * visible 1 s after Watch starts, hidden 3 s on (at 4 s, or just before the first step
 * change if that comes sooner), visible again within 0.5 s of the next step change and
 * hidden 2.5 s later. The resume leg from step 8 keeps its beats but shortens their
 * reading pauses (waitScale 0.25, no voice hold), so the run fits the MCP call.
 */
@component
export class WatchModeScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(200)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const director = root.getComponent(RepairDirector.getTypeName()) as RepairDirector
    const idle = root.getComponent(IdleHint.getTypeName()) as IdleHint
    const stats = root.getComponent(RunStats.getTypeName()) as RunStats
    expect(director, "RepairDirector on BenchCoach").toBeTruthy()
    expect(idle, "IdleHint on BenchCoach").toBeTruthy()
    expect(stats, "RunStats on BenchCoach").toBeTruthy()
    const path = findSceneObjectByName("FloorPath").getComponent(FloorPath.getTypeName()) as FloorPath
    expect(path, "FloorPath").toBeTruthy()

    const badge = findSceneObjectByName("WatchBadgeRoot").getParent().getComponent(BenchCoachWatchBadgeUI.getTypeName()) as BenchCoachWatchBadgeUI
    expect(badge, "the Watching badge").toBeTruthy()

    manager.reset()
    await sleep(300)
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

    // ── Plays on its own to the pull (pass B: the badge is sampled every poll) ──
    const playStart = director.lastPlayTime
    let sawOne = false
    let visibleAt1 = false
    let hiddenLate: boolean | null = null
    let hiddenAt4: boolean | null = null
    let stepChangeAt = -1
    let shownAfterStep = false
    let hiddenAfterStep: boolean | null = null
    const sampleBadge = () => {
      const now = getTime()
      const el = now - playStart
      const st = manager.getState().step
      if (!sawOne && el >= 1) {
        sawOne = true
        visibleAt1 = badge.showing
      }
      if (st === 1 && el >= 3.3) hiddenLate = !badge.showing
      if (st === 1 && el >= 4 && hiddenAt4 === null) hiddenAt4 = !badge.showing
      if (st === 2 && stepChangeAt < 0) {
        stepChangeAt = now
        shownAfterStep = badge.showing
      }
      if (stepChangeAt > 0 && hiddenAfterStep === null && now - stepChangeAt >= 2.5 && st === 2) hiddenAfterStep = !badge.showing
    }
    const ready = await this.pollUntil(
      40,
      () => {
        sampleBadge()
        return manager.getState().step >= 5 && manager.getPeeledBeads().length === 3
      },
      100
    )
    const atReady = manager.getState().step
    print(`[WatchModeScenario] ready after ${(getTime() - t0).toFixed(1)} s: step ${atReady}, peeled ${manager.getPeeledBeads().length}`)
    print(`[WatchModeScenario] badge: visible at 1 s ${visibleAt1}; hidden at 4 s ${hiddenAt4} (just before step 2 ${hiddenLate}); step 2 at ${(stepChangeAt - playStart).toFixed(1)} s, shown then ${shownAfterStep}, hidden 2.5 s later ${hiddenAfterStep}`)
    expect(visibleAt1, "the badge shows 1 s after Watch starts").toBe(true)
    expect(hiddenAt4 ?? hiddenLate, "the badge is hidden at 4 s").toBe(true)
    expect(stepChangeAt > 0, "the next step change was seen").toBe(true)
    expect(shownAfterStep, "the badge shows again within 0.5 s of the step change").toBe(true)
    expect(hiddenAfterStep, "the badge is hidden 2.5 s after the step change").toBe(true)
    expect(ready, "watch mode reached step 5 with three peeled beads within 40 s").toBe(true)
    expect(atReady, "on step 5").toBe(5)
    expect(director.playing, "still playing at the pull").toBe(true)

    // ── Step 5: the path shows and the pull waits for the walk ──────────────
    expect(path.visible, "Watch, step 5: the floor path shows").toBe(true)
    expect(director.lastActStep !== 5, "Watch, step 5: the pull has not started").toBe(true)
    const camTr = findSceneObjectByName("Camera Object").getTransform()
    const camHome = camTr.getWorldPosition()
    const camRot = camTr.getWorldRotation()
    const far = path.farSpotWorld()
    const goal = new vec3(far.x, camHome.y, far.z)
    // The preview puts the camera back every frame, so it is set again every poll.
    const holdAt = async (sec: number, cond: () => boolean): Promise<boolean> => {
      const end = getTime() + sec
      while (getTime() < end) {
        camTr.setWorldPosition(goal)
        if (cond()) return true
        await sleep(50)
      }
      return cond()
    }
    // A walk round the stand's right side over 3 s (the take's walk was 5.6 s): the beat's
    // own 3.5 s wait and the voice line still run, so an instant jump would only measure them.
    const side = new vec3(far.x + 45, camHome.y, (camHome.z + far.z) / 2)
    const walkSec = 3
    const walkStart = getTime()
    let pathDuringWalk = true
    let pullDuringWalk = false
    while (!path.arrived && getTime() - walkStart < walkSec + 1) {
      const f = Math.min(1, (getTime() - walkStart) / walkSec)
      const p = f < 0.5 ? vec3.lerp(camHome, side, f * 2) : vec3.lerp(side, goal, (f - 0.5) * 2)
      camTr.setWorldPosition(p)
      if (!path.arrived && !path.visible) pathDuringWalk = false
      if (director.lastActStep === 5) pullDuringWalk = true
      await sleep(50)
    }
    const arrived = await holdAt(1, () => path.arrived)
    const tArrive = getTime()
    expect(pathDuringWalk, "the path shows until the arrival").toBe(true)
    expect(pullDuringWalk, "no pull while walking").toBe(false)
    expect(arrived, "the viewer arrives at the far spot").toBe(true)
    expect(path.visible, "arrival hides the path").toBe(false)
    expect(manager.getState().step, "arrival does not complete step 5").toBe(5)
    const pulled = await holdAt(6, () => director.lastActStep === 5)
    const pullAfter = director.lastActTime - tArrive
    print(`[WatchModeScenario] arrived ${(tArrive - walkStart).toFixed(1)} s into step 5; pull ${pullAfter.toFixed(2)} s after the arrival (${director.lastWalkEnd})`)
    expect(pulled, "the pull starts after the arrival").toBe(true)
    expect(pullAfter <= 2, `the pull starts within 2 s of the arrival (${pullAfter.toFixed(2)} s)`).toBe(true)
    expect(director.lastWalkEnd, "the beat ended its wait on the arrival").toBe("arrival")
    const atSix = await holdAt(5, () => manager.getState().step === 6)
    camTr.setWorldPosition(camHome)
    camTr.setWorldRotation(camRot)
    expect(atSix, "the pull completes step 5").toBe(true)

    // ── Next stops it and advances once ──────────────────────────────────────
    const before = manager.getState().step
    await interactor.tap("BtnNext")
    await sleep(500)
    print(`[WatchModeScenario] after BtnNext: playing ${director.playing} (${director.lastStopReason}), step ${before} -> ${manager.getState().step}`)
    expect(director.playing, "Next stops watch mode").toBe(false)
    expect(director.lastStopReason, "stopped by a press").toBe("stop")
    expect(manager.getState().step, "Next advanced exactly one step").toBe(before + 1)
    expect(idle.suspended, "idle hints back on after the stop").toBe(false)
    await sleep(700)
    expect(manager.getState().step, "nothing advances by itself after the stop").toBe(before + 1)

    // ── Next once more (the halfway card), then resume ──────────────────────
    await interactor.tap("BtnNext")
    await sleep(300)
    expect(manager.getState().step, `Next to step ${before + 2}`).toBe(before + 2)
    expect(director.playing, "still stopped").toBe(false)

    // ── Resume to the Finish card ────────────────────────────────────────────
    const t1 = getTime()
    const savedWait = director.waitScale
    const savedHold = director.voiceHoldMaxSec
    director.waitScale = 0.25
    director.voiceHoldMaxSec = 0
    director.play()
    expect(director.playing, "play() resumes").toBe(true)
    let finished = false
    try {
      finished = await this.pollUntil(90, () => manager.getState().step === LAST_STEP && !director.playing)
    } finally {
      director.waitScale = savedWait
      director.voiceHoldMaxSec = savedHold
    }
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
  private async pollUntil(timeoutSec: number, cond: () => boolean, everyMs: number = 250): Promise<boolean> {
    const end = getTime() + timeoutSec
    while (getTime() < end) {
      if (cond()) return true
      await sleep(everyMs)
    }
    return cond()
  }
}
