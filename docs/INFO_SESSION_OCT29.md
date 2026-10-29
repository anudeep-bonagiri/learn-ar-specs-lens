# Info session, Oct 29: what the judges said and what we change

Notes from the Devpost live build session on Oct 29, 2026, hosted by the two judges, Joe Holmes and Darlyze Calixte. The research that follows was checked against the skill pack repo and Snap's docs the same day.
Devpost's own pages blocked automated access, so open https://learn-specs.devpost.com/rules in a browser and confirm the rules there. The organizers said they will post an FAQ on the hackathon page for questions they didn't answer live.

**Read this first.** There are four action items, and two of them can cost us the submission:

1. `devpost/design-brief.md` does not exist. It is required (task A1).
2. The video plan opens with 15 seconds of non-app footage. The judges want the app on screen in the first 10 seconds, and a video without the preview recording is disqualified (task A2).
3. The project is saved in Lens Studio 5.24.1. Everyone needs 5.24.1 to open it (task A3).
4. Post to Discord with the **Will It Ship** tag so the project can be reviewed live on Nov 5 (task A4).

---

## 1. What the judges said

### Judging criteria (four, no weights given)

**Design**
- "Don't put a website in front of your face." The quick-start periodic-table lens was called out as the wrong pattern, because it is a floating panel that blocks your view.
- Good design is a physical thing in the world. Examples were a Jenga tower on a table and a billiards helper on a real pool table.
- Use the three platform facts together: your hands are free, the lens draws in your world, and it sees what you see.
- Keep content in the center cone of vision, not too high and not too low. Things appear when needed and get out of the way after. A corner HUD that makes you look up strains the eyes.
- Pinch is click, and hand input is imprecise, so use big, forgiving targets.

**Technical implementation**
- How well you built on the platform, and whether you pushed past the no-effort version of Lens Studio.

**Innovation and idea**
- Joe said this is the criterion he cares about most. "AI converges on the mean," so original ideas score higher.
- Don't copy the samples, the docs examples or the stream demo (a table pet). He remembers what he built and what the samples look like.

**Presentation**
- This means video production and how well you communicate.
- **The app must be on screen in the first 10 seconds.** No long warm-up.
- **A screen recording of Lens Studio preview is mandatory.** Without it the entry is disqualified. Judges will not open or run our project.
- The video is in English. An AI voice is fine.

### Q&A rulings
- Any theme is allowed. Accessibility and hands-free practical help were encouraged. Joe's own example was a guide that names the parts under a car hood, which is close to our idea (see Section 3, Innovation).
- Mocked real-world objects in the preview are "more challenging" and more impressive. Our virtual wheel in a stand is exactly this.
- A custom backdrop in the video is fine.
- Prefabs and licensed 3D models are fine. Don't pirate. "Not a 3D modeling contest."
- Real brand names as plain text are probably fine. Email the organizers if unsure.
- The app only needs to run in Lens Studio preview. No device and no deploy.
- AI APIs, databases and Git are all allowed. "It's a full computing platform."
- After the first plan, keep iterating with CLAD directly in a fresh chat. You don't need to re-run `plan-lens`.
- In 5.23.x, Lens Studio sometimes shows a permission dialog during a CLAD run (for example, "load the LEAF plugin?"), and the agent waits until you click OK.

### Events
- **Nov 5, 12 PM ET: Live Project Review.** The judges walk through the criteria again and review some projects live. Register on the Devpost events page.
- **Discord:** join through the hackathon's link. Say hi in `#specs-general`. Post to the Devpost Learn feedback forum with the project name, the course ("Learn AR with Specs"), a description, a demo link or clip, and the feedback we want. Tag **Will It Ship** if we want it discussed live.

---

## 2. Research done after the session

### Skill pack (`challengepost/learn-specs`, last commit Oct 13)
- `plan-lens` writes exactly one file, `devpost/design-brief.md`. It starts as `status: draft`, and becomes `status: approved` when the builder says "looks good".
- Template sections:
  - spatial moment
  - why glasses
  - product or overlay, plus stand-in
  - where things live (cm)
  - hands
  - when things show
  - 3 to 5 done criteria
  - out of scope
  - risks
  - build notes for CLAD
  - after the build
- The template's own submission line says: "Make your repo public with your Lens Studio project and this `devpost/` folder."

### Snap design numbers (developers.snap.com, Spectacles best practices)
| Item | Number |
| --- | --- |
| Near field / far field | 35 to 60 cm / 60 to 160 cm |
| Best default distance | 110 cm (usable area 53 x 77 cm) |
| Focus plane | 1 m |
| Field of view | about 37 degrees tall x 32 degrees wide |
| Target size at 110 cm | 4 cm minimum, 6 cm best, 8 cm large (measured on the collider, not the mesh) |
| Target size at 55 cm | 2 / 3 / 4 cm |
| Target spacing | at least 1 degree |
| Layout | lists of 7 items or fewer, at most 3 windows, a background panel behind text |

Content belongs slightly below eye level, because the view tilts down. Black renders as transparent and dark colors fade.

### Remote Service Gateway (Ask the coach)
- Snap's page says the APIs are "only available on Spectacles". Our spike showed it working in the preview. Keep the offline fallback, and in the video say it needs internet.
- Snap's Gemini example uses `gemini-2.5-flash-lite`. Our `gemini-2.5-flash` works through RSG (Pass 12 notes), so no change is needed.
- Tokens never expire. Never commit them. `tools/check-no-tokens.sh` must print OK before every commit.

