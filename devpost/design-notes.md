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

## 2026-10-24: Pass 4, criterion 5 (plan Section 7): inspect, Done, Back and Replay everywhere, cues, body-locked panels

Branch `Sudeep-Updates`. Scope: step 6 and 7 behavior, Back and Replay on every step, the remaining cues, and lazy body-follow for the control bar and tool tray. The tube still leaves as one ring (segment-by-segment peel stays deferred).

What was built:

- `ThornHotspot` under `Tire` at 4 o'clock (local (29.62, -17.1, 2.0), rotation z -120 so local +Y points out of the tire) with `ThornHotspot.ts`: a 1 cm cyan `MarkerMat` glint (unit `Sphere.mesh`) that twinkles only while step 6 is armed, a 5 cm pinch box and `Interactable` that exist only while armed (the box overlaps `Bead_2`'s hit box), and a brass `ValveMat` thorn spike shown once found. `flash()` is the Replay hint.
- Step 6 is a search: `StepDefinitions` marker anchor `inspect` puts the label above the wheel and shows no ring. Pinching the glint plays the click, moves the ring onto the thorn, swaps the label to "Thorn. Pull it out before the new tube goes in.", and after `thornRevealSec` (2.5 s) enters step 7. Back during that delay cancels it (generation counter).
- Step 7 plays the new Done cue from the Done card; the card shows the elapsed time from Found it. Try again resets to step 0.
- Replay on every step: ghost hook motion on 3 and 4, a bright glint flash on 6, the done cue on 7, and elsewhere the chime from the marker, so the user hears where the work is. `RepairManager.replayCount` exposes it for tests.
- Back from step 6 hides the thorn again; from 7 it returns to an unsolved step 6.
- Cues: `Assets/GeneratedSFX/Tick.wav`, `Click.wav`, `Nope.wav`, `Done.wav` from `/build-sfx` (algorithmic, license-clean), on new `Audio/Tick|Click|Nope|Done` emitters. Tick plays from the pressed panel on every button (`UIBindings`), click on each lever snap and on finding the thorn, nope when a lever is rejected.
- `BodyFollow.ts` on `ControlBar` and `ToolTray`: the authored pose is read as an offset from the start pose (origin, facing -Z) and carried by the camera's position and yaw. It snaps to the user on its first frame, then only glides (exponential, speed 6) once the target is 20 cm away or 35 degrees off, and holds still while either lever is grabbed or tweening. Walking 60 cm right and turning 40 degrees put the bar 45 cm ahead and 25 cm below eye level on the new heading.
- `LeverPlacement`: a hooked lever is reparented to the socket's parent (`Wheel`) so the following tray never drags it off the rim; home is stored in the tray's local space and the lever is reparented back on Back / reset.

| Criterion | LEAF scenario | Result |
| --- | --- | --- |
| 1 | `start` | PASSED |
| 2 | `deflate-loosen` | PASSED |
| 3 | `lever-snap` | PASSED |
| 4 | `peel-and-pull` | PASSED (from the default camera pose; see below) |
| 5 | `inspect-done` | PASSED (ring 1.50 cm from the thorn; Done card "Time 0:03"; Back from steps 1 to 7 matches the `jumpToStep(n-1)` model exactly, 0.000 cm; Replay acted on all 7 steps, ghost replayed on 3 and 4) |

Findings that change the plan:

- **`peel-and-pull` depends on the preview camera pose.** With the preview camera left at z 78 cm (168 cm from the wheel) the 6 o'clock marker is inside the view and the edge arrow correctly stays off, failing the assertion. Reset the preview camera (`MovePreviewCamera reset`) before a test run.
- **Hidden panels have not followed yet.** The tray is disabled until step 3, so its first follow happens when it appears; the Back test compares levers in their parent's space for that reason.
- **A ring on the answer would turn inspect into a card**, so the plan's "Marker on: tire inside face" became a label-only search with the ring as the reward.
- **Scene edits made through the MCP are not on disk until the project is saved** (`Editor.Model.IModel.project.save()`).

## 2026-10-24: Pass 5, placement and sizes (plan Section 4), checked by walking the preview

Branch `Sudeep-Updates`. Measured every panel in the running preview from the start pose, then walked through steps 0 to 7 with the hand simulation and screenshots.

Measured against Section 4 (all already to spec): control bar buttons Back 5 / Next 6 / Replay 5 cm with 2 cm gaps (centers 7.5 cm apart); start and Done cards 24 x 14 cm; step label panel 16 x 5 cm, placed 10 cm out from its marker along the wheel radius; tool tray 20 x 10 cm.

