import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {LeverPlacement} from "../Scripts/LeverPlacement"
import {TubePull} from "../Scripts/TubePull"
import {TubeFit} from "../Scripts/TubeFit"

/**
 * Pass 9, step 8: the halfway card's Continue enters step 8, where both levers
 * go back to the tray, the old tube is gone and the new tube coil (NewTube /
 * NewTubeEnd) waits in the tray. Dragging NewTubeEnd onto ValveSocket refits the
 * SAME eight TubeSeg_i at home and the valve home, and enters step 9. Back from 9
 * hides the segments again and shows the coil.
 */
@component
export class RefitTubeScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const tubeEnd = findSceneObjectByName("TubeEnd")
    const tubePull = tubeEnd.getComponent(TubePull.getTypeName()) as TubePull
    const newTube = findSceneObjectByName("NewTube")
    const newTubeEnd = findSceneObjectByName("NewTubeEnd")
    const socket = findSceneObjectByName("ValveSocket")
    const toolTray = findSceneObjectByName("ToolTray")
    expect(newTube, "NewTube exists").toBeTruthy()
    expect(newTubeEnd, "NewTubeEnd exists").toBeTruthy()
    expect(socket, "ValveSocket exists").toBeTruthy()
    const fit = newTubeEnd.getComponent(TubeFit.getTypeName()) as TubeFit
    expect(fit, "TubeFit on NewTubeEnd").toBeTruthy()
    const leverA = findSceneObjectByName("LeverA").getComponent(LeverPlacement.getTypeName()) as LeverPlacement
    const leverB = findSceneObjectByName("LeverB").getComponent(LeverPlacement.getTypeName()) as LeverPlacement

    // ── Continue on the halfway card enters step 8; levers tween home ──────
    manager.jumpToStep(7)
    await sleep(400)
    expect(findSceneObjectByName("BtnContinue").isEnabledInHierarchy, "Continue on the halfway card").toBe(true)
    await interactor.tap("BtnContinue")
    await sleep(900) // lever tweens home
    expect(manager.getState().step, "Continue enters step 8").toBe(8)

    // ── Step 8 state ────────────────────────────────────────────────────────
    const checkStep8 = (when: string): void => {
      expect(leverA.sceneObject.getParent().name, `lever A back in the tray (${when})`).toBe("ToolTray")
      expect(leverB.sceneObject.getParent().name, `lever B back in the tray (${when})`).toBe("ToolTray")
      print(`[RefitTubeScenario] ${when}: lever A ${leverA.distanceToHome().toFixed(2)} cm, lever B ${leverB.distanceToHome().toFixed(2)} cm from home`)
      expect(leverA.distanceToHome(), `lever A home (${when})`).toBeLessThan(0.5)
      expect(leverB.distanceToHome(), `lever B home (${when})`).toBeLessThan(0.5)
      expect(leverA.isLocked || leverB.isLocked, `levers unlocked (${when})`).toBe(false)
      expect(toolTray.isEnabledInHierarchy, `tray shown (${when})`).toBe(true)
      expect(newTube.isEnabledInHierarchy, `NewTube shown (${when})`).toBe(true)
      expect(newTubeEnd.isEnabledInHierarchy, `NewTubeEnd enabled (${when})`).toBe(true)
      expect(tubePull.enabledSegmentCount(), `old tube segments gone (${when})`).toBe(0)
    }
    checkStep8("after Continue")

    manager.jumpToStep(8)
    await sleep(500)
    expect(manager.getState().step, "jumpToStep(8)").toBe(8)
    checkStep8("after jumpToStep(8)")
    const marker = findSceneObjectByName("StepMarker")
    const markerToSocket = marker.getTransform().getWorldPosition().distance(socket.getTransform().getWorldPosition())
    print(`[RefitTubeScenario] marker ${markerToSocket.toFixed(2)} cm from ValveSocket`)
    expect(markerToSocket, "marker on the valve socket").toBeLessThan(2.0)

    // ── A miss returns the end to the coil ──────────────────────────────────
    const handle = findInteractablesByName("NewTubeEnd", undefined, true)[0]
    expect(handle, "NewTubeEnd interactable enabled").toBeTruthy()
    const socketPos = socket.getTransform().getWorldPosition()
    await interactor.dragTo(handle, socketPos.add(new vec3(12, 0, 0)), 1.0, 8000, 0.5)
    await sleep(800)
    print(`[RefitTubeScenario] after a miss: ${fit.distanceToHome().toFixed(2)} cm from the coil`)
    expect(fit.distanceToHome(), "missed end back on the coil").toBeLessThan(1.0)
    expect(manager.getState().step, "still step 8 after a miss").toBe(8)

    // ── Fit: the same eight segments go back in, valve home, step 9 ─────────
    await interactor.dragTo(handle, socketPos.add(new vec3(1.5, 0, 0)), 1.0, 8000, 0.5)
    // Pass P: the new tube feeds in, in a lighter tone than the tire, stops proud of the
    // tire as a ring, then seats all at once (the seated moment) and takes its own tone back.
    const lum = (c: vec4) => 0.2126 * c.x + 0.7152 * c.y + 0.0722 * c.z
    const tireLum = lum((findSceneObjectByName("Bead_0").getComponent("Component.RenderMeshVisual") as RenderMeshVisual).mainMaterial.mainPass.baseColor)
    const seg0 = () => {
      const t = findSceneObjectByName("Tube")
      for (let c = 0; c < t.getChildrenCount(); c++) if (t.getChild(c).name === "TubeSeg_0") return t.getChild(c)
      return null
    }
    const segLum = () => lum((seg0().getComponent("Component.RenderMeshVisual") as RenderMeshVisual).mainMaterial.mainPass.baseColor)
    const restLum = segLum()
    let lighter = 0
    let sawRing = false
    let sawSeat = false
    for (let i = 0; i < 160 && (tubePull.refitting || manager.getState().step === 8); i++) {
      await sleep(50)
      if (!tubePull.refitting) continue
      if (seg0().enabled && segLum() > Math.max(tireLum, restLum) + 0.1) lighter++
      if (tubePull.enabledSegmentCount() === 8 && tubePull.segmentHomeError() > 0.8 && tubePull["seatElapsed"] < 0) sawRing = true
      if (tubePull["seatElapsed"] >= 0) sawSeat = true
    }
    print(`[RefitTubeScenario] feed: ${lighter} samples lighter than the tire (tire ${tireLum.toFixed(2)}, tube ${restLum.toFixed(2)}), ring ${sawRing}, seat ${sawSeat}`)
    expect(lighter, "the new tube feeds in lighter than the tire").toBeGreaterThan(2)
    expect(sawRing, "the whole new tube stands in front of the tire before it seats").toBe(true)
    expect(sawSeat, "a seated moment: the tube presses into the tire together").toBe(true)
    expect(Math.abs(segLum() - restLum) < 0.02, "the tube's own tone is back once seated").toBe(true)
    await sleep(200)
    print(`[RefitTubeScenario] after fit: ${tubePull.enabledSegmentCount()} segments on, worst ${tubePull.segmentHomeError().toFixed(3)} cm from home, valve ${tubePull.valveHomeError().toFixed(3)} cm`)
    expect(tubePull.enabledSegmentCount(), "all eight TubeSeg_i enabled").toBe(8)
    const tube = findSceneObjectByName("Tube")
    let segs = 0
    for (let c = 0; c < tube.getChildrenCount(); c++) if (tube.getChild(c).name.indexOf("TubeSeg_") === 0) segs++
    expect(segs, "still eight ring objects (reused, none added)").toBe(8)
    expect(tubePull.segmentHomeError(), "every segment within 0.5 cm of home").toBeLessThan(0.5)
    expect(tubePull.valveHomeError(), "valve home").toBeLessThan(0.5)
    expect(findSceneObjectByName("Valve").isEnabledInHierarchy, "valve shown").toBe(true)
    expect(newTube.enabled, "coil hidden once fitted").toBe(false)
    expect(manager.getState().step, "fit enters step 9").toBe(9)

    // ── Back hides them again ───────────────────────────────────────────────
    await interactor.tap("BtnBack")
    await sleep(400)
    expect(manager.getState().step, "Back from 9 lands on 8").toBe(8)
    checkStep8("after Back from 9")

    manager.reset()
    await sleep(300)
  }
}
