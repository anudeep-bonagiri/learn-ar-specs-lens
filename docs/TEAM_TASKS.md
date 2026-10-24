# Bench Coach: team task list

Status as of Oct 24, 2026. Branch `Sujeeth-AR-SPECS-WORK` is the integration branch. Full design: `docs/PASSES_7_TO_10_PLAN.md`. Build history and pitfalls: `devpost/design-notes.md` (read its "Findings" lists before touching code).

Done: criteria 1 to 5, six LEAF scenarios green (`start`, `deflate-loosen`, `lever-snap`, `peel-and-pull`, `inspect-done`, `step-ticks`).

Done: **Pass 7a** (curved levers, tread, valve and bead glow, hiss, tube hidden until a bead lifts, peel to 5 o'clock, segment-by-segment pull). Eight LEAF scenarios green, adding `scene-dressing`. Done: **Pass 7b** (workbench, pegboard, toolbox, saddle, code-built bike frame, floor mat, key and fill lights with shadows on the mat). Done: **Pass 9** (halfway card with Continue, fit the new tube, seat the bead, hold-to-inflate, Finish card with stats). Ten LEAF scenarios green. **Next up: B3 (pass 8).**

## Rules so we don't break each other

1. **One person owns `Assets/Scene.scene` at a time.** It does not merge cleanly. Say in chat when you take it and when you push.
2. Pull before you start, push when you stop. Build on top of the latest `Sujeeth-AR-SPECS-WORK`.
3. Install git-lfs once (`brew install git-lfs && git lfs install`). Audio, meshes and images are LFS; without it you get 130-byte stub files.
4. After a pull, recompile in Lens Studio and check the Logger for "Input X was not provided". Lens Studio drops script references when it loads a scene before the scripts compile; rewire them in the Inspector.
5. Lens Studio deletes any `.agents/` folder. The plan-lens skill lives at `.claude/skills/plan-lens/`.
6. All LEAF scenarios must pass from the default preview camera before you push.

## Build tasks (one agent pass each, in this order)

| # | Task | Depends on | Notes |
| --- | --- | --- | --- |
| B1 | **DONE.** **Pass 7b: scene dressing.** Text-to-3D workbench and pegboard (pale colors), MeshBuilder bike rear triangle from the hub, floor mat, key and fill lights with shadows on the mat, metallic rim and hub. Finish `scene-dressing` assertions (Environment and BikeFrame). | Ready now | Plan "Pass 7". Owns the scene file. |
| B2 | **DONE.** **Pass 9: finish the repair.** Steps 8 to 11: halfway card with Continue, fit the new tube, seat the bead, pinch-and-hold inflate, Finish card with stats. `StepModule` seam, `RefitSteps.ts`, `TubeFit.ts`, `RunStats.ts`. LEAF `refit-tube`, `seat-inflate`. | B1 | Plan "Pass 9". Runs before pass 8 on purpose. Ready now. |
| B3 | **Pass 8: learning layer.** "What's this?" mode, mistake feedback with reasons, random flat cause (thorn, glass, snakebite), progress rail, idle hints. LEAF `whats-this`, `mistakes`, `flat-causes`, `progress-idle`. | B2 | Plan "Pass 8". Cut "What's this?" first if late. Ready now. Do F1 first. |
| B4 | **Pass 10: watch mode.** Auto-play demo from a Watch button, stoppable. LEAF `watch-mode`. Then run all scenarios and record results in design notes. | B3 | Plan "Pass 10". |

## Tasks that can run in parallel with the builds (no scene file)

| # | Task | Owner | Notes |
| --- | --- | --- | --- |
| P1 | **plan-lens interview**, writes `devpost/design-brief.md`. Learner-led: answer it yourself, do not paste the plan in. | Sujeeth (builder) | Required by the hackathon rules. Fresh Claude Code session in this folder. |
| P2 | **Hands-on preview walk** after each pass: play the whole repair with the mouse, note anything confusing, wrong or ugly in `devpost/design-notes.md` with a date. | Anyone | Tests can't catch feel problems. |
| P3 | **Video script and shot list**, under 3 minutes, from plan Section 11. Decide who narrates. | Anyone | Record after B4. |
| P4 | **README draft**, written by a human: what it does, who it's for, why glasses, what we learned, how CLAD and the MCP were used, disclosures (SIK, UIKit, LEAF, Base Template, CLAD-generated code, text-to-3D assets). | Team, in your own words | Agents may check facts and paste the LEAF table, not write prose. |
| P5 | **Project name** and rename `Specs Base Template.esproj` plus the README title. | Team decision | Do the file rename once, by the scene owner, after B4. |
| P6 | **Check Discord** for other step-coach entries and adjust the pitch if crowded. | Anyone | Plan Section 12. |
| P7 | **Live review prep** (Thu Nov 5, 12 PM ET): demo order, one-minute pitch, who presents. | Anyone | Feature freeze after the review. |

## Submission tasks (Nov 6 to 8)

| # | Task | Notes |
| --- | --- | --- |
| S1 | Record and upload the video, public on YouTube. | |
| S2 | Move private docs out of the repo: `AGENT_BRIEF.md` and everything in `docs/` except `HACKATHON.md` and `SUBMISSION_CHECKLIST.md`. Confirm `.mcp.json` and `spk_debug_key.pem` are not tracked. | Before making the repo public. |
| S3 | Merge the final work into `main`, make the repo public. | |
| S4 | Fill the Devpost form with video and repo links. Submit by **Sat Nov 8**. Deadline Mon Nov 9, 5 PM ET. | |

## Follow-ups from pass 9 (do before pass 8)

| # | Task | Notes |
| --- | --- | --- |
| F1 | **Clear the Lens Studio cache.** Close Lens Studio, delete the project's `Cache/` folder, reopen. Since Oct 24 the cache blocks edits to `BodyFollow.ts`, `StepTicks.ts`, `ThornHotspot.ts` ("duplicate of the loaded id"), so changes to those files silently never run. Pass 8 edits `ThornHotspot.ts`, so this must happen first. | `Cache/` is not in git; deleting it is safe. |
| F2 | **Tray holds still while the new tube is held.** After F1, add `NewTubeEnd` to `BodyFollow`'s list of held objects (same as the levers). | A few lines; see the Pass 9 entry in `devpost/design-notes.md`. |
| F3 | **Halfway card height.** Its title and time sit just above the default view (buttons visible). Lowering it brings back the lever-A overlap fixed earlier; pick a position that clears both. | Visual check in the preview. |
