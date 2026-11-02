/**
 * BenchCoachControlBarUI — the always-on control bar: BtnWhatsThis, BtnAsk, BtnBack,
 * BtnNext and BtnReplay as icon-only UIKit Buttons in one row, with a strip under the
 * row for the progress rail (ControlBar/ProgressRail sits in it).
 * BtnWhatsThis and BtnAsk are UIKit toggles, so their latched look shows while the mode is on.
 * Owns: only its view. Emits onBack / onNext / onReplay / onWhatsThis(on) / onAsk(on).
 * setWhatsThisLatched() / setAskLatched() sync the toggle looks. Holds no repair state.
 * Pass F: once every button is up, logs each hit box along the bar against its visual
 * and flags any overlap (`hitBoxes` keeps the numbers for tests).
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Button} from "SpectaclesUIKit.lspkg/Scripts/Components/Button/Button"
import {ElementContent} from "SpectaclesUIKit.lspkg/Scripts/Components/Content/ElementContent"
import {RoundedRectangle} from "SpectaclesUIKit.lspkg/Scripts/Visuals/RoundedRectangle/RoundedRectangle"
import {BodyFollow} from "./BodyFollow"
import {ProgressRail} from "./ProgressRail"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {addIconButton, backPlatePanel, flexRow} from "./UIHelpers"

const ICON_BACK: Texture = requireAsset("../../Icons/arrow_back.png") as Texture
const ICON_NEXT: Texture = requireAsset("../../Icons/arrow_forward.png") as Texture
const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture
const ICON_INFO: Texture = requireAsset("../../Icons/info.png") as Texture
const ICON_ASK: Texture = requireAsset("../../Icons/help.png") as Texture
/** Pass G3: a toggle that is on shows a close icon, so "on" is a shape as well as UIKit's tint. */
const ICON_CLOSE: Texture = requireAsset("../../Icons/close.png") as Texture

