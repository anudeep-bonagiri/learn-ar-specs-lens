import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {WorkspaceAnchor} from "./WorkspaceAnchor"

/** One up-facing floor candidate hit (world cm). `mesh` is true for world-mesh hits. */
export interface FloorHit {
  x: number
  y: number
  z: number
  mesh: boolean
}

/** A height level that enough hits agree on. */
export interface FloorCluster {
  y: number
  hits: number
  cells: number
  spreadCm: number
  fromQuery: number
  fromMesh: number
}

export interface FloorPickOptions {
  /** Half the height band (cm) hits must share to count as one level. */
  bandCm: number
  /** Distinct 10 cm floor cells a level needs. */
  minCells: number
  /** Horizontal spread (cm, diagonal of the hits' footprint) a level needs. */
  minSpreadCm: number
}

const CELL_CM = 10
/** Seconds after which FloorLevel stops waiting for a world mesh that never answered. */
const MESH_GIVE_UP_SEC = 90

/**
 * Pass F: the floor is the LOWEST level with broad support. Hits are sorted by
 * height; each window of 2 x bandCm is a candidate level. The first (lowest)
 * window whose hits cover at least minCells distinct 10 cm cells spread over at
 * least minSpreadCm wins; a narrow or sparse low level (a box, a stray hit) is
 * skipped. The level's height is the mean of the hits within bandCm of the
 * window's median, so a stray just below the floor does not drag it down.
 * Pure function: FloorLevel and the `floor-level` LEAF scenario both call it.
 */
export function pickFloorCluster(hits: FloorHit[], opts: FloorPickOptions): FloorCluster | null {
  const sorted = hits.slice().sort((a, b) => a.y - b.y)
  let j = 0
  for (let i = 0; i < sorted.length; i++) {
    if (j < i) j = i
    while (j + 1 < sorted.length && sorted[j + 1].y <= sorted[i].y + 2 * opts.bandCm) j++
    const win = sorted.slice(i, j + 1)
    const median = win[Math.floor(win.length / 2)].y
    const members = sorted.filter((h) => Math.abs(h.y - median) <= opts.bandCm)
    const c = describe(members)
    if (c.cells >= opts.minCells && c.spreadCm >= opts.minSpreadCm) return c
  }
  return null
}

function describe(members: FloorHit[]): FloorCluster {
  const cells: {[k: string]: boolean} = {}
  let minX = Infinity
  let maxX = -Infinity
  let minZ = Infinity
  let maxZ = -Infinity
  let sum = 0
  let fromMesh = 0
  for (const h of members) {
    cells[`${Math.floor(h.x / CELL_CM)},${Math.floor(h.z / CELL_CM)}`] = true
    minX = Math.min(minX, h.x)
    maxX = Math.max(maxX, h.x)
    minZ = Math.min(minZ, h.z)
    maxZ = Math.max(maxZ, h.z)
    sum += h.y
    if (h.mesh) fromMesh++
  }
  const n = members.length
  return {
    y: n > 0 ? sum / n : NaN,
    hits: n,
    cells: Object.keys(cells).length,
    spreadCm: n > 0 ? Math.sqrt((maxX - minX) * (maxX - minX) + (maxZ - minZ) * (maxZ - minZ)) : 0,
    fromQuery: n - fromMesh,
    fromMesh,
  }
}

/**
 * FloorLevel — the one floor height that every floor-standing part reads
 * (FloorMat via FloorAnchor, FloorPath, WheelStand). From Lens start it casts
 * downward rays: two rings around the stand footprint for both paths, a grid
 * fanned out below the current gaze for the World Query hit test (async, answers
 * only inside the view), and rays from the eye toward floor spots further out
 * for world-mesh raycasts through DeviceTracking (the mesh loads progressively;
 * in the preview it is often missing for the first runs after a room loads).
 * Up-facing hits at least minDropCm below the eye are pooled over time,
 * deduplicated per 2 x 10 cm cell, and pickFloorCluster() picks the lowest level
 * with broad support.
 * Timing (pass F): nothing is decided before maxWaitSec (one early World Query
 * batch cannot decide); a level seen only by World Query waits up to meshWaitSec
 * more for the world mesh; with no level by then the fallback is published. Until
 * correctWindowSec, a lower well-supported level (or any level after the
 * fallback) replaces the decision and onFloorChanged fires again; readers rebuild
 * on every change. The window stays open until the world mesh has answered for
 * meshWaitSec (at most 90 s): without the mesh, World Query only sees what is in
 * view, and looking down at the bar or the wheel can still reveal a lower floor.
 * Every decision is logged with its path, hit count and spread.
 * Owns: the floor height. Must not: move anything itself; readers subscribe to
 * onFloorChanged and read currentFloorY() (a method, so it works across @inputs).
 * Expects: @input deviceTracking (the Camera's DeviceTracking) for the world-mesh path.
 */
