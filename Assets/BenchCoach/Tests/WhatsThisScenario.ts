import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {PartInfo} from "../Scripts/PartInfo"
import {LeverPlacement} from "../Scripts/LeverPlacement"
import {BenchCoachControlBarUI} from "../Scripts/BenchCoachControlBarUI"
import {FLAT_CAUSES, PART_FACTS, STEPS} from "../Scripts/StepDefinitions"

/**
 * Pass 8, What's this?: BtnWhatsThis turns the mode on (step interactions paused,
 * toggle latched, prompt on the label); pinching a part's info box puts "Title:
 * fact" on the label next to the part; the cause's box exists only once the cause
 * is found and names it; turning the mode off gives the step back. The switch
 * waits while a lever is held.
 */
@component
export class WhatsThisScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const info = findSceneObjectByName("BenchCoach").getComponent(PartInfo.getTypeName()) as PartInfo
    const bar = findSceneObjectByName("ControlBar").getComponent(BenchCoachControlBarUI.getTypeName()) as BenchCoachControlBarUI
    const leverAObj = findSceneObjectByName("LeverA")
    const leverA = leverAObj.getComponent(LeverPlacement.getTypeName()) as LeverPlacement
    const label = findSceneObjectByName("LabelText").getComponent("Component.Text") as Text
    const labelObj = findSceneObjectByName("StepLabel")
    const valve = findSceneObjectByName("Valve")
    expect(info, "PartInfo script").toBeTruthy()
    const fact = (id: string) => PART_FACTS.filter((f) => f.id === id)[0]

    // ── On: paused, latched, prompt ─────────────────────────────────────────
    manager.jumpToStep(1)
    await sleep(400)
    const valveTarget = valve.getComponent(Interactable.getTypeName()) as Interactable
    expect(valveTarget.enabled, "valve takes pinches on step 1").toBe(true)
    await interactor.tap("BtnWhatsThis")
    await sleep(300)
    expect(info.active, "What's this? on").toBe(true)
    expect(manager.interactionsPaused, "step interactions paused").toBe(true)
    expect(bar.whatsThisOn, "toggle latched").toBe(true)
    expect(valveTarget.enabled, "valve pinch target off while paused").toBe(false)
    expect(label.text, "prompt on the label").toBe(info.promptText)

    // ── Pinch the valve's info box ──────────────────────────────────────────
    await interactor.tap("InfoHit_Valve")
    await sleep(200)
    print(`[WhatsThisScenario] valve: "${label.text}"`)
    expect(info.lastPart, "valve picked").toBe("Valve")
    expect(label.text, "valve fact on the label").toBe(`Valve: ${fact("Valve").fact}`)
    const labelToValve = labelObj.getTransform().getWorldPosition().distance(valve.getTransform().getWorldPosition())
    print(`[WhatsThisScenario] label ${labelToValve.toFixed(1)} cm from the valve`)
    expect(labelToValve, "label next to the valve").toBeLessThan(12)
    expect(manager.getState().step, "still step 1 (the valve pinch did not deflate)").toBe(1)
    expect(findSceneObjectByName("InfoHit_Cause").enabled, "no cause box before the cause is found").toBe(false)

    await interactor.tap("InfoHit_Hub")
    await sleep(200)
    expect(info.lastPart, "hub picked").toBe("Hub")

    // ── Off: the step comes back ───────────────────────────────────────────
    await interactor.tap("BtnWhatsThis")
    await sleep(300)
    expect(info.active, "What's this? off").toBe(false)
    expect(manager.interactionsPaused, "interactions back").toBe(false)
    expect(bar.whatsThisOn, "toggle released").toBe(false)
    expect(valveTarget.enabled, "valve takes pinches again").toBe(true)
    expect(label.text, "step 1 label back").toBe(STEPS[1].label)
    expect(findSceneObjectByName("InfoHits").enabled, "info boxes hidden").toBe(false)

    // ── Levers: their boxes follow them; snapping is off while paused ──────
    manager.jumpToStep(3)
    await sleep(400)
    info.setActive(true)
    await sleep(200)
    expect(leverA.snapEnabled, "lever A snap off while paused").toBe(false)
    await interactor.tap("InfoHit_LeverA")
    await sleep(200)
    expect(info.lastPart, "lever picked").toBe("LeverA")
    const boxToLever = findSceneObjectByName("InfoHit_LeverA").getTransform().getWorldPosition().distance(leverAObj.getTransform().getWorldPosition())
    expect(boxToLever, "lever box on the lever").toBeLessThan(0.1)
    info.setActive(false)
    await sleep(200)
    expect(leverA.snapEnabled, "lever A snaps again").toBe(true)

    // ── The switch waits while a lever is held ─────────────────────────────
    leverA.grabbed = true
    info.setActive(true)
    await sleep(200)
    expect(info.active, "not switched while lever A is held").toBe(false)
    expect(info.wanted, "request kept").toBe(true)
    leverA.grabbed = false
    await sleep(200)
    expect(info.active, "switched once lever A is let go").toBe(true)
    info.setActive(false)
    await sleep(200)

    // ── The cause's box once found (halfway card: label hidden normally) ───
    manager.forceCause = "glass"
    manager.jumpToStep(7)
    await sleep(400)
    expect(labelObj.enabled, "no step label on the halfway card").toBe(false)
    await interactor.tap("BtnWhatsThis")
    await sleep(300)
    expect(labelObj.enabled, "prompt shown on the halfway card").toBe(true)
    await interactor.tap("InfoHit_Cause")
    await sleep(200)
    print(`[WhatsThisScenario] cause: "${label.text}"`)
    expect(label.text, "cause fact names the glass").toBe("Cause: a sliver cut through the tread.")
    expect(FLAT_CAUSES.glass.fact.indexOf("sliver") >= 0, "fact comes from FLAT_CAUSES").toBe(true)
    await interactor.tap("BtnWhatsThis")
    await sleep(300)
    expect(labelObj.enabled, "label hidden again on the halfway card").toBe(false)

    manager.forceCause = ""
    manager.reset()
    await sleep(300)
  }
}