Changed, with reasons:

- **Control bar lowered from 25 to 35 cm below the eye line (still 45 cm out, tilted 38 degrees to face the eye).** At 25 cm below, the bar sat right over the bottom of the wheel, where step 5's tube end is, which breaks Section 4's own rule "No panel ever sits between the user and the wheel." The tire's lowest point is 34.4 degrees below the eye from the start pose; at 35 cm below, the bar's top edge is at 33.8 degrees, so only the outer edge of the tire's lowest point is still covered.
- **Tool tray moved from (16, -25, -40) to (20, -30, -40), tilted 37 degrees.** The old spot covered the lower right of the wheel during steps 3 and 4.
- **Step label type raised from Body to Headline2 and made to shrink for long lines.** At Body size the text filled about half the 16 cm panel, and the 47-character thorn label still ran past both edges. Labels now use Headline2 up to 32 characters and scale down beyond that (`BenchCoachStepLabelUI.fitChars`), so every label stays on one line inside the panel.
- **The valve and bead pinch targets are live only on their own steps (1 and 2).** Walking the inspect step showed that neither the hand simulation nor a mouse click could pinch the thorn: Bead_2's 26 x 6 x 6 cm hit box stays live and covers the 4 o'clock glint, and on step 6 a bead pinch does nothing. LEAF `trigger` calls the target directly without a ray, so `inspect-done` had passed anyway. `WheelTargets.setActive(valve, beads)` is called from `RepairManager.applyStep`, and `inspect-done` now asserts that the valve and bead targets are off on step 6.

| Criterion | LEAF scenario | Result |
| --- | --- | --- |
| 1 | `start` | PASSED |
| 2 | `deflate-loosen` | PASSED |
| 3 | `lever-snap` | PASSED |
| 4 | `peel-and-pull` | PASSED (default camera pose) |
| 5 | `inspect-done` | PASSED (with the new pinch-target assertion) |

Findings:

- **The preview hand simulation could not pinch targets on the wheel while their hit boxes overlapped,** and it reported `obstructed` on the valve because of the valve's own child hit box. A real pinch or click in the preview is the check that catches this; LEAF `trigger` cannot.
- **Once pulled, the tube hangs as a ring in front of the lower wheel** through steps 6 and 7. It does not block the thorn.

## 2026-10-24: Pass 6, additive-display colors, stand-in badge, dim ticks (plan Section 4)

Branch `Sudeep-Updates`.

Audited against Section 4's additive rule ("no black or dark grey anywhere"): every material's base color read from `Assets/BenchCoach/Materials/*.mat`. Darkest is the tire at 0.50 grey (the mid-grey the plan asks for); rim 0.85, spokes 0.80, stand 0.75, tube tan (0.88, 0.74, 0.52), valve brass (0.85, 0.68, 0.30), levers blue (0.20, 0.55, 1.0), ghost and marker cyan (0.10, 0.95, 1.0). Text sits on light UIKit back plates. No change needed.

Already in place from passes 1 to 4, verified in the walk: the stand-in badge ("stand-in: wheel placed by pinch") in the start card's corner; audio cues tick / click / zipper / chime / nope / done.

Built: **dim ticks for completed steps.** `StepTicks.ts` on a new `StepTicks` object under `BenchCoach` builds a pool of six check marks (two thin box strokes each, 1.6 cm) in a runtime clone of `MarkerMat` at 45% brightness, which stays cyan rather than dark. `RepairManager.placeTicks()` shows one per completed step with an anchor, using the same `markerAnchorFor()` that places the ring; a completed step's tick sits where the work ended (`StepDefinitions.tickAngleDeg`: loosen at 292.5 degrees, the last lit bead; peel at 90 degrees where the peel finishes), not where it started. The ring placement code was refactored into `markerAnchorFor(step, live)` so both the ring and the ticks share it.

| Criterion | LEAF scenario | Result |
| --- | --- | --- |
| 1 | `start` | PASSED |
| 2 | `deflate-loosen` | PASSED |
| 3 | `lever-snap` | PASSED |
| 4 | `peel-and-pull` | PASSED |
| 5 | `inspect-done` | PASSED |
| Section 4 ticks | `step-ticks` (new) | PASSED: 0..6 ticks on steps 0..7; closest two ticks (steps 1 and 3) 7.15 cm apart; inspect tick 1.50 cm from the thorn; deflate tick 1.50 cm from the valve; Back from 5 leaves 3; reset leaves 0 |

Findings:

- **A recompile from any session resets the running Lens.** A parallel agent's compile check reset the preview mid-walk; one session should own the preview while another compiles.
