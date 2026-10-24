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

## 2026-10-24: Review fixes after pass 6

A read-only review of every script change since `b1016c9` (a parallel agent, no preview access) found no high-severity bug and six small ones. Fixed:

- **Lever B lost rotate and scale after Back / Try again.** `RimDrag.arm` turned them off for the rim-constrained drag and nothing turned them back on, so the second grab from the tray no longer rotated with the hand. `RimDrag` now restores both when it disarms or completes.
- **The tube end's pinch target was live on every step.** Its 7 cm box at 6 o'clock sits in front of the end of `Bead_4`'s hit box, so a real pinch on that end of Bead_4 in step 2 would hit the tube end and do nothing (LEAF `trigger` skips the ray, so tests passed). The `Interactable` is now off until step 5 and stays on from the pull onward; `inspect-done` asserts it is off on step 2.
- **The deflate tick followed the valve.** The valve lifts 6 cm with the tube in step 5; the completed tick now stays at the rim where the valve was.
- **Lever A's tip crossed the Done card's lower corner** (card bottom at y 15, lever tip at y 15.9). The card moved up 3 cm, to (0, 25, -88).
- `RepairManager.ticks` is marked `@allowUndefined` to match its null guard.

Finding that cost a regression: **turning an `Interactable` off while a hand is still pinching it strands that pinch.** The first version of the tube-end fix turned the target off on the step change to 6, which happens while the pull drag is still held, and LEAF's `dragTo` never resolved (`peel-and-pull` timed out twice, after "tube out"). A disable now waits for the release, and the step-change path no longer touches the target at all.

