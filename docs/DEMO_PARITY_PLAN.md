# Bench Coach vs. the showcase Spectacles apps: what to add, and what is honestly possible

Status: proposal, Oct 24, 2026. Nothing here is decided. The builder picks; this file is a menu with feasibility notes.
Reads with: `docs/BENCH_COACH_PLAN.md` (concept, criteria 1–5), `docs/PASSES_7_TO_10_PLAN.md` (passes 8 and 10 still to run), `AGENT_BRIEF.md` Section 0 (ground rules).
Private: this file lives in `docs/`, which moves out of the repo before it goes public.

---

## 1. Bottom line

- **Matching those apps in *feel* is possible** in the Lens Studio preview, and Bench Coach already beats most of them on the things this hackathon judges: instructions on the part, a model that changes as you act, a step on the far side, and 9+ LEAF scenarios that prove it.
- **Matching HandymanAI's core trick, seeing your real wheel through the camera and reacting to it, is not possible for this submission.** Nobody has glasses, and the preview camera sees a simulated room, not a tire. The "Found it" stand-in stays. Claiming otherwise in the video would hurt the Design and Presentation scores.
- **Two AI-style features are *probably* possible in preview and need a 30-minute spike each before committing:** voice commands (ASR) and an "Ask the coach" answer (Remote Service Gateway to Gemini/OpenAI). The CLAD `specs-asr` skill says ASR "works in both Lens Studio Preview and on-device", which **conflicts with** `BENCH_COACH_PLAN.md` 3.3 ("voice: can't show"). Settle it with the spike, not by argument.
- **Time is the real limit.** Today is Oct 24; feature freeze is Nov 5. Passes 8 (learning layer) and 10 (watch mode) are still planned. Anything added below must fit inside that window or replace something.

## 2. The four showcase apps, mapped to Bench Coach

Descriptions come from a pasted ChatGPT summary and are **unverified**. Check each on Snap's newsroom or Snap Engineering before citing it in the README or video.

| App (claimed) | Its key move | Bench Coach today | Gap worth closing |
| --- | --- | --- | --- |
| HandymanAI: repair help from camera + voice | Sees the real job; you talk to it | Virtual wheel, pinch-to-place stand-in; buttons only | Hands-free voice (spike B). Real-world recognition: **not possible** in preview |
| Piano Tutor: notes on real keys + ML feedback | Overlays on the real object; grades you | Overlays on the part; mistakes table planned in pass 8 | A **Coach report** that grades the run (D) |
| NavigatAR: glowing arrows to a destination | Draws a path in the world | Edge arrow + chime for the far side | **Floor path** around the stand on step 5 (E) |
| Magic Science Lab: hands-on virtual chemistry | Physical, playful hand interaction | Grab, snap, drag-along-rim, pull | **Physics moments**: thorn drops, old tube tossed in a bin (F) |

What none of them show, and Bench Coach does: a step you must walk around the object to reach, an inspect step that is a search, and an automated test suite. Lead with that.

## 3. Candidate features, with honest feasibility

Legend: Preview = can it be shown in the Lens Studio preview without glasses.

