import {RepairDirector} from "../Scripts/RepairDirector"
import {RimDrag} from "../Scripts/RimDrag"
import {TubeFit} from "../Scripts/TubeFit"
import {LAST_STEP} from "../Scripts/StepDefinitions"
import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {ScenarioConfig} from "Leaf.lspkg/Scenarios/scenario/ScenarioConfig"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {getRepairManager} from "./BenchCoachLeafInteractor"
import {RefitSteps} from "../Scripts/RefitSteps"
import {PartInfo} from "../Scripts/PartInfo"
import {CoachFeedback} from "../Scripts/CoachFeedback"
import {IdleHint} from "../Scripts/IdleHint"
import {BenchCoachLeafInteractor} from "./BenchCoachLeafInteractor"
import {AskCoach} from "../Scripts/AskCoach"

/**
 * Helper, not a criterion: jumps the Lens to step `step` (parameter, default 5)
 * with the model state of every earlier step applied, and leaves it there — for
 * screenshots, demo recording and manual checks of a single step. Prints where
 * the levers, marker and edge arrow ended up. On step 5, parameter `pullCm` > 0
 * holds the tube end that far past the rim (segment-by-segment pull, mid-way).
 * On step 8, `fit` = 1 runs the live fit (new tube back in the tire) but stays on
 * step 8; on step 10, `inflate` (0..1) holds the tire part-inflated.
 * Pass 8 screenshot helpers (all optional, strings): `cause` forces the flat cause
 * for this jump; `find` = 1 on step 6 pinches the hotspot and holds the reveal for
 * 30 s; `part` turns What's this? on and pinches InfoHit_<part>; `mistake` shows
 * that mistake code's reason for 30 s; `idle` = 1 fires the idle hint.
 * Pass 10: `watch` = 1 starts watch mode and leaves it running (step 0 taps BtnWatch;
 * any other step resumes from there with director.play()), for screenshots and video
 * takes. `until` = sweep | fit | finish waits until that beat is under way (lever B
 * sliding round, the new tube end flying to the valve, the Finish card), prints the
 * moving part at two moments 0.8 s apart, and returns while it is still playing.
 * Pass 12: `ask` = open taps BtnAsk; `ask` = 0..2 also pinches that chip and waits
 * (up to 8 s) for the answer; `canned` = 1 forces the offline answer. Screenshots only;
 * the live path needs tokens set in memory (tools/set-coach-tokens.md).
 * Pass B: `more` = 1 opens the dock's More popover and leaves it open, for screenshots.
 */
