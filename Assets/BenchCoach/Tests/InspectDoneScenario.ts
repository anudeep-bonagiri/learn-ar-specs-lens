import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {RepairManager} from "../Scripts/RepairManager"
import {ThornHotspot} from "../Scripts/ThornHotspot"
import {GhostAnimator} from "../Scripts/GhostAnimator"
import {BenchCoachAudio} from "../Scripts/BenchCoachAudio"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"

const MODEL_PARTS = [
  "Tire",
  "Bead_0", "Bead_1", "Bead_2", "Bead_3", "Bead_4", "Bead_5", "Bead_6", "Bead_7",
  "Tube",
  "TubeSeg_0", "TubeSeg_1", "TubeSeg_2", "TubeSeg_3", "TubeSeg_4", "TubeSeg_5", "TubeSeg_6", "TubeSeg_7",
  "TubeEnd", "Valve", "LeverA", "LeverB",
]

interface Snapshot {
  step: number
  thornFound: boolean
  poses: vec3[]
  scales: vec3[]
  leverParents: string
}

function snapshot(manager: RepairManager, thorn: ThornHotspot): Snapshot {
  const poses: vec3[] = []
  const scales: vec3[] = []
  const parents: string[] = []
  for (const name of MODEL_PARTS) {
    const so = findSceneObjectByName(name)
    const tr = so.getTransform()
    // Levers live in the body-following tray until hooked, so compare them in their parent's space.
    const isLever = name.indexOf("Lever") === 0
    poses.push(isLever ? tr.getLocalPosition() : tr.getWorldPosition())
    scales.push(isLever ? tr.getLocalScale() : tr.getWorldScale())
    if (isLever) parents.push(so.getParent() ? so.getParent().name : "")
  }
  return {step: manager.getState().step, thornFound: thorn.found, poses, scales, leverParents: parents.join(",")}
}

/** Largest pose / scale difference between two snapshots, with the part it is on. */
function worstDiff(a: Snapshot, b: Snapshot): {cm: number; part: string} {
  let cm = 0
  let part = "none"
  for (let i = 0; i < MODEL_PARTS.length; i++) {
    const d = Math.max(a.poses[i].distance(b.poses[i]), a.scales[i].distance(b.scales[i]) * 10)
    if (d > cm) {
      cm = d
      part = MODEL_PARTS[i]
    }
  }
  return {cm, part}
}

/**
 * Criterion 5: pinching the thorn on the inspect step reveals it, then the Done
 * card appears with the elapsed time and the done cue; Try again returns to
 * step 0. Back from every step n lands on step n-1 with exactly the model state
 * jumpToStep(n-1) produces (Bead_0 restored from step 4), and Replay does
 * something on every step (ghost on 3 and 4, glint flash on 6, cue elsewhere).
 */
