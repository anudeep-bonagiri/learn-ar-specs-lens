/**
 * BenchCoachControlBarUI — the dock (pass D2; replaces the control-bar slab and the
 * progress dots). One slim plate, body-followed low on the user's left (out of the
 * right hand's path to the wheel and the tool tray, never over the work):
 *  - pass B, a row of three: BtnBack, BtnNext (the accent primary, with its label), BtnMore;
 *  - under it the progress: "4 / 10" and a thin bar (ControlBar/ProgressRail, on the two
 *    cards only since pass B).
 * BtnMore toggles a small popover on top of the dock: BtnReplay first (pass B: rarely
 * used, so out of the dock), then the two learning tools, BtnWhatsThis and BtnAsk (UIKit
 * toggles: latched in the accent while the mode is on), and under them BtnVoice (pass V:
 * the voice coach, on by default; a speaker icon while on, a crossed-out speaker while
 * off, so the state is never colour alone).
 * While watch mode plays, a pill on top of the dock says "Watching the coach" with
 * BtnStopWatch.
 * Owns: only its view. Emits onBack / onNext / onReplay / onWhatsThis(on) / onAsk(on) /
 * onStopWatch. setWhatsThisLatched() / setAskLatched() sync the toggle looks;
 * setProgress(step) and setWatching(on) push state in. Holds no repair state.
 * Pass F: once every button is up, logs each row's hit boxes against their visuals
 * and flags any overlap (`hitBoxes` keeps the numbers for tests).
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Button} from "SpectaclesUIKit.lspkg/Scripts/Components/Button/Button"
import {ProgressRail} from "./ProgressRail"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {
  COLOR,
  addIconButton,
  addLabelButton,
  addUIText,
  addRowImage,
  charCm,
  flexChild,
  flexRow,
  grid,
  lineCm,
  makePlate,
  obj,
  setButtonIcon,
} from "./UIHelpers"

const ICON_BACK: Texture = requireAsset("../../Icons/arrow_back.png") as Texture
const ICON_NEXT: Texture = requireAsset("../../Icons/arrow_forward.png") as Texture
const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture
const ICON_INFO: Texture = requireAsset("../../Icons/info.png") as Texture
const ICON_ASK: Texture = requireAsset("../../Icons/help.png") as Texture
const ICON_MORE: Texture = requireAsset("../../Icons/more_horiz.png") as Texture
const ICON_PLAY: Texture = requireAsset("../../Icons/play_arrow.png") as Texture
const ICON_STOP: Texture = requireAsset("../../Icons/stop.png") as Texture
/** Pass G3 (Sujeeth), on D2's popover: a toggle that is on shows a close cross, not only the accent tint. */
const ICON_CLOSE: Texture = requireAsset("../../Icons/close.png") as Texture
/** Pass V: the Voice toggle's two states. */
const ICON_VOICE_ON: Texture = requireAsset("../../Icons/volume_up.png") as Texture
const ICON_VOICE_OFF: Texture = requireAsset("../../Icons/volume_off.png") as Texture

