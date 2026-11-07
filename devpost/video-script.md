# Bench Coach, demo video script (2:55 as cut)

Drafted Nov 4 from the team's video plan and the judges' public guidance (the Oct 29 info session). The table below is the seventh cut (Nov 7 night) as spoken; the draft's rows were replaced once the cut settled.

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
| 0:17 to 0:26 | Wide: the wheel in the stand, the callout on the part, the dock low | "It's for a home cyclist with a flat and no one to ask, doing it for the first time. Glasses keep both hands on the wheel and put each instruction on the part it's about, from your own angle." |
| 0:26 to 0:33 | **The one take starts here.** Looking down at the garage floor; the coach says the floor is found; the camera tilts up to the start card, "Floor found" in green | "First, the floor. The Lens asks World Query where it is, and stands the wheel on it. On glasses, that's your floor." |
| 0:32 to 1:18 | **One take, no cuts, 52 s with the floor.** Start card and Found it, the scan up the tire, step 1, the beads, lever A on its ghost, lever B round to 5 o'clock, then the far side: chime, edge arrow, floor path, the walk, the tube out. The coach's own voice carries it | Only twice. Over the start card: "One honest note first: the Lens Studio preview can't see a real wheel, so a pinch stands one in. The design is for your own wheel. The virtual one is the stand-in." At the far side, after the coach's line: "A chime, an arrow at the edge of your view, a path on the floor. A screen on the bench can't follow you there." |
| 1:18 to 1:28 | The second lever grabbed first; the amber Not quite | "Do it wrong, say lever B first, and the coach tells you why, right on the label." "Mistakes count on your report at the end." |
| 1:28 to 1:41 | Inspect: the thorn. Ask: the offline answer next to the part | "Before the new tube goes in, find what caused the flat: a thorn, glass, or a pinch. Pinch any part and ask what it is." "Ask the coach a question and it answers next to the part. That needs internet. Offline, it falls back to built-in answers." |
| 1:41 to 1:46 | Refit at 3x: tube in, bead on, pump | "Fit the new tube starting at the valve hole, seat the bead, and hold the valve to inflate." |
| 1:46 to 1:58 | Our first Finish card (recorded Nov 5, a wall of text), then the compact one | "Our first Finish card was a wall of text: a website on your face. Now it's your time, one tip, and the rest behind More." |
| 1:58 to 2:07 | The drill: three reps of lever A | "And if you want it, practise the step you got wrong: three reps on the wheel, and the card keeps your best time." |
| 2:07 to 2:19 | **The coach adapts.** Run 1: lever A dropped 10 cm off the ghost, the amber "Too far". Run 2: the start card with the Run 2 line. Run 2, step 3: the ghost looping on the rim and the hint at 6 s | "The coach keeps a score for every step. Do a step clean twice and it goes quiet there. Slip twice, and next run it helps sooner: the ghost keeps looping, and the hint comes at six seconds." |
| 2:19 to 2:34 | A card from `devpost/design-brief.md` (the one spatial moment), the Lens Studio window, the 23 LEAF scenarios | "We planned it in a design brief, built it with Claude through Lens Studio's MCP, and tested it with LEAF: twenty-three scenarios that run the whole repair in the preview. All of them pass." |
| 2:34 to 2:50 | "Logic: proven" and "Feel: unproven" over the wide shot | "What's proven: the logic, every step, every mistake, every test. What isn't: how it feels on real glasses, lining up with a real wheel, how a lever feels in the hand. That's what we'd test next." |
| 2:50 to 2:55 | Title card: Bench Coach, repo link | "Bench Coach. The repair, on the part, for Specs." |

## How it was recorded and cut (Nov 5, pickups Nov 6, the one-take act and the coach-adapts takes Nov 7)

The recipe that stood here (Plane room, macOS screen recording, cursor visible) was not used. What happened instead:

