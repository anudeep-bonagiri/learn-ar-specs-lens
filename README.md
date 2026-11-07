# Bench Coach

A hands-free coach for fixing a bike flat, for Snap SPECS. Every instruction sits on the part it is about, and the coach says each step out loud.

Built for [Learn AR with SPECS](https://learn-specs.devpost.com/) on Devpost Learn. Planned in a design brief ([devpost/design-brief.md](devpost/design-brief.md)) and built by an AI coding agent using CLAD and the Lens Studio MCP.

## Demo

- Video (YouTube, under 3 minutes): _link_
- Devpost project page: _link_

## The spatial moment

You stand at the wheel with a tire lever hooked under the bead. The next step is on the far side. A chime sounds from there, an arrow points off the edge of your view, and a path on the floor leads you round the stand to where the tube comes out.

## Problem and audience

- **Problem:** fixing a flat is easy once someone has shown you. Learning it from a paused video, with greasy hands, is not. In Cycling UK's figures 47% of adults can't fix a flat ([Cycling Plus, 2022](https://www.pressreader.com/australia/cycling-plus/20221028/281724093468028)); a shop charges £15 to £30 or more for the ten minutes ([r/BikeMechanics](https://www.reddit.com/r/BikeMechanics/comments/1glx027/how_much_are_yall_charging_for_punctures/)); and U.S. PIRG puts what American households could keep by repairing electronics instead of replacing them at about $49.6 billion a year ([Repair Saves Families Big II, 2023](https://pirg.org/edfund/media-center/report-fixing-instead-of-replacing-devices-could-save-americans-nearly-50-billion-a-year/)). That last number is about electronics, not bikes; the habit is the same.
- **Who it's for:** anyone with something broken and no one to ask. They put the glasses on, do the repair once with the coach, and get on with their day. The first repair is a bike flat, start to finish.
- **Why glasses:** both hands stay on the wheel and the levers. Each instruction is on the part, seen from your own angle. The next marker makes you walk to where the work is. A phone propped on the bench cannot follow you round the stand.

## How it works

**Where things live**

- A repair stand with a 70 cm wheel stands on the floor in front of you. The Lens finds the floor first (World Query), then places the stand on it.
- The current step has one ring on its part and one callout next to it, joined by a line. Finished steps leave a small tick.
- A tool tray sits low on the right when a lever or the new tube is needed.
- A dock sits low in front: Back, Replay, Next, More. More holds What's this?, Ask and Voice.
- Cards (start, halfway, finish) appear in front of the wheel.
- On step 5 an arrow at the edge of the view and a path of arrows on the floor lead to a stand-here marker behind the wheel.

**The ten steps**

1. Unthread the valve tip, then press it to let the air out.
2. Push each glowing bead toward the middle of the rim.
3. Hook the first lever under the bead, on the ghost.
4. Hook the second lever, then slide it round to 5 o'clock.
5. Go round the stand, then pull the tube out at the bottom.
6. Find the cause: look for a glint on the tire.
7. Halfway card: tube out, cause found.
8. Start at the valve, then feed the new tube in.
9. Push the bead back over the rim with your thumbs.
10. Pinch and hold the valve to pump the tire up.

**Interactions**

- Pinch: the valve, the beads, the glint, any part in What's this?.
- Grab and drop: a lever from the tray onto its ghost. On the ghost it snaps in. Too far away it goes back to the tray.
- Drag: the second lever round the rim, the old tube end out of the tire, the new tube end to the valve hole.
- Pinch and hold: the valve, to pump.
- Walk: round the stand on step 5.
- Buttons answer a ray pinch only, so a hand passing through cannot press them.

**What the coach does**

- Speaks every step, every mistake and every hint (30 recorded lines). Voice can be turned off.
- Explains seven kinds of mistake on the callout and aloud, for example the second lever before the first.
- Gives a hint when a step sits idle.
- What's this?: pinch a part to get its name and one fact.
- Ask: three questions per step, answered next to the part. Live answers come from Gemini through Snap's Remote Service Gateway and need internet. Offline, or without tokens, built-in answers are used and tagged "Offline answer".
- Watch first: the Lens plays the whole repair by itself. At step 5 it shows the floor path and waits for you to walk round before it pulls the tube.
- The flat has one of three causes (thorn, glass, pinch), and the Finish card names it.
- The Finish card shows your time and one tip for next time. More opens the rest: the cause, lever misses, mistakes, hints, slowest steps and one thing to practise.
- Practise it now, if you want it: a button on the Finish card names one step, for example "Practise lever A". It is the step where you made the most mistakes, or your slowest step if you made none. Press it and the Lens sets up that step three times in a row. The coach says the step once. Afterwards the Finish card shows your reps, your best time and your mistakes. Most people will read the Next time tip and leave; the drill is there for the ones who want the step in their hands before the next flat.

**Stand-ins used in preview:** see the next section.

## What is real and what is simulated

- **Real:** the Lens itself. Every step, mistake, hint, spoken line and card in the video is the Lens running in Lens Studio's Interactive Preview, and the tests drive that same Lens.
- **Simulated:** the wheel and the stand are virtual. The Lens Studio preview cannot see a real wheel, so the Found it pinch places one. The design is for your own wheel: the callouts, the path and the coach would sit on the real one once it is found. The virtual wheel is the stand-in.
- **Simulated:** the garage in the video is a preview room (`preview-room/`). It is not part of the Lens.
- **Offline:** no tokens are in this repo, so Ask gives its built-in answers in the tests and in the video, tagged "Offline answer".

## How it was built

- Lens Studio 5.24.1, starting from the Specs Base Template.
- Built by Claude Code working in Lens Studio through the Lens Studio MCP, with the CLAD plugin's skills. The work went in passes. Each pass is written up in [devpost/design-notes.md](devpost/design-notes.md): what changed, what was checked, what was left over.
- Spectacles Interaction Kit for hands, grabbing and ray pinch. Spectacles UI Kit for buttons and cards.
- The wheel, tire, beads and tube are meshes built in code, so they can lift, peel and deflate.
- Tested with LEAF: one scenario per done criterion, plus a `jump-to-step` helper that puts the Lens on any step for screenshots and video takes.
- Planned with the hackathon's skill pack. The `plan-lens` questions were answered in writing on Oct 22, before the first build, and the answers are the design brief: [devpost/design-brief.md](devpost/design-brief.md), the one moment, where things live, hands, when things show, five done criteria, and a last section on what the build changed. The brief's preview limits are why the wheel is a stand-in and why every interaction is a pinch, grab, drop or drag. Its done criteria became the first five LEAF tests.

## Done criteria and test results

Last full run: Nov 6, 2026, Lens Studio 5.24.1. All 22 passed in the Garage preview room and in Sunlit Room.

| # | Done criterion | LEAF test | Status |
|---|---|---|---|
| 1 | Found it places the wheel in the stand, the scan reveal plays, and step 1's ring sits on the valve | `start` | Passed |
| 2 | Steps 1 and 2 finish by pinching the valve and the four lit beads; only the current step's ring shows | `deflate-loosen` | Passed |
| 3 | Lever A dropped 10 cm off the ghost goes back to the tray; dropped on the ghost it snaps in and lifts the bead | `lever-snap` | Passed |
| 4 | Lever B slides round to 5 o'clock and peels the bead; the far-side ring and edge arrow come on; pulling the tube end takes the tube out piece by piece | `peel-and-pull` | Passed |
| 5 | Pinching the cause reveals it and ends the first half; Back undoes every step exactly; Replay does something on every step | `inspect-done` | Passed |
| 6 | Finished steps leave one tick each, none stacked; Back removes the tick it undoes | `step-ticks` | Passed |
| 7 | The tube is hidden until a bead lifts; the valve hisses; only the parts of the current step glow; the stand stands on the measured floor | `scene-dressing` | Passed |
| 8 | Dragging the new tube end to the valve hole fits the tube; Back takes it out again | `refit-tube` | Passed |
| 9 | Seating four beads and holding the valve for 3 s inflates the tire and shows the Finish card | `seat-inflate` | Passed |
| 10 | What's this? pauses the step and names any part that is pinched | `whats-this` | Passed |
| 11 | Each of the seven mistakes plays its sound, shows its reason and leaves the step unchanged | `mistakes` | Passed |
| 12 | Thorn, glass and pinch each sit at their own place on the tire and are named on the Finish card | `flat-causes` | Passed |
| 13 | The progress rail lights finished steps; an idle step shows its hint once | `progress-idle` | Passed |
| 14 | Watch first plays the repair by itself; Next stops it and moves one step; it can resume to the Finish card | `watch-mode` | Passed |
| 15 | Ask opens three questions for the step and puts the offline answer next to the part within 2 s | `ask-coach-fallback` | Passed |
| 16 | On step 5 at least six arrows lie on the floor, clear of the stand, and end behind the wheel; arriving there hides them | `floor-path` | Passed |
| 17 | After a run with real mistakes the Finish card lists the slowest steps and the tip for the most frequent mistake | `coach-report` | Passed |
| 18 | Dock buttons do not overlap, answer only a ray pinch, and each does one thing | `control-bar` | Passed |
| 19 | The floor is the lowest wide level; a lower level found later moves the stand, mat and path down together | `floor-level` | Passed |
| 20 | No text crosses its plate, no callout covers the tire or another callout, and text is at least 0.55 degrees tall | `ui-layout` | Passed |
| 21 | The coach speaks on each step, a mistake cuts in, no line repeats within 6 s, and Voice off is silent | `voice-coach` | Passed |
| 22 | The Finish card's Practise button drills the step of the most frequent mistake three times and reports the reps and the best time | `practise-step` | Passed |

## Logic proven vs. feel unproven

- **Logic proven** (tests and preview): the step order, the lever snap, the bead peel, the tube pull and refit, inflation, every mistake, the far-side cue and floor path, what shows when, when the coach speaks, text size and overlap, floor finding in the Garage room.
- **Not used:** the camera. The preview cannot see a real wheel, so nothing is recognised. The Lens draws, speaks and listens for pinches.
- **Known gap:** in Sunlit Room, from the default pose, the floor finder can settle on the sofa seat instead of the floor.
- **Feel unproven** (needs real glasses): the Lens has not run on Specs. Lining the virtual wheel up with a real one, how a lever feels in the hand, whether a ghost tool reads against a real tire, voice volume in a real workshop, text size on the real display.

## Not built

- Running on Specs hardware. Everything here is the Lens Studio preview.
- Finding and lining up with a real wheel.
- Any repair other than a flat. The halfway card names brake pads as the next skill, and it is only a name.

## Run it

1. Install Lens Studio 5.24.1 or newer and Git LFS (`git lfs install`), then clone this repo. The voice clips and textures are LFS files.
2. Open `Specs Base Template.esproj`.
3. In the Preview panel pick the Specs device and Interactive Preview. Any built-in room works. To use the garage from the video, see [preview-room/README.md](preview-room/README.md).
4. Look down at the floor until the start card says "Floor found" (about 5 s looking straight down, up to 12 s otherwise), then click Found it, or Watch first to see the whole repair.
5. Move with WASD, Q and E for down and up, right-drag or Shift to look. A click acts as a pinch.
6. To run the tests, open the LEAF panel and run the scenarios one at a time.
7. Ask works offline as is. For live answers follow [tools/set-coach-tokens.md](tools/set-coach-tokens.md). Never commit tokens; `tools/check-no-tokens.sh` checks.

## Credits

- Spectacles Interaction Kit, Spectacles UI Kit, LEAF, Remote Service Gateway, Utilities and SnapDecorators packages by Snap, and the Specs Base Template.
- Coach voice: generated with [ElevenLabs](https://elevenlabs.io), voice "River".
- Sound effects and the finish jingle: made with code during the build (CLAD `build-sfx` and `build-music`).
- Icons: Google Material Symbols.
- Garage preview room: sources listed in [preview-room/README.md](preview-room/README.md).
- Repair procedure based on Park Tool's "Tire and Tube Removal and Installation".

## License

MIT