Not changed (coverage gaps the review listed): the Back loop in `inspect-done` builds every "from" state with `jumpToStep`, so Back after real input (partly loosened beads, a drag in progress, the thorn's pending Done delay) is reasoned about, not tested; the snapshot compares transforms and parents only, not interactable or manipulation flags.

All six LEAF scenarios pass after the fixes, from the default camera pose.

## 2026-10-24: Pass 7a, richer scene (code and sounds half; plan `docs/PASSES_7_TO_10_PLAN.md`)

Branch `Sujeeth-AR-SPECS-WORK`. Built by the CLAD Specs Experience Builder through the Lens Studio MCP. Scope: code and sounds only; no text-to-3D props, bike frame, floor mat, lights or environment (pass 7b). Before building, the live scene was compared with the committed `Assets/Scene.scene` (191 objects, names, enabled flags, transforms and component counts): no unsaved edits from the interrupted run.

What was built:

- **`LeverMesh.ts`** (MeshBuilder, the `TorusArc.ts` pattern) on `LeverA/LeverMesh`, `LeverB/LeverMesh` and `GhostLever/GhostMesh`, whose scale went from (12, 2, 1) back to (1, 1, 1). A 12 cm lever, 2 cm wide, 1 cm thick, bowed 0.5 cm so both ends curve toward +Z, with a thinner, slightly flared spoon and a 0.6 cm lip at -X and a spoke-hook notch in the +Y edge at the +X (handle) end. Built from cross-section slices with flat per-face normals; each quad is wound so that (v1 - v0) x (v2 - v0) points outward (the same convention `TorusArc` uses). Origin at the shaft center, so the sockets and the 12 x 2 x 1 collider on the lever roots are unchanged. The existing RenderMeshVisual keeps its LeverMat / GhostMat. `lever-snap` was run straight after the swap and passed.
- **Tire tread.** `TorusArc` has `treadDepth` and `treadBlocksPerArc`: a square-wave radial bump on the cross-section's outer third (cos(phi) > 0.6, facing away from the hub), blocks centered in each period so both arc ends stay low and the end caps still fit. Ring count goes up to 4 per block; normals are recomputed from the bumped grid. Set to 0.25 cm and 6 blocks on `Bead_0..7` only.
- **`Highlighter.ts`** on `BenchCoach`: `set(parts)`, `clear()`, `current` (a field). Swaps each part's main material for one cached clone per source material, lerps its base color toward `glowTint` (0.6, 1, 1, 1) by 70 percent times a 0.5..1.0 pulse at 1.2 Hz, and restores the original on clear. `RepairManager.applyHighlight()` lights `Valve` on step 1 and the not-yet-loosened `LOOSEN_BEADS` on step 2 (re-applied after each bead pinch), and clears everywhere else.
- **Deflate hiss.** `Assets/GeneratedSFX/Hiss.wav` from `/build-sfx` (algorithmic, license-clean): white noise through a band-pass whose center slides 3 kHz to 1.5 kHz (Q 2.2) plus a quieter 6 to 4 kHz air layer, 10 ms attack, exponential decay (tau 0.38 s), 1.4 s, peak -12 dBFS. New `Audio/Hiss` AudioComponent, `BenchCoachAudio.hiss`, `hissVolume` 0.35, `playHissAt(pos)`, `hissPlays`. Played from the valve on the step-1 valve pinch.
- **Tube hidden until a bead lifts.** `RepairManager` has `@input tube`; `applyStep` sets it enabled when `step >= 4` or lever A is placed. `TubeEnd` is a child of `Tube`, so it hides with it. Back, reset and `jumpToStep` all go through `applyStep`, and `setDeflated` uses the same reference. `TubePull` keeps its recorded homes while the group is off.
- **Peel to 150 degrees.** `PEEL_END_ANGLE_DEG = 150`; `RimDrag.peelEndAngleDeg` literal default 150, and the serialized scene value changed from 90 to 150. Step 4 label: "Hook the second lever, then slide it round to 5 o'clock"; step 4 `tickAngleDeg` 150. Bead_1..3 lift.
- **Segment-by-segment tube pull.** While armed and before the 15 cm threshold, segment i's progress = clamp((d - k * 1.5) / 6), where d is the distance past the rim and k is its index in `[4, 3, 5, 2, 6, 1, 7, 0]`. `segmentLagCm` 1.5 and `segmentRunCm` 6 are inputs. At the threshold the staggered finish runs in the same order and each segment finishes from wherever the hand left it. `completeInstant()` and `restore()` keep their behavior (they also set progress to 1 and 0).
- **LEAF.** New `scene-dressing` (`SceneDressingScenario.ts`): `Tube` off on step 2, on on step 4, off again on step 3; `highlighter.current` is `["Valve"]` on step 1; the valve pinch adds 1 to `hissPlays`; on step 2 the four loosen beads are lit, and after tapping `Bead_2` exactly `Bead_0`, `Bead_4`, `Bead_6`; nothing is lit on step 3 or after reset; the `// pass 7b: Environment and BikeFrame assertions go here` marker is in place. `peel-and-pull` changes: waypoints 35, 50, 65, 80, 95, 110, 125, 140, 150; `getPeeledBeads().length == 3`; Bead_1..3 each lift about 1 cm; a mid-pull check (tube end about 8 cm past the rim: `TubeSeg_4` moved > 2 cm, `TubeSeg_0` < 0.5 cm) before the full pull. `jump-to-step` gains an optional `pullCm` (step 5 only) that holds the tube end that far past the rim, for screenshots.

| Scenario | Result (serial, default camera pose, preview) |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED (reject back to tray 0.00 cm; snap 0.00 cm; Bead_0 lift 0.96 cm) |
| `peel-and-pull` | PASSED (lever B snap 0.00 cm; Bead_1..3 lift 0.96 cm each; marker 1.50 cm from TubeEnd; mid-pull 7.8 cm past the rim: TubeSeg_4 moved 23.20 cm, TubeSeg_0 0.00 cm; step 6) |
| `inspect-done` | PASSED (Back from 1..7 worst diff 0.000 cm) |
| `step-ticks` | PASSED (closest ticks steps 1/3, 7.15 cm) |
| `scene-dressing` (new) | PASSED |
| `jump-to-step` | PASSED |

Findings and deviations:

- **SIK Z-stretch yanked the tube end toward the user on grab.** `InteractableManipulation.calculateStretchFactor` clamps the stretch to the interactor's drag range (`maxRaycastDistance` minus the arm extension). For the tube end, about 106 cm from the eye, the first grab frames moved it about 57 cm toward the camera along the ray. That is more than the 15 cm threshold, so the pull finished before any drag. The old one-step pull test passed because of this jump. It also hides the segment-by-segment pull from a real mouse or hand user. `TubePull` now sets `enableStretchZ = false` on the tube end's manipulation; the pull is a drag in the wheel's frame. The levers were never affected because the tray sits at about 48 cm.
- **`BenchCoachLeafInteractor.dragTo` has two new optional arguments.** `stopOnArrive` zeroes the drag vector before release, because LEAF keeps applying the last vector until the release lands. `stopWhen()` releases as soon as a condition holds; the final pull uses it so the hand lets go when the staggered finish starts, instead of relying on the old grab jump. Existing callers are unchanged.
- **VirtualScene addresses script inputs as `components.ScriptComponent#<index>.<input>`**, not by script class name (the class-name form failed atomically with "#0 not found").
- After the final recompile, every BenchCoach script `@input` was checked non-null in the scene snapshot. The only nulls are SIK's own hand-visual joint slots.
- Visual check: on step 1 the valve is tinted toward cyan inside the ring and the tread shows on the tire's outer edge, with the tube hidden. On step 2 beads 0, 2, 4 and 6 glow and the odd beads stay grey. On step 4 the curved lever A sits in socket A. At the end of step 4, lever B is at 5 o'clock and Bead_1..3 are lifted with the tube showing underneath. At step 5 mid-pull, the segments by the tube end hang out, the next ones are partly out, and the valve-side segments are still in. `RunAndCollectLogsTool` shows no Lens errors (only editor-side `adb` device-probe warnings, no device attached).

Left for 7b: `Environment` (Workbench, Pegboard, Toolbox, FloorMat), `Stand/BikeFrame` and `Saddle`, `StandClamp` move, lights and shadows, metallic Hub and Rim materials, and the `Environment` / `BikeFrame` assertions at the marker in `scene-dressing`.

## 2026-10-24: Pass 7b, richer scene (scene half; plan `docs/PASSES_7_TO_10_PLAN.md`)

Branch `Sujeeth-AR-SPECS-WORK`. Built by the CLAD Specs Experience Builder through the Lens Studio MCP, on top of 7a (7e0b75f). Scope: text-to-3D props, the code-built rear triangle and floor mat, layout, lights and shadows, metal materials, and the `scene-dressing` 7b assertions. Not committed.

What was built:

- **Text-to-3D props** (SPECS text-to-3D through `/build-mesh`, balanced quality, all four succeeded on the first job, each about 30 to 60 s): `Assets/GeneratedMeshes/Workbench.glb` (3,979 tris), `Pegboard.glb` (3,877), `Toolbox.glb` (3,949), `Saddle.glb` (3,767). All were already under 20k triangles, so `SimplifyMeshTool` was not needed. Sizes were baked into the GLBs with `normalize_glb.js` (no node scaling): Workbench 150 x 90.9 x 79.8 cm, grounded; Pegboard 120 x 100 x 24 cm (per-axis, a 13 percent stretch from the raw 100 x 94 x 29); Toolbox 45 x 37.7 x 28.9 cm, grounded; Saddle 21.5 x 27.5 x 28 cm, grounded (min-Y at the seatpost foot). Each instance (localScale 100) sits under a unit-scale wrapper named for the prop.
- **`RearTriangle.ts`** on new `Stand/BikeFrame` (inputs `hub`, `material`; geometry inputs `chainStayCm` 42, `bbDropCm` 7, `seatTubeCm` 50, `seatAngleDeg` 73, `stayOffsetCm` 6). Built once in `onAwake` from the hub's position, read into BikeFrame's local space: BB 41.4 cm forward (-X) and 7 cm below the hub; seat cluster 50 cm up the seat tube, leaning back toward the wheel; two chain stays and two seat stays from dropouts at hub ± 6 cm Z; seat tube; BB shell; two dropout plates; a skewer through the hub. One mesh, 336 tris, `FrameMat` pale teal (0.45, 0.8, 0.8). `dropoutWorldPos()` is the midpoint of the dropouts, so it equals the hub by construction; `seatTubeWorldPos(t)` is also public. The seat tube clears the hub axis by 37.6 cm (tire outer radius about 35.3 cm).
- **`FloorMat.ts`** on `Environment/FloorMat` at (0, -149.5, -90): 180 x 120 cm rounded rectangle (corner 10 cm), 7 cm pale blue border band and a 0.6 cm skirt (`MatBorderMat` 0.62, 0.78, 0.96) around a light grey field (`MatFieldMat` 0.82). Two runtime children (`FloorMatField`, `FloorMatBorder`), 180 tris, shadow receivers.
- **`MeshKit.ts`**: small shared MeshBuilder helper (tube, disc, box, winding fixed from an outward hint) used by both scripts.
- **Layout.** New root `Environment` (`FloorMat`, `Workbench` at (0, -150, -168) so its top is at y -59.1, `Pegboard` at (0, -5, -215) spanning y -55 to 45 with its front at z -203 just behind the bench's back edge at z -208, `Toolbox` on the floor at (70, -150, -120), yaw -20). `RepairManager` gained `@input @allowUndefined environment` and enables it with `showWheel`. `Stand/BikeFrame/Saddle` sits on the seat tube top at local (-27.95, 162, 20), tilted -17 degrees about Z to follow the seat tube; `SaddleModel` yaw -90 so the nose points forward (-X). `StandClamp` moved to grip the seat tube 40 percent up from the BB (local (-35.56, 137.13, 10.5), scale 5 x 5 x 23, reaching from the post at z 0 to the seat tube at z 20); `StandPost` and `StandBase` moved under it (post local x -35.56, y 4 to 135). Names unchanged. Nothing new sits between the user and the wheel; the only geometry in front of the wheel plane is the near-side chain stay and seat stay, 6 cm out, as on a real bike.
- **Lighting.** `Lighting/Light` renamed `KeyLight`: directional, rotation (-68, -30, 0), shadows on (ShadowMap, density 0.35, blur 3, 1024 map). New `Lighting/FillLight`: directional, rotation (-20, 30, 0), intensity 0.4, no shadows. `Ambient Light` is now type EnvMap with the Pasadena diffuse and specular maps (`Assets/BenchCoach/Materials/Pasadena.hdr`), exposure 2. Casters: `Hub`, `Spoke_0..15`, `StandBase`, `StandPost`, `StandClamp`, the rear triangle, the workbench, toolbox and saddle visuals, and the `TorusArc` rim and beads through a new `TorusArc.castShadows` input (true on `Rim` and `Bead_0..7`). Receiver: the floor mat only.
- **Materials.** New `HubMat` (base 0.95, metallic 0.45, roughness 0.3) on `Hub`. `RimMat` metallic 0.9, roughness 0.35. `TireMat` unchanged (0.5 grey).
- **LEAF.** `scene-dressing` 7b block: after `reset`, step 0 has `Environment` and `BikeFrame` not enabled in hierarchy; after `BtnFoundIt`, step 1 has both enabled; `RearTriangle.dropoutWorldPos()` is within 1 cm of `Hub` (measured 0.00 cm). `BikeFrame` hides with `Stand`, so the test reads `isEnabledInHierarchy`, not its own flag.

| Scenario | Result (serial, preview, camera reset before the run and again before `peel-and-pull`) |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED |
| `peel-and-pull` | PASSED (lever B 0.00 cm from socket B; mid-pull 7.8 cm past the rim: TubeSeg_4 moved 23.20 cm, TubeSeg_0 0.00 cm) |
| `inspect-done` | PASSED (Back from 1..7 worst diff 0.000 cm) |
| `step-ticks` | PASSED (closest ticks steps 1/3, 7.15 cm) |
| `scene-dressing` | PASSED (dropout to hub 0.00 cm) |
| `jump-to-step` | PASSED |

After the final recompile, all 372 `@input`s on BenchCoach scripts in the scene snapshot are non-null.

Cost: about 16,100 new triangles (props 15,572, frame 336, mat 180) and 7 new draw calls (4 props, 1 frame, 2 mat), plus a shadow-map pass that redraws the casters (about 33 draws). Frame time was not profiled; the refresh logs show no Lens errors or performance warnings (only the editor's `adb` device-probe warnings, with no device attached).

Deviations and why:

- **Key light 68 degrees down, not 35.** At 35 degrees the wheel, 125 cm above the floor, throws its shadow about 180 cm back and to the right, past the mat, so there was nothing on the receiver. At 58 degrees it slid off the mat's right edge; at 68 it falls on the mat as a soft light-grey shape. Direction (from the front left) is unchanged.
- **Hub metallic 0.45, not fully metallic.** At 0.9 (and 0.6) the hub cylinder rendered dark grey in the SPECS preview even with the env map; 0.45 with a 0.95 base reads as light metal. The rim keeps 0.9 / 0.35 and reads as mid-grey metal with a highlight.
- **The specular env map needs an EnvMap-type light.** With the template's `Ambient` type the specular texture did nothing and the metal stayed near-black, so the ambient light was switched to EnvMap with both Pasadena maps, exposure 2.
- **Pegboard tool handles were black.** One regeneration with an explicit light-colors prompt came back as crumpled, faceted geometry, so the first pegboard was kept and lightened instead: `emissiveFactor` 0.45 was baked into the GLB's glTF JSON, because edits to materials inside an imported GLB are not written to disk. Handles now read mid-grey and pale orange. The panel came with two short feet, which stand on the bench top.
- **Pegboard placed at z -215 (not -200) and the bench at z -168 (not -175),** so the 80 cm deep bench and the 24 cm deep panel do not intersect.
- No Blender on this machine, so `/build-mesh` could not render previews; completeness and facing were checked from runtime captures in Lens Studio instead (all four props whole; saddle yaw fixed from a top capture). The GLBs are not stamped canonical.

Findings:

- **`asset-graphql duplicateAsset` renamed the source asset instead of copying it** (it returned the source id, and `RimMat` / `StandMat` vanished from the list). Both were renamed back straight away; ids, scene references and file contents are unchanged (git shows no diff from that step). New materials were made as disk copies with fresh internal UUIDs instead.
- **LEAF `run_leaf_scenario` overrides must be strings** (`{"step": "1"}`); a number fails with `Override "step" must be a string`.
- **VirtualScene enum fields take numbers**: `lightType` 1 = Directional, 4 = EnvMap; `meshShadowMode` 1 = Caster; `shadowType` 2 = ShadowMap. Strings are rejected.
- **Shadows need `shadowType` set on the light as well as `castsShadows`.**
- **`MovePreviewCamera` and `SimplifyMeshTool` are reached through `IChatToolRegistry.execute()`**, like the LEAF tools.
- Runtime capture ids are not editor ids; scene-mode captures (center and distance) work for close-ups.

Left over: the tire still reads as dark grey under the new lighting (unchanged 0.5 `TireMat`, as the plan asks); a hands-on mouse walk of steps 2 to 7 with the new frame in view was not done (the near chain stay crosses in front of Bead_6's 9 o'clock region; it has no collider, so pinch rays are not blocked, but it is visually in front).

## 2026-10-24: Pass 7b fix round, brightness on the additive display

Review of the default-camera step 1 screenshot: the tire, rim, hub, seatpost and pegboard tool handles read near-black. Measured on screenshot pixels (sRGB luminance; the preview's see-through background is about 0.40, so anything near 0.40 is effectively invisible): tire 0.41 to 0.50, rim 0.40 to 0.48, darkest 2 percent of the pegboard tool area 0.43 to 0.53. Changes:

- **`Ambient Light` back to the template's flat Ambient type** (intensity 1). The EnvMap diffuse at exposure 2 lit the wheel less than the flat ambient did. The Pasadena maps moved to a new `Lighting/EnvLight` (EnvMap type, exposure 1), so metal still gets reflections.
- **`TireMat` 0.50 to 0.76 grey** (the plan's "mid-grey" was a material value; on screen it rendered at background level under the new lights).
- **`RimMat` metallic 0.9 to 0.35, base 0.85 to 0.95; `HubMat` metallic 0.45 to 0.35.**
- **`FillLight` intensity 0.4 to 0.6.**
- **Emissive baked into the GLB JSON:** `Pegboard.glb` 0.45 to 0.65, `Saddle.glb` 0 to 0.4 (lifts the black seatpost).

After (same camera and step): tire 0.54 to 0.74, rim 0.51 to 0.69 with highlights near 1.0, seatpost 0.82 to 0.87, darkest 2 percent of the pegboard tools 0.56 to 0.65. The wheel's shadow on the mat measures about 0.63 against 0.71 for open mat. Stand, spokes, frame, levers, ticks and the marker ring are unchanged or lighter. The ControlBar and ToolTray back plates are unlit UIKit panels and are not affected by lighting. A Lens Studio finding: material and light edits in the editor reset the running Lens, so every screenshot was retaken after `jump-to-step`. All 8 LEAF scenarios pass again, run serially from the default camera pose (camera reset before `peel-and-pull`).

## 2026-10-24: Pass 9, finish the repair (steps 8 to 11; plan `docs/PASSES_7_TO_10_PLAN.md`)

Branch `Sujeeth-AR-SPECS-WORK`, on top of 585e773. Built by the CLAD Specs Experience Builder through the Lens Studio MCP. 9a and 9b were written together and tested as one pass (the 9a scenarios were run on their own first). Not committed.

What was built:

- **The seam.** `StepDefinitions.ts` has the `StepModule` interface, rows 8 to 11 (`Fit the new tube` / `Seat the bead` / `Inflate` / `Done`, labels as in the plan), new fields `showFinishCard`, `showNewTube`, `module`, a `"module"` marker anchor, `SEAT_BEADS` [0..3], `HALFWAY_STEP` 7 and a one-entry `FLAT_CAUSES` (thorn: label and prevention tip; pass 8 adds the other causes). `RepairManager.ts` gained `@input refit` / `finishCard` / `stats` (all `@allowUndefined`), `causeId` ("thorn"), and delegates through the `default:` branches of `completeStep` / `undoStep`, one `refit.apply(step, false, instant)` call in `applyStep` (every step), and one branch in `markerAnchorFor` (live module rings). It advances on `refit.onStepComplete`, moves the ring on `refit.onSubStep`, toggles the Finish card and pushes time and stats into it. The Done cue now plays on entering the halfway card (step 7, `showDoneCard`), the new Finish cue on `LAST_STEP`. Lever A only snaps up to step 3 now (it is back in the tray from step 8). Bead-offset maths moved to the shared `WheelMath.ts`.
- **`RefitSteps.ts`** (the `StepModule`, on `BenchCoach`). Step 8 entry tweens both levers home (instant on Back, reset and `jumpToStep`), takes the old tube away (`TubePull.removeForRefit()`: segments off, tube-end and valve visuals hidden) and shows `NewTube`, which glows. `TubeFit.onFitted` hides the coil and calls `TubePull.refit()`; the refit finishing completes step 8. Step 9 seats Bead_0..3 on `WheelTargets.onBeadPinched` (offset back to 0; the rest keep glowing; ring on the next one). Step 10 counts hold time from the valve's trigger start / end (`WheelTargets.onValveDown` / `onValveUp`), scales `Tire` and `Tube` from 0.96 to 1.0 over `inflateHoldSec` (2.5 s) with the pump loop, and keeps partial progress on an early release. `undo(8)` puts the levers back on the wheel (`placeInstant` plus `RimDrag.completeInstant` at 5 o'clock) and the old tube hanging out (`TubePull.unrefit()`), so Back from 8 equals `jumpToStep(7)`.
- **`TubePull.refit()`** brings the same eight `TubeSeg_i` back: valve home first, then each segment is re-enabled at home and slides 4 cm in from the front, in the order 0, 7, 1, 6, 2, 5, 3, 4 (from the valve round both ways), 0.12 s apart. `refitInstant()` and `unrefit()` are the Next and Back versions; `restore()` also re-shows everything. No new ring objects.
- **`TubeFit.ts`** on new `ToolTray/NewTube/NewTubeEnd` (the `LeverPlacement` pattern): 3 x 4 x 3 cm box collider, Interactable, Manipulation with rotate, scale and Z stretch off, 5 cm snap to new `Wheel/ValveSocket` (wheel-local (0, 27, 0), the valve's home), `onFitted` / `onRejected` (nope cue), `fitInstant()`, `returnHome()`. Armed on step 8 only. Arming and disarming never touch its Interactable.
- **New tube in the tray.** `NewTube` is two `TorusArc` loops in `TubeMat` (2.0 and 1.65 cm radius, offset, so it reads as a coil) at tray-local (-1, -6.4, 1.2), under the levers, with a brass `NewTubeStem` (the valve cylinder mesh and `ValveMat`) on `NewTubeEnd`. To make room, the tray panel grew from 20 x 10 to 20 x 14 cm and moved 2 cm down (`ToolTrayPanel` y -2), so the levers' homes did not move; the header now reads "Tools".
- **`RunStats.ts`** (on `BenchCoach`): `leverMisses` (levers' `onRejected`), `hintsUsed` (each Replay that acts; pass 8's idle hints will add to it), `mistakes` (a new-tube end released away from the valve), `reset()` on reset, `snapshot()`.
- **`BenchCoachFinishCardUI.ts`** on new `BenchCoach/FinishCard`, billboarded at (0, 21.5, -88), 26 x 16 cm: "Flat fixed.", `FinishTime`, `FinishStats` ("Lever misses 0 · Hints 0 · Cause: thorn"), `FinishTip` ("Next time: run a hand round inside the tire before fitting a tube."), `BtnRestart` ("Start over").
- **Halfway card.** `BtnContinue` ("Fit the new tube", arrow_forward icon, UIKit SnapOS2 `Primary` style through a new optional `style` argument on `UIHelpers.addLabelButton`) next to `BtnTryAgain`, now labeled "Start over" (object name kept). `UIBindings` wires Continue to `next()` and Restart to `reset()`.
- **Audio.** `Assets/GeneratedSFX/Pump.wav` (`/build-sfx`, hand-built: filtered-noise downstroke with a soft piston thump and a lighter upstroke, a 1.2 s loop that starts and ends near silence, peak -9 dBFS) and `Finish.wav` (`/build-music`: marimba plus quiet bell, C-E-G-C over 0.6 s with a music-box sparkle and a soft pad chord under the top note, small room, 2.4 s). New `Audio/Pump` and `Audio/Finish`; `BenchCoachAudio.startPumpAt()` loops it, `stopPump()`, `playFinishAt()`, counters `pumpPlays`, `finishPlays`, `pumping`. All algorithmic and license-clean.
- **`WheelTargets`** now builds pinch targets on all eight beads (pass 8 needs them too); `setActive(valve, beads)` takes `true` (the loosen beads), `false`, or a list. It emits `onValveDown` / `onValveUp`. A valve target switched off while still held stays on until the release, because the inflate finishes, and the step changes, while the hand is still pinching.
- **`StepTicks`** pool 9 (scene value). Tick spots for the new steps: 8 at the top of the tire (5 cm outside the deflate tick on the valve), 9 at Bead_1 (67.5 degrees), 10 at 330 degrees.
- **LEAF.** `BenchCoachLeafInteractor.holdOn(name, ms)` (hover, select, wait, release). New `refit-tube` (`RefitTubeScenario.ts`) and `seat-inflate` (`SeatInflateScenario.ts`). `step-ticks` checks 0..9 ticks on steps 0..11 and that the nine ticks on step 11 do not stack; `inspect-done` runs its Back loop and its Replay loop up to `LAST_STEP`. `jump-to-step` takes `fit` (step 8: run the live fit but stay on 8) and `inflate` (step 10: hold part-inflated), and prints the screen position of the valve, Found it, NewTubeEnd and ValveSocket for injected mouse checks.

| Scenario | Result (serial, preview, camera reset before each run, after the save) |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED |
| `peel-and-pull` | PASSED (mid-pull 7.8 cm past the rim: TubeSeg_4 moved 23.20 cm, TubeSeg_0 0.00 cm) |
| `inspect-done` | PASSED (Back from 1..11 worst diff 0.000 cm; Replay acted on all 11 steps) |
| `step-ticks` | PASSED (9 ticks on step 11, closest pair steps 1 and 8, 6.71 cm) |
| `scene-dressing` | PASSED |
| `refit-tube` (new) | PASSED (Continue enters 8 with both levers 0.00 cm from home; ring 1.50 cm from ValveSocket; a miss returns the end 0.00 cm from the coil; the fit brings all 8 TubeSeg_i back, worst 0.000 cm from home, valve 0.000 cm; Back from 9 restores step 8) |
| `seat-inflate` (new) | PASSED (Bead_0..3 seat to 0.000 cm; `holdOn("Valve", 3000)` takes the tire 0.960 to 1.000 with one pump play; Finish card "Time 0:05" and "Lever misses 0 · Hints 0 · Cause: thorn"; Finish cue once, no second Done cue; Restart to step 0) |
| `jump-to-step` | PASSED |

Mouse check of the hold (injected touches): a `tap` on the valve gives hover only, and a press straight away is ignored (the pass-0 rule: a press grabs only after a hover frame). Hover with a tap, wait about 0.6 s, `touch start`, hold, `touch end` works. A 3 s hold pumped from 0 to 100 percent, entered step 11 while still held and released cleanly; a 0.6 s hold stopped at 41 percent and stayed on step 10. The hand simulation still reports the valve "obstructed" by its own `ValveHit` box (pass 5 finding).

Screenshots reviewed from the default pose: step 7 (Continue and Start over), step 8 (old tube and valve gone, ring on the valve hole; tray capture with both levers home and the coil under them), step 8 after the fit (valve back, tan tube showing under the lifted beads), step 9 (Bead_0..3 glowing, ring on Bead_0), step 10 half-inflated (valve glowing in the ring), step 11 (whole Finish card inside the view, above the tire). Measured on screenshot pixels against the 0.40 background: highlighted beads 0.68, valve and new stem 0.60, refitted tube 0.58, Finish card text 0.63 to 0.71, Continue fill 0.45 (other UIKit plates sit at 0.40 as before; their white text carries them). After the final recompile every BenchCoach script `@input` in the scene is non-null; `RunAndCollectLogsTool` shows no Lens errors.

Deviations and why:

- **`StepModule.apply` has a third, optional `instant` argument.** Step 8's entry tweens the levers home, and a 0.4 s tween would make `inspect-done`'s Back snapshot depend on timing. The manager passes `instant` on Back, reset and `jumpToStep`, so only a live Continue / Next tweens.
- **The step-8 tick is not on the valve.** The deflate tick already sits there; step 8's sits at the top of the tire, step 10's at 330 degrees, so the nine ticks stay at least 6.7 cm apart.
- **Finish card at y 21.5, not the Done card's 25.** At 25 the title and time were above the top of the SPECS view from the default pose. The levers are in the tray on step 11, so nothing it could cross. The halfway card (unchanged at y 25) has the same issue: its "Tube out, cause found" line and time are just above the view from the default pose; the buttons are in view. Lowering it would bring back the lever-A crossing fixed in the review round, so it is left for a design decision.
- **Hints = Replay presses** until pass 8 adds idle hints; **mistakes = new-tube misses** until pass 8's `CoachFeedback`.
- **`step-ticks` and `inspect-done` moved to new files** (`TickMarksScenario.ts`, `InspectFinishScenario.ts`; scenario ids unchanged in `LeafIndex`). See the next finding.
- **`BodyFollow` is unchanged.** The plan wanted the tray to hold still while the new tube end is grabbed, as it does for the levers. The edit could not reach the runtime (next finding), so it was reverted; the tray only moves when the user walks 20 cm or turns 35 degrees, so it is a small risk.
- Beads 4 and 6 keep their 0.5 cm loosen offset after the inflate (invisible at this size; one less state to undo).

Findings:

- **The project Cache is stale for five scripts, and edits to them never reach the runtime.** Since this Lens Studio session started (15:31), every import of `BodyFollow.ts`, `StepTicks.ts`, `ThornHotspot.ts`, `StepTicksScenario.ts` and `InspectDoneScenario.ts` fails with "contains a duplicate of the loaded id ... from Assets/...", and at startup the two tests failed with "Cannot copy ... Cache/.../Data/<name>.ts: File exists". The file watcher treats each save as a new asset and never registers a deletion, so the old compiled code keeps running: `step-ticks` ran its old loop to step 7 after the edit. The two tests were recreated under new names; `StepTicks.ts` only changed a default that the scene overrides (9); `BodyFollow.ts` was reverted. Fix outside a session: close Lens Studio, delete `Cache/`, reopen. Until then, test edits to those five files with a log line first.
- **Injected mouse input needs hover, then a pause, then the press,** as above; a `tap` on a large UIKit button works on its own.
- **VirtualScene could not wire a new `@input` on `BodyFollow`** ("Script input 'tubeFit' not found ... recompile"), because of the stale import above; recompiling does not help.
- The music and SFX generator scripts (`tempAssetGen/`) were removed after rendering; the recipes are described above.

Left over: delete the project `Cache/` with Lens Studio closed, then re-apply the `BodyFollow` hold-still for the tube handle (discover `TubeFit` under the tray, as drafted in this pass) and re-run `step-ticks` / `inspect-done` from either file name; decide whether to lower the halfway card; a hands-on hand-tracking walk of steps 8 to 10 (the hand simulation cannot pinch the valve).