| ID | Feature | Preview | Effort | Risk | Recommendation |
| --- | --- | --- | --- | --- | --- |
| A | **Ask the coach**: preset question chips on the current part ("Why start opposite the valve?", "Presta or Schrader?") → Remote Service Gateway → Gemini/OpenAI → one-line answer on a light panel next to the part. Canned answers as offline fallback | Likely (needs internet + RSG token; spike first) | M | Network fails mid-demo; tokens must never be committed; judges may read it as "chatbot in your face" | **Spike**, adopt only if the answer lands on the part, not in a floating panel |
| B | **Voice commands**: "next", "back", "repeat", "what's this" via `AsrModule`, matched on the transcript. Matches the "greasy hands" pitch | Skill says yes; plan says no. **Spike** | S–M | Latency; mic in the recording; skill warns ASR isn't built for keyword spotting | **Spike first.** Strongest story fit of anything here |
| C | Camera + AI vision: "look at my tire, what caused the flat?" | **No** (preview camera sees the sim room, not a tire). Snapshotting the virtual wheel to an AI would be a fake | M | Dishonest demo | **Skip.** Say in the README it's the on-device next step |
| D | **Coach report**: end card grades the run (time per step, lever drops rejected, mistakes from pass 8, hints used) with one "practice this next" tip | Yes, pure logic | S | Low | **Do**. Fold into pass 8 or the FinishCard |
| E | **Floor path**: pulsing footprints/arrows on the floor mat from the front of the stand to the far side when step 5 starts; fade when you arrive | Yes | S | Low | **Do**. Improves the launch-reel shot |
| F | **Physics moments**: pulled thorn drops and bounces on the mat; old tube can be grabbed and thrown into a bin | Yes (physics works in preview) | M | Physics jitter; LEAF needs polling | Optional, after D and E |
| G | Pump strokes: inflate by dragging a pump handle N times instead of a single action (check what pass 9 built first) | Yes | S–M | Low | Optional |
| H | AI-generated props (Snap3D, Imagen) | Yes | S | Gimmick; adds nothing to the repair | Skip |
| I | Two-person mode (mentor + learner) via Sync Kit | Partly (multiple previews), heavy setup | L | High | Skip |
| J | Saved progress / skills tree in Snap Cloud | Not showable (no persistence in preview story) | M | Medium | Skip |
| K | Aligning to a real wheel | **No**, needs glasses | n/a | n/a | Keep the stand-in, say so on screen |

