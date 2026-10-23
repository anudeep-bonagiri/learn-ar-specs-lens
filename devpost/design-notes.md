# Design notes

Dated build log for Bench Coach. One entry per iteration, with the reason for each change.

## 2026-10-23: Section 9 verifications (plan `docs/BENCH_COACH_PLAN.md`)

Environment: Lens Studio 5.23.2, SIK 2.0.0, UIKit 2.0.0, LEAF 2.0.2, preview on SPECS 27 Interactive (Plane scene).

| # | Check | Result | Evidence |
| --- | --- | --- | --- |
| 1 | Black in preview | **Black vanishes.** With the SPECS simulation on, a pure black cube at 90 cm did not render at all; a mid-grey (0.5) cube rendered. Wheel stays mid-grey. | Preview screenshot, two 20 cm unlit cubes at z = -90 |
| 2 | Procedural wheel in one pass | **Pass.** `Stand` (base, post, clamp) and `Wheel` (`Hub`, `Rim`, `Spokes/Spoke_0..15`, `Tire/Bead_0..7`, `Tube/TubeSeg_0..7`, `TubeEnd`, `Valve`) built in one VirtualScene apply. Every part is its own SceneObject; Stand, Rim, Spoke, Tire, Tube and Valve have separate materials. | Front screenshot and isometric runtime capture; no runtime errors |
| 3 | LEAF install + trivial button scenario | **Pass.** LEAF 2.0.2 installed from the Asset Library (pulls Bitmoji 3D). `verify-button` triggers a UIKit `Button` named `BtnVerify` and asserts the press counter went up by one. | LEAF panel: `PASSED: verify-button` (1.5 s) |
| 4 | Grab in preview | **Pass.** `LeverA` with `Interactable` + `InteractableManipulation` (box collider 12 x 2 x 1). Mouse drag (injected touch start/move/end) grabbed, moved 8.9 cm and released. Hand-sim drag via the preview interaction tool moved it 10.8 cm. LEAF `verify-lever-drag` moved it and saw one manipulation start and one end. | Log lines `[GrabbableLever] LeverA grabbed / released`; LEAF panel `PASSED: verify-lever-drag` |

Findings that change the plan:

- **`PinchButton` does not exist in SIK 2.0.** Buttons are UIKit `Button` / `RectangleButton` / `CapsuleButton`. They extend `Interactable`, so LEAF `trigger` and the preview mouse both work. Subscribe with `button.onTriggerUp`.
- **Mesh presets have fixed proportions.** The torus preset is a fat 1:3 donut, so a 62 cm rim with a 1.6 cm tube cannot come from presets. Rim, bead segments and tube segments are built at runtime by `Assets/BenchCoach/Scripts/TorusArc.ts` (MeshBuilder, one arc per object, end caps on partial arcs). Spokes, hub, stand and valve use cylinder and box presets.
- **LEAF `drag(target, vector, ms)` applies the vector every frame**, not once. A (10, 6, 0) vector over 800 ms moved the lever about 438 cm. Tests must use small per-frame vectors (for example 0.3 cm per frame) and assert on the final position.
- **Mouse grab needs a hover frame first.** A press that starts on the lever without the cursor having hovered it first does nothing; moving the cursor onto the lever, then pressing, grabs. Real mouse use does this naturally.
- **Floor height is not documented for the preview.** The stand assumes the eye is 150 cm above the floor: stand base at y = -150, hub at y = -25 (100 cm off the floor). Adjust if the preview floor turns out to be elsewhere.
- **Preview framing.** A 70 cm wheel at 90 cm fills the SPECS view; the plan already designs around the part the user is looking at.

Scaffolding left in the scene after this step, to be replaced by the first build: `VerifyButton` (script `VerifyButtonUI.ts`), `LeverA` (script `GrabbableLever.ts`), `LeafIndex` with the two verification scenarios under `Assets/BenchCoach/Tests/`.

## 2026-10-23: First build, criteria 1 to 3 (plan Section 7)

