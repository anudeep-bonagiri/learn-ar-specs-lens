import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {ThornHotspot} from "../Scripts/ThornHotspot"
import {FLAT_CAUSE_IDS, FLAT_CAUSES, LAST_STEP} from "../Scripts/StepDefinitions"

/**
 * Pass 8, flat causes (always forced; randomness is never asserted): for thorn,
 * glass and snakebite the hotspot sits at the cause's angle in the tire, the
 * pinch reveals the cause's shape and label, the ring lands on it, and the Finish
 * card names the cause and its tip. With no force, reset and jumpToStep use the
 * thorn at 120 degrees (the existing scenarios rely on it).
 */
@component
export class FlatCausesScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const hotspotObj = findSceneObjectByName("ThornHotspot")
    const hotspot = hotspotObj.getComponent(ThornHotspot.getTypeName()) as ThornHotspot
    const wheel = findSceneObjectByName("Wheel")
    const marker = findSceneObjectByName("StepMarker")
    const label = findSceneObjectByName("LabelText").getComponent("Component.Text") as Text
    const shapeObj: {[shape: string]: string} = {spike: "Thorn", shard: "Shard", dots: "Bite"}
    const savedForce = manager.forceCause

    try {
      for (const id of FLAT_CAUSE_IDS) {
        const cause = FLAT_CAUSES[id]
        manager.forceCause = id
        manager.jumpToStep(6)
        await sleep(500)
        expect(manager.getCause(), `${id}: forced cause`).toBe(id)
        expect(hotspot.causeId, `${id}: hotspot cause`).toBe(id)
        expect(hotspot.currentAngleDeg, `${id}: angle`).toBe(cause.angleDeg)
        // Clockwise angle of the hotspot round the wheel, measured in the wheel's space.
        const local = wheel.getTransform().getInvertedWorldTransform().multiplyPoint(hotspotObj.getTransform().getWorldPosition())
        let measured = (Math.atan2(local.x, local.y) * 180) / Math.PI
        if (measured < 0) measured += 360
        print(`[FlatCausesScenario] ${id}: hotspot at ${measured.toFixed(1)} deg`)
        expect(Math.abs(measured - cause.angleDeg), `${id}: hotspot at ${cause.angleDeg} deg`).toBeLessThan(1)
        expect(hotspot.armed, `${id}: glint armed`).toBe(true)

        await interactor.tap("ThornHotspot")
        await sleep(200)
        expect(hotspot.found, `${id}: found`).toBe(true)
        expect(label.text, `${id}: found label`).toBe(cause.foundLabel)
        for (const shape of Object.keys(shapeObj)) {
          const so = findSceneObjectByName(shapeObj[shape])
          expect(so.enabled, `${id}: ${shapeObj[shape]} ${shape === cause.shape ? "shown" : "hidden"}`).toBe(shape === cause.shape)
        }
        const ring = marker.getTransform().getWorldPosition().distance(hotspotObj.getTransform().getWorldPosition())
        expect(ring, `${id}: ring on the cause`).toBeLessThan(2.0)
        await sleep(2800)
        expect(manager.getState().step, `${id}: halfway card after the reveal`).toBe(7)

        manager.jumpToStep(LAST_STEP)
        await sleep(400)
        const causeText = (findSceneObjectByName("FinishCause").getComponent("Component.Text") as Text).text
        const tipText = (findSceneObjectByName("FinishTip").getComponent("Component.Text") as Text).text
        print(`[FlatCausesScenario] ${id}: finish "${causeText}" / "${tipText}"`)
        // Pass D2: "Cause" is the row label; the value is the cause, capitalized.
        expect(causeText, `${id}: Finish card names the cause`).toBe(cause.label.charAt(0).toUpperCase() + cause.label.substring(1))
        expect(tipText, `${id}: Finish card tip`).toBe(`Next time: ${cause.tip}`)
      }

      // ── Unforced: reset and jumpToStep fall back to the thorn at 120 ─────
      manager.forceCause = ""
      manager.jumpToStep(6)
      await sleep(300)
      expect(manager.getCause(), "default cause after jumpToStep").toBe("thorn")
      expect(hotspot.currentAngleDeg, "thorn at 120").toBe(120)
      // Found it picks some cause (any of the three; which one is not asserted).
      manager.reset()
      await sleep(200)
      await interactor.tap("BtnFoundIt")
      expect(FLAT_CAUSE_IDS.indexOf(manager.getCause()) >= 0, "Found it picks a known cause").toBe(true)
    } finally {
      manager.forceCause = savedForce
      manager.reset()
      await sleep(300)
    }
  }
}
