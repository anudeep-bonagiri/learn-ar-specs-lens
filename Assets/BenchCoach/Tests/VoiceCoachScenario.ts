import {Scenario} from "Leaf.lspkg/Scenarios/scenario/Scenario"
import {expect} from "Leaf.lspkg/Utils/common/Expect"
import {findSceneObjectByName, sleep} from "Leaf.lspkg/Utils/common/Utils"
import {BenchCoachLeafInteractor, getRepairManager} from "./BenchCoachLeafInteractor"
import {VoiceCoach} from "../Scripts/VoiceCoach"
import {CoachFeedback} from "../Scripts/CoachFeedback"
import {IdleHint} from "../Scripts/IdleHint"
import {BenchCoachAudio} from "../Scripts/BenchCoachAudio"
import {ScanReveal} from "../Scripts/ScanReveal"
import {LAST_STEP, voiceLines} from "../Scripts/StepDefinitions"

/**
 * Pass V, the voice coach. Every voiceLines() id has a track. A step speaks its line about
 * 0.4 s after it starts, and step 1's line waits for the scan reveal's sweep; a mistake
 * cuts the playing line off and speaks its reason; the idle hint speaks; the same line never
 * starts twice within 6 s (Replay inside the window is skipped, outside it speaks); the
 * cues duck while a line plays and the cue counters do not move for speech; BtnVoice off
 * stops the line at once and keeps the next step silent; the halfway card says "halfway"
 * (not step-07) and the Finish card "finish".
 */
