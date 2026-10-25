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
