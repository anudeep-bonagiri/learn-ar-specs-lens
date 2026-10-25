/**
 * AskCoach — "Ask the coach" (pass 12). While open, the chips panel beside the step
 * label shows the current step's preset questions (StepDefinitions.COACH_QUESTIONS);
 * a chip asks Gemini through the Remote Service Gateway for a one- or two-sentence
 * answer about this step, shown on the answer panel next to the part with a source
 * tag. Falls back to the step's canned answer on an error, a missing token, no
 * internet, a timeout (timeoutSec) or when forceCanned / !useLive.
 * Closes on a step change (answer hidden, chips refreshed if still open), on reset,
 * when watch mode plays, and when What's this? turns on (UIBindings keeps the two
 * exclusive). IdleHint is suspended while it is open (IdleHint.askSuspended).
 * Owns: open, busy, lastAnswer, lastSource, the request in flight, panel placement.
 * Emits onOpenChanged(on), onAnswer({step, index, text, source}).
 * Must not: change steps or author UI (the two panels are passive views).
 * Tokens: read from RemoteServiceGatewayCredentials at call time; never logged.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import WorldCameraFinderProvider from "SpectaclesInteractionKit.lspkg/Providers/CameraProvider/WorldCameraFinderProvider"
import {Gemini} from "RemoteServiceGateway.lspkg/HostedExternal/Gemini"
import {AvaliableApiTypes, RemoteServiceGatewayCredentials} from "RemoteServiceGateway.lspkg/RemoteServiceGatewayCredentials"
import {STEPS, coachQuestions} from "./StepDefinitions"
import {RepairManager} from "./RepairManager"
import {BenchCoachStepLabelUI} from "./BenchCoachStepLabelUI"
import {BenchCoachAskChipsUI} from "./BenchCoachAskChipsUI"
import {BenchCoachAskAnswerUI} from "./BenchCoachAskAnswerUI"
import {RepairDirector} from "./RepairDirector"
import {IdleHint} from "./IdleHint"
import {BenchCoachAudio} from "./BenchCoachAudio"

export interface CoachAnswer {
  step: number
  index: number
  text: string
  source: string
}

@component
export class AskCoach extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">AskCoach – Ask the coach (RSG + canned fallback)</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">References</span>')
  @ui.group_start("References")
  @input
  @hint("The step machine (current step, step changes, reset)")
  manager: RepairManager

  @input
  @hint("Step label: the panels sit around it")
  stepLabel: BenchCoachStepLabelUI

  @input
  @hint("Question chips panel")
  chips: BenchCoachAskChipsUI

  @input
  @hint("Answer panel")
  answerPanel: BenchCoachAskAnswerUI

  @input
  @allowUndefined
  @hint("Watch mode: Ask closes while it plays")
  director: RepairDirector

  @input
  @allowUndefined
  @hint("Idle hints: suspended while Ask is open")
  idle: IdleHint

  @input
  @allowUndefined
  @hint("Cue player (tick on a chip)")
  audio: BenchCoachAudio
  @ui.group_end

  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Ask the LLM; off = always the canned answers")
  useLive: boolean = true

  @input
  @hint("Tests: always use the canned answer, never the network")
  forceCanned: boolean = false

  @input
  @hint("Seconds to wait for a live answer before using the canned one")
  @widget(new SliderWidget(1, 15, 0.5))
  timeoutSec: number = 6

  @input
  @hint("Gemini model id through the Remote Service Gateway")
  model: string = "gemini-2.5-flash"

  @input
  @hint("System prompt; {step} becomes the step name and label")
  systemPrompt: string = "You are a calm bike mechanic. Answer in at most 2 short sentences, specific to this step: {step}."

  @input
  @hint("Gap between the step label and the Ask panels, in cm")
  @widget(new SliderWidget(0, 4, 0.1))
  panelGapCm: number = 0.5

  @input
  @hint("Highest a panel's top edge may sit above the eye, in degrees; above that the answer goes under the label and the chips top-align with it")
  @widget(new SliderWidget(5, 40, 1))
  maxElevationDeg: number = 18
  @ui.group_end

  /** Ask is open (chips shown). */
  open: boolean = false
  /** A live request is in flight. */
  busy: boolean = false
  /** Last answer shown ("" = none since the step changed). */
  lastAnswer: string = ""
  /** "live" or "canned" ("" = none yet). */
  lastSource: string = ""
  /** Why the last canned answer was used ("forced", "offline", "no token", "timeout", "error", "empty"). */
  lastFallbackReason: string = ""
  /** Milliseconds the last live answer took (0 = none). */
  lastLatencyMs: number = 0
  askCount: number = 0

  private _onOpenChanged = new Event<boolean>()
  onOpenChanged: PublicApi<boolean> = this._onOpenChanged.publicApi()
  private _onAnswer = new Event<CoachAnswer>()
  onAnswer: PublicApi<CoachAnswer> = this._onAnswer.publicApi()

  private request = 0
  private hiddenOnce = false
  private answerShown = false

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => {
      if (!this.manager || !this.stepLabel || !this.chips || !this.answerPanel) {
        print("[AskCoach] ERROR: missing @input refs")
        return
      }
      this.chips.onChip.add((i) => {
        if (this.audio) this.audio.playTickAt(this.chips.sceneObject.getTransform().getWorldPosition())
        if (this.idle) this.idle.touch()
        this.ask(this.manager.getState().step, i)
      })
      this.manager.onStepChanged.add(() => this.stepChanged())
      this.manager.onReset.add(() => this.setOpen(false))
    })
    this.createEvent("LateUpdateEvent").bind(() => this.tick())
  }

  /** Open or close Ask (the chips; closing also hides the answer). */
  setOpen(on: boolean): void {
    if (this.open === on) return
    this.open = on
    if (on) {
      this.chips.setQuestions(coachQuestions(this.manager.getState().step).map((c) => c.q))
    } else {
      this.cancel()
      this.hideAnswer()
    }
    this.chips.sceneObject.enabled = on
    if (this.idle) this.idle.askSuspended = on
    if (on) this.place()
    print(`[AskCoach] Ask ${on ? "on" : "off"}`)
    this._onOpenChanged.invoke(on)
  }

  /** Ask the step's question `index`: live through RSG, else (or on failure) the canned answer. */
  ask(step: number, index: number): void {
    const list = coachQuestions(step)
    if (index < 0 || index >= list.length) return
    const qa = list[index]
    this.askCount += 1
    this.cancel()
    const reason = this.cannedReason()
    if (reason) {
      this.finish(step, index, qa.a, "canned", reason)
      return
    }
    const id = ++this.request
    this.busy = true
    this.showAnswer(this.answerPanel.thinkingText, "")
    const t0 = getTime()
    const timer = this.createEvent("DelayedCallbackEvent")
    timer.bind(() => {
      if (id !== this.request) return
      this.finish(step, index, qa.a, "canned", "timeout")
    })
    timer.reset(this.timeoutSec)
    const def = STEPS[step]
    const sys = this.systemPrompt.replace("{step}", `${def.name}, "${def.label}"`)
    Gemini.models({
      model: this.model,
      type: "generateContent",
      body: {
        systemInstruction: {parts: [{text: sys}]},
        contents: [{role: "user", parts: [{text: qa.q}]}],
        generationConfig: {temperature: 0.4, maxOutputTokens: 90, thinkingConfig: {thinkingBudget: 0}},
      },
    })
      .then((r: any) => {
        if (id !== this.request) return
        const parts = r && r.candidates && r.candidates[0] && r.candidates[0].content ? r.candidates[0].content.parts : null
        const text = parts && parts[0] && parts[0].text ? ("" + parts[0].text).trim() : ""
        this.lastLatencyMs = Math.round((getTime() - t0) * 1000)
        if (!text) {
          this.finish(step, index, qa.a, "canned", "empty")
          return
        }
        this.finish(step, index, text.length > 240 ? text.substring(0, 237) + "..." : text, "live", "")
      })
      .catch((e: any) => {
        if (id !== this.request) return
        print(`[AskCoach] live error: ${("" + e).substring(0, 120)}`)
        this.finish(step, index, qa.a, "canned", "error")
      })
  }

  private cannedReason(): string {
    if (this.forceCanned) return "forced"
    if (!this.useLive) return "live off"
    if (!global.deviceInfoSystem.isInternetAvailable()) return "offline"
    const token = RemoteServiceGatewayCredentials.getApiToken(AvaliableApiTypes.Google)
    if (!token || token.indexOf("INSERT") >= 0) return "no token"
    return ""
  }

  private finish(step: number, index: number, text: string, source: string, reason: string): void {
    this.request += 1
    this.busy = false
    if (step !== this.manager.getState().step || !this.open) return
    this.lastAnswer = text
    this.lastSource = source
    this.lastFallbackReason = reason
    this.showAnswer(text, source === "live" ? "coach" : "offline")
    const lat = source === "live" ? ` ${this.lastLatencyMs} ms` : ` (${reason})`
    print(`[AskCoach] step ${step} q${index} ${source}${lat}: ${text.substring(0, 80)}`)
    this._onAnswer.invoke({step, index, text, source})
  }

  private cancel(): void {
    this.request += 1
    this.busy = false
  }

  private showAnswer(text: string, tag: string): void {
    this.answerPanel.showAnswer(text, tag)
    this.answerShown = true
    this.answerPanel.sceneObject.enabled = true
    this.place()
  }

  private hideAnswer(): void {
    this.answerShown = false
    this.lastAnswer = ""
    this.answerPanel.sceneObject.enabled = false
  }

  private stepChanged(): void {
    this.cancel()
    this.hideAnswer()
    this.lastSource = ""
    if (this.open) this.chips.setQuestions(coachQuestions(this.manager.getState().step).map((c) => c.q))
  }

  private tick(): void {
    if (!this.chips || !this.answerPanel || !this.manager) return
    if (!this.hiddenOnce) {
      // First frame: every UIKit part has initialized while enabled; now start hidden.
      this.hiddenOnce = true
      this.chips.sceneObject.enabled = this.open
      this.answerPanel.sceneObject.enabled = this.answerShown
    }
    if (!this.open) return
    if (this.director && this.director.playing) {
      this.setOpen(false)
      return
    }
    this.place()
  }

  /**
   * Answer above the step label (next to the part); chips on the user's left of the
   * label (the label is billboarded, so its right vector is the user's right; the tool
   * tray is on the right), bottom edges level so the chips stay above the tire. When a
   * label sits high (the inspect step's label is above the wheel and closer), panels
   * would rise past maxElevationDeg out of view: then the answer goes under the label
   * and the chips top-align with it.
   */
  private place(): void {
    if (!this.stepLabel) return
    const lt = this.stepLabel.sceneObject.getTransform()
    const l = lt.getWorldPosition()
    const labelH = this.stepLabel.panelHeight
    const answerH = this.answerPanel.panelHeight
    const chipsH = this.chips.height
    const up = labelH / 2 + this.panelGapCm + answerH / 2
    const high = this.tooHigh(l.add(new vec3(0, up + answerH / 2, 0)))
    if (this.answerShown) {
      this.answerPanel.sceneObject.getTransform().setWorldPosition(l.add(new vec3(0, high ? -up : up, 0.5)))
    }
    const side = this.stepLabel.panelWidth / 2 + this.panelGapCm + this.chips.panelWidth / 2
    const dy = high ? (labelH - chipsH) / 2 : (chipsH - labelH) / 2
    this.chips.sceneObject.getTransform().setWorldPosition(l.add(lt.right.uniformScale(-side)).add(new vec3(0, dy, 0.5)))
  }

  /** The point is more than maxElevationDeg above the eye (horizontal distance from the camera). */
  private tooHigh(p: vec3): boolean {
    const cam = WorldCameraFinderProvider.getInstance()
    const c = cam ? cam.getWorldPosition() : vec3.zero()
    const flat = Math.sqrt((p.x - c.x) * (p.x - c.x) + (p.z - c.z) * (p.z - c.z))
    return (Math.atan2(p.y - c.y, Math.max(1, flat)) * 180) / Math.PI > this.maxElevationDeg
  }
}