@component
export class VoiceCoachScenario extends Scenario {
  async run(): Promise<void> {
    await sleep(1000)
    const manager = getRepairManager()
    const interactor = new BenchCoachLeafInteractor()
    const root = findSceneObjectByName("BenchCoach")
    const voice = root.getComponent(VoiceCoach.getTypeName()) as VoiceCoach
    const fb = root.getComponent(CoachFeedback.getTypeName()) as CoachFeedback
    const idle = root.getComponent(IdleHint.getTypeName()) as IdleHint
    const audio = findSceneObjectByName("Audio").getComponent(BenchCoachAudio.getTypeName()) as BenchCoachAudio
    const reveal = findSceneObjectByName("ScanReveal")
    const scan = reveal ? (reveal.getComponent(ScanReveal.getTypeName()) as ScanReveal) : null
    expect(voice, "VoiceCoach on BenchCoach").toBeTruthy()
    expect(voice.missing.length, `every voice line has a track (missing: ${voice.missing.join(", ")})`).toBe(0)
    expect(voiceLines().length, "30 voice lines").toBe(30)
    voice.setEnabled(true)

    const since = (n: number) => voice.history.slice(n).map((h) => h.id)
    const waitFor = async (sec: number, cond: () => boolean) => {
      const end = getTime() + sec
      while (getTime() < end && !cond()) await sleep(50)
      return cond()
    }

    // ── Step 1: the line waits for the scan reveal's heads to meet ─────────────
    manager.reset()
    await sleep(400)
    let n = voice.history.length
    let t0 = getTime()
    await interactor.tap("BtnFoundIt")
    expect(await waitFor(4, () => since(n).indexOf("step-01") >= 0), "step 1 speaks step-01").toBe(true)
    const s1 = voice.history[voice.history.length - 1]
    print(`[VoiceCoachScenario] step-01 started ${(s1.t - t0).toFixed(2)} s after Found it (sweep ${scan ? scan.sweepSec : "?"} s)`)
    if (scan) expect(s1.t - t0, "step-01 waits for the sweep").toBeGreaterThan(scan.sweepSec - 0.1)

    // ── A step speaks about 0.4 s after it starts; the cues duck meanwhile ─────
    manager.jumpToStep(2)
    await sleep(800)
    n = voice.history.length
    const ticks = audio.tickPlays
    const chimes = audio.chimePlays
    t0 = getTime()
    manager.next()
    expect(manager.getState().step, "on step 3").toBe(3)
    expect(await waitFor(2, () => since(n).indexOf("step-03") >= 0), "step 3 speaks step-03").toBe(true)
    const s3 = voice.history[voice.history.length - 1]
    const lag = s3.t - t0
    print(`[VoiceCoachScenario] step-03 started ${lag.toFixed(2)} s after the step change`)
    expect(lag > 0.3 && lag < 0.9, `step-03 about 0.4 s after the step (${lag.toFixed(2)} s)`).toBe(true)
    expect(voice.speaking, "step-03 playing").toBe("step-03")
    await sleep(100)
    expect(audio.duck, "long cues ducked while the line plays").toBeLessThan(0.75)
    expect(audio.tickPlays === ticks && audio.chimePlays === chimes, "speech moves no cue counter").toBe(true)

    // ── A mistake interrupts ───────────────────────────────────────────────────
    const stopsBefore = voice.stops.length
    n = voice.history.length
    fb.mistake("leverTooFar", findSceneObjectByName("StepMarker").getTransform().getWorldPosition())
    expect(voice.stops.length, "the mistake cut the step line off").toBe(stopsBefore + 1)
    expect(voice.stops[voice.stops.length - 1], "it was step-03").toBe("step-03")
    expect(await waitFor(1.5, () => since(n).indexOf("mistake-leverTooFar") >= 0), "mistake-leverTooFar speaks").toBe(true)
    expect(await waitFor(4, () => voice.speaking === ""), "the mistake line ends").toBe(true)
    await sleep(200)
    expect(audio.duck, "cues back to full once the line ends").toBe(1)

    // ── The idle hint speaks ──────────────────────────────────────────────────
    await waitFor(3, () => !fb.showing)
    const savedIdle = idle.idleSec
    idle.idleSec = 1
    idle.touch()
    n = voice.history.length
    const hinted = await waitFor(4, () => since(n).indexOf("idle-step-03") >= 0)
    idle.idleSec = savedIdle
    expect(hinted, "the idle hint speaks idle-step-03").toBe(true)
    await waitFor(4, () => voice.speaking === "")

    // ── Never the same line twice within 6 s ─────────────────────────────────
    // step-03 started more than 6 s ago by now? Wait until it has, then Replay speaks it.
    await waitFor(8, () => getTime() - s3.t > voice.repeatGuardSec + 0.1)
    n = voice.history.length
    manager.replay()
    expect(await waitFor(1, () => since(n).indexOf("step-03") >= 0), "Replay says step-03 again after 6 s").toBe(true)
    const skips = voice.skipped.length
    n = voice.history.length
    manager.replay()
    await sleep(300)
    expect(since(n).length, "a second Replay inside 6 s says nothing").toBe(0)
    expect(voice.skipped.length, "it is logged as a skip").toBe(skips + 1)
    expect(voice.skipped[voice.skipped.length - 1], "the skipped line is step-03").toBe("step-03")

    // ── BtnVoice off silences at once, and the next step stays quiet ──────────
    expect(voice.speaking, "step-03 still playing from the Replay").toBe("step-03")
    await interactor.tap("BtnVoice")
    expect(voice.enabled, "Voice off").toBe(false)
    expect(voice.speaking, "the line stopped at once").toBe("")
    expect(voice.speaker.isPlaying(), "the speaker is silent").toBe(false)
    n = voice.history.length
    manager.next()
    await sleep(1200)
    expect(since(n).length, "nothing speaks with Voice off").toBe(0)
    await interactor.tap("BtnVoice")
    expect(voice.enabled, "Voice on again").toBe(true)

    // ── Halfway and finish ────────────────────────────────────────────────────
    manager.jumpToStep(6)
    await sleep(800)
    n = voice.history.length
    manager.next()
    expect(manager.getState().step, "on the halfway card").toBe(7)
    expect(await waitFor(2, () => since(n).indexOf("halfway") >= 0), "the halfway card says halfway").toBe(true)
    expect(since(n).indexOf("step-07"), "not step-07 as well").toBe(-1)
    manager.jumpToStep(LAST_STEP - 1)
    await sleep(800)
    n = voice.history.length
    manager.next()
    expect(manager.getState().step, "on the Finish card").toBe(LAST_STEP)
    expect(await waitFor(2, () => since(n).indexOf("finish") >= 0), "the Finish card says finish").toBe(true)

    // ── No line started twice inside 6 s in this whole run ────────────────────
    const last: {[id: string]: number} = {}
    for (const h of voice.history) {
      if (last[h.id] !== undefined) expect(h.t - last[h.id] >= voice.repeatGuardSec - 0.05, `${h.id} not repeated within 6 s`).toBe(true)
      last[h.id] = h.t
    }
    print(`[VoiceCoachScenario] spoken: ${voice.history.map((h) => h.id).join(", ")}; stops ${voice.stops.join(", ")}; skips ${voice.skipped.join(", ")}`)

    manager.reset()
    await sleep(300)
  }
}
