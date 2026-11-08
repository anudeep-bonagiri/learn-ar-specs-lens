import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, countEnabledByName, getRepairManager} from "./BenchCoachLeafInteractor"
import {ScanReveal} from "../Scripts/ScanReveal"
import {PREVIEW_NOTE} from "../Scripts/BenchCoachStartCardUI"

/**
 * Criterion 1: pinching Found it places the wheel in the stand and step 1's
 * marker sits on the valve. Pass G4 (on D2 in pass M): the scan reveal plays as the
 * wheel appears (the outline tracing up both sides, Rim, Valve and Hub labels on once the
 * heads meet, everything gone after the hold and fade) without holding step 1 up.
 */
@component
export class StartScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    manager.reset()
    await sleep(300)

    const wheel = findSceneObjectByName("Wheel")
    const stand = findSceneObjectByName("Stand")
    const startCard = findSceneObjectByName("StartCard")
    const marker = findSceneObjectByName("StepMarker")
    const valve = findSceneObjectByName("Valve")
    expect(wheel, "Wheel exists").toBeTruthy()
    expect(stand, "Stand exists").toBeTruthy()
    expect(startCard, "StartCard exists").toBeTruthy()
    expect(marker, "StepMarker exists").toBeTruthy()
    expect(valve, "Valve exists").toBeTruthy()
    // Pass D2: no debug text on the card (the stand-in note is logged); a floor status line instead.
    expect(findSceneObjectByName("StandInBadge"), "no stand-in badge on the start card").toBeFalsy()
    const floorLine = (findSceneObjectByName("FloorStatus").getComponent("Component.Text") as Text).text
    print(`[StartScenario] floor line: "${floorLine}"`)
    expect(
      ["Look down at your work spot", "Floor found", "Using a standard floor height"].indexOf(floorLine) >= 0,
      "floor line shows the floor status"
    ).toBe(true)

    // Pass B: in the editor the card says what Found it does there; on Specs the row is not built.
    const previewNote = findSceneObjectByName("PreviewNote")
    if (global.deviceInfoSystem.isEditor()) {
      expect(previewNote && previewNote.isEnabledInHierarchy, "the preview line shows in the editor").toBe(true)
      const noteText = (previewNote.getComponent("Component.Text") as Text).text
      print(`[StartScenario] preview line: "${noteText}"`)
      expect(noteText, "the preview line's text").toBe(PREVIEW_NOTE)
    } else {
      expect(previewNote, "no preview line on device").toBeFalsy()
    }
    expect(manager.getState().step, "starts at step 0").toBe(0)
    expect(wheel.enabled, "Wheel hidden before Found it").toBe(false)
    expect(stand.enabled, "Stand hidden before Found it").toBe(false)
    expect(startCard.enabled, "StartCard visible at step 0").toBe(true)
    expect(marker.enabled, "StepMarker hidden at step 0").toBe(false)

    const interactor = new BenchCoachLeafInteractor()
    await interactor.tap("BtnFoundIt")
    await sleep(300)

    const state = manager.getState()
    expect(state.step, "step is 1 after Found it").toBe(1)
    expect(state.startTime, "timer started").toBeGreaterThan(0)
    expect(wheel.enabled, "Wheel enabled").toBe(true)
    expect(stand.enabled, "Stand enabled").toBe(true)
    expect(startCard.enabled, "StartCard hidden").toBe(false)
    expect(marker.enabled, "StepMarker enabled").toBe(true)
    expect(countEnabledByName("StepMarker"), "exactly one StepMarker enabled").toBe(1)

    const wheelPos = wheel.getTransform().getWorldPosition()
    expect(wheelPos.z, "wheel is ahead of the user (negative z)").toBeLessThan(-60)
    const markerToValve = marker.getTransform().getWorldPosition().distance(valve.getTransform().getWorldPosition())
    print(`[StartScenario] marker to valve ${markerToValve.toFixed(2)} cm`)
    expect(markerToValve, "marker within 2 cm of the valve").toBeLessThan(2.0)
    expect(findSceneObjectByName("StepLabel").enabled, "StepLabel visible").toBe(true)

    // ── Scan reveal (pass G4) ─────────────────────────────────────────────
    const scanObj = findSceneObjectByName("ScanReveal")
    expect(scanObj, "ScanReveal exists").toBeTruthy()
    const scan = scanObj.getComponent(ScanReveal.getTypeName()) as ScanReveal
    expect(scan.playing, "scan plays on Found it").toBe(true)
    expect(scan.phase, "scan is tracing 0.3 s in").toBe("sweep")
    expect(findSceneObjectByName("ScanOutline").enabled, "outline visible").toBe(true)
    expect(scan.litSegments > 0 && scan.litSegments < 120, "outline part-way round").toBe(true)
    await sleep(scan.sweepSec * 1000 + 400)
    expect(scan.phase, "heads met: holding").toBe("hold")
    expect(scan.litSegments, "the outline is closed round the tire").toBe(120)
    expect(scan.labelsShown, "Rim, Valve and Hub labels on after the heads meet").toBe(3)
    expect(findSceneObjectByName("ScanLabel_Valve").enabled, "Valve label on").toBe(true)
    expect(findSceneObjectByName("ScanLabel_Rim").enabled, "Rim label on").toBe(true)
    expect(findSceneObjectByName("ScanLabel_Hub").enabled, "Hub label on").toBe(true)
    expect(manager.getState().step, "step 1 ran underneath").toBe(1)
    await sleep((scan.holdSec + scan.fadeSec) * 1000 + 300)
    expect(scan.playing, "scan over after hold and fade").toBe(false)
    expect(findSceneObjectByName("ScanLabel_Valve").enabled, "labels gone").toBe(false)
    expect(findSceneObjectByName("ScanOutline").enabled, "outline gone").toBe(false)
  }
}
