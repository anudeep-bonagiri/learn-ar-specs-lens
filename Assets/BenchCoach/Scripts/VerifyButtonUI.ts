import {Button} from "SpectaclesUIKit.lspkg/Scripts/Components/Button/Button"

/**
 * Section 9 verification 3: one UIKit Button that LEAF can trigger.
 * Creates a child SceneObject named BtnVerify with a Button on it and counts presses.
 */
@component
export class VerifyButtonUI extends BaseScriptComponent {
  @input
  @hint("Button size in cm (x, y, z)")
  buttonSize: vec3 = new vec3(8, 4, 1)

  pressCount: number = 0

  private button: Button | null = null

  onAwake(): void {
    this.sceneObject.createComponent("Component.Canvas")

    const btnObj = global.scene.createSceneObject("BtnVerify")
    btnObj.setParent(this.sceneObject)
    btnObj.getTransform().setLocalPosition(new vec3(0, 0, 0.6))

    const button = btnObj.createComponent(Button.getTypeName()) as Button
    button.onInitialized.add(() => {
      button.size = this.buttonSize
    })
    button.onTriggerUp.add(() => {
      this.pressCount += 1
      print(`[VerifyButtonUI] BtnVerify pressed, count=${this.pressCount}`)
    })
    this.button = button
  }
}
