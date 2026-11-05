import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BackPlate} from "SpectaclesUIKit.lspkg/Scripts/BackPlate"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {BenchCoachStepLabelUI} from "../Scripts/BenchCoachStepLabelUI"
import {BenchCoachInfoCalloutUI} from "../Scripts/BenchCoachInfoCalloutUI"
import {BenchCoachControlBarUI} from "../Scripts/BenchCoachControlBarUI"
import {EdgeHint} from "../Scripts/EdgeHint"
import {AskCoach} from "../Scripts/AskCoach"
import {LAST_STEP, STEPS} from "../Scripts/StepDefinitions"

type Rect = {x0: number; x1: number; y0: number; y1: number}

/** Panels whose texts must stay inside their plate (root object names). */
const PANELS = ["StepLabel", "InfoCallout", "AskChipsPanel", "AskAnswerPanel", "StartCard", "DoneCard", "FinishCard", "ControlBar", "MorePopover", "WatchPill", "ToolTrayPanel"]

/**
 * Pass D2, the layout rules that can be checked in code, from the live eye (run it from
 * the recording pose and from the default pose):
 *  - on every repair step the step callout's plate does not cover the marker ring on
 *    screen, and its leader runs from the plate edge to the ring;
 *  - inside the rim, every corner of the callout is inside the clear circle (off the
 *    tire, the beads, the valve and lever handles);
 *  - the edge arrow, when it shows, is not on the step callout or the dock;
 *  - no Text's rectangle crosses its plate's edge (every panel, on the step it shows);
 *  - with Ask open the callout and the chips sit above or below the tire, never over it;
 *  - the What's this? info callout does not overlap the step callout on screen.
 */
