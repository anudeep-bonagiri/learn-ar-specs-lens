import {DefaultLeafInteractor} from "Leaf.lspkg/Interactors/interactor/DefaultLeafInteractor"
import {findInteractablesByName} from "Leaf.lspkg/Interactors/InteractableUtils"
import {awaitEventOnce, nextFrame, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {Interactable} from "SpectaclesInteractionKit.lspkg/Components/Interaction/Interactable/Interactable"
import {InteractorTriggerType} from "SpectaclesInteractionKit.lspkg/Core/Interactor/Interactor"
import {findSceneObjectByName} from "Leaf.lspkg/Utils/common/Utils"
import {RepairManager} from "../Scripts/RepairManager"

/**
 * BenchCoach LEAF helpers. `dragTo` steers a grabbed interactable toward a world
 * position frame by frame (LEAF's drag() applies its vector EVERY frame, so a
 * total-displacement drag is frame-rate dependent; this one checks the actual
 * position each frame and releases when it arrives or times out).
 */
/** Buttons inside the dock's More popover. */
const MORE_ITEMS = ["BtnWhatsThis", "BtnAsk", "BtnVoice"]

export class BenchCoachLeafInteractor extends DefaultLeafInteractor {
  async tap(name: string): Promise<void> {
    // Pass D2: What's this? and Ask the coach live in the dock's More popover; open it
    // first, as a user would.
    if (MORE_ITEMS.indexOf(name) >= 0 && !findInteractablesByName(name, undefined, true)[0]) {
      const more = findInteractablesByName("BtnMore", undefined, true)[0]
      if (more) {
        await this.trigger(more)
        await sleep(400)
      }
    }
    const target = findInteractablesByName(name, undefined, true)[0]
    if (!target) throw new Error(`Interactable "${name}" not found or not enabled`)
    await this.trigger(target)
    await sleep(250)
  }

  /**
   * Pinch and hold `name` for `ms` milliseconds, then let go (hover, select,
   * wait, release), like trigger() with a hold in the middle.
   */
  async holdOn(name: string, ms: number): Promise<void> {
    const target = findInteractablesByName(name, undefined, true)[0]
    if (!target) throw new Error(`Interactable "${name}" not found or not enabled`)
    const started = awaitEventOnce(target.onTriggerStart)
    await this.enterHover(target)
    await nextFrame()
    this["overrideTrigger"] = InteractorTriggerType.Select
    await started
    await sleep(ms)
    const ended = awaitEventOnce(target.onTriggerEnd)
    this["overrideTrigger"] = InteractorTriggerType.None
    await nextFrame()
    await ended
    await this.exitHover()
    await sleep(250)
  }

  async dragTo(
    target: Interactable,
    goal: vec3,
    maxStepCm: number = 1.0,
    timeoutMs: number = 8000,
    toleranceCm: number = 0.4,
    stopOnArrive: boolean = false,
    stopWhen?: () => boolean
  ): Promise<void> {
    const tr = target.getTransform()
    const unsubscribe = target.onDragUpdate.add(() => {
      const delta = goal.sub(tr.getWorldPosition())
      const len = delta.length
      const step = len > maxStepCm ? delta.uniformScale(maxStepCm / len) : delta
      this.startPoint = this.startPoint.add(step)
      this.endPoint = this.endPoint.add(step)
      this.overrideDragVector = step
    })
    const dragStarted = awaitEventOnce(target.onDragStart)
    const dragEnded = awaitEventOnce(target.onDragEnd)

    await this.enterHover(target)
    await nextFrame()
    await nextFrame()
    this["overrideTrigger"] = InteractorTriggerType.Select
    await nextFrame()
    this.overrideDragVector = new vec3(0.05, 0.05, 0)
    await dragStarted

    const startMs = getTime() * 1000
    while (getTime() * 1000 < startMs + timeoutMs) {
      await awaitEventOnce(target.onTriggerUpdate)
      if (tr.getWorldPosition().distance(goal) <= toleranceCm) break
      if (stopWhen && stopWhen()) break
    }
    unsubscribe()
    // LEAF keeps applying the last drag vector every frame until the release lands;
    // stopOnArrive zeroes it so the target is let go where it arrived (no drift).
    if (stopOnArrive) this.overrideDragVector = vec3.zero()
    this["overrideTrigger"] = InteractorTriggerType.None
    await dragEnded
    this.resetStartEndPoint()
    this.overrideDragVector = undefined
    await this.exitHover()
  }
}

export function getRepairManager(): RepairManager {
  const root = findSceneObjectByName("BenchCoach")
  if (!root) throw new Error("BenchCoach root not found")
  const manager = root.getComponent(RepairManager.getTypeName()) as RepairManager
  if (!manager) throw new Error("RepairManager not found on BenchCoach")
  return manager
}

export function countEnabledByName(name: string): number {
  let count = 0
  const stack: SceneObject[] = []
  const n = global.scene.getRootObjectsCount()
  for (let i = 0; i < n; i++) stack.push(global.scene.getRootObject(i))
  while (stack.length > 0) {
    const so = stack.pop()!
    if (so.name === name && so.isEnabledInHierarchy) count++
    const c = so.getChildrenCount()
    for (let i = 0; i < c; i++) stack.push(so.getChild(i))
  }
  return count
}