**Recommended package:** D + E for sure (small, safe, demoable). Spike B and A on day one. Adopt B if it works (it's the better pitch fit). Adopt A only if B fails or there's slack, and keep it button-triggered with canned fallback.

**Cut order if behind:** A, then F/G, then B. Never cut D, E, the final LEAF sweep or watch mode (watch mode is your video safety net).

## 4. Fitting it into the calendar

| Date | Work |
| --- | --- |
| Sat Oct 25 | Builder: plan-lens interview (unchanged). Agent: spike B (ASR in preview) and spike A (RSG round-trip), 30 min each, results in `devpost/design-notes.md`. |
| Oct 26–30 | Passes 8a/8b as planned, plus D (Coach report) and E (floor path) as pass 8c. |
| Oct 31 | Buffer. If spike B passed: voice pass (B). Else if spike A passed: A. |
| Nov 1–2 | Pass 10 (watch mode) + final LEAF sweep including new scenarios. |
| Nov 3–4 | F/G only if everything is green. Dry run. |
| Nov 5 | Live review, freeze. |

New LEAF scenarios to add: `coach-report` (forced mistakes → report numbers), `floor-path` (enabled on step 5 entry, disabled on arrival), `voice-commands` if B lands (call the command handler with a fake transcript; never depend on a real mic in LEAF), `ask-coach-fallback` if A lands (offline path returns the canned answer).

## 5. Tools, plugins and skills

Already in use (keep):
- **Lens Studio 5.22+** with the **Lens Studio MCP** (`mcp__lens-studio__*`): all scene and script work.
- **CLAD plugin** `ls-clad@ls-extensions` (`/plugin marketplace add https://github.com/lens-studio-devs/ls-extensions.git`).
- **Spectacles Interaction Kit (SIK)**: `Interactable`, `InteractableManipulation`, `PinchButton`, `ContainerFrame`.
- **Spectacles UI Kit**: panels, buttons, `ProgressBar` fallback.
- **LEAF** (`Leaf.lspkg`) for tests.
- **TypeScript** `BaseScriptComponent` scripts in `Assets/BenchCoach/Scripts`.

CLAD skills and agents per feature:

| Feature | Skills / agents | Packages |
| --- | --- | --- |
| A Ask the coach | `ls-clad:specs-ai-remote-service`, `ls-clad:specs-internet` | `RemoteServiceGateway.lspkg` **0.2.0+** (token plugin generates SNAP/OPENAI/GOOGLE tokens from your Snap login) |
| B Voice | `ls-clad:specs-asr`, `ls-clad:specs-audio` | ASR module (built in) |
| D Coach report | `ls-clad:specs-build-ui`, `ls-clad:lens-api` | UI Kit |
| E Floor path | `ls-clad:mesh-builder-scripting`, `ls-clad:materials`, `ls-clad:vfx-graph` (optional glow) | none new |
| F Physics | `ls-clad:physics`, `ls-clad:specs-interaction-recipes` | none new |
| G Pump | `ls-clad:specs-interaction-recipes`, `ls-clad:build-sfx` | none new |
| Sounds | `ls-clad:build-sfx` | n/a |
| Every pass | `ls-clad:specs-experience-builder` (agent), `ls-clad:verify-preview`, `ls-clad:specs-leaf-write-scenarios`, `ls-clad:specs-leaf-run-in-preview`, `ls-clad:lens-debug`, `ls-clad:specs-debug` | n/a |
| Perf check (Nov 3) | `ls-clad:specs-lens-perf-attribution` | n/a |

Not useful here: `specs-camera`, `specs-depth`, `specs-world-query`, `specs-custom-locations` (all need real-world input the preview can't fake honestly), `specs-sync-kit`, `specs-snap-cloud`, `specs-keyboard` (doesn't render in the SPECS 27 preview simulation).

## 6. Guardrails (unchanged from the brief, repeated because new features tempt breaking them)

- Builder leads. Agent never writes README, Devpost text, project name, reflection or survey answers.
- CLAD builds the Lens through the MCP. No raw HTTP to Lens Studio.
- Everything must work in preview. If a spike fails twice, drop the feature.
- No RSG tokens, `.mcp.json`, `spk_debug_key.pem` or private docs in commits. Check `git diff --cached` for token strings before every commit once RSG is installed.
- Additive display: no black or dark grey.
- Stable object names; never rename after a LEAF scenario uses them.
- Disclose in the README: SIK, UI Kit, LEAF, RSG, Base Template, CLAD-generated code, any AI-generated asset, and any model provider called at runtime.

## 7. The prompt to paste into Claude Code

Open Lens Studio with `Specs Base Template.esproj` first, then run `claude` from `~/learn-ar-specs-lens` and paste:

```text
Read AGENT_BRIEF.md section 0, docs/BENCH_COACH_PLAN.md, docs/PASSES_7_TO_10_PLAN.md,
docs/DEMO_PARITY_PLAN.md and the last 40 lines of devpost/design-notes.md. Then check
git log and confirm which passes are done.

Goal: make Bench Coach stand up next to the showcase Spectacles apps (HandymanAI,
Piano Tutor, NavigatAR, Magic Science Lab) without breaking the ground rules. Do
not write any README, Devpost or submission text.

Step 1, spikes only (no feature code yet). Using the Lens Studio MCP and CLAD skills:
  a) ls-clad:specs-asr: does AsrModule return a transcript in the Lens Studio preview
     with SPECS simulation on? Build the smallest throwaway test, then remove it.
  b) ls-clad:specs-ai-remote-service: with RemoteServiceGateway 0.2.0+, does one
     Gemini or OpenAI text call return in preview? Throwaway test, then remove it.
     Make sure no token ends up in a tracked file.
Report pass/fail with evidence (log lines, screenshots), add a dated facts-only entry
to devpost/design-notes.md, and stop. I will choose which features to build.

Rules: all scene work through mcp__lens-studio__* and CLAD; never raw HTTP to Lens
Studio; everything must work in preview; no black or dark grey; keep object names
stable; one agent owns the preview; commit small with clear messages; never commit
.mcp.json, spk_debug_key.pem or tokens. If an MCP tool fails, stop and tell me.
```

After you pick features, follow-up prompt per pass:

```text
Build feature <D/E/B/A> from docs/DEMO_PARITY_PLAN.md section 3 for SPECS, as its own
pass. Use ls-clad:specs-experience-builder and the skills listed for it in section 5.
Add the LEAF scenario named in section 4, run all scenarios from the default camera
pose, /verify-preview, then commit. Tell me what passed and what didn't.
```
