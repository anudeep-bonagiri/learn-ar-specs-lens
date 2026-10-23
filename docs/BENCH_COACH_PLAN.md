# Bench Coach: build plan for the coding agent

Status: current direction as of Oct 22, 2026. Supersedes the Walk the Talk concept in `AGENT_BRIEF.md` Section 3; the ground rules, setup and submission sections of that file still apply.
Hackathon: Learn AR with SPECS (Devpost Learn). Deadline Mon Nov 9, 2026, 5 PM ET. Live build session Thu Oct 22, 12 PM ET. Live project review Thu Nov 5, 12 PM ET.

---

## 0. How to use this file (read first)

1. **Learner-led.** When the builder runs `plan-lens`, do not answer its interview for them and do not paste this file into it. Section 9 is the builder's own prepared thinking. Never draft the README prose, Devpost description, or reflection. You may check facts, point out gaps, and fix spelling when asked.
2. **CLAD builds the Lens.** All scene and script work goes through the CLAD plugin and the Lens Studio MCP tools (`mcp__lens-studio__*` in Claude Code). Never use raw HTTP to reach Lens Studio. If an MCP tool fails, stop and report.
3. **Preview is the only target.** Nobody has SPECS glasses. Every feature must be visible and testable in the Lens Studio preview with WASD/QE/mouse. Anything on the can't-show list (live camera vision, custom or two-hand gestures, hand pose or speed, persistence, multi-user, voice) stays out.
4. **One moment, done well.** The featured moment is Section 2. Everything else is bookends. When in doubt, cut.
5. **Commit small and often.** Never commit `.mcp.json`, `spk_debug_key.pem`, or private docs. Before the repo goes public, move `docs/` (except `docs/HACKATHON.md`, `docs/SUBMISSION_CHECKLIST.md`) and `AGENT_BRIEF.md` out.

---

## 1. The decision and the pitch

**Bench Coach** is a hands-free bike repair guide for SPECS where every instruction lives on the part it is about, never in a floating panel. Version 1 teaches one repair, removing a tire and tube to fix a flat, on a rear wheel sitting in a repair stand.

**Pitch (first 15 seconds of the video):** "Your hands are greasy, the video is paused across the room, and you're guessing which way the lever goes. Bench Coach puts the next move on the wheel itself, and the step you can't see is waiting on the other side."

**Audience:** home cyclists who fix their own flats. Flats repeat, the procedure is the same on nearly every bike, and a wheel in a stand sits 0.6 to 1.6 m away, slightly below eye level, exactly where SPECS content works best.

**Why glasses (two of the three strengths, one stand-in):**
- Draws in the world: ghost tools and markers sit on the rim, tire and valve at true scale.
- Leaves your body free: both hands are on the wheel and levers; eyes stay on the work.
- Shares your view: in real use the glasses would find your wheel. In preview, a "Found it" pinch anchors a virtual wheel. Labeled on screen as a stand-in.

**Why not a phone:** a phone is propped on the bench, you scrub a video with a greasy thumb, and you translate the video's camera angle onto your own wheel. Here the instruction is on your wheel, from your angle, and the next marker makes you walk to where the work is.

**Why it won't read as a step-coach slideshow (the main judging risk):** the wheel model changes as you act (bead lifts, lever stays hooked, tube comes out), each step requires a body action (grab, place, drag along the rim, walk around the stand), and the "inspect" step is a search, not a card.

---

## 2. The one spatial moment

Step 4 of the procedure. You stand at the front of the wheel. A ghost tire lever fades in at the valve, already hooked under the bead, and animates the hooking motion once. You grab the real-size virtual lever from the tool tray and place it where the ghost is; it snaps, the bead section visibly lifts, the ghost disappears, and a second ghost appears 5 cm along the rim. You place the second lever, then drag it along the rim and the bead peels up behind it with a soft zipper sound. A marker then lights on the far side of the wheel, opposite the valve, with a chime from that direction. You walk around the stand. The marker is the tube end: grab it and pull, and the tube slides out of the tire.

