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
      id: "jump-to-step",
      typename: JumpToStepScenario.getTypeName(),
      parameters: {step: "5", pullCm: "0", fit: "0", inflate: "0"},
    },
  ]
}