@component
export class UiLayoutScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const labelObj = findSceneObjectByName("StepLabel")
    const callout = labelObj.getComponent(BenchCoachStepLabelUI.getTypeName()) as BenchCoachStepLabelUI
    const info = findSceneObjectByName("InfoCallout").getComponent(BenchCoachInfoCalloutUI.getTypeName()) as BenchCoachInfoCalloutUI
    const dock = findSceneObjectByName("ControlBar").getComponent(BenchCoachControlBarUI.getTypeName()) as BenchCoachControlBarUI
    const edge = root.getComponent(EdgeHint.getTypeName()) as EdgeHint
    const ask = root.getComponent(AskCoach.getTypeName()) as AskCoach
    const marker = findSceneObjectByName("StepMarker")
    const arrow = findSceneObjectByName("EdgeArrow")
    const camera = findSceneObjectByName("Camera Object").getComponent("Component.Camera") as Camera
    const hub = () => findSceneObjectByName("Wheel").getTransform().getWorldPosition()
    const tire = findSceneObjectByName("Tire")

    // ── Every repair step: callout off the ring, inside the clear circle, leader on ──
    for (let step = 1; step < LAST_STEP; step++) {
      if (STEPS[step].markerAnchor === "none") continue
      manager.jumpToStep(step)
      await sleep(500)
      const c = labelObj.getTransform().getWorldPosition()
      const w = callout.scaledWidth()
      const h = callout.scaledHeight()
      const right = this.flatRight(c)
      const plate = this.screenRect(camera, c, right, w, h)
      const markerOn = marker.isEnabledInHierarchy
      let note = `zone ${callout.zone}, scale ${callout.scale.toFixed(2)}`
      if (markerOn) {
        const m = marker.getTransform().getWorldPosition()
        const ring = this.screenRect(camera, m, right, 2 * 2.2, 2 * 2.2)
        const covers = this.overlaps(plate, ring) && c.distance(camera.getTransform().getWorldPosition()) < m.distance(camera.getTransform().getWorldPosition())
        expect(covers, `step ${step}: the callout does not cover the marker ring on screen`).toBe(false)
        expect(callout.leaderFrom !== null && callout.leaderTo !== null, `step ${step}: leader drawn to the marker`).toBe(true)
        const toRing = callout.leaderTo ? callout.leaderTo.distance(m) : 99
        expect(toRing < 3.5, `step ${step}: the leader ends at the ring`).toBe(true)
        note += `, leader ends ${toRing.toFixed(1)} cm from the ring center`
      }
      if (callout.zone === "inside") {
        const radius = 33.4 * tire.getTransform().getLocalScale().x
        const inner = radius - 6.5
        const d = c.sub(hub())
        const fx = Math.abs(d.x) + w / 2
        const fy = Math.abs(d.y) + h / 2
        const far = Math.sqrt(fx * fx + fy * fy)
        expect(far <= inner + 0.5, `step ${step}: every corner inside the clear circle (${far.toFixed(1)} <= ${inner.toFixed(1)} cm)`).toBe(true)
      }
      if (arrow.isEnabledInHierarchy) {
        const a = camera.worldSpaceToScreenSpace(arrow.getTransform().getWorldPosition())
        expect(this.inside(a, plate), `step ${step}: the edge arrow is not on the step callout`).toBe(false)
        if (dock.sceneObject.isEnabledInHierarchy) {
          const dt = dock.sceneObject.getTransform()
          const dr = this.screenRect(camera, dt.getWorldPosition(), dt.right, dock.width, dock.height, dt.up)
          expect(this.inside(a, dr), `step ${step}: the edge arrow is not on the dock`).toBe(false)
        }
        note += ", edge arrow clear"
      }
      this.checkTexts(step)
      print(`[UiLayoutScenario] step ${step}: ${note}`)
    }

    // ── Cards: texts inside their plates ─────────────────────────────────────
    for (const step of [0, 7, LAST_STEP]) {
      manager.jumpToStep(step)
      await sleep(500)
      this.checkTexts(step)
    }

    // ── Ask open: the callout and the stack stay off the wheel ───────────────
    for (const step of [3, 5]) {
      manager.jumpToStep(step)
      await sleep(400)
      ask.forceCanned = true
      await interactor.tap("BtnAsk")
      await sleep(400)
      const c = labelObj.getTransform().getWorldPosition()
      const chips = findSceneObjectByName("AskChipsPanel").getTransform().getWorldPosition()
      const tireOuter = 33.4 * tire.getTransform().getLocalScale().x + 3.2
      const hy = hub().y
      print(`[UiLayoutScenario] Ask on step ${step}: zone ${callout.zone}, callout y ${(c.y - hy).toFixed(1)}, chips y ${(chips.y - hy).toFixed(1)} from the hub`)
      expect(callout.zone === "top" || callout.zone === "bottom", `Ask on step ${step}: callout above or below the tire`).toBe(true)
      if (callout.zone === "top") {
        const chipsBottom = chips.y - (ask.chips.height * callout.scale) / 2
        expect(chipsBottom > hy + tireOuter, `Ask on step ${step}: chips above the tire`).toBe(true)
      } else {
        expect(c.y + callout.scaledHeight() / 2 < hy - tireOuter, `Ask on step ${step}: callout below the tire`).toBe(true)
      }
      this.checkTexts(step)
      await interactor.tap("AskChip_0")
      await sleep(400)
      this.checkTexts(step)
      await interactor.tap("BtnAsk")
      await sleep(300)
      ask.forceCanned = false
    }

    // ── What's this?: the info callout never overlaps the step callout ──────
    manager.jumpToStep(1)
    await sleep(400)
    await interactor.tap("BtnWhatsThis")
    await sleep(300)
    for (const part of ["Tire", "Valve", "Hub"]) {
      await interactor.tap(`InfoHit_${part}`)
      await sleep(300)
      const ic = info.sceneObject.getTransform().getWorldPosition()
      const sc = labelObj.getTransform().getWorldPosition()
      const ir = this.screenRect(camera, ic, this.flatRight(ic), info.panelWidth, info.panelHeight)
      const sr = this.screenRect(camera, sc, this.flatRight(sc), callout.scaledWidth(), callout.scaledHeight())
      expect(this.overlaps(ir, sr), `What's this? ${part}: the info callout does not overlap the step callout`).toBe(false)
      this.checkTexts(1)
    }
    await interactor.tap("BtnWhatsThis")
    await sleep(300)
    manager.reset()
    await sleep(300)
  }

  /** Every enabled Text under each enabled panel stays inside that panel's plate. */
  private checkTexts(step: number): void {
    let checked = 0
    for (const name of PANELS) {
      const so = findSceneObjectByName(name)
      if (!so || !so.isEnabledInHierarchy) continue
      const plate = so.getComponent(BackPlate.getTypeName()) as BackPlate
      if (!plate) continue
      const size = plate.size
      const inv = so.getTransform().getInvertedWorldTransform()
      for (const t of this.texts(so)) {
        const r = t.layoutRect
        const m = t.getSceneObject().getTransform().getWorldTransform()
        for (const p of [new vec3(r.left, r.bottom, 0), new vec3(r.right, r.bottom, 0), new vec3(r.left, r.top, 0), new vec3(r.right, r.top, 0)]) {
          const l = inv.multiplyPoint(m.multiplyPoint(p))
          const ok = Math.abs(l.x) <= size.x / 2 + 0.01 && Math.abs(l.y) <= size.y / 2 + 0.01
          if (!ok) print(`[UiLayoutScenario] step ${step}: ${name}/${t.getSceneObject().name} "${t.text}" corner (${l.x.toFixed(2)}, ${l.y.toFixed(2)}) outside ${size.x.toFixed(1)} x ${size.y.toFixed(1)}`)
          expect(ok, `step ${step}: text "${t.getSceneObject().name}" inside the ${name} plate`).toBe(true)
        }
        checked++
      }
    }
    if (checked === 0) print(`[UiLayoutScenario] step ${step}: no panel texts to check`)
  }

  /** Texts under a panel, not descending into nested panels with their own plate (checked on their own). */
  private texts(so: SceneObject): Text[] {
    const out: Text[] = []
    const walk = (o: SceneObject) => {
      if (!o.isEnabledInHierarchy) return
      if (o !== so && o.getComponent(BackPlate.getTypeName())) return
      const t = o.getComponent("Component.Text") as Text
      if (t && t.text.length > 0) out.push(t)
      for (let i = 0; i < o.getChildrenCount(); i++) walk(o.getChild(i))
    }
    walk(so)
    return out
  }

  private flatRight(c: vec3): vec3 {
    const eye = findSceneObjectByName("Camera Object").getTransform().getWorldPosition()
    const f = new vec3(eye.x - c.x, 0, eye.z - c.z)
    if (f.length < 1e-3) return vec3.right()
    const n = f.normalize()
    return new vec3(n.z, 0, -n.x)
  }

  private screenRect(camera: Camera, c: vec3, right: vec3, w: number, h: number, up: vec3 = vec3.up()): Rect {
    let x0 = 2
    let x1 = -1
    let y0 = 2
    let y1 = -1
    for (const sx of [-1, 1]) {
      for (const sy of [-1, 1]) {
        const p = camera.worldSpaceToScreenSpace(c.add(right.uniformScale((sx * w) / 2)).add(up.uniformScale((sy * h) / 2)))
        x0 = Math.min(x0, p.x)
        x1 = Math.max(x1, p.x)
        y0 = Math.min(y0, p.y)
        y1 = Math.max(y1, p.y)
      }
    }
    return {x0, x1, y0, y1}
  }

  private overlaps(a: Rect, b: Rect): boolean {
    return a.x0 < b.x1 && a.x1 > b.x0 && a.y0 < b.y1 && a.y1 > b.y0
  }

  private inside(p: vec2, r: Rect): boolean {
    return p.x > r.x0 && p.x < r.x1 && p.y > r.y0 && p.y < r.y1
  }
}
