# Bench Coach: integration plan (demo parity + remaining passes)

Status: Oct 24, 2026, evening. Reconciles `docs/DEMO_PARITY_PLAN.md` (written before passes 8 and 9 landed) with what is actually built, and folds it into `docs/PASSES_7_TO_10_PLAN.md`. Private: lives in `docs/`, which moves out of the repo before it goes public.

## 1. Where we are

Built and pushed (`Sujeeth-AR-SPECS-WORK`, f7045ea): passes 7a, 7b, 9 and 8. The repair runs end to end, 0 to 11: deflate, loosen, two levers with a rim peel, far-side tube pull, inspect, halfway card, fit the new tube, seat the bead, hold-to-inflate, Finish card. Workshop scene, bike frame, What's this? mode, mistake feedback, random flat cause, progress rail, idle hints. 14 LEAF scenarios pass from the default camera pose.

Still planned: pass 10 (watch mode + final LEAF sweep), follow-ups F4 (control bar width) and F5 (hands-on mouse walk) from `docs/TEAM_TASKS.md`.

## 2. The parity proposal, item by item

| ID | Feature | Status today | Decision |
| --- | --- | --- | --- |
| D | Coach report on the end card | **Mostly built.** Finish card shows time, lever misses, hints, mistakes source, cause and a prevention tip | Finish it in pass 11: per-step times and one "practice this next" line chosen from the most frequent mistake |
| E | Floor path to the far side on step 5 | Not built | **Do** in pass 11. Strongest addition to the launch-reel walk-around shot |
| B | Voice commands ("next", "back", "repeat", "what's this") | Not built. Skills disagree: `specs-asr` says ASR works in preview, `specs-ai-remote-service` says on-device only. ASR also needs internet | **Spike first** (30 min, throwaway). Build in pass 12 only if the spike returns a transcript in preview. Buttons stay as the fallback |
| A | Ask the coach (preset question chips, Remote Service Gateway to an LLM, answer on the part) | Not built. Needs the RSG package, a token from your Snap login, and internet | **Spike** after B. Build only if B fails or there is slack. Canned offline answers required; answer must appear on the part, not a floating panel |
| F | Physics moments (thorn drops and bounces, old tube tossed in a bin) | Not built | Optional, only if everything is green by Nov 1 |
| G | Pump strokes instead of hold-to-inflate | Hold-to-inflate built in pass 9 | **Skip.** Pass 9 already covers inflate; strokes add little |
| C | Camera + AI vision of the real tire | Not possible honestly in preview | Skip; mention as the on-device next step in the README |
| H, I, J | AI props, two-person Sync Kit, saved progress | n/a | Skip (no fit, not showable, or too heavy) |
| K | Align to a real wheel | Needs glasses | Keep the "Found it" stand-in, labeled on screen |

Corrections to the proposal, so nobody builds against stale facts:
- `PinchButton` does not exist in SIK 2.0; every button is a UIKit `Button`. `ContainerFrame` is not used; panels follow via `BodyFollow.ts`.
- Steps are now 0 to 11 (pass 9). Voice *output* was already ruled out (text-to-speech is deprecated; skipped by choice). Voice *input* (B) is a separate question the spike settles.
- The four showcase-app descriptions came from an unverified summary. Verify on Snap's newsroom or Snap Engineering before citing any of them in the README or video.

## 3. Order of work

| # | Pass | Contents | LEAF added | Gate |
| --- | --- | --- | --- | --- |
| 1 | **Pass 10** (as planned) | Watch mode: Watch button on the start card, auto-plays the full repair with ghost tools, stops on any press. Plus F4 (control bar width). Final sweep of all scenarios | `watch-mode` | None. Watch mode is the video safety net, so it goes first |
| 2 | **Spikes** (no feature code) | B: smallest ASR test in preview, then removed. A: one RSG text call in preview, then removed; confirm no token lands in a tracked file. Facts-only entry in design notes | none | Results decide pass 12 |
| 3 | **Pass 11** | E floor path: pulsing arrows on the floor mat from the front of the stand to the far side when step 5 starts, fading on arrival (MeshBuilder, light cyan, no black). D report extras: per-step times on the Finish card, "practice this next" line | `floor-path` (on at step 5 entry, off on arrival or step change), `coach-report` (forced mistakes, report numbers and practice line) | None |
| 4 | **Pass 12** (conditional) | If spike B passed: voice commands via `AsrModule`, keyword match on the transcript, same handlers as the buttons, mic-on indicator, buttons unchanged. Else if spike A passed: Ask the coach chips on the current part with canned fallback | `voice-commands` (call the handler with a fake transcript; never a real mic in LEAF) or `ask-coach-fallback` (offline path returns the canned answer) | Spike result and your call |
| 5 | Optional | F physics moments | `physics-moments` with polling | Everything green by Nov 1 |
| 6 | Wrap-up | F5 hands-on walk, final sweep, perf check with `specs-lens-perf-attribution`, record terminal and LEAF footage, dry run | all | Nov 3 to 4 |

Cut order if behind: A, then F, then B. Never cut watch mode, the floor path, the report extras or the final LEAF sweep.

## 4. Calendar

| Date | Work |
| --- | --- |
| Sat Oct 25 | You: plan-lens interview (fresh session). Agent: pass 10 |
| Sun Oct 26 | Spikes B and A; you decide pass 12 |
| Mon Oct 27 to Tue Oct 28 | Pass 11 (floor path, report extras) |
| Wed Oct 29 to Thu Oct 30 | Pass 12 (voice or ask-coach), if a spike passed |
| Fri Oct 31 | Buffer; hands-on walk (F5) |
| Sat Nov 1 to Sun Nov 2 | Optional F; final LEAF sweep |
| Mon Nov 3 | Perf check, polish, footage |
| Tue Nov 4 | Dry run of the live demo; bugs only |
| Wed Nov 5 | Live review 12 PM ET; feature freeze |
| Nov 6 to 8 | README (you), video (you), private docs out, repo public, Devpost submit by Nov 8 |

## 5. Rules for every pass (unchanged)

Builder-agent passes through the Lens Studio MCP and CLAD only; one session owns the preview; every scenario passes from the default camera pose before commit; nothing black or dark; stable object names; literal `@input` defaults; never commit `.mcp.json`, `spk_debug_key.pem` or RSG tokens (run `git diff --cached | grep -iE "token|bearer|api[_-]?key"` before every commit once RSG is installed). Disclose in the README: SIK, UIKit, LEAF, Base Template, CLAD-generated code, text-to-3D assets, and RSG plus any model provider if A ships.
