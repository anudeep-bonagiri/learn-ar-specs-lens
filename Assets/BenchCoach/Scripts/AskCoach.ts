/**
 * AskCoach — "Ask the coach" (pass 12). While open, the chips panel beside the step
 * label shows the current step's preset questions (StepDefinitions.COACH_QUESTIONS);
 * a chip asks Gemini through the Remote Service Gateway for a one- or two-sentence
 * answer about this step, shown on the answer panel next to the part with a source
 * tag. Falls back to the step's canned answer on an error, a missing token, no
 * internet, a timeout (timeoutSec) or when forceCanned / !useLive.
 * Show it only when needed (pass G2, carried onto D2 in pass M): Ask closes on a step
 * change, on reset, and after chipsIdleSec with the chips up and no chip press; a shown
 * answer hides after answerSec or at the next sub-step, and the chips come back in its
 * slot (their idle clock restarts then). It also closes
 * when watch mode plays, and when What's this? turns on (UIBindings keeps the two
 * exclusive). IdleHint is suspended while it is open (IdleHint.askSuspended).
 * Pass D2: the chips and the answer take turns in one slot hung under the step
 * callout (BenchCoachStepLabelUI.setStack), so they never lie over the wheel; the
 * answer's close button brings the chips back, the chips' close button closes Ask.
 * Owns: open, busy, lastAnswer, lastSource, the request in flight, panel placement.
 * Emits onOpenChanged(on), onAnswer({step, index, text, source}).
 * Must not: change steps or author UI (the two panels are passive views).
 * Tokens: read from RemoteServiceGatewayCredentials at call time; never logged.
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
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
  @hint("Gap between the step callout and the Ask panel hung under it, in cm")
  @widget(new SliderWidget(0, 4, 0.1))
  panelGapCm: number = 0.5

  @input
  @hint("Seconds a shown answer stays up before it hides on its own (0 = until the step changes); Nov 1 audit: show it only when needed")
  @widget(new SliderWidget(0, 30, 0.5))
  answerSec: number = 8

  @input
  @hint("Seconds the chips stay open after the last chip press or answer before Ask closes on its own (0 = never)")
  @widget(new SliderWidget(0, 60, 0.5))
  chipsIdleSec: number = 10
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
  private ownsSlot = false
  /** getTime() at which the shown answer hides itself (Infinity = no timer). */
  private answerHideAt = Number.POSITIVE_INFINITY
  /** getTime() at which Ask closes itself for lack of chip presses (Infinity = no timer). */
  private chipsCloseAt = Number.POSITIVE_INFINITY
  /** The sub-step the shown answer belongs to (a new sub-step hides it). */
  private answerSub = -1

  onAwake(): void {
    this.createEvent("OnStartEvent").bind(() => {
      if (!this.manager || !this.stepLabel || !this.chips || !this.answerPanel) {
        print("[AskCoach] ERROR: missing @input refs")
        return
      }
      this.chips.onChip.add((i) => {
        if (this.audio) this.audio.playTickAt(this.chips.sceneObject.getTransform().getWorldPosition())
        if (this.idle) this.idle.touch()
        this.touchChips()
        this.ask(this.manager.getState().step, i)
      })
      this.chips.onClose.add(() => {
        print("[AskCoach] chips closed")
        this.setOpen(false)
      })
      this.answerPanel.onClose.add(() => {
        print("[AskCoach] answer closed")
        this.cancel()
        this.hideAnswer()
        this.place()
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
      this.touchChips()
    } else {
      this.cancel()
      this.hideAnswer()
      this.chipsCloseAt = Number.POSITIVE_INFINITY
    }
    this.chips.sceneObject.enabled = on && !this.answerShown
    if (this.idle) this.idle.askSuspended = on
    this.place()
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
    this.showAnswer(text, source === "live" ? "Coach" : "Offline answer")
    if (this.answerSec > 0) this.answerHideAt = getTime() + this.answerSec
    this.touchChips()
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
    this.answerHideAt = Number.POSITIVE_INFINITY
    this.answerSub = this.manager.getState().subStep
    this.answerPanel.sceneObject.enabled = true
    this.chips.sceneObject.enabled = false
    this.place()
  }

  private hideAnswer(): void {
    this.answerShown = false
    this.answerHideAt = Number.POSITIVE_INFINITY
    this.lastAnswer = ""
    this.answerPanel.sceneObject.enabled = false
    if (this.open) {
      // The chips are back in the slot: their idle clock starts again.
      this.chips.sceneObject.enabled = true
      this.touchChips()
    }
  }

  /** A new step: Ask closes (pass G2 / M); the next step brings its own questions when reopened. */
  private stepChanged(): void {
    this.cancel()
    this.lastSource = ""
    if (this.open) {
      print("[AskCoach] Ask closed on a step change")
      this.setOpen(false)
    } else {
      this.hideAnswer()
    }
  }

  /** Restart the chips' idle timer: a chip press, an open, or the chips coming back counts as use. */
  private touchChips(): void {
    this.chipsCloseAt = this.chipsIdleSec > 0 ? getTime() + this.chipsIdleSec : Number.POSITIVE_INFINITY
  }

  private tick(): void {
    if (!this.chips || !this.answerPanel || !this.manager) return
    if (!this.hiddenOnce) {
      // First frame: every UIKit part has initialized while enabled; now start hidden.
      this.hiddenOnce = true
      this.chips.sceneObject.enabled = this.open && !this.answerShown
      this.answerPanel.sceneObject.enabled = this.answerShown
    }
    if (!this.open) return
    if (this.director && this.director.playing) {
      this.setOpen(false)
      return
    }
    const now = getTime()
    if (this.answerShown && this.manager.getState().subStep !== this.answerSub) {
      this.cancel()
      this.hideAnswer()
      print("[AskCoach] answer hidden at the next sub-step")
    } else if (this.answerShown && !this.busy && now >= this.answerHideAt) {
      this.hideAnswer()
      print("[AskCoach] answer hidden after " + this.answerSec + " s")
    }
    // The chips' idle clock only runs while they are up (not while an answer is read).
    if (!this.answerShown && now >= this.chipsCloseAt) {
      print("[AskCoach] Ask closed after " + this.chipsIdleSec + " s idle")
      this.setOpen(false)
      return
    }
    this.place()
  }

  /**
   * The chips, or the answer in their place, hang under the step callout (its slot);
   * the callout keeps the slot clear of the wheel (top or bottom zone).
   */
  private place(): void {
    if (!this.stepLabel) return
    if (!this.open) {
      // Give the slot back once (What's this? may own it next).
      if (this.ownsSlot) this.stepLabel.setStack(0)
      this.ownsSlot = false
      return
    }
    this.ownsSlot = true
    const h = this.answerShown ? this.answerPanel.panelHeight : this.chips.height
    this.stepLabel.setStack(h + this.panelGapCm)
    // Same scale as the callout, so the two read as one.
    const k = this.stepLabel.scale
    const at = this.stepLabel.stackTop(this.panelGapCm).add(new vec3(0, (-h / 2) * k, 0))
    const panel = this.answerShown ? this.answerPanel.sceneObject : this.chips.sceneObject
    panel.getTransform().setWorldPosition(at)
    panel.getTransform().setLocalScale(new vec3(k, k, k))
  }
}