- **Room:** the Garage preview room (`preview-room/Garage`), from the start eye.
- **Recording:** the Mac's screen was locked, and macOS refuses screen and window capture while locked. The footage was captured with the Preview panel's own screenshot call in a loop inside Lens Studio, through the MCP: the preview render only, 1392 x 1731, 25 to 28 frames a second, no cursor. See the design notes, "Pass R".
- **Sound:** the frames are silent. Every take's sound was rebuilt from the Lens log (`[Voice]` and `[Audio]` lines with wall-clock times) and the Lens's own audio files.
- **Takes:** 25 on Nov 5, about 13 minutes; 6 pickup takes on Nov 6 after pass P changed what five shots show (the `-p` takes below); and on Nov 7, after passes S1 and S2, one unbroken take of Watch first from the start card to the far side (`t13-unbroken-c`, four attempts, the one with no recorder gap inside a camera move), the compact Finish card (`t14-finish`) and the drill driven by the `practise-step` scenario (`t15-practise-b`); and on Nov 7 night, after pass A, four takes driven by the `adaptive-coach` scenario's `stay` parameter (`t16-memory` to `t19-quiet`), of which three are in the cut. Watch first drives steps 1 to 5 and 7 to 10. Real preview mouse input drives Found it, the glint, Continue and the mistake (the second lever grabbed first). Ask shows the offline answer.
- **Narration:** the table above, read by an ElevenLabs voice. Two rows were split so the coach's own voice can be heard in between. The 2:10 row's clip names the design brief (`devpost/design-brief.md`); a clip without that clause was used in the cuts before the brief existed.
- **Cut:** 2:55 long, 1920 x 1080 (the seventh cut, Nov 7 night, second render: the sixth cut plus the floor-found moment at the head of the one take, the coach-adapts beat after the drill, and trims to stay under three minutes). The first nine seconds are Anudeep's generated clip of the problem, full frame, with its own voice, run at 1.15 times speed so the Lens is on screen at 0:09. From there the preview render sits at full height in the centre of the frame on a blurred copy of itself, with a small title and a one-line honesty label in the left margin and the captions under them; no header, no chapter rail, no notes (the earlier split layout, a title column on the left, is kept as `bench-coach-demo.split.mp4`). The first Lens shot is the second lever on the rim with the coach speaking, under the title "Presenting Bench Coach". The middle act, from looking down at the floor to the tube coming out on the far side, is one take with no cuts at real speed, 52 s, and the coach's own voice carries it: the narrator speaks only before the coach starts (the honest note) and once at the far side, after the coach's line. The judges asked for an unbroken minute at the Nov 5 live review and for "what it feels like"; the coach being heard is that. After the repair: our first Finish card, recorded Nov 5, against the compact one (the judges' "website on your face" rule applied, without naming the review in the video); then the drill; then the coach adapting (run 1's drop, run 2's card, the early hint); then a card from the design brief, the Lens Studio window and the tests; then proven and unproven.

| At | On screen | Footage |
| --- | --- | --- |
| 0:00 | The problem | `t00-intro` 0 to 10.0267 s, 1.15x speed, full frame |
| 0:08 | Bench Coach | `t04-step4-p` 14.25 to 22.15 s |
| 0:16 | A flat, and no one to ask | `t11-wide-right` 3.9 to 9 s |
| 0:21 | A flat, and no one to ask | `t11-wide-left` 4.3 to 9 s |
| 0:26 | First, the floor | `t13-unbroken-c` 26.3 to 32.6 s |
| 0:32 | Found it, then Watch first | `t13-unbroken-c` 32.6 to 43.9 s |
| 0:43 | It names what it sees | `t13-unbroken-c` 43.9 to 48.33 s |
| 0:48 | Let the air out, loosen the bead | `t13-unbroken-c` 48.33 to 54.3 s |
| 0:54 | A ghost shows where the lever goes | `t13-unbroken-c` 54.3 to 58.62 s |
| 0:58 | Hook, slide, peel | `t13-unbroken-c` 58.62 to 66.81 s |
| 1:06 | The next step is behind the wheel | `t13-unbroken-c` 66.81 to 78.6 s |
| 1:18 | Second lever before the first | `t07-mistake` 13.5 to 16 s |
| 1:21 | Do it wrong and the coach says why | `t07-mistake` 38 to 45 s |
| 1:28 | Find what caused the flat | `t06-inspect` 18.3 to 23.8 s |
| 1:33 | A question, answered next to the part | `t06-ask` 5.8 to 13 s |
| 1:40 | New tube in, bead on, pump | `t09-refit-p` 14.74 to 31.02 s, 3x speed |
| 1:46 | A wall of text | `t10-report` 42 to 47.2 s |
| 1:51 | Three lines and one tip | `t14-finish` 23.8 to 30.6 s |
| 1:58 | Practise the step you got wrong | `t15-practise-b` 26.4 to 27.5 s |
| 1:59 | Practise the step you got wrong | `t15-practise-b` 28.9 to 31.6 s |
| 2:02 | Practise the step you got wrong | `t15-practise-b` 41.9 to 45.45 s, last frame held 1.5 s |
| 2:07 | The coach keeps a score per step | `t16-memory` 28.4 to 31.4 s |
| 2:10 | Quiet where you're good | `t17-run2` 34.2 to 37.2 s |
| 2:13 | Sooner where you slipped | `t18-struggle` 37.4 to 44 s |
| 2:19 | devpost/design-brief.md | text card from the design brief |
| 2:24 | Built in Lens Studio | still of the Lens Studio window |
| 2:27 | 23 of 23 scenarios pass | `t12-tests` 10.4 to 13.15 s |
| 2:30 | 23 of 23 scenarios pass | `t12-tests` 14.5 to 18.7 s |
| 2:34 | Logic: proven | `t04-wide-left` 4 to 10.5 s |
| 2:41 | Feel: unproven | `t04-wide-left` 10.5 to 20.1 s |
| 2:50 | Bench Coach | title card |

