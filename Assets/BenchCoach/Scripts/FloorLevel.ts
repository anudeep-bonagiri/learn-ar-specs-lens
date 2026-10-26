import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"

/**
 * FloorLevel — the one floor height that every floor-standing part reads
 * (FloorMat via FloorAnchor, FloorPath, WheelStand). At Lens start it casts downward rays (a ring
 * around the stand footprint plus rays from the eye toward the floor further out)
 * with the World Query hit test for maxWaitSec, then with world-mesh raycasts
 * through DeviceTracking until they hit (up to meshWaitSec more). Only upward-facing
 * hits at least minDropCm below the eye count (a standing user; anything higher is
 * a table top or seat). The floor is the lowest height that minHits or more hits
 * agree on; higher levels and stray hits are rejected. With no such level
 * it keeps fallbackFloorY. The path that ran is logged and kept in `source`.
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
  @hint("Camera's DeviceTracking, used for the world-mesh fallback")
  deviceTracking: DeviceTracking
  @ui.group_end

  @ui.separator
  @ui.group_start("Settings")
  @input
  @hint("Floor height (world y, cm) used until a measurement lands, and when no ray hits")
  fallbackFloorY: number = -150

  @input("vec3", "{-20, 0, -95}")
  @hint("Center of the ray ring on the floor plane (world x, z; y is ignored)")
  probeCenter: vec3 = new vec3(-20, 0, -95)

  @input
  @hint("Radius of the ray ring, in cm")
  @widget(new SliderWidget(5, 100, 1))
  probeRadiusCm: number = 35

  @input
  @hint("Rays on the ring (plus one at the center)")
  @widget(new SliderWidget(3, 16, 1))
  probeRays: number = 8

  @input
  @hint("Ray start and end heights (world y, cm)")
  rayTopY: number = 0

  @input
  rayBottomY: number = -400

  @input
  @hint("Seconds to keep collecting World Query hits before deciding")
  @widget(new SliderWidget(0.5, 10, 0.5))
  maxWaitSec: number = 3

  @input
  @hint("Extra seconds to retry world-mesh raycasts (the mesh builds over time) before the fallback")
  @widget(new SliderWidget(0, 20, 0.5))
  meshWaitSec: number = 8

  @input
  @hint("Inlier hits needed to accept a measurement")
  @widget(new SliderWidget(1, 16, 1))
  minHits: number = 3

  @input
  @hint("A floor must be at least this far below the eye (cm); higher levels are table tops or seats (the Lens is used standing)")
  @widget(new SliderWidget(60, 200, 5))
  minDropCm: number = 140

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
  /** Inlier hits behind the published value, and rejected outliers. */
  inliers: number = 0
  rejected: number = 0

  private _onFloorChanged = new Event<number>()
  /** Fires once, with floorY, when the measurement (or the fallback) is decided. */
  onFloorChanged: PublicApi<number> = this._onFloorChanged.publicApi()

  private session: HitTestSession | null = null
  private queryHits: number[] = []
  private started = 0
  private nextVolley = 0
  private pendingCallbacks = 0
  private callbacks = 0
  private queryDone = false

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
   * Ray segments, all aimed down: vertical rays on the ring around the stand
   * footprint, then rays from the eye toward floor spots further out (World Query
   * answers only inside the camera's view, and the footprint is far below the gaze).
   */
  private rays(): vec3[][] {
    const out: vec3[][] = []
    const n = Math.max(3, Math.round(this.probeRays))
    const ring = [new vec3(this.probeCenter.x, 0, this.probeCenter.z)]
    for (let i = 0; i < n; i++) {
      const a = (2 * Math.PI * i) / n
      ring.push(new vec3(this.probeCenter.x + Math.cos(a) * this.probeRadiusCm, 0, this.probeCenter.z + Math.sin(a) * this.probeRadiusCm))
    }
    for (const p of ring) out.push([new vec3(p.x, this.rayTopY, p.z), new vec3(p.x, this.rayBottomY, p.z)])
    const eye = this.deviceTracking ? this.deviceTracking.getSceneObject().getTransform().getWorldPosition() : vec3.zero()
    for (let x = -150; x <= 150; x += 50) {
      for (let z = -150; z >= -450; z -= 75) {
        const target = new vec3(x, this.fallbackFloorY, z)
        out.push([eye, eye.add(target.sub(eye).normalize().uniformScale(600))])
      }
    }
    return out
  }

  private tick(): void {
    if (this.ready) return
    const now = getTime()
    if (!this.queryDone) {
      if (this.session && now - this.started < this.maxWaitSec) {
        if (now >= this.nextVolley && this.pendingCallbacks === 0) {
          this.nextVolley = now + 0.25
          for (const r of this.rays()) {
            this.pendingCallbacks++
            this.session.hitTest(r[0], r[1], (hit) => {
              this.pendingCallbacks = Math.max(0, this.pendingCallbacks - 1)
              this.callbacks++
              if (hit && hit.normal.y > 0.8) this.queryHits.push(hit.position.y)
            })
          }
        }
        return
      }
      this.queryDone = true
      print(`[FloorLevel] worldQuery: ${this.callbacks} rays answered, up-facing heights ${this.histogram(this.queryHits)}`)
    }
    if (now < this.nextVolley) return
    // World Query only answers inside the view, where the floor is often hidden by
    // furniture tops, so both paths' hits are pooled and the lowest level wins.
    const meshHits = this.worldMeshHits()
    const meshReady = meshHits.length >= this.minHits || now - this.started >= this.maxWaitSec + this.meshWaitSec
    if (!meshReady) {
      this.nextVolley = now + 0.5
      return
    }
    if (this.accept(this.queryHits, meshHits)) return
    this.decide(this.fallbackFloorY, "fallback")
  }

  private worldMeshHits(): number[] {
    const ys: number[] = []
    if (!this.deviceTracking) return ys
    try {
      for (const r of this.rays()) {
        const res = this.deviceTracking.raycastWorldMesh(r[0], r[1])
        if (res && res.length > 0 && res[0].normal.y > 0.8) ys.push(res[0].position.y)
      }
    } catch (e) {
      print(`[FloorLevel] world-mesh raycast unavailable (${e})`)
    }
    if (ys.length > 0) print(`[FloorLevel] worldMesh: up-facing heights ${this.histogram(ys)}`)
    return ys
  }

  /** Counts per 5 cm height bin, for the log. */
  private histogram(ys: number[]): string {
    const bins: {[k: string]: number} = {}
    for (const y of ys) {
      const k = (Math.round(y / 5) * 5).toString()
      bins[k] = (bins[k] || 0) + 1
    }
    return JSON.stringify(bins)
  }

  /**
   * Hits closer than minDropCm below the eye are dropped (table tops, seats). The
   * floor is the lowest height that at least minHits of the rest agree on (within
   * 2 x outlierCm); stray hits outside that band are rejected too.
   */
  private accept(queryHits: number[], meshHits: number[]): boolean {
    const eyeY = this.deviceTracking ? this.deviceTracking.getSceneObject().getTransform().getWorldPosition().y : 0
    const low = (y: number) => y <= eyeY - this.minDropCm
    const queryYs = queryHits.filter(low)
    const meshYs = meshHits.filter(low)
    const all = queryYs.concat(meshYs)
    const tooHigh = queryHits.length + meshHits.length - all.length
    const sorted = all.slice().sort((a, b) => a - b)
    for (let i = 0; i < sorted.length; i++) {
      const lo = sorted[i]
      const hi = lo + 2 * this.outlierCm
      const keep = sorted.filter((y) => y >= lo && y <= hi)
      if (keep.length < this.minHits) continue
      const fromQuery = queryYs.filter((y) => y >= lo && y <= hi).length
      const fromMesh = keep.length - fromQuery
      this.inliers = keep.length
      this.rejected = all.length - keep.length + tooHigh
      const mean = keep.reduce((s, y) => s + y, 0) / keep.length
      this.decide(mean, fromQuery > 0 && fromMesh > 0 ? "worldQuery+worldMesh" : fromQuery > 0 ? "worldQuery" : "worldMesh")
      return true
    }
    print(`[FloorLevel] ${all.length} up-facing hits at least ${this.minDropCm} cm below the eye (${tooHigh} higher), no level with ${this.minHits} or more`)
    return false
  }

  private decide(y: number, source: string): void {
    this.floorY = y
    this.source = source
    this.ready = true
    if (this.session) this.session.stop()
    print(
      `[FloorLevel] floor y ${y.toFixed(1)} cm via ${source}` +
        (source === "fallback" ? " (no measurement)" : ` (${this.inliers} inlier hits; ${this.rejected} higher or stray hits rejected)`)
    )
    this._onFloorChanged.invoke(y)
  }
}