@component
export class InspectDoneScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const thornObj = findSceneObjectByName("ThornHotspot")
    expect(thornObj, "ThornHotspot exists").toBeTruthy()
    const thorn = thornObj.getComponent(ThornHotspot.getTypeName()) as ThornHotspot
    expect(thorn, "ThornHotspot script").toBeTruthy()
    const ghost = findSceneObjectByName("GhostLever").getComponent(GhostAnimator.getTypeName()) as GhostAnimator
    const audio = findSceneObjectByName("Audio").getComponent(BenchCoachAudio.getTypeName()) as BenchCoachAudio
    const marker = findSceneObjectByName("StepMarker")
    const label = findSceneObjectByName("StepLabel")
    const doneCard = findSceneObjectByName("DoneCard")

    // ── Inspect: the glint is a search, Replay flashes it, pinch finds it ────
    manager.jumpToStep(6)
    await sleep(600)
    expect(manager.getState().step, "on the inspect step").toBe(6)
    expect(thorn.armed, "glint armed").toBe(true)
    expect(marker.enabled, "no ring on the answer while searching").toBe(false)
    expect(label.enabled, "inspect label shown").toBe(true)
    // trigger() skips the ray; a live bead hit box around the thorn would swallow real pinches.
    for (const name of ["Valve", "Bead_0", "Bead_2", "Bead_4", "Bead_6"]) {
      const target = findSceneObjectByName(name).getComponent(Interactable.getTypeName()) as Interactable
      expect(target.enabled, `${name} takes no pinches on the inspect step`).toBe(false)
    }
    const flashesBefore = thorn.flashCount
    await interactor.tap("BtnReplay")
    expect(thorn.flashCount, "Replay flashes the glint").toBe(flashesBefore + 1)

    const clicksBefore = audio.clickPlays
    const donesBefore = audio.donePlays
    await interactor.tap("ThornHotspot")
    expect(thorn.found, "thorn found").toBe(true)
    expect(audio.clickPlays, "click on the find").toBe(clicksBefore + 1)
    expect(manager.getState().step, "thorn shown before Done").toBe(6)
    expect(marker.enabled, "ring highlights the found thorn").toBe(true)
    const ringToThorn = marker.getTransform().getWorldPosition().distance(thornObj.getTransform().getWorldPosition())
    print(`[InspectDoneScenario] ring ${ringToThorn.toFixed(2)} cm from the thorn`)
    expect(ringToThorn, "ring on the thorn").toBeLessThan(2.0)

    await sleep(3000) // thorn reveal, then Done
    expect(manager.getState().step, "Done after the reveal").toBe(7)
    expect(doneCard.enabled, "DoneCard enabled").toBe(true)
    const timeText = findSceneObjectByName("TimeText").getComponent("Component.Text") as Text
    print(`[InspectDoneScenario] done card time: "${timeText.text}"`)
    expect(timeText.text.indexOf(":") >= 0, "time on the Done card contains ':'").toBe(true)
    expect(audio.donePlays, "done cue played once").toBe(donesBefore + 1)

    // ── Try again ───────────────────────────────────────────────────────────
    await interactor.tap("BtnTryAgain")
    expect(manager.getState().step, "Try again returns to step 0").toBe(0)
    expect(findSceneObjectByName("StartCard").enabled, "start card back").toBe(true)
    expect(thorn.found, "thorn hidden again").toBe(false)

    // ── Back at every step restores exactly the previous step's model ───────
    for (let n = 1; n <= 7; n++) {
      manager.jumpToStep(n - 1)
      await sleep(300)
      const expected = snapshot(manager, thorn)
      manager.jumpToStep(n)
      await sleep(300)
      const bead0Lifted = findSceneObjectByName("Bead_0").getTransform().getWorldPosition()
      await interactor.tap("BtnBack")
      await sleep(300)
      const actual = snapshot(manager, thorn)
      const diff = worstDiff(expected, actual)
      print(`[InspectDoneScenario] Back from ${n}: step ${actual.step}, worst diff ${diff.cm.toFixed(3)} cm (${diff.part})`)
      expect(actual.step, `Back from ${n} lands on ${n - 1}`).toBe(n - 1)
      expect(actual.thornFound, `thorn state after Back from ${n}`).toBe(expected.thornFound)
      expect(actual.leverParents, `lever parents after Back from ${n}`).toBe(expected.leverParents)
      expect(diff.cm, `model after Back from ${n} matches step ${n - 1}`).toBeLessThan(0.05)
      if (n === 4) {
        const drop = bead0Lifted.distance(findSceneObjectByName("Bead_0").getTransform().getWorldPosition())
        expect(drop, "Back from 4 lowers Bead_0 again").toBeCloseTo(1.0, 1)
      }
    }

    // ── Replay does something on every step ──────────────────────────────────
    for (let n = 1; n <= 7; n++) {
      manager.jumpToStep(n)
      await sleep(1000) // let any ghost motion finish
      const ghostBefore = ghost.playCount
      const ticksBefore = audio.tickPlays
      await interactor.tap("BtnReplay")
      print(`[InspectDoneScenario] Replay on ${n}: replayCount ${manager.replayCount}, ghost +${ghost.playCount - ghostBefore}`)
      expect(manager.replayCount, `Replay acted on step ${n}`).toBe(1)
      expect(audio.tickPlays, `tick on Replay at step ${n}`).toBe(ticksBefore + 1)
      if (n === 3 || n === 4) expect(ghost.playCount, `ghost replayed on step ${n}`).toBe(ghostBefore + 1)
    }

    manager.reset()
    await sleep(300)
  }
}