Differences from the plan above:

- The testing shot shows the `lever-snap` scenario driving the Lens next to the list of the 23 scenarios. The LEAF panel itself could not be captured.
- The Finish card is from the `coach-report` test run (two wrong lever drops, one early pinch), so it shows real numbers. The video says so on screen.
- The refit (steps 8 to 10) plays at 3 times speed, and the video says so on screen.
- The coach-adapts shots are driven by the `adaptive-coach` scenario, and the video says so on screen. Its More view (the "Coach memory" line) is not in the cut: the scenario jumps to the Finish card, which leaves the run's counts at zero, so that card reads "Mistakes 0" above "lever A needs help". The Run 2 start card carries the memory instead.
- The floor-found moment is the first 7 s of the unbroken take: bare floor, the coach's "floor found" line, the tilt up to the card.
- The one-take act ends 0.2 s after step 6 starts: from the far side the step 6 callout sits partly behind the stand's clamp.
- The drill is cut from a run the `practise-step` scenario drives, so its reps are quick; the simulated hand carries the lever past the camera between reps, and those spans are cut out.
- What's this? shows the Tire card. The Valve card's leader runs behind the step callout from this pose.
- The design brief is on screen as a text card (its file name, status line and the one spatial moment) while the narration names it; then the Lens Studio window and the test list.
- The video opens on the problem, not the Lens: a nine-second AI-generated clip Anudeep made on Nov 7 (`t00-intro`, 640 x 360, scaled to the frame). Its own narration states the problem, including "nearly half of adults can't fix a flat tire", and the source of that figure (Cycling UK, 47%) is on screen with the label "AI-generated illustration. The Lens starts next." Because the clip says the stat and the phone problem once, the Lens's first line is only the reveal ("Presenting Bench Coach. Put on your glasses, and now you have everything you need.") and the who-it's-for line no longer mentions the phone; it answers the clip's "someone else's angle" with "seen from your own angle". The clip runs at 1.15 times speed, voice tempo-shifted with the pitch kept, so the Lens is on screen at 0:09 and inside the judges' 10-second rule.
- The drill is titled "If you want it" and its line says so; the person with a flat wants the tube out, and the Finish card's default is three lines and one tip.
- Four narration lines from the earlier cuts are not used (the "one take" announcement, the scan, lever A, the Finish card): they explained what the coach was already saying on screen, and the sixth cut lets the coach be heard instead. The far-side line was recorded again shorter (n07d) so it fits after the coach's own line. The captions file carries the words as spoken.
- The Nov 5 beat is worded for what happened: the judges marked another project's dense end screen down as "a website on your face"; our Finish card recorded that day (`t10-report`) was the same pattern, and the compact card is the fix. A first take of that line said the judges had seen our card; they had not, and the clip (n17) is unused. On Nov 7 the Nov 5 narration clips were generated again by mistake, so every line is a Nov 7 take; the offsets were checked against the new lengths and nothing overlaps.

## Checks before upload

- App on screen within the first 10 seconds (it is on screen at 0:09, after the problem clip).
- Total under 3:00.
- Narration says "needs internet, falls back offline" (1:35 row).
- Narration says the preview stands the wheel in with a pinch (0:25 row).
- Lens audio audible: hiss, zipper, chime, and the coach's voice at the first Lens shot, after Found it, on the mistake and on the Finish card.
- Someone has listened to the whole cut. So far the mix was checked by level only (the sixth cut: -15.1 LUFS, no silence over 2.5 s except after the far-side line and after the Nov 5 line, both under 5 s with the Lens audio under them).
- YouTube visibility set to Public, link pasted into the Devpost form.
