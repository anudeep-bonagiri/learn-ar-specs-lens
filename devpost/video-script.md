# Bench Coach, demo video script (2:55)

Drafted Nov 4 from plan Section 11 (`docs/BENCH_COACH_PLAN.md`) and the judges' rules in
`docs/INFO_SESSION_OCT29.md`. Read it aloud at a normal pace and it runs about 2:50.
Change the words freely; keep the order and the timings.

Rules this script is built around:
- The Lens Studio preview is on screen inside the first 10 seconds (the judges' rule). In the final cut a nine-second clip states the problem first and the Lens is on screen at 0:09.
- Under 3 minutes. English. An AI voice is fine.
- Say that Ask Coach needs internet and falls back offline.
- Say that the preview cannot see a real wheel, so a pinch stands one in.

## Narration with shots

| Time | On screen (preview unless noted) | Narration |
| --- | --- | --- |
| 0:00 to 0:09 | The problem (not the Lens): a generated clip of a man in a garage with a flat, a repair video on a phone propped against a box, greasy thumb on the scrub bar, then crouched by the wheel. Labelled "AI-generated illustration" on screen, with the source of the figure it speaks | The clip's own voice: "When something breaks, the phone is a bad stand-in. Nearly half of adults can't fix a flat tire. YouTube videos are shot from someone else's angle. Hands and eyes are in the wrong place. So people just give up." |
| 0:09 to 0:17 | Cut to the Lens, mid-repair: lever B on the rim, the coach speaking the step | "Presenting Bench Coach. Put on your glasses, and now you have everything you need." |
| 0:17 to 0:34 | Pull back: wheel in the stand, step callout on the part, dock low | "It's for anyone with something broken and no one to ask. Glasses keep both hands on the wheel and put each instruction on the part it's about, seen from your own angle." |
| 0:25 to 0:45 | Start card, Found it, scan reveal runs up the wheel, Rim, Valve and Hub labels, pinch the valve (hiss), push the beads in | "One honest note first: the Lens Studio preview can't see a real wheel, so a pinch stands one in. On the glasses it appears where you look. A scan line finds the valve and the rim, and the coach says each step out loud. Pinch the valve to let the air out, then push the beads toward the centre to loosen them." |
| 0:45 to 1:10 | Lever A ghost on the rim, grab from the tray, drop on the ghost, snap, bead lifts. Then one mistake: lever B first, the amber warning and sound | "Every step shows a ghost of what to do. Grab lever A from the tray, drop its tip on the ghost, and it snaps in and lifts the bead. Do it wrong, say lever B first, and the coach tells you why, right on the label. Mistakes count on your report at the end." |
| 1:10 to 1:35 | **Hero moment.** Far-side chime, arrow at the edge of view, path on the floor, walk around the stand, peel the rest, pull the tube out | "Here's the part that needs glasses. The next step is on the far side of the wheel. A chime sounds, an arrow points off the edge of your view, and a path on the floor leads you round the stand. Walk round, peel the bead the rest of the way, and pull the tube out. A screen on the bench can't follow you there." |
| 1:35 to 1:50 | Inspect: the thorn hotspot. What's this? on one part. Ask the coach one question, the answer beside the part | "Before the new tube goes in, find what caused the flat: a thorn, glass, or a pinch. Pinch any part and ask what it is. Ask the coach a question and it answers next to the part. That needs internet. Offline, it falls back to built-in answers." |
| 1:50 to 2:10 | Fit the tube at the valve hole, seat the bead, hold the valve to inflate, Finish card with time, slowest steps and the practice tip | "Fit the new tube starting at the valve hole, seat the bead, and hold the valve to inflate. The Finish card shows your time, your slowest steps, and one thing to practise next time." |
| 2:10 to 2:35 | Screen recording: `devpost/design-brief.md`, Claude Code building through the Lens Studio MCP, a LEAF run with all 22 scenarios passing | "We planned it in a design brief, built it with Claude through Lens Studio's MCP, and tested it with LEAF: twenty-two scenarios that run the whole repair in the preview. All of them pass." |
| 2:35 to 2:50 | Two labels over the preview: "Logic: proven" and "Feel: unproven" | "What's proven: the logic, every step, every mistake, every test. What isn't: how it feels on real glasses, lining up with a real wheel, how a lever feels in the hand. That's what we'd test next." |
| 2:50 to 2:55 | Title card: Bench Coach, repo link | "Bench Coach. The repair, on the part, for Specs." |

## How it was recorded and cut (Nov 5, pickups Nov 6, the one-take act Nov 7)

The recipe that stood here (Plane room, macOS screen recording, cursor visible) was not used. What happened instead:

- **Room:** the Garage preview room (`preview-room/Garage`), from the start eye.
- **Recording:** the Mac's screen was locked, and macOS refuses screen and window capture while locked. The footage was captured with the Preview panel's own screenshot call in a loop inside Lens Studio, through the MCP: the preview render only, 1392 x 1731, 25 to 28 frames a second, no cursor. See the design notes, "Pass R".
- **Sound:** the frames are silent. Every take's sound was rebuilt from the Lens log (`[Voice]` and `[Audio]` lines with wall-clock times) and the Lens's own audio files.
- **Takes:** 25 on Nov 5, about 13 minutes; 6 pickup takes on Nov 6 after pass P changed what five shots show (the `-p` takes below); and on Nov 7, after passes S1 and S2, one unbroken take of Watch first from the start card to the far side (`t13-unbroken-c`, four attempts, the one with no recorder gap inside a camera move), the compact Finish card (`t14-finish`) and the drill driven by the `practise-step` scenario (`t15-practise-b`). Watch first drives steps 1 to 5 and 7 to 10. Real preview mouse input drives Found it, the glint, Continue and the mistake (the second lever grabbed first). Ask shows the offline answer.
- **Narration:** the table above, read by an ElevenLabs voice. Two rows were split so the coach's own voice can be heard in between. The 2:10 row's clip names the design brief (`devpost/design-brief.md`); a clip without that clause was used in the cuts before the brief existed.
- **Cut:** 2:46 long, 1920 x 1080. The first nine seconds are Anudeep's generated clip of the problem, full frame, with its own voice, run at 1.15 times speed so the Lens is on screen at 0:09. From there the preview is on the right, a title and a note on the left, captions under them. The first Lens shot is the second lever on the rim with the coach speaking, under the title "Presenting Bench Coach". The middle act, from the start card to the tube coming out on the far side, is one take with no cuts: the same footage runs under six titles. The judges asked for an unbroken minute at the Nov 5 live review.

| At | On screen | Footage |
| --- | --- | --- |
| 0:00 | The problem | `t00-intro` 0 to 10.0267 s, 1.15x speed, full frame |
| 0:09 | Bench Coach | `t04-step4-p` 14.25 to 22.15 s |
| 0:17 | Hook, slide, peel | `t04-wide-right` 22.9 to 27.5 s |
| 0:21 | Something broken, and no one to ask | `t11-wide-right` 3.9 to 10.4 s |
| 0:28 | Something broken, and no one to ask | `t11-wide-left` 4.3 to 10.4 s |
| 0:34 | Watch first, from the start card to the far side | `t13-unbroken-c` 32.6 to 43.9 s, 0.8x speed |
| 0:48 | It names what it sees | `t13-unbroken-c` 43.9 to 48.33 s |
| 0:52 | Let the air out, loosen the bead | `t13-unbroken-c` 48.33 to 54.3 s |
| 0:58 | A ghost shows where the lever goes | `t13-unbroken-c` 54.3 to 58.62 s |
| 1:03 | Hook, slide, peel | `t13-unbroken-c` 58.62 to 66.81 s |
| 1:11 | The next step is behind the wheel | `t13-unbroken-c` 66.81 to 78.6 s |
| 1:23 | Second lever before the first | `t07-mistake` 13.5 to 16 s |
| 1:25 | Do it wrong and the coach says why | `t07-mistake` 38 to 45 s |
| 1:32 | Find what caused the flat | `t06-inspect` 18.3 to 23.8 s |
| 1:38 | Pinch a part to learn its name | `t06-whats-b-p` 10.57 to 14.07 s |
| 1:41 | A question, answered next to the part | `t06-ask` 5.8 to 13 s |
| 1:48 | New tube in, bead on, pump | `t09-refit-p` 14.74 to 31.02 s, 2.6x speed |
| 1:55 | A report, and one thing to practise | `t14-finish` 23.8 to 31.8 s |
| 2:03 | Practise the step you got wrong | `t15-practise-b` 26.4 to 27.5 s |
| 2:04 | Practise the step you got wrong | `t15-practise-b` 28.9 to 31.6 s |
| 2:06 | Practise the step you got wrong | `t15-practise-b` 41.9 to 45.45 s, last frame held 1.5 s |
| 2:11 | Built in Lens Studio | still of the Lens Studio window |
| 2:17 | 22 of 22 scenarios pass | `t12-tests` 10.4 to 13.15 s |
| 2:19 | 22 of 22 scenarios pass | `t12-tests` 14.5 to 19.4 s |
| 2:24 | Logic: proven | `t04-wide-left` 4 to 10.5 s |
| 2:31 | Feel: unproven | `t04-wide-left` 10.5 to 20.9 s |
| 2:41 | Bench Coach | title card |

Differences from the plan above:

- The testing shot shows the `lever-snap` scenario driving the Lens next to the list of the 22 scenarios. The LEAF panel itself could not be captured.
- The Finish card is from the `coach-report` test run (two wrong lever drops, one early pinch), so it shows real numbers. The video says so on screen.
- The refit (steps 8 to 10) plays at 2.6 times speed, and the video says so on screen.
- The one-take act ends 0.2 s after step 6 starts: from the far side the step 6 callout sits partly behind the stand's clamp.
- The drill is cut from a run the `practise-step` scenario drives, so its reps are quick; the simulated hand carries the lever past the camera between reps, and those spans are cut out.
- What's this? shows the Tire card. The Valve card's leader runs behind the step callout from this pose.
- There is no shot of the design brief itself; the narration names it over the Lens Studio window and the test list.
- The video opens on the problem, not the Lens: a nine-second AI-generated clip Anudeep made on Nov 7 (`t00-intro`, 640 x 360, scaled to the frame). Its own narration states the problem, including "nearly half of adults can't fix a flat tire", and the source of that figure (Cycling UK, 47%) is on screen with the label "AI-generated illustration. The Lens starts next." Because the clip says the stat and the phone problem once, the Lens's first line is only the reveal ("Presenting Bench Coach. Put on your glasses, and now you have everything you need.") and the who-it's-for line no longer mentions the phone; it answers the clip's "someone else's angle" with "seen from your own angle". The clip runs at 1.15 times speed, voice tempo-shifted with the pitch kept, so the Lens is on screen at 0:09 and inside the judges' 10-second rule.
- The drill is titled "If you want it" and its line says so; the person with a flat wants the tube out, and the Finish card's default is three lines and one tip.
- Several lines were recorded again shorter or reworded (the honest note, the scan, the far side, the drill, the build line); the captions file carries the words as spoken. On Nov 7 the Nov 5 narration clips were generated again by mistake, so every line is a Nov 7 take; the offsets were checked against the new lengths and nothing overlaps.

## Checks before upload

- App on screen within the first 10 seconds (it is on screen at 0:09, after the problem clip).
- Total under 3:00.
- Narration says "needs internet, falls back offline" (1:35 row).
- Narration says the preview stands the wheel in with a pinch (0:25 row).
- Lens audio audible: hiss, zipper, chime, and the coach's voice at the first Lens shot, after Found it, on the mistake and on the Finish card.
- Someone has listened to the whole cut. So far the mix was checked by level only.
- YouTube visibility set to Public, link pasted into the Devpost form.
