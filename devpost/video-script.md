# Bench Coach, demo video script (2:55)

Drafted Nov 4 from plan Section 11 (`docs/BENCH_COACH_PLAN.md`) and the judges' rules in
`docs/INFO_SESSION_OCT29.md`. Read it aloud at a normal pace and it runs about 2:50.
Change the words freely; keep the order and the timings.

Rules this script is built around:
- The Lens Studio preview is on screen from 0:00. No title card first.
- Under 3 minutes. English. An AI voice is fine.
- Say that Ask Coach needs internet and falls back offline.
- Say that the preview cannot see a real wheel, so a pinch stands one in.

## Narration with shots

| Time | On screen (preview unless noted) | Narration |
| --- | --- | --- |
| 0:00 to 0:10 | Cold open, mid-repair: lever B drags along the rim, the bead peels, zipper sound | "Fixing a flat is easy once someone has shown you. Bench Coach is that someone, on Specs, with every step sitting on the wheel itself." |
| 0:10 to 0:25 | Pull back: wheel in the stand, step label on the part, control bar low | "It's for anyone with a bike, a flat, and no one to ask. Your hands are busy and greasy, so a phone propped on the bench doesn't work. Glasses keep both hands free and put each instruction on the part it's about." |
| 0:25 to 0:45 | Start card, Found it, scan line sweeps the wheel, Valve and Rim labels, pinch the valve (hiss), push the beads in | "One honest note first: the Lens Studio preview can't see a real wheel, so a pinch stands one in. On the glasses it appears where you look. A scan line finds the valve and the rim. Pinch the valve to let the air out, then push the beads toward the centre to loosen them." |
| 0:45 to 1:10 | Lever A ghost on the rim, grab from the tray, drop on the ghost, snap, bead lifts. Then one mistake: lever B first, the amber warning and sound | "Every step shows a ghost of what to do. Grab lever A from the tray, drop its tip on the ghost, and it snaps in and lifts the bead. Do it wrong, say lever B first, and the coach tells you why, right on the label. Mistakes count on your report at the end." |
| 1:10 to 1:35 | **Hero moment.** Far-side chime, arrow at the edge of view, path on the floor, walk around the stand, peel the rest, pull the tube out | "Here's the part that needs glasses. The next step is on the far side of the wheel. A chime sounds, an arrow points off the edge of your view, and a path on the floor leads you round the stand. Walk round, peel the bead the rest of the way, and pull the tube out. A screen on the bench can't follow you there." |
| 1:35 to 1:50 | Inspect: the thorn hotspot. What's this? on one part. Ask the coach one question, the answer beside the part | "Before the new tube goes in, find what caused the flat: a thorn, glass, or a pinch. Pinch any part and ask what it is. Ask the coach a question and it answers next to the part. That needs internet. Offline, it falls back to built-in answers." |
| 1:50 to 2:10 | Fit the tube at the valve hole, seat the bead, hold the valve to inflate, Finish card with time, slowest steps and the practice tip | "Fit the new tube starting at the valve hole, seat the bead, and hold the valve to inflate. The Finish card shows your time, your slowest steps, and one thing to practise next time." |
| 2:10 to 2:35 | Screen recording: `devpost/design-brief.md`, Claude Code building through the Lens Studio MCP, a LEAF run with all 20 scenarios passing | "We planned it in a design brief, built it with Claude through Lens Studio's MCP, and tested it with LEAF: twenty scenarios that run the whole repair in the preview. All of them pass." |
| 2:35 to 2:50 | Two labels over the preview: "Logic: proven" and "Feel: unproven" | "What's proven: the logic, every step, every mistake, every test. What isn't: how it feels on real glasses, lining up with a real wheel, how a lever feels in the hand. That's what we'd test next." |
| 2:50 to 2:55 | Title card: Bench Coach, repo link | "Bench Coach. The repair, on the part, for Specs." |

## Recording recipe (what to capture, in order)

All takes: Plane room, Specs device, cursor visible, Lens audio on, macOS `Cmd + Shift + 5`
with "Show Mouse Clicks" ticked. Record the whole Preview panel.

1. **Watch-mode take, uncut, about 57 s.** Press Record, say "go", the agent runs
   `jump-to-step` with `step=0, watch=1`. Covers shots 0:00, 0:10, 0:25, 0:45 (the clean lever), 1:10 and 1:50.
2. **Mistake take, 10 s.** `jump-to-step step=3`, then grab lever B from the tray first. The amber warning and sound.
3. **Inspect take, 20 s.** `jump-to-step step=6`. Pinch the thorn, open What's this? on a lever, pinch an Ask chip. For the internet line, show the live answer if online, otherwise the offline fallback and say so.
4. **Finish card, 10 s.** `jump-to-step step=10`, hold the valve, let the card come up.
5. **Testing shot, 25 s.** Screen record the terminal and the LEAF panel during a real run of all 20 scenarios.
6. **Design brief, 10 s.** Scroll `devpost/design-brief.md` in the editor.

Cut order follows the table. The cold open is the lever B peel from take 1, trimmed so the lever
is already on the rim at frame one.

## Checks before upload

- App on screen within the first 10 seconds (it is on screen at 0:00).
- Total under 3:00.
- Narration says "needs internet, falls back offline" (1:35 row).
- Narration says the preview stands the wheel in with a pinch (0:25 row).
- Lens audio audible: hiss, zipper, chime.
- YouTube visibility set to Public, link pasted into the Devpost form.
