# Bench Coach: team task list

Status as of Oct 24, 2026. **Current order of work: `docs/INTEGRATION_PLAN.md`** (pass 10, spikes, pass 11, conditional pass 12). Branch `Sujeeth-AR-SPECS-WORK` is the integration branch. Full design: `docs/PASSES_7_TO_10_PLAN.md`. Build history and pitfalls: `devpost/design-notes.md` (read its "Findings" lists before touching code).

Done: criteria 1 to 5, six LEAF scenarios green (`start`, `deflate-loosen`, `lever-snap`, `peel-and-pull`, `inspect-done`, `step-ticks`).

Done: **Pass 7a** (curved levers, tread, valve and bead glow, hiss, tube hidden until a bead lifts, peel to 5 o'clock, segment-by-segment pull). Eight LEAF scenarios green, adding `scene-dressing`. Done: **Pass 7b** (workbench, pegboard, toolbox, saddle, code-built bike frame, floor mat, key and fill lights with shadows on the mat). Done: **Pass 9** (halfway card with Continue, fit the new tube, seat the bead, hold-to-inflate, Finish card with stats). Ten LEAF scenarios green. Done: **Pass 8** (What's this? mode, mistake feedback, random flat cause, progress rail, idle hints) and follow-ups F1 to F3. Fourteen LEAF scenarios green. Done: **Pass 10** (watch mode, about 57 s end to end; control bar narrowed). Fifteen LEAF scenarios green. Done: **Pass 12, Ask the coach** (RSG + Gemini 2.5 Flash, preset questions per step, answer next to the part, offline fallback). Sixteen LEAF scenarios green. Voice test skipped by choice. Done: **Pass 11** (floor path around the stand on step 5; Finish card with slowest steps and a practice line). Eighteen LEAF scenarios green. **Next up: friend handoff below; then F5 hands-on walk, perf check and the dry run (see `docs/INTEGRATION_PLAN.md`).**

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
| B3 | **DONE.** **Pass 8: learning layer.** "What's this?" mode, mistake feedback with reasons, random flat cause (thorn, glass, snakebite), progress rail, idle hints. LEAF `whats-this`, `mistakes`, `flat-causes`, `progress-idle`. | B2 | Plan "Pass 8". Cut "What's this?" first if late. Ready now. Do F1 first. |
| B4 | **DONE.** **Pass 10: watch mode.** Auto-play demo from a Watch button, stoppable. LEAF `watch-mode`. Then run all scenarios and record results in design notes. | B3 | Plan "Pass 10". Ready now. |

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
| F1 | **DONE.** **Clear the Lens Studio cache.** Close Lens Studio, delete the project's `Cache/` folder, reopen. Since Oct 24 the cache blocks edits to `BodyFollow.ts`, `StepTicks.ts`, `ThornHotspot.ts` ("duplicate of the loaded id"), so changes to those files silently never run. Pass 8 edits `ThornHotspot.ts`, so this must happen first. | `Cache/` is not in git; deleting it is safe. |
| F2 | **DONE.** **Tray holds still while the new tube is held.** After F1, add `NewTubeEnd` to `BodyFollow`'s list of held objects (same as the levers). | A few lines; see the Pass 9 entry in `devpost/design-notes.md`. |
| F3 | **DONE.** **Halfway card height.** Its title and time sit just above the default view (buttons visible). Lowering it brings back the lever-A overlap fixed earlier; pick a position that clears both. | Visual check in the preview. |
| F4 | **DONE.** **Control bar width.** Pass 8 widened the bar to 29.5 cm for the What's this? button and progress rail. Looking down, the info button is clipped at the left edge of the view and the bar's right end tucks under the tool tray. Shrink the gaps or move the info button. | Seen on a screenshot after pass 8; do with or after pass 10. |
| F5 | **Hands-on walk with the mouse** of the whole repair, including What's this? (do the info boxes win over the levers?) and the idle hint. LEAF skips the ray, so this is untested. | Anyone. |

## Handoff: Ask the coach + AI voice (friend)

Ask the coach is built (pass 12). The friend owns it from here and adds AI voice. Until the friend says otherwise, nobody else edits `AskCoach.ts`, `BenchCoachAskChipsUI.ts`, `BenchCoachAskAnswerUI.ts` or the Ask parts of `StepDefinitions.ts`.

**Setup (once)**
1. Clone the repo, check out `Sujeeth-AR-SPECS-WORK`, branch off it (for example `ai-coach-voice`).
2. `brew install git-lfs && git lfs install && git lfs pull`.
3. Lens Studio 5.22+, signed in; open `Specs Base Template.esproj`. Claude Code from the folder, approve the `lens-studio` MCP; `/plugin marketplace add https://github.com/lens-studio-devs/ls-extensions.git`, `/plugin install ls-clad@ls-extensions`.
4. Read this file's rules, `docs/INTEGRATION_PLAN.md`, and the "Pass 12: Ask the coach" entry at the end of `devpost/design-notes.md`.
5. Recompile; fix any "Input X was not provided" in the Logger by rewiring in the Inspector.

**How it works now:** `Assets/BenchCoach/Scripts/AskCoach.ts` calls Gemini `gemini-2.5-flash` (thinking off, about 1.1 s) through Remote Service Gateway 2.0.1. Questions and offline answers are in `StepDefinitions.ts` (three per repair step). Any error, missing token, no internet or a 6 s timeout falls back to the offline answer, tagged "offline". Test: `ask-coach-fallback` (never uses the network). Model notes: `gpt-4.1-nano` is deprecated and `gemini-2.0-flash` returns 404 through RSG; `gpt-4o-mini` works as an OpenAI alternative.

**Tokens (hard rule):** RSG tokens live in the scene file and must never be committed. Before a live test or demo follow `tools/set-coach-tokens.md` (snippets `tools/coach-tokens-set.ts` / `tools/coach-tokens-clear.ts`); clear them before every save. Run `tools/check-no-tokens.sh` before every commit; it must print OK.

**AI voice, what is possible**
- **Coach speaks its answer:** possible in the preview. RSG can call OpenAI text-to-speech and play the result through an `AudioComponent` (needs internet and tokens). Add a mute toggle, keep the text answer visible, fall back silently when offline. Add a LEAF check that does not need the network (for example, the request is made and the mute flag is respected).
- **Talking to the coach (voice commands / ASR):** only works on real Specs glasses; in the preview it always hears nothing. Build only if you can test on paired glasses. Keep buttons as the fallback; LEAF must call the handler with a fake transcript, never a real mic.
- Do not use the deprecated Lens `TextToSpeechModule`.

**Open items you inherit**
- Step 5: the label and answer sit behind the control bar from the start pose (the walk-around step).
- Step 6: the question chips clip about 2 cm at the left edge; steps 2 to 4: the answer's first line sits in the faded top edge.
- Live answers sometimes add analogies; tighten the system prompt in `AskCoach.ts`.

**Rules:** one person edits `Assets/Scene.scene` at a time (say so in chat); every LEAF scenario passes from the default preview camera before you push (run one per call); nothing black or dark; build through Claude Code with the CLAD Specs experience builder; tell the team every AI provider you call so the README can disclose it (currently RSG and Google Gemini).
