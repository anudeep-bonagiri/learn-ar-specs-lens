import {scenariosIndex} from "Leaf.lspkg/Scenarios/decorator/ScenarioIndexDecorator"
import {ScenarioMetadata} from "Leaf.lspkg/Scenarios/scenario/ScenarioMetadata"
import {VerifyButtonScenario} from "./VerifyButtonScenario"
import {VerifyLeverDragScenario} from "./VerifyLeverDragScenario"

@component
export class LeafIndex extends BaseScriptComponent {
  @scenariosIndex
  static scenariosIndex: ScenarioMetadata[] = [
    {
      id: "verify-button",
      typename: VerifyButtonScenario.getTypeName(),
    },
    {
      id: "verify-lever-drag",
      typename: VerifyLeverDragScenario.getTypeName(),
    },
  ]
}
