import {scenariosIndex} from "Leaf.lspkg/Scenarios/decorator/ScenarioIndexDecorator"
import {ScenarioMetadata} from "Leaf.lspkg/Scenarios/scenario/ScenarioMetadata"
import {StartScenario} from "./StartScenario"
import {DeflateLoosenScenario} from "./DeflateLoosenScenario"
import {LeverSnapScenario} from "./LeverSnapScenario"
import {PeelAndPullScenario} from "./PeelAndPullScenario"
import {InspectFinishScenario} from "./InspectFinishScenario"
import {JumpToStepScenario} from "./JumpToStepScenario"
import {TickMarksScenario} from "./TickMarksScenario"
import {SceneDressingScenario} from "./SceneDressingScenario"
import {RefitTubeScenario} from "./RefitTubeScenario"
import {SeatInflateScenario} from "./SeatInflateScenario"
import {ProgressIdleScenario} from "./ProgressIdleScenario"
import {WhatsThisScenario} from "./WhatsThisScenario"
import {MistakesScenario} from "./MistakesScenario"
import {FlatCausesScenario} from "./FlatCausesScenario"
import {WatchModeScenario} from "./WatchModeScenario"
import {AskCoachFallbackScenario} from "./AskCoachFallbackScenario"
import {FloorPathScenario} from "./FloorPathScenario"
import {CoachReportScenario} from "./CoachReportScenario"
import {ControlBarScenario} from "./ControlBarScenario"
import {FloorLevelScenario} from "./FloorLevelScenario"
import {UiLayoutScenario} from "./UiLayoutScenario"
import {VoiceCoachScenario} from "./VoiceCoachScenario"
import {PractiseStepScenario} from "./PractiseStepScenario"
import {AdaptiveCoachScenario} from "./AdaptiveCoachScenario"

@component
export class LeafIndex extends BaseScriptComponent {
  @scenariosIndex
  static scenariosIndex: ScenarioMetadata[] = [
    {
      id: "start",
      typename: StartScenario.getTypeName(),
    },
    {
      id: "deflate-loosen",
      typename: DeflateLoosenScenario.getTypeName(),
    },
    {
      id: "lever-snap",
      typename: LeverSnapScenario.getTypeName(),
    },
    {
      id: "peel-and-pull",
      typename: PeelAndPullScenario.getTypeName(),
    },
    {
      id: "inspect-done",
      typename: InspectFinishScenario.getTypeName(),
    },
    {
      id: "step-ticks",
      typename: TickMarksScenario.getTypeName(),
    },
    {
      id: "scene-dressing",
      typename: SceneDressingScenario.getTypeName(),
    },
    {
      id: "refit-tube",
      typename: RefitTubeScenario.getTypeName(),
    },
    {
      id: "seat-inflate",
      typename: SeatInflateScenario.getTypeName(),
    },
    {
      id: "whats-this",
      typename: WhatsThisScenario.getTypeName(),
    },
    {
      id: "mistakes",
      typename: MistakesScenario.getTypeName(),
    },
    {
      id: "flat-causes",
      typename: FlatCausesScenario.getTypeName(),
    },
    {
      id: "progress-idle",
      typename: ProgressIdleScenario.getTypeName(),
    },
    {
      id: "watch-mode",
      typename: WatchModeScenario.getTypeName(),
    },
    {
      id: "ask-coach-fallback",
      typename: AskCoachFallbackScenario.getTypeName(),
    },
    {
      id: "floor-path",
      typename: FloorPathScenario.getTypeName(),
    },
    {
      id: "coach-report",
      typename: CoachReportScenario.getTypeName(),
      parameters: {stay: "0"},
    },
    {
      id: "control-bar",
      typename: ControlBarScenario.getTypeName(),
    },
    {
      id: "floor-level",
      typename: FloorLevelScenario.getTypeName(),
    },
    {
      id: "ui-layout",
      typename: UiLayoutScenario.getTypeName(),
    },
    {
      id: "voice-coach",
      typename: VoiceCoachScenario.getTypeName(),
    },
    {
      id: "practise-step",
      typename: PractiseStepScenario.getTypeName(),
      parameters: {stay: "0"},
    },
    {
      id: "adaptive-coach",
      typename: AdaptiveCoachScenario.getTypeName(),
      parameters: {stay: "0"},
    },
    {
      id: "jump-to-step",
      typename: JumpToStepScenario.getTypeName(),
      parameters: {step: "5", pullCm: "0", fit: "0", inflate: "0", cause: "", find: "0", part: "", mistake: "", idle: "0", watch: "0", until: "", ask: "", canned: "0"},
    },
  ]
}
