# Agent brief: Learn AR with SPECS, "Walk the Talk"

> **Direction change (Oct 22, 2026):** the team picked **Bench Coach** (bike flat repair). Read `docs/BENCH_COACH_PLAN.md` for the concept, design spec, done criteria, LEAF plan and workflow. Section 3 of this file (Walk the Talk) is superseded; the ground rules, setup and submission sections still apply.

You are a coding agent (Claude Code, Codex or Cursor) running on the builder's own machine.
This brief has everything you need to take the project from setup to submission.
Read it fully before acting. Background research is in `docs/`. Read a file there only when this brief points you to it.

---

## 0. Ground rules. Read first.

1. **This is a learner-led hackathon.** The builder must lead the planning and write all submission text. Specifically:
   - When the builder runs `plan-lens`, **do not answer its interview questions for them.** Do not paste this brief into it.
     The builder can use Section 3 as their own prepared thinking, but the answers must be theirs.
   - **Never draft or rewrite** the README prose, Devpost description, project name, reflection or exit-survey answers.
     You may point out gaps, check facts against the build, and fix spelling and grammar when asked. Devpost's own skill packs follow this rule.
2. **The project must be new code** written during the submission period (Oct 15 – Nov 9, 2026). Don't copy code from elsewhere.
3. **The Lens must be built by CLAD through the Lens Studio MCP.** Don't hand-write the Lens outside that flow. Small scene nudges by the builder are fine.
4. **Everything must work in the Lens Studio preview.** No SPECS glasses are required or assumed.
5. **Commit small and often,** with clear messages. A judge reviews commit history.
   Never commit secrets, API keys, `.mcp.json`, or private notes such as `devpost/learner-profile.md` if one exists.
6. **Before the repo goes public,** move `docs/` to a private location, except `docs/HACKATHON.md` and `docs/SUBMISSION_CHECKLIST.md`. Move this `AGENT_BRIEF.md` too. See Section 9.

---

## 1. Key facts

| Item | Value |
|---|---|
| Hackathon | Learn AR with SPECS (Devpost Learn): https://learn-specs.devpost.com/ |
| Deadline | **Mon Nov 9, 2026, 5:00 PM ET.** Aim to submit by Nov 8. |
| Live build session | Thu Oct 22, 12 PM ET (Zoom, recorded) |
| Live project review | Thu Nov 5, 12 PM ET. Bring a working loop. |
| Winners | Thu Nov 19 |
| Prizes | $1,250 / $750 / $500, plus a newsletter and social feature for winners |
| Judges | Joe Holmes (AI Learning Hackathon Architect, Devpost) and Darlyze Calixte (Developer Marketing Manager, Devpost). See `docs/JUDGES.md`. |
| Help | #specs-general on the Devpost Discord. Snap troubleshooting guides are on the Resources page. |

**What to submit:**
- A public **YouTube** demo video under **3 minutes**, recorded in the Lens Studio preview.
- A **public repo** with the Lens Studio project and the `devpost/` folder.
- The Devpost form.

**Judging criteria:**
- **Design:** a complete product experience, not a tech demo.
- **Technical implementation:** including how well it uses CLAD, Lens Studio and the Lens Studio MCP.
- **Innovation / idea.**
- **Presentation:** the video shows it working end to end, and the pitch explains the problem, the audience and why it matters.

**What the concept video says judges look for:** AR that **shares your view**, **draws in the world** and **leaves your body free**.

---

## 2. Setup, done with the builder

1. **Install the prerequisites:**
   - **Lens Studio 5.22 or newer,** signed in with a Snap/SPECS account
   - **Node.js**
   - **Git**
   - a coding agent that supports skills
2. **Create the project.** In Lens Studio, choose SPECS > Base Template > File > Save As, into this repo folder.
   **The `.esproj` file must sit at the repo root**, next to this brief. If Lens Studio insists on making a subfolder, move the repo files into the project folder instead.
3. **Keep Lens Studio open.** Start the agent from the repo root so the `lens-studio` MCP tools load. The MCP server is per Lens Studio window.
4. **Install CLAD.** In Claude Code:
   ```
   /plugin marketplace add lens-studio-devs/ls-extensions
   /plugin install ls-clad@ls-extensions
   ```
   For Codex: `codex plugin marketplace add lens-studio-devs/ls-extensions`, then `/plugin` and install `ls-clad`.
   Docs: https://developers.specs.com/docs/clad
