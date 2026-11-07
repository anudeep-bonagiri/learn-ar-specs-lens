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
import {BenchCoachAskAnswerUI} from "../Scripts/BenchCoachAskAnswerUI"
import {LAST_STEP, STEPS} from "../Scripts/StepDefinitions"
import {BenchCoachFinishCardUI} from "../Scripts/BenchCoachFinishCardUI"
import {MIN_BODY_XHEIGHT_DEG, MIN_TITLE_XHEIGHT_DEG, xHeightDeg} from "../Scripts/UIHelpers"

type Rect = {x0: number; x1: number; y0: number; y1: number}

/** Panels whose texts must stay inside their plate (root object names). */
const PANELS = ["StepLabel", "InfoCallout", "AskChipsPanel", "AskAnswerPanel", "StartCard", "DoneCard", "FinishCard", "ControlBar", "MorePopover", "WatchPill", "ToolTrayPanel", "WatchBadgeRoot"]

/** Pass V: body and instruction lines (x-height at least 1.5% of the frame) and titles (2.2%). */
const BODY_TEXTS = ["LabelText", "HintText", "Subtitle", "DoneNext", "FinishTip", "AskAnswerText", "InfoLine", "TimeText", "DoneCause", "FinishCause", "FinishTimes"]
const TITLE_TEXTS = ["Title", "DoneText", "FinishTitle", "FinishTime"]

/**
 * Pass D2, the layout rules that can be checked in code, from the live eye (run it from
 * the recording pose and from the default pose):
 *  - on every repair step the step callout's plate does not cover the marker ring on
 *    screen, and its leader runs from the plate edge to the ring;
 *  - inside the rim, every corner of the callout is inside the clear circle (off the
 *    tire, the beads, the valve and lever handles);
 *  - the edge arrow, when it shows, is not on the step callout or the dock;
 *  - no Text's rectangle crosses its plate's edge (every panel, on the step it shows);
 *  - with Ask open the callout and the chips (or the answer) sit inside the rim together,
 *    every corner in the clear circle, or above or below the tire; never over the tire,
 *    and their top at most 14 degrees above the eye (pass M: Sujeeth's G5, Specs' top
 *    edge is about 18.5 degrees);
 *  - the What's this? info callout does not overlap the step callout on screen;
 *  - pass V, the type scale for video: from the live eye every body and instruction line
 *    has an x-height of at least MIN_BODY_XHEIGHT_DEG (1.5% of the 36.6-degree frame) and
 *    every title at least MIN_TITLE_XHEIGHT_DEG (2.2%);
 *  - pass P, in view: while the hub is in view, the callout is fully inside the frame
 *    on every step and every sub-target (step 2's and step 9's beads);
 *  - pass P, no doubled text: on every frame of the run (an UpdateEvent sees what the
 *    last frame drew), no two visible Texts of one panel overlap. The first show of a
 *    panel after the reset used to draw every child at the column's centre for a frame;
 *  - pass S1, the Finish card compact and after More: the plate inside the view while the
 *    eye looks at the card (the card pose; from Sunlit Room's level default pose the card
 *    sits 10 degrees low and is logged only), its texts inside the plate at their minimum
 *    x-height, its buttons at least as tall (in degrees from the eye) as the dock's and
 *    not under the dock on screen.
 */
@component
export class UiLayoutScenario extends Scenario {
  private overlapsSeen: string[] = []
  private framesWatched = 0

