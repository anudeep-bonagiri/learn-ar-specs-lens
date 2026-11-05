/**
 * BenchCoachFinishCardUI — the final card (step 11, pass D2: the shared card component):
 * a green "Repair complete" kicker, "Flat fixed", a tidy two-column list (time, cause,
 * lever misses, mistakes, hints, slowest steps), the prevention tip and the practice
 * line, and BtnRestart. Pass 11's coach report is the list's last row and the practice
 * line (FinishTimes, FinishPractice).
 * Owns: only its view. setResult() pushes time, stats, cause and tip in; setReport() the
 * slowest steps and the practice line. Emits onRestart.
 * Must not: hold repair state or count anything (RunStats counts, RepairManager pushes).
 */
import Event, {PublicApi} from "SpectaclesInteractionKit.lspkg/Utils/Event"
import {Billboard} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Billboard/Billboard"
import {COLOR, buildCard} from "./UIHelpers"

const ICON_REPLAY: Texture = requireAsset("../../Icons/replay.png") as Texture

export interface FinishStats {
  leverMisses: number
  mistakes: number
  hintsUsed: number
}

@component
export class BenchCoachFinishCardUI extends BaseScriptComponent {
  @ui.label('<span style="color: #60A5FA;">BenchCoachFinishCardUI – step 11 finish card</span>')
  @ui.separator
  @ui.label('<span style="color: #60A5FA;">Settings</span>')
  @ui.group_start("Settings")
  @input
  @hint("Card width in cm (the height follows the content)")
  @widget(new SliderWidget(16, 40, 0.5))
  panelWidth: number = 29

  @input
  @hint("Viewing distance in cm; scales the type and the spacing grid")
  @widget(new SliderWidget(40, 160, 1))
  viewDistanceCm: number = 82

  @input
  @hint("Headline")
  titleText: string = "Flat fixed"

  @input
  @hint("Label on the restart button")
  restartLabel: string = "Start over"
  @ui.group_end

  private texts: {[name: string]: Text} = {}
  private _onRestart = new Event<void>()
  onRestart: PublicApi<void> = this._onRestart.publicApi()

  /** Time from Found it, the run's counts, the cause and its prevention tip. */
  setResult(seconds: number, stats: FinishStats, causeLabel: string, tip: string): void {
    const s = Math.max(0, Math.floor(seconds))
    const m = Math.floor(s / 60)
    const r = s % 60
    this.set("FinishTime", `${m}:${r < 10 ? "0" : ""}${r}`)
    this.set("FinishCause", causeLabel.length > 0 ? causeLabel.charAt(0).toUpperCase() + causeLabel.substring(1) : causeLabel)
    this.set("FinishLeverMisses", `${stats.leverMisses}`)
    this.set("FinishMistakes", `${stats.mistakes}`)
    this.set("FinishHints", `${stats.hintsUsed}`)
    this.set("FinishTip", `Next time: ${tip}`)
  }

  /** Pass 11: the slowest steps ("Pull 0:12 · Peel 0:09") and the practice line. */
  setReport(slowest: string, practiceLine: string): void {
    this.set("FinishTimes", slowest)
    this.set("FinishPractice", practiceLine)
  }

  /** Text on a named line ("" if there is none), for tests. */
  textOf(name: string): string {
    return this.texts[name] ? this.texts[name].text : ""
  }

  private set(name: string, text: string): void {
    if (this.texts[name]) this.texts[name].text = text
  }

  onAwake(): void {
    this.sceneObject.createComponent(Billboard.getTypeName())
    const card = buildCard(this.sceneObject, {
      width: this.panelWidth,
      distanceCm: this.viewDistanceCm,
      title: {name: "FinishTitle", text: this.titleText, kicker: {name: "FinishKicker", text: "Repair complete", color: COLOR.green}},
      rows: [],
      pairs: [
        {name: "FinishTime", label: "Time", value: "0:00"},
        {name: "FinishCause", label: "Cause", value: "Thorn"},
        {name: "FinishLeverMisses", label: "Lever misses", value: "0"},
        {name: "FinishMistakes", label: "Mistakes", value: "0"},
        {name: "FinishHints", label: "Hints", value: "0"},
        {name: "FinishTimes", label: "Slowest", value: "Pull 0:00 · Peel 0:00 · Lever A 0:00"},
      ],
      rowsAfter: [
        {name: "FinishTip", text: "Next time: run a hand round inside the tire before fitting a tube.", role: "body", lines: 2},
        {name: "FinishPractice", text: "Practice next: nothing stands out.", role: "secondary", lines: 2},
      ],
      buttons: [{name: "BtnRestart", label: this.restartLabel, icon: ICON_REPLAY, kind: "primary", width: 12, onClick: () => this._onRestart.invoke()}],
    })
    this.texts = card.texts
  }
}