5. **Install the skill pack** from the repo root:
   ```
   npx skills add challengepost/learn-specs --all -y
   ```
6. **Verify:** the `lens-studio` MCP tools are connected, CLAD's agents and skills are visible, and `.esproj` is in the current folder.
   If any check fails, use the Resources page troubleshooting guides or ask in #specs-general.
7. **Create the GitHub repo** as private for now. It goes public in Section 9.
   ```
   gh repo create anudeep-bonagiri/learn-ar-specs-lens --private --source . --remote origin --push
   ```
8. **Commit:** "Create SPECS project from Base Template".

---

## 3. The concept, the builder's prepared thinking

**Walk the Talk:** rehearse a toast or talk by walking it around your room.
Your notes live on the furniture and fade every run, until you give the talk with none.

The rest of this section is reference for the builder going into `plan-lens`. **Don't use it to answer the interview.**

- **Problem:** people rehearse by pacing while holding notes, which trains them to read instead of talk.
- **Audience:**
  - anyone with a speech coming up, such as a toast, a class presentation, an interview pitch or a demo
  - especially first-time presenters, second-language speakers and anyone with speaking anxiety
- **The one spatial moment:** run 3. You walk the route with nothing showing and stall at the shelf.
  Only then does that beat's icon glow faintly, just below your gaze. You recover, and a chime from the next beat's direction pulls you on.
  The end card reads "0 peeks · 2:41 · no notes."
- **Strengths:**
  - **Draws in the world:** beats sit on furniture, and cues appear where your eyes already go.
  - **Leaves your body free:** hands empty and eyes up.
  - Shares your view is a roadmap item only.
- **Why not a phone:** holding notes is the exact habit rehearsal should break. A phone pulls your eyes down and away from your audience.
- **Product or overlay:** a product, a trainer, with beats placed on real places, not recognized objects.
- **Out of scope:**
  - saving talks between sessions
  - real speech recognition
  - audience avatars
  - multi-user feedback
  - recording or identifying people
- **Risk to note:** walking and pinching orbs can look like a tech demo. A real spoken voiceover in the video is what fixes it.

Go deeper with `docs/COUNCIL_DEBATE.md` for the full spec and why this idea won, and `docs/JUDGES.md` for judge-specific tuning.

---

## 4. Plan with `plan-lens`, led by the builder

1. The builder tells the agent to run **`plan-lens`**. It takes 20 to 30 minutes.
2. The skill interviews the builder and writes `devpost/design-brief.md` with `status: draft`.
3. The builder reviews it and says "looks good" to set `status: approved`.
4. **Check against this brief, then flag differences to the builder. Don't rewrite.** The approved brief should contain:
   - 5 done criteria similar to Section 5, each checkable in preview
   - the stand-ins from Section 5
   - placement 0.6 to 1.6 m away, slightly below eye level
   - light text with no reliance on black
5. **Commit:** "Approve design brief".

---

## 5. Build specification

The approved brief is the source of truth. This section is what a good brief for this concept contains.

### Loop
1. **Load a talk.**
   - Ship two hard-coded sample talks of 5 beats each: a best-man toast and a 1-minute class presentation.
   - **Optional AI step:** split pasted notes into 5 beats using Snap's supported AI integration. Use the hard-coded talk as the automatic fallback, and label it on screen.
   - AI only splits the user's own text into beats. It never invents content.
2. **Place.** Pinch 5 anchor spots on the preview room's furniture and surfaces. Store each world position.
3. **Run 1** shows the full sentence when a beat is cued. **Run 2** shows one keyword. **Run 3** shows an icon only.
4. **Cueing.** A beat's cue shows only when the user is within 2 m and facing it within a 15° cone. Every other beat stays a dim orb.
5. **Peek.** Pinch an active orb to see the full text. Each peek is counted per beat.
6. **Pace.** A ring around the active orb fills against the beat's target time and turns amber when over.
   A **spatial chime** plays from the next beat's position. A "next beat" pinch button advances.
