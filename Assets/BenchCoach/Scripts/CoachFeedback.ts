/**
 * CoachFeedback — mistake feedback with a reason. mistake(code, worldPos) plays
 * the nope cue from where it happened, puts the reason (StepDefinitions.MISTAKES)
 * on the step callout in its amber mistake state for showSec, then gives the label back to the step through
 * the restore callback RepairManager installs (refreshLabel).
 * Callers: RepairManager (bead before deflate, valve already deflated, lever B
 * before A, lever too far, tube before the peel, inflate before seating) and
 * RefitSteps (new tube missed the valve hole).
 * Owns: mistakeCount, lastCode, the label timer. Emits onMistake({code, reason}).
 * Must not: change steps or count stats itself (UIBindings wires onMistake to RunStats).
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {MISTAKES} from "./StepDefinitions"
import {BenchCoachStepLabelUI} from "./BenchCoachStepLabelUI"
import {BenchCoachAudio} from "./BenchCoachAudio"

export interface MistakeInfo {
  code: string
  reason: string
}

@component
export class CoachFeedback extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">CoachFeedback – mistakes with a reason</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("Step label panel (shows the reason)")
  stepLabel: BenchCoachStepLabelUI

  @input
  @hint("Cue player (nope)")
  audio: BenchCoachAudio
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Seconds the reason stays on the label")
  @widget(new SliderWidget(0.5, 8, 0.1))
  showSec: number = 2.5
  @ui.group_end

  mistakeCount: number = 0
  lastCode: string = ""
  lastReason: string = ""
  /** True while a reason is on the label. */
  showing: boolean = false
  /** Installed by RepairManager: puts the current step's label back. */
  restoreLabel: (() => void) | null = null

  private generation = 0

  private _onMistake = new Event<MistakeInfo>()
  onMistake: PublicApi<MistakeInfo> = this._onMistake.publicApi()

  mistake(code: string, worldPos: vec3): void {
    const reason = MISTAKES[code] ? MISTAKES[code] : code
    this.mistakeCount += 1
    this.lastCode = code
    this.lastReason = reason
    if (this.audio) this.audio.playNopeAt(worldPos)
    if (this.stepLabel && this.stepLabel.sceneObject.isEnabledInHierarchy) {
      this.stepLabel.showMistake(reason)
      this.showing = true
      const generation = ++this.generation
      const delay = this.createEvent("DelayedCallbackEvent")
      delay.bind(() => {
        if (generation !== this.generation || !this.showing) return
        this.showing = false
        if (this.restoreLabel) this.restoreLabel()
      })
      delay.reset(this.showSec)
    }
    print(`[CoachFeedback] ${code}: "${reason}"`)
    this._onMistake.invoke({code, reason})
  }

  /** The step changed (its label was rewritten): drop a pending restore. */
  cancel(): void {
    this.generation += 1
    this.showing = false
  }
}