@component
export class FloorLevel extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">FloorLevel – measured floor height, one source of truth</span>')
  @ui.separator
  @ui.group_start("References")
  @input
  @allowUndefined
  @hint("Camera's DeviceTracking, used for the world-mesh path")
  deviceTracking: DeviceTracking
  @ui.group_end

  @ui.separator
  @ui.group_start("Settings")
  @input
  @hint("Floor height (world y, cm) used until a measurement lands, and when no level is found")
  fallbackFloorY: number = -150

  @input("vec3", "{-20, 0, -95}")
  @hint("Center of the ray rings on the floor plane (world x, z; y is ignored)")
  probeCenter: vec3 = new vec3(-20, 0, -95)

  @input
  @hint("Radius of the inner ray ring, in cm (the outer ring is twice as wide)")
  @widget(new SliderWidget(5, 100, 1))
  probeRadiusCm: number = 35

  @input
  @hint("Rays on the inner ring (plus one at the center; the outer ring has twice as many)")
  @widget(new SliderWidget(3, 16, 1))
  probeRays: number = 8

  @input
  @hint("Ray start and end heights (world y, cm)")
  rayTopY: number = 0

  @input
  rayBottomY: number = -400

  @input
  @hint("Earliest decision, in seconds: hits are pooled at least this long")
  @widget(new SliderWidget(0.5, 10, 0.5))
  maxWaitSec: number = 3

  @input
  @hint("Extra seconds a World-Query-only level waits for world-mesh support (and before the fallback)")
  @widget(new SliderWidget(0, 20, 0.5))
  meshWaitSec: number = 8

  @input
  @hint("Seconds after start during which a lower well-supported level still replaces the decision")
  @widget(new SliderWidget(5, 60, 1))
  correctWindowSec: number = 20

  @input
  @hint("Distinct 10 cm floor cells a level needs")
  @widget(new SliderWidget(1, 16, 1))
  minHits: number = 3

  @input
  @hint("Horizontal spread (cm) a level's hits need; a floor is the lowest WIDE surface")
  @widget(new SliderWidget(10, 200, 5))
  minSpreadCm: number = 60

  @input
  @hint("A floor must be at least this far below the eye (cm); higher levels are table tops or seats. 120, not 140: Colorful Home's floor is 135 cm below the eye, and table tops lose to a lower wide floor anyway")
  @widget(new SliderWidget(60, 200, 5))
  minDropCm: number = 120

  @input
  @hint("Half the height band (cm) that hits must share to count as one level")
  @widget(new SliderWidget(0.5, 20, 0.5))
  outlierCm: number = 4
  @ui.group_end

  /** Published floor height (world y, cm). */
  floorY: number = -150
  /** "pending", "worldQuery", "worldMesh", "worldQuery+worldMesh" or "fallback". */
  source: string = "pending"
  /** True once a decision was made (measured or fallback). */
  ready: boolean = false
  /** Hits behind the published level, and its horizontal spread (cm). */
  inliers: number = 0
  spreadCm: number = 0
  /** Pooled hits that were too high (table tops) when the level was published. */
  rejected: number = 0
  /** Decisions so far (1 = first; more after corrections). */
  decisions: number = 0
  /** True once the correction window closed and sampling stopped. */
  final: boolean = false

  private _onFloorChanged = new Event<number>()
  /** Fires with floorY on the first decision and again on each correction. */
  onFloorChanged: PublicApi<number> = this._onFloorChanged.publicApi()

  private session: HitTestSession | null = null
  private hits: {[k: string]: FloorHit} = {}
  private tooHigh: {[k: string]: FloorHit} = {}
  private started = 0
  private nextQuery = 0
  private nextMesh = 0
  private pendingCallbacks = 0
  private callbacks = 0
  private meshOff = false
  private meshFirstSec = -1

  onAwake(): void {
    this.floorY = this.fallbackFloorY
    try {
      const wq = require("LensStudio:WorldQueryModule") as WorldQueryModule
      const options = HitTestSessionOptions.create()
      options.filter = false
      this.session = wq.createHitTestSessionWithOptions(options)
      this.session.start()
    } catch (e) {
      print(`[FloorLevel] World Query unavailable (${e})`)
      this.session = null
    }
    if (this.deviceTracking) {
      try {
        this.deviceTracking.worldOptions.enableWorldMeshesTracking = true
      } catch (e) {
        print(`[FloorLevel] world mesh tracking not available (${e})`)
      }
    }
    this.started = getTime()
    this.createEvent("UpdateEvent").bind(() => this.tick())
  }

  /** The floor height to build on right now (fallback until measured). */
  currentFloorY(): number {
    return this.ready ? this.floorY : this.fallbackFloorY
  }

  /**
   * Ray segments for the world mesh, all aimed down: vertical rays on two rings
   * around the stand footprint, then rays from the eye toward floor spots further out.
   */
  private rays(): vec3[][] {
    const out = this.ringRays()
    const eye = this.eye()
    for (let x = -200; x <= 200; x += 50) {
      for (let z = -100; z >= -450; z -= 70) {
        const target = new vec3(x, this.fallbackFloorY, z)
        out.push([eye, eye.add(target.sub(eye).normalize().uniformScale(600))])
      }
    }
    return out
  }

  /** Vertical rays on two rings around the stand footprint. */
  private ringRays(): vec3[][] {
    const out: vec3[][] = []
    const n = Math.max(3, Math.round(this.probeRays))
    // probeCenter is authored with the start eye at the origin (WorkspaceAnchor).
    const c = WorkspaceAnchor.place(this.probeCenter)
    const ring = [new vec3(c.x, 0, c.z)]
    for (const [r, count] of [
      [this.probeRadiusCm, n],
      [2 * this.probeRadiusCm, 2 * n],
    ]) {
      for (let i = 0; i < count; i++) {
        const a = (2 * Math.PI * i) / count
        ring.push(new vec3(c.x + Math.cos(a) * r, 0, c.z + Math.sin(a) * r))
      }
    }
    for (const p of ring) out.push([new vec3(p.x, this.rayTopY, p.z), new vec3(p.x, this.rayBottomY, p.z)])
    return out
  }

  /**
   * Ray segments for World Query: it answers only inside the camera's view, so
   * besides the rings (in view when the user looks down) the rays fan out on a grid
   * relative to the current gaze (yaw -21..21, 4 to 28 degrees below it). When the
   * user looks down at the bar or the wheel, the grid follows onto the near floor.
   */
  private queryRays(): vec3[][] {
    const out = this.ringRays()
    if (!this.deviceTracking) return out
    const tr = this.deviceTracking.getSceneObject().getTransform()
    const eye = tr.getWorldPosition()
    const fwd = tr.forward.uniformScale(-1) // the camera looks down its -Z
    const right = tr.right
    const up = tr.up
    for (let yaw = -21; yaw <= 21; yaw += 6) {
      for (let pitch = 4; pitch <= 28; pitch += 4) {
        const y = (yaw * Math.PI) / 180
        const p = (pitch * Math.PI) / 180
        const dir = fwd
          .uniformScale(Math.cos(p) * Math.cos(y))
          .add(right.uniformScale(Math.cos(p) * Math.sin(y)))
          .sub(up.uniformScale(Math.sin(p)))
        out.push([eye, eye.add(dir.normalize().uniformScale(800))])
      }
    }
    return out
  }

  private eye(): vec3 {
    return this.deviceTracking ? this.deviceTracking.getSceneObject().getTransform().getWorldPosition() : vec3.zero()
  }

  private elapsed(): number {
    return getTime() - this.started
  }

  /** Pools one up-facing hit (deduplicated per 10 cm cell and 2 cm of height, per path). */
  private addHit(p: vec3, normal: vec3, mesh: boolean): void {
    if (normal.y <= 0.8) return
    const key = `${mesh ? "m" : "q"}${Math.floor(p.x / CELL_CM)},${Math.floor(p.z / CELL_CM)},${Math.round(p.y / 2)}`
    if (p.y > this.eye().y - this.minDropCm) {
      this.tooHigh[key] = {x: p.x, y: p.y, z: p.z, mesh}
      return
    }
    if (!this.hits[key]) this.hits[key] = {x: p.x, y: p.y, z: p.z, mesh}
  }

  private tick(): void {
    if (this.final) return
    const t = this.elapsed()
    if (this.session && t >= this.nextQuery && this.pendingCallbacks === 0) {
      this.nextQuery = t + 0.25
      for (const r of this.queryRays()) {
        this.pendingCallbacks++
        this.session.hitTest(r[0], r[1], (hit) => {
          this.pendingCallbacks = Math.max(0, this.pendingCallbacks - 1)
          this.callbacks++
          if (hit) this.addHit(hit.position, hit.normal, false)
        })
      }
    }
    if (t < this.nextMesh) return
    this.nextMesh = t + 0.5
    this.worldMeshVolley()
    if (t < this.maxWaitSec) return
    this.evaluate(t)
    if (this.ready && this.windowClosed(t)) this.finish()
  }

  /**
   * The correction window closes at correctWindowSec, but not before the world
   * mesh has answered and had meshWaitSec to fill in (in the preview it may never
   * answer in a run; a World-Query-only level may be a furniture top until the user
   * looks down). Capped at MESH_GIVE_UP_SEC.
   */
  private windowClosed(t: number): boolean {
    if (t >= MESH_GIVE_UP_SEC) return true
    if (t < this.correctWindowSec) return false
    return !this.deviceTracking || this.meshOff || (this.meshFirstSec >= 0 && t >= this.meshFirstSec + this.meshWaitSec)
  }

  private worldMeshVolley(): void {
    if (!this.deviceTracking || this.meshOff) return
    try {
      for (const r of this.rays()) {
        const res = this.deviceTracking.raycastWorldMesh(r[0], r[1])
        if (res && res.length > 0) {
          if (this.meshFirstSec < 0) {
            this.meshFirstSec = this.elapsed()
            print(`[FloorLevel] world mesh first answered at ${this.meshFirstSec.toFixed(1)} s`)
          }
          this.addHit(res[0].position, res[0].normal, true)
        }
      }
    } catch (e) {
      print(`[FloorLevel] world-mesh raycast unavailable (${e})`)
      this.meshOff = true
    }
  }

  private pooled(): FloorHit[] {
    return Object.keys(this.hits).map((k) => this.hits[k])
  }

  private evaluate(t: number): void {
    const best = pickFloorCluster(this.pooled(), {bandCm: this.outlierCm, minCells: this.minHits, minSpreadCm: this.minSpreadCm})
    if (!this.ready) {
      const meshTimeUp = t >= this.maxWaitSec + this.meshWaitSec
      if (best && (best.fromMesh > 0 || meshTimeUp)) this.decide(best, "")
      else if (!best && meshTimeUp) this.decideFallback()
      return
    }
    if (!best) return
    if (this.source === "fallback") this.decide(best, " (replaces the fallback)")
    else if (best.y < this.floorY - this.outlierCm) this.decide(best, ` (corrected down from ${this.floorY.toFixed(1)})`)
  }

  private decide(c: FloorCluster, note: string): void {
    this.floorY = c.y
    this.source = c.fromQuery > 0 && c.fromMesh > 0 ? "worldQuery+worldMesh" : c.fromQuery > 0 ? "worldQuery" : "worldMesh"
    this.inliers = c.hits
    this.spreadCm = c.spreadCm
    this.rejected = Object.keys(this.tooHigh).length
    this.publish(
      `floor y ${c.y.toFixed(1)} cm via ${this.source}${note}: ${c.hits} hits (${c.fromQuery} World Query, ${c.fromMesh} world mesh) ` +
        `in ${c.cells} cells, spread ${c.spreadCm.toFixed(0)} cm`
    )
  }

  private decideFallback(): void {
    this.floorY = this.fallbackFloorY
    this.source = "fallback"
    this.inliers = 0
    this.spreadCm = 0
    this.rejected = Object.keys(this.tooHigh).length
    this.publish(`floor y ${this.floorY.toFixed(1)} cm via fallback (no level with ${this.minHits} cells over ${this.minSpreadCm} cm)`)
  }

  private publish(what: string): void {
    this.ready = true
    this.decisions++
    print(
      `[FloorLevel] ${what} at ${this.elapsed().toFixed(1)} s (eye y ${this.eye().y.toFixed(1)}); pooled ${this.histogram(this.pooled())}; ` +
        `ignored as higher than ${this.minDropCm} cm below the eye: ${this.histogram(Object.keys(this.tooHigh).map((k) => this.tooHigh[k]))}`
    )
    this._onFloorChanged.invoke(this.floorY)
  }

  private finish(): void {
    this.final = true
    if (this.session) this.session.stop()
    const mesh = this.meshFirstSec >= 0 ? `world mesh from ${this.meshFirstSec.toFixed(1)} s` : "no world-mesh answer"
    print(
      `[FloorLevel] final at ${this.elapsed().toFixed(1)} s: floor y ${this.floorY.toFixed(1)} cm via ${this.source} after ${this.decisions} decision(s); ` +
        `${this.callbacks} World Query answers, ${mesh}`
    )
  }

  /** Hits per 5 cm height bin ("q" World Query, "m" world mesh), for the log. */
  private histogram(hits: FloorHit[]): string {
    if (hits.length === 0) return "none"
    const bins: {[k: string]: number[]} = {}
    for (const h of hits) {
      const k = (Math.round(h.y / 5) * 5).toString()
      if (!bins[k]) bins[k] = [0, 0]
      bins[k][h.mesh ? 1 : 0]++
    }
    return Object.keys(bins)
      .sort((a, b) => Number(a) - Number(b))
      .map((k) => `${k}: ${bins[k][0]}q/${bins[k][1]}m`)
      .join(", ")
  }
}
