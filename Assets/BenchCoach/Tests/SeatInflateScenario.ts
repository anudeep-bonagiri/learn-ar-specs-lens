import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {Highlighter} from "../Scripts/Highlighter"
import {BenchCoachAudio} from "../Scripts/BenchCoachAudio"

/**
 * Pass 9, steps 9 to 11: on step 9 Bead_0..3 glow; pinching each seats it
 * (offset back to 0) and the four enter step 10. Pinching and holding the valve
 * for 3 s plays the pump loop and inflates Tire to scale 1.00, which enters step
 * 11: the Finish card with the time and a stats line, and the Finish cue (the
 * halfway Done cue does not play again). Restart returns to step 0.
 */
@component
export class SeatInflateScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const highlighter = findSceneObjectByName("BenchCoach").getComponent(Highlighter.getTypeName()) as Highlighter
    const audio = findSceneObjectByName("Audio").getComponent(BenchCoachAudio.getTypeName()) as BenchCoachAudio
    const tire = findSceneObjectByName("Tire")
    const finishCard = findSceneObjectByName("FinishCard")
    expect(finishCard, "FinishCard exists").toBeTruthy()
    const sorted = (a: string[]): string => JSON.stringify(a.slice().sort())

    // ── Step 9: seat Bead_0..3 ──────────────────────────────────────────────
    manager.jumpToStep(9)
    await sleep(500)
    expect(manager.getState().step, "on step 9").toBe(9)
    print(`[SeatInflateScenario] step 9 highlight: ${JSON.stringify(highlighter.current)}`)
    expect(sorted(highlighter.current), "Bead_0..3 highlighted").toBe(sorted(["Bead_0", "Bead_1", "Bead_2", "Bead_3"]))
    for (const i of [1, 3, 0, 2]) {
      const bead = findSceneObjectByName(`Bead_${i}`)
      expect(bead.getTransform().getLocalPosition().length, `Bead_${i} lifted before seating`).toBeGreaterThan(0.3)
      await interactor.tap(`Bead_${i}`)
      await sleep(150)
      const off = bead.getTransform().getLocalPosition().length
      print(`[SeatInflateScenario] Bead_${i} seated: offset ${off.toFixed(3)} cm, step ${manager.getState().step}`)
      expect(off, `Bead_${i} back on the rim`).toBeLessThan(0.01)
      if (manager.getState().step === 9) {
        expect(highlighter.current.indexOf(`Bead_${i}`) < 0, `Bead_${i} no longer glows`).toBe(true)
      }
    }
    expect(manager.getState().step, "four beads seated: step 10").toBe(10)
    expect(sorted(highlighter.current), "valve glows on step 10").toBe(sorted(["Valve"]))

    // ── Step 10: pinch and hold the valve ───────────────────────────────────
    const scaleBefore = tire.getTransform().getLocalScale().x
    const pumpBefore = audio.pumpPlays
    const finishBefore = audio.finishPlays
    const doneBefore = audio.donePlays
    expect(scaleBefore, "tire still flat").toBeCloseTo(0.96, 2)
    await interactor.holdOn("Valve", 3000)
    await sleep(300)
    const scaleAfter = tire.getTransform().getLocalScale().x
    print(`[SeatInflateScenario] tire scale ${scaleBefore.toFixed(3)} -> ${scaleAfter.toFixed(3)}, pump plays +${audio.pumpPlays - pumpBefore}`)
    expect(scaleAfter, "tire inflated to 1.00").toBeCloseTo(1.0, 2)
    expect(audio.pumpPlays, "pump loop played").toBeGreaterThan(pumpBefore)
    expect(audio.pumping, "pump stopped after the release").toBe(false)
    expect(manager.getState().step, "inflated: step 11").toBe(11)

    // ── Step 11: Finish card ───────────────────────────────────────────────
    expect(finishCard.enabled, "FinishCard enabled").toBe(true)
    expect(findSceneObjectByName("DoneCard").enabled, "halfway card hidden").toBe(false)
    // Pass D2: the stats are rows of a two-column list.
    const stats = findSceneObjectByName("FinishLeverMissesLabel").getComponent("Component.Text") as Text
    const time = findSceneObjectByName("FinishTime").getComponent("Component.Text") as Text
    print(`[SeatInflateScenario] finish card: "${time.text}" / "${stats.text}"`)
    expect(stats.text.indexOf("misses") >= 0, "stats list names the misses").toBe(true)
    expect(time.text.indexOf(":") >= 0, "time on the Finish card").toBe(true)
    expect(audio.finishPlays, "Finish cue once").toBe(finishBefore + 1)
    expect(audio.donePlays, "no halfway Done cue on the Finish").toBe(doneBefore)

    // ── Restart ────────────────────────────────────────────────────────────
    await interactor.tap("BtnRestart")
    await sleep(300)
    expect(manager.getState().step, "Restart returns to step 0").toBe(0)
    expect(finishCard.enabled, "FinishCard hidden after restart").toBe(false)
    expect(tire.getTransform().getLocalScale().x, "tire back to full after reset").toBeCloseTo(1.0, 2)
  }
}
