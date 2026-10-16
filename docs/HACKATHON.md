# Learn AR with SPECS: hackathon reference

Source: https://learn-specs.devpost.com/ (Devpost Learn). Compiled 2026-10-16.
Check the Devpost page for the official rules. It may have changed since this was written.

## What it is

You design an AR Lens for Snap SPECS glasses. A coding agent builds it in Lens Studio.
You don't need the glasses. Everything runs in Lens Studio's preview on your laptop.

1. The Devpost skill pack (`plan-lens`) interviews you, checks your idea against AR design rules, and writes a design brief.
2. Snap's CLAD agents build the Lens in Lens Studio from that brief, using the Lens Studio MCP.
3. You try it in the preview, iterate with design notes, and submit.

## Key dates (ET)

| Event | When |
|---|---|
| Submissions open | Oct 15, 2026 |
| Live Build Session (recorded) | Thu Oct 22, 2026, 12:00 PM ET |
| Live Project Review (projects judged in progress) | Thu Nov 5, 2026, 12:00 PM ET |
| **Submission deadline** | **Mon Nov 9, 2026, 5:00 PM EST** |
| Winners announced | Thu Nov 19, 2026 |

## Prizes ($2,500 cash)

| Place | Prize |
|---|---|
| 1st | $1,250 |
| 2nd | $750 |
| 3rd | $500 |

All winners get a feature in the Devpost newsletter and socials.
Every eligible submission earns a Devpost Learn badge and a Discord role.

## Eligibility

- Above the legal age of majority in your country of residence.
- All countries and territories, with standard exceptions.

## Project rules

- **New project.** Start it during the submission period. Old ideas are fine, old code is not.
- **Planning docs.** The repo must include the planning docs the skill pack writes to `devpost/`.
- **Built with CLAD.** The coding agent builds the Lens in Lens Studio through the CLAD plugin and the Lens Studio MCP.
- **Runs in preview.** The Lens must run in the Lens Studio preview. SPECS hardware is not required.

## What to submit

- A demo video, public on YouTube, **under 3 minutes**, showing the Lens working. A screen recording of the Lens Studio preview is recommended.
- A **public** code repo on GitHub, GitLab, or Bitbucket, with the Lens Studio project and the `devpost/` folder.
- The Devpost project page write-up.

## Judging criteria

- **Design.** Is it a complete, coherent product experience rather than a technical proof of concept?
- **Technical implementation.** How well is it built, and how well does it use CLAD, Lens Studio, and the Lens Studio MCP?
- **Innovation / idea.** How creative and novel is the concept?
- **Presentation.** Does the video show it working end to end? Does the pitch explain the problem, the audience, and why it matters?

The concept video covers the design ideas judges look for: AR that shares your view, draws in the world around you, and leaves your body free. See [IDEAS.md](IDEAS.md) for how to apply them.

**Help:** ask in #specs-general on the Devpost Discord. Snap troubleshooting guides are on the Resources page.

## Requirements to set up

- A computer that runs Lens Studio (5.22 or newer, per the organizers).
- A Snap/SPECS account signed in to Lens Studio.
- Node.js and Git.
- A coding agent that supports skills, such as Claude Code, Codex, or Cursor.
- For Claude Code with the Lens Studio MCP: the Chat Tool package from the Lens Studio Asset Library.

## Setup steps

1. **Create the project.** In Lens Studio, choose SPECS > Base Template, then File > Save As into this repo folder. The `.esproj` file must sit at the repo root.
2. **Open your agent in that folder** with Lens Studio open, so the `lens-studio` MCP tools load. The MCP server is per Lens Studio window.
3. **Install CLAD** (Claude Code):
   ```
   /plugin marketplace add lens-studio-devs/ls-extensions
   /plugin install ls-clad@ls-extensions
   ```
   Guide: https://developers.specs.com/docs/clad
4. **Install the skill pack** from the project folder:
   ```
   npx skills add challengepost/learn-specs --all -y
   ```
5. **Plan.** Tell the agent `plan-lens`. It takes about 20 to 30 minutes and writes `devpost/design-brief.md`. Say "looks good" to approve it.
6. **Build.** Clear the chat and ask CLAD to build from the brief:
   ```
   Read devpost/design-brief.md and build this Lens for SPECS. Get the basic flow
   working first, then add detail. Write and run LEAF tests for each done criterion
   and tell me which pass.
   ```
   The build can take 30 minutes or more.

## What plan-lens asks about

The interview runs six to eight exchanges and fills the brief template.

- **The one spatial moment** the Lens is built around.
- **Why it belongs on glasses**: it shares your view, draws on the world, or leaves hands free.
- **Product or overlay**: is the virtual thing the experience, or does it respond to something real?
- **Where things live**: anchor, distance, height, and size in centimeters.
- **Hands and input**: pinch, grab, drag, throw, buttons, sliders. Avoid custom gestures.
- **When things show**: each element appears when needed and recedes after.
- **Done criteria**: three to five outcomes you can check in preview.
- **Out of scope**, and **risks and open questions**.

## AR design rules to keep in mind

- Place content on or near its subject, from arm's length to a couple of meters away, slightly below eye level.
- Keep content inside the narrow field of view. Never place it behind the user or stuck to their face.
- Use a few large targets and standard interactions.
- The display is additive, so black renders as transparent. Use light, readable text and avoid dark UI.
- Cue important off-screen items with a sound or a small arrow.
- Don't record, identify, or follow people.

## What the preview can and can't show

| Works in preview | Needs a stand-in | Can't be shown |
|---|---|---|
| Walking around, room-scale objects | Recognizing real objects | Custom or two-hand gestures |
| Mouse-driven panels and interactions | Real places and routes | Hand speed or pose |
| Spatial sound, simple physics, animation | AI and voice | Live camera vision |
| 3D models and text | | Memory across sessions, multi-person use |

## After the build: judge it

1. Ask the agent which LEAF tests passed and which done criteria have no test.
2. Walk around it in Interactive Preview. WASD moves, Q and E go down and up, right-drag or Shift looks around, and a click acts as a pinch.
3. Ask whether it uses what you're looking at, places things where they belong, and frees your hands. Ask whether a phone would do just as well.
4. Check comfort: everything in view, controls within reach, readable text, no dark UI vanishing.
5. Mark what tests prove as "logic proven" and what only real glasses can judge as "feel unproven".
6. Fix with design notes, not code. For example: "Move the step card 15 cm lower and next to the pan." Then re-run the tests.

## Links

- Hackathon: https://learn-specs.devpost.com/
- Resources and Quick Start: https://learn-specs.devpost.com/resources
- Skill pack: https://github.com/challengepost/learn-specs
- CLAD plugin: https://github.com/lens-studio-devs/ls-extensions
- CLAD docs: https://developers.specs.com/docs/clad
- Claude Code setup for CLAD: https://developers.specs.com/docs/clad/setup/setup-ai/claude-code-setup
- Spectacles samples: https://github.com/specs-devs/samples
