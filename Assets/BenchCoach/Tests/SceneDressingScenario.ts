import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {WorkspaceAnchor} from "../Scripts/WorkspaceAnchor"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {Highlighter} from "../Scripts/Highlighter"
import {BenchCoachAudio} from "../Scripts/BenchCoachAudio"
import {FloorLevel} from "../Scripts/FloorLevel"
import {WheelStand} from "../Scripts/WheelStand"

/**
 * Pass 7 scene dressing (code half, 7a): the Tube is hidden until a bead lifts
 * (off on step 2, on from step 4); the valve pinch on step 1 plays the hiss; the
 * Highlighter glows the valve on step 1 and exactly the not-yet-loosened beads on
 * step 2, and nothing once the step moves on.
 * Scene half (pass D1, replaces the 7b frame checks): Environment is hidden on
 * step 0 and shown after Found it; the pegboard, toolbox, workbench, bike frame and
 * saddle are gone; FloorLevel has decided a floor; the stand base and floor mat sit
 * on it (within 1 cm); the stand's clamp grips the back of the hub; the hub is 20
 * to 30 cm below and 85 to 95 cm in front of the default eye.
 */
@component
export class SceneDressingScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const tube = findSceneObjectByName("Tube")
    expect(tube, "Tube exists").toBeTruthy()
    const highlighter = findSceneObjectByName("BenchCoach").getComponent(Highlighter.getTypeName()) as Highlighter
    expect(highlighter, "Highlighter on BenchCoach").toBeTruthy()
    const audio = findSceneObjectByName("Audio").getComponent(BenchCoachAudio.getTypeName()) as BenchCoachAudio
    expect(audio, "BenchCoachAudio on Audio").toBeTruthy()

    // ── Tube hidden until a bead lifts ──────────────────────────────────────
    manager.jumpToStep(2)
    await sleep(300)
    expect(tube.enabled, "Tube hidden on step 2").toBe(false)
    manager.jumpToStep(4)
    await sleep(300)
    expect(tube.enabled, "Tube shown on step 4").toBe(true)
    manager.jumpToStep(3)
    await sleep(300)
    expect(tube.enabled, "Tube hidden again on step 3 before lever A hooks").toBe(false)

    // ── Step 1: the valve glows, its pinch hisses ───────────────────────────
    manager.jumpToStep(1)
    await sleep(300)
    print(`[SceneDressingScenario] step 1 highlight: ${JSON.stringify(highlighter.current)}`)
    expect(JSON.stringify(highlighter.current), "valve highlighted on step 1").toBe(JSON.stringify(["Valve"]))
    const hissBefore = audio.hissPlays
    await interactor.tap("Valve")
    await sleep(200)
    expect(manager.getState().step, "valve pinch deflates (step 2)").toBe(2)
    expect(audio.hissPlays, "hiss played once on the valve pinch").toBe(hissBefore + 1)

    // ── Step 2: the beads still to loosen glow ──────────────────────────────
    const sorted = (a: string[]): string => JSON.stringify(a.slice().sort())
    print(`[SceneDressingScenario] step 2 highlight: ${JSON.stringify(highlighter.current)}`)
    expect(sorted(highlighter.current), "four loosen beads highlighted on step 2").toBe(
      sorted(["Bead_0", "Bead_2", "Bead_4", "Bead_6"])
    )
    await interactor.tap("Bead_2")
    await sleep(200)
    print(`[SceneDressingScenario] after Bead_2: ${JSON.stringify(highlighter.current)}`)
    expect(sorted(highlighter.current), "three remaining beads highlighted after Bead_2").toBe(
      sorted(["Bead_0", "Bead_4", "Bead_6"])
    )

    // ── Later steps: nothing glows ──────────────────────────────────────────
    manager.jumpToStep(3)
    await sleep(300)
    expect(highlighter.current.length, "no highlight on step 3").toBe(0)

    // ── Pass D1: workshop environment, measured floor, stand ───────────────
    const environment = findSceneObjectByName("Environment")
    const hub = findSceneObjectByName("Hub")
    expect(environment, "Environment exists").toBeTruthy()
    expect(hub, "Hub exists").toBeTruthy()
    for (const gone of ["Pegboard", "Toolbox", "Workbench", "BikeFrame", "Saddle"]) {
      expect(findSceneObjectByName(gone), `${gone} removed`).toBeFalsy()
    }
    manager.reset()
    await sleep(300)
    expect(manager.getState().step, "reset returns to step 0").toBe(0)
    expect(environment.isEnabledInHierarchy, "Environment hidden on step 0").toBe(false)
    await interactor.tap("BtnFoundIt")
    await sleep(300)
    expect(manager.getState().step, "Found it enters step 1").toBe(1)
    expect(environment.isEnabledInHierarchy, "Environment shown after Found it").toBe(true)

    const floorLevel = findSceneObjectByName("FloorLevel").getComponent(FloorLevel.getTypeName()) as FloorLevel
    expect(floorLevel, "FloorLevel exists").toBeTruthy()
    for (let i = 0; i < 300 && !floorLevel.ready; i++) await sleep(100)
    expect(floorLevel.ready, "floor decided within 30 s").toBe(true)
    await sleep(200)
    const floorY = floorLevel.floorY
    print(`[SceneDressingScenario] floor y ${floorY.toFixed(1)} cm via ${floorLevel.source} (${floorLevel.inliers} inliers)`)

    const stand = findSceneObjectByName("Stand").getComponent(WheelStand.getTypeName()) as WheelStand
    expect(stand, "WheelStand on Stand").toBeTruthy()
    const baseY = findSceneObjectByName("StandBase").getTransform().getWorldPosition().y
    print(`[SceneDressingScenario] stand base y ${baseY.toFixed(1)}, built on ${stand.builtFloorY.toFixed(1)}`)
    expect(Math.abs(baseY - floorY), "stand base within 1 cm of the floor").toBeLessThan(1.0)
    expect(Math.abs(stand.builtFloorY - floorY), "stand built on the measured floor").toBeLessThan(1.0)
    const matY = findSceneObjectByName("FloorMat").getTransform().getWorldPosition().y
    expect(Math.abs(matY - (floorY + 0.5)), "mat top 0.5 cm above the floor").toBeLessThan(1.0)

    const hubPos = hub.getTransform().getWorldPosition()
    const clampPos = findSceneObjectByName("StandClamp").getTransform().getWorldPosition()
    expect(Math.abs(clampPos.x - hubPos.x) + Math.abs(clampPos.y - hubPos.y), "clamp level with the hub").toBeLessThan(0.5)
    expect(hubPos.z - clampPos.z > 6 && hubPos.z - clampPos.z < 11, "clamp just behind the hub").toBe(true)
    // Pass D2: the workspace is placed from the start eye (WorkspaceAnchor; zero offset on Specs).
    const eye = WorkspaceAnchor.offset()
    const rel = hubPos.sub(eye)
    print(`[SceneDressingScenario] hub (${hubPos.x.toFixed(1)}, ${hubPos.y.toFixed(1)}, ${hubPos.z.toFixed(1)}), start eye (${eye.x.toFixed(1)}, ${eye.y.toFixed(1)}, ${eye.z.toFixed(1)})`)
    expect(rel.y < -20 && rel.y > -30, "hub 20 to 30 cm below the start eye").toBe(true)
    expect(rel.z < -85 && rel.z > -95, "hub 85 to 95 cm in front of the start eye").toBe(true)


    manager.reset()
    await sleep(300)
    expect(highlighter.current.length, "no highlight after reset").toBe(0)
  }
}
