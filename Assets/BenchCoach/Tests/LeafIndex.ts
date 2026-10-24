import {scenariosIndex} from "Leaf.lspkg/Scenarios/decorator/ScenarioIndexDecorator"
import {ScenarioMetadata} from "Leaf.lspkg/Scenarios/scenario/ScenarioMetadata"
import {StartScenario} from "./StartScenario"
import {DeflateLoosenScenario} from "./DeflateLoosenScenario"
import {LeverSnapScenario} from "./LeverSnapScenario"
import {PeelAndPullScenario} from "./PeelAndPullScenario"
import {InspectDoneScenario} from "./InspectDoneScenario"
import {JumpToStepScenario} from "./JumpToStepScenario"

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
      typename: InspectDoneScenario.getTypeName(),
    },
    {
      id: "jump-to-step",
      typename: JumpToStepScenario.getTypeName(),
      parameters: {step: "5"},
    },
  ]
}
