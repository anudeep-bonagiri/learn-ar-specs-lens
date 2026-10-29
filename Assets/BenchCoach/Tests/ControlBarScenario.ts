import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {Button} from "SpectaclesUIKit.lspkg/Scripts/Components/Button/Button"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {TargetingMode} from "SpectaclesInteractionKit.lspkg/Core/Interactor/Interactor"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {BenchCoachControlBarUI} from "../Scripts/BenchCoachControlBarUI"
import {PartInfo} from "../Scripts/PartInfo"
import {AskCoach} from "../Scripts/AskCoach"

/**
 * Pass F: the control bar's hit boxes and targeting.
 * - Every bar button's live collider is as wide as its visual and none overlaps
 *   its neighbor (Next is 6 cm, the rest 3.9 cm, 0.5 cm gaps).
 * - Every initialized UIKit button answers only a ray pinch (TargetingMode.Indirect),
 *   so a hand passing through cannot poke it; the grabbable tools and wheel parts
 *   keep direct targeting.
 * - Replay keeps the step and says what it replayed; each bar button acts alone
 *   (Back and Next move one step, What's this? and Ask toggle only their mode).
 * The hand pass-through itself is not simulated here (LEAF's interactor does not
 * travel through space); see the pass F notes for the preview-hand check.
 */
@component
export class ControlBarScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    manager.reset()
    await sleep(300)
    const bar = findSceneObjectByName("ControlBar").getComponent(BenchCoachControlBarUI.getTypeName()) as BenchCoachControlBarUI
    const info = findSceneObjectByName("BenchCoach").getComponent(PartInfo.getTypeName()) as PartInfo
    const ask = findSceneObjectByName("BenchCoach").getComponent(AskCoach.getTypeName()) as AskCoach
    expect(bar, "BenchCoachControlBarUI on ControlBar").toBeTruthy()

    // ── Hit boxes ─────────────────────────────────────────────────────────
    for (let i = 0; i < 50 && bar.hitBoxes.length === 0; i++) await sleep(100)
    expect(bar.hitBoxes.length, "five hit boxes measured").toBe(5)
    for (let i = 0; i < bar.hitBoxes.length; i++) {
      const h = bar.hitBoxes[i]
      const w = h.right - h.left
      print(`[ControlBarScenario] ${h.name} ${h.left.toFixed(2)}..${h.right.toFixed(2)} (visual ${h.visualWidth.toFixed(2)})`)
      expect(Math.abs(w - h.visualWidth), `${h.name} hit box as wide as its visual`).toBeLessThan(0.05)
      if (i + 1 < bar.hitBoxes.length) {
        expect(bar.hitBoxes[i + 1].left - h.right, `${h.name} clear of ${bar.hitBoxes[i + 1].name}`).toBeGreaterThan(0.4)
      }
    }
    expect(bar.hitBoxesClear, "bar reports its hit boxes clear").toBe(true)

    // ── Targeting: UI buttons ray only, tools and wheel parts direct ──────
    const buttons: Button[] = []
    const walk = (o: SceneObject) => {
      for (const b of o.getComponents(Button.getTypeName()) as Button[]) buttons.push(b)
      for (let i = 0; i < o.getChildrenCount(); i++) walk(o.getChild(i))
    }
    for (let i = 0; i < global.scene.getRootObjectsCount(); i++) walk(global.scene.getRootObject(i))
    const live = buttons.filter((b) => b.initialized)
    expect(live.length, "bar and start card buttons are up").toBeGreaterThan(6)
    for (const b of live) {
      expect(b.interactable.targetingMode, `${b.getSceneObject().name} answers only a ray pinch`).toBe(TargetingMode.Indirect)
    }
    print(`[ControlBarScenario] ${live.length} UI buttons ray-only: ${live.map((b) => b.getSceneObject().name).join(", ")}`)
    for (const name of ["LeverA", "LeverB", "TubeEnd", "NewTubeEnd", "Valve"]) {
      const so = findSceneObjectByName(name)
      expect(so, `${name} exists`).toBeTruthy()
      const it = so.getComponent(Interactable.getTypeName()) as Interactable
      expect(it, `${name} has an Interactable`).toBeTruthy()
      expect((it.targetingMode & TargetingMode.Direct) !== 0, `${name} still takes a direct pinch`).toBe(true)
    }

    // ── Each bar button acts alone; Replay keeps the step ─────────────────
    const interactor = new BenchCoachLeafInteractor()
    manager.jumpToStep(4)
    await sleep(300)
    expect(manager.getState().step, "on step 4").toBe(4)
    await interactor.tap("BtnReplay")
    print(`[ControlBarScenario] Replay on step 4: ${manager.lastReplay} (count ${manager.replayCount})`)
    expect(manager.getState().step, "Replay keeps step 4").toBe(4)
    expect(manager.replayCount, "Replay acted once").toBe(1)
    expect(manager.lastReplay.indexOf("ghost") >= 0, "Replay showed the ghost lever on step 4").toBe(true)

    await interactor.tap("BtnWhatsThis")
    expect(info.active, "What's this? on").toBe(true)
    expect(manager.getState().step, "What's this? keeps the step").toBe(4)
    await interactor.tap("BtnWhatsThis")
    expect(info.active, "What's this? off").toBe(false)

    await interactor.tap("BtnAsk")
    expect(ask.open, "Ask open").toBe(true)
    expect(info.active, "Ask did not turn What's this? on").toBe(false)
    expect(manager.getState().step, "Ask keeps the step").toBe(4)
    await interactor.tap("BtnAsk")
    expect(ask.open, "Ask closed").toBe(false)

    await interactor.tap("BtnBack")
    expect(manager.getState().step, "Back moves one step").toBe(3)
    await interactor.tap("BtnNext")
    expect(manager.getState().step, "Next moves one step").toBe(4)

    manager.reset()
    await sleep(300)
  }
}