  async run(): Promise<void> {
    await sleep(1000)
    const watcher = this.createEvent("UpdateEvent")
    watcher.bind(() => this.watchOverlaps())
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
      // Pass P: while step 5's far-side callout would be read through the wheel, the plate
      // is the near-side note: kicker and nearSideLine, on the near side, no leader.
      if (callout.throughWheel) {
        expect(step, "only step 5's callout turns into the near-side note").toBe(5)
        expect(callout.nearNote, "the near-side note shows").toBe(true)
        const text = (findSceneObjectByName("LabelText").getComponent("Component.Text") as Text).text
        expect(text, "the note's line").toBe(STEPS[5].nearSideLine)
        expect(callout.leaderFrom, "no leader on the note").toBe(null)
        if (arrow.isEnabledInHierarchy) {
          const ap = camera.worldSpaceToScreenSpace(arrow.getTransform().getWorldPosition())
          expect(this.inside(ap, plate), `step ${step}: the edge arrow is not on the note`).toBe(false)
        }
        await this.laidOut()
        this.checkTexts(step)
        print(`[UiLayoutScenario] step ${step}: near-side note "${text}"${this.checkInFrame(camera, step, " (note)")}, edge arrow ${arrow.isEnabledInHierarchy ? "on" : "off"}`)
        continue
      }
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
      await this.laidOut()
      this.checkTexts(step)
      note += this.checkInFrame(camera, step, "")
      print(`[UiLayoutScenario] step ${step}: ${note}`)
      // Pass P: every sub-target of the step too (step 2's beads, step 9's beads).
      const subBeads = step === 2 ? [0, 2, 4] : step === 9 ? [0, 1, 2] : []
      for (const b of subBeads) {
        await interactor.tap(`Bead_${b}`)
        await sleep(400)
        print(`[UiLayoutScenario] step ${step} after Bead_${b}:${this.checkInFrame(camera, step, ` after Bead_${b}`)}`)
      }
    }

    // ── Cards: texts inside their plates ─────────────────────────────────────
    for (const step of [0, 7, LAST_STEP]) {
      manager.jumpToStep(step)
      await sleep(500)
      await this.laidOut()
      this.checkTexts(step)
    }
    // ── Pass S1: the Finish card, compact and after More ─────────────────────
    const finish = findSceneObjectByName("FinishCard").getComponent(BenchCoachFinishCardUI.getTypeName()) as BenchCoachFinishCardUI
    expect(finish.expanded, "the Finish card opens compact").toBe(false)
    this.checkFinish(camera, dock, finish, "compact")
    await interactor.tap("BtnFinishMore")
    await sleep(300)
    await this.laidOut()
    expect(finish.expanded, "More expands the Finish card").toBe(true)
    this.checkTexts(LAST_STEP)
    this.checkFinish(camera, dock, finish, "expanded")

    // ── Ask open: the callout and the stack stay off the tire and in view ────
    // Steps 2 and 3 (marker at the top), 5 (far side) and 6 (inspect): Sujeeth's G5 cases.
    const checkStack = (step: number, panelH: number, what: string) => {
      const c = labelObj.getTransform().getWorldPosition()
      const tireOuter = 33.4 * tire.getTransform().getLocalScale().x + 3.2
      const hy = hub().y
      const k = callout.scale
      const top = c.y + callout.scaledHeight() / 2
      const bottom = c.y - callout.scaledHeight() / 2 - (ask.panelGapCm + panelH) * k
      const eye = camera.getTransform().getWorldPosition()
      const flat = Math.sqrt((c.x - eye.x) * (c.x - eye.x) + (c.z - eye.z) * (c.z - eye.z))
      const elev = (Math.atan2(top - eye.y, Math.max(1, flat)) * 180) / Math.PI
      print(`[UiLayoutScenario] Ask on step ${step} (${what}): zone ${callout.zone}, top ${(top - hy).toFixed(1)} / bottom ${(bottom - hy).toFixed(1)} cm from the hub, top ${elev.toFixed(1)} deg above the eye`)
      expect(elev <= 14, `Ask on step ${step} (${what}): top of callout and stack at most 14 degrees above the eye (${elev.toFixed(1)})`).toBe(true)
      if (callout.zone === "inside") {
        const inner = 33.4 * tire.getTransform().getLocalScale().x - 6.5
        const dx = Math.abs(c.x - hub().x) + callout.scaledWidth() / 2
        const dy = Math.max(Math.abs(top - hy), Math.abs(bottom - hy))
        const far = Math.sqrt(dx * dx + dy * dy)
        expect(far <= inner + 0.5, `Ask on step ${step} (${what}): callout and stack inside the clear circle (${far.toFixed(1)} <= ${inner.toFixed(1)} cm)`).toBe(true)
      } else if (callout.zone === "top") {
        expect(bottom > hy + tireOuter, `Ask on step ${step} (${what}): the stack above the tire`).toBe(true)
      } else {
        expect(callout.zone === "bottom", `Ask on step ${step} (${what}): callout in a known zone`).toBe(true)
        expect(top < hy - tireOuter, `Ask on step ${step} (${what}): callout below the tire`).toBe(true)
      }
    }
    for (const step of [2, 3, 5, 6]) {
      manager.jumpToStep(step)
      await sleep(400)
      ask.forceCanned = true
      await interactor.tap("BtnAsk")
      await sleep(400)
      checkStack(step, ask.chips.height, "chips")
      await this.laidOut()
      this.checkTexts(step)
      await interactor.tap("AskChip_0")
      await sleep(400)
      checkStack(step, (findSceneObjectByName("AskAnswerPanel").getComponent(BenchCoachAskAnswerUI.getTypeName()) as BenchCoachAskAnswerUI).panelHeight, "answer")
      await this.laidOut()
      this.checkTexts(step)
      await interactor.tap("BtnAsk")
      await sleep(300)
      ask.forceCanned = false
    }

