import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {getRepairManager} from "./BenchCoachLeafInteractor"
import {FloorHit, FloorLevel, pickFloorCluster} from "../Scripts/FloorLevel"
import {WheelStand} from "../Scripts/WheelStand"
import {FloorPath} from "../Scripts/FloorPath"

/** Hits on a line from (x0, z0) to (x1, z1) at height y, `n` of them. */
function row(y: number, x0: number, z0: number, x1: number, z1: number, n: number, mesh: boolean): FloorHit[] {
  const out: FloorHit[] = []
  for (let i = 0; i < n; i++) {
    const t = n === 1 ? 0 : i / (n - 1)
    out.push({x: x0 + (x1 - x0) * t, y: y + ((i % 3) - 1) * 0.4, z: z0 + (z1 - z0) * t, mesh})
  }
  return out
}

/**
 * Pass F: FloorLevel picks the LOWEST level with broad support.
 * Part 1 feeds pickFloorCluster() mixed heights like the Sunlit Room's (a console
 * top at -146.6 that World Query sees, the floor at -178.3 that the world mesh
 * sees), plus a narrow box below the floor and stray low hits.
 * Part 2 checks the live decision and that a downward correction moves the stand,
 * the mat and the floor path together (a lower wide level is injected into the
 * running FloorLevel), while a higher level never moves the floor up.
 */
@component
export class FloorLevelScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(500)
    const opts = {bandCm: 4, minCells: 3, minSpreadCm: 60}
    const consoleTop = row(-146.6, -50, -300, 50, -300, 10, false)
    const floor = row(-178.3, -150, -150, 150, -400, 12, true)

    let c = pickFloorCluster(consoleTop.concat(floor), opts)
    expect(c, "a level is found among console and floor hits").toBeTruthy()
    print(`[FloorLevelScenario] console + floor -> ${c.y.toFixed(1)} (${c.cells} cells, spread ${c.spreadCm.toFixed(0)} cm)`)
    expect(Math.abs(c.y - -178.3), "the floor wins over the console top").toBeLessThan(1)

    const box = row(-190, -10, -100, 10, -110, 4, true) // a 22 cm wide box top below the floor level
    c = pickFloorCluster(box.concat(consoleTop, floor), opts)
    expect(Math.abs(c.y - -178.3), "a narrow lower box is skipped").toBeLessThan(1)

    const strays = [
      {x: 0, y: -230, z: -200, mesh: true},
      {x: 80, y: -205, z: -260, mesh: false},
    ]
    c = pickFloorCluster(strays.concat(consoleTop, floor), opts)
    expect(Math.abs(c.y - -178.3), "stray low hits are skipped").toBeLessThan(1)

    const nearFloor = [{x: 30, y: -183, z: -220, mesh: true}] // just under the floor band's start
    c = pickFloorCluster(nearFloor.concat(floor), opts)
    expect(Math.abs(c.y - -178.3), "a stray just below the floor does not drag the level down").toBeLessThan(1)

    c = pickFloorCluster(consoleTop, opts)
    expect(Math.abs(c.y - -146.6), "with only the console top, that is the lowest wide level").toBeLessThan(1)
    expect(pickFloorCluster(row(-178, 0, -100, 20, -100, 2, true), opts), "two cells are not enough").toBeFalsy()
    expect(pickFloorCluster(row(-178, 0, -100, 40, -100, 6, true), opts), "40 cm of spread is not enough").toBeFalsy()

    // ── Live: the decision, then a correction through the single source of truth ──
    getRepairManager().reset()
    const floorLevel = findSceneObjectByName("FloorLevel").getComponent(FloorLevel.getTypeName()) as FloorLevel
    const stand = findSceneObjectByName("Stand").getComponent(WheelStand.getTypeName()) as WheelStand
    const path = findSceneObjectByName("FloorPath").getComponent(FloorPath.getTypeName()) as FloorPath
    expect(floorLevel && stand && path, "FloorLevel, WheelStand and FloorPath exist").toBeTruthy()
    for (let i = 0; i < 300 && !floorLevel.ready; i++) await sleep(100)
    expect(floorLevel.ready, "floor decided within 30 s").toBe(true)
    const y0 = floorLevel.floorY
    print(`[FloorLevelScenario] live floor ${y0.toFixed(1)} via ${floorLevel.source}, ${floorLevel.inliers} hits, spread ${floorLevel.spreadCm.toFixed(0)} cm`)
    if (floorLevel.source !== "fallback") {
      expect(floorLevel.spreadCm, "live level spread at least 60 cm").toBeGreaterThan(59.9)
    }
    this.checkReaders(floorLevel, stand, path, y0, "after the decision")

    const decisions = floorLevel.decisions
    const addHit = (p: vec3) => floorLevel["addHit"](p, vec3.up(), true)
    for (let x = -100; x <= 100; x += 25) addHit(new vec3(x, y0 + 8, -160)) // higher wide level
    floorLevel["evaluate"](0)
    expect(floorLevel.floorY, "a higher level never moves the floor up").toBe(y0)
    for (let x = -100; x <= 100; x += 25) addHit(new vec3(x, y0 - 12, -170)) // lower wide level
    floorLevel["evaluate"](0)
    print(`[FloorLevelScenario] after a lower wide level: ${floorLevel.floorY.toFixed(1)} (${floorLevel.decisions} decisions)`)
    expect(Math.abs(floorLevel.floorY - (y0 - 12)), "a lower wide level corrects the floor down").toBeLessThan(1)
    expect(floorLevel.decisions, "the correction is a new decision").toBe(decisions + 1)
    await sleep(100)
    this.checkReaders(floorLevel, stand, path, floorLevel.floorY, "after the correction")
  }

  private checkReaders(floorLevel: FloorLevel, stand: WheelStand, path: FloorPath, y: number, when: string): void {
    expect(Math.abs(floorLevel.currentFloorY() - y), `currentFloorY is the floor (${when})`).toBeLessThan(0.01)
    expect(Math.abs(stand.builtFloorY - y), `stand built on the floor (${when})`).toBeLessThan(0.5)
    const baseY = findSceneObjectByName("StandBase").getTransform().getWorldPosition().y
    expect(Math.abs(baseY - y), `stand base on the floor (${when})`).toBeLessThan(1)
    const matY = findSceneObjectByName("FloorMat").getTransform().getWorldPosition().y
    expect(Math.abs(matY - (y + 0.5)), `mat 0.5 cm above the floor (${when})`).toBeLessThan(1)
    expect(path.arrowPositions.length, `floor path arrows built (${when})`).toBeGreaterThan(0)
    for (const p of path.arrowPositions) {
      expect(p.y > y + 0.5 && p.y < y + 1.5, `path arrow just above the mat (${when})`).toBe(true)
    }
    print(`[FloorLevelScenario] ${when}: floor ${y.toFixed(1)}, stand ${stand.builtFloorY.toFixed(1)}, base ${baseY.toFixed(1)}, mat ${matY.toFixed(1)}, ${path.arrowPositions.length} arrows`)
  }
}