@component
export class BenchCoachControlBarUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachControlBarUI – the dock: Back / Next / More, progress, watch pill</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(30, 120, 1))
  viewDistanceCm: number = 48

  @input
  @hint("Icon button size in cm (Back, More)")
  @widget(new SliderWidget(2.5, 8, 0.1))
  buttonSize: number = 4

  @input
  @hint("Width of the Next button in cm (the primary action, with its label)")
  @widget(new SliderWidget(4, 12, 0.1))
  nextWidth: number = 7

  @input
  @hint("Gap between buttons in cm (0.85 is 1 degree at 48 cm: Snap's spacing rule, pass G / M)")
  @widget(new SliderWidget(0.2, 2, 0.05))
  gap: number = 0.85

  @input
  @hint("Steps in the repair (the progress reads 'N / this')")
  totalSteps: number = 10

  @input
  @hint("Label on the Next button")
  nextLabel: string = "Next"
  @ui.group_end

  private _onBack = new Event<void>()
  private _onNext = new Event<void>()
  private _onReplay = new Event<void>()
  private _onWhatsThis = new Event<boolean>()
  private _onStopWatch = new Event<void>()
  onBack: PublicApi<void> = this._onBack.publicApi()
  onNext: PublicApi<void> = this._onNext.publicApi()
  onReplay: PublicApi<void> = this._onReplay.publicApi()
  /** The What's this? toggle changed (by a press or by setWhatsThisLatched). */
  onWhatsThis: PublicApi<boolean> = this._onWhatsThis.publicApi()
  private _onAsk = new Event<boolean>()
  /** The Ask toggle changed (by a press or by setAskLatched). */
  onAsk: PublicApi<boolean> = this._onAsk.publicApi()
  private _onVoice = new Event<boolean>()
  /** The Voice toggle changed (by a press or by setVoiceLatched). */
  onVoice: PublicApi<boolean> = this._onVoice.publicApi()
  /** Stop on the watch pill. */
  onStopWatch: PublicApi<void> = this._onStopWatch.publicApi()
  private _onMore = new Event<boolean>()
  /** BtnMore opened or closed the popover (a press, not a sync). */
  onMore: PublicApi<boolean> = this._onMore.publicApi()

  /** Current latched state of BtnAsk. */
  askOn: boolean = false
  /** Current latched state of BtnVoice (on by default). */
  voiceOn: boolean = true
  /** BtnVoice shows the speaker (on) rather than the crossed-out speaker; tests read it. */
  voiceIconOn: boolean = true
  /** Current latched state of BtnWhatsThis. */
  whatsThisOn: boolean = false
  /** The More popover is open. */
  moreOpen: boolean = false
  /** The watch pill is showing. */
  watching: boolean = false
  /** Text of the progress counter ("4 / 10"). */
  progressText: string = ""
  /** Dock plate size in cm (tests and EdgeHint read it). */
  width: number = 0
  height: number = 0

  private whatsThis: Button | null = null
  private ask: Button | null = null
  private voice: Button | null = null
  private more: Button | null = null
  private rowButtons: Button[] = []
  private popButtons: Button[] = []
  private popover: SceneObject | null = null
  private pill: SceneObject | null = null
  private counter: Text | null = null
  private popoverH = 0
  private pillH = 0
  private hiddenOnce = false

  /** Hit boxes along each row, in cm from the dock's center, once measured (tests read it). */
  hitBoxes: {name: string; row: string; left: number; right: number; visualWidth: number}[] = []
  /** True once the hit boxes were measured, each matches its visual width and none overlaps its neighbor. */
  hitBoxesClear: boolean = false

  /** The What's this? toggle shows the close cross (it is on); tests read it. */
  whatsThisIconClose: boolean = false
  /** The Ask toggle shows the close cross (it is on); tests read it. */
  askIconClose: boolean = false

  /** Show the Ask toggle as on or off (no-op if it already is). */
  setAskLatched(on: boolean): void {
    if (this.ask && this.ask.isOn !== on) this.ask.isOn = on
    this.syncToggleIcons()
  }

  /** Show the Voice toggle as on or off (no-op if it already is). */
  setVoiceLatched(on: boolean): void {
    this.voiceOn = on
    if (this.voice && this.voice.initialized && this.voice.isOn !== on) this.voice.isOn = on
    this.syncToggleIcons()
  }

  /** Show the What's this? toggle as on or off (no-op if it already is). */
  setWhatsThisLatched(on: boolean): void {
    if (this.whatsThis && this.whatsThis.isOn !== on) this.whatsThis.isOn = on
    this.syncToggleIcons()
  }

  /** Each toggle's icon: its own while off, the close cross while on (never colour alone). */
  private syncToggleIcons(): void {
    const info = !!this.whatsThis && this.whatsThis.isOn
    const ask = !!this.ask && this.ask.isOn
    if (setButtonIcon(this.whatsThis, info ? ICON_CLOSE : ICON_INFO)) this.whatsThisIconClose = info
    if (setButtonIcon(this.ask, ask ? ICON_CLOSE : ICON_ASK)) this.askIconClose = ask
    const voice = this.voice && this.voice.initialized ? this.voice.isOn : this.voiceOn
    if (setButtonIcon(this.voice, voice ? ICON_VOICE_ON : ICON_VOICE_OFF)) this.voiceIconOn = voice
  }

  /** Open or close the More popover (BtnMore's latch follows). */
  setMoreOpen(on: boolean): void {
    this.moreOpen = on
    if (this.more && this.more.isOn !== on) this.more.isOn = on
    if (this.popover && this.hiddenOnce) this.popover.enabled = on
    this.layoutTop()
  }

  /** Progress: "N / 10" (the halfway card is 7; the start card shows 0). */
  setProgress(step: number): void {
    const n = Math.max(0, Math.min(this.totalSteps, step))
    this.progressText = `${n} / ${this.totalSteps}`
    if (this.counter) this.counter.text = this.progressText
  }

  /** Watch mode playing: show the pill (and close the popover). */
  setWatching(on: boolean): void {
    if (this.watching === on) return
    this.watching = on
    if (on && this.moreOpen) this.setMoreOpen(false)
    if (this.pill && this.hiddenOnce) this.pill.enabled = on
    this.layoutTop()
  }

  onAwake(): void {
    const d = this.viewDistanceCm
    const g = grid(d)
    const s = this.buttonSize
    const rowW = 2 * s + this.nextWidth + 2 * this.gap
    const w = rowW + 2 * g.pad
    // Pass B: the dock lost Replay, but the popover and the pill keep the width they had,
    // so their labels do not shrink.
    const wideW = rowW + s + this.gap + 2 * g.pad
    const progH = lineCm("body", d)
    const h = g.pad + s + g.gap + progH + g.pad * 0.8
    this.width = w
    this.height = h
    const plate = makePlate(this.sceneObject, w, h, d)
    // Button row in the top part of the plate.
    const rowY = h / 2 - g.pad - s / 2
    const rowHolder = obj(plate.content, "Row", new vec3(0, rowY, 0))
    const row = flexRow(rowHolder, rowW, s, {gap: this.gap, justify: FlexJustify.Center, align: FlexAlign.Center})
    const backBtn = addIconButton(row, "BtnBack", ICON_BACK, s, () => this._onBack.invoke(), d)
    const nextBtn = addLabelButton(row, "BtnNext", this.nextLabel, ICON_NEXT, this.nextWidth, s, d, () => this._onNext.invoke(), "primary")
    const moreBtn = addIconButton(row, "BtnMore", ICON_MORE, s, () => {}, d)
    this.rowButtons = [backBtn, nextBtn, moreBtn]
    this.more = moreBtn
    moreBtn.onInitialized.add(() => moreBtn.setIsToggleable(true))
    moreBtn.onValueChange.add((v) => {
      const on = v === 1
      if (on === this.moreOpen) return
      print(`[ControlBar] More ${on ? "open" : "closed"}`)
      this.setMoreOpen(on)
      this._onMore.invoke(on)
    })
    // Progress: the counter on the left, the bar (ProgressRail, a child authored in the
    // scene) fills the rest of the line.
    const progY = -h / 2 + g.pad * 0.8 + progH / 2
    const counterW = charCm("body", d) * 7
    const progHolder = obj(plate.content, "Progress", new vec3(-rowW / 2 + counterW / 2, progY, 0))
    const progRow = flexRow(progHolder, counterW, progH, {justify: FlexJustify.Start, align: FlexAlign.Center})
    this.counter = addUIText(progRow, "ProgressText", "0 / 10", "body", counterW, progH, d)
    const rail = this.findChild("ProgressRail")
    if (rail) {
      const barW = rowW - counterW - g.gap
      rail.getTransform().setLocalPosition(new vec3(-rowW / 2 + counterW + g.gap + barW / 2, progY, 0.7))
      // A child script has no methods before its own onAwake: size the bar on start.
      this.createEvent("OnStartEvent").bind(() => {
        const bar = rail.getComponent(ProgressRail.getTypeName()) as ProgressRail
        if (bar && bar.setLength) bar.setLength(barW)
      })
    }
    this.popover = this.buildPopover(wideW, d)
    this.pill = this.buildPill(wideW, d)
    this.layoutTop()
    this.setProgress(0)
    // Measure once the buttons are up and FlexLayout has placed them (it lays out a few
    // frames after init). The popover and the pill stay up until then, so every UIKit
    // part initializes and lays out while enabled; then they hide (the dock sits low on
    // the left, out of view at the start card).
    let settled = 0
    const check = this.createEvent("UpdateEvent")
    check.bind(() => {
      const all = this.rowButtons.concat(this.popButtons)
      if (!all.every((b) => b.initialized)) return
      if (++settled < 30) return
      check.enabled = false
      this.logHitBoxes()
      this.hiddenOnce = true
      if (this.popover) this.popover.enabled = this.moreOpen
      if (this.pill) this.pill.enabled = this.watching
    })
  }

  /** Replay, the two learning tools and the Voice toggle, on their own plate on top of the dock. */
  private buildPopover(w: number, d: number): SceneObject {
    const g = grid(d)
    const bh = this.buttonSize * 0.9
    const h = 3 * bh + 2 * this.gap + 2 * g.pad * 0.8
    const root = obj(this.sceneObject, "MorePopover")
    const plate = makePlate(root, w, h, d)
    const rowW = w - 2 * g.pad
    const bw = (rowW - this.gap) / 2
    const rowStep = bh + this.gap
    // Pass B: Replay, the first row (it left the dock; a choice here closes the popover).
    const replayHolder = obj(plate.content, "ReplayRow", new vec3(0, rowStep, 0))
    const replayRow = flexRow(replayHolder, rowW, bh, {gap: this.gap, justify: FlexJustify.Start, align: FlexAlign.Center})
    const replayBtn = addLabelButton(replayRow, "BtnReplay", "Replay", ICON_REPLAY, bw, bh, d, () => this._onReplay.invoke())
    const rowHolder = obj(plate.content, "LearnRow", new vec3(0, 0, 0))
    const row = flexRow(rowHolder, rowW, bh, {gap: this.gap, justify: FlexJustify.Center, align: FlexAlign.Center})
    const info = addLabelButton(row, "BtnWhatsThis", "What's this?", ICON_INFO, bw, bh, d, () => {})
    const askBtn = addLabelButton(row, "BtnAsk", "Ask the coach", ICON_ASK, bw, bh, d, () => {})
    this.popButtons = [replayBtn, info, askBtn]
    info.onInitialized.add(() => info.setIsToggleable(true))
    info.onValueChange.add((v) => {
      this.whatsThisOn = v === 1
      this.syncToggleIcons()
      this._onWhatsThis.invoke(this.whatsThisOn)
    })
    this.whatsThis = info
    askBtn.onInitialized.add(() => askBtn.setIsToggleable(true))
    askBtn.onValueChange.add((v) => {
      this.askOn = v === 1
      this.syncToggleIcons()
      this._onAsk.invoke(this.askOn)
    })
    this.ask = askBtn
    // Pass V: the Voice toggle, under What's this? (on by default).
    const voiceHolder = obj(plate.content, "VoiceRow", new vec3(0, -rowStep, 0))
    const voiceRow = flexRow(voiceHolder, rowW, bh, {gap: this.gap, justify: FlexJustify.Start, align: FlexAlign.Center})
    const voiceBtn = addLabelButton(voiceRow, "BtnVoice", "Voice", ICON_VOICE_ON, bw, bh, d, () => {})
    this.popButtons.push(voiceBtn)
    this.voice = voiceBtn
    voiceBtn.onInitialized.add(() => {
      voiceBtn.setIsToggleable(true)
      voiceBtn.isOn = this.voiceOn
      this.syncToggleIcons()
    })
    voiceBtn.onValueChange.add((v) => {
      this.voiceOn = v === 1
      this.syncToggleIcons()
      this._onVoice.invoke(this.voiceOn)
    })
    this.popoverH = h
    return root
  }

  /** "Watching the coach" with Stop, a pill on top of the dock. */
  private buildPill(w: number, d: number): SceneObject {
    const g = grid(d)
    const bh = this.buttonSize * 0.8
    const h = bh + 2 * g.pad * 0.6
    const root = obj(this.sceneObject, "WatchPill")
    const plate = makePlate(root, w, h, d, COLOR.accent)
    plate.setRadius(h / 2)
    // A pill: the side padding is its corner radius, so nothing runs into the round ends.
    const rowW = w - h
    const stopW = charCm("button", d) * 5 + bh * 0.5 + 2.5 * g.pad
    const row = flexRow(plate.content, rowW, bh, {gap: g.gap, justify: FlexJustify.SpaceBetween, align: FlexAlign.Center})
    const leftW = rowW - stopW - g.gap
    flexChild(row, {w: leftW, h: bh, name: "WatchLabel"}, (holder) => {
      const r = flexRow(holder, leftW, bh, {gap: g.gap, justify: FlexJustify.Start, align: FlexAlign.Center})
      addRowImage(r, ICON_PLAY, lineCm("button", d))
      addUIText(r, "WatchText", "Watching the coach", "button", leftW - lineCm("button", d) - g.gap, bh, d)
    })
    addLabelButton(row, "BtnStopWatch", "Stop", ICON_STOP, stopW, bh, d, () => this._onStopWatch.invoke())
    this.pillH = h
    return root
  }

  /** Stacks the popover and the pill on top of the dock (pill above the popover). */
  private layoutTop(): void {
    const g = grid(this.viewDistanceCm)
    let y = this.height / 2 + g.gap
    for (const so of [this.popover, this.pill]) {
      if (!so) continue
      const h = so === this.popover ? this.popoverH : this.pillH
      const on = so === this.popover ? this.moreOpen : this.watching
      so.getTransform().setLocalPosition(new vec3(0, y + h / 2, 0))
      if (on) y += h + g.gap
    }
  }

  private findChild(name: string): SceneObject | null {
    const n = this.sceneObject.getChildrenCount()
    for (let i = 0; i < n; i++) {
      const c = this.sceneObject.getChild(i)
      if (c.name === name) return c
    }
    return null
  }

  /** Measures each button's live collider along the dock's x axis and logs it, per row. */
  private logHitBoxes(): void {
    const bar = this.sceneObject.getTransform()
    const right = bar.right
    const measure = (list: Button[], rowName: string) =>
      list.map((b) => {
        const origin = bar.getWorldPosition()
        const tr = b.collider.getSceneObject().getTransform()
        const half = ((b.collider.shape as BoxShape).size.x * tr.getWorldScale().x) / 2
        const c = tr.getWorldPosition().sub(origin).dot(right)
        const name = b.getSceneObject().name
        // Replay (pass B) and the Voice toggle (pass V) have their own rows in the popover.
        const own = name === "BtnVoice" ? "voice" : name === "BtnReplay" ? "replay" : rowName
        return {name, row: own, left: c - half, right: c + half, visualWidth: b.size.x}
      })
    this.hitBoxes = measure(this.rowButtons, "dock").concat(measure(this.popButtons, "more"))
    const parts: string[] = []
    let clear = true
    for (let i = 0; i < this.hitBoxes.length; i++) {
      const h = this.hitBoxes[i]
      const next = this.hitBoxes[i + 1] && this.hitBoxes[i + 1].row === h.row ? this.hitBoxes[i + 1] : null
      const gap = next ? next.left - h.right : NaN
      if (next && gap < 0) clear = false
      if (Math.abs(h.right - h.left - h.visualWidth) > 0.05) clear = false
      parts.push(
        `${h.name} ${h.left.toFixed(2)}..${h.right.toFixed(2)} (hit ${(h.right - h.left).toFixed(2)}, visual ${h.visualWidth.toFixed(2)})` +
          (next ? ` gap ${gap.toFixed(2)}` : "")
      )
    }
    this.hitBoxesClear = clear
    print(`[ControlBar] hit boxes along the dock (cm): ${parts.join("; ")}: ${clear ? "match the visuals, no overlap" : "MISMATCH OR OVERLAP"}`)
  }
}