    // ── What's this?: the info card sits beside its part ─────────────────────
    // Never on the step callout; pass P: never on the part's own pinch box or the marker
    // ring, and inside the view, for every part that can be pinched (steps 1, 4 and 5).
    for (const step of [1, 4, 5]) {
      manager.jumpToStep(step)
      await sleep(400)
      await interactor.tap("BtnWhatsThis")
      await sleep(300)
      const hits = findSceneObjectByName("InfoHits")
      const parts: string[] = []
      for (let i = 0; i < hits.getChildrenCount(); i++) {
        const h = hits.getChild(i)
        if (h.enabled && this.onScreen(camera, h.getTransform().getWorldPosition())) parts.push(h.name.substring("InfoHit_".length))
      }
      for (const part of parts) {
        await interactor.tap(`InfoHit_${part}`)
        await sleep(300)
        const ic = info.sceneObject.getTransform().getWorldPosition()
        const k = info.sceneObject.getTransform().getWorldScale().x
        const ir = this.screenRect(camera, ic, this.flatRight(ic), info.panelWidth * k, info.panelHeight * k)
        // Hard for the footage parts (Valve, Tire) at any pose, and for every part whose card
        // found a spot clear of the part, the step callout and the frame edge (from Sunlit
        // Room's straight-ahead default pose lever A's tall handle leaves no such spot).
        const hard = part === "Valve" || part === "Tire" || info.clearOfPart
        const must = (ok: boolean, what: string) => {
          if (hard) expect(ok, `What's this? ${part} on step ${step}: ${what}`).toBe(true)
          else if (!ok) print(`[UiLayoutScenario] What's this? ${part} on step ${step}: no clean spot from this pose (${what} fails)`)
        }
        if (labelObj.isEnabledInHierarchy && !(callout.throughWheel && !callout.nearNote)) {
          const sc = labelObj.getTransform().getWorldPosition()
          const sr = this.screenRect(camera, sc, this.flatRight(sc), callout.scaledWidth(), callout.scaledHeight())
          must(!this.overlaps(ir, sr), "the card does not overlap the step callout")
        }
        const box = this.boxRect(camera, findSceneObjectByName(`InfoHit_${part}`))
        must(!this.overlaps(ir, box), "the card does not cover the part")
        // The marker ring: kept clear whenever a spot allows it. Asserted for the valve and the
        // tire (the footage cases); logged for the rest (on step 1 the Hub has no spot clear of
        // the valve ring, the callout and the hub at once).
        const ring = callout.markerAt()
        let ringNote = "no ring"
        if (ring) {
          const rr = this.screenRect(camera, ring, this.flatRight(ring), 4.4, 4.4)
          const covers = this.overlaps(ir, rr)
          ringNote = covers ? "covers the marker ring" : "ring clear"
          if (part === "Valve" || part === "Tire") expect(covers, `What's this? ${part} on step ${step}: the card does not cover the marker ring`).toBe(false)
        }
        must(ir.x0 >= 0 && ir.x1 <= 1 && ir.y0 >= 0 && ir.y1 <= 1, "the card is inside the view")
        print(`[UiLayoutScenario] What's this? ${part} on step ${step}: card x ${ir.x0.toFixed(2)}..${ir.x1.toFixed(2)}, y ${ir.y0.toFixed(2)}..${ir.y1.toFixed(2)}, ${ringNote}`)
        await this.laidOut()
        this.checkTexts(step)
      }
      await interactor.tap("BtnWhatsThis")
      await sleep(300)
    }
    manager.reset()
    await sleep(300)
    watcher.enabled = false
    print(`[UiLayoutScenario] ${this.framesWatched} frames watched for overlapping texts, ${this.overlapsSeen.length} with an overlap`)
    expect(this.overlapsSeen.length === 0, `no two texts overlap on one plate in any frame (${this.overlapsSeen.slice(0, 3).join("; ")})`).toBe(true)
  }

  /** Pass P: every frame, the visible Texts of each panel, as rectangles in the plate's plane, do not overlap. */
  private watchOverlaps(): void {
    this.framesWatched++
    for (const name of PANELS) {
      const so = findSceneObjectByName(name)
      if (!so || !so.isEnabledInHierarchy) continue
      const inv = so.getTransform().getInvertedWorldTransform()
      const rects: {n: string; r: Rect}[] = []
      for (const t of this.texts(so)) {
        const tr = t.getSceneObject().getTransform()
        if (tr.getWorldScale().x < 1e-3 || tr.getWorldScale().y < 1e-3) continue
        const r = t.layoutRect
        const m = tr.getWorldTransform()
        let x0 = 1e9
        let x1 = -1e9
        let y0 = 1e9
        let y1 = -1e9
        for (const p of [new vec3(r.left, r.bottom, 0), new vec3(r.right, r.top, 0)]) {
          const l = inv.multiplyPoint(m.multiplyPoint(p))
          x0 = Math.min(x0, l.x)
          x1 = Math.max(x1, l.x)
          y0 = Math.min(y0, l.y)
          y1 = Math.max(y1, l.y)
        }
        // 0.05 cm of slack: touching rows are not an overlap.
        rects.push({n: t.getSceneObject().name, r: {x0: x0 + 0.05, x1: x1 - 0.05, y0: y0 + 0.05, y1: y1 - 0.05}})
      }
      for (let i = 0; i < rects.length; i++) {
        for (let j = i + 1; j < rects.length; j++) {
          if (this.overlaps(rects[i].r, rects[j].r)) {
            const what = `frame ${this.framesWatched}: ${name} ${rects[i].n} over ${rects[j].n}`
            if (this.overlapsSeen.length < 20) print(`[UiLayoutScenario] overlap ${what}`)
            this.overlapsSeen.push(what)
          }
        }
      }
    }
  }

  /**
   * Pass P: while the hub is in view, every corner of the step callout is inside the view
   * with 1% to spare (the callout keeps VIEW_MARGIN, 2%, so this is not flaky).
   */
  private checkInFrame(camera: Camera, step: number, what: string): string {
    const labelObj = findSceneObjectByName("StepLabel")
    const marker = findSceneObjectByName("StepMarker")
    const callout = labelObj.getComponent(BenchCoachStepLabelUI.getTypeName()) as BenchCoachStepLabelUI
    if (!labelObj.isEnabledInHierarchy || (!marker.isEnabledInHierarchy && !callout.nearNote) || (callout.throughWheel && !callout.nearNote)) return ""
    // While the user looks at the wheel (hub in view), even if the marker is not (step 2's beads 3 and 4).
    const hub = findSceneObjectByName("Wheel").getTransform().getWorldPosition()
    const hp = camera.worldSpaceToScreenSpace(hub)
    if (!camera.isSphereVisible(hub, 0.1) || hp.x < 0 || hp.x > 1 || hp.y < 0 || hp.y > 1) return ", hub out of view (frame not checked)"
    const c = labelObj.getTransform().getWorldPosition()
    const r = this.screenRect(camera, c, this.flatRight(c), callout.scaledWidth(), callout.scaledHeight())
    const ok = r.x0 >= 0.01 && r.x1 <= 0.99 && r.y0 >= 0.01 && r.y1 <= 0.99
    const desc = `x ${r.x0.toFixed(3)}..${r.x1.toFixed(3)}, y ${r.y0.toFixed(3)}..${r.y1.toFixed(3)}`
    expect(ok, `step ${step}${what}: the callout is fully inside the view (${desc})`).toBe(true)
    return `, in frame (${desc})`
  }

  /**
   * Pass S1: while the eye looks at the card (within 3 degrees of where the expanded card is
   * centred), the Finish card's plate is inside the view (1% margin); each of its buttons is
   * at least as tall in degrees as the dock's buttons and off the dock on screen.
   */
  private checkFinish(camera: Camera, dock: BenchCoachControlBarUI, card: BenchCoachFinishCardUI, what: string): void {
    const tr = card.sceneObject.getTransform()
    const k = tr.getWorldScale().x
    const h = (card.expanded ? card.expandedHeight : card.compactHeight) * k
    const r = this.screenRect(camera, tr.getWorldPosition(), tr.right, card.width * k, h, tr.up)
    let desc = `x ${r.x0.toFixed(3)}..${r.x1.toFixed(3)}, y ${r.y0.toFixed(3)}..${r.y1.toFixed(3)}`
    const eye = camera.getTransform().getWorldPosition()
    // The expanded card is centred where the card is authored; the compact one is lifted by half the difference.
    const lift = ((card.expandedHeight - h / k) / 2) * k
    const anchor = tr.getWorldPosition().sub(new vec3(0, lift, 0))
    const view = camera.getTransform().forward.uniformScale(-1)
    const off = (Math.acos(Math.max(-1, Math.min(1, view.dot(anchor.sub(eye).normalize())))) * 180) / Math.PI
    if (off <= 3) {
      expect(r.x0 >= 0.01 && r.x1 <= 0.99 && r.y0 >= 0.01 && r.y1 <= 0.99, `Finish card ${what}: inside the view (${desc})`).toBe(true)
    } else desc += ` (the eye looks ${off.toFixed(1)} deg away from the card: frame not checked)`
    const deg = (so: SceneObject): number => {
      const size = this.sizeOf(so)
      const hh = size ? size.y * so.getTransform().getWorldScale().y : 0
      return (2 * Math.atan2(hh / 2, so.getTransform().getWorldPosition().distance(eye)) * 180) / Math.PI
    }
    const dockDeg = deg(findSceneObjectByName("BtnBack"))
    expect(dockDeg > 1, `the dock's button size is read (${dockDeg.toFixed(2)} deg)`).toBe(true)
    const dt = dock.sceneObject.getTransform()
    const dr = this.screenRect(camera, dt.getWorldPosition(), dt.right, dock.width, dock.height, dt.up)
    let note = ""
    for (const name of ["BtnFinishMore", "BtnRestart"]) {
      const b = findSceneObjectByName(name)
      const bd = deg(b)
      note += `, ${name} ${bd.toFixed(2)} deg`
      expect(bd >= dockDeg * 0.98, `Finish card ${what}: ${name} ${bd.toFixed(2)} deg at least the dock's ${dockDeg.toFixed(2)} deg`).toBe(true)
      const size = this.sizeOf(b)
      const bt = b.getTransform()
      const br = this.screenRect(camera, bt.getWorldPosition(), bt.right, size ? size.x : 0, size ? size.y : 0, bt.up)
      expect(dock.sceneObject.isEnabledInHierarchy && this.overlaps(br, dr), `Finish card ${what}: ${name} is not under the dock`).toBe(false)
    }
    print(`[UiLayoutScenario] Finish card ${what}: ${desc}; dock buttons ${dockDeg.toFixed(2)} deg${note}`)
  }

  /** A UIKit element's size (cm, the `size` of a script component on it), or null. */
  private sizeOf(so: SceneObject): vec3 | null {
    for (const c of so.getComponents("Component.ScriptComponent")) {
      const s = (c as any).size
      if (s && typeof s.x === "number" && typeof s.y === "number") return new vec3(s.x, s.y, 0)
    }
    return null
  }

  /**
   * Pass P: a panel's flex column stays at zero scale until its first layout (one frame
   * at a normal frame rate; longer right after a slow Lens start). Waits for it, at most 3 s.
   */
  private async laidOut(): Promise<void> {
    for (let i = 0; i < 30; i++) {
      let pending = false
      for (const name of PANELS) {
        const so = findSceneObjectByName(name)
        if (!so || !so.isEnabledInHierarchy) continue
        for (const t of this.texts(so)) if (t.getSceneObject().getTransform().getWorldScale().x < 1e-3) pending = true
      }
      if (!pending) return
      await sleep(100)
    }
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
        this.checkSize(step, name, t)
      }
    }
    if (checked === 0) print(`[UiLayoutScenario] step ${step}: no panel texts to check`)
  }

  /** Pass V: the text's x-height in degrees from the live eye meets its role's minimum. */
  private checkSize(step: number, panel: string, t: Text): void {
    const name = t.getSceneObject().name
    const min = BODY_TEXTS.indexOf(name) >= 0 ? MIN_BODY_XHEIGHT_DEG : TITLE_TEXTS.indexOf(name) >= 0 ? MIN_TITLE_XHEIGHT_DEG : 0
    if (min === 0) return
    // Step 5's callout (and the Ask stack under it) faces the far side: it is read from there,
    // about 35 cm away, and keeps its apparent size; from the start eye it is seen past the
    // wheel. Checked on the far-side capture instead.
    // Pass P: the near-side note is read from here, so it is checked.
    const note = (findSceneObjectByName("StepLabel").getComponent(BenchCoachStepLabelUI.getTypeName()) as BenchCoachStepLabelUI).nearNote
    if (step === 5 && !(note && panel === "StepLabel") && ["StepLabel", "AskChipsPanel", "AskAnswerPanel"].indexOf(panel) >= 0) return
    const cam = findSceneObjectByName("Camera Object").getTransform().getWorldPosition()
    const deg = xHeightDeg(t, t.getSceneObject().getTransform().getWorldPosition().distance(cam))
    print(`[UiLayoutScenario] step ${step}: ${panel}/${name} x-height ${deg.toFixed(2)} deg (min ${min})`)
    expect(deg >= min, `step ${step}: ${panel}/${name} x-height ${deg.toFixed(2)} >= ${min} degrees`).toBe(true)
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

  private onScreen(camera: Camera, p: vec3): boolean {
    const q = camera.worldSpaceToScreenSpace(p)
    return camera.isSphereVisible(p, 0.1) && q.x > 0.02 && q.x < 0.98 && q.y > 0.02 && q.y < 0.98
  }

  /** Screen rectangle of a pinch box (its box collider, from its world transform). */
  private boxRect(camera: Camera, so: SceneObject): Rect {
    const col = so.getComponent("Physics.ColliderComponent") as ColliderComponent
    const s = col ? (col.shape as BoxShape).size : new vec3(4, 4, 4)
    const m = so.getTransform().getWorldTransform()
    let x0 = 2
    let x1 = -1
    let y0 = 2
    let y1 = -1
    for (const sx of [-0.5, 0.5]) {
      for (const sy of [-0.5, 0.5]) {
        for (const sz of [-0.5, 0.5]) {
          const q = camera.worldSpaceToScreenSpace(m.multiplyPoint(new vec3(sx * s.x, sy * s.y, sz * s.z)))
          x0 = Math.min(x0, q.x)
          x1 = Math.max(x1, q.x)
          y0 = Math.min(y0, q.y)
          y1 = Math.max(y1, q.y)
        }
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