Built by the CLAD Specs Experience Builder through the Lens Studio MCP. Scene: `BenchCoach` root (`RepairManager` + `UIBindings`) with `StartCard`, `ControlBar`, `StepMarker`, `StepLabel`, `ToolTray` (`ToolTrayPanel`, `LeverA`, `LeverB`), `DoneCard`; `LeverSocket` and `GhostLever` under `Wheel`; `WheelTargets` on `Wheel` adds pinch targets to `Valve` and `Bead_0/2/4/6`. Scripts under `Assets/BenchCoach/Scripts/`, scenarios under `Assets/BenchCoach/Tests/` (`start`, `deflate-loosen`, `lever-snap`).

| Criterion | LEAF scenario | Result |
| --- | --- | --- |
| 1 Found it places the wheel; marker on the valve | `start` | PASSED (marker 1.5 cm from the valve) |
| 2 Valve + four beads complete steps 1 and 2; one marker at a time | `deflate-loosen` | PASSED |
| 3 Lever A rejects at 10 cm, snaps within 4 cm, lifts Bead_0 | `lever-snap` | PASSED (reject at 9.9 cm returned to tray; snap at 1.5 cm; Bead_0 lift 1.0 cm) |

Findings that change the plan:

- **Class getters are invisible across component-typed `@input`s.** `get onFoundIt()` on a UI module read as `undefined` from `UIBindings`; public fields (`onFoundIt: PublicApi<void> = this._onFoundIt.publicApi()`, the SIK style) work. Same for `getState()`-style methods: use methods or fields, never getters, on anything another script reads through an `@input`.
- **UIKit 2.0 `FlexLayout.addItems()` throws before init unless `autoDiscoverItemsOnStart = false`.** The shared `UIHelpers.makeFlex` sets it to false so layouts can be composed in `onAwake`.
- **LEAF drag is steered per frame.** `BenchCoachLeafInteractor.dragTo(target, worldPos)` adjusts the interactor each `onDragUpdate` toward a world position and releases when within 0.4 cm (or on timeout), so snap and reject tests are frame-rate independent.
- **The LEAF ChatTools (`list_leaf_scenarios`, `run_leaf_scenario`, `open_leaf_panel`) are callable from editor code** via `IChatToolRegistry.execute()` when the MCP client does not surface them.
- **Deflate scales `Tube` with `Tire`**; shrinking the tire alone sank the beads into the tube ring.
- Body-locked panels (`ControlBar`, `ToolTray`) are static world placements relative to the start pose in this pass; a follower would move the levers' parent mid-drag.

## 2026-10-23: Pass 3, criterion 4 (plan Section 7): second lever, rim drag, far-side marker, tube pull

Built by the CLAD Specs Experience Builder through the Lens Studio MCP. Scope: step 4 and step 5 only; steps 6 and 7 stay Next-only stubs.

What was built:

