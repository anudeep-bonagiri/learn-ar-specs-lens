import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {FloorPath} from "../Scripts/FloorPath"
import {RepairDirector} from "../Scripts/RepairDirector"

/**
 * Pass 11 (feature E): the floor path. Hidden on step 4; a forward entry into step 5
 * shows at least six arrows on the floor mat, all clear of the stand base, the
 * toolbox and the workbench, curving round the wheel's right side (+X) and ending
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

    // ── Arrive at the far spot ──────────────────────────────────────────────
    const camObj = findSceneObjectByName("Camera Object")
    const camTr = camObj.getTransform()
    const camHome = camTr.getWorldPosition()
    const camRot = camTr.getWorldRotation()
    const far = path.farSpot
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

  /** Arrows on the mat, clear of the stand base, toolbox and bench, round the right side, ending behind the wheel. */
  private checkLayout(path: FloorPath): void {
    const pts = path.arrowPositions
    let maxX = -1e9
    let minClear = 1e9
    for (const p of pts) {
      expect(p.y > -149.5 && p.y < -148.5, "arrow just above the mat").toBe(true)
      expect(p.x > -90 && p.x < 90 && p.z > -150 && p.z < -30, "arrow on the floor mat").toBe(true)
      // Stand base footprint x -55.6..-15.6, z -130..-90; workbench front edge z -128.1 (x -75..75).
      expect(p.x > -15.6 + 6, "clear of the stand base").toBe(true)
      expect(p.z > -128.1 + 3, "clear of the workbench").toBe(true)
      minClear = Math.min(minClear, this.toolboxClearance(p))
      maxX = Math.max(maxX, p.x)
    }
    const last = pts[pts.length - 1]
    print(
      `[FloorPathScenario] layout: first (${pts[0].x.toFixed(1)}, ${pts[0].z.toFixed(1)}), last (${last.x.toFixed(1)}, ${last.z.toFixed(1)}), ` +
        `max x ${maxX.toFixed(1)}, toolbox clearance ${minClear.toFixed(1)} cm`
    )
    expect(minClear, "arrow centers at least 8 cm from the toolbox").toBeGreaterThan(8)
    expect(maxX, "path swings round the right side").toBeGreaterThan(25)
    expect(pts[0].z > -60, "starts in front of the stand").toBe(true)
    expect(last.z < -110, "ends behind the wheel (wheel plane z -90)").toBe(true)
  }

  /** Distance on the floor from p to the toolbox footprint (45 x 28.9 cm at (70, -120), yaw -20 degrees). */
  private toolboxClearance(p: vec3): number {
    const a = (-20 * Math.PI) / 180
    const dx = p.x - 70
    const dz = p.z + 120
    // Into the box's local frame (inverse yaw about Y).
    const lx = dx * Math.cos(a) - dz * Math.sin(a)
    const lz = dx * Math.sin(a) + dz * Math.cos(a)
    const ox = Math.max(0, Math.abs(lx) - 22.5)
    const oz = Math.max(0, Math.abs(lz) - 14.45)
    return Math.sqrt(ox * ox + oz * oz)
  }
}