@component
export class JumpToStepScenario extends Scenario {
  async run(config?: ScenarioConfig): Promise<void> {
    const step = config?.getNumber("step") ?? 5
    const pullCm = config?.getNumber("pullCm") ?? 0
    const fit = config?.getNumber("fit") ?? 0
    const inflate = config?.getNumber("inflate") ?? 0
    const cause = config?.get("cause") ?? ""
    const find = config?.getNumber("find") ?? 0
    const part = config?.get("part") ?? ""
    const mistake = config?.get("mistake") ?? ""
    const idleOn = config?.getNumber("idle") ?? 0
    const watch = config?.getNumber("watch") ?? 0
    const until = config?.get("until") ?? ""
    const askArg = config?.get("ask") ?? ""
    const canned = config?.getNumber("canned") ?? 0
    const more = config?.getNumber("more") ?? 0
    await sleep(500)
    const manager = getRepairManager()
    const root = findSceneObjectByName("BenchCoach")
    const savedForce = manager.forceCause
    if (cause) manager.forceCause = cause
    manager.jumpToStep(step)
    manager.forceCause = savedForce
    await sleep(1200)
    expect(manager.getState().step, `landed on step ${step}`).toBe(step)
    if (step === 5 && pullCm > 0) {
      // TubePull reads the tube end's position each frame while armed; place it straight down from the hub.
      const wheel = findSceneObjectByName("Wheel").getTransform().getWorldPosition()
      const tube = findSceneObjectByName("Tube")
      const rimCm = 33.4 * tube.getTransform().getWorldScale().x
      findSceneObjectByName("TubeEnd").getTransform().setWorldPosition(wheel.add(new vec3(0, -(rimCm + pullCm), 0)))
      await sleep(300)
    }
    const refit = findSceneObjectByName("BenchCoach").getComponent(RefitSteps.getTypeName()) as RefitSteps
    if (step === 8 && fit > 0 && refit) {
      refit.advanceOnFit = false
      refit.fitNow()
      await sleep(2500)
      refit.advanceOnFit = true
    }
    if (step === 10 && inflate > 0 && refit) {
      refit.setInflateProgress(inflate)
      await sleep(200)
    }
    const interactor = new BenchCoachLeafInteractor()
    if (step === 6 && find > 0) {
      const saved = manager.thornRevealSec
      manager.thornRevealSec = 30
      await interactor.tap("ThornHotspot")
      manager.thornRevealSec = saved
    }
    if (mistake) {
      const fb = root.getComponent(CoachFeedback.getTypeName()) as CoachFeedback
      const saved = fb.showSec
      fb.showSec = 30
      fb.mistake(mistake, findSceneObjectByName("StepMarker").getTransform().getWorldPosition())
      fb.showSec = saved
    }
    if (idleOn > 0) {
      const idle = root.getComponent(IdleHint.getTypeName()) as IdleHint
      const saved = idle.idleSec
      idle.idleSec = 1
      idle.touch()
      await sleep(1400)
      idle.idleSec = saved
    }
    if (watch > 0) {
      const director = root.getComponent(RepairDirector.getTypeName()) as RepairDirector
      if (step === 0) await interactor.tap("BtnWatch")
      else director.play()
      print(`[JumpToStep] watch mode started (step ${manager.getState().step}, playing ${director.playing})`)
      const rim = findSceneObjectByName("LeverB").getComponent(RimDrag.getTypeName()) as RimDrag
      const fitEnd = findSceneObjectByName("NewTubeEnd")
      const fitObj = fitEnd ? (fitEnd.getComponent(TubeFit.getTypeName()) as TubeFit) : null
      const sample = (): string => {
        const e = fitEnd.getTransform().getWorldPosition()
        return `step ${manager.getState().step}, lever B ${rim.currentAngleDeg.toFixed(1)} deg, new tube end (${e.x.toFixed(1)}, ${e.y.toFixed(1)}, ${e.z.toFixed(1)})`
      }
      const cond = (): boolean =>
        until === "sweep" ? rim.sweeping : until === "fit" ? !!fitObj && fitObj.isBusy() : until === "finish" ? manager.getState().step === LAST_STEP : true
      const end = getTime() + 75
      while (until && !cond() && getTime() < end) await sleep(50)
      expect(cond(), `watch mode reached "${until}"`).toBe(true)
      if (until) {
        print(`[JumpToStep] ${until} t1: ${sample()}`)
        await sleep(800)
        print(`[JumpToStep] ${until} t2: ${sample()}`)
      }
    }
    if (part) {
      const info = root.getComponent(PartInfo.getTypeName()) as PartInfo
      await interactor.tap("BtnWhatsThis")
      await sleep(300)
      await interactor.tap(`InfoHit_${part}`)
      print(`[JumpToStep] What's this? ${info.lastText}`)
    }
    if (more > 0) {
      await interactor.tap("BtnMore")
      await sleep(400)
      print("[JumpToStep] the More popover is open")
    }
    if (askArg) {
      const ask = root.getComponent(AskCoach.getTypeName()) as AskCoach
      ask.forceCanned = canned > 0
      await interactor.tap("BtnAsk")
      await sleep(300)
      if (askArg !== "open") {
        const t0 = getTime()
        await interactor.tap(`AskChip_${askArg}`)
        await sleep(100)
        while ((ask.busy || !ask.lastSource) && getTime() - t0 < 8) await sleep(50)
        print(`[JumpToStep] ask ${askArg}: ${ask.lastSource} (${ask.lastFallbackReason}) ${ask.lastLatencyMs} ms "${ask.lastAnswer}"`)
      }
      for (const name of ["AskChipsPanel", "AskAnswerPanel", "StepLabel"]) {
        const p = findSceneObjectByName(name).getTransform().getWorldPosition()
        print(`[JumpToStep] ${name} at (${p.x.toFixed(1)}, ${p.y.toFixed(1)}, ${p.z.toFixed(1)})`)
      }
    }
    for (const name of ["LeverA", "LeverB", "StepMarker", "TubeEnd", "EdgeArrow", "NewTubeEnd"]) {
      const so = findSceneObjectByName(name)
      if (!so) continue
      const p = so.getTransform().getWorldPosition()
      print(`[JumpToStep] ${name} enabled=${so.isEnabledInHierarchy} at (${p.x.toFixed(1)}, ${p.y.toFixed(1)}, ${p.z.toFixed(1)})`)
    }
    // Screen position (0..1, top-left origin) of the step's touch target, for injected mouse checks.
    const cam = findSceneObjectByName("Camera Object")
    const camera = cam ? (cam.getComponent("Component.Camera") as Camera) : null
    for (const name of ["Valve", "BtnFoundIt", "NewTubeEnd", "ValveSocket"]) {
      const so = findSceneObjectByName(name)
      if (!camera || !so || !so.isEnabledInHierarchy) continue
      const sp = camera.worldSpaceToScreenSpace(so.getTransform().getWorldPosition())
      print(`[JumpToStep] ${name} on screen at (${sp.x.toFixed(3)}, ${sp.y.toFixed(3)})`)
    }
  }
}
