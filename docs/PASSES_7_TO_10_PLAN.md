# Bench Coach: feature passes 7 to 10 and submission plan

## Context

Criteria 1 to 5 of `docs/BENCH_COACH_PLAN.md` are built and all six LEAF scenarios pass (branch `Sujeeth-AR-SPECS-WORK`, HEAD 9ea17f3, in sync with the teammate's `Sudeep-Updates`). The builder looked at the preview and found it thin: a start card in an empty grid room, then a grey wheel on a post. The ask is a complete plan that makes the Lens richer and adds features, then executes it, before the Nov 5 live review (feature freeze) and the Nov 9 deadline.

Builder's choices: richer scene, learning layer, finish the repair (with a halfway card), watch mode. Voice is skipped (text-to-speech is deprecated in the Lens runtime; the only path needs an internet gateway). Four unattended build passes, each run by `ls-clad:specs-experience-builder` through the Lens Studio MCP, verified by me in the preview with LEAF, then committed and pushed.

Pass order is 7, 9, 8, 10: the second half (pass 9) extends the step table, and the learning layer (pass 8) indexes that table, so doing 9 first avoids re-touching 8.

## Ground rules for every pass

- **Step numbering (final):** 0 Start, 1 Deflate, 2 Loosen, 3 First lever, 4 Second lever and peel, 5 Pull the tube, 6 Inspect, 7 Tube out (halfway card), 8 Fit the new tube, 9 Seat the bead, 10 Inflate, 11 Done. Steps 0..7 keep their ids, names, anchors and the `DoneCard` object (its text already reads "Tube out, cause found. Ready for the new tube."; it gains `BtnContinue`, and `BtnTryAgain` is relabeled "Start over"). This keeps every existing LEAF assertion true. The new final card is a new object `FinishCard`.
- **`RepairManager.ts` stays the only step machine.** Two seams keep it small: a `StepModule` interface (pass 9) that it delegates to through the `default:` branches of `completeStep` / `undoStep` plus one line each in `applyStep` and `markerAnchorFor`; and a `RepairDirector` (pass 10) that only calls public APIs. New features hang off `onStepChanged`, `getState()` and the controllers' events.
- **Data first:** `StepDefinitions.ts` grows (`hint`, `railDot`, `module`, `showFinishCard`, `showNewTube`) plus tables `PART_FACTS`, `MISTAKES`, `FLAT_CAUSES`, `WATCH_BEATS`. `@input` defaults stay literals (recorded pitfall).
- **Known pitfalls to pass to the builder every time** (all in `devpost/design-notes.md`): literal `@input` defaults; no class getters across component-typed inputs; `UIHelpers.makeFlex` sets `autoDiscoverItemsOnStart=false`; LEAF drag is per frame, use `BenchCoachLeafInteractor.dragTo`; never disable an `Interactable` under a held pinch; a recompile resets the running Lens, one agent owns the preview; reset the preview camera before `peel-and-pull`; save the project through `IModel.project.save()`; no black or dark grey (additive display).
- Each pass: commit before, builder runs, I verify (recompile, logs, screenshots, all scenarios from the default camera pose), commit, push. Design-notes entry per pass, facts only.

## Pass 7: richer scene and visual spec gaps (Oct 25 to 26)

Assets:
- SPECS text-to-3D via `/build-mesh` (start jobs first, they take minutes): `Workbench.glb` ("sturdy garage workbench, pale birch plywood top, light grey steel legs and lower shelf, clean, single freestanding asset"), `Pegboard.glb` ("flat pale pegboard panel with hanging bicycle workshop tools: wrench, pliers, screwdrivers, hex keys, tire levers, light colors, shallow relief, single freestanding asset"), optional `Saddle.glb` and `Toolbox.glb`. Prompts say pale/light; if a result comes back dark, tint `baseColor` up via asset-graphql or regenerate. Wrap each instance in a parent and scale the wrapper (instances have localScale 100).
- MeshBuilder scripts (`/mesh-builder-scripting`): `RearTriangle.ts` (chain stays, seat stays, seat tube, BB shell, dropouts, parametric from the hub so alignment is by construction; do not ask text-to-3D for a bike, it returns whole bikes), `LeverMesh.ts` (12 cm curved lever with a spoon tip and spoke hook, origin at the shaft center so the existing sockets and 12x2x1 collider stay valid; replaces the box on `LeverA`, `LeverB`, `GhostLever`), `FloorMat.ts` (180 x 120 rounded mat, light grey with a pale blue border; the shadow receiver).
- `TorusArc.ts` gains `treadDepth` and `treadBlocksPerArc` (square-wave bump on the outer third of the cross-section).
- `/build-sfx` `Hiss.wav` for the deflate.

Scene (stable names): `Environment` root (enabled with the wheel) with `Workbench`, `Pegboard`, `Toolbox`, `FloorMat`; wheel at (0,-25,-90), floor y=-150: mat at (0,-149.5,-90), bench behind at z=-175 with its top at y=-60, pegboard on a virtual wall at z=-200. `Stand/BikeFrame` (+ `Saddle`), `StandClamp` moved to grip the seat tube. `Lighting/KeyLight` (35 deg down, 30 deg from the left, shadows on, density 0.35) and new `FillLight`; add the specular env map so metal reads. New `HubMat` metallic; `RimMat` metallic 0.9 / roughness 0.35. Wheel and stand cast shadows, mat receives. Simplify imported meshes to 20k tris or fewer; cap new triangles around 60k.

Scripts:
- New `Highlighter.ts` on `BenchCoach`: `set(parts)`, `clear()`, `current: string[]`; swaps materials for cached clones lerped toward a cyan glow and pulses. Step 1 lights `Valve`, step 2 lights the unloosened `LOOSEN_BEADS`.
- `RepairManager.ts`: inputs `highlighter`, `environment`, `tube`; `applyStep` enables `Environment` with the wheel, hides `Tube` until a bead lifts (step 4 or lever A placed), calls `highlighter.set(...)`; valve pinch plays the hiss (`BenchCoachAudio.playHissAt`). Step 4 tick angle 150.
- `RimDrag.ts` and `StepDefinitions.PEEL_END_ANGLE_DEG`: peel to 150 degrees (5 o'clock) so Bead_1..3 lift. Not 180: lever B would park on `TubeEnd`'s hit box and the tick would stack on step 5's.
- `TubePull.ts`: segment-by-segment pull; order `[4,3,5,2,6,1,7,0]` with the pull distance driving each segment's progress, existing staggered finish completes it; `completeInstant` and `restore` unchanged.

LEAF: new `scene-dressing` (`Environment` and `BikeFrame` enabled after Found it and disabled on step 0; dropout within 1 cm of `Hub`; `Tube` hidden on step 2 and shown on step 4; `hissPlays` +1 after the valve; `highlighter.current` is `["Valve"]` on step 1 and the unloosened beads on step 2). Update `peel-and-pull` (waypoints to 150 degrees, `getPeeledBeads().length == 3`, and a mid-pull check that `TubeSeg_4` moves before `TubeSeg_0`).

Order: 7a code and sounds, run all scenarios; 7b scene placement, lights, shadows, simplify, screenshot walk, save, notes. Verify `lever-snap` right after the lever mesh swap before anything else.

## Pass 9: finish the repair, steps 8 to 11 (Oct 27 to 28)

Seam in `StepDefinitions.ts`:
```ts
export interface StepModule {
  ownsStep(step: number): boolean
  complete(step: number): void   // model state as if done (Next / jumpToStep)
  undo(step: number): void       // Back / reset
  apply(step: number, paused: boolean): void
  markerAnchor(step: number, live: boolean): {pos: vec3; angleDeg: number; radius: number} | null
  replay(step: number): boolean
  demo(step: number): number     // pass 10: animate the step, return seconds
}
```
`RepairManager.ts` (about 40 lines): inputs `refit: RefitSteps` (`@allowUndefined`), `finishCard`, `stats`; `completeStep` / `undoStep` default to `refit`; `applyStep` calls `refit.apply`, toggles `FinishCard`, pushes stats; `markerAnchorFor` defers for module steps; `refit.onStepComplete` advances; `LAST_STEP` plays a new `Finish` cue (the step-7 `Done` cue stays so `inspect-done` holds). The bead-offset helper moves to a shared `WheelMath.ts`.

New steps in `STEPS`: 8 "Fit the new tube" ("Start at the valve. Feed the new tube in.", action `tubeFit`, tray shown, `NewTube` shown), 9 "Seat the bead" ("Push the bead back over the rim", beads 0..3), 10 "Inflate" ("Pinch and hold the valve to inflate"), 11 "Done" ("Flat fixed.", `FinishCard`). `StepTicks` pool 6 to 9.

Scripts:
- New `RefitSteps.ts` (implements `StepModule`) on `BenchCoach`: step 8 entry tweens both levers home and shows `NewTube` in the tray; `TubeFit.onFitted` triggers `TubePull.refit()` (new: re-enables the same `TubeSeg_i` at home in order with a stagger, valve home) and completes 8; step 9 seats beads on `WheelTargets.onBeadPinched` (offset to 0, highlight the rest); step 10 accumulates hold time from the valve `Interactable`'s trigger start/end, lerps `Tire` and `Tube` scale 0.96 to 1.0 with a looping pump sound; `undo` reverses each. Model change for step 8 lives in `apply(8)`/`undo(8)` so `jumpToStep(7)` still matches `inspect-done`'s snapshot.
- New `TubeFit.ts` on `ToolTray/NewTube/NewTubeEnd` (same pattern as `LeverPlacement.ts`: collider, Interactable, Manipulation, socket = new `Wheel/ValveSocket` at 12 o'clock, 5 cm snap, `onFitted`, `onRejected`, `fitInstant()`, `returnHome()`); `NewTube` is a coiled tan ring (TorusArc) that hides on fit.
- New `RunStats.ts` on `BenchCoach`: `leverMisses` (from `onRejected`), `hintsUsed`, `mistakes`, `reset()`, `snapshot()`.
- New `BenchCoachFinishCardUI.ts` on `FinishCard` (billboarded above the wheel): "Flat fixed.", time, stats line ("Lever misses 1 · Hints 0 · Cause: thorn"), prevention tip, `BtnRestart`.
- `BenchCoachDoneCardUI.ts`: `BtnContinue` ("Fit the new tube", primary); `UIBindings.ts` wires Continue to `next()` and Restart to `reset()`.
- `BenchCoachAudio.ts`: `Pump.wav` loop (`/build-sfx`) and `Finish.wav` (`/build-music`, short rising arpeggio).
- `BenchCoachLeafInteractor.ts`: `holdOn(name, ms)` for pinch-and-hold.

LEAF: new `refit-tube` (`jumpToStep(8)`: levers back in the tray, `NewTubeEnd` enabled; drag to `ValveSocket`: every `TubeSeg_i` enabled within 0.5 cm of home, valve home, step 9; Back hides them again) and `seat-inflate` (`jumpToStep(9)`: tap Bead_0..3 to step 10; `holdOn("Valve", 3000)`: tire scale 1.00, `pumpPlays` > 0, step 11, `FinishCard` enabled with "misses" in the stats; `BtnRestart` to step 0). Update `step-ticks` (9 ticks on step 11) and extend `inspect-done`'s Back loop to `LAST_STEP`.

## Pass 8: learning layer (Oct 29 to 30)

Data in `StepDefinitions.ts`: `hint` and `railDot` per step; `PART_FACTS` (Rim, Hub, Spoke, Tire, Tube, Valve, levers, stand, hotspot, frame: name + one-line fact); `MISTAKES` (`beadBeforeDeflate`, `valveAlreadyDeflated`, `leverBBeforeA`, `leverTooFar`, `tubeBeforePeel`); `FLAT_CAUSES` (thorn 120 deg, glass shard 200, snakebite 300; label, prevention tip, reveal shape).

Scripts:
- New `PartInfo.ts` ("What's this?") on `BenchCoach`: `setActive(on)`, `active`, `lastPart`; builds `InfoHit_<Name>` colliders + Interactables per fact entry, enabled only while active; a pinch writes "Title: fact" to the step label and places it at the part. Pauses step interactions through a new `RepairManager.setInteractionsPaused(on)` (re-runs `applyStep` with every arm gated). `setActive` waits until no lever is busy.
- New `CoachFeedback.ts`: `mistake(code, worldPos)` plays nope, shows the reason on the label for 2.5 s, restores the step label; `mistakeCount`, `lastCode`, `onMistake`. `WheelTargets.setActive(valve, beads[])` gets targets on all eight beads so step 1 can catch a bead pinch; lever B rejected on step 3 reports `leverBBeforeA`.
- `ThornHotspot.ts`: `setCause(cause)` repositions and builds the reveal shape (spike, shard, two dots); `causeId`, `currentAngleDeg`. `RepairManager.foundIt()` picks a random cause unless `forceCause` is set; `getCause()`; `markerAnchorFor` reads the hotspot's angle.
- New `ProgressRail.ts` on `ControlBar/ProgressRail` (body-follows with the bar): one 0.8 cm dot per `railDot` step, bright = done, pulsing = current, dim clone = ahead (the `StepTicks` dim-clone trick); `setStep`, `litCount`, `dotCount`. UIKit `ProgressBar` is the fallback.
- New `IdleHint.ts`: `idleSec` (12, public), `touch()`, `suspended`, `hintCount`, `onHint`; resets on step or sub-step change and on any control-bar press; on fire shows `def.hint`, boosts the marker pulse (`StepMarker.pulseBoost`), chimes at the marker.
- `BenchCoachControlBarUI.ts`: `BtnWhatsThis` (icon `info`, latched tint); `UIBindings.ts` wires it and calls `idle.touch()` on every press.

LEAF: `whats-this`, `mistakes`, `flat-causes` (always forced, randomness never asserted), `progress-idle` (rail counts; `idleSec = 1` then `hintCount == 1` and the hint label; Next clears it).

## Pass 10: watch mode and final LEAF sweep (Nov 1 to 2)

- New `RepairDirector.ts` on `BenchCoach`: `play()`, `stop()`, `playing`, `beatIndex`, `onFinished`. Runs `WATCH_BEATS` from a new `WatchPlan.ts`: per step `{waitSec, action}` with actions `next`, `hookA` (ghost plays, then `LeverPlacement.placeInstant(true)`), `sweep` (`placeInstant`, then new `RimDrag.playSweep(sec)` which tweens the pose and emits the existing segment events), `pull` (new `TubePull.playPull()`), `find` (`ThornHotspot.flash()` then new `findInstant()`), `demo` (`RefitSteps.demo(step)`). The step's own events advance the manager; the director never touches private state. Stops on any control-bar press, on a lever grab, or at `LAST_STEP`; suspends `IdleHint` while playing. About 60 s end to end.
- `BenchCoachStartCardUI.ts`: `BtnWatch` ("Watch", icon `play_arrow`) → `foundIt()` then `director.play()`.
- LEAF: `watch-mode` (Watch starts it; poll until step 4 and three peeled beads; Next stops it and advances once; resume to `LAST_STEP` with `FinishCard` enabled; polling with hard timeouts so a failure is an assertion, not a hang).
- Final sweep: run all 14 scenario ids serially from the default camera pose (`start`, `deflate-loosen`, `lever-snap`, `peel-and-pull`, `inspect-done`, `step-ticks`, `scene-dressing`, `refit-tube`, `seat-inflate`, `whats-this`, `mistakes`, `flat-causes`, `progress-idle`, `watch-mode`, plus helper `jump-to-step`). Results go in `devpost/design-notes.md` and later the README table.

## Submission work (Nov 3 to 8)

| Date | Work |
| --- | --- |
| Sat Oct 25 | Builder runs the `plan-lens` interview in a fresh chat (writes `devpost/design-brief.md`); I start pass 7 (text-to-3D jobs first). |
| Sun Oct 26 | Pass 7b. 7 scenarios green. |
| Mon Oct 27 to Tue Oct 28 | Pass 9a, 9b. 9 scenarios green. |
| Wed Oct 29 to Thu Oct 30 | Pass 8a, 8b. 13 scenarios green. |
| Fri Oct 31 | Buffer for regressions and the builder's hands-on preview walk. |
| Sat Nov 1 to Sun Nov 2 | Pass 10, final LEAF sweep, 14 green. |
| Mon Nov 3 | Perf check in the preview, polish, record terminal and LEAF footage. |
| Tue Nov 4 | Dry run of the live demo (watch mode as the opener, then a manual far-side walk). Bugs only from here. |
| Wed Nov 5 | Live review 12 PM ET. Feature freeze. |
| Thu Nov 6 | Review feedback fixes (bugs only). Builder writes the README (I check facts, paste the LEAF table, disclosures: SIK, UIKit, LEAF, Base Template, CLAD-generated code, text-to-3D assets). Move `AGENT_BRIEF.md` and `docs/` except `HACKATHON.md` and `SUBMISSION_CHECKLIST.md` out of the repo. Rename the project from "Specs Base Template". |
| Fri Nov 7 | Builder records the sub-3-minute video (use `jump-to-step` and watch mode for clean takes), uploads public to YouTube. |
| Sat Nov 8 | Repo public, Devpost form submitted. |
| Sun Nov 9 | Slack day; deadline 5 PM ET. |

Cut order if behind on Oct 31: drop "What's this?" first, then the flat-cause variants, then the environment props beyond the mat and bench. Never cut the final LEAF sweep.

## Verification (every pass)

1. `RecompileTypeScriptTool` clean; `RunAndCollectLogsTool` refresh with no errors.
2. `MovePreviewCamera reset`, then run every registered scenario serially with `run_leaf_scenario` (long ones watched through the Lens Studio log).
3. Screenshots of each new state (`jump-to-step` to reach them) and an isometric runtime capture of the whole scene; check nothing is black and nothing sits between the user and the wheel.
4. Save through `IModel.project.save()`, `git status` shows only intended files, commit, push `Sujeeth-AR-SPECS-WORK`.
5. Builder does a hands-on mouse walk after passes 7 and 10 at minimum.