That walk-around is the launch-reel shot. Everything before it (deflate, push the bead) and after it (inspect, done, next skill) is shown quickly.

---

## 3. Research summary

### 3.1 The procedure (Park Tool, "Tire and Tube Removal and Installation")
Canonical steps for removing a clincher tire and tube, used as the Lens's step list:
1. Wheel off the bike (we skip this: the wheel is already in the stand).
2. Deflate completely (Presta: unthread the tip locknut and press; Schrader: press the plunger with a small tool).
3. Push one bead toward the rim center all the way around to loosen it; repeat on the other bead.
4. Engage one tire lever under the bead; engage a second lever 25 to 50 mm away; pull both toward the spokes to lift the bead. Disengage one, move it 5 cm along, re-engage, repeat until the bead loosens, then slide the lever around the rim under the bead.
5. Starting opposite the valve, pull the inner tube out of the tire; lift the valve from the valve hole last.
6. Remove the second bead to take the tire off fully (optional in v1).
7. Inspect tube and tire: find the cause (thorn, glass, pinch) so the flat doesn't repeat.
Caution from the source: never use a screwdriver or sharp object as a lever.

### 3.2 SPECS numbers that shape placement (Snap design docs)
- Near field 35 to 60 cm (direct reach), far field 60 to 160 cm. Default content distance about 110 cm; focus plane about 1 m.
- Usable area (w x h): 55 cm away 23 x 38 cm; 110 cm away 53 x 77 cm. View is about 37 degrees tall by 32 wide, so a 70 cm wheel at 90 cm is not all in view at once. Design around the part the user is looking at.
- Target sizes (best): 3 cm at 55 cm, 6 cm at 110 cm. Minimum 2 degrees per target, 1 degree spacing.
- Content lower than on a phone; keep arms low; put controls near the hands.
- Additive display: black renders transparent. Tires, chains and grease are black, so the virtual wheel is rendered mid-grey with bright overlays.
- Put a light panel behind any text.

### 3.3 Preview facts (skill pack `preview-limits.md`, Snap preview docs)
- Walk with WASD, Q/E up and down, mouse look. The mouse is one hand doing a pinch on SIK interactables.
- Works: real-scale objects, SIK buttons, sliders, grab/drag/throw, spatial sound, simple physics, animation, 3D models, text. LEAF can drive SIK interactables.
- Needs a stand-in: recognizing real things (a "Found it" pinch), voice (a button).
- Can't show: custom gestures, live camera, persistence, multi-user.
- The simulated room has no repair stand or bike; the Lens provides them.

### 3.4 Tools and open-source resources
| Need | Resource | Notes |
| --- | --- | --- |
| Agent toolchain | CLAD plugin `ls-clad` from `https://github.com/lens-studio-devs/ls-extensions.git`, Lens Studio MCP (auto-created by Lens Studio 5.22+) | Setup commands in Section 8 |
| UI and interaction | Spectacles Interaction Kit (`SpectaclesInteractionKit.lspkg`, ships with the SPECS Base Template): `Interactable`, `InteractableManipulation`, `PinchButton` (`onButtonPinched`), `ToggleButton`, `Slider` (`onValueUpdate`), `ContainerFrame` (billboarding, follow) | All mouse-drivable in preview and LEAF-drivable |
| Testing | LEAF (`Leaf.lspkg`): `Scenario` classes with async `run()`, `DefaultLeafInteractor` (`trigger`, `drag`, `hover`), `LeafHandInteractor` (pinch, grab poses), `expect` assertions, `@scenariosIndex`. Skills: `/specs-leaf-install-packages`, `/specs-leaf-write-scenarios`, `/specs-leaf-run-in-preview`, `/verify-preview` | LEAF, SIK and Lens Studio versions must match |
| 3D parts | CLAD `/build-mesh` (procedural and text-to-3D), `/mesh-builder-scripting` | Preferred: procedural primitives so tire, rim, tube, levers are separate objects with controllable colors |
| Whole-bike silhouette (optional) | Poly Pizza free low-poly bicycles (Poly by Google, CC-BY 3.0), Sketchfab CC-BY models; glTF/GLB or FBX import into Lens Studio | Only as a dim context model behind the wheel; must be recolored away from black |
| Audio | CLAD `/build-sfx` for tick, zipper, chime, "nope" | Keep quiet; preview recording captures audio |
| Reference samples | `github.com/specs-devs/samples` (main branch targets SPECS 27, Lens Studio 5.22+, Git LFS): Essentials (gesture, physics, raycast, tween), Throw Lab (grab/throw), Specs Base Template With Examples | Use for SIK patterns, not for copying code into the repo (disclose anything reused) |
| Procedure reference | Park Tool repair help, "Tire and Tube Removal and Installation" | Step wording in the Lens is paraphrased, not copied |