7. **End card.** Shows peeks and time per beat for runs 1 to 3, and the change from run 1 to run 3. Buttons: **Run again** and **New talk**.

### Where things live
| Element | Spec |
|---|---|
| Beat orb | About 6 cm sphere at the anchor, 0.6 to 1.6 m from the user. Dim when idle, glowing when cued. |
| Cue panel | Just below the gaze line, above its orb. Light text on a pale panel. Never rely on black. |
| Pace ring | About 8 cm ring around the active orb |
| Next-beat button | Large target, at least 6 cm, near the active orb |
| End card | 40 × 25 cm, 1 m away, slightly below eye level |
| Mode and talk panel | Small, opened by a button, never fixed to the face |

### Done criteria

Write one LEAF test per criterion, run them in preview, and report which pass.

1. Five beats load, from AI or the fallback. Pinch-placing stores 5 world positions, each 0.6 to 1.6 m from the user.
2. A beat's cue shows only when the user is within 2 m and facing it within 15°. All other beats stay dim.
3. Cue content fades by run: a sentence, then a keyword, then an icon. A peek pinch shows the full text and adds 1 to that beat's peek count.
4. The pace ring fills against the target time and turns amber when over. A spatial chime plays from the next beat's position.
5. The end card shows peeks and time per beat for runs 1 to 3. "New talk" loads the second talk.

### Stand-ins, labeled on screen
- A "next beat" pinch stands in for voice and pace detection.
- The hard-coded talk stands in for AI chunking whenever AI fails.
- The preview room's furniture stands in for the user's living room.

### Build notes for CLAD
- Target SPECS. The Lens must run and be demonstrable in Lens Studio Interactive Preview.
- Use the **Spectacles Interaction Kit (SIK)** and **UI Kit** for all interaction, so it works with the mouse and with LEAF.
- Use real-world scale in cm. Keep content inside the view during the task: about 37° × 32°, with the focus plane at about 1 m.
- The display is additive, so black renders transparent. Use light, readable text.
- **Get the basic flow working first:** load, place, then run 1 and the end card. Then add the fade, cueing, pace ring, chime and AI.
- Don't record, identify or follow people.

---

## 6. Build with CLAD

1. **Clear the chat,** or start a new one in the same folder, with Lens Studio still open.
2. The builder gives this build prompt:
   ```
   Read devpost/design-brief.md and build this Lens for SPECS. Get the basic flow
   working first, then add detail. Write and run LEAF tests for each done criterion
   and tell me which pass, and which criteria have no test.
   ```
3. The build can take 30 minutes or more.
4. **Commit at each working milestone:**
   - "Basic flow: load, place, run 1, end card"
   - "Fade across runs"
   - "Gaze and distance cueing"
   - "Pace ring and spatial chime"
   - "LEAF tests for criteria 1-5"
5. **Keep a test log.** Save the LEAF results summary to `devpost/test-results.md` after each run.

---

## 7. Judge it and iterate

Follow the "After the build" section at the bottom of the brief.

1. **Check the tests.** Ask which LEAF tests pass and which criteria have no test.
2. **Walk around it** in Interactive Preview:
   - WASD moves.
   - Q and E move down and up.
   - Right-drag or Shift looks around.
   - A click acts as a pinch.
3. **Ask the questions:**
   - Does it use what I'm looking at?
   - Does it place things where they belong?
   - Does it free my hands and keep my eyes up?
   - Would a phone do just as well?
4. **Check comfort:**
   - everything needed is in view
   - controls are within reach
   - text reads easily
   - no dark UI disappears
   - cues show only when needed
5. **Label what you know.** Mark "logic proven" for what the tests and preview confirm. Mark "feel unproven" for what only glasses can judge.
6. **Fix with design notes, not code.** For example: "Move the cue panel 10 cm lower and closer to its orb." Then re-run the tests.
7. **Log every iteration** in `devpost/design-notes.md`: the date, what the preview showed, the change, and why. **Aim for at least 2 iterations.** Judges look for this.
8. **Commit** each iteration.

---

## 8. Video and submission assets

**The builder records the video and speaks the talk for real during the runs.** That voiceover is the proof of the core action.