### Prior art (innovation check)
No Spectacles, HoloLens or Vision Pro lens for flat-tire or bike-tube repair turned up. The closest:
- A 2011 marker-based AR poster about mountain-bike V-brakes.
- A Packt tutorial on AR car-tire changing.
- Cannondale's PTC AR case study.
- Phone apps that aren't AR (Haynes, Bike Repair).

One search can't rule out a niche app, but the idea looks new on glasses.

### Google AR UX research (linked from the resources page)
- Put text in 3D on the object it describes. Switching between scene and screen causes "cognitive tunneling".
- Prompt the user to move or look, and use shadows as depth cues.
- On an additive display, prefer bold type and outlines over filled dark blocks.
- Every glance has to earn its place.

---

## 3. How Bench Coach scores now

| Criterion | Status | Why |
| --- | --- | --- |
| Design | Strong | Instructions sit on the part. The coach's answer appears next to the part. The wheel is 90 cm out and 25 cm below the eye, which is in Snap's range. The far-side step uses a chime, an edge arrow and a floor path. Colors are tuned for the additive display (passes 7b and D1). |
| Technical | Strong | 18 LEAF scenarios pass. A code-built wheel that changes as you act. Floor detection with World Query and the world mesh. RSG with an offline fallback. Watch mode. |
| Innovation | Good, with one risk | No prior art found, and Joe likes hands-free repair help. The risk: the samples include a cooking step coach, so "repair guide" sounds like a sample. Lead with what only we do: instructions on the wheel, a far-side step that makes you walk, a tire that changes, and inspect as a search. |
| Presentation | Not started | The plan in `BENCH_COACH_PLAN.md` Section 11 breaks the 10-second rule (see A2). |

**Design risks to check**
- Flat panels: the start card, halfway card, finish card and control bar. Keep each card short-lived so none of them reads as "a website on your face".
- Open layout bugs from the Pass 12 handoff in `TEAM_TASKS.md`. Recheck these after Pass F:
  - Step 5: the label and answer sit behind the control bar from the start pose.
  - Step 6: the question chips clip about 2 cm at the left edge.
  - Steps 2 to 4: the answer's first line sits in the faded top edge.
- Button and chip hit-box sizes against Snap's 4 to 6 cm at 110 cm (task B2).

---

## 4. Tasks

Owner "anyone" means take it in team chat first. The `Assets/Scene.scene` rule in `TEAM_TASKS.md` still applies.

### A. Must do

| # | Task | Owner | By |
| --- | --- | --- | --- |
| A1 | **Run `/plan-lens`** in a fresh Claude Code session at the repo root, with Lens Studio open. Answer in your own words and do not paste the plan. Say "looks good" so the brief is saved as `status: approved`, then commit `devpost/design-brief.md`. Its done criteria should match what the Lens really does. | Sujeeth | Oct 31 |
| A2 | **Rewrite the video plan** (`BENCH_COACH_PLAN.md` Section 11). Open on the preview: lever snap and bead peel, with the pitch spoken over it. Cut the greasy-hands clip or move it later. Keep it under 3 minutes and in English. The CLAD and LEAF process shots can stay in the second half. | Anyone | Nov 3 |
| A3 | **Install Lens Studio 5.24.1** in `/Applications`. Don't run it from the mounted DMG. The project's esproj is coreVersion 377 and 5.23.2 can't open it. | Everyone | Now |
| A4 | **Discord post** in the Devpost Learn feedback forum with a short preview clip. Ask "What would make this stronger on Design and Innovation?" and tag **Will It Ship**. Register for the Nov 5 review. | Anyone | Nov 1 |

### B. Polish before the Nov 5 freeze

| # | Task | Owner | Notes |
| --- | --- | --- | --- |
| B1 | Fix the three layout bugs in Section 3 if they're still there after Pass F. | Scene owner | Check them in the Plane room from the default pose. |
| B2 | Measure the hit boxes on the control-bar buttons, the question chips and the card buttons. Bring any under 4 cm at their distance up to 6 cm. | Scene owner | Snap measures the collider, not the mesh. |
| B3 | Audit the cards: each one shows only when needed and steps aside after. No card stays up during hands-on steps. | Anyone | Joe's main Design point. |
| B4 | F5 hands-on walk with the mouse through the whole repair, What's this? and the idle hint. Note findings in `devpost/design-notes.md`. | Anyone | LEAF skips the ray, so this is untested. |
| B5 | Tighten the Ask the coach system prompt (live answers add analogies). | Friend (AI owner) | Already an open item. |

### C. Submission (Nov 6 to 8)

| # | Task | Notes |
| --- | --- | --- |
| C1 | Record the video in the Plane room, with the cursor visible, then upload it to YouTube as **Public**. | App in the first 10 seconds. |
| C2 | README written by us, as a case study: problem, audience, why glasses, how CLAD and the MCP were used, logic proven vs. feel unproven, what changed and why. | Human-written. Disclose SIK, UIKit, LEAF, Base Template, CLAD-generated code, text-to-3D assets, RSG and Google Gemini. |
| C3 | Move `docs/` (except `HACKATHON.md` and `SUBMISSION_CHECKLIST.md`) and `AGENT_BRIEF.md` to a private place. Run `tools/check-no-tokens.sh`. Confirm `.mcp.json` and `spk_debug_key.pem` are untracked. Make the repo public. | |
| C4 | Fill in the Devpost form with the video and repo links and submit by **Sat Nov 8**. The deadline is Mon Nov 9, 5 PM ET. | |

### Questions to confirm (FAQ, Discord or email)
- Is a design brief written after most of the build acceptable, or should we say so in the README?
- Can the repo change after the deadline?
- Rules on outside AI APIs and team size. Neither was stated on stream.