- `LeverSocketB` under `Wheel` at wheel-local (12.80, 34.08, 0), rotation (0, -25, 69.42): 20.58 degrees clockwise of 12 o'clock, 5 cm along the 33.4 cm bead circle from socket A (12 degrees). `StepDefinitions` step 4 is now action `leverB` with `ghostSocket: "B"`; step 5 is action `tubePull`. `GhostAnimator.setSocket()` retargets the ghost per step.
- `LeverB` keeps `LeverPlacement` (socket wired to `LeverSocketB`, `snapEnabled` only during step 4 before the hook) and gains `RimDrag.ts`: after the hook it re-enables the SIK manipulation, projects the lever onto the socket's circle in the wheel plane every LateUpdate (radius 36.4 cm, radial and tangent-aligned), tracks the clockwise angle, emits `onSegmentPassed(i)` as the lever reaches i * 45 degrees and `onPeelComplete` at 90 degrees (3 o'clock), where it locks. `RepairManager` lifts Bead_1 and Bead_2 by 1 cm and plays the zipper from the lever's position.
- `TubeEnd` gains a box collider, `Interactable`, `InteractableManipulation` and `TubePull.ts`: armed in step 5 only; once the tube end is 15 cm past the rim (47.1 cm from the hub with the deflated tube) the eight `TubeSeg_i` tween 22 cm down and 10 cm toward the user, staggered 0.1 s over 0.5 s each, then `Valve` lifts 6 cm; `onPullComplete` enters step 6. `restore()` puts tube, tube end and valve back.
- `EdgeHint.ts` on `BenchCoach`: projects `StepMarker` with `Camera.worldSpaceToScreenSpace`; outside the centered 80 percent rectangle (or behind the user) it shows `EdgeArrow` (an empty child of `Camera Object`; a 3 cm cyan `MarkerMat` chevron built with MeshBuilder, both windings), placed at the view edge at 45 cm and aimed at the marker, and plays the chime once per step from the marker's world position. Step 5's marker sits 1.5 cm in front of `TubeEnd`.
- `Audio` under `BenchCoach` with `Zipper` and `Chime` children (`AudioComponent`s, spatial, LowLatency) and `BenchCoachAudio.ts` (volumes 0.35 and 0.4, moves the emitter before playing). `AudioListenerComponent` added to `Camera Object` (spatial audio warns without it). `Assets/GeneratedSFX/Zipper.wav` (accelerating band-passed tick train over a faint rising body, 1.05 s with tail) and `Chime.wav` (two-bell notify preset, medium room, 3.2 s) are algorithmic, license-clean, from `/build-sfx`.
- `RepairManager`: Next now applies the current step's model change before advancing (`completeStep`); Back drops the current step's partial work, then undoes the previous step (lever B back to the tray and peeled beads lowered from step 4; tube and valve restored from step 5); `jumpToStep(n)` for tests and demo recording.
- Tests: `PeelAndPullScenario` (`peel-and-pull`) and a helper `JumpToStepScenario` (`jump-to-step`, parameter `step`, default 5) that leaves the Lens on a step for screenshots.

| Criterion | LEAF scenario | Result |
| --- | --- | --- |
| 1 | `start` | PASSED |
| 2 | `deflate-loosen` | PASSED |
| 3 | `lever-snap` | PASSED (assertion updated: after the snap the ghost is re-shown at socket B, 5 cm away, instead of hidden) |
| 4 | `peel-and-pull` | PASSED (lever B snap 0.0 cm; Bead_1 passed at 44.2 degrees, Bead_2 at 90.0; lifts 0.96 cm each; marker 1.50 cm from TubeEnd; EdgeArrow on from the default camera; pull started at 47.2 cm; all eight segments displaced; step 6) |

Findings that change the plan:

- **`@input` defaults must be literals.** `peelEndAngleDeg: number = PEEL_END_ANGLE_DEG` (an imported constant) registered as 0 in the scene, so the rim drag completed the instant lever B was hooked and the tube pull fired at 15 cm from the hub. Both now use literal defaults (90, 33.4).
- **A controller must only release what it armed.** `RimDrag.disarm()` ran on every non-step-4 transition and switched off lever B's manipulation, making it ungrabbable from the tray; it now only disables manipulation if it had armed it.
- **Rim constraint works with SIK's absolute translate.** `InteractableManipulation` sets the position to interactor + offset each frame; the LateUpdate projection keeps the visible lever on the circle while the raw position drifts (at completion it was near the camera). `dragTo` steers on the visible position, so the LEAF waypoints (35, 50, 65, 80, 90 degrees) were all reached exactly.
- **`onManipulationEnd` fires three times per release** (three `snapped` log lines); harmless because the snap tween restarts toward the same pose.
- **LEAF tools are reached through `IChatToolRegistry.execute(descriptor, Parameters)`** with `Parameters.data = {scenarioId, parameters}`. Awaiting `open_leaf_panel` never resolved (the panel did open); `list_leaf_scenarios` and `run_leaf_scenario` resolve normally. Runs must stay serial.
- **The chime fires in any step whose marker leaves the view**, including step 2's beads at 6 and 9 o'clock, which matches the Section 4 visibility rule rather than only step 5.
- Tube segments' transforms sit at the wheel center (the arc is in the mesh), so the test asserts displacement greater than 10 cm rather than distance from the hub.
- The generator script folder `tempAssetGen/` was removed after rendering; the recipes are described above.

Left for criterion 5: thorn hotspot and inspect step, Done card timing and Try again, Back and Replay at every step under test, tick / click / nope / done sounds, body-locked follow for the control bar and tray.
