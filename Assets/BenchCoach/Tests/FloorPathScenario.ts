import {BenchCoachStepLabelUI} from "../Scripts/BenchCoachStepLabelUI"
import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {WorkspaceAnchor} from "../Scripts/WorkspaceAnchor"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {FloorPath} from "../Scripts/FloorPath"
import {RepairDirector} from "../Scripts/RepairDirector"
import {FloorLevel} from "../Scripts/FloorLevel"
import {WheelStand} from "../Scripts/WheelStand"

/**
 * Pass 11 (feature E): the floor path. Hidden on step 4; a forward entry into step 5
 * shows at least six arrows on the floor mat at the measured floor, all clear of the
 * stand's tripod, curving round the wheel's right side (+X) and ending
 * behind the wheel. Moving the camera to the far spot (the Camera Object's world
 * position is set from the scenario and held there; see the log line) sets `arrived`
 * and hides the path without completing the step. Next from step 5 hides it, Back
 * into step 5 keeps it hidden, and watch mode never shows it.
 */
@component
export class FloorPathScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const pathObj = findSceneObjectByName("FloorPath")
    expect(pathObj, "Environment/FloorPath exists").toBeTruthy()
    expect(pathObj.getParent() && pathObj.getParent().name === "Environment", "FloorPath under Environment").toBe(true)
    const path = pathObj.getComponent(FloorPath.getTypeName()) as FloorPath
    const director = root.getComponent(RepairDirector.getTypeName()) as RepairDirector
    expect(path, "FloorPath component").toBeTruthy()
    expect(director, "RepairDirector on BenchCoach").toBeTruthy()

    // ── Step 4: hidden ──────────────────────────────────────────────────────
    manager.jumpToStep(4)
    await sleep(600)
    expect(manager.getState().step, "on step 4").toBe(4)
    expect(path.visible, "path hidden on step 4").toBe(false)
    expect(this.shownArrows(pathObj), "no arrow enabled on step 4").toBe(0)

    // ── Step 5: visible ─────────────────────────────────────────────────────
    manager.jumpToStep(5)
    await sleep(600)
    const shown = this.shownArrows(pathObj)
    print(`[FloorPathScenario] step 5: visible ${path.visible}, arrows ${shown} of ${path.builtCount}`)
    expect(path.visible, "path visible on step 5").toBe(true)
    expect(path.arrived, "not arrived on entry").toBe(false)
    expect(shown, "at least 6 arrows shown").toBeGreaterThan(5)
    this.checkLayout(path)
    // Pass P: from the near side the far-side callout would be read through the spokes:
    // only the path (and the edge arrow) send the user round.
    const callout = findSceneObjectByName("StepLabel").getComponent(BenchCoachStepLabelUI.getTypeName()) as BenchCoachStepLabelUI
    expect(callout.throughWheel, "step 5 callout hidden from the near side").toBe(true)

    // ── Arrive at the far spot ──────────────────────────────────────────────
    const camObj = findSceneObjectByName("Camera Object")
    const camTr = camObj.getTransform()
    const camHome = camTr.getWorldPosition()
    const camRot = camTr.getWorldRotation()
    const far = path.farSpotWorld()
    const goal = new vec3(far.x, camHome.y, far.z)
    let held = 0
    const end = getTime() + 4
    while (getTime() < end && !path.arrived) {
      camTr.setWorldPosition(goal)
      await sleep(50)
      const p = camTr.getWorldPosition()
      if (Math.abs(p.x - goal.x) < 1 && Math.abs(p.z - goal.z) < 1) held++
    }
    const camNow = camTr.getWorldPosition()
    print(
      `[FloorPathScenario] camera set to (${goal.x.toFixed(1)}, ${goal.y.toFixed(1)}, ${goal.z.toFixed(1)}), ` +
        `reads (${camNow.x.toFixed(1)}, ${camNow.y.toFixed(1)}, ${camNow.z.toFixed(1)}), held ${held} polls; arrived ${path.arrived}`
    )
    expect(path.arrived, "arrived at the far spot").toBe(true)
    expect(path.visible, "path hidden on arrival").toBe(false)
    expect(this.shownArrows(pathObj), "no arrow enabled after arrival").toBe(0)
    expect(manager.getState().step, "arrival does not complete step 5").toBe(5)
    // The preview puts the camera back every frame, so hold it at the far spot for a second
    // and read the callout in those frames.
    let fullAtFar = 0
    const holdEnd = getTime() + 1
    while (getTime() < holdEnd) {
      camTr.setWorldPosition(goal)
      await sleep(30)
      if (!callout.throughWheel && callout.leaderFrom !== null) fullAtFar++
    }
    print(`[FloorPathScenario] at the far spot: full callout with its leader in ${fullAtFar} polls`)
    expect(fullAtFar, "the full callout (with its leader) is in at the far spot").toBeGreaterThan(0)
    camTr.setWorldPosition(camHome)
    camTr.setWorldRotation(camRot)
    await sleep(300)

    // ── Next from step 5 hides it ───────────────────────────────────────────
    manager.jumpToStep(5)
    await sleep(500)
    expect(path.visible, "visible again on a fresh step 5").toBe(true)
    await interactor.tap("BtnNext")
    await sleep(300)
    expect(manager.getState().step, "Next to step 6").toBe(6)
    expect(path.visible, "hidden after Next").toBe(false)

    // ── Back into step 5 keeps it hidden ────────────────────────────────────
    await interactor.tap("BtnBack")
    await sleep(300)
    expect(manager.getState().step, "Back to step 5").toBe(5)
    expect(path.visible, "hidden after Back into step 5").toBe(false)

    // ── Watch mode never shows it ───────────────────────────────────────────
    manager.jumpToStep(4)
    await sleep(500)
    director.play()
    let everVisible = false
    let sawStep5 = false
    const wEnd = getTime() + 40
    while (getTime() < wEnd && manager.getState().step < 6) {
      if (manager.getState().step === 5) sawStep5 = true
      if (path.visible || this.shownArrows(pathObj) > 0) everVisible = true
      await sleep(100)
    }
    print(`[FloorPathScenario] watch: reached step ${manager.getState().step}, saw step 5 ${sawStep5}, ever visible ${everVisible}`)
    director.stop()
    expect(sawStep5, "watch mode passed through step 5").toBe(true)
    expect(manager.getState().step >= 6, "watch mode pulled the tube").toBe(true)
    expect(everVisible, "path never visible in watch mode").toBe(false)

    manager.reset()
    await sleep(300)
  }

  private shownArrows(pathObj: SceneObject): number {
    let n = 0
    for (let i = 0; i < pathObj.getChildrenCount(); i++) {
      const c = pathObj.getChild(i)
      if (c.name.indexOf("PathArrow_") === 0 && c.isEnabledInHierarchy) n++
    }
    return n
  }

  /** Arrows on the mat at the measured floor, clear of the stand's tripod, round the right side, ending behind the wheel. */
  private checkLayout(path: FloorPath): void {
    const floorLevel = findSceneObjectByName("FloorLevel").getComponent(FloorLevel.getTypeName()) as FloorLevel
    const matTop = floorLevel.currentFloorY() + 0.5
    const stand = findSceneObjectByName("Stand").getComponent(WheelStand.getTypeName()) as WheelStand
    const base = findSceneObjectByName("StandBase").getTransform().getWorldPosition()
    const tripodMaxX = base.x + stand.legSpreadCm + 2
    // Pass D2: positions relative to the start eye (WorkspaceAnchor; zero offset on Specs).
    const eye = WorkspaceAnchor.offset()
    const pts = path.arrowPositions.map((p) => new vec3(p.x - eye.x, p.y, p.z - eye.z))
    const tripodRel = tripodMaxX - eye.x
    let maxX = -1e9
    for (const p of pts) {
      expect(p.y > matTop && p.y < matTop + 1, "arrow just above the mat").toBe(true)
      expect(p.x > -90 && p.x < 90 && p.z > -150 && p.z < -30, "arrow on the floor mat").toBe(true)
      expect(p.x > tripodRel + 6, "clear of the stand's tripod").toBe(true)
      maxX = Math.max(maxX, p.x)
    }
    const last = pts[pts.length - 1]
    print(
      `[FloorPathScenario] layout: first (${pts[0].x.toFixed(1)}, ${pts[0].z.toFixed(1)}), last (${last.x.toFixed(1)}, ${last.z.toFixed(1)}), ` +
        `max x ${maxX.toFixed(1)}, y ${pts[0].y.toFixed(1)} (mat top ${matTop.toFixed(1)})`
    )
    expect(maxX, "path swings round the right side").toBeGreaterThan(25)
    expect(pts[0].z > -60, "starts in front of the stand").toBe(true)
    // Pass V: the chain ends at the far-spot marker's edge, behind the wheel (wheel plane z -90).
    expect(last.z < -100, "ends behind the wheel (wheel plane z -90)").toBe(true)
    const far = path.farSpotWorld()
    expect(path.markerVisible || !path.visible, "the far-spot marker shows with the path").toBe(true)
    expect(last.distance(new vec3(far.x - eye.x, last.y, far.z - eye.z)) < 40, "the last arrow is at the far-spot marker").toBe(true)
  }
}