@component
export class BenchCoachControlBarUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachControlBarUI – What\'s this? / Ask / Back / Next / Replay</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Back button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  backSize: number = 3.5

  @input
  @hint("Next button size in cm (the brightest, largest target)")
  @widget(new SliderWidget(3, 10, 0.5))
  nextSize: number = 6

  @input
  @hint("Replay button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  replaySize: number = 3.5

  @input
  @hint("What's this? button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  whatsThisSize: number = 3.5

  @input
  @hint("Ask button size in cm")
  @widget(new SliderWidget(3, 10, 0.5))
  askSize: number = 3.5

  @input
  @hint("Gap between buttons in cm")
  @widget(new SliderWidget(0.4, 5, 0.1))
  gap: number = 1.1

  @input
  @hint("Opacity while a part is held or the user looks at the wheel (Nov 1 audit: show it only when needed); 1 = never fade")
  @widget(new SliderWidget(0, 1, 0.05))
  faintOpacity: number = 0.3

  @input
  @hint("Camera pitch, in degrees below level, past which the user is looking down at the bar and it comes back to full")
  @widget(new SliderWidget(5, 45, 1))
  lookDownDeg: number = 22

  @input
  @hint("Seconds for a fade between faint and full")
  @widget(new SliderWidget(0, 2, 0.05))
  fadeSec: number = 0.3

  @input
  @hint("Panel padding above and below the buttons in cm")
  @widget(new SliderWidget(0.5, 4, 0.25))
  padding: number = 1

  @input
  @hint("Panel padding left and right of the buttons in cm")
  @widget(new SliderWidget(0.25, 4, 0.25))
  padX: number = 0.75

  @input
  @hint("Height of the strip under the buttons for the progress rail, in cm (0 = none)")
  @widget(new SliderWidget(0, 4, 0.1))
  railStripCm: number = 1.6
  @ui.group_end

  private _onBack = new Event<void>()
  private _onNext = new Event<void>()
  private _onReplay = new Event<void>()
  private _onWhatsThis = new Event<boolean>()
  onBack: PublicApi<void> = this._onBack.publicApi()
  onNext: PublicApi<void> = this._onNext.publicApi()
  onReplay: PublicApi<void> = this._onReplay.publicApi()
  /** The What's this? toggle changed (by a press or by setWhatsThisLatched). */
  onWhatsThis: PublicApi<boolean> = this._onWhatsThis.publicApi()
  private _onAsk = new Event<boolean>()
  /** The Ask toggle changed (by a press or by setAskLatched). */
  onAsk: PublicApi<boolean> = this._onAsk.publicApi()

  /** Current latched state of BtnAsk. */
  askOn: boolean = false

  /** Current latched state of BtnWhatsThis. */
  whatsThisOn: boolean = false

  private whatsThis: Button | null = null
  private ask: Button | null = null
  private buttons: Button[] = []

  /** Hit boxes along the bar, in cm from its center, once measured (tests read it). */
  hitBoxes: {name: string; left: number; right: number; visualWidth: number}[] = []
  /** Current bar opacity (0..1). */
  opacity: number = 1
  /** Why the bar is faint: "held", "wheel", or "" while full (hovered, or looking down at it). */
  faintReason: string = ""
  private hoverCount = 0
  private follow: BodyFollow | null = null
  private rail: ProgressRail | null = null
  private plate: RoundedRectangle | null = null
  private contents: ElementContent[] = []
  private fadeReady = false

  /** True once the hit boxes were measured, each matches its visual width and none overlaps its neighbor. */
  hitBoxesClear: boolean = false

  /** Show the Ask toggle as on or off (no-op if it already is). */
  setAskLatched(on: boolean): void {
    if (this.ask && this.ask.isOn !== on) this.ask.isOn = on
    this.setToggleIcon(this.ask, on, ICON_ASK)
  }

  /** Show the What's this? toggle as on or off (no-op if it already is). */
  setWhatsThisLatched(on: boolean): void {
    if (this.whatsThis && this.whatsThis.isOn !== on) this.whatsThis.isOn = on
    this.setToggleIcon(this.whatsThis, on, ICON_INFO)
  }

  /** Icon of a toggle: its own while off, close while on (never colour alone). */
  private setToggleIcon(btn: Button | null, on: boolean, offIcon: Texture): void {
    if (!btn) return
    const ec = btn.getSceneObject().getComponent(ElementContent.getTypeName()) as ElementContent | null
    if (ec) ec.leadingIcon = on ? ICON_CLOSE : offIcon
  }

  onAwake(): void {
    const w =
      this.backSize + this.nextSize + this.replaySize + this.whatsThisSize + this.askSize + 4 * this.gap + 2 * this.padX
    const rowH = this.nextSize + 2 * this.padding
    const h = rowH + this.railStripCm
    const panel = backPlatePanel(this.sceneObject, w, h)
    const row = flexRow(panel.content, w, rowH, {
      gap: this.gap,
      padX: this.padX,
      padY: this.padding,
      justify: FlexJustify.Center,
      align: FlexAlign.Center,
    })
    // The row sits in the top part of the panel; the rail strip is underneath.
    const rp = row.getTransform().getLocalPosition()
    row.getTransform().setLocalPosition(new vec3(rp.x, rp.y + this.railStripCm / 2, rp.z))
    // What's this? and Ask sit at the left end (the tool tray is on the right). F4 (pass 10)
    // kept the bar at 25.1 cm so, looking 32 degrees down, every button and the rail are in
    // view and the right end clears the tray. The Nov 1 target audit widened it to 25.9 cm
    // (secondary buttons 3.5 cm, gap 1.1 so neighbors are 1 degree apart at 57 cm, side
    // padding 0.75; Next stays 6 cm), which is 0.4 cm per side: still clear of the tray.
    const btn = addIconButton(row, "BtnWhatsThis", ICON_INFO, this.whatsThisSize, () => {})
    const askBtn = addIconButton(row, "BtnAsk", ICON_ASK, this.askSize, () => {})
    const backBtn = addIconButton(row, "BtnBack", ICON_BACK, this.backSize, () => this._onBack.invoke())
    const nextBtn = addIconButton(row, "BtnNext", ICON_NEXT, this.nextSize, () => this._onNext.invoke())
    const replayBtn = addIconButton(row, "BtnReplay", ICON_REPLAY, this.replaySize, () => this._onReplay.invoke())
    this.buttons = [btn, askBtn, backBtn, nextBtn, replayBtn]
    btn.onInitialized.add(() => btn.setIsToggleable(true))
    btn.onValueChange.add((v) => {
      this.whatsThisOn = v === 1
      this.setToggleIcon(btn, this.whatsThisOn, ICON_INFO)
      this._onWhatsThis.invoke(this.whatsThisOn)
    })
    this.whatsThis = btn
    askBtn.onInitialized.add(() => askBtn.setIsToggleable(true))
    askBtn.onValueChange.add((v) => {
      this.askOn = v === 1
      this.setToggleIcon(askBtn, this.askOn, ICON_ASK)
      this._onAsk.invoke(this.askOn)
    })
    this.ask = askBtn
    // Measure once the buttons are up and FlexLayout has placed them (it lays out a few
    // frames after init; until then every button sits at the bar's center).
    this.follow = this.sceneObject.getComponent(BodyFollow.getTypeName()) as BodyFollow | null
    for (let i = 0; i < this.sceneObject.getChildrenCount(); i++) {
      const r = this.sceneObject.getChild(i).getComponent(ProgressRail.getTypeName()) as ProgressRail | null
      if (r) this.rail = r
    }
    for (const b of this.buttons) {
      b.onInitialized.add(() => {
        b.interactable.onHoverEnter.add(() => (this.hoverCount += 1))
        b.interactable.onHoverExit.add(() => (this.hoverCount = Math.max(0, this.hoverCount - 1)))
      })
    }
    this.createEvent("LateUpdateEvent").bind(() => this.fadeTick())
    let settled = 0
    const check = this.createEvent("UpdateEvent")
    check.bind(() => {
      if (!this.buttons.every((b) => b.initialized)) return
      if (++settled < 30) return
      check.enabled = false
      this.logHitBoxes()
    })
  }

  /**
   * Show it only when needed (Nov 1 audit): the bar fades to faintOpacity while a lever
   * or the tube end is held, or while the user looks at the wheel rather than down at the
   * bar; it returns to full when a button is hovered or the camera pitches down past
   * lookDownDeg. Hover wins, so a ray on the bar always sees it solid.
   */
  private fadeTick(): void {
    if (!this.fadeReady) {
      if (!this.buttons.every((b) => b.initialized)) return
      this.plate = this.sceneObject.getComponent(RoundedRectangle.getTypeName()) as RoundedRectangle | null
      this.contents = this.buttons
        .map((b) => b.getSceneObject().getComponent(ElementContent.getTypeName()) as ElementContent | null)
        .filter((c) => !!c) as ElementContent[]
      this.fadeReady = true
    }
    let reason = ""
    if (this.hoverCount === 0 && this.faintOpacity < 1) {
      if (this.follow && this.follow.isHeld()) reason = "held"
      else if (!this.lookingDown()) reason = "wheel"
    }
    this.faintReason = reason
    const target = reason ? this.faintOpacity : 1
    if (this.opacity === target) return
    const step = this.fadeSec > 0 ? getDeltaTime() / this.fadeSec : 1
    const o = this.opacity < target ? Math.min(target, this.opacity + step) : Math.max(target, this.opacity - step)
    this.applyOpacity(o)
  }

  /** Camera pitch at least lookDownDeg below level, with a 3 degree band so it doesn't flicker. */
  private lookingDown(): boolean {
    const cam = this.follow ? this.follow.camera : null
    if (!cam) return true
    const look = cam.getTransform().getWorldRotation().multiplyVec3(new vec3(0, 0, -1))
    const downDeg = (-Math.asin(Math.max(-1, Math.min(1, look.y))) * 180) / Math.PI
    return downDeg >= this.lookDownDeg - (this.faintReason === "wheel" ? 0 : 3)
  }

  private applyOpacity(o: number): void {
    this.opacity = o
    if (this.plate) this.plate.opacity = o
    for (const b of this.buttons) b.opacity = o
    for (const c of this.contents) c.opacity = o
    if (this.rail) this.rail.setOpacity(o)
  }

  /** Measures each button's live collider along the bar's x axis and logs it. */
  private logHitBoxes(): void {
    const bar = this.sceneObject.getTransform()
    const origin = bar.getWorldPosition()
    const right = bar.right
    this.hitBoxes = this.buttons.map((b) => {
      const tr = b.collider.getSceneObject().getTransform()
      const half = ((b.collider.shape as BoxShape).size.x * tr.getWorldScale().x) / 2
      const c = tr.getWorldPosition().sub(origin).dot(right)
      return {name: b.getSceneObject().name, left: c - half, right: c + half, visualWidth: b.size.x}
    })
    const parts: string[] = []
    let clear = true
    for (let i = 0; i < this.hitBoxes.length; i++) {
      const h = this.hitBoxes[i]
      const next = this.hitBoxes[i + 1]
      const gap = next ? next.left - h.right : NaN
      if (next && gap < 0) clear = false
      if (Math.abs(h.right - h.left - h.visualWidth) > 0.05) clear = false
      parts.push(
        `${h.name} ${h.left.toFixed(2)}..${h.right.toFixed(2)} (hit ${(h.right - h.left).toFixed(2)}, visual ${h.visualWidth.toFixed(2)})` +
          (next ? ` gap ${gap.toFixed(2)}` : "")
      )
    }
    this.hitBoxesClear = clear
    print(`[ControlBar] hit boxes along the bar (cm): ${parts.join("; ")}: ${clear ? "match the visuals, no overlap" : "MISMATCH OR OVERLAP"}`)
  }
}
