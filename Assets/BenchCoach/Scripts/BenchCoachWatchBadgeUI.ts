/**
 * BenchCoachWatchBadgeUI — "Watching" in frame while watch mode plays. The dock's
 * watch pill sits low on the left, out of frame from the recording pose; this small pill
 * floats just above the tire and left of the valve (badgeAboveHubCm over the hub,
 * badgeSideCm to the side: the clear dark strip under the top edge of the frame at the
 * recording pose, away from the lever handles that stand up on steps 3 and 4), with its
 * own Stop. Same plate as the dock's pill: a cyan-edged pill, a play icon, "Watching" in
 * the button role, and BtnBadgeStop, an icon button (ray-only, 2.2 degrees at its distance).
 * The badge is brief. It shows for startSec when Watch starts and for stepSec on
 * each step change while watching (showForStep), then hides; BtnBadgeStop works whenever it
 * shows. `watching` is still the whole Watch run, `showing` is the badge on screen now.
 * Owns: only its view. Emits onStop; setWatching(on) starts and ends it. Follows the
 * wheel every frame (so a re-anchor carries it) and turns to face the user.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {Button} from "SpectaclesUIKit.lspkg/Scripts/Components/Button/Button"
import {FlexAlign, FlexJustify} from "SpectaclesUIKit.lspkg/Scripts/Components/Layout2D/Flex/FlexTypes"
import {COLOR, addIconButton, addRowImage, addUIText, charCm, flexChild, flexRow, grid, lineCm, makePlate, targetCm} from "./UIHelpers"

const ICON_PLAY: Texture = requireAsset("../../Icons/play_arrow.png") as Texture
const ICON_STOP: Texture = requireAsset("../../Icons/stop.png") as Texture

@component
export class BenchCoachWatchBadgeUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachWatchBadgeUI – "Watching" above the wheel in watch mode</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Wheel root: the badge floats above its hub")
  wheel: SceneObject
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 90

  @input
  @hint("Height of the badge's center above the hub, in cm (the tire's top is about 34.6 cm above it)")
  @widget(new SliderWidget(30, 60, 0.5))
  badgeAboveHubCm: number = 41

  @input
  @hint("Sideways offset of the badge's center from the hub, in cm (negative = left, clear of the lever handles)")
  @widget(new SliderWidget(-25, 25, 0.5))
  badgeSideCm: number = -10

  @input
  @hint("How far the badge stands in front of the wheel plane, toward the user, in cm")
  @widget(new SliderWidget(0, 20, 0.5))
  standOffCm: number = 4

  @input
  @hint("Label")
  label: string = "Watching"

  @input
  @hint("Seconds the badge shows when Watch starts")
  @widget(new SliderWidget(0.5, 10, 0.5))
  startSec: number = 3

  @input
  @hint("Seconds the badge shows on each step change while watching")
  @widget(new SliderWidget(0.5, 10, 0.5))
  stepSec: number = 2
  @ui.group_end

  /** Watch mode is playing (the whole run). */
  watching: boolean = false
  /** The badge is on screen now (brief: at the start and on each step change). */
  showing: boolean = false
  /** Plate size in cm (tests read it). */
  width: number = 0
  height: number = 0

  private _onStop = new Event<void>()
  /** BtnBadgeStop. */
  onStop: PublicApi<void> = this._onStop.publicApi()

  private root: SceneObject | null = null
  private stopBtn: Button | null = null
  private hiddenOnce = false

  /** getTime() at which the badge hides. */
  private hideAt = 0

  setWatching(on: boolean): void {
    this.watching = on
    if (on) this.showFor(this.startSec)
    else this.setShowing(false)
  }

  /** Watch moved on to a new step. */
  showForStep(): void {
    if (this.watching) this.showFor(this.stepSec)
  }

  private showFor(sec: number): void {
    this.hideAt = getTime() + sec
    this.setShowing(true)
    this.follow()
  }

  private setShowing(on: boolean): void {
    this.showing = on
    if (this.root && this.hiddenOnce) this.root.enabled = on
  }

  onAwake(): void {
    const d = this.viewDistanceCm
    const g = grid(d)
    // Stop is at least a 2-degree target (Snap's rule).
    const bh = Math.max(targetCm(d, 2.2), lineCm("button", d) * 1.9)
    const h = bh + 2 * g.pad * 0.6
    const iconW = lineCm("button", d) * 0.9
    const labelW = charCm("button", d) * (this.label.length + 1)
    const stopW = bh
    const leftW = iconW + g.gap + labelW
    const w = h + leftW + g.gap * 2 + stopW
    this.width = w
    this.height = h
    this.root = global.scene.createSceneObject("WatchBadgeRoot")
    this.root.setParent(this.sceneObject)
    this.root.createComponent(Billboard.getTypeName())
    const plate = makePlate(this.root, w, h, d, COLOR.accent)
    plate.setRadius(h / 2)
    const rowW = w - h
    const row = flexRow(plate.content, rowW, bh, {gap: g.gap * 2, justify: FlexJustify.SpaceBetween, align: FlexAlign.Center})
    flexChild(row, {w: leftW, h: bh, name: "BadgeLabel"}, (holder) => {
      const r = flexRow(holder, leftW, bh, {gap: g.gap, justify: FlexJustify.Start, align: FlexAlign.Center})
      addRowImage(r, ICON_PLAY, iconW)
      addUIText(r, "WatchBadgeText", this.label, "button", labelW, lineCm("button", d), d)
    })
    this.stopBtn = addIconButton(row, "BtnBadgeStop", ICON_STOP, stopW, () => this._onStop.invoke(), d)
    // UIKit parts initialize while enabled; hide once they are up.
    let frames = 0
    const init = this.createEvent("UpdateEvent")
    init.bind(() => {
      if (this.stopBtn && !this.stopBtn.initialized) return
      if (++frames < 5) return
      init.enabled = false
      this.hiddenOnce = true
      if (this.root) this.root.enabled = this.showing
    })
    this.createEvent("LateUpdateEvent").bind(() => {
      if (!this.showing) return
      if (getTime() >= this.hideAt) this.setShowing(false)
      else this.follow()
    })
  }

  /** Above the hub, in front of the wheel plane (+Z is toward the user; the workspace only translates). */
  private follow(): void {
    if (!this.wheel || !this.root) return
    const p = this.wheel.getTransform().getWorldPosition().add(new vec3(this.badgeSideCm, this.badgeAboveHubCm, this.standOffCm))
    this.root.getTransform().setWorldPosition(p)
  }
}