### 3.5 Prior art and the differentiator
Phone and web: iFixit, Park Tool guides, YouTube, BILT 3D instructions. Headsets: Dynamics 365 Guides, Vuforia, TeamViewer Frontline. SPECS: CPR trainer and card-game tutor winners; the skill pack's own cooking coach. Differentiator to protect: instructions on the part, a model that changes as you act, a step that is physically on the far side of the wheel, and an inspect step that is a search.

---

## 4. Design spec

All units cm (Lens Studio world units). The user starts 90 cm in front of the wheel, hub at 100 cm height, slightly below eye level.

| Element | Anchor | Distance | Size | When it shows |
| --- | --- | --- | --- | --- |
| Repair stand | Floor, 90 cm in front of start camera | 90 | Post 120 cm tall, clamp arm 30 cm, light grey | Always |
| Rear wheel assembly | Stand clamp, hub at 100 cm height, wheel plane facing the user | 90 | 70 cm diameter (700c); rim 62 cm; tire torus tube radius 1.6 cm; 16 spokes | Always after "Found it" |
| Tire | On rim | 90 | Mid-grey (not black), 8 bead segments so sections can lift individually | Always |
| Tube | Inside tire | 90 | Light tan torus, 8 segments, valve stem 4 cm at the top (12 o'clock) | Visible once the bead is lifted |
| Valve | Top of rim at 12 o'clock | 90 | Presta, 4 cm, brass color | Always; glows in Step 2 |
| Tool tray | Body-locked, lower right, 40 cm out, 25 cm below eye line | 40 | 20 x 10 cm panel holding 2 tire levers (12 x 2 cm, bright blue) | Steps 4 and 5 only |
| Ghost tool | On the wheel, at the exact target pose | 90 | Same mesh as the lever, 40% alpha, cyan | Only for the current sub-step; disappears on placement |
| Lever socket | Invisible snap target on the bead at the ghost pose | 90 | 4 cm snap radius | Current sub-step only |
| Step marker | 1 cm off the part the step is about | 90 | 3 cm glowing ring, pulsing | Current step only; completed steps leave a small dim tick |
| Step label | 10 cm off its marker, billboarded, light panel behind text | 90 | 16 x 5 cm, one line, 13 pt equivalent | Current step only |
| Far-side chime + edge arrow | Camera-locked at the view edge | 45 | 3 cm arrow | When the current marker is outside the view |
| Thorn hotspot | In the tire tread at 4 o'clock, inside face | 90 | 1 cm glint, invisible until the inspect step | Inspect step only |
| Control bar | Body-locked, lower center, 45 cm out, 25 cm below eye line, `ContainerFrame` | 45 | Back 5 cm, Next 6 cm (brightest), Replay 5 cm; 2 cm gaps | Always |
| Start card | In front of the wheel at 90 cm, light panel | 90 | 24 x 14 cm: "Fix a flat" + big Found it button (6 cm) + stand-in badge | Step 0 only |
| Done card | Above the wheel, billboarded | 90 | 24 x 14 cm: "Tube out, cause found. Ready for the new tube." + time + "Next skill: brake pads" (not clickable in v1) | Last step only |
| Stand-in badge | Corner of the start card | 90 | "stand-in: wheel placed by pinch" | Step 0 |

**Interactions (standard SIK only):**
- `PinchButton`: Found it, Next, Back, Replay.
- `Interactable` + `InteractableManipulation` on each lever: grab from the tray, move, release; a release within 4 cm of the current socket snaps it in.
- `Interactable` on the second lever once hooked: a drag along the rim arc (constrained to the rim circle) peels the bead.
- `Interactable` on the tube end marker: grab and pull 15 cm away from the rim slides the tube out.
- `Interactable` on the valve (Step 2) and on bead segments (Step 3): pinch to act.
- `Interactable` on the thorn hotspot (inspect): pinch to find it.

**Visibility rules:** one step's marker and label at a time. The tool tray appears only when a lever is needed. Completed steps leave a small dim tick on the part. If the current marker is outside the view, a chime plays from its position and the edge arrow points to it. No panel ever sits between the user and the wheel.

**Audio:** tick on buttons, soft click on a snap, zipper on the bead peel, chime from the far side on step 5, "nope" when a lever is released far from the socket, warm chime on Done.

**Additive display:** no black or dark grey anywhere; the wheel is mid-grey, overlays are saturated cyan, blue and green; text on light panels.

---

## 5. Step list (what the Lens does)

| # | Step name | Marker on | Label (one line) | Body action to complete | Model change |
| --- | --- | --- | --- | --- | --- |
| 0 | Start | Start card | "Fix a flat. Pinch Found it when your wheel is in the stand." | Pinch Found it | Wheel and stand appear in front of the user |
| 1 | Deflate | Valve tip | "Unthread the tip and press to deflate" | Pinch the valve | Tire scale shrinks 4% with a hiss |
| 2 | Loosen the bead | Bead at 12 o'clock, then 3, 6, 9 | "Push the bead toward the rim center" | Pinch the 4 lit bead segments in any order | Each segment shifts 0.5 cm inward |
| 3 | First lever | Bead at the valve | "Hook the lever under the bead" | Grab lever A from the tray, place on the ghost | Snap, bead segment lifts 1 cm, ghost gone |
| 4 | Second lever and peel | Bead 5 cm along | "Hook the second lever, then slide it round" | Grab lever B, place, then drag along the rim arc | Bead segments peel up behind the lever with a zipper sound |
| 5 | Pull the tube (far side) | Tube end at 6 o'clock, opposite the valve | "Start opposite the valve. Pull the tube out." | Walk around the stand; grab the tube end and pull 15 cm | Tube slides out of the tire; valve lifts out last |
| 6 | Inspect | Tire inside face | "Find what caused it" | Walk the wheel; pinch the glint at 4 o'clock | Thorn highlights, label: "Thorn. Pull it out before the new tube goes in." |
| 7 | Done | Done card | "Tube out, cause found. Ready for the new tube." (plus time N:MM and "Next skill: brake pads") | Pinch Try again to restart | Resets to step 0 |

Back reverses one step and undoes its model change. Replay re-plays the current step's ghost animation.

---

## 6. Scene and script architecture

**Scene objects (stable names; LEAF finds interactables by name):**
`Stand`, `Wheel` (children `Rim`, `Spokes`, `Tire` with `Bead_0..7`, `Tube` with `TubeSeg_0..7` and `TubeEnd`, `Valve`), `GhostLever`, `LeverSocket`, `LeverA`, `LeverB`, `ToolTray`, `StepMarker`, `StepLabel`, `EdgeArrow`, `ThornHotspot`, `ControlBar` (`BtnBack`, `BtnNext`, `BtnReplay`), `StartCard` (`BtnFoundIt`, `StandInBadge`), `DoneCard` (`BtnTryAgain`), `Audio` (tick, click, zipper, chime, nope, done), `LeafScenarios`.

**Scripts (TypeScript, `BaseScriptComponent`):**
- `RepairManager.ts`: state (`step`, `subStep`, `startTime`), the step machine 0 to 7, enables and disables objects per step, exposes `getState()` for tests.
- `StepDefinitions.ts`: a data table (marker anchor, label text, required action, model change) so steps are content, not code.
- `UIBindings.ts`: subscribes to `PinchButton.onButtonPinched` for all buttons and calls `RepairManager`.
- `LeverPlacement.ts`: on manipulation end, measures distance to `LeverSocket`; within 4 cm snaps, locks the lever, fires `onPlaced`; else plays "nope" and returns the lever to the tray.
- `RimDrag.ts`: constrains the hooked lever to the rim circle during drag; computes the swept angle; raises `BeadSeg_i` as the angle passes each segment.
- `TubePull.ts`: on drag of `TubeEnd` beyond 15 cm from the rim, tweens the tube segments out along the rim tangent.
- `GhostAnimator.ts`: plays the ghost's hooking motion (0.8 s, ease-in-out) on step entry and on Replay.
- `EdgeHint.ts`: projects the current marker into the camera; outside a safe rectangle, enables `EdgeArrow`, aims it, plays the chime from the marker's position once per step.
- `BuildWheel.ts` (editor-time or first-frame): procedural wheel from primitives so parts are separate and colors are controlled. If CLAD prefers `/build-mesh`, keep the same object names.

**Why these choices:** everything is SIK (`PinchButton`, `Interactable`, `InteractableManipulation`, `ContainerFrame`) so the mouse drives it in preview and LEAF can `trigger` and `drag` it. Procedural parts avoid a black imported bike and let the bead and tube move per segment. All motion is per-frame tweens, no imported animation clips, no physics.

---

## 7. Done criteria and LEAF test plan

| # | Done criterion (checkable in preview) | LEAF scenario | Key assertions |
| --- | --- | --- | --- |
| 1 | Pinching Found it places a 70 cm wheel in a stand 90 cm ahead, and step 1's marker sits on the valve | `StartScenario` | `trigger(BtnFoundIt)`; `Wheel` enabled; marker position within 2 cm of `Valve`; `state.step == 1` |
| 2 | Steps 1 and 2 complete by pinching the valve and the four lit bead segments, and only the current step's marker is visible | `DeflateLoosenScenario` | `trigger(Valve)` -> step 2; `trigger(Bead_0,2,4,6)` -> step 3; exactly one `StepMarker` enabled at any time |
| 3 | Dropping lever A on the ghost snaps it and lifts the bead; dropping it 10 cm away rejects it and returns it to the tray | `LeverSnapScenario` | `drag(LeverA)` to socket -> `LeverA` locked, `Bead_0` y raised 1 cm, `GhostLever` disabled; `drag(LeverA)` to socket + 10 cm first -> `LeverA` back at tray position |
| 4 | Dragging lever B along the rim peels the bead, then the far-side marker and chime fire, and pulling the tube end removes the tube | `PeelAndPullScenario` | `drag(LeverB)` along 90 degrees of rim -> `Bead_1..2` raised; marker at `TubeEnd` enabled; `EdgeArrow` enabled while camera faces the valve; `drag(TubeEnd)` 15 cm -> `TubeSeg_*` outside the tire |
| 5 | Pinching the thorn ends the repair with a timed Done card; Back and Replay work at every step; Try again returns to step 0 | `InspectDoneScenario` | `trigger(ThornHotspot)` -> `DoneCard` enabled, text contains ":"; `trigger(BtnBack)` from step 4 -> step 3 and `Bead_0` restored; `trigger(BtnReplay)` restarts `GhostAnimator`; `trigger(BtnTryAgain)` -> step 0 |

**Test hygiene (from Snap's LEAF docs):** `await` every interactor call; `nextFrame()` or `sleep()` before assertions; stable names; matched LEAF, SIK and Lens Studio versions via `/specs-leaf-install-packages`; use `/verify-preview` for quick checks during the build and LEAF once behavior is locked.

**Logic proven vs. feel unproven (say it on screen and in the README):** proven in preview: step order, snap logic, bead peel, tube pull, visibility rules, far-side cue, timing. Unproven: aligning the virtual wheel to a real one, lever force and feel, whether a ghost tool reads well against a real tire, chime timing while actually working.

---

## 8. Toolchain and commands

Order matters: Lens Studio first, then Claude Code from the project folder.

1. Lens Studio 5.22 or newer, signed in. Open `Specs Base Template.esproj` in this folder.
2. `node -v`, `git --version` (both already used by the skill pack).
3. From the project folder: `claude`. Trust the folder. Approve the `lens-studio` MCP server ("use this and all future MCP servers in this project").
4. In Claude Code: `/plugin marketplace add https://github.com/lens-studio-devs/ls-extensions.git`, then `/plugin install ls-clad@ls-extensions`, then `/reload-plugins`.
5. Verify: `/mcp` shows `lens-studio` connected; `/plugin` Installed lists CLAD. The skill pack lives at `.claude/skills/plan-lens/` (moved there on Oct 23, 2026: the Lens Studio Agents-Docs plugin deletes any `.agents/` folder on every project load and save, so the default `npx skills add` location does not survive). If it is missing, `git checkout -- .claude/skills/plan-lens` restores it; do not re-run `npx skills add` into `.agents/`.
6. Optional: Shift+Tab to auto mode to reduce permission prompts. A full CLAD build can take 30+ minutes.
7. Preview: Interactive Preview Mode with the SPECS simulation so the additive display is shown. WASD/QE/mouse.

Troubleshooting: https://developers.specs.com/docs/clad/troubleshooting/troubleshoot-lens-studio-mcp and .../troubleshoot-lens-studio-plugin.

---

## 9. Verifications to run before the main build (first CLAD session, 15 minutes)

1. **Black in preview.** Place a black cube and a mid-grey cube in the SPECS preview with simulation on. Record whether black vanishes. Either way, keep the wheel mid-grey.
2. **Procedural wheel in one pass.** Ask CLAD for `Stand` + `Wheel` with the object names in Section 6, nothing else. Confirm the parts are separate objects with separate materials.
3. **LEAF install.** `/specs-leaf-install-packages`, then one trivial scenario that triggers a `PinchButton`. Confirm it passes in the LEAF panel.
4. **Grab in preview.** One lever with `Interactable` + `InteractableManipulation`; confirm the mouse can grab, move and release it, and that LEAF `drag` moves it.
If 2 or 4 fail after two attempts, simplify: levers become pinch-to-place (pinch the ghost) instead of grab-and-drop, and the plan still holds.

---

## 10. Workflow

**Step A, the plan-lens interview (the builder, 20 to 30 minutes).** With Lens Studio open and Claude Code in the folder, say "Run the plan-lens skill." It asks six to eight open questions. Prepared thinking, in the builder's own words:
1. Idea: a hands-free guide to fixing a flat, with each instruction on the part it is about.
2. Spatial moment: Section 2 (levers at the valve, then the tube end on the far side).
3. Product or overlay: a trainer on a virtual wheel; the real wheel is a stand-in via a Found it pinch.
4. Where things live: on the rim, tire and valve, 90 cm away, below eye level; controls low near the hands.
5. Hands: pinch buttons, grab-and-place levers, drag along the rim; no custom gestures, no voice.
6. When things show: one step's marker and label; tray only when a lever is needed; chime and edge arrow for the far side.
7. Done: the five criteria in Section 7.
Approve the brief with "looks good." It lands at `devpost/design-brief.md`.

**Step B, first build (unattended, 30+ min).** `/clear`, then paste: "Read devpost/design-brief.md and build it for SPECS. Follow the brief closely. Get the basic flow working first, then add detail. Write and run LEAF tests for each done criterion, and tell me which pass." Commit before and after.

**Step C, iteration passes (one ask per pass, then `/verify-preview`, commit, and a dated line in `devpost/design-notes.md`):**
1. Stand, wheel, start card, Found it, step machine with markers and labels (criteria 1 and 2).
2. Tool tray, lever A snap and reject (criterion 3).
3. Lever B rim drag and bead peel; far-side marker, chime, edge arrow; tube pull (criterion 4).
4. Inspect hotspot, Done card with timer, Back and Replay for every step, Try again (criterion 5).
5. Control bar and label placement and sizes per Section 4; check by walking the preview.
6. Audio, colors for the additive display, stand-in badge, dim ticks for completed steps.
7. `/specs-leaf-write-scenarios`, `/specs-leaf-run-in-preview`; fix until five pass; paste results into the README.
Feature freeze after the Nov 5 project review.

**Prompting CLAD:** describe the outcome and name the kit ("use SIK PinchButton and InteractableManipulation"), one thing per pass, keep generated LEAF tests, append "for SPECS" to invoke the Experience Builder for a full pass.

---

## 11. Demo video plan (under 3 minutes, YouTube, preview recording with real voice)

| Time | Shot | Line |
| --- | --- | --- |
| 0:00-0:15 | Photo or clip: greasy hands, phone propped on a bench | "You're guessing which way the lever goes. Bench Coach puts the next move on the wheel." |
| 0:15-0:30 | Preview: walk up to the wheel in the stand | "Phone guides show someone else's wheel from their angle. This is yours, from yours." |
| 0:30-0:45 | Found it, stand-in badge, deflate, loosen the bead | "The preview can't see a real wheel, so I pinch to place one. Everything after is real." |
| 0:45-1:15 | Lever A ghost, grab, snap, bead lifts; lever B, drag, zipper peel | "Instructions on the part. The model changes when I act." |
| 1:15-1:45 | Far-side chime, edge arrow, walk around the stand, pull the tube | "The step you can't see is on the other side, and it tells you." |
| 1:45-2:05 | Inspect: find the thorn; Done card with time; "Next skill: brake pads" | "It also makes you find the cause, so the flat doesn't come back." |
| 2:05-2:25 | Terminal: CLAD building through the MCP; LEAF panel, five green | "Planned with plan-lens, built by CLAD, five done criteria, five passing tests." |
| 2:25-2:45 | Two labels: logic proven, feel unproven | Name what's unproven: aligning to a real wheel, lever feel. |
| 2:45-3:00 | Title card, repo link | |

Record the terminal and LEAF segments during the build. Keep the cursor visible so pinches are legible.

---

## 12. Risks and mitigations

| Risk | Mitigation |
| --- | --- |
| Looks like a step-coach slideshow | Every step needs a body action; the model changes; step 5 is on the far side; inspect is a search. No step is text plus Next. |
| Grab-and-drop fiddly with a mouse | 4 cm snap radius; reject returns the lever to the tray; fallback to pinch-the-ghost if Section 9 test 4 fails |
| Black wheel vanishes on the additive display | Mid-grey wheel, bright overlays; verify in Section 9 test 1 |
| Rim drag and bead peel are hard for CLAD | Bead is 8 rigid segments; the drag is constrained to a circle; segments just raise 1 cm |
| Tube and tire deformation | No deformation: tube segments tween out along the tangent; tire never deforms |
| LEAF can't find an object | Stable names from Section 6; never rename after tests exist; versions matched |
| Preview room furniture intersects the stand | Spawn 90 cm ahead of the start camera; test in the default room |
| Innovation score | Lead the pitch with "instructions on the wheel, far side included," not "repair guide." Check Discord for step-coach entries before Nov 1; if crowded, sharpen the far-side and inspect moments further rather than switching |
| Time | Criteria 1 to 3 are the product; 4 and 5 are polish. Freeze Nov 5. |

---

## 13. Timeline

| Date | Milestone |
| --- | --- |
| Oct 22 | Live build session 12 PM ET; Section 9 verifications |
| Oct 23 | plan-lens interview; brief approved; first CLAD build |
| Oct 24-30 | Passes 1-3; criteria 1-3 green in `/verify-preview` |
| Oct 31-Nov 4 | Passes 4-6; five LEAF scenarios green |
| Nov 5 | Live project review 12 PM ET; feature freeze |
| Nov 6-8 | Video, README (builder writes), repo cleanup and public |
| Nov 8 | Submit (one day of slack) |
| Nov 9, 5 PM ET | Deadline. Winners Nov 19 |

---

## 14. Submission checklist

- [ ] `/mcp` shows `lens-studio`; `/plugin` shows `ls-clad`
- [ ] Section 9 verifications done and recorded in `devpost/design-notes.md`
- [ ] plan-lens interview done; `devpost/design-brief.md` approved
- [ ] First CLAD build committed
- [ ] Criteria 1-3 pass `/verify-preview`
- [ ] Criteria 4-5 pass; audio, edge arrow, badge, ticks in
- [ ] Five LEAF scenarios green; results in README
- [ ] `devpost/design-notes.md` has at least two dated iterations with reasons
- [ ] Terminal and LEAF footage recorded
- [ ] Video under 3 minutes, public on YouTube
- [ ] README written by the builder: what it does, who it's for, what was learned, pre-existing code disclosed (SIK, LEAF, template, any CC-BY model with attribution)
- [ ] `.mcp.json`, `spk_debug_key.pem`, private docs out of the repo; repo public
- [ ] Devpost form submitted by Nov 8

---

## 15. Sources

- Learn AR with SPECS: https://learn-specs.devpost.com/ and https://learn-specs.devpost.com/resources
- Skill pack (plan-lens, ar-design-rules.md, preview-limits.md): https://github.com/challengepost/learn-specs
- CLAD setup for Claude Code: https://developers.specs.com/docs/clad/setup/setup-ai/claude-code-setup
- How CLAD works: https://developers.specs.com/docs/clad/overview-section/how-clad-works
- CLAD agents and skills: https://developers.specs.com/docs/clad/overview-section/agents-and-skills
- LEAF: https://developers.specs.com/docs/clad/tools/test-your-lens-with-leaf
- ls-extensions marketplace: https://github.com/lens-studio-devs/ls-extensions
- SIK UI elements: https://developers.snap.com/spectacles/spectacles-frameworks/spectacles-interaction-kit/features/ui-elements
- SIK UI composites: https://developers.snap.com/spectacles/spectacles-frameworks/spectacles-interaction-kit/features/ui-composites
- SIK interaction system: https://developers.snap.com/spectacles/spectacles-frameworks/spectacles-interaction-kit/features/interactionsystem
- Positioning and sizing: https://developers.snap.com/spectacles/best-practices/design-for-spectacles/positioning-sizing-content
- Design best practices: https://developers.snap.com/spectacles/best-practices/design-for-spectacles/design-best-practices
- Preview panel: https://developers.snap.com/spectacles/get-started/start-building/preview-panel
- SPECS sample projects: https://github.com/specs-devs/samples
- Park Tool, Tire and Tube Removal and Installation: https://www.parktool.com/en-us/blog/repair-help/tire-and-tube-removal-and-installation
- Free low-poly bicycle models (CC-BY): https://poly.pizza/search/bicycle
- Team research: `docs/IDEAS.md`, `docs/WINNING_RESEARCH.md`, `docs/COUNCIL_DEBATE.md`, `docs/council/fitcheck-vs-benchcoach.md`, `docs/JUDGES.md`, `AGENT_BRIEF.md`
