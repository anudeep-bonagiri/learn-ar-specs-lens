import {BenchCoachInfoCalloutUI} from "../Scripts/BenchCoachInfoCalloutUI"
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
    // Pass D2: prompt and facts show on the info callout; the step callout keeps its instruction.
    const infoObj = findSceneObjectByName("InfoCallout")
    const infoTitle = findSceneObjectByName("InfoTitle").getComponent("Component.Text") as Text
    const infoLine = findSceneObjectByName("InfoLine").getComponent("Component.Text") as Text
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
    expect(infoObj.enabled, "info callout shown").toBe(true)
    expect(infoTitle.text, "prompt on the info callout").toBe(info.promptText)
    expect(infoLine.text, "prompt line on the info callout").toBe(info.promptLine)
    expect(label.text, "the step callout keeps its instruction").toBe(STEPS[1].label)

    // ── Pinch the valve's info box ──────────────────────────────────────────
    await interactor.tap("InfoHit_Valve")
    await sleep(200)
    print(`[WhatsThisScenario] valve: "${infoTitle.text}: ${infoLine.text}"`)
    expect(info.lastPart, "valve picked").toBe("Valve")
    expect(info.lastText, "valve fact").toBe(`Valve: ${fact("Valve").fact}`)
    expect(infoTitle.text, "valve name on the info callout").toBe("Valve")
    expect(infoLine.text.toLowerCase(), "valve fact on the info callout").toBe(fact("Valve").fact.toLowerCase())
    expect(label.text, "the step callout still shows step 1").toBe(STEPS[1].label)
    // Beside the valve when the valve is in view; otherwise it slides into view (never cut off).
    const camera = findSceneObjectByName("Camera Object").getComponent("Component.Camera") as Camera
    const vs = camera.worldSpaceToScreenSpace(valve.getTransform().getWorldPosition())
    const is = camera.worldSpaceToScreenSpace(infoObj.getTransform().getWorldPosition())
    const infoToValve = infoObj.getTransform().getWorldPosition().distance(valve.getTransform().getWorldPosition())
    const valveInView = vs.x > 0 && vs.x < 1 && vs.y > 0 && vs.y < 1
    print(`[WhatsThisScenario] info callout ${infoToValve.toFixed(1)} cm from the valve; valve ${valveInView ? "in" : "out of"} view; card at screen (${is.x.toFixed(2)}, ${is.y.toFixed(2)})`)
    // Pass P: the card now keeps off the valve, its ring and the step callout, so "beside" is
    // measured from the card's side (centre distance less half its width), not its centre.
    const infoComp = infoObj.getComponent(BenchCoachInfoCalloutUI.getTypeName()) as BenchCoachInfoCalloutUI
    const edgeToValve = infoToValve - infoComp.panelWidth / 2
    print(`[WhatsThisScenario] card side ${edgeToValve.toFixed(1)} cm from the valve`)
    if (valveInView) expect(edgeToValve, "info callout beside the valve (its side within 15 cm)").toBeLessThan(15)
    expect(is.x > 0.05 && is.x < 0.95 && is.y > 0.05 && is.y < 0.95, "info callout inside the view").toBe(true)
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
    expect(infoObj.enabled, "info callout hidden").toBe(false)

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
    expect(infoObj.enabled, "prompt shown on the halfway card").toBe(true)
    expect(labelObj.enabled, "the step callout stays hidden on the card").toBe(false)
    await interactor.tap("InfoHit_Cause")
    await sleep(200)
    print(`[WhatsThisScenario] cause: "${info.lastText}"`)
    expect(info.lastText, "cause fact names the glass").toBe("Cause: a sliver cut through the tread.")
    expect(infoTitle.text, "cause on the info callout").toBe("Cause")
    expect(FLAT_CAUSES.glass.fact.indexOf("sliver") >= 0, "fact comes from FLAT_CAUSES").toBe(true)
    await interactor.tap("BtnWhatsThis")
    await sleep(300)
    expect(labelObj.enabled, "label hidden again on the halfway card").toBe(false)
    expect(infoObj.enabled, "info callout hidden again").toBe(false)

    manager.forceCause = ""
    manager.reset()
    await sleep(300)
  }
}
