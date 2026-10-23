import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {BenchCoachLeafInteractor, countEnabledByName, getRepairManager} from "./BenchCoachLeafInteractor"
import {LeverPlacement} from "../Scripts/LeverPlacement"
import {RimDrag} from "../Scripts/RimDrag"
import {TubePull} from "../Scripts/TubePull"
import {EdgeHint} from "../Scripts/EdgeHint"

/**
 * Criterion 4: lever B snaps to the second socket, dragging it ~90 degrees along
 * the rim peels Bead_1 and Bead_2 (each raised 1 cm radially) and enters step 5;
 * the step-5 marker sits on TubeEnd (6 o'clock) and, because the default camera
 * faces the valve, the EdgeArrow is on; pulling TubeEnd 15 cm past the rim
 * slides every TubeSeg_i out of the tire and enters step 6.
 */
@component
export class PeelAndPullScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    manager.jumpToStep(4)
    await sleep(1000) // ghost hook animation at socket B

    expect(manager.getState().step, "jumpToStep landed on step 4").toBe(4)
    const wheel = findSceneObjectByName("Wheel")
    const socketB = findSceneObjectByName("LeverSocketB")
    const ghost = findSceneObjectByName("GhostLever")
    const bead1 = findSceneObjectByName("Bead_1")
    const bead2 = findSceneObjectByName("Bead_2")
    const marker = findSceneObjectByName("StepMarker")
    const tubeEnd = findSceneObjectByName("TubeEnd")
    const edgeArrow = findSceneObjectByName("EdgeArrow")
    expect(socketB, "LeverSocketB exists").toBeTruthy()
    expect(edgeArrow, "EdgeArrow exists").toBeTruthy()
    expect(ghost.enabled, "ghost visible at socket B").toBe(true)
    const ghostToSocketB = ghost.getTransform().getWorldPosition().distance(socketB.getTransform().getWorldPosition())
    expect(ghostToSocketB, "ghost animated onto socket B").toBeLessThan(0.5)

    const interactor = new BenchCoachLeafInteractor()

    // ── Hook lever B ────────────────────────────────────────────────────────
    const lever = findInteractablesByName("LeverB", undefined, true)[0]
    expect(lever, "LeverB interactable enabled").toBeTruthy()
    const leverObj = lever.getSceneObject()
    const placement = leverObj.getComponent(LeverPlacement.getTypeName()) as LeverPlacement
    const rimDrag = leverObj.getComponent(RimDrag.getTypeName()) as RimDrag
    expect(placement, "LeverPlacement on LeverB").toBeTruthy()
    expect(rimDrag, "RimDrag on LeverB").toBeTruthy()
    const socketPos = socketB.getTransform().getWorldPosition()
    await interactor.dragTo(lever, socketPos.add(new vec3(1.5, 0, 0)), 1.0, 8000, 0.5)
    await sleep(800)
    const toSocket = leverObj.getTransform().getWorldPosition().distance(socketPos)
    print(`[PeelAndPullScenario] lever B after snap: ${toSocket.toFixed(2)} cm from socket B`)
    expect(toSocket, "lever B sits on socket B").toBeLessThan(0.5)
    expect(placement.isLocked, "lever B locked").toBe(true)
    expect(ghost.enabled, "ghost hidden after hooking lever B").toBe(false)
    expect(rimDrag.armed, "rim drag armed").toBe(true)
    expect(manager.getState().step, "still step 4 after hooking").toBe(4)

    // ── Slide it round: waypoints on the rim circle up to 3 o'clock ─────────
    const bead1Before = bead1.getTransform().getWorldPosition()
    const bead2Before = bead2.getTransform().getWorldPosition()
    const wheelMat = wheel.getTransform().getWorldTransform()
    const socketLocal = wheel.getTransform().getInvertedWorldTransform().multiplyPoint(socketPos)
    const radius = Math.sqrt(socketLocal.x * socketLocal.x + socketLocal.y * socketLocal.y)
    const onRim = (deg: number): vec3 => {
      const a = (deg * Math.PI) / 180
      return wheelMat.multiplyPoint(new vec3(Math.sin(a) * radius, Math.cos(a) * radius, socketLocal.z))
    }
    for (const deg of [35, 50, 65, 80, 90]) {
      await interactor.dragTo(lever, onRim(deg), 1.0, 4000, 1.5)
      print(`[PeelAndPullScenario] waypoint ${deg}: lever at ${rimDrag.currentAngleDeg.toFixed(1)} deg`)
      await sleep(150)
    }
    await sleep(500)
    expect(rimDrag.complete, "rim drag reached 3 o'clock").toBe(true)
    const lift1 = bead1.getTransform().getWorldPosition().sub(bead1Before).length
    const lift2 = bead2.getTransform().getWorldPosition().sub(bead2Before).length
    print(`[PeelAndPullScenario] Bead_1 lift ${lift1.toFixed(2)} cm, Bead_2 lift ${lift2.toFixed(2)} cm`)
    expect(lift1, "Bead_1 raised 1 cm").toBeCloseTo(1.0, 1)
    expect(lift2, "Bead_2 raised 1 cm").toBeCloseTo(1.0, 1)
    expect(manager.getPeeledBeads().length, "two beads peeled").toBe(2)
    expect(manager.getState().step, "advanced to step 5").toBe(5)

    // ── Far-side marker and edge arrow ──────────────────────────────────────
    await sleep(300)
    expect(countEnabledByName("StepMarker"), "exactly one StepMarker enabled").toBe(1)
    const markerToTubeEnd = marker.getTransform().getWorldPosition().distance(tubeEnd.getTransform().getWorldPosition())
    print(`[PeelAndPullScenario] marker to TubeEnd ${markerToTubeEnd.toFixed(2)} cm`)
    expect(markerToTubeEnd, "marker within 2 cm of TubeEnd").toBeLessThan(2.0)
    const edgeHint = findSceneObjectByName("BenchCoach").getComponent(EdgeHint.getTypeName()) as EdgeHint
    expect(edgeHint, "EdgeHint on BenchCoach").toBeTruthy()
    expect(edgeArrow.enabled, "EdgeArrow on while the camera faces the valve").toBe(true)
    expect(edgeHint.arrowVisible, "EdgeHint reports the arrow visible").toBe(true)

    // ── Pull the tube out ───────────────────────────────────────────────────
    const tube = findSceneObjectByName("Tube")
    const segments: SceneObject[] = []
    const starts: vec3[] = []
    for (let c = 0; c < tube.getChildrenCount(); c++) {
      const child = tube.getChild(c)
      if (child.name.indexOf("TubeSeg_") === 0) {
        segments.push(child)
        starts.push(child.getTransform().getWorldPosition())
      }
    }
    expect(segments.length, "eight tube segments").toBe(8)
    const tubePull = tubeEnd.getComponent(TubePull.getTypeName()) as TubePull
    expect(tubePull, "TubePull on TubeEnd").toBeTruthy()
    expect(tubePull.armed, "tube pull armed in step 5").toBe(true)
    const tubeEndInteractable = findInteractablesByName("TubeEnd", undefined, true)[0]
    expect(tubeEndInteractable, "TubeEnd interactable enabled").toBeTruthy()
    const endStart = tubeEnd.getTransform().getWorldPosition()
    const center = wheel.getTransform().getWorldPosition()
    const outward = endStart.sub(center).normalize()
    await interactor.dragTo(tubeEndInteractable, endStart.add(outward.uniformScale(17.5)), 1.0, 8000, 3.0)
    await sleep(2500) // staggered segment tweens + valve lift
    expect(tubePull.pulled, "tube pulled").toBe(true)
    const wheelCenter = wheel.getTransform().getWorldPosition()
    for (let i = 0; i < segments.length; i++) {
      const p = segments[i].getTransform().getWorldPosition()
      const moved = p.distance(starts[i])
      const fromCenter = p.distance(wheelCenter)
      expect(fromCenter > 35 || moved > 10, `${segments[i].name} outside the tire (moved ${moved.toFixed(1)} cm)`).toBe(true)
    }
    expect(manager.getState().step, "advanced to step 6").toBe(6)
  }
}
