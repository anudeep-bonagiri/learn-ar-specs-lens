import {scenariosIndex} from "Leaf.lspkg/Scenarios/decorator/ScenarioIndexDecorator"
import {ScenarioMetadata} from "Leaf.lspkg/Scenarios/scenario/ScenarioMetadata"
import {StartScenario} from "./StartScenario"
import {DeflateLoosenScenario} from "./DeflateLoosenScenario"
import {LeverSnapScenario} from "./LeverSnapScenario"

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
  ]
}
