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

## 2026-10-24: Pass 8, learning layer, plus pass 9 follow-ups F2 and F3 (plan `docs/PASSES_7_TO_10_PLAN.md`)

Branch `Sujeeth-AR-SPECS-WORK`, on top of 9d214f6, after the Lens Studio cache was cleared (F1). Built by the CLAD Specs Experience Builder through the Lens Studio MCP, in two halves (8a, then 8b), each followed by a full scenario run. Not committed.

The cache problem is gone: no "duplicate of the loaded id" line all session, and edits to `BodyFollow.ts` and `ThornHotspot.ts` reached the runtime (VirtualScene could wire the new `BodyFollow.tubeFit` input, and the new cause shapes render).

What was built:

- **Data (`StepDefinitions.ts`).** Every step 0..11 has a `hint` (one short line for the label) and `railDot`. Rail dots are steps 1..6 and 8..10 (nine dots); the cards (0 Start, 7 halfway, 11 Finish) have none. New tables: `FLAT_CAUSES` (thorn 120 degrees, glass 240, snakebite 300; each with label, found label, prevention tip, What's this? fact, reveal shape), `FLAT_CAUSE_IDS`, `MISTAKES` (seven codes with one-line reasons), `PART_FACTS` (Rim, Hub, Spoke, Tire, Tube, Valve, LeverA, LeverB, Stand, Cause, Frame: target object, title, fact, offset and box size), `railSteps()`.
- **`ProgressRail.ts`** on new `ControlBar/ProgressRail` (body-follows with the bar): nine 0.8 cm dots in a strip under the buttons. Done dots use `MarkerMat`, the current one pulses (1.0 to 1.5 times), dots ahead use a runtime clone at 50 percent brightness. `setStep`, `dotCount`, `litCount`, `currentIndex`. `BenchCoachControlBarUI` gained `railStripCm` (1.6): the panel grows by the strip and the button row moves up inside it. The bar root moved 0.8 cm down its own tilted Y (to (.., -35.63, -44.51)) so its top edge, the one that matters for the wheel (pass 5), stays where it was.
- **`BtnWhatsThis`** (icon `info`, imported with `IconSelector` to `Assets/Icons/info.png`) at the left end of the bar, a UIKit toggle (`setIsToggleable(true)`), so its latched look shows while the mode is on. To keep Back / Next / Replay where pass 5 put them, the bar root also moved 3.5 cm left (x -3.5); the right end stays clear of the tool tray.
- **`IdleHint.ts`** on `BenchCoach`: `idleSec` 12, `boostSec` 4, `touch()`, `suspended`, `showing`, `hintCount`, `lastHintStep`, `onHint`. Fires once per quiet spell on steps with a visible label: the step's `hint` on the label, `StepMarker.pulseBoost(4)` (new: 2.5 times the swing, twice the rate), the chime at the marker. A step or sub-step change, any control-bar press (`UIBindings` calls `touch()`) or a mistake starts a new spell; a held or tweening lever, new tube end or tube end counts as activity, so a slow LEAF drag never looks idle. Suspended while What's this? pauses the step. `RepairManager.refreshLabel()` (new) puts the step label back.
- **`CoachFeedback.ts`** on `BenchCoach`: `mistake(code, worldPos)` plays nope there, puts `MISTAKES[code]` on the label for `showSec` (2.5), then calls the restore callback the manager installs; `mistakeCount`, `lastCode`, `showing`, `onMistake`, `cancel()` on every step change. Callers: step 1 bead pinch (`beadBeforeDeflate`; `WheelTargets` now takes all eight beads plus the valve on step 1), step 2 valve pinch (`valveAlreadyDeflated`; the valve stays live on step 2), lever B released on step 3 (`leverBBeforeA`), a lever dropped away from its socket on step 3 or 4 (`leverTooFar`), the tube end pinched on step 4 (`tubeBeforePeel`; new `TubePull.setEarlyPinch` / `onEarlyPinch`: pinch target on, no grab), the new tube end released away from the valve hole on step 8 (`tubeFitMiss`, from `RefitSteps`), and the valve pinched on step 9 before the beads are seated (`inflateBeforeSeat`; the valve is live on step 9). Other lever rejections still just play nope.
- **Flat causes.** `ThornHotspot.setCause(id)` moves the hotspot round the tire (radius 34.2 cm, local +Y outward) and picks the reveal: the existing spike (thorn), a pale shard of two thin tilted boxes (glass, a runtime copy of `MarkerMat` tinted (0.85, 0.97, 1)), or two warm dots side by side (snakebite, tinted (1, 0.8, 0.5)); `causeId`, `currentAngleDeg`. `RepairManager.foundIt()` picks a random cause unless `forceCause` is set; `reset()` and so `jumpToStep()` use `forceCause` or the default `causeId` ("thorn"), so every existing scenario still sees the thorn at 120 degrees. `getCause()`, `setCause()`. The found label comes from the cause; `markerAnchorFor` uses the hotspot's angle.
- **Finish card** shows the cause and its tip: now 30 x 14 cm at (0, 17, -88), title and time on one row, `FinishCause` ("Cause: glass shard") and `FinishStats` ("Lever misses 0 · Mistakes 0 · Hints 0") on the next, then the tip and `BtnRestart`.
- **`PartInfo.ts`** ("What's this?") on `BenchCoach`: `setActive(on)`, `active`, `wanted`, `lastPart`, `lastText`, `onActiveChanged`. Builds one `InfoHit_<id>` box collider and Interactable per fact under a new runtime `BenchCoach/InfoHits` (not under the parts, so no part's own Interactable claims the collider). Each box follows its part every frame and is a little larger than any collider it encloses (lever 13 x 3 x 2 against 12 x 2 x 1, valve 6 x 8 x 6 against 5 x 7 x 5, tube end 8 against 7), so it takes the ray first. Boxes for hidden parts are off; the cause box exists only once the cause is found and its fact comes from the cause. A pinch puts "Title: fact" on the label 7 cm above the part. Switching waits until no lever, new tube end or tube end is held or tweening. A reset (new `RepairManager.onReset`) turns the mode off.
- **`RepairManager.setInteractionsPaused(on)`** re-runs `applyStep` with every arm gated: valve and bead targets off, lever snapping off, tube pull and early pinch off, glint disarmed, and `refit.apply(step, paused)` (new tube, seat beads, inflate valve off).
- **`RunStats`**: hints now come from `IdleHint.onHint` and mistakes from `CoachFeedback.onMistake` (wired in `UIBindings`, which keeps `RunStats` free of imports that would loop back through `RepairManager`); lever codes are not counted as mistakes because they are already lever misses. Replay no longer counts as a hint; the new-tube miss is now the `tubeFitMiss` mistake.
- **F2.** `BodyFollow` has `@input tubeFit` and holds still while the new tube end is grabbed or tweening; wired on both the tool tray and the control bar.
- **F3.** The halfway card is 13 cm tall (gap 0.3, padding 0.5) at (-6.5, 17, -88): title and time inside the default view, right edge clear of lever A's tip, bottom clear of the valve.
- **LEAF.** New `whats-this`, `mistakes`, `flat-causes`, `progress-idle`. `jump-to-step` takes `cause`, `find` (pinch the hotspot and hold the reveal 30 s), `part` (What's this? and pinch `InfoHit_<part>`), `mistake` (show that reason 30 s) and `idle` for screenshots.

| Scenario | Result (serial, preview, camera reset before each run, final code) |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED (reject back to tray 0.00 cm; snap 0.00 cm) |
| `peel-and-pull` | PASSED (mid-pull 7.8 cm past the rim: TubeSeg_4 moved 23.20 cm, TubeSeg_0 0.00 cm) |
| `inspect-done` | PASSED (Back from 1..11 worst diff 0.000 cm) |
| `step-ticks` | PASSED (closest pair steps 1/3, 7.15 cm; on step 11 steps 1/8, 6.71 cm) |
| `scene-dressing` | PASSED |
| `refit-tube` | PASSED |
| `seat-inflate` | PASSED |
| `whats-this` (new) | PASSED (valve fact on the label 8.1 cm from the valve; the switch waits while lever A is held; glass cause fact on the halfway card) |
| `mistakes` (new) | PASSED (all seven codes: reason, nope, step unchanged; reason gone after 2.5 s; lever codes count as lever misses only) |
| `flat-causes` (new) | PASSED (hotspot measured at 120.0, 240.0, 300.0 degrees; shapes, found labels, ring on the cause, Finish card cause and tip) |
| `progress-idle` (new) | PASSED (9 dots; 3 lit and the fourth pulsing on step 4; one hint after a quiet second, shown once; Next clears it) |
| `jump-to-step` | PASSED |

Screenshots reviewed from the default pose (or the camera aimed at a cause): What's this? with "Valve: unscrew the tip, then press." above the valve and the toggle latched on the bar; a mistake reason on the label on step 1; thorn, glass and snakebite revealed with their labels in front of the hanging tube; the rail on step 4 (pixels: done dots 0.82, dim dots 0.47 on a 0.27 plate); the idle hint "Pinch each glowing bead." on step 2; the halfway card fully in view; the Finish card with "Cause: glass shard" and its tip fully in view above the tire. Glass shard pixels 0.96. After the final recompile all 491 BenchCoach script inputs in the scene are non-null; `RunAndCollectLogsTool` shows no Lens errors.

Deviations and why:

- **Glass at 240 degrees, not 200.** At 200 the found label hangs outward below the wheel, behind the body-locked control bar (pass 5 already notes the bar covers the bottom of the tire from the start pose). 240 mirrors the thorn and is 20 degrees clear of the near chain stay.
- **The inspect-step label sits 16 cm in front of the wheel plane, not 4.** The pulled tube hangs 10 cm toward the user through steps 6 and 7 and cut through the found label (true for the thorn since pass 4 as well).
- **Finish card 30 x 14 cm with two-up rows.** Adding the cause row made the old 26 cm wide column too tall: the title and time left the top of the view, and lowering it covered the tire.
- **Halfway card moved 6.5 cm left** as well as down: no height between the top of the view and lever A's tip fits the card centered.
- **Rail dots on 1..6 and 8..10.** The plan left `railDot` open; the cards are milestones, not work.
- **Two extra mistake codes** for the new steps (`tubeFitMiss`, `inflateBeforeSeat`); the plan allowed it. `RunStats.mistakes` leaves the two lever codes out so a lever drop is not counted twice.
- **`StepModule` and `IdleHint.suspended` are unchanged in shape**; `suspended` is there for pass 10's director.

Findings:

- **Lever misses were counted three times per drop.** SIK fires `onManipulationEnd` three times per release (pass 3 finding), and `LeverPlacement.onReleased` ran its reject path each time, so `onRejected` (nope, `leverMisses`) fired three times. It now returns while the snap or return tween is running, so a drop counts once. `mistakes` caught it (expected 3, got 5).
- **A long batch of scenarios in one `ExecuteEditorCode` call outlives the MCP transport** (the call times out after about two minutes), but the editor keeps running it; starting another run meanwhile cancels the one in flight ("Scenario run cancelled"). Run one scenario per call.
- **An OAuth token refresh in the editor reset the running Lens** mid-scenario (`flat-causes` stopped after the glass case; it passed on the rerun). Another reason to read results from the log.
- `UIKit` toggles: `setIsToggleable(true)` after `onInitialized` works (with a one-line warning in the log); `onValueChange` fires for presses and for `isOn = ...`, so `UIBindings` ignores a change that matches the mode's requested state.

Left over: the bar is now 29.5 cm wide; with the head pitched down 32 degrees from the start pose the What's this? button is at the left edge of the view (a hands-on check should decide whether to shrink the gaps). The idle-hint marker boost is checked by counters, not on a screenshot. A hands-on hand-tracking walk of What's this? and the mistake cases was not done (LEAF `trigger` skips the ray, so ray priority of the info boxes over the levers is reasoned from their sizes, not tested).

## 2026-10-24: Pass 10, watch mode, F4 control bar width, final LEAF sweep (plan `docs/PASSES_7_TO_10_PLAN.md`, `docs/INTEGRATION_PLAN.md` row 1)

Branch `Sujeeth-AR-SPECS-WORK`, on top of 99818e8. Built by the CLAD Specs Experience Builder through the Lens Studio MCP. No voice (dropped). Not committed.

What was built:

- **`WatchPlan.ts`** (data): `WATCH_BEATS`, one `{step, waitSec, action, actSec}` per step 0..11. Actions: `valve` (1), `beads` (2), `hookA` (3), `sweep` (4), `pull` (5), `find` (6), `next` (7, the halfway card's Continue), `demo` (8, 9, 10), `none` (0, 11). Reading pause 3.5 s per step (4.5 s on the halfway card); timing constants for the lever flight (0.8 s), the sweep (4 s), the pull (1.6 s) and the bead gap (0.8 s).
- **`RepairDirector.ts`** on `BenchCoach`: `play()`, `stop()`, `playing`, `beatIndex`, `onFinished`, plus `fallbacks`, `lastStopReason`, `lastPlayTime` for tests and `waitScale` (Inspector). Per frame: if the step changed, start that step's beat; after `waitSec`, act through public controls only; the step's own events advance `RepairManager`. If a step does not advance within `actSec + 8 s` it calls `next()` and counts a fallback (0 in every run). It stops on `stop()`, on a hand grab of lever A, lever B, the tube end or the new tube end (polled each frame), and on `LAST_STEP` (`onFinished`). While playing, `IdleHint.suspended` and the new `RunStats.suspended` are set, and What's this? is turned off.
- **Small public adds:** `LeverPlacement.placeInstant(emit)` and `playPlace(sec)` (the snap tween from wherever the lever is, firing `onPlaced` on arrival); `RimDrag.playSweep(sec)` / `stopSweep()` / `sweeping` (sets the pose each LateUpdate before the normal angle check, so `onSegmentPassed` and `onPeelComplete` fire as for a hand drag; it starts from the lever's current angle); `TubePull.playPull(sec)` / `demoPulling` (draws the tube end out along wheel -Y, driving the segment-by-segment pull, then runs the usual staggered finish and `onPullComplete`); `ThornHotspot.findInstant()`; `TubeFit.playFit(sec)`; `WheelTargets.pinchValve()` / `pinchBead(i)` (fire the existing events without a hand); `RefitSteps.demo(step)` (8: `playFit`, then the normal `onFitted`, refit and `onStepComplete`; 9: seats the lifted beads one every 0.7 s through its own bead handler; 10: holds the valve until full) and `stopDemo()`; `RunStats.suspended`.
- **`BtnWatch`** ("Watch", icon `play_arrow` imported with `IconSelector` to `Assets/Icons/play_arrow.png`) next to `BtnFoundIt` on the start card, in a row the same height as the old single button (Found it 12 x 6 cm, Watch 8.6 x 6 cm). `UIBindings` has `@input director`: every button press calls `director.stop()` first (any control-bar press, Back, What's this?, Continue, Start over, Restart); Watch presses Found it, then `director.play()`.
- **F4.** `BenchCoachControlBarUI` gap 2 to 0.7 cm and padding 1.25 to 1 cm (literal defaults and scene values), so the bar is 25.1 cm wide instead of 29.5; button sizes unchanged (Next still 6 cm and brightest). `ControlBar` moved from (-3.5, -35.63, -44.51) to (-2.35, -35.433, -44.664): centered between the view's left edge and the tray at 32 degrees down, and 0.25 cm up its own tilted Y so the top edge stays where pass 5 put it (the panel is 0.5 cm shorter).
- **LEAF.** New `watch-mode` (`WatchModeScenario.ts`). `jump-to-step` gained `watch` (1 = start watch mode: on step 0 it taps `BtnWatch`, else `director.play()` from that step) and `until` (`sweep`, `fit`, `finish`: waits for that beat, prints the moving part at two moments 0.8 s apart, returns while it plays), for screenshots and video takes.

Flat cause in watch mode: whatever `foundIt()` picked at random (snakebite and glass in two of the runs, thorn after a jump); nothing is forced.

| Scenario | Result (serial, preview, camera reset before each run, final code, after the save) |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED |
| `peel-and-pull` | PASSED (lever B 0.00 cm from socket B; mid-pull 7.8 cm past the rim: TubeSeg_4 moved 23.20 cm, TubeSeg_0 0.00 cm) |
| `inspect-done` | PASSED (Back from 1..11 worst diff 0.000 cm) |
| `step-ticks` | PASSED (closest pair steps 1/3, 7.15 cm; on step 11 steps 1/8, 6.71 cm) |
| `scene-dressing` | PASSED |
| `refit-tube` | PASSED |
| `seat-inflate` | PASSED |
| `whats-this` | PASSED |
| `mistakes` | PASSED |
| `flat-causes` | PASSED |
| `progress-idle` | PASSED |
| `watch-mode` (new) | PASSED (Watch to playing on step 1 in 111 ms, cause glass; step 5 with 3 peeled beads after 22.1 s; Next stopped it, 5 to 6, nothing moved in the next 1.5 s; resume to step 11 in 29.1 s, ended "finished", 0 fallbacks, misses 0, hints 0, mistakes 0, IdleHint and RunStats no longer suspended) |
| `jump-to-step` | PASSED |

Uninterrupted watch run (BtnWatch to the Finish card, from the log): 52.4 s with 3.0 s pauses; the pauses were then raised to 3.5 s (4.5 s on the halfway card), measured at 57.3 s (19:22:26.0 play from step 1, 19:23:23.3 stopped, finished, on step 11).

Two-timestamp checks (the beats animate): sweep beat, lever B at 20.6 degrees then 31.9 degrees 0.8 s later, still step 4; two sequential front captures of the wheel show lever B at about 1 o'clock, then at 5 o'clock with the bead peeled behind it. Fit beat, the new tube end at (21.6, -34.2, -35.0) in the tray, then (1.5, -0.5, -86.3) at the valve 0.8 s later; the refit then advanced to step 9 on its own.

Screenshots reviewed: start card with Found it and Watch side by side, both readable; watch mode mid-peel (front captures above; from the default pose lever B leaves the frame below 3 o'clock because the SPECS view only shows the top half of the wheel); watch mode on step 8 (new tan tube going in at the valve, label "Start at the valve. Feed the new tube in."); the Finish card at the end of watch mode, fully in view ("Cause: thorn", "Lever misses 0 · Mistakes 0 · Hints 0"); the control bar at 32 degrees down: all four buttons and the nine rail dots in view, about 1.4 cm from the left edge and 1.2 cm clear of the tray (before: What's this? cut off at the left edge and the bar's right end about 2 cm under the tray). After the final recompile all 507 BenchCoach script inputs in the scene are non-null; `RunAndCollectLogsTool` shows no Lens errors.

Deviations and why:

- **Steps 1 and 2 use real pinch events, not `next`.** The plan listed `next` for them; `WheelTargets.pinchValve()` / `pinchBead(i)` fire the existing events instead, so watch mode plays the hiss, the deflate and the beads loosening one by one through `RepairManager`'s own handlers.
- **`hookA` and `sweep` fly the lever in with `playPlace(0.8 s)`** (the existing snap tween, `onPlaced` on arrival) instead of `placeInstant(true)`, so the lever visibly travels from the tray. `placeInstant(emit)` exists as planned. The ghost plays on step entry as it always has.
- **The director polls the grab flags** (`LeverPlacement.grabbed`, `TubePull.isHeld()`, `TubeFit.grabbed`) instead of subscribing to manipulation events; no new events were needed.
- **A lever flight or tube pull already under way finishes after `stop()`** (both are under 3 s, and their own events then advance the step); a sweep and the step 9/10 demos stop where they are. Next and Back cancel all of them through `completeStep` / `undoStep`.
- **`RunStats.suspended`** is extra: watch-mode actions cannot produce misses, but it guarantees a grab or mistake path during playback is never counted.
- **About 57 s, not exactly 60.** Every beat's pause is long enough to read the label; `waitScale` stretches all of them for a slower take.

Findings:

- **`PreviewInteractTool` called through `IChatToolRegistry.execute()` hung** on a Pinch of `BtnWatch` and never returned; the call outlived the MCP timeout. LEAF's `tap` was used instead (`jump-to-step` `watch=1`).
- **Capturing the preview from inside a long `ExecuteEditorCode` call does not work**: `CapturePanelScreenshotTool` through the registry never produced a frame while the call waited between shots. Timed captures were taken with the MCP tools right after a scenario returned mid-beat (`jump-to-step` `until`).
- **The MCP `CapturePanelScreenshotTool` and `CaptureRuntimeViewTool` calls in one batch run at the same moment**; issue them one after the other for a two-timestamp check.
- **`IChatToolRegistry.execute` needs a `Parameters` instance** (`new Parameters(); p.data = {...}`); a plain object fails with "Value is not a native object".
- A transient "Input manager was not provided for the object BenchCoach" appeared between the VirtualScene Phase A (bare `RepairDirector` component) and Phase B (wiring); gone after the wiring.

Left over: F5 (a hands-on mouse walk) is still open; a hand grab stopping watch mode is reasoned and polled, not tested in LEAF (`watch-mode` stops it with `BtnNext`); a mouse walk should grab a lever mid-watch once. `docs/TEAM_TASKS.md` still lists B4 and F4 as open (not edited in this pass).

## 2026-10-24: Pass 12, Ask the coach (`docs/INTEGRATION_PLAN.md` row 4, feature A; `docs/DEMO_PARITY_PLAN.md` A)

Branch `Sujeeth-AR-SPECS-WORK`. Built by the CLAD Specs Experience Builder through the Lens Studio MCP. No voice (no ASR, mic, realtime or websocket pieces). Not committed.

### Spike (phase 1): passed

- **Package.** `SearchLensStudioAssetLibrary` listed Remote Service Gateway 0.1.8 to 0.1.11, 0.2.0, 2.0.0 and 2.0.1; installed **2.0.1** (>= 0.2.0). It pulled in Utilities 2.0.0 and SnapDecorators 2.0.0 and added the `RemoteServiceGatewayToken` editor plugin under `Plugins/`. It instantiated a `RemoteServiceGatewayExamples` prefab: the `Guide_ReadAndDisable` text and the two empty example roots were deleted; its `RemoteServiceGatewayCredentials` child is reused for the tokens.
- **Tokens.** SNAP, OPENAI and GOOGLE generated together from the signed-in account with `Network.performAuthorizedHttpRequest` in `ExecuteEditorCode` (`tools/coach-tokens-set.ts`), set in memory only, cleared with `tools/coach-tokens-clear.ts` before every save.
- **One call from a throwaway `CoachSpike.ts`** (prompt "In one sentence, why start removing a bike tube opposite the valve?"), deleted afterwards along with its SceneObject:

| Provider / model | Result | Latency |
| --- | --- | --- |
| Gemini `gemini-2.5-flash` (default thinking) | OK: "Starting opposite the valve allows the tire bead to drop into the rim's deep cen" | 4372 ms |
| Gemini `gemini-2.5-flash`, `thinkingBudget: 0` | OK: "Starting opposite the valve provides more slack in the tire bead, making it easi" | 1055 ms |
| Gemini `gemini-2.0-flash` | 404 "Publisher model ... was not found" | 310 ms |
| OpenAI `gpt-4.1-nano` | error: "The model `gpt-4.1-nano` has been deprecated" | 1668 ms |
| OpenAI `gpt-4o-mini` | OK: "Removing a bike tube opposite the valve helps prevent the valve from getting dam" | 1270 ms |

Chosen: Gemini `gemini-2.5-flash` with thinking off (about 1.1 s, well inside the 6 s timeout).

### What was built (phase 2)

- **Data.** `StepDefinitions.COACH_QUESTIONS`: three preset questions per repair step 1 to 6 and 8 to 10, each with a one- or two-sentence canned answer paraphrasing the Park Tool tube procedure (step 5's first: "Why start opposite the valve?" with the answer from the brief). The cards 0, 7 and 11 have none; Ask shows "Ask on a repair step." there. `coachQuestions(step)`.
- **`AskCoach.ts`** on `BenchCoach`: `setOpen(on)`, `ask(step, index)`, `open`, `busy`, `lastAnswer`, `lastSource` ("live" | "canned"), `lastFallbackReason`, `lastLatencyMs`, `onOpenChanged`, `onAnswer`. Sends the system prompt "You are a calm bike mechanic. Answer in at most 2 short sentences, specific to this step: <name>, "<label>"." plus the question to `Gemini.models` (`temperature 0.4`, `maxOutputTokens 90`, `thinkingBudget 0`). Uses the canned answer when `forceCanned`, `!useLive`, no internet, the Google token is a placeholder, the call errors, the reply is empty, or `timeoutSec` (6) passes; a late reply is dropped. Inputs (literal defaults): `useLive` true, `forceCanned` false, `timeoutSec` 6, `model`, `systemPrompt`, `panelGapCm` 0.5, `maxElevationDeg` 18. Tokens are read at call time and never logged.
- **UI** (two passive views, authored under `BenchCoach`, billboarded, default light BackPlate, white text): `AskChipsPanel` (`BenchCoachAskChipsUI`: header "Ask the coach", three UIKit Button chips `AskChip_0..2`, `setQuestions()`, `onChip`) and `AskAnswerPanel` (`BenchCoachAskAnswerUI`: 17 x 7 cm, wrapped answer `AskAnswerText`, tag `AskSourceTag` "coach" or "offline" in light blue, "Thinking…" while waiting). `UIHelpers.addTextButton` added for chips whose label changes.
- **Placement.** The answer sits above the step label, so next to the part the label already points at; the chips sit on the user's left of the label (from the billboarded label's right vector; the tray is on the right), bottom edges level so they stay above the tire. When the answer's top would rise past 18 degrees above the eye (the inspect step's label is higher and closer), the answer goes under the label and the chips top-align with it. Answers stay until the step changes (answer hidden, chips switch to the new step's questions) or Ask turns off.
- **Control bar.** `BtnAsk` (icon `help`, imported with `IconSelector` to `Assets/Icons/help.png`) is a UIKit toggle next to What's this?. The bar stays **25.1 cm** wide: the four secondary buttons 5 to 3.9 cm, gap 0.7 to 0.5 cm, side padding 1 to 0.75 cm (new `padX`; `padding` is now top and bottom only); Next stays 6 cm and the height is unchanged, so `ControlBar` did not move. Literal defaults and scene values both updated.
- **Rules.** `UIBindings` (new `@input askCoach`): BtnAsk presses go through `press()` (tick, `director.stop()`, idle touch); Ask on turns What's this? off and What's this? on turns Ask off. Watch mode closes Ask (AskCoach polls `director.playing`). `IdleHint.askSuspended` (new flag, separate from watch mode's `suspended`) holds hints while Ask is open. A reset closes Ask.
- **LEAF.** New `ask-coach-fallback` (`AskCoachFallbackScenario.ts`): `forceCanned`, jump to step 5, BtnAsk (open, latched, IdleHint suspended, step 5's three questions), AskChip_0 gives the canned answer in 413 ms with `lastSource` "canned", the label text equal to the canned answer and the tag "offline", the panel 6.5 cm from the step label; What's this? and Ask exclude each other both ways; BtnNext hides the answer and switches the chips to step 6; BtnAsk closes it and releases IdleHint. Never touches the network. `jump-to-step` gained `ask` (open, or 0..2 to pinch a chip and wait for the answer) and `canned`, for screenshots.

| Scenario | Result (serial, preview, camera reset before each run, tokens cleared, final code) |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED |
| `peel-and-pull` | PASSED |
| `inspect-done` | PASSED |
| `step-ticks` | PASSED |
| `scene-dressing` | PASSED |
| `refit-tube` | PASSED |
| `seat-inflate` | PASSED |
| `whats-this` | PASSED |
| `mistakes` | PASSED |
| `flat-causes` | PASSED |
| `progress-idle` | PASSED |
| `watch-mode` | PASSED |
| `ask-coach-fallback` (new) | PASSED (canned answer after 413 ms) |
| `jump-to-step` | PASSED |

**Live check (not LEAF), tokens in memory:** step 2, "Why push to the center?", live in 1148 ms ("Pushing the bead to the rim's center creates slack in the tire, making it easier to remove from the rim. ..."), tag "coach", panel beside the bead label; step 6, "Why find the cause?", live in 1125 ms and 1026 ms, panel under the inspect label. With the tokens cleared, step 3 fell back to the canned answer ("no token"). Screenshots reviewed: the control bar at 32 degrees down (five buttons and nine rail dots in view, right end clear of the tray); chips and an offline answer on step 1 and step 3; live answers on steps 2 and 6. On screenshot pixels the new plates read 0.40 (same as every UIKit plate) against the 0.38 background, the text 1.0, the tag 0.86. After the final recompile all 536 BenchCoach script inputs in the scene are non-null; `RunAndCollectLogsTool` shows no Lens errors.

**Token procedure.** `tools/set-coach-tokens.md`: run `tools/coach-tokens-set.ts` through `ExecuteEditorCode` before a demo, never save while tokens are set, run `tools/coach-tokens-clear.ts` before saving, then `tools/check-no-tokens.sh` (exits 1 and names file and line if a token key holds a non-placeholder value or a long bearer-like string in any tracked, unignored-untracked or staged file; self-tested on fake values). The saved scene holds the placeholders `[INSERT SNAP TOKEN]`, `[INSERT OPEN AI TOKEN]`, `[INSERT GOOGLE TOKEN]`.

Deviations and why:

- **Package folder renamed.** `InstallLensStudioPackage` named the folder after the `assetName` argument ("Remote Service Gateway.lspkg"), which broke the package's own example import (`RemoteServiceGateway.lspkg/HostedSnap/Snap3D`, TS2307). Renamed to `RemoteServiceGateway.lspkg` with `AssetManager.rename`; the scene's credentials component kept its reference.
- **Model.** The skill's known-good `gpt-4.1-nano` is deprecated and `gemini-2.0-flash` 404s through RSG; `gemini-2.5-flash` with `thinkingBudget: 0` is used (four times faster than default thinking).
- **Ask does not pause the step** (What's this? does): you can keep working with an answer up.
- **Chips go left of the label, not "away from the wheel center"**: the first rule put them off the right edge on steps 2, 3, 4 and 9.
- **Three questions on every step with questions** (the brief allowed 2 or 3), so chips never switch on and off mid-step (no Interactable is disabled under a pinch).
- **Seven tunables on AskCoach**, one more than the usual cap, because `forceCanned` is a test switch.

Findings:

- **`InstallLensStudioPackage` uses `assetName` as the package folder name.** Pass the canonical name or none, or rename afterwards.
- **`gemini-2.0-flash` returns 404 through RSG** in this project; `gpt-4.1-nano` returns "deprecated". `gemini-2.5-flash` and `gpt-4o-mini` work.
- **`thinkingConfig: {thinkingBudget: 0}` cuts `gemini-2.5-flash` from about 4.4 s to about 1.1 s** for a one-sentence answer.
- **The RSG prefab placeholders differ from the script defaults** (`[INSERT OPEN AI TOKEN]` on the prefab, `[INSERT OPENAI TOKEN HERE]` in code); `AskCoach` and `check-no-tokens.sh` treat any `[INSERT...` value as a placeholder.
- **The preview fades the top tenth of the view**: text there reads about 0.6 instead of 1.0 on screenshot pixels.

Left over:

- Step 5's label sits at 6 o'clock behind the body-locked control bar from the start pose (existing behavior; step 5 is the walk-around step), so its answer is there too.
- On step 6 the chips' left edge clips about 2 cm at the view edge (all chip text readable); on steps 2 to 4 the answer's first line is in the top fade band (readable).
- Live answers sometimes add an analogy ("like a detective solving a mystery"); a stricter system prompt ("plain, practical, no analogies") is a one-field change.
- README disclosure: RSG and Google Gemini (`gemini-2.5-flash`) are now called at runtime.
- `tools/check-no-tokens.sh`, `tools/set-coach-tokens.md` and the two snippets are new and untracked until committed.

## 2026-10-24: Pass 11, floor path and coach-report extras (`docs/INTEGRATION_PLAN.md` row 3, features E and D)

Branch `Sujeeth-AR-SPECS-WORK`, on top of 35a1b6b (pass 12). Built by the CLAD Specs Experience Builder through the Lens Studio MCP. The Ask the coach files were not touched; no RSG tokens were set. Not committed.

What was built:

- **E, `FloorPath.ts`** on new `Environment/FloorPath` (so it follows the environment's visibility). Eight flat chevrons (MeshBuilder via `MeshKit`, 12 cm long, 11 cm wide, 3.4 cm arms, wound counter-clockwise seen from above so they face +Y, 4 tris each), 0.3 cm above the mat's top face (y -149.2), spaced evenly by arc length along a cubic curve from `startSpot` (6, -149.5, -48) to `farSpot` (10, -149.5, -124) whose handles pull to `swingX` 45, so the chain swings round the wheel's right side to x 35.8 (the frame and stand base are at -X) and ends behind the wheel. Each arrow has its own clone of `MarkerMat`; a brightness crest travels from the first arrow to the last at `pulseHz` 0.8, between (0.5, 0.92, 1) and (0.92, 1, 1), both light. Public: `show()`, `hide()`, `visible`, `arrived`, `onArrived`, plus `builtCount` and `arrowPositions` for tests. Rules: every step change hides it and only a forward entry into step 5 (the peel finishing, Next or `jumpToStep`) shows it, so Back into 5 keeps it hidden and the pull ending step 5 hides it; it hides on arrival (camera within `arriveRadiusCm` 30 of the far spot on the floor plane), which does not complete the step; it stays hidden while `RepairDirector.playing`. Inputs (literal defaults): `manager`, `director`, `camera`, `arrowMaterial`; `arrowCount` 8, `startSpot`, `farSpot`, `swingX` 45, `arriveRadiusCm` 30, `pulseHz` 0.8.
- **D, `RunStats`**: `mistakeCounts` per code (lever codes included, used only for the tip; `mistakes` still leaves them out), `noteStep(from, to)` called from `RepairManager.goTo` before `applyStep` (so step 10's time is in when the Finish card fills), `stepSeconds(step)`, `slowestSteps(k)`, `slowestStep()`, `topMistake()`, `practiceTip()`, `formatMSS()`, `PRACTICE_CLEAN`. A step's time runs from entry to a forward completion (to = from + 1) and is summed over such visits; a visit left by Back adds nothing, `jumpToStep` never records (it goes 0 to n in one change), entering step 0 clears everything, and nothing is recorded while `suspended` (watch mode).
- **Data (`StepDefinitions.ts`, next to `MISTAKES`)**: `MISTAKE_TIPS` (one "Practice next: ..." line per code) and `STEP_SHORT_NAMES` for the time row.
- **`BenchCoachFinishCardUI`**: `FinishTimes` ("Slowest: Lever 1 0:10 · Deflate 0:02 · Loosen 0:01", the three slowest work steps) and `FinishPractice` (warm light text) between the existing rows; new `setReport(timesLine, practiceLine)`; `setResult` unchanged. The card grew from 14 to 16 cm and moved from y 17 to 18, so it grew upward and its bottom edge (y 10) did not move; restart button 4.5 to 3.8 cm tall, gap 0.35 to 0.3, top/bottom padding 0.6 to 0.45. Literal default and scene value both 16.
- **LEAF.** New `floor-path` (`FloorPathScenario.ts`) and `coach-report` (`CoachReportScenario.ts`, optional `stay` = 1 leaves the Finish card up for screenshots).

| Scenario | Result (serial, one per call, preview, camera reset before each run, final code, after the save) |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED |
| `peel-and-pull` | PASSED (the first try was cut off by an editor OAuth token refresh that reset the Lens; passed on the rerun and again in the final sweep) |
| `inspect-done` | PASSED |
| `step-ticks` | PASSED |
| `scene-dressing` | PASSED |
| `refit-tube` | PASSED |
| `seat-inflate` | PASSED |
| `whats-this` | PASSED |
| `mistakes` | PASSED |
| `flat-causes` | PASSED |
| `progress-idle` | PASSED |
| `watch-mode` | PASSED |
| `ask-coach-fallback` | PASSED |
| `floor-path` (new) | PASSED (hidden on 4; 8 of 8 arrows on 5; first (12.8, -50.4), last (20.8, -118.8), max x 35.8, arrow centers 15.5 cm from the toolbox footprint; arrival hides it and leaves step 5; Next hides it; Back into 5 keeps it hidden; watch mode from step 4 passes through 5 to 6 with the path never visible) |
| `coach-report` (new) | PASSED (counts beadBeforeDeflate 1, leverTooFar 2 from real drags; step 3 10.06 s, 10.48 s after Back + Next; "Slowest: Lever 1 0:10 · Deflate 0:02 · Loosen 0:01"; "Practice next: lever tips. Drop each tip on the ghost."; no-mistake run "Practice next: Deflate, your slowest step at 0:02"; reset and `jumpToStep(11)` give the clean line and "Slowest: no timed steps") |
| `jump-to-step` | PASSED |

How the scenarios drive things (as the brief asked to record): `coach-report` produces the two lever misses with LEAF `dragTo` (lever A dropped 10 cm right of the socket, as `lever-snap` does), not `CoachFeedback.mistake()`; the drags were reliable in every run. `floor-path` sets the `Camera Object` world position from the scenario (polled every 50 ms); FloorPath saw the far-side position on the first poll every run, but reading the transform back afterwards gives the tracked pose (0, 0, 0), because DeviceTracking writes the camera back each frame. So the in-scenario move depends on update order. The real preview camera was also checked outside LEAF: `MovePreviewCamera setPosition (10, 0, -124)` logged "[FloorPath] arrived at the far side" and the path was gone on the next screenshot.

Screenshots reviewed: step 5 from the start pose pitched down 62 degrees (eight light cyan chevrons on the mat, starting in front and curving right round the wheel toward the far side, the stand base and frame to the left, the toolbox to the right and clear); a top view of the layout; a view from partway along the path at (34, 0, -66) (the chain carrying on past the wheel's right side, toolbox clear); the far side after arrival from (12, -15, -126) (no arrows; the tube end at 6 o'clock and its label "Grab the tube end at 6 o'clock. Pull." in view); the Finish card from the default pose after a real `coach-report` run (whole card in view above the tire: title and time, cause and stats, the time row, the tip, the practice line, Start over). Pulse, two captures taken one after the other: the first arrow measured 0.97 then 0.86 (sRGB luminance) against 0.71 for the mat. Card text 0.95 to 1.0 on a 0.40 plate against a 0.38 background. After the final recompile all 546 BenchCoach script inputs in the scene are non-null; `RunAndCollectLogsTool` shows no Lens errors; no "duplicate of the loaded id" line this session; `tools/check-no-tokens.sh` printed OK.

Deviations and why:

- **Far spot at z -124, not -130.** The workbench's front edge is at z -128.1 (150 x 79.8 cm at z -168), so -130 would put the end of the path under the bench. The camera arrival radius (30 cm) still covers -130.
- **Times are summed over forward visits.** A Back then Next on the same step adds the second visit instead of replacing the first, so a long first attempt is not erased by a quick redo.
- **The time row ranks work steps only (rail-dot steps 1 to 6 and 8 to 10).** Step 7 (the halfway card) is timed too, but it is reading time, so it is left out of "slowest" and the tip.
- **Watch mode records no step times** (`RunStats.suspended`, like the other counters), so the Finish card after an uninterrupted watch run shows "Slowest: no timed steps" and the clean practice line.
- **The Finish card was edited in place** with the project's `UIHelpers` (UIKit BackPlate, FlexLayout, Button), not regenerated through `/specs-build-ui`, so the existing layout and object names stay as they were.
- **Chevrons 12 x 11 cm** (the first try at 10 x 9 cm with 2.6 cm arms looked thin and aliased from 1.6 m up).

Findings:

- **Setting the camera transform from a Lens script holds for one frame only.** DeviceTracking writes it back, so in-Lens checks work only if they read the camera in the same frame; `MovePreviewCamera` is the reliable way to move the user.
- **`expect(...).toBeGreaterThanOrEqual` does not exist in LEAF's `Expectation`**; use `toBeGreaterThan(n - 1)`.
- **A LEAF run can take up to about 50 s to start after a recompile** (the panel waits for the reset), so the MCP call can time out while the scenario still runs and passes. Read the result from the log.

Left over: the step-5 marker ring sits on the front side of the tire, so from the far spot it is hidden behind the tire (the tube end and its label are in view); a hands-on walk along the path in the preview (WASD) was not done beyond the camera moves above; the README should mention the floor path in the walk-around shot.

## 2026-10-25: Pass D1, scene and art direction

Branch `fix/step5-far-side-marker`. Built through the CLAD skills and the Lens Studio MCP. Scope: the scene and the art direction only. Panels, labels, the control bar and the cards were not restyled (that is the UI pass).

What the audit showed (`shots/audit/`, Pass V):

- The text-to-3D pegboard (emissive 0.65) was a bright white slab directly behind the wheel in every start-pose shot.
- The rear triangle cut diagonally across the wheel, and the white saddle blob sat at the top left.
- The glossy red toolbox and the bright wood workbench showed behind the wheel's lower half.
- Every BenchCoach PBR material multiplied its base color by `Base.png`, a 1x1 texel of (128, 128, 128), so the set colors rendered at about half.
- The hub was a cube-like cylinder. The spokes ran into the hub center. The rim was a round tube. The valve was a plain cylinder.
- The stand assumed a floor 150 cm below the eye.

Changes, each with the reason:

- **Base.png multiply removed.** `ENABLE_BASE_TEX` was taken off the 11 BenchCoach PBR materials (Hub, Rim, Spoke, Tire, Tube, Valve, Stand, Lever, MatField, MatBorder, and the new Sidewall). `ImageMaterial` (the flat UI shader) keeps it. The colors were then retuned on screenshots:
  - Rim: 0.95 silver, metallic 0.5, roughness 0.35. At 0.80 / metallic 0.6 the rim face read 0.50 against a 0.42 background; at 0.95 / 0.5 it reads 0.56.
  - Tire tread: charcoal 0.38, roughness 0.8, metallic 0.
  - New `SidewallMat`: tan (0.75, 0.60, 0.42), roughness 0.75.
  - Tube: muted amber (0.78, 0.47, 0.16), roughness 0.55. It is more saturated than the tan sidewall so the two stay apart.
  - Stand: (0.36, 0.37, 0.39), metallic 0.3, roughness 0.6.
  - Hub: 0.80 silver, metallic 0.5, roughness 0.3.
  - Spokes: 0.78, metallic 0.4, roughness 0.35. Spokes, tire, tube and valve were all roughness 0 before, which caused the hot streaks.
  - Valve: brass (0.80, 0.66, 0.38), metallic 0.5, roughness 0.35.
  - Mat field: 0.34, roughness 0.9. Mat border: (0.26, 0.31, 0.38), roughness 0.9. Both are below the old effective values (0.41 and 0.31 to 0.48), so the mat no longer glows.
  - Levers: (0.20, 0.50, 0.95), roughness 0.5.
- **Clutter removed.** These were deleted from the scene and the project:
  - `Environment/Pegboard` + `Pegboard.glb`.
  - `Environment/Toolbox` + `Toolbox.glb`.
  - `Stand/BikeFrame` (rear triangle and saddle) + `RearTriangle.ts`, `FrameMat.mat`, `Saddle.glb`.
  - The "Frame" What's this? fact and PartInfo's seat-tube placement code.
- **Workbench removed too (item 4).** It was moved to (95, floor, -120), turned 90 degrees so it no longer sat behind the work area, and given a matte, darker wood (roughness 1.0 and base factor (0.62, 0.55, 0.48), baked into the GLB JSON). It still read as a bright, blocky, cartoon-wood slab and was the largest bright shape in the wide view, so it was deleted with `Workbench.glb`. The floor path's far spot no longer has a bench edge to stay in front of.
- **Wheel model** (code-built; names and transforms unchanged):
  - `MeshKit.lathe()` (new): solids of revolution with crisp shoulders, plus faceted hex nuts.
  - `WheelParts.ts` (new, on `Wheel`) builds into the existing RenderMeshVisuals:
    - Hub: a waisted round body, two 2.6 cm flanges, hex locknuts, and a 6.3 cm axle stub each side.
    - Spokes: 0.12 cm radius, flange hole to the rim's spoke bed, alternating flanges, with a nipple at the rim. Each is built in its own `Spoke_i` frame, so the Spoke_2 What's this? box still sits on a spoke.
    - Presta valve: knurled tip locknut, thin core, threaded stem, and a hex rim nut against the spoke bed.
    - A light "700x25c" sidewall marking at 96 degrees on `Bead_2`.
  - Hub, Valve and Spoke_i now have unit scale in the scene. WheelTargets sizes the valve hit box from the scale, and the hit box is unchanged in cm.
  - `TorusArc`:
    - `profile` = 1 builds a box-section rim (3.2 cm deep, 2.0 cm wide, chamfered, flat-shaded), with a 0.16 x 0.06 cm groove at the inner edge of a 1.1 cm braking track.
    - `bandMaterial` / `bandBelowCos`: tire faces off the tread go into a second RenderMeshVisual on the same bead, which makes the tire two-tone.
    - Beads: 16 cross-section segments, tread 0.1 cm deep with 16 blocks per arc. The old 0.25 cm x 6 blocks was a lumpy silhouette.
  - `Highlighter` swaps every RenderMeshVisual on a part, so the sidewall band glows with the tread.
- **Stand on the real floor.**
  - `FloorLevel.ts` (new, root object `FloorLevel`) is the single source of truth for the floor.
    - It casts 44 downward rays: 9 vertical rays on a 35 cm ring around the stand footprint, plus 35 rays from the eye toward the floor 1.5 to 4.5 m out.
    - It uses the World Query hit test for 3 s, then world-mesh raycasts until they hit (up to 8 s more). It sets `enableWorldMeshesTracking`.
    - It keeps upward-facing hits at least 140 cm below the eye, and takes the lowest height that 3 or more hits agree on within 8 cm. Higher levels (table tops, seats) and stray hits are rejected.
    - Otherwise it keeps -150, and it logs which path ran.
  - `WheelStand.ts` (new, on `Stand`) builds the stand into StandBase / StandPost / StandClamp on that floor:
    - Tripod with rubber feet.
    - Telescoping post with a height collar, T-knob, top cap and arm collar.
    - An arm 8.2 cm behind the wheel plane from a post 47 cm to the left, ending in a clamp head with jaws on the back axle stub and a quick-release lever.
  - `FloorAnchor.ts` (new) puts the mat's top 0.5 cm above the floor. `FloorPath` lays the arrows 0.3 cm above the mat top at the measured floor.
  - The wheel did not move. The hub stays at (0, -25, -90): 25 cm below and 90 cm in front of the default eye. Only the post length follows the floor.
  - Readers subscribe to `onFloorChanged` and read `currentFloorY()` in `OnStartEvent`.
- **Lighting:**
  - KeyLight 1.0 to 0.9, with shadow blur 3 to 5.
  - FillLight 0.6 to 0.9, because the front-facing rim sidewall gets little of the steep key.
  - EnvLight 1.0 to 1.5, because the reflections make the metal read as silver.
  - The wheel's soft shadow still shows on the mat.

Floor measurement (default start pose, logged by `FloorLevel`):

| Preview room | Floor y (cm) | Path |
| --- | --- | --- |
| Sunlit Room (the default) | -178.3, -178.5, -178.5, -177.8 (four runs) | world mesh (15 to 16 inliers), once World Query (15) |
| Plane (chosen for shots) | -150.0, -150.1 | World Query (3 to 6 hits); one run fell back to -150 before the 140 cm rule existed |
| Sunlit Outdoor / Evening Outdoor | -172.9 / -173.0 | World Query |
| Colorful Home | -150.1 | World Query, 3 hits |
| Evening Room | -135.8 (rejected now) | World Query only sees a furniture top there; this is why the 140 cm rule exists. Not re-run after the rule. |

In the Sunlit Room, the world mesh sees -175 to -180 (floor), -165, -140 to -145 and -110 (the coffee table in front of the start pose). From the start pose, World Query sees only one surface at -146.6, a low console top. Before the pooled lowest-level rule, the median picked -142.1.

Preview room (editor setting, not part of the Lens): six rooms were captured on step 1 from the start pose (`shots/d1-notes/rooms-sheet.png`). The figures are the luminance spread behind the wheel on screenshot pixels, with the brightest 10 percent (spokes, rim) trimmed:

| Room | Spread | Notes |
| --- | --- | --- |
| Sunlit Room | 0.100 | High-contrast posters behind the wheel |
| Colorful Home | 0.113 | Green wall, chair, table |
| Evening Room | 0.036 | Same posters, dimmer |
| Sunlit Outdoor | 0.041 | Plaza arches |
| Evening Outdoor | 0.032 | Dark plaza and tiles |
| Plane | 0.029 | Nothing behind the wheel; faint floor grid |

**Plane was chosen** for the demo video and the after-shots. It is the calmest backdrop: no posters, shelves or furniture, and the floor measured there matches its visible grid (the mat lies flush on it). Evening Room is the runner-up if a lived-in room is wanted, but its floor is not measurable from the start pose.

| Scenario | Result (serial, one per call, Plane, default camera pose, after the save) |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED |
| `peel-and-pull` | PASSED |
| `inspect-done` | PASSED |
| `step-ticks` | PASSED |
| `scene-dressing` (changed) | PASSED. Plane: floor -150.0 via World Query + world mesh (56 inliers), stand base -150.0, hub (0, -25, -90). Sunlit Room rerun: floor -177.8, base -177.8 |
| `refit-tube` | PASSED |
| `seat-inflate` | PASSED |
| `whats-this` | PASSED |
| `mistakes` | PASSED |
| `flat-causes` | PASSED |
| `progress-idle` | PASSED |
| `watch-mode` | PASSED on the rerun. The first run failed ("watch mode reached LAST_STEP within 90 s") because the preview paused itself at step 9. |
| `ask-coach-fallback` | PASSED |
| `floor-path` (changed) | PASSED. Arrows y -149.2 on a -149.5 mat top in Plane, -177.3 on -177.6 in the Sunlit Room; first (12.8, -50.4), last (20.8, -118.8), max x 35.8 |
| `coach-report` | PASSED |
| `jump-to-step` | PASSED |

Assertions changed, and why:

- **`scene-dressing` 7b block.** These checks were removed because the objects are gone: BikeFrame exists / hidden on step 0 / shown after Found it, and the rear dropouts within 1 cm of the hub. These checks were added:
  - Pegboard, Toolbox, Workbench, BikeFrame and Saddle absent.
  - FloorLevel decided within 30 s.
  - StandBase within 1 cm of the floor, and WheelStand built on it.
  - Mat origin 0.5 cm (within 1 cm) above the floor.
  - StandClamp level with the hub (within 0.5 cm), 6 to 11 cm behind it.
  - Hub 20 to 30 cm below and 85 to 95 cm in front of the default eye.
  - The Workbench placement check proposed for item 2 was not added, because the bench was removed.
- **`floor-path` layout checks.**
  - The fixed y -149.5 to -148.5 is now "within 1 cm above the measured mat top".
  - "Clear of the stand base" (x > -9.6) is now "clear of the tripod" (x > base x + leg spread + 8).
  - The workbench-edge and toolbox-clearance checks were removed (both props are gone).

Every BenchCoach script input in the saved scene is set (697 across 39 script components), except the 12 optional `TorusArc.bandMaterial` slots (`@allowUndefined`, empty by design on the rim, tube segments, marker ring and new-tube coils). `RunAndCollectLogsTool` showed no Lens errors after the final recompile.

Cost:
- Removed: about 15,900 triangles (the four GLBs and the frame).
- Added:
  - WheelParts 1,824 triangles.
  - WheelStand 944 triangles, replacing three primitives.
  - Tire beads about 16,600 triangles, up from 4,800 (64 rings x 16 segments x 8 beads, for the fine tread).
  - Rim about 2,200 triangles, up from 1,500.
- Net about flat.
- Draw calls: minus 5 props, plus 8 sidewall bands and 1 text.

Findings:

- **World Query in the preview answers only inside the camera's view.** From the start pose that is far floor and furniture, not the floor under the stand.
- **World-mesh raycasts need `worldOptions.enableWorldMeshesTracking = true` and a few seconds** before they hit anything.
- **The floor differs per preview room** (-150 to -178.5), so a hard-coded floor is wrong in most rooms.
- **A script component referenced through an `@input` has no methods before its own `onAwake`.** WheelStand on `Stand` threw "undefined is not a function" calling `FloorLevel.currentFloorY()`, because FloorLevel sits lower in the hierarchy. Read it in `OnStartEvent`.
- **`CapturePanelScreenshotTool` with `outputPath` reports success but writes nothing when the folder does not exist.**
- **Two LEAF runs and two captures sent at once left the editor unresponsive for about 7 minutes.** Afterwards `CapturePanelScreenshotTool` kept timing out, so the after-shot run was stopped (see Left over).
- **The Preview panel changed size mid-session**, from 1463 x 1590 to 1392 x 1731, so the after-shots frame more of the scene vertically than the audit shots.
- **Lens Studio reported "not signed in".** Nothing in this pass needed account APIs.

Left over:

- Only 5 of the 24 after-shots were taken: 00, 01, 02, 03 and 03b in `shots/after-d1/`, all in Plane. 04 through 31 still need retaking with the same poses as the audit, one call at a time.
- On loosened or lifted beads, the charcoal end caps show as small ticks at the bead joints.
- The stand's arm is visible through the spokes at 9 o'clock, behind the wheel.
- On step 3, in the taller panel, the edge arrow shows next to the ring.
- FloorLevel is untested on a device. There, World Query also sees only what is in view, so the world-mesh path may decide.
- The Evening Room was not re-measured after the 140 cm rule.
- No hands-on walk was done.

## 2026-10-28: Pass F, control-bar misfires and floor detection

On `main`. Built through the CLAD skills and the Lens Studio MCP. Pass Q played the whole repair with real preview input and found three bugs. Each was reproduced, fixed at its root cause and re-checked with the same kind of real input. No UI restyle.

Real input in this pass is of two kinds:
- **The preview agent hand** (`PreviewInteractTool`). It always targets directly: SIK's HandInteractor stays in Direct mode with a zero ray direction. It animates from its rest pose to the target with the index finger out, so it can poke whatever it passes. This is the input pass Q used.
- **The preview's mouse ray** (`InjectPreviewGesture` taps). This is a SIK indirect interactor: a deliberate ray pinch. The first press at a new spot only moves the cursor and fires nothing; the second press triggers.

### Bug 1: Replay presses Next

Repro: on step 4, a by-id pinch on `BtnReplay` timed out on Replay's `onTriggerStart` and the step went 4 to 5. With a trigger log added, one world-position pinch at Replay's centre (7.5, -34.4, -44.65) gave:
- "BtnNext triggered by poke" (step 4 to 5);
- then "BtnReplay triggered by poke".

A by-id pinch straight after gave "BtnNext triggered by poke" again (step 5 to 6).

Root cause: not the hit boxes. Measured live after FlexLayout placed them, in cm from the bar's centre, each collider is exactly as wide as its visual, with 0.50 cm gaps:

| Button | Hit box | Width (= visual) |
| --- | --- | --- |
| BtnWhatsThis | -11.80 to -7.90 | 3.90 |
| BtnAsk | -7.40 to -3.50 | 3.90 |
| BtnBack | -3.00 to 0.90 | 3.90 |
| BtnNext | 1.40 to 7.40 | 6.00 |
| BtnReplay | 7.90 to 11.80 | 3.90 |

UIKit's `Element.initialize()` sets every button's Interactable to `TargetingMode.All`, which includes Poke. A hand on its way to Replay pokes Next, the large button in its path. This is the same root cause as bug 2, and the same fix closes it. Until the layout runs (a few frames after init), all five buttons sit at the bar's centre, so a measurement must wait for it.

Fix:
- **Ray-only buttons:** see bug 2.
- **Replay log:** `RepairManager.replay()` logs the step and what it replayed ("replay on step 4 (Second lever and peel): the ghost lever's hooking motion (replay 1 on this step)") and keeps it in `lastReplay`.
- **Press log:** `UIBindings` logs "press <button>" for every bar and card press.
- **Trigger log:** `UIHelpers` logs "[UI] <button> triggered by ray|poke|direct pinch".
- **Hit-box log:** the bar logs its measured hit boxes once after layout (`hitBoxes`, `hitBoxesClear`).

Verification (mouse ray at the centre of every bar button):
- **Step 2:**
  - Replay: chime, step stays 2.
  - What's this? on, then off.
  - Ask on, then off.
  - Back: 2 to 1.
  - Next: 1 to 2.
- **Step 4:**
  - Replay: ghost replay, step stays 4.
  - What's this? on, then off.
  - Ask on, then off.
  - Back: 4 to 3.
  - Next: 3 to 4.
- Every press logged only its own button.
- Agent-hand pinches at all five centres on step 4 (pass Q's input) now fire nothing, and the step stays 4.

### Bug 2: control-bar buttons fire when the hand passes over them

Root cause: `TargetingMode.All`, as above. A hand passing through the body-locked bar (about 44 cm out, 32 degrees down) poked its buttons.

Fix: `UIHelpers.rayOnly()` sets `TargetingMode.Indirect` once each button is up. This is SIK's own setting (`Interactable.targetingMode`; its interactors and `PhysicalInteractionProvider` skip interactables without the Direct or Poke bit). It applies to every UI button built by `addIconButton`, `addLabelButton` and `addTextButton`, 13 in all:
- the bar (5);
- Found it and Watch;
- Continue and Try again;
- Restart;
- Ask chips 0 to 2.

The tool tray has no UI buttons. The levers, tube ends, new tube, valve, beads and What's this? boxes keep their own targeting.

Verification:
- **Found it**, agent-hand pinch (Sunlit Room): nothing fired, and What's this? stayed off. By ray: only Found it, step 1.
- **Valve**, agent hand, step 1: the tire deflated and the step went to 2; no UI fired. On step 2: only the "already flat" coaching.
- **New tube**, agent-hand drag on step 8 (shown as 9): fitted 0.1 cm from the socket, step 9; no UI fired.
- **Step 9 (shown as 10):** the tube is not grabbable there. The same tray-to-valve hand path, and a pinch-drag starting on Ask/Back and ending at the wheel, fired nothing.
- **Ask**, by ray: open, chip 1 (offline answer, no token), close. Each fired alone.
- **Other buttons by ray:** Watch, Continue, Try again and Restart each fired alone.

### Bug 3: FloorLevel could pick a console top

Root cause:
- When the world mesh had too few hits, World Query hits were accepted alone, and the 140 cm rule let a -146 console top through.
- World Query answers only inside the view, and most of the fixed eye rays aimed outside it.
- In the preview the world mesh is often missing for the first Lens runs after a room loads. In one Colorful Home run it never appeared in 90 s, and in Evening Room it stayed missing across seven Lens runs (LEAF resets, a preview refresh and a recompile).

Fix (`FloorLevel.ts`):
- **Wider footprint, pooled over time:** hits from both paths are pooled, one per 10 cm cell and 2 cm of height per path:
  - two rings round the stand (35 and 70 cm);
  - a World Query grid fanned below the current gaze (yaw -21 to 21, 4 to 28 degrees down), so looking down brings the near floor into it;
  - world-mesh eye rays out to 450 cm.
- **Lowest wide level:** the exported, pure `pickFloorCluster()` takes the lowest 8 cm band with 3 or more cells spread over 60 cm or more.
- **Timing:**
  - Nothing is decided before 3 s.
  - A level seen only by World Query waits 8 s more for the mesh. With no level, the -150 fallback stays.
  - Until 20 s, a lower wide level replaces the decision. The window stays open until the mesh has answered for 8 s, at most 90 s.
  - Stand, mat and floor path rebuild on every `onFloorChanged`.
- **`minDropCm` 140 to 120:** Colorful Home's visible floor is about -135, not -150.1. Its world mesh puts 37 cells at -135. A preview camera at y -142 is under the floor, and at y -128 it sees the floor just below. The -150.1 in pass D1 came from three World Query hits.
- **Logs:** every decision logs its path, hits per path, cells, spread, time, the pooled histogram and the ignored higher hits.

Decided floor, default pose, Lens reset right before each LEAF run:

| Room | Visible floor | With the world mesh | Without it (fresh room load) |
| --- | --- | --- | --- |
| Sunlit Room | about -178 | -179.4 (28 cells, spread 589 cm, 3.1 s) in `start`, `deflate-loosen`, `lever-snap`; -178.4 (16 cells) | -178.1 (3 World Query cells, spread 221 cm, 11 s) in `start`, `deflate-loosen`, `lever-snap`. One session decided -138.4 (a 2.5 m wide surface 40 cm above the floor, probably the sofa seat) until the mesh arrived and corrected it to -178.2. |
| Evening Room (Sunlit's geometry, dimmer) | about -178 | -178.4 (16 cells) | -178.1 in `start`, `deflate-loosen`, `lever-snap` |
| Plane | -150 | -150.0 (75 mesh + 4 World Query hits) in `deflate-loosen`, `lever-snap` | -150.0 (5 to 6 World Query cells) in `start`, `deflate-loosen`, `lever-snap` |
| Colorful Home | about -135 | -133.6 (38 cells) in `start`, `deflate-loosen`, `lever-snap` | -135.5 (14 to 15 World Query cells) in `start`, `deflate-loosen`, `lever-snap` |

Before the gaze grid, the Evening Room with no mesh decided -146.3. Looking down 32 degrees then corrected it to -176.3 at 28.4 s, and the stand followed.

Side views with the stand's feet on the mat on the room floor: `shots/pass-f/floor-sunlit-room.png`, `floor-evening-room.png`, `floor-plane.png`, `floor-colorful-home.png`.

### LEAF

Two scenarios were added:
- **`control-bar`:**
  - hit boxes match their visuals and do not overlap;
  - all 13 UI buttons are ray-only, and the grabbables still take a direct pinch;
  - Replay keeps step 4 and reports the ghost;
  - each bar button acts alone.
- **`floor-level`:**
  - mixed heights: the floor beats a console top, and a narrow box or strays below the floor are skipped;
  - live: a higher level never raises the floor, and a lower wide level corrects it down with the stand, mat and path following.

| Scenario | Result (serial, one per call, Sunlit Room, default pose, after the save) |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED |
| `peel-and-pull` | PASSED. In the sweep before the last FloorLevel change it failed once (lever B never grabbed, still 66.75 cm from socket B; the floor decision came after the drag timed out) and passed on the immediate rerun |
| `inspect-done` | PASSED |
| `step-ticks` | PASSED |
| `scene-dressing` | PASSED. Floor -138.4 via World Query in that session (see bug 3), stand base -138.4 |
| `refit-tube` | PASSED |
| `seat-inflate` | PASSED |
| `whats-this` | PASSED |
| `mistakes` | PASSED |
| `flat-causes` | PASSED |
| `progress-idle` | PASSED |
| `watch-mode` | PASSED |
| `ask-coach-fallback` | PASSED |
| `floor-path` | PASSED. The mesh arrived mid-run: -138.2 corrected to -178.2 at 14.1 s |
| `coach-report` | PASSED |
| `control-bar` (new) | PASSED |
| `floor-level` (new) | PASSED. Live floor -178.4 via world mesh; correction to -190.4 moved stand, base, mat and 8 arrows |
| `jump-to-step` | PASSED |

Not covered by an automated test:
- **Bug 2's hand pass-through, and bug 1's poke misfire.** LEAF's interactor triggers an interactable directly and cannot travel through space or poke. `control-bar` checks the setting, the hit boxes and each button's effect.
- **Bug 3's no-mesh behaviour.** It depends on the preview's world mesh and World Query. `floor-level` covers the cluster choice and the correction path.

All BenchCoach script inputs are set (699 across 63 script components), except the 12 optional `TorusArc.bandMaterial` slots. `RunAndCollectLogsTool` shows no Lens errors after the final recompile.

Findings:

- **UIKit `Element.initialize()` forces `TargetingMode.All` on every Button.** Set the targeting after `onInitialized`. `setIsToggleable` keeps it.
- **`PreviewInteractTool` can no longer press UI buttons.** They now take only ray pinches, and its hand only targets directly. Use `InjectPreviewGesture` taps: press twice at a new spot (the first only moves the cursor). Read button screen positions from the camera's `worldSpaceToScreenSpace`; do not estimate them from screenshots.
- **The preview's world mesh** is missing for the first Lens runs after a room loads, sometimes for many resets. It never appeared mid-run.
- **A new `@input`'s default is stored in the scene at its first compile.** Changing the default afterwards does not change the scene value; set it on the component.
- **The Evening Room is the Sunlit Room's geometry with dimmer light:** the same floor and the same World Query answers.
- **Saving through the MCP made the LEAF plugin re-create its "LEAF Plugin Bridge"** with new ids. That hunk was left out of the commit.

Left over:

- **Ray-only UI is untested on Specs.** People can no longer poke or touch-pinch the bar, the cards or the chips; they must use the hand ray. If direct pinches are wanted on device, `TargetingMode.Direct | Indirect` (no Poke) is the next thing to try.
- **Without the world mesh, World Query from the start pose sometimes sees no floor.** One session picked a surface at -138 until the mesh came. On a device the mesh builds while the user looks around, and looking down corrects it, but this is untested there.
- **FloorLevel now casts more rays,** for 20 s, or up to 90 s while the mesh is missing:
  - 81 World Query hit tests every 0.25 s;
  - 79 world-mesh raycasts every 0.5 s.

  Performance was not measured.
- **Floor figures elsewhere:** the brief's -150.1 for Colorful Home is superseded by about -135. `docs/TEAM_TASKS.md` was not updated.
- **Hands-on walk:** no real-hand walk was done, and the cursor-tap verification is the preview mouse, not a Specs hand ray.

## 2026-10-29: Pass D2, the UI system

On `main`. Built through the CLAD skills (`specs-build-ui`, preview inspection and interaction, LEAF) and the Lens Studio MCP, one call at a time. Scope: how the UI looks, where it sits and what it says. The step logic is unchanged; the few logic-adjacent changes are listed under "Placement changes outside the UI scripts" with the reason for each. The session was interrupted by a machine restart; the work resumed on 2026-11-05 from the saved working tree.

### The recording room and pose

- **Room: Evening Room.** It is darker than Sunlit Room, so the Lens content stands out on the additive display.
- **Pose:**
  - start eye (-150, 0, -225), yaw 0 (facing -Z), pitch about -10°;
  - step 5 far side: eye (-140, 0, -349);
  - exact steps, working poses and the room layout are in `scratchpad/recording-pose.md`.
- **Why there:** overhead captures (1.24 px/cm, scaled from the 180 x 120 cm mat) show:
  - from the default pose the mat runs about 40 cm under the sofa (front edge z -108), and the step-5 far spot (z -124) is inside the sofa;
  - a low console sits under the default eye;
  - the left half of the rug, behind the sofa, is about 2.3 x 2.3 m of open floor.

  From (-150, 0, -225) the set fits there:
  - the mat spans x -240 to -60 and z -374 to -255: 14 cm clear of the coffee table and 32 cm of a cabinet;
  - the far side is at z -349, 100 cm short of the poster console;
  - the background behind the wheel is the dim lamp-lit wall.
- **Floor:** -178.6 cm via the world mesh (40 hits) in every run of the Evening sweep.
- **The Lens must re-anchor (new `WorkspaceAnchor`, on Camera Object).**
  - In the preview the Lens world is the simulated room: after moving the preview camera and resetting, the Lens camera sits at the moved pose but the workspace stayed at its authored room coordinates.
  - `WorkspaceAnchor` moves the workspace roots by the start eye's position at OnStart: Lighting, Stand, Wheel, Environment and the world-placed BenchCoach panels. Translation only, so every "+Z toward the user" rule in the step code still holds.
  - On Specs the start eye is the origin, so nothing moves.
  - Readers of world constants add `WorkspaceAnchor.offset()`: FloorPath's spots and swing, FloorLevel's probe center, and the tests.

### The design system (`UIHelpers.ts`)

- **Colour tokens, one meaning each (`COLOR`):**

| Token | Value | Meaning |
| --- | --- | --- |
| accent | cyan (0.10, 0.95, 1.0) | "Do it here": markers, the step leader line, the primary button, latched toggles, the hint pulse, the watch pill |
| amber | (1.0, 0.72, 0.22) | A mistake or a warning (mistake edge and kicker, floor fallback) |
| green | (0.42, 0.95, 0.52) | Done ("Floor found", "Found it", "Halfway", "Repair complete") |
| text | white | Primary text |
| textSecondary | light grey (0.76, 0.79, 0.82) | Secondary lines and list labels |
| edge | light grey at 0.38 alpha | Neutral plate edge and the info leader (not a colour) |

- **Text roles (`UIRole` on the existing type scale, scaled by distance):**
  - title: Title2, card titles;
  - instruction: Headline2, the callout line and the info title;
  - body: Body, answers and card values;
  - secondary: Caption, grey;
  - button: Subheadline, bold. It was Button; that read too small on the dock in screenshots.
- **Text rects keep glyphs in:** one-line text shrinks to its width, and wrapped text shrinks to its height.
- **Spacing grid:** `grid(d)` at k = d / 90 gives padding 1.1k, gap 0.5k, corner radius 1.0k and edge 0.09k, so every panel has the same angular padding.
- **One plate (`makePlate`):**
  - a UIKit BackPlate in the **"dark"** style (linear 0.09 to 0.26 grey), which kept the most contrast under white text on screenshots;
  - plus a thin edge on its RoundedRectangle. On the additive display every plate is mostly see-through, so the edge is what draws the panel;
  - `setEdge()` turns the edge amber for a mistake or pulses it in the accent for a hint.
- **Buttons:**
  - UIKit Buttons with a custom `RoundedRectangleVisual` per state: neutral (dark, light edge, cyan on hover) and primary (cyan-tinted, cyan edge);
  - toggles latch in the accent;
  - still ray-only (`rayOnly`, pass F).
- **Shared builders:**
  - `buildCard`: kicker, title, rows, a two-column list, more rows, a button row; the height follows the content;
  - `LeaderLine`: a thin box stretched between two points;
  - `plateEdgePoint`;
  - `addUIText`, `addLabelButton`, `addIconButton`, `addTextButton`.

### Components, where they live and why

- **Start card** (`BenchCoachStartCardUI`, eye + (0, -12, -82)):
  - "Fix a flat", one instruction ("Put your wheel in the stand, then pinch Found it."), and a floor line:
    - grey "Look down at your work spot" while FloorLevel is pending;
    - green "Floor found";
    - amber "Using a standard floor height" on the fallback.
  - "Found it" (primary) and "Watch first".
  - The stand-in badge is gone; the note is logged at start.
  - Centered just below eye level.
- **Step callout** (`BenchCoachStepLabelUI`, the object keeps the name StepLabel):
  - Content: "Step N of 10", then the instruction on up to two lines.
  - A cyan leader runs from the plate edge to 2.6 cm short of the marker ring.
  - States:
    - mistake: amber edge and "Not quite";
    - idle hint: "Hint" with the edge pulsing in cyan;
    - cause found: green "Found it".
  - Placement:
    - Default "inside": from the marker toward the hub until the near edge clears the ring by 4.5 cm, then pulled in until every corner is inside the clear circle (bead radius - 6.5 cm). It never covers the tire, a bead, the valve or a lever handle (handles stand up out of the tire), and it stays near eye level.
    - From the live eye it never covers the ring on screen: if it would, it keeps moving toward the hub. From step 5's far side the user looks steeply down past it.
    - It keeps its apparent size: closer than 90 cm it scales down (min 0.45), so it fits at the far side about 35 cm away.
    - With something hung under it (Ask, the What's this? prompt), it moves above the tire (shifted away from the marker's side, clear of handles) or below it, so the stack never lies over the wheel.
- **What's this? info callout** (new `BenchCoachInfoCalloutUI`, object InfoCallout):
  - the part's name and one line, with a grey leader to the part, placed beside it;
  - it tries spots toward the view center, above, below, the diagonals and outward, and takes the first that stays inside 90% of the view and doesn't overlap the step callout on screen;
  - the prompt ("What's this?" / "Pinch any part to learn what it is.") hangs in the slot under the step callout;
  - it never rewrites the step callout.
- **Dock** (`BenchCoachControlBarUI` on ControlBar):
  - Contents:
    - Back, Replay, Next (primary, labelled) and More, as 3.6 cm buttons (6.6 cm for Next) at 48 cm;
    - under them "4 / 10" and a thin segmented bar (ProgressRail, now nine flat segments);
    - More opens a popover with "What's this?" and "Ask the coach" (the same toggles as before);
    - during watch mode, a cyan-edged pill "Watching the coach" with Stop sits on top.
  - Where: body-followed low on the user's left, yaw -30° and pitch -30° at 48 cm.
  - Why there:
    - **Reach:** buttons are ray-only, so arm reach does not limit it.
    - **View:** from every working pose it is out of frame (the preview shows about ±15° x ±18°); one glance down-left brings all of it into view.
    - **Hands:** it is out of the right hand's path to the wheel and the tray, on the opposite side from the tray.
    - **Step-5 walk:** it follows the walk.
  - The old bar sat 38° straight down in the hand's path.
  - The per-press logs from pass F stay; More, BtnAskClose and BtnAnswerClose now also go through `UIBindings.press`.
- **Ask the coach:**
  - the chips (header with close) or the answer (source tag "Coach" / "Offline answer", close, text) take turns in the slot under the step callout, at the callout's width and scale;
  - the answer's close brings the chips back, and the chips' close closes Ask.
- **Watch mode:** the pill on the dock, as above. It goes away when watch mode stops: a grab (existing), any press, or Stop.
- **Tool tray** (17 x 14 cm, ToolTray at yaw +25° right, pitch -38°, 52 cm):
  - same plate, a small "Tools" label;
  - both 12 cm levers and the coil sit inside it.
  - Hidden on step 5: the levers are in the wheel by then, and the empty tray sat in the downward gaze along the floor path.
- **Markers and the edge arrow:**
  - the ring never covers callout text (the callout keeps clear of it);
  - the edge arrow slides along the view edge off the dock, the step callout and the info callout.
- **Halfway and Finish cards:** the same card component and buttons as the start card.
  - Halfway: green "Halfway" kicker, "Tube out, cause found", Time and Cause in a two-column list, "Next skill: brake pads".
  - Finish: green "Repair complete", "Flat fixed", a list of Time, Cause, Lever misses, Mistakes, Hints and Slowest, then the tip and practice lines.
  - Both at eye + (0, -8, -80), just below eye level.

### Voice-ready text

- **Step lines:** each step's callout line is one short sentence, and `voiceLine` (in `StepDefinitions.ts`) is the same sentence spoken, at most 12 words. Step 7 and the finish card have their own lines.
- **Other lines** come from the same file: `MISTAKES` (mistake-<code>), each step's `hint` (idle-step-NN), and `VOICE_FLOOR_FOUND`, `VOICE_HALFWAY`, `VOICE_FINISH`.
- **Export:** `voiceLines()` lists all of them. `tools/export-voice-lines.py` writes `Assets/BenchCoach/Voice/voice-lines.json`: 30 lines with stable ids, the longest 12 words. The exporter fails on a line over 12 words.
- **Wording change:** one hint was reworded ("lever B" became "the second lever").

### Placement changes outside the UI scripts

- **`BodyFollow`:**
  - The thresholds now compare the camera with where it was when the panel last settled. Turning the head 24° toward the dock moved its target more than 20 cm, so the dock glided away as you looked at it.
  - The turn threshold is now 55°.
  - The panel snaps on re-enable or when more than 150 cm away. The tray is hidden until step 3, and its first placement can come before the preview's camera pose lands, so it swept 2.7 m across the room when it appeared.
- **`WorkspaceAnchor`:** above. It re-anchors once if the eye jumps more than 5 cm in the first 1.5 s; the preview briefly reports the room's spawn point (70, 180, 304) after a room switch.
- **Builds moved to OnStart:** FloorPath now builds at OnStart. WheelStand and FloorAnchor rebuild on a re-anchor.
- **`StepDefinitions`:** step 5 `showTray` false (above).
- **`RepairManager`:** it pushes the callout anchor, the step number, the found state and the halfway card's cause.

### Critique rounds

- **Round 1** (24 states, Evening Room, from the recording pose):
  - On steps 3 and 4, the callout above the tire covered the ghost lever's handle and was cut off at the top of the view. **Fix:** the inside-the-rim default.
  - From the far side, the callout covered the ring. **Fix:** the live screen-space ring check.
  - The callout was larger than the view from about 35 cm. **Fix:** the apparent-size scale.
  - The edge arrow drew over the step-5 callout text. **Fix:** the arrow avoids all panels.
  - The dock glided away when looked at. **Fix:** BodyFollow.
  - The info callout sat behind the camera, because SIK `forward()` is the transform's +Z. **Fix:** the look direction computed as rotation x (0, 0, -1).
  - The info card hid behind the step callout. **Fix:** the candidate spots.
  - The leader ran behind the answer card. **Fix:** it now leaves the outline of callout and stack together.
  - Stop ran into the pill's round end. **Fix:** pill padding of half its height.
  - The tray and dock poked in at the frame edges. **Fix:** tray at yaw 25° / pitch -38°, dock at yaw -30° / pitch -30°.
  - The tray sat in the far side's line of sight. **Fix:** the same move.
  - The cards were high in the frame. **Fix:** lowered.
  - The dock labels were small. **Fix:** the button role is now Subheadline, and the counter uses body.
- **Round 2** (`shots/pass-d2/00..23`, `contact-sheet.png`):
  - The step-5 frame showed the empty tray. **Fix:** hidden on step 5.
  - The floor path is clean, with the edge arrow pointing back at the wheel.
  - All other states pass the checklist:
    - every line is readable at full resolution;
    - nothing is clipped;
    - no ring, handle, bead or valve is covered;
    - at most three panels are in view;
    - one plate, one grid, one set of roles;
    - cyan, amber and green each mean one thing.

### Button presses (preview mouse ray, two taps per new spot)

- **Method:** screen positions came from projecting world positions through the camera (fov 0.639 rad vertical, aspect 0.804). The Ask panel needed a measured correction of about 0.03.
- **Results:** every press logged only its own `[UI] … triggered by ray` and `press …` lines:
  - **Dock, step 4:** Replay (ghost replay, step stays 4), Back (4 to 3), Next (3 to 4), More (open), What's this? (on, off), Ask (on, off).
  - **Dock, step 2:** Replay (chime), Back (2 to 1), Next (1 to 2), More, What's this? (on, off), Ask (on, off), More (closed).
  - **Ask panel, step 4:** AskChip_0 (offline answer), BtnAnswerClose (chips back), BtnAskClose (Ask off).
  - **Start card:** Watch first (watch mode from step 1), then Stop on the pill (stopped on step 2); Found it (step 1).
  - **Halfway card:** Start over (step 0), Continue (step 8).
  - **Finish card:** Start over (step 0).
- **Taps right after a Lens reset:** they twice landed before the card was ready; a third tap fired.

### LEAF

- **Scenario changes:**
  - **Updated for the new names and layout:**
    - `control-bar`: six hit boxes in two rows, More, and every UI button ray-only;
    - `ask-coach-fallback`: answer in the chips' slot, both close buttons, the callout off the wheel;
    - `whats-this`: prompt and facts on the info callout, the step callout untouched; "beside the part" when the part is in view, otherwise "in view";
    - `start`: no badge, a floor line;
    - `seat-inflate`, `flat-causes`, `coach-report`: the two-column finish card;
    - `progress-idle`: the "4 / 10" counter and the hint state;
    - `mistakes`: the amber state;
    - `scene-dressing`, `floor-path`: positions relative to the start eye.
  - **Interactor:** the test interactor opens More before tapping What's this? or Ask.
  - **New `ui-layout`:** on every repair step, from the live eye:
    - the callout's screen rectangle does not cover the marker ring;
    - inside the rim, every corner is in the clear circle;
    - the leader ends at the ring;
    - the edge arrow is not on the callout or the dock;
    - no Text's rectangle crosses its plate (11 panels, including cards, Ask and the dock);
    - with Ask open, the callout and chips sit above or below the tire;
    - the info callout does not overlap the step callout for Tire, Valve and Hub.
- **Failures found and fixed:**
  - `refit-tube` failed from the recording pose: the new tube end was still near the world origin when grabbed, because of the BodyFollow sweep. The agent hand fitted it (1.6 cm) once the tray was in place.
  - `whats-this` failed because the camera looked down and the valve was out of view, so the card correctly moved into view.

| Scenario | Evening Room, recording pose | Sunlit Room, default pose |
| --- | --- | --- |
| `start` | PASSED | PASSED |
| `deflate-loosen` | PASSED | PASSED |
| `lever-snap` | PASSED | PASSED |
| `peel-and-pull` | PASSED | PASSED |
| `inspect-done` | PASSED | PASSED |
| `step-ticks` | PASSED (the first call timed out before the Lens started the run; rerun) | PASSED |
| `scene-dressing` | PASSED | PASSED |
| `refit-tube` | PASSED | PASSED |
| `seat-inflate` | PASSED | PASSED |
| `whats-this` | PASSED | PASSED |
| `mistakes` | PASSED | PASSED |
| `flat-causes` | PASSED | PASSED |
| `progress-idle` | PASSED | PASSED |
| `watch-mode` | PASSED | PASSED |
| `ask-coach-fallback` | PASSED | PASSED |
| `floor-path` | PASSED | PASSED |
| `coach-report` | PASSED | PASSED |
| `control-bar` | PASSED | PASSED |
| `floor-level` | PASSED | PASSED |
| `ui-layout` (new) | PASSED | PASSED |
| `jump-to-step` | PASSED | PASSED |

- **Floor during the sweeps:**
  - Evening Room: -178.6 cm via the world mesh in every run.
  - Sunlit Room, default pose: -138.4 / -138.2 via World Query in 15 of 16 decisions (no world mesh this session). Once the mesh came, it corrected to -150.4.
- **Inputs and log:**
  - All BenchCoach script inputs are set: 716 across 64 script components, except the 12 optional `TorusArc.bandMaterial` slots.
  - `RunAndCollectLogsTool` shows no Lens errors after the final recompile.
- **Scene save:** the project was saved through the MCP. The save re-created the LEAF Plugin Bridge, its MessagingBridge and the AiPreviewAgent Handler with new ids; that is committed separately.

Findings:

- **The preview's Lens world is the room.** Moving the preview camera does not re-anchor anything on reset; the workspace has to place itself from the start eye.
- **Camera timing at start:**
  - at onAwake the camera is at the origin;
  - by OnStart it has the pose;
  - after a room switch, the first frames can report the room's spawn point (y 180).
- **The preview camera's FOV** is 0.639 rad vertical, aspect 0.804: about ±18° x ±15°. A 74 cm wheel at 90 cm fills it, so nothing can sit beside the wheel; callouts go inside, above or below.
- **SIK `WorldCameraFinderProvider.forward()`** returns the transform's +Z, the opposite of the look direction.
- **LEAF drags** of a body-followed object need it to be in place first; a glide still in progress makes the drag miss.
- **`model.project.save()`** through `ExecuteEditorCode` saves the scene, and re-creates the LEAF and preview-agent helper objects.

Left over:

- **Lost screenshots:** the before screenshots (`shots/audit/`, `shots/verify-q/`) and round 1 (`shots/pass-d2/r1/`) were lost when the scratchpad was wiped by the restart. Only round 2 (`shots/pass-d2/00..23`) remains.
- **Sunlit Room floor:** from the default pose, without the world mesh, FloorLevel decides the sofa seat (-138) until the mesh comes (pass F's left-over). The recording uses Evening Room, where the mesh answered every time.
- **Ask and the What's this? prompt** stack above the tire on top-of-wheel steps. The top of the stack is about 20° up, so the recording should tilt up a little when Ask is open.
- **The callout covers part of the spokes and hub;** they are never worked.
- **The watch pill is on the dock,** out of frame unless the user looks down-left, as the brief placed it.
- **Text sizes** follow the Specs angular scale. They read at full resolution, but are small in frames downscaled for the video.
- **Untested:**
  - nothing in this pass was checked on Specs;
  - `WorkspaceAnchor` is a no-op there only if the Lens starts at the origin, as it does;
  - ray-only buttons still need a device check (pass F).
- **Extra reset:** once, an agent-hand drag right after a LEAF jump ran on a Lens that had reset about 5 s after the jump (cause not found). Repeating the jump worked.

## 2026-11-01: Pass G, target sizes and spacing (`docs/INFO_SESSION_OCT29.md` section 5.1)

First pass on Lens Studio 5.24.1. Snap's rule is a target of at least 2 degrees and a gap of at least 1 degree, measured on the collider. The Nov 1 audit listed every target under that; this pass applies the exact values it gave, so no new measuring was done.

| Target | Before | After |
| --- | --- | --- |
| Control bar (57 cm) | secondary buttons 3.9 cm, gap 0.5 (0.5 degrees) | buttons 3.5, gap 1.1 (1.1 degrees); Next stays 6. Bar 25.1 to 25.9 cm. Literal defaults and the scene values on `ControlBar`. |
| `ControlBar` position | (-2.35, -35.433, -44.664) | (-3.35, same, same). At 25.1 cm the bar's bounds already met the tray's (10.2 vs 10 in x); at 25.9 they overlapped by 0.6 cm. 1 cm left puts the right edge at 9.6, 0.4 cm clear, and the left edge at -16.3, inside the -18.25 the bar had before F4. |
| Start card: Found it and Watch (86 cm) | gap 0.8 | gap 1.6, `BtnFoundIt` 12 to 11.4 (the row still fills 21.6 cm) |
| Halfway card: Continue and Start over (90 cm) | gap 0.8 | gap 1.6, `BtnContinue` 12.4 to 11.6 |
| Ask question chips (89 cm) | chip 3.2, gap 0.5 | chip 3.6, gap 1.6 (defaults and the scene values on the `BenchCoachAskChipsUI` component) |
| Lever B while sliding on the rim (91 cm) | 12 x 2 x 1 box, 1.25 degrees | `RimDrag.arm()` sets 12 x 3.5 x 2 through a new `LeverPlacement.setColliderSize()`; `disarm()`, `completeInstant()` and the peel-complete branch restore the tray size, so the two tray boxes don't overlap |
| What's this? spoke | 2.5 x 16 x 2.5 | 4 x 16 x 4 |
| What's this? levers | 13 x 3 x 2 (0.2 cm apart in the tray) | 13 x 2.2 x 2 (1.0 cm apart) |

### LEAF

All 20 scenarios passed from the default preview camera, one per call, on the first run: `start`, `deflate-loosen`, `lever-snap`, `peel-and-pull`, `inspect-done`, `step-ticks`, `scene-dressing`, `refit-tube`, `seat-inflate`, `whats-this`, `mistakes`, `flat-causes`, `progress-idle`, `watch-mode`, `ask-coach-fallback`, `floor-path`, `coach-report`, `control-bar`, `floor-level`, `jump-to-step`. `control-bar` ran once more after the 1 cm move and passed. `RunAndCollectLogsTool` shows no Lens errors.

Findings:

- **A live `BoxShape.size` can be changed at runtime.** `LeverPlacement` keeps the shape it created and resizes it on request; the Interactable keeps working through the change (`peel-and-pull`, `watch-mode`, `mistakes` and `coach-report` all drag lever B through an armed resize).
- **Scene values were set on the components, not left to the recompile.** The scene flags these inputs as default (`ScriptInputsDefault`), but after pass F's lesson the values were written through `scene-graphql` and confirmed by read-back.
- **Lens Studio 5.24.1 opened the project cleanly;** the MCP, LEAF panel and the 5.23 permission dialog were not an issue in this session.

Left over:

- **The taller lever box is unproven with a hand ray.** LEAF's interactor triggers the Interactable directly, so the tests prove the resize doesn't break the drag, not that a ray hits 3.5 cm more easily. The B4 mouse walk should include a grab of lever B mid-peel.
- **The chips panel grew 4.5 cm taller** (14.9 to 19.4). `AskCoach`'s `maxElevationDeg` placement was not rechecked; `ask-coach-fallback` passes, but the panel's top edge from the start pose needs a look in the B1 check.
- **Sections 5.2 (show and hide) and 5.3 (color-only signals) of the audit are not started.**

## 2026-11-01: Pass G2, show it only when needed (`docs/INFO_SESSION_OCT29.md` section 5.2)

Joe's main Design point: things appear when needed and get out of the way after. The Nov 1 audit named three things that stayed up: the control bar (always on, covering the lowest edge of the tire), the Ask chips (open across steps, no timeout, blocking idle hints) and the Ask answer (no timeout).

| Item | Before | After |
| --- | --- | --- |
| Control bar | Always full | `BenchCoachControlBarUI` fades the bar to `faintOpacity` (0.3) while a lever or the tube end is held (`BodyFollow.isHeld()`, now public) or while the user looks at the wheel; it returns to full when any bar button is hovered by the ray, or the camera pitches down past `lookDownDeg` (22, with a 3 degree band so it doesn't flicker). Hover wins. `fadeSec` 0.3. The fade drives UIKit `Button.opacity`, each button's `ElementContent.opacity` (the icon; `Button.opacity` doesn't reach it), the BackPlate's `RoundedRectangle.opacity` and a new `ProgressRail.setOpacity()`. |
| Ask question chips | Open until toggled, What's this?, reset or watch mode | Also close after `chipsIdleSec` (10 s) without a chip press, an answer, an open or a step change. They still follow the step while open (`ask-coach-fallback` asserts that). |
| Ask answer | Up until the step changed or Ask closed | Also hides after `answerSec` (8 s) once a real answer is shown; the "thinking" text is never timed. |
| What's this? fact label | Over the wheel for hub and spoke | Not changed (the audit rated it low priority). |

`ProgressRail` now clones `MarkerMat` for the lit dots as well as the dim ones, with `BlendMode.Normal` on both clones (the asset has blending off), so the dots take an alpha. The dot colours are unchanged.

### LEAF

All 20 scenarios passed from the reset preview camera, one per call. `control-bar` gained a fade check: from the default pose the bar reads `faintReason` "wheel" at its faint opacity. The look-down and hover returns are not in LEAF (its interactor neither hovers nor moves the camera); they were checked by hand: `MovePreviewCamera lookAt (0, -35, -45)` brought the bar to full in the preview and in `CaptureRuntimeViewTool`, and `reset` sent it faint again.

Findings:

- **The preview camera's "default" is identity (pitch 0).** This session started at -12 degrees, left over from an earlier session; `MovePreviewCamera reset` gives 0. Both poses count as looking at the wheel for the fade.
- **`MovePreviewCamera rotate` with `pitch: -20` turned the camera to +89 degrees** (looking straight up), not 20 degrees down. Use `lookAt` with a point for an absolute pitch.
- **`RunAndCollectLogsTool` can return before the Lens has registered LEAF** when the log goes quiet for 800 ms during startup; the tail a few seconds later had everything. Don't read a short refresh log as a halted Lens.
- **Script fields don't show in `QueryRuntimeSceneTool`;** `components(filter:["ScriptComponent"])` lists only `scriptAsset`. Verify script state through LEAF or prints.

Left over:

- **The faint bar from the default pose changes the demo's look:** the bar is at 30 % until the user looks down or hovers it. If the video wants the bar solid in a shot, hover it or set `faintOpacity` to 1 on `ControlBar` for the take.
- **Hover counting assumes every `onHoverEnter` gets an `onHoverExit`.** If a button is destroyed or disabled mid-hover the count could stick at 1 and the bar stay full; no bar button is ever disabled today.
- **Watch mode and the far-side step were not re-looked-at for the fade.** During watch mode nothing is held and the user watches the wheel, so the bar is faint, which is what we want; untested by eye.
- **5.3 (colour-only signals) is not started.**

## 2026-11-01: Pass G3, no signal by colour alone (`docs/INFO_SESSION_OCT29.md` section 5.3)

The Nov 1 audit found three states told apart only by colour or brightness. Each now has a shape as well.

| Item | Before | After |
| --- | --- | --- |
| Progress rail, done steps | A brighter dot than the steps ahead | A small tick (`ProgressRail.buildTick`: two stretched spheres in the `StepTicks` proportions, `tickSizeCm` 1.4, in the lit material); the current step stays a pulsing dot, steps ahead stay dim dots. `tickCount` for LEAF. |
| What's this? and Ask toggles while on | UIKit's tint only; the icon never changed | The icon becomes a close cross while the toggle is on (`setToggleIcon`, on `onValueChange` and in the latched setters), back to info / help when off. `Assets/Icons/close.png` imported with `IconSelector` (Material Symbols, rounded, 600). |
| Mistake reason on the step label | Same white text as an instruction, plus the nope sound | `BenchCoachStepLabelUI.setText(reason, true)`: a warning badge just outside the panel's left edge and amber text (1, 0.82, 0.35); `warning` for LEAF. `CoachFeedback` passes `true`; every other caller leaves the default. `Assets/Icons/warning.png` imported the same way. |

### LEAF

All 20 scenarios passed from the reset preview camera, one per call. `progress-idle` now asserts three ticks on step 4 and nine on the Finish card; `mistakes` asserts the warning state with each reason and its clearing when the label comes back. The three visuals were checked in `CaptureRuntimeViewTool` after `jump-to-step` with `mistake` and with `part`.

Findings:

- **`IconSelector` imports land in `Assets/Icons`** next to the hand-placed icons, so `requireAsset("../../Icons/<name>.png")` works unchanged.
- **The first badge position (inside the panel's left edge) sat on the first letters:** the label text is centred across the whole panel. Outside the edge it reads as a badge and never collides.
- **`jump-to-step`'s `mistake` holds the reason for 30 s,** but an earlier capture still found the step label back: something refreshed it in between (likely the lever-B highlight path on step 4). A capture straight after the run is fine.

Left over:

- **The bar's "on" tint plus the cross is still UIKit's default style;** no contrast check was done against the additive display.
- **The rail ticks are 1.4 cm at 57 cm (1.4 degrees):** readable in the preview, not measured on glass.

## 2026-11-01: Pass G4, the scanning moment (`docs/INFO_SESSION_OCT29.md` section 6, item 4)

The audit's most valuable Design item: make "it sees what you see" visible. The wheel is hidden until Found it (the `start` scenario asserts it), so the moment plays *as* the wheel appears rather than before the pinch, and step 1 runs underneath it from the first frame.

**What was built.** `ScanReveal` (new `Assets/BenchCoach/Scripts/ScanReveal.ts`, on a new `BenchCoach/ScanReveal` object; inputs manager, wheel, valve, boxMesh, markerMaterial, audio). On the step change 0 to 1 a thin cyan line (the StepTicks box mesh, 0.6 x 86 x 0.5 cm, MarkerMat clone with normal blending) sweeps across the wheel from the user's left to right in `sweepSec` 1.2 s, 4 cm in front of the wheel plane. As it passes each spot a 3D text label pops on (0.4 to 1 scale in 0.15 s) with the audio tick: **Valve** 12 cm along the rim to the right of the marker (`valveLabelAlongCm`; straight above it is where the step label panel sits), **Rim** outside the tire at 11 o'clock (`rimLabelAngleDeg` 330, `labelOutCm` 4). The line goes when the sweep ends; the labels hold `holdSec` 2.5 s, fade over `fadeSec` 0.4 s, and everything hides. Reset hides it; `jumpToStep(1)` replays it (reset then go to 1); any other jump target does not. The start card's stand-in badge is untouched. Fields for LEAF: `playing`, `phase`, `labelsShown`, `plays`.

### LEAF

All 20 scenarios passed from the reset preview camera, one per call. `start` now asserts: the reveal is playing and sweeping 0.3 s after Found it with the line visible; after the sweep both labels are on, the line is off and the step is 1; after the hold and fade everything is gone. Seen in the preview with `holdSec` raised to 12 for the shot: "Valve" beside the marker, "Rim" at the upper left, both inside the camera's view from the start pose.

Findings:

- **`Text.size` on a world object is about 0.036 cm per unit** (the step label's size 33 is 1.2 cm tall). The first size, 9, drew a speck; 80 gives 3 cm letters. The sidewall marking at 12 is a 0.45 cm engraving, which is right for a sidewall.
- **Straight above the valve is taken:** the step label panel sits 10 cm above the marker, so a radial Valve label was hidden behind it. Along the rim's tangent it reads.
- **10 o'clock is outside the preview camera's view** from the start pose (and Specs' 32 degree width): 39 cm left at 86 cm. 11 o'clock at 22 cm is inside both.
- **`CaptureRuntimeViewTool` does not draw `Text`** (the sidewall marking is missing from its renders too). Use the Preview panel screenshot for anything with text.
- **Script inputs added after the first compile store their default on the next compile;** `holdSec`, `labelOutCm`, `rimLabelAngleDeg` and `labelSize` were set on the component as well so the scene holds the final values.

Left over:

- **No shot of the line mid-sweep;** it lasts 1.2 s. For the video, `jump-to-step` with `step` 1 replays it on demand.
- **The sweep is a line, not an outline that traces the wheel.** The audit wrote "an outline sweeps the wheel"; a line crossing it reads as a scan and cost one component. A rim-shaped outline (a TorusArc that draws itself round) is the richer version if there is time.
- **Hierarchy order:** `ScanReveal` is the last child of `BenchCoach`, after `RepairManager`, so its `OnStart` subscription lands after the manager's; it reacts to step changes only, so order does not matter today.

## 2026-11-01: Pass G5, the three Pass 12 layout bugs (`docs/INFO_SESSION_OCT29.md` B1)

Checked from the reset preview camera with `jump-to-step` and the Preview panel screenshot. Each bug had a cause the Pass 12 notes didn't name; none needed the Ask panels resized.

| Bug | Cause | Fix |
| --- | --- | --- |
| Step 6: the question chips clip about 2 cm at the left edge | The inspect step pulled the label 16 cm toward the user (so it sits in front of the hanging tube once the thorn is found) *while searching too*, when the label is simply above the wheel. At 74 cm the chips' outer edge (label.x - 23.5 cm) is 17.6 degrees out; the view's half-width is about 16. | `RepairManager.placeMarkerAndLabel`: the 16 cm only once `thornFound`; while searching the label is at the normal 4 cm. At 86 cm the same chips edge is 15.3 degrees: inside. |
| Steps 2 to 4: the answer's first line sits in the faded top edge | `AskCoach.maxElevationDeg` 18 is Specs' own top edge (about 18.5 degrees), so the answer flipped under the label only when it was already off the display. | `maxElevationDeg` 14 (default and scene value). And the flipped answer no longer goes *under the label*, where it covered the marker ring and the part and ran past the view's right edge on step 2: in the high case it sits under the question chips (left of the part, in reading order). The normal case is unchanged: above the label, next to the part. |
| Step 5: the label and answer sit behind the control bar from the start pose | The far-side label was at 6 o'clock, 71 cm below the eye at 86 cm (39 degrees down), the same band as the body-locked bar (38 degrees down, 45 cm out). | New `RepairManager.farSideLabelLiftCm` 20: the step 5 label sits at -51 cm (31 degrees down), above the bar's top edge, 8 cm above the tube end it points at. The marker ring stays on the tube end. |

### LEAF

All 20 scenarios passed from the reset preview camera, one per call; `ask-coach-fallback` (answer within 10 cm of the step 5 label) and `inspect-done` were run first. No scenario changes: these are placements LEAF doesn't assert, checked by screenshot: step 6 with Ask open (chips fully inside the view), step 2 with a canned answer (answer under the chips, marker clear), and step 5 looking 33 degrees down (label, answer and chips above the bar).

Findings:

- **The Ask timeouts from pass G2 race the screenshot workflow:** a `jump-to-step` run plus the call latency is about 10 s, so the first step 6 shot came one second after the chips had closed. For screenshot sessions set `chipsIdleSec` and `answerSec` to 60 on the `AskCoach` component, and put them back (10 and 8) before the sweep; both are restored in the committed scene.
- **Two of the three bugs were depth, not layout:** the same panel at 74 cm instead of 86 cm is 16 % bigger on screen.

Left over:

- **B4, the hands-on mouse walk,** is still untested (LEAF skips the ray).
- **The Ask panels are the friend's files** (`TEAM_TASKS.md` handoff); passes G, G2 and G5 touched `AskCoach.ts` and `BenchCoachAskChipsUI.ts` per the Nov 1 audit. Sujeeth is telling the friend; the changes are the chip size, the two timeouts, `maxElevationDeg` and the high-case answer spot.

## 2026-11-02: Pass G6, the hands-on mouse walk (`docs/INFO_SESSION_OCT29.md` B4, `TEAM_TASKS.md` F5)

The whole repair, What's this?, Ask, a mistake and the idle hint, driven through the preview's own mouse ray (SIK's `MouseInteractor`, the same path a person's mouse takes in the Preview panel) instead of LEAF's `trigger()`, which skips the ray. Start card to Finish card in one run from the reset camera, Plane room, SPECS 27: Found it, valve, four beads, lever A from the tray onto the ghost, lever B hooked and slid round to 5 o'clock, tube pulled, cause pinched, Continue, new tube fitted at the valve, four beads seated, valve held to inflate, Finish card, Start over; then Next twice, What's this? on a tray lever, and Ask with a chip. Every step fired through the real colliders. The synthetic SIK hand (`PreviewInteractTool`) could not reach a UIKit button in this project (pinch, poke and hover all time out), so the walk used `InjectPreviewGesture` touch events, which is closer to the mouse anyway.

| What | Result |
| --- | --- |
| Buttons (Found it, Continue, Start over, Next, What's this?, Ask, a question chip) | All fire from the ray. |
| Valve, beads, the glint, the valve hold | Fire on release; the 2.5 s hold inflates from 0 to 100 %. |
| Lever A and B, tube end, new tube end | Grab, carry and drop with `InteractableManipulation`; snaps at 1.5, 1.9, 0.9 cm. |
| Rim slide | Lever B swept 30 to 150 degrees across two head turns; beads 1 to 3 peeled in order. |
| What's this? over a grabbable lever | The info box wins: the fact label shows, the lever does not move. |
| Mistake with the ray | Valve on step 9 gives "Seat the bead first, or the tube pinches." |
| Idle hint | Fires at 12 s on every step it was given the chance (12 hints in a 17 minute run). |
| Ask | Chips open from the bar, a chip answers (canned, offline tag), the answer sits under the chips (G5 high case). |

Fixes from the walk:

| Bug | Cause | Fix |
| --- | --- | --- |
| The tool tray slides away when you turn to look at it | `BodyFollow` glides once the yaw-carried target is 20 cm from the panel. The tray's horizontal offset is 44 cm, so a 26 degree turn moves its target 20 cm, but the tray itself sits 35 degrees to the right: looking at it always moved it, and then it sat 35 degrees right of the new heading. On Specs it could only ever be seen at the right edge of the display (turn 19 to 26 degrees). | `moveThresholdCm` 20 to 35 and `turnThresholdDeg` 35 to 45 on both panels (defaults and scene values). A 35 degree look moves the target 26 cm: nothing glides. Both panels keep the same numbers, because a bar that followed under a tray that stayed overlapped it (seen when only the tray was changed). Walking 35 cm or turning 46 degrees still brings both along. |
| Finish card: "Slowest: Lever 14:52" | Step 3's short name is "Lever 1", so "Lever 1 4:52" reads as fourteen minutes. | `STEP_SHORT_NAMES[3]` "Lever A" (the step 4 hint already says "lever B"). |

### Mouse recipe (for the video and anyone testing by hand)

- **A click fires on release, and the ray must already be on the target.** With a real mouse the hover comes free; with injected touches a `start` at a new spot only moves the ray, so the walk primed each new target with one click and fired with the second. Beads, the valve and the glint act on `onTriggerEnd`, so they fire on the first click; buttons, grabs and the valve hold need the second.
- **A grab keeps the part at its grab distance from the eye.** The mouse has no depth, so a lever grabbed in the tray (52 cm away) can only be dropped on a socket that is also about 52 cm away: walk forward (W) until the wheel is about 38 cm in front of you, grab, turn your head to the ghost, drop. Snap radius is 4 cm (tube end 5 cm). Hands on Specs move in depth and do not need this.
- **Turn your head while holding;** the panels hold still while a part is held, and the part follows the ray.
- **The rim slide and the tube pull are depth-free:** `RimDrag` takes the angle in the wheel plane, `TubePull` the distance from the wheel center, so the cursor only has to sweep along the rim or pull down past 48 cm from the center.
- **The Ask chips close 10 s after opening and the answer 8 s after it shows**, so click a chip straight after Ask.
- **Everything is measured from the reset camera (pitch 0, origin).** `MovePreviewCamera reset`, not `rotate`.

### LEAF

All 20 scenarios passed from the reset preview camera after the two fixes, one per call (`start`, `deflate-loosen`, `lever-snap`, `peel-and-pull`, `inspect-done`, `step-ticks`, `scene-dressing`, `refit-tube`, `seat-inflate`, `whats-this`, `mistakes`, `flat-causes`, `progress-idle`, `watch-mode`, `ask-coach-fallback`, `floor-path`, `coach-report`, `control-bar`, `floor-level`, `jump-to-step`). `coach-report` only checks that each time entry ends in m:ss, so "Lever A" needed no test change; `floor-path` walks 60 cm, so the panels still follow it.

Findings:

- **The synthetic SIK hand does not reach this project's interactables.** `PreviewInteractTool` Pinch, Poke and Hover on `BtnFoundIt` all timed out waiting for `onTriggerStart`, with `AiPreviewAgent Handler` present and the puppet hand parented in the scene. The mouse ray works, so the walk used it; the hand path was not debugged.
- **Injected touches are not a mouse.** The preview delivers no hover move without a button, so a `start` at a new spot moves the ray and pinches in the same frame, and the target is not yet hovered when the pinch starts. A real mouse hovers first. Script code needs no change; the notes above say which parts fire on the first click anyway.
- **The watch demo is too quick for a grab test through the tools:** its beats are 3.5 s and a tool round trip is about 3 s, so the lever and the new tube end had flown each time. `RepairDirector.halt("grab")` stays reasoned, not seen.
- **From the start pose, half the loosen beads are outside the view** (beads 2 and 6 at 30 cm left and right of center; the view is 23 cm wide at 90 cm). The user turns the head, which is the point of the wheel-sized layout, but the video take should show it.
- **Close up, the step 4 label runs off the right edge:** at 38 cm from the wheel the label at 1 o'clock is cut. It is fine from the start pose, where every label was checked in pass G5.
- **Hover on a bar button pulls the bar back to full opacity** even when the head is up (pass G2 rule), seen while clicking Next from the lever pose.
- **`Finish` card stats are honest about a slow run:** 17:01, Hints 12, Mistakes 1, "Practice next: seat every bead before you pump."

Left over:

- A grab during watch mode by a person (one try, lever B at step 3, within about 5 s of the tray appearing).
- The puppet hand (`PreviewInteractTool`) in this project: why SIK's hand interactor never targets the UIKit buttons here. Not needed for the hackathon.
- The watch-mode screen recording (section 6 item 6) still needs a person to press Record.

## 2026-11-04: Pass G7, the mistake reason survives an idle hint

Found while cutting the demo video: in every recorded take of the lever B mistake the label never turned amber. The takes had a ten second lead-in, so the idle hint (12 s) was showing when the lever dropped. `CoachFeedback.mistake()` wrote the reason, and in the same frame `UIBindings` forwarded the mistake to `IdleHint.touch()`, which saw a hint showing and called `RepairManager.refreshLabel()`, rewriting the step text over the reason. By hand (no lead-in) it never happened, and the `mistakes` scenario pinches straight away, so neither caught it.

Fix: `refreshLabel()` returns while `feedback.showing` is true. The reason's own 2.5 s timer clears `showing` before it restores the label through the same method, and `cancel()` clears it on a step change, so nothing else waits on it.

Verified by hand: jump to step 3, 14 s idle (hint fires), grab lever B, drop at the rim: label "First lever first. Hook the other one." in amber. LEAF after the fix: `mistakes`, `progress-idle`, `whats-this`, `inspect-done` (see below).

Video notes from the same session: Lens Studio has no garage room (Plane, Sunlit Room, Evening Room, Colorful Home, two outdoors); the LEAF status line is hidden per run with `__leaf__log_level=WARN`; a bare injected `move` hovers a target, and a button or lever then needs one click, sometimes two, after a camera move; macOS screen recording captures no Lens audio; resizing or scrolling the Preview panel mid-take resets the Lens or pushes the camera back.

LEAF after the fix, reset camera, one per call: `mistakes`, `progress-idle`, `whats-this`, `inspect-done` all PASSED.

## 2026-11-05: Pass M, Sujeeth's G passes on the D2 UI

On `main`. `origin/Sujeeth-AR-SPECS-WORK` (passes G to G7, Nov 1 to 4, built on the old UI) merged with `--no-ff`, so his seven commits and authorship stay in history. Policy: D2's UI architecture wins; every intent of his that still applies is carried onto it; nothing of his is dropped silently. Built through the CLAD skills and the Lens Studio MCP, one call at a time.

### The merge

- **Conflicts:** 20 files. The UI files rebuilt in D2 (dock, step callout, cards, ProgressRail, BodyFollow, chips) took D2's side; his intents on them came back as separate commits. `AskCoach` kept D2's slot plus his two timers. `Assets/Icons/close.png` was byte-identical on both sides; main's meta was kept.
- **`Assets/Scene.scene`:** main's, not hand-merged. His scene changes were re-applied through the Editor API (`VirtualScene`, `scene-graphql`) and saved.
- **Design notes:** every entry from both sides, in date order (D2's Oct 29 entry, then his Nov 1 to Nov 4 entries).
- **Docs kept as he wrote them:** `devpost/video-script.md`, his `docs/INFO_SESSION_OCT29.md` and `docs/TEAM_TASKS.md` changes.
- Lens Studio pauses its TypeScript compiler while a git merge is in progress, so the merge was type-checked with the same `lensifyts tsc-only` command against the project's `tsconfig.json` (no emit) before the merge commit.

### Each G pass on D2

| Pass | Item | On D2 |
| --- | --- | --- |
| G | Card button gaps | **Ported.** `UIHelpers.targetCm(d, deg)` holds the rule. The card button gap is at least 1 degree (1.48 cm on the start card at 85 cm, 1.43 cm on the halfway card at 82 cm). Found it and Watch are 11.2 cm, Continue 12.6 cm. |
| G | Ask chips | **Ported.** His 3.6 cm chips with 1.6 cm gaps (2.3 and 1.0 degrees at 90 cm; D2 had 2.7 and 0.35). |
| G | Lever B's armed box, spoke and tray-lever What's this? boxes | **Kept from the merge** (`RimDrag`, `LeverPlacement.setColliderSize`, `PART_FACTS`). |
| G | Dock (new in D2) | **Adapted.** Buttons 3.6 cm (4.3 degrees at 48 cm) already passed. Gaps were 0.45 cm (0.54 degree); now 0.85 cm (1.0 degree). |
| G | Ask close buttons (new in D2) | **Adapted.** `BtnAskClose` and `BtnAnswerClose` were 2.2 cm (1.4 degrees); the header rows are now at least 2 degrees (3.14 cm at 90 cm). |
| G | Control bar 1 cm left, clear of the tray | **Moot.** D2's dock is on the opposite side from the tray. |
| G2 | Ask closes after 10 s without a chip press; answer hides after 8 s | **Ported.** The chips' clock runs only while they are up and restarts when they come back, so an 8 s answer is not followed by a 2 s flash of chips. |
| G2 | Ask on a step change | **Adapted to the brief.** Ask now closes on a step change (his version kept it open and refreshed the chips). The dock's toggle releases through `onOpenChanged`. |
| G2 | Answer at the next sub-step | **Added.** A new sub-step (a bead, a peel) hides the answer, and the chips come back in the slot. |
| G2 | Control-bar fade | **Not ported.** D2's dock sits at yaw -30, pitch -30 at 48 cm, out of frame from every working pose. His fade existed because the old bar sat in view under the tire. |
| G3 | Toggle on-state | **Ported.** What's this? and Ask (in the More popover) show the close cross while on. D2 draws the icon as an Image, so the swap is a new `UIHelpers.setButtonIcon()`, not his `ElementContent.leadingIcon`. |
| G3 | Mistake badge | **Ported onto D2's amber state.** His `warning.png`, tinted amber, sits on the plate's left edge, level with "Not quite". Half of it is inside the padding, so it never touches the text. |
| G3 | Rail ticks | **Moot.** D2 replaced the dots with segments, and the dock's "4 / 10" counter gives progress in text. |
| G4 | Scan reveal | **Ported and rebuilt in D2's style** (below). |
| G5 | Step 6 chips clipping the left edge; step 5 label behind the bar | **Moot.** D2 keeps the callout's apparent size and moved the dock. Checked: step 6 with Ask open, everything in view. |
| G5 | Answer's first line in Specs' faded top edge | **Still there on D2, and worse; fixed.** With a stack hung under it, D2 put the callout above the tire: with the chips open on step 2 its top was about 27 degrees above the eye (24 before the G chip sizes; Specs ends at about 18.5). Callout and stack now try D2's inside-the-rim search as one box first, and fall back to above or below the tire only if they don't fit. Measured top: 1.1 to 3.3 degrees below the eye on steps 2, 3 and 6. |
| G6 | Tray slides away when looked at | **Moot.** D2's BodyFollow compares the camera with its settled pose (55 degree turn). Checked: looking straight at the tray (25 degrees right, 40 down) left its world position unchanged. |
| G6 | "Lever 1 4:52" | **Kept.** "Lever A", also in D2's Finish card placeholder. |
| G7 | Mistake reason survives an idle hint | **Ported** to D2's label path (`refreshLabel` returns while `CoachFeedback.showing`). `mistakes` now covers it. |

### The scan reveal on D2 (G4)

- **The sweep is the audit's outline.** Two bright heads leave 6 o'clock and run up both sides, hugging the tread (120 exact chords at 35.2 cm), and meet at the valve, where step 1's marker is, in 1.4 s, fast out and slowing in. The trail is a thin accent ring. It flashes as the heads meet, settles dimmer, holds 2.5 s and fades in 0.4 s. A chime plays as they meet.
- **Labels in the What's this? look:** D2 plate, title role, a neutral edge that flashes the accent as each pops, and a grey leader. Rim pops first, then Valve as the heads meet, then Hub; each plays his tick.
- **Placement:** from the recording pose only 4 cm of view is left above the tire and its sides are cut, so a first try with the labels above the tire was clipped at the top. They sit inside the rim: Valve right of the marker above the step callout, Rim at the left with a short leader to the rim, Hub right of the hub.
- **Tire radius:** 34.6 cm with the tread, measured on screenshots against the valve (27 cm above the hub). His 38 cm floated the outline 2 cm off the tread; the Tire's bounds report 38.5, which is larger than the visible tire.
- **Real input:** Found it pressed with the preview mouse. For the shots `sweepSec` and `holdSec` were raised to 12 and 15, then restored to 1.4 and 2.5 before the save:
  - mid-sweep: `scratchpad/shots/merge/g4-02-sweep.png`;
  - labels after the meeting: `scratchpad/shots/merge/g4-03-labels.png`.
  The step callout reads "Hint" in both only because the stretched sweep let the 12 s idle hint fire.

### Checked with real input (preview mouse, two taps per new spot)

- **Mistake with the badge, after an idle hint:**
  - Step 1, hint showing; a bead tapped before deflating.
  - The callout stayed amber with the badge and "Let the air out first. Pinch the valve." (`v-04-mistake-still-up.png`; `showSec` raised to 8 for the capture, then restored).
  - At 2.5 s the reason ran out before a capture could land (the tool round trip is about 2 s).
- **Ask timing out:** opened from the popover at 14:04:58.22, closed itself at 14:05:08.24, and the toggle went back to its help icon (`v-07-ask-on.png`, `v-08-ask-timed-out.png`).
- **Every button logged `triggered by ray` once and did only its own job:**
  - dock: Next (0 to 1, 1 to 2), Replay (chime, step kept), Back (2 to 1), More (open);
  - popover: What's this? on and off (`v-06-whatsthis-on.png` shows the cross), Ask on;
  - Ask panel: AskChip_0 (offline answer), BtnAnswerClose (chips back), BtnAskClose (Ask off);
  - watch pill: Stop (stopped on step 3);
  - start card: Found it, Watch first;
  - halfway card: Continue (7 to 8), Start over (7 to 0);
  - finish card: Start over (11 to 0).
- **Ask chips by mouse:** `chipsIdleSec` and `answerSec` were raised to 60 for the presses, then restored: the round trip from the dock to the wheel is longer than 10 s.
- **Inputs:** 731 BenchCoach script inputs across 66 components are set, except the 12 optional `TorusArc.bandMaterial` slots. No Lens errors after the final recompile.

### LEAF

- **Scenario changes:**
  - `start`: the D2 reveal (trace part-way at 0.3 s, closed outline and three labels in the hold, all gone after the fade);
  - `mistakes`: the badge on and off, and the G7 case (hint showing, valve mistake, amber still up 1 s later);
  - `control-bar`: the toggle icons; his fade asserts removed (no fade on D2);
  - `progress-idle`: his tick asserts removed (moot);
  - `ask-coach-fallback`: Next closes Ask, both timers (shortened in the test), the answer hiding at a bead, the inside zone;
  - `ui-layout`: Ask on steps 2, 3, 5 and 6, chips and answer, inside the clear circle or off the tire, top at most 14 degrees above the eye;
  - `inspect-done`: waits for the reveal's label ticks on step 1 before counting Replay's.
- **Sweeps:** one scenario per call, `__leaf__log_level=ERROR`, the project saved first.

| Scenario | Evening Room, recording pose | Sunlit Room, default pose |
| --- | --- | --- |
| `start` | PASSED | PASSED |
| `deflate-loosen` | PASSED | PASSED |
| `lever-snap` | PASSED | PASSED |
| `peel-and-pull` | PASSED | PASSED |
| `inspect-done` | PASSED (first run failed on the reveal's ticks, fixed in the test; one rerun timed out at about 60 s after the Lens had finished, then passed) | PASSED |
| `step-ticks` | PASSED | PASSED |
| `scene-dressing` | PASSED | PASSED (the first call timed out while Lens Studio took 2 minutes to reset; rerun) |
| `refit-tube` | PASSED | PASSED |
| `seat-inflate` | PASSED | PASSED |
| `whats-this` | PASSED | PASSED (the first call stalled on its first button tap with Lens Studio at about 200% CPU; skipped and rerun last) |
| `mistakes` | PASSED | PASSED |
| `flat-causes` | PASSED | PASSED |
| `progress-idle` | PASSED | PASSED |
| `watch-mode` | PASSED | PASSED |
| `ask-coach-fallback` | PASSED | PASSED |
| `floor-path` | PASSED | PASSED |
| `coach-report` | PASSED | PASSED |
| `control-bar` | PASSED | PASSED |
| `floor-level` | PASSED | PASSED |
| `ui-layout` | PASSED | PASSED |
| `jump-to-step` | PASSED | PASSED |

- **Floor during the sweeps:**
  - Evening Room: -179.2 cm via the world mesh in 24 decisions (one -191.2).
  - Sunlit Room: -178.4 via the world mesh in 17, and -138.4 / -138.5 via World Query in 6 (the sofa seat, D2's left-over).

Findings:

- **Lens Studio crashed once,** during the first `ui-layout` run (after `control-bar` and `ask-coach-fallback` had passed). The scene had been saved before the crash, so no values were lost; `ui-layout` passed on every later run.
- **The tool round trip (about 2 to 3 s per call) is longer than several timers:** the 2.5 s mistake reason, the 10 s Ask clock across a camera move, and the scan reveal. Real-input captures need those timers raised on the component for the shot, then put back.
- **Edit-time `setProperty` resets the preview Lens,** so a timer change for a capture also sends the Lens back to the start card.
- **`/opt/homebrew/bin/python3` (3.15) has no Pillow on this machine;** it is installed for another Homebrew Python, so no contact sheet was made.

Left over:

- **`devpost/video-script.md` still describes the old UI:** "scan line ... Valve and Rim labels" (0:25 row), "control bar low" (0:10 row), "all 20 scenarios" (now 21), and the Plane room (the recording room is Evening Room). It is his narration; it was kept as written.
- **Step 6 with Ask open:** the chips cover the middle of the hanging tube, which is not worked on that step.
- **Lens Studio reported the user as not signed in** (`isAuthorized` false). Nothing in this pass needed it.
- **Untested on Specs:** everything in this pass.

## 2026-11-05: Pass H, a garage preview room

On `main`. The demo video is recorded in the Interactive Preview, whose simulated room is the "real world" the Lens sits in. Bench Coach is a garage job, so the recording now happens in a home garage instead of Evening Room. The room is a preview stand-in only, in `preview-room/` (see its README); nothing in the Lens changed. Built through the Lens Studio MCP, one call at a time.

### How the room is built

- **The format, read from the built-in rooms:** their `scene.scn` is a tagged binary tree (a string table, then type, key and length records), decoded with a small script.
  - Every room has `WorldTrackingMeshSimulator > meshes` holding all its meshes, props included. Sunlit and Evening Room put the sofa, tables and shelves there too.
  - `NavigationNodes > Start` is at eye height with identity rotation, facing -Z: (0, 150, 0) in Plane, (70, 180, 304) in Sunlit and Evening Room. Its `Camera` child has deviceProperty All.
  - The floor is at y 0. The preview puts the Lens camera at Start.
  - Colorful Home adds a top-level `Lighting` (an envmap and a light with shadows), so lights and shadows are allowed.
- **The project:**
  - `setDefaultProject()`, then `saveTo` `~/dev/bench-coach-garage-room/GarageRoom.esproj`.
  - Start at (0, 165, 0): the eye is 165 cm above the garage floor and the Lens needs no offset.
  - Floor plane 600 x 560 cm, walls, ceiling.
- **Back wall (behind the wheel):** a dark slate roll-up door with section joints, tracks and an opener. It is kept medium-dark because the preview adds the Lens's light over the room.
- **Left wall:** a 172 x 62 cm workbench (top 90 cm) with a vise. Above it, a dark charcoal pegboard with hex keys, tire levers, a chain whip, a hammer, a hacksaw and the Tools Pack hand tools. Also a warm clamp lamp, a tall cabinet, a paint-can shelf, a broom and roll carts.
- **Right wall:** a red tool chest in the back corner, shelving with bins, a road bike and a mountain bike hung vertically on hooks, a floor pump and two spare tires on a hook.
- **Front wall:** an entry door and a fire extinguisher.
- **Lights:** an envmap at 0.35, a warm directional light with shadow maps, two LED shop-light points, a warm clamp-lamp point, a right-wall fill and a dim cool ambient. Floor and walls receive shadows; props cast them.
- **Clear floor:** x -130..130, z -260..60, around the stand, mat and floor path.
- **Asset sources:**
  - Lens Studio primitives for the shell and most fittings.
  - `GenerateFast3DAssets` for the two bikes, the tool chest and the vise (about 30k triangles each). The first road bike came out as two bikes crossed and was regenerated. The floor pump was refused twice ("ALD verification failed") and is primitives.
  - `GenerateTexture` for the door and the concrete base. Its drywall and pegboard textures came back blank.
  - Python (PIL and numpy) for the worn floor, the pegboard and the butcher-block top.
  - The Asset Library Tools Pack for the hand tools.
- **Licences:** no licence text was found for the Tools Pack or the generated output. The package and its listing carry none, and Lens Studio's documentation search needs a signed-in account. The README says so.

### How it is exported and selected

1. The CLI refuses a project that is open in the GUI ("Project is currently in use by another instance"), so the saved project is copied without its lock, `Cache/` and `Workspaces/`.
2. Export: `"/Applications/Lens Studio.app/Contents/MacOS/Lens Studio" export-lens --source <copy>/GarageRoom.esproj --output <tmp> --pack Folder --include-all-platforms`. It writes `<tmp>/GarageRoom/` in about 75 s.
3. The folder moves to `preview-room/Garage/` (23 MB).
4. The export has no `checksum.json`, so one is written in the built-in format: base64 MD5 per file, which matches 17 of Plane's 19 entries.
5. In Bench Coach: `PreviewPanelTool setConfig` (Interactive, sourcePath the folder). After a project switch or a restart the preview came back on a built-in room twice, so select it again.

### Floor and placement

- **FloorLevel decides -165.0 cm via World Query** in every Garage reset:
  - 40 to 49 hits in 37 to 41 cells when the reset happens looking down;
  - 10 hits in 10 cells from the card pose;
  - about 11.3 s after the reset.
- The bench top (75 cm below the eye) is never picked. The only other decision in the sweep, -177, is the lower level that `floor-level` injects on purpose.
- WheelStand rebuilds on -165 with the hub 140 cm above it. WorkspaceAnchor logs "start eye (0.0, 0.0, 0.0): nothing moved".
- Stand, mat and floor path stand on the floor; nothing intersects the room.
- **Recording pose:** the start eye (0, 0, 0), lookAt (0, -16, -90). The working pose for every state and two wide establishing poses are in `scratchpad/recording-pose-garage.md`, each checked with a capture.

### Critique rounds (`scratchpad/shots/pass-h/`)

- **Round 0** (`author-r0-*.png`, the garage project's own camera, wide field of view):
  - The floor was near-white and would sit behind the wheel. **Fix:** toned down to a warm mid grey.
  - The walls read charcoal, not mid grey. **Fix:** raised.
  - The spare tires looked like donuts (the unit torus has a 22 cm hole). **Fix:** rebuilt as rings of 24 segments.
- **Round 1** (`r1-00..09`, in Bench Coach: start card, steps 1, 3 and 5 (path and far side), step 6 found, halfway, finish, two wide shots):
  - Cards, callouts, cyan rings and the floor-path chevrons all read against the dark door and the floor. Nothing in the room draws through the Lens content.
  - The bench top read as orange tiles. **Fix:** a muted butcher-block texture.
  - The right wall (bikes, shelves) was murky. **Fix:** a warm fill light near it, away from the door.
  - **Added:** a fire extinguisher, a power strip and a broom, so the room reads as a garage.
- **Round 2** (`r2-00..09`, `contact-sheet.png`, `compare-r1-r2-wide.png`): every frame passes. The wide shots read as a home garage at first glance: pegboard, bench, door, chest, shelving, bikes.

### LEAF

One scenario per call, `__leaf__log_level=ERROR`, the project saved first, Garage room, from the recording pose. Lens Studio closed during `step-ticks`; after the relaunch the sweep resumed at `step-ticks`.

| Scenario | Garage room, recording pose |
| --- | --- |
| `start` | PASSED |
| `deflate-loosen` | PASSED |
| `lever-snap` | PASSED |
| `peel-and-pull` | PASSED |
| `inspect-done` | PASSED |
| `step-ticks` | PASSED (the first call was cut off when Lens Studio closed; passed after the relaunch) |
| `scene-dressing` | PASSED |
| `refit-tube` | PASSED |
| `seat-inflate` | PASSED |
| `whats-this` | PASSED |
| `mistakes` | PASSED |
| `flat-causes` | PASSED |
| `progress-idle` | PASSED |
| `watch-mode` | PASSED |
| `ask-coach-fallback` | PASSED |
| `floor-path` | PASSED |
| `coach-report` | PASSED |
| `control-bar` | PASSED |
| `floor-level` | PASSED |
| `ui-layout` | PASSED |
| `jump-to-step` | PASSED |

Left over:

- **Licences** for the Tools Pack and the generated assets are unconfirmed (see the README).
- **The garage project still lists the unused Vehicle Pack** (installed while looking for a bike). It cannot be removed ("Cannot remove packed package items"). None of its content is in the export; only its name is in `metainfo.json`.
- **The exported `metainfo.json` says `api_level` "public"**, where the built-in rooms say "private". The room loads either way.
- **Ask open on step 4:** the chips hang under the callout inside the rim, so the D2 look-up pose cuts them off here. The garage pose doc uses (2, -16, -90).
- **`devpost/video-script.md`** still says "All takes: Plane room" (line 30). It is his narration and was not edited in this pass; the recording room is now the Garage.
- **Untested on Specs:** nothing changes there; the room is preview-only.

## 2026-11-05: Pass V, the voice coach and video polish

On `main`. The coach now speaks, and the Lens was judged as a video frame in the Garage room from the recording pose. Built through the CLAD skills (`specs-audio`, `icon-selector`, preview inspection, LEAF) and the Lens Studio MCP, one call at a time.

### The voice coach

- **Clips:** 30 mp3 files, one per id in `voice-lines.json`, in `Assets/BenchCoach/Voice/<id>.mp3` (Git LFS, 30 files). 1.4 to 3.2 s each.
- **Attribution:** voice lines generated with ElevenLabs (elevenlabs.io), voice "River", on the free tier, which requires this credit. The repo has no credits list, so the line lives here.
- **Spoken texts:** unchanged. `tools/export-voice-lines.py` writes the same `voice-lines.json`.
- **Where:** `VoiceCoach` on BenchCoach plays every line from one AudioComponent on `Audio/Voice`. It is not spatial (the coach in your ear) and plays at volume 1.0; the cues play at 0.25 to 0.5 from where they happen.
- **Tracks:** one array input. The script matches tracks to `voiceLines()` ids by asset name and logs an error naming any id without a track. At start it logs "30 voice tracks, one per line".

| When | Line | Why |
| --- | --- | --- |
| A step 1 to 10 becomes active | `step-NN`, 0.4 s after the step change | After the step's own cue (done, finish, chime), so they never collide |
| Step 1 | `step-01`, held until the scan reveal's heads meet | Nothing speaks during the 1.4 s sweep |
| Halfway card (step 7) | `halfway` instead of `step-07` | The card is the step |
| Finish card (step 11) | `finish` | |
| A mistake | `mistake-<code>`, 0.25 s after the nope cue | It cuts off whatever plays: the reason matters now |
| The idle hint shows | `idle-step-NN`, 0.4 s after the hint's chime | |
| The start card turns to "Floor found" | `floor-found`, once | The first sign that the Lens sees the room |
| Replay | the step's line again | Replay re-shows the step; now it also re-says it |

- **Rules:**
  - one line at a time; a new line stops the old one;
  - a line never starts again within 6 s of its last start. This includes Replay: a second Replay inside 6 s is silent and logged as a skip;
  - while a line plays, hiss, pump and zipper play at half volume (`BenchCoachAudio.setDuck`);
  - Back to the start card or a reset drops a queued line.
- **Watch mode:** each beat now also waits until its line has been said, at most 4 s more (`RepairDirector.voiceHoldMaxSec`). Before, step 1's line would have been cut off by the valve pinch at 3.5 s. In the `watch-mode` run every line played to its end (no `[Voice] stop` line).
- **Voice toggle:** "Voice" on its own row in the dock's More popover, on by default. It latches in the accent and shows `volume_up`; off shows `volume_off` (icon tool, Rounded 600), so the state is never colour alone. Off stops the current line at once.
- **More popover:** a choice in it (What's this?, Ask, Voice) now closes it. With the Voice row the open popover reached into the recording frame from the dock while Ask was open.

### Log lines for rebuilding the soundtrack

- Formats:
  - `[Voice] <id> ms=<Date.now()> dur=<seconds>` when a line starts;
  - `[Voice] stop <id> ms=...` when a line is cut off;
  - `[Audio] <cue> ms=<Date.now()> vol=<volume>` for every cue `BenchCoachAudio` plays (the logged volume includes the duck);
  - `[Audio] pump stop ms=...` when the pump loop ends;
  - `[Sync] ms=<Date.now()> lensTime=<getTime()>` once at start.
- Examples from the `voice-coach` run:
  - `[Voice] step-03 ms=1793915524867 dur=2.64`
  - `[Audio] nope ms=1793915525009 vol=0.40`
  - `[Voice] stop step-03 ms=1793915525027`
- **Clock check:** `Date.now()` works in the Lens runtime and is the Mac's wall clock. `[Sync] ms=1793915424452` was printed on the log line stamped 15:50:24.452, the same millisecond. Later, `[Voice] floor-found ms=1793918541725` was followed by `date +%s` = 1793918541 and Python's `time.time()` = 1793918541770, 45 ms later, the time it took to run the command. Offset: 0 within the log's 1 ms resolution.
- **Audio map:** `scratchpad/rec/audio-map.json` lists every cue and voice id with the absolute path of its source file, the volume it plays at, whether it is spatial, loops or ducks, and the voice text.

### Visual polish

Captures in `scratchpad/shots/pass-v/` (`before/`, `r1/`, `r2/`, `contact-sheet.png`, `before-after.png`).

| Item | Before | After |
| --- | --- | --- |
| Type scale (`UIHelpers` tokens) | Body and instruction lines had an x-height of 0.52 to 0.66% of the frame height from the recording pose, titles 1.27% | Role sizes at 110 cm: title 165, instruction 118, body 118, secondary 66, button 64 (D2: 93, 48, 39, 38, 41). Measured: card body 1.56 to 1.68%, step instruction 1.62%, titles 2.3%. Plates grow with the text through `plateCm()` (1.6 times the D2 width, capped at 25 degrees). `ui-layout` asserts the minimum (0.55 and 0.81 degrees of x-height) from the live eye |
| "5 o'clock" on step 4 | Wrapped as "5 / o'clock" (`before/pose-step04.png`) | `keepTogether()` puts a no-break space after the number at display time; the step texts and voice lines are unchanged (`r2/04-step04.png`) |
| The tire | A flat grey band | Two light lines from `RimMat` (one on the outer shoulder, one where the tire meets the rim), part of each bead's mesh in `TorusArc`, so they lift, peel and deflate with it; the darker tread band with its blocks is unchanged |
| Step 5 far side | A light grey mat slab with a 7 cm blue band filled the bottom of the frame; the yaw-only callout was seen edge-on (text about 1.0% of the frame) | The mat is a dim fill with a thin light outline. A stand-here marker at the far spot: cyan outline, dim fill, two shoe prints toward the wheel; the chevron chain ends at its edge (6 arrows). On the far side the callout also turns in pitch (text 1.6%) (`r2/05a`, `r2/05b`) |
| Finish card | Time and counts in body text in a list | Time, Lever misses, Mistakes and Hints as big numbers (new display role) with captions; Cause and Slowest stay a list; 6 cm lower so it is centred in the frame (`r2/11-finish.png`) |
| Watch mode | The "Watching the coach" pill lived on the dock, out of frame | A small "Watching" pill with an icon Stop floats above the tire, left of the valve, clear of the lever handles; Stop goes through `UIBindings.press` (`r2/14-watch-mode.png`) |

### Frame review rounds (Garage, recording pose, each capture scaled to 1080 px tall)

States: start card, step 1 during the sweep and with the labels, steps 3 and 4, step 5 path and far side, step 6 found, halfway, step 10, Finish, a mistake (`leverTooFar`), Ask open with an offline answer, watch mode. For the reveal shots `sweepSec` and `holdSec` were raised to 12 and 15, then put back to 1.4 and 2.5 before the save.

- **Round 1** (`r1/`):
  - Step 5 path: the chevrons ran into the new marker's corner, then bunched once they stopped at its edge. **Fix:** the chain ends at the edge, one arrow length apart.
  - Step 5 far side: the marker is under the user's feet and out of that frame; the slab in frame was the mat. **Fix:** the mat restyle, and the pitch-following callout.
  - Footprints read as two "person" icons (round heel and ball). **Fix:** shoe-print outlines.
  - Halfway card: the hanging old tube (z -79 to -81) drew over its buttons (already true in pass H, worse with the larger card). **Fix:** the card moved 8 cm toward the user, with its view distance set to match.
  - Finish card: top edge 4% from the frame top; the Slowest value sat a line below its label; an empty line above the tip. **Fix:** card 6 cm lower; wrapped card rows start at the top; the line estimate is 0.43 em per glyph (measured 0.38 to 0.40).
  - Ask open: the More popover showed in the bottom-left corner. **Fix:** a choice closes the popover.
  - Watch badge: covered lever A's handle. **Fix:** smaller (button role, icon Stop) and moved left of the valve.
  - What's this? Tire: the info card overlapped the wider step callout (found by `ui-layout`). **Fix:** each spot is also tried further from the part.
  - A corner of the dock showed at the frame's bottom-left (also in pass H's start-card shot). **Fix:** dock 3 cm lower (pitch -33 degrees).
- **Round 2** (`r2/`, `contact-sheet.png`): every frame passes. Every line reads at 1080 px, nothing clips at the frame edge, nothing overlaps, and no text sits on a bright part of the garage.

### LEAF

- **New `voice-coach`:** step 1's line waits for the sweep (1.70 s after Found it); `step-03` starts 0.41 s after the step change; the cues duck and no cue counter moves for speech; a mistake cuts the line off and speaks its reason; the idle hint speaks; Replay after 6 s speaks, a second inside 6 s is skipped; BtnVoice off stops the line at once and the next step stays silent; the halfway card says `halfway` and not `step-07`; the Finish card says `finish`; no line starts twice within 6 s in the whole run.
- **Changed:**
  - `control-bar`: seven hit boxes (BtnVoice on its own row); Voice on by default, off and on again with the icon swap;
  - `ui-layout`: the x-height minimum; step 5's callout stack is read from the far side, so it is checked on the far-side capture instead;
  - `floor-path`: the chain ends at the marker, behind the wheel;
  - the test interactor opens More for BtnVoice.
- **Sweeps:** one scenario per call, `__leaf__log_level=ERROR`, the project saved first.

| Scenario | Garage room, recording pose | Sunlit Room, default pose |
| --- | --- | --- |
| `start` | PASSED | PASSED |
| `deflate-loosen` | PASSED | PASSED |
| `lever-snap` | PASSED | PASSED |
| `peel-and-pull` | PASSED | PASSED |
| `inspect-done` | PASSED | PASSED |
| `step-ticks` | PASSED | PASSED |
| `scene-dressing` | PASSED | PASSED |
| `refit-tube` | PASSED | PASSED |
| `seat-inflate` | PASSED | PASSED |
| `whats-this` | PASSED | PASSED |
| `mistakes` | PASSED | PASSED |
| `flat-causes` | PASSED | PASSED |
| `progress-idle` | PASSED | PASSED |
| `watch-mode` | PASSED | PASSED |
| `ask-coach-fallback` | PASSED | PASSED |
| `floor-path` | PASSED | PASSED |
| `coach-report` | PASSED | PASSED |
| `control-bar` | PASSED | PASSED |
| `floor-level` | PASSED | PASSED |
| `ui-layout` | PASSED | PASSED |
| `voice-coach` (new) | PASSED | PASSED |
| `jump-to-step` | PASSED | PASSED |

- Every scenario passed on its first run in both sweeps; no FAILED line in either log slice.
- **Floor during the sweeps:**
  - Garage: -165.0 cm via World Query in 16 decisions, plus the -177 that `floor-level` injects.
  - Sunlit Room: -138.2 to -138.4 via World Query in 17 (the sofa seat, D2's left-over), -150.4 via the world mesh once.

Findings:

- **`asset-graphql duplicateAsset` renamed the asset instead of copying it** (SidewallMat became TireLineMat, same id). It was renamed back at once; git shows the file unchanged. The sidewall lines use the existing RimMat instead of a new material.
- **The preview frame is portrait, about 37 x 30 degrees.** At 1.5% x-height a 7-word line does not fit in a plate that stays inside the frame. Callouts now carry 4 to 6 words per line on two lines; cards wrap their body line.
- **A yaw-only billboard loses about 40% of its text height** when the eye looks 50 degrees down at it. Only the far-side callout follows pitch.
- **One `jump-to-step` call (step 7) timed out on the MCP side** while the Lens reached the step; the capture after it was fine.

Left over:

- **I checked the audio through the log, not by ear:** every play, stop, duck and duration is logged, but nobody has listened to the mix in this pass.
- **Clips that never play:** `step-07` (the halfway card says `halfway`) and `idle-step-07` (the halfway card has no idle hint). They are kept so every id has a track.
- **Replay inside 6 s of a line is silent**, by the repeat rule as written.
- **On step 5 the Ask chips and answer** under the far-side callout are still yaw-only.
- **Dimming the mat** also makes the wheel's shadow on it hard to see. On the additive display it was faint anyway.
- **`devpost/video-script.md`** still describes the old UI and room (see pass H). Not edited.
- **Untested on Specs:** everything in this pass, including `Date.now()` on the device and the speech volume against the cues.

## 2026-11-05: Pass R, recording the demo footage

No change to the Lens, the scene or any repo file. Three recording passes through the Lens Studio MCP, one call at a time.

### Why this way

- The Mac's screen was locked while the footage was due. macOS refuses screen and window capture while locked ("could not create image from window", a ScreenCaptureKit stream error). A Lens Studio window on another desktop also stops repainting.
- The MCP's CapturePanelScreenshotTool still worked. It asks the Preview panel for its next rendered frame (`panel.tryScreenshot`).
- So the recorder is that same call in a loop inside the editor, started with ExecuteEditorCode: 96 requests in flight, frames saved as jpg 90 by an interval drain. Each frame's time comes from the Preview worker's own per-frame log stamp, because results arrive in batches and out of order.
- A script turns the frames into a constant 30 fps video that keeps real time. The sound is rebuilt from the `[Voice]` and `[Audio]` log lines that pass V added.

### Numbers

- **Frame:** 1392 x 1731, the preview render only, no cursor.
- **Rate:** 28.6 fps mean in the probe, 25 to 28 fps in the takes.
- **Holes:** one of 0.22 to 0.33 s about every 3 s, locked to the Lens reset. Each take's LEAF start step was chosen so the holes miss the key motion.
- **Recording does not change the Lens:** steps 3, 4 and 5 came 7.22 / 11.52 / 19.71 s after step 2 while recording, and 7.18 / 11.45 / 19.71 s without.
- **Takes:** 25, about 13 minutes.

### What drove the takes

- **Watch first** (`jump-to-step` with `watch=1`): steps 1 to 5 and 7 to 10.
- **Real preview mouse input:** Found it, the glint on step 6, Continue on the halfway card, and the mistake (the second lever grabbed from the tray and let go first).
- **Parameters:** `part=Valve` for What's this?, `ask=0 canned=1` for Ask (the offline answer; no tokens were set).
- **LEAF scenarios on camera:** `start`, `lever-snap` and `mistakes` passed during their take. `coach-report` with `stay=1` gave the Finish card after a run with mistakes: 0:30, 2 lever misses, 1 mistake, slowest "Lever A 0:18, Deflate 0:02, Pull 0:02", and the practice line for lever tips.
- **The step 5 walk:** one camera track from the start eye round to the far spot, started by the Lens reset. At eye height the arrow path passes about 7 cm from the tire, so the camera walks a line 31 cm outside it.

### What the footage showed about the Lens

- **A freeze under load.** While the machine was overloaded (load average 25 to 30, swap full) every step 5 froze the Lens for about 30 s: "TimeoutError: Javascript execution has timed out" inside an AudioComponent volume call from `VoiceCoach.setDuck`. `setDuck` only runs when speech starts or stops. It did not happen before the load rose or after it fell. Not changed.
- **The floor drop.** The floor is decided about 12 s after a reset. Until then the stand is on the -150 fallback, then it drops 15 cm. It shows in any take that starts within 12 s of a reset.
- **Doubled callout text** for about 0.6 s while a new step fades in.
- **Step 5 from the near side:** the callout sits on the far side, so it is read through the spokes.
- **What's this? on the valve:** the card covers the valve and lever A.
- **Step 2 at the wheel pose:** the callout follows beads 3 and 4 partly off the frame edge.
- **Step 8:** the new tube's fit is hard to see.
- **The idle hint** replaces the step callout 12 s after a step change, also on a wide shot.
- **LEAF's drag** carries the lever through the camera, because the tray follows the camera.

Not possible:

- **A simulated-hand take of step 3.** The hand's drag failed twice ("Blocked by InteractionPlaneColliderRoot").
- **A capture of the LEAF panel.** The panel's plugin "is loaded in a different module". The video shows a test driving the Lens next to the list of the 21 scenarios.

### Left over

- **Nobody has listened to the cut.** The mix was checked by level only (about -16 LUFS).
- **The footage, narration, edit list and tools are kept outside the repo.**
- **The video is not uploaded.**

## 2026-11-06: Pass P, what the footage showed

On `main`. Each flaw that pass R's footage showed was reproduced, fixed at its cause where that was small, and checked by a capture and a LEAF assertion. Built through the CLAD skills (preview inspection, preview interaction, LEAF in preview) and the Lens Studio MCP, one call at a time. Captures are in `scratchpad/shots/pass-p/` (`before-*`, `after-*`, `judge/`, `contact-sheet.png`). The before captures for items 2 to 7 are frames of the Nov 5 takes (the same build), at the moments pass R noted.

### Items

1. **Doubled callout text.**
   - Wrong: at a step change the callout looked doubled.
   - Cause: there is no cross-fade; the text swaps in one frame. UIKit's `FlexLayout` runs its first layout from `OnStartEvent`, in the next `LateUpdate`. A panel that is off at Lens start (the step callout, the cards, What's this?, Ask) drew every child at the column's centre on the frame it first showed: "Step 2 of 10" over the instruction. In t05-oner this is the frame at 12.97 s. The step 5 "doubling" in t04 and t05 was the spokes in front of the text (item 7).
   - Fix: `UIHelpers.makeFlex` keeps a root flex column at zero scale until its first layout is done (one frame at a normal frame rate). It covers every panel.
   - Checked: every frame of a jump to step 2 (`before-1-callout-frames.png`: frame 44 has the kicker on the text; `after-1-callout-frames.png`: one empty plate, then the laid-out text). `ui-layout` now watches every frame of its run for two visible texts overlapping on one plate. With the fix switched off it failed on the step callout and the halfway card; with it on, 1,521 frames and no overlap.
2. **What's this? covered the part.**
   - Cause: the candidates were toward the view centre, up, down and the diagonals. `intoView()` then slid each one back toward the centre, so with the valve at the top of the frame "up" came back down onto the valve and lever A. Nothing checked the part itself.
   - Fix (`BenchCoachInfoCalloutUI`, `PartInfo`): the card searches 12 directions round its part at growing distances.
     - It must keep off its part's pinch box and the step callout, and stay inside the view.
     - Where a spot allows it, it also keeps off the marker ring, off the valve and the levers within 40 cm, off any other part within 18 cm, and keeps its leader off the callout.
     - It stands at least as far out as the step callout's plane; the axle end poked through it.
     - A spot that still passes is kept.
   - Checked: `after-2-whats-valve-step6.png` and `after-2b-whats-tire-step6.png`: valve, lever A and the top of the tire are visible. `ui-layout` checks every pinchable part on screen on steps 1, 4 and 5: card off the part, the callout and the frame edge, the ring clear for Valve and Tire. `whats-this` measures "beside" from the card's side (within 15 cm).
3. **Step 2's callout ran off the frame.**
   - Cause: the inside-the-rim search took the first spot that cleared the ring. Nothing checked the frame.
   - Fix (`BenchCoachStepLabelUI.insideSpot`): a spot must have every corner in the view, with a 2% margin, while the hub is in view (so it does not chase the frame when the user looks away). This also applies when the marker itself is out of view, as on step 2's low beads. If no spot on the marker-to-hub line is in view, it tries straight above and below the hub. That was needed from Sunlit Room's default pose, where the hub sits at the frame's bottom edge.
   - Checked: `after-3-step2-watch-frames.png`. `ui-layout` asserts the plate's corners inside the frame (1% margin) on every step and after each bead of steps 2 and 9, in both rooms.
4. **The floor drop.**
   - Cause of the 12 s: a level seen only by World Query waited `maxWaitSec + meshWaitSec` (3 + 8 s) for world-mesh support, and in the preview the mesh mostly never answers.
   - Fix (`FloorLevel`, `WheelStand`, `FloorAnchor`, `FloorPath`):
     - A World-Query-only level decides early when 16 hits in 12 cells, spread over at least 120 cm, have agreed on it for 1 s.
     - Every change of the shown floor eases out over 0.5 s, advanced per frame with the frame time capped at 1/20 s so a stall cannot skip it.
     - Stand, mat and path move together each frame; the stand stretches its post and keeps the clamp at the hub. They rebuild once at the end.
     - The correction window is unchanged, so criterion 19 holds: a lower wide level found later moves everything down, now eased.
   - Time to floor:

     | Room and pose | Before | After |
     | --- | --- | --- |
     | Garage, looking down at the work spot (the README's procedure) | about 11.3 s | 4.4 and 4.6 s (early, 42 to 46 hits) |
     | Garage, start-card pose | 11 to 12 s | 11.0 to 11.5 s (10 hits, below the early rule, so unchanged) |
     | Sunlit Room, default pose | about 11 s | 11.0 to 11.4 s (5 or 6 hits, unchanged) |

   - Checked: `after-4-floor-settle-frames.png` (the mat edge and a tripod leg slide down over about 10 frames). `floor-level` asserts the eased correction: in the Garage, 16 samples, 10 between the levels, largest step 2.2 cm, mat with the stand. `floor-level` and `scene-dressing` wait for the ease before they read the stand.
5. **The idle hint hid the instruction.**
   - Fix (`BenchCoachStepLabelUI.showHint`, `Plate.setHeight`): the instruction stays, and the plate grows by a "Hint" kicker and the hint line (one or two lines).
   - Steps 4, 6 and 10 keep the old swap, because their hints state the whole step:
     - 4: "Hook the second lever on the ghost, then slide it down."
     - 6: "Look for a glint on the tire. Pinch it."
     - 10: "Pinch the valve and keep holding."
   - A mistake reason still survives a hint (pass G7; `mistakes` passes).
   - Checked: `after-5-idle-hint-step2.png`. `progress-idle` asserts the instruction stays and the hint line shows under it.
6. **Step 8 was hard to see.**
   - Cause: each segment slid in from 4 cm for 0.3 s and vanished into the tire, so the whole fit took about 1.3 s.
   - Fix (`TubePull`, `RefitSteps`, scene timing):
     - The new tube feeds in from the valve both ways in a lighter amber (`refitTint`), 0.18 s apart, 0.45 s each, from 8 cm.
     - Each segment stops 1.5 cm in front of the tire, so a ring builds round the wheel.
     - Then the whole tube presses in over 0.3 s while its tone fades back: the seated moment. No particles.
     - Watch mode budgets the beat from the same numbers. The fit now takes about 2.4 s.
   - Checked: `after-6-refit-frames.png`. `refit-tube` asserts 29 samples lighter than the tire (0.51 against 0.38), the ring, the seat and the tone back.
7. **Step 5 from the near side.**
   - Fix (`BenchCoachStepLabelUI`): on step 5 the far-side callout hides while the line from the eye to it crosses the wheel disc, unless Ask or What's this? hangs under it. The edge arrow (`EdgeHint` ignores the hidden plate) and the floor path send the user round. The full callout comes in once the user is behind the wheel or sees it clear of the tire. No extra line was added.
   - Checked: `after-7-step5-near-and-far.png`. `floor-path` asserts the hide from the start eye and the full callout with its leader at the far spot (31 polls). `peel-and-pull` passes.
8. **The freeze under load in `setDuck`.**
   - Fix (`BenchCoachAudio`, `VoiceCoach`):
     - `setDuck` writes only to a long cue that is playing, and only when the value changes;
     - a cue that starts later gets the duck when it starts;
     - `cut()` no longer touches the duck, and the voice coach applies it only from its own `UpdateEvent`.
   - The `[Voice]` and `[Audio]` lines are unchanged.
   - Checked: `voice-coach` asserts the duck writes no volume while no long cue plays. Not chased further.
9. **Sunlit Room, the sofa.** Not fixed.
   - From the default pose World Query sees 5 or 6 hits at -138.2 to -138.4, and never the floor. The world mesh saw -150.4 once in this pass.
   - The suggested rule does not apply: the level is 138 cm below the eye, not under 110.
   - Item 4 does not change it: 5 hits are below the early rule.
   - The README's known gap stands.

### Judged as a judge would (Garage, recording pose)

Watch first from the start card to the Finish card was recorded at 1080 px (2,058 frames) and checked frame by frame. So were a mistake (`leverTooFar`), What's this? on the valve and on the tire, Ask with the offline answer, and the halfway card (`judge/`).
- Every word reads.
- Nothing overlaps or leaves the frame.
- Nothing is doubled.

### LEAF

One scenario per call, `__leaf__log_level=ERROR`, the project saved first.

| Scenario | Garage room, recording pose | Sunlit Room, default pose |
| --- | --- | --- |
| `start` | PASSED | PASSED (FAILED once, first run after the room switch, see below) |
| `deflate-loosen` | PASSED | PASSED |
| `lever-snap` | PASSED | PASSED |
| `peel-and-pull` | PASSED | PASSED |
| `inspect-done` | PASSED | PASSED |
| `step-ticks` | PASSED | PASSED |
| `scene-dressing` | PASSED | PASSED |
| `refit-tube` | PASSED | PASSED |
| `seat-inflate` | PASSED | PASSED |
| `whats-this` | PASSED | PASSED |
| `mistakes` | PASSED | PASSED |
| `flat-causes` | PASSED | PASSED |
| `progress-idle` | PASSED | PASSED |
| `watch-mode` | PASSED (plugin line; the MCP call timed out) | PASSED (plugin line; the MCP call timed out) |
| `ask-coach-fallback` | PASSED | PASSED |
| `floor-path` | PASSED | PASSED |
| `coach-report` | PASSED | PASSED |
| `control-bar` | PASSED | PASSED |
| `floor-level` | PASSED | FAILED, then not re-run (see below) |
| `ui-layout` | PASSED | PASSED |
| `voice-coach` | PASSED | PASSED |
| `jump-to-step` | PASSED | PASSED |

- **`watch-mode`** takes 59 to 60 s, at the MCP call's limit (one more second for the step 8 fit). In the Garage sweep the call timed out and the next run reset the scene while it ran. Run again alone, the plugin logged "Scenario watch-mode completed successfully" after 59.8 s. In Sunlit Room it completed too.
- **`start` in Sunlit Room** failed once: 0.3 s after Found it the 1.4 s scan sweep was already holding. This was the first run after switching rooms, with frames stalling; it passed when run again. The scan reveal was not changed.
- **`floor-level` in Sunlit Room** failed: one stalled frame covered the whole 0.5 s ease (1 sample, a 12 cm step). That led to the per-frame cap on the ease. The project compiles with it (offline `lensifyts tsc-only`, no errors), but **neither sweep was run on it**: the next `floor-level` run never reported and Lens Studio stopped answering the MCP. Every other row ran on the code before that one change.

### Findings

- **The screen locked at 01:11.** From then on the Preview paused itself, and macOS background jobs (`mediaanalysisd`, Spotlight) held the load at 100 to 160 for about an hour. LEAF runs hung and the Lens took minutes to start. `PreviewPanelTool resume` and waiting were the only remedies. Nothing ran usefully until about 02:15.
- **New inputs are stored in the scene at their first compiled value.** `earlyHits` and `earlyCells` were later lowered to 8 and 6 in code, but the scene kept 16 and 12. So every run used 16 and 12, and the code defaults were set back to match.
- **From the start-card pose World Query gets only about 10 floor hits in the Garage,** and none at all when looking straight at the wheel. A reset from the wheel pose falls back to -150.

### Left over

- **The full sweeps were not repeated on the last `FloorLevel` change** (the per-frame cap on the ease). The README's "Last full run" line is not updated.
- **What's this? Valve at the recording pose** sits under the step callout, close to it, with its leader passing behind the callout. There is no room above the valve for a card 60% of the frame's width.
- **Lever A on step 4 from Sunlit Room's default pose** has no spot clear of the lever, the callout and the frame. The card covers the lever's handle, and `ui-layout` logs it.
- **In Watch mode, step 5 from the near side shows no text.** Watch hides the floor path, and the callout is hidden while seen through the wheel; the voice line carries the step.
- **Item 9** stays a known gap.
- **The Preview is left in Sunlit Room on a stalled `floor-level` run,** not on the Garage start card. Lens Studio stopped answering the MCP at 03:27. The project was saved before that run.

### Finishing the pass (second session)

The near-side note, the `watch-mode` change and a third audio change were written while the Preview's audio was stalled, so they had not run in LEAF. This session ran both sweeps on them and fixed what failed.

#### The near-side note (item 7, second part)

- **Why.** Item 7 hid step 5's far-side callout while it would be read through the spokes. From the start eye that left step 5 with no text at all. In Watch mode the floor path is hidden too, so only the voice line carried the step.
- **What shows where.**
  - While the full callout would be read through the wheel, the same plate becomes a short note on the near side: "Step 5 of 10" and "Go round the stand".
  - The line is `nearSideLine` in `StepDefinitions`. It is display only and never spoken.
  - The note sits straight above or below the hub, inside the rim, at the first spot that is in view. It has no leader.
  - It shows in the normal and hint states, also in Watch mode. A mistake or "Found it" keeps its own text. The idle hint line waits for the full callout.
  - Once the user is behind the wheel, or sees the callout clear of the tire, the full callout and its leader come back. Note and callout are one plate, so they never show together.
  - The edge arrow keeps off the note (`EdgeHint`), and What's this? keeps its card off it (`BenchCoachInfoCalloutUI`).
- **Fixed in the sweep.** `ui-layout` failed in Sunlit Room: What's this? Rim on step 5 read at 0.53 degrees, under the 0.55 minimum.
  - Cause: the card now had to keep off the note. It went lower in the frame (y 0.73 to 0.90), so farther from the eye, and the card does not scale with distance.
  - Fix (`BenchCoachInfoCalloutUI.placeBeside`): a spot where the card's line would read under the body minimum (2% margin) now ranks below every readable spot. It weighs more than the soft rules and less than the must rules.
  - After: the Rim card sits at y 0.32 to 0.50 and reads 0.58 degrees in both rooms.
- **Checked.**
  - `floor-path` asserts the note from the start eye (its text, no leader), the full callout with its instruction and leader at the far spot, and the note in Watch mode.
  - `ui-layout` asserts the note's text, no leader, the plate inside the frame, the edge arrow off it, and its x-height (0.59 degrees).
  - Captures in `scratchpad/shots/pass-p/`, Garage room:
    - `after-7b-step5-near-note.png`: the note under the hub, inside the rim, clear of the levers. The edge arrow is apart at the lower right.
    - `after-7b-step5-near-note-watch.png`: the same note with the Watching pill.
    - `after-7b-step5-far.png`: from the far spot, the full callout with its leader to the tube end, and no note.

#### `watch-mode`

- After Next stops Watch on step 5, the scenario now presses Next twice more (the glint step, the halfway card) and resumes Watch from step 8. Its first wait is 0.5 s instead of 1 s.
- The Lens's Watch timings are unchanged. This scenario no longer plays Watch's steps 6 and 7.
- Run time: 48.5 and 48.8 s in Sunlit Room, 49.1 s in the Garage, down from 59.8 s. The MCP call now returns before its limit.

#### Audio, a third change

- `BenchCoachAudio` keeps its own record of which long cue is playing: the pump by its flag, hiss and zipper by their start time plus duration (the duration is read once). `setDuck` makes no `isPlaying()` calls.
- `VoiceCoach` does not apply the duck in the frame a voice line starts.
- Why: a TimeoutError in `setDuck`, in the frame a line had started. That error came during the audio stall below, so it was most likely the stall. The change stays because it is cheaper, and it passed both sweeps.
- The `[Voice]` and `[Audio]` lines are unchanged, and `tools/export-voice-lines.py` writes an identical `voice-lines.json`.

#### The audio stall

- From about 04:06, every AudioComponent `play()` in the Preview blocked about 15 s. A voice line started 15.3 s after its trigger, followed by "TimeoutError: Javascript execution has timed out".
- Cause: the Mac, not Lens Studio and not the Lens. After an idle sleep at 03:35 the Mac came back only in dark wake. `pmset -g systemstate` showed "CPU Network" with no Audio, and in that state every sound start on the machine fails after 15 s.
- The Lens Studio relaunch at 04:29:59 did not clear it. The same Lens Studio session still stalled 15 s at 04:30 and 04:32.
- Once the Mac was fully awake ("CPU Graphics Audio Network"), the same session was clean. At 04:36, `[Voice] floor-found` came 0.33 s after "floor line: found", with no TimeoutError. The screen stayed locked throughout, so the lock was not the cause.

#### LEAF on the final code

One scenario per call, `__leaf__log_level=ERROR`, the project saved before every run.
- Sunlit Room was swept again from the top after the `placeBeside` fix.
- Garage room: the start eye, looking at the start card (0, -16, -90).

| Scenario | Garage room, recording pose | Sunlit Room, default pose |
| --- | --- | --- |
| `start` | PASSED | PASSED |
| `deflate-loosen` | PASSED | PASSED |
| `lever-snap` | PASSED | PASSED |
| `peel-and-pull` | PASSED | PASSED |
| `inspect-done` | PASSED | PASSED |
| `step-ticks` | PASSED | PASSED |
| `scene-dressing` | PASSED | PASSED |
| `refit-tube` | PASSED | PASSED |
| `seat-inflate` | PASSED | PASSED |
| `whats-this` | PASSED | PASSED |
| `mistakes` | PASSED | PASSED |
| `flat-causes` | PASSED | PASSED |
| `progress-idle` | PASSED | PASSED |
| `watch-mode` | PASSED (49.1 s) | PASSED (48.8 s) |
| `ask-coach-fallback` | PASSED | PASSED |
| `floor-path` | PASSED | PASSED |
| `coach-report` | PASSED | PASSED |
| `control-bar` | PASSED | PASSED |
| `floor-level` | PASSED | PASSED |
| `ui-layout` | PASSED (plugin line; the MCP call timed out at 61.7 s) | PASSED (FAILED before the `placeBeside` fix, see above) |
| `voice-coach` | PASSED | PASSED (FAILED once, see below) |
| `jump-to-step` | PASSED | PASSED |

- **`voice-coach` in Sunlit Room** failed once on "speech moves no cue counter". The edge arrow's chime had played on steps 2 and 3, because their markers were out of view. The Preview eye was found pitched 12 degrees down instead of level: a scenario earlier in the sweep had left it there. The scenario passed with the eye put back at the default pose. In the Garage sweep the pose was checked after `inspect-done`, `floor-path` and `ui-layout`, and it never moved.
- **`floor-level` in Sunlit Room**, which stalled at the end of the first session, passed in both sweeps on the per-frame cap of the ease.
- **Load.** From 05:05 macOS background analysis (`mediaanalysisd`) pushed the load average to 100 to 135. The sweep waited 20 minutes, then ran its last 8 Garage scenarios at a load of 25 to 30. All passed.

#### Left over

- These first-session items are now closed: the sweeps on the last `FloorLevel` change, the README's "Last full run" line, Watch mode's step 5 showing no text, and the Preview left in Sunlit Room.
- **`ui-layout` runs 53 to 62 s**, at the MCP call's limit. In the Garage the call timed out, and the pass was read from the plugin's line.
- **The eye drift in Sunlit Room** is not explained. Some scenario between 04:49 and 04:57 left the Preview eye pitched 12 degrees down. It did not happen in the Garage sweep.
- **Voice timing under load.** At a load of 30, `[Voice] floor-found` came 4.3 s after "floor line: found", and the floor took 8.5 s instead of 4.6 s. Neither the 15 s stall nor a TimeoutError showed. Checked again at a load of 10 to 20: 1.09 s and 0.72 s, no TimeoutError.
- **The Preview paused itself once more** at 05:51, with the screen locked: a reset printed nothing for two minutes. `PreviewPanelTool resume` brought it back.
- The What's this? Valve card at the recording pose, Lever A on step 4 from Sunlit Room's default pose, and item 9 stand as listed above. They were not re-checked.
- The commits are on `main` and not pushed.

## 2026-11-06: Pass R4, pickup takes and the second cut

No change to the Lens, the scene or any repo file besides these notes, the shot list and two README lines. One recording pass through the Lens Studio MCP, 20 minutes, then the cut was rendered again.

### Why

Pass P changed what five shots of the Nov 5 cut show: steps 1 and 2, the step 4 opening shot with the step 5 cue, the step 5 walk, What's this?, and the refit. The other shots were compared with the Lens as it is now, frame by frame, and stay.

### Lens Studio was throttled while the screen was locked

- With the screen locked, macOS App Nap ran Lens Studio at background priority. `ps` showed priority 4, and timers started from editor snippets ticked at 3 to 20 Hz. That is where the earlier passes' slow timers came from.
- It mattered once macOS photo analysis (`mediaanalysisd`) filled the efficiency cores after the system update. The load average sat at 30 to 130 while the CPU was 70% idle, and the Lens ran slow: the floor found in 8.5 s instead of 4.6 s, a voice line 4 s late.
- Fix: Lens Studio was quit and started again with `-NSAppSleepDisabled YES` on its command line. That applies to the one launch and saves nothing. Priority stayed at 58.
- After it, at a load average of 20 to 50: the floor was decided 4.71 s after a reset with the eye looking down, and `[Voice] floor-found` started 0.08 s later. The recorder's drain timer ticked at about 78 Hz. One camera timer gave 77 to 79 Hz with no repeated frames, so the three interleaved timers of pass R are not needed. Step changes came 1.4 to 1.5 s after a reset instead of 2.3 to 2.5 s.
- The recorder's 0.25 s gaps every 3 s now follow the recorder's start, not the Lens reset.

### The takes

Same recorder, same room and poses as pass R. Each take was made in one attempt except the walk (two).

| Take | Driven by | Used span | Rate, worst gap |
| --- | --- | --- | --- |
| `t02-step1-2-p` | `jump-to-step` step=1 watch=1, wheel pose | 9.72 to 19.32 s | 27.2 fps, 0.28 s |
| `t04-step4-p` | step=3 watch=1, wheel pose | 14.25 to 25.55 s | 28.0 fps, 0.29 s |
| `t05-oner-p` | step=5, camera track from the Lens reset | 12.9 to 24.55 s | 28.2 fps, 0.26 s |
| `t06-whats-p` | step=6 part=Valve | not used | 28.3 fps, 0.26 s |
| `t06-whats-b-p` | step=6 part=Tire | 10.57 to 14.07 s | 26.2 fps, 0.32 s |
| `t09-refit-p` | step=7 watch=1, card pose | 14.74 to 31.02 s | 27.4 fps, 0.32 s |

- **The walk.** The arrows and the marker read the same positions as on Nov 5. The walk is 5.6 s. The track's start is delayed so the tilt and the look-up fall between two recorder gaps. The floor settles 0.34 s into the walk, while the camera looks down at the arrows.
- **What's this?** The cut uses the Tire card: it sits right of centre with its leader up to the tire. The Valve card no longer covers the valve, but its leader runs behind the step callout.
- **The refit.** Step 8 is 6.94 s in Watch (6.01 s before). The amber ring feeds in from 15.94 s and seats at 18.44 s.

### The cut

- 2:28 long (147.8 s), 1920 x 1080, -15.7 LUFS, the same as the Nov 5 cut. The Nov 5 cut is kept beside it.
- The walk shot ends 0.1 s before the idle hint. It is 2.2 s shorter than before, which is where the length went.
- "Walk round, peel the bead the rest of the way" now starts as the camera looks up, 0.7 s earlier in the shot.
- Every changed shot was checked on frames from the rendered file. Nobody has listened to it yet. The level was scanned second by second: no new silence, and the same pauses between narration lines as before.

### What the takes showed about the Lens

- **Step 5, far side, idle hint.** When the hint grows the plate upward, the stand's post covers part of the first line ("Go roun he stand"). The cut ends the shot before the hint.
- **What's this? Hub:** the card goes above the step callout and covers the valve stem.
- **What's this? Rim:** the leader runs to the lower left, and the rim it names is at the frame's edge.
- **No doubled text** in any take. A change is a one-frame swap, or one empty plate and then the laid-out text.

### Left over

- The three items above.
- Listening to the cut, the upload, and the design brief line in the narration (clip n12a is used once `devpost/design-brief.md` exists).

## 2026-11-06: Pass S1, Watch walks and a compact Finish card

On `main`. At the live review on Nov 5 the judges asked for an unbroken minute of the experience ("no cuts, what it feels like") and called the dense end screen "a website on your face". The video's unbroken minute will be Watch mode from Found it to the far side, so Watch has to walk. The Finish card gets progressive disclosure. Built through the CLAD skills (preview inspection, LEAF in preview) and the Lens Studio MCP, one call at a time. Captures are in `scratchpad/shots/pass-s1/`, each scaled to 1080 px tall and looked at.

### Items

1. **Watch mode walks at step 5.**
   - Wrong: `FloorPath` stayed hidden while `director.playing`, and the step 5 beat pulled the tube 3.5 s into the step with the viewer still on the near side. Watch never showed the far side.
   - Changed (`RepairDirector`, `FloorPath`):
     - The floor path, its stand-here marker, the near-side note and the edge arrow show on step 5 in Watch mode as in normal mode.
     - `FloorPath` registers itself as the director's `walkCue` at start. It already imports the director, so no import loops back.
     - The step 5 beat waits until the viewer arrives at the far spot (the arrival `FloorPath` detects, which hides the path), at most `watchWalkMaxSec` from the step's start. That is a new `@input` on `RepairDirector`, 12 s. The beat's 3.5 s wait and the voice hold still apply.
     - The beat logs `beat 5: pull after arrival, at most 12.0 s` when the step starts, then `beat 5: pull after arrival (3.5 s)` or `beat 5: pull after timeout (12.0 s)`.
     - Next or a grab during the walk stops Watch as before. The full callout comes in at the far spot as in normal mode: the `throughWheel` rule does not look at Watch mode.
   - Watch from Found it to the Finish card, Garage room, start eye (`jump-to-step` step 0, watch 1):

     | Viewer | Step 5 beat | Found it to the Finish card |
     | --- | --- | --- |
     | Never walks (pull after timeout, 12.0 s) | 15.2 s | 67.9 s |
     | Walks at once (eye at the far spot before step 5; pull after arrival at 3.5 s, as before this pass) | 6.7 s | 59.4 s |

   - Checked:
     - `watch-mode`: on step 5 the path shows and the pull has not started. The eye then walks round the stand's right side to the far spot over 3 s, set every 50 ms, as soon as step 5 starts. The path shows until the arrival, nothing pulls during the walk, and the arrival hides the path without completing the step. The pull starts 0.90 s (Garage) and 0.86 s (Sunlit Room) after the arrival, logged `after arrival`. Next then stops Watch on step 6 and moves to the halfway card, one more Next reaches step 8, and play() resumes to the Finish card as before.
     - Why a 3 s walk and not a jump: with an instant jump the pull still waits for the beat's own 3.5 s, about 3.2 s after the arrival, so the 2 s check would only measure that wait.
     - `floor-path`: "path never visible in watch mode" became "in Watch mode on step 5 the path, its marker and at least six arrows show, and the near-side note shows". Watch is then stopped there. The normal-mode near and far assertions are unchanged.
     - Captures (Garage room, `jump-to-step` step 5 watch 1, the camera driven from the Lens reset by an editor timer, the floor decided at -165 looking down first):
       - `watch-step5-near.png`, the wheel pose: the Watching pill, the note "Step 5 of 10 / Go round the stand", the edge arrow at the lower right.
       - `watch-step5-near-path.png`, lookAt (8, -100, -75): the edge arrow pointing up, the stand-here marker and the arrows.
       - `watch-step5-far.png`, eye (10, 0, -124) lookAt (0, -45, -90), 1.15 s after the arrival: the full callout with its leader, the ring, the tube end coming out.
     - One frame cannot hold all four near-side cues from the start eye. The pill floats about 7 degrees above eye level, the note about 27 degrees below, and the path 53 to 74 degrees below, in a frame 36.6 degrees tall. So the near side is two captures.
2. **The Finish card: three lines by default, the rest behind More.**
   - Wrong: one card with a kicker, the title, a row of big numbers (time, lever misses, mistakes, hints), the cause and slowest steps, the tip, the practice line and Start over.
   - Changed (`BenchCoachFinishCardUI`):
     - Compact by default: the green kicker "Repair complete", "Flat fixed" with the time on the same row (both title size, the time right-aligned), the "Next time" tip (up to two lines), and two buttons, More and Start over.
     - More (`BtnFinishMore`; the dock already has a `BtnMore`) shows the list (Cause, Lever misses, Mistakes, Hints, Slowest) and the practice line, and reads Less. Less collapses it. The Slowest row wraps to two lines: a real run's three steps need about 37 characters, and about 25 fit.
     - The card grows downward: its top edge stays put. The expanded card is centred where the card is authored; the compact one shares its top edge. Every show starts compact (`OnEnableEvent`).
     - Buttons are at least `minButtonDeg` tall (a new `@input`, 4.8 degrees, 6.9 cm at the 82 cm viewing distance). The dock's are 4 cm at 48 cm.
     - Every state is in words: the kicker says "Repair complete", the buttons say More, Less and Start over.
     - `setResult` and `setReport` keep their signatures, and the Text names the tests read are kept. `RepairManager` is unchanged. The spoken finish line is unchanged.
   - Checked:
     - `coach-report`: after a real run the card opens compact, with the tip and the time and none of the list rows. A ray press on More shows every row and the practice line, and the button reads Less. Then the rows as before.
     - `ui-layout` checks the card in both states. The texts are inside the plate at their minimum x-height (FinishTitle 0.83, FinishTime 0.82, FinishTip 0.59, FinishCause 0.59, FinishTimes 0.57 degrees). The buttons are at least as tall from the eye as the dock's (4.77 and 4.79 degrees compact, 4.50 and 4.52 expanded, the dock's 4.16) and are not under the dock on screen. While the eye looks at the card, the plate is inside the view: at the card pose, compact y 0.100 to 0.505 of the frame, expanded 0.100 to 0.858.
     - The first version of that view check failed in Sunlit Room. From the level default pose the world-locked card sits 9.9 degrees below the view centre, and the expanded bottom reached y 1.154. The old card was not checked for this. The check now runs while the eye is within 3 degrees of the card, and other poses are logged.
     - `seat-inflate` and `flat-causes` press More before reading the counts and the cause, and assert those rows show.
     - Captures at the card pose (Garage room, `coach-report` stay 1: time 0:23, Snakebite, 2 lever misses, 1 mistake): `finish-compact.png` and `finish-more.png`. Every word reads, nothing overlaps, both are inside the frame, and the dock is out of frame to the left.
   - `tools/export-voice-lines.py` still writes an identical `voice-lines.json` (30 lines). The `[Voice]` and `[Audio]` lines and `jump-to-step`'s parameters are unchanged.

### LEAF on the final code

One scenario per call, `__leaf__log_level=ERROR`, the project saved before every run. Garage room at the start eye looking at the start card (0, -16, -90); Sunlit Room at the default pose.

| Scenario | Garage room, start eye | Sunlit Room, default pose |
| --- | --- | --- |
| `start` | PASSED | PASSED |
| `deflate-loosen` | PASSED | PASSED |
| `lever-snap` | PASSED | PASSED |
| `peel-and-pull` | PASSED | PASSED |
| `inspect-done` | PASSED | PASSED |
| `step-ticks` | PASSED | PASSED |
| `scene-dressing` | PASSED | PASSED |
| `refit-tube` | PASSED | PASSED |
| `seat-inflate` | PASSED | PASSED |
| `whats-this` | PASSED | PASSED |
| `mistakes` | PASSED | PASSED |
| `flat-causes` | PASSED | PASSED |
| `progress-idle` | PASSED | PASSED |
| `watch-mode` | PASSED (53.7 s) | PASSED (54.0 s) |
| `ask-coach-fallback` | PASSED | PASSED |
| `floor-path` | PASSED | PASSED |
| `coach-report` | PASSED | PASSED |
| `control-bar` | PASSED | PASSED |
| `floor-level` | PASSED | PASSED |
| `ui-layout` | PASSED (53.9 s) | PASSED (51.2 s; FAILED before the view check was limited, see item 2) |
| `voice-coach` | PASSED | PASSED |
| `jump-to-step` | PASSED | PASSED |

- `ui-layout` is the only scenario changed after the Garage sweep. It was run again in the Garage on the final code (53.9 s; 53.6 s in the sweep).
- **The eye drift in Sunlit Room came back.** After `inspect-done` the Preview eye was pitched 12 degrees down (348). It was put back at the default pose before `step-ticks`, and it did not move again (checked after `seat-inflate`, after `floor-path` and before `voice-coach`). The cause is one of `start`, `deflate-loosen`, `lever-snap`, `peel-and-pull` and `inspect-done`. In the Garage the pose was checked after `inspect-done`, `floor-path` and `ui-layout`, and it never moved.

### Left over

- **`watch-mode` runs 53.7 to 54.0 s,** 1 s under the 55 s limit (49 s before; the walk and the pull add about 5 s).
- **`ui-layout` runs 51 to 54 s.**
- **The expanded Finish card from a level eye** (Sunlit Room's default pose) runs off the bottom of the frame. The card is world-locked 10 degrees below eye level, and the user looks down to read the rest.
- **The full callout at the far spot in Watch mode** is checked on the capture only. `floor-path` asserts it in normal mode.
- **The eye drift in Sunlit Room** is narrowed to the first five scenarios but not explained.
- The near-side capture is two frames, for the reason above.
- The video is not recorded again in this pass.
- The commits are on `main` and not pushed.