| Time | Shot |
|---|---|
| 0:00–0:15 | Hook: a real, dreaded speaking moment, and who it's for. One inclusive audience line. |
| 0:15–0:40 | Place 5 beats on the furniture, with the camera walking around them to show world anchoring. |
| 0:40–1:05 | Run 1 with full text, spoken aloud |
| 1:05–1:25 | Process: the approved brief, CLAD building through the Lens Studio MCP, LEAF tests going green, one design-notes iteration |
| 1:25–1:45 | Run 2 with keywords and one peek |
| 1:45–2:30 | Run 3 with icons only: the stall, the glow, the chime, then "0 peeks" |
| 2:30–3:00 | End card with runs 1 to 3, the logic-proven and feel-unproven labels, and why glasses |

**Assets to export:**
- the full video, uploaded to YouTube as **Public**
- a 10-second clip of run 3
- one still of the end card

**README, written by the builder.** The agent may suggest structure only. Sections:
- problem
- audience
- the spatial moment
- how it works
- a table of done criteria with LEAF status
- logic-proven vs. feel-unproven
- what changed in iteration and why
- stand-ins
- how to run it
- next steps

**Reflection, written by the builder:** one real build moment, and the practice they'd reuse.

---

## 9. Pre-publish checklist and submit

1. **Move the private files out of the repo:** `AGENT_BRIEF.md`, plus everything in `docs/` except `HACKATHON.md` and `SUBMISSION_CHECKLIST.md`.
   Put them in a private repo or a folder outside this repo. Remove them from tracking:
   ```
   mkdir -p ../walk-the-talk-private
   cp -r AGENT_BRIEF.md docs/WINNING_RESEARCH.md docs/IDEAS.md docs/COUNCIL_DEBATE.md docs/JUDGES.md docs/council ../walk-the-talk-private/
   git rm -r AGENT_BRIEF.md docs/WINNING_RESEARCH.md docs/IDEAS.md docs/COUNCIL_DEBATE.md docs/JUDGES.md docs/council
   git commit -m "Move private research out of the public repo"
   ```
   Also remove the README lines that link to the moved files. Old commits still contain these files.
   If that matters, publish from a fresh history: create a new repo from the current files, or squash the early research commits **before** making it public.
   Ask the builder which they prefer.
2. **Scan for secrets and private context:**
   ```
   git log -p | grep -iE "api[_-]?key|secret|token|password" | head
   ```
   Confirm `.mcp.json` is not tracked.
3. **Confirm the repo contains:**
   - the Lens Studio project with `.esproj` at the root
   - `devpost/design-brief.md` (approved)
   - `devpost/design-notes.md`
   - `devpost/test-results.md`
   - the builder's README
   - `LICENSE`
4. **Make the repo public:**
   ```
   gh repo edit anudeep-bonagiri/learn-ar-specs-lens --visibility public --accept-visibility-change-consequences
   ```
5. **Submit on Devpost** with the YouTube link, the repo link, and the builder's own write-up.

---

## 10. Timeline

| When | Milestone |
|---|---|
| Oct 18–21 | Setup, `plan-lens`, approved brief |
| Thu Oct 22 | Live build session. Ask in #specs-general how judges weigh consumer use against craft. |
| Oct 23–28 | CLAD build. Basic flow first, then the fade, cueing, pace and chime. LEAF tests. |
| Oct 29–Nov 1 | Judge in preview. Run at least 2 design-note iterations. **Decide by Nov 1** whether to switch to the backup. |
| Around Nov 4 | Study the Build With AI: Basics winners. They had the same judges. |
| Thu Nov 5 | Live project review. Ask: "What would make this stronger on Design?" |
| Nov 6–8 | Polish, record the video, write the README, run the pre-publish checklist, submit |
| Mon Nov 9, 5 PM ET | Hard deadline |

## Backup concept: Call the Shot

Use this only if feedback says craft and provability outweigh story. Full spec is in `docs/COUNCIL_DEBATE.md`.

- **The idea:** walk to where you think a ramp-launched ball will land, then walk around its frozen life-size arc to see why you were wrong.
- **Flagship LEAF test:** a deterministic launch lands within 2 cm of the projectile formula.
