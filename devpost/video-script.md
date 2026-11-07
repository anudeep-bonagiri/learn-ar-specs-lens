# Bench Coach, demo video script (2:43 as cut)

Drafted Nov 4 from plan Section 11 (`docs/BENCH_COACH_PLAN.md`) and the judges' rules in
`docs/INFO_SESSION_OCT29.md`. The table below is the sixth cut (Nov 7 evening) as spoken; the draft's rows were replaced once the cut settled.

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
| 0:17 to 0:29 | Wide: the wheel in the stand, the callout on the part, the dock low | "It's for anyone with something broken and no one to ask. Glasses keep both hands on the wheel and put each instruction on the part it's about, seen from your own angle." |
| 0:29 to 1:15 | **One take, no cuts, 46 s.** Start card and Found it, the scan up the tire, step 1, the beads, lever A on its ghost, lever B round to 5 o'clock, then the far side: chime, edge arrow, floor path, the walk, the tube out. The coach's own voice carries it | Only twice. Over the start card: "One honest note first: the Lens Studio preview can't see a real wheel, so a pinch stands one in. The design is for your own wheel. The virtual one is the stand-in." At the far side, after the coach's line: "A chime, an arrow at the edge of your view, a path on the floor. A screen on the bench can't follow you there." |
| 1:15 to 1:25 | The second lever grabbed first; the amber Not quite | "Do it wrong, say lever B first, and the coach tells you why, right on the label." "Mistakes count on your report at the end." |
| 1:25 to 1:37 | Inspect: the thorn. Ask: the offline answer next to the part | "Before the new tube goes in, find what caused the flat: a thorn, glass, or a pinch. Pinch any part and ask what it is." "Ask the coach a question and it answers next to the part. That needs internet. Offline, it falls back to built-in answers." |
| 1:37 to 1:44 | Refit at 2.6x: tube in, bead on, pump | "Fit the new tube starting at the valve hole, seat the bead, and hold the valve to inflate." |
| 1:44 to 1:57 | The dense Finish card recorded on Nov 5, then the compact one | "At the Nov 5 review the judges marked a dense end screen down as a website on your face. Ours was one. Now it's your time, one tip, and the rest behind More." |
| 1:57 to 2:06 | The drill: three reps of lever A | "And if you want it, practise the step you got wrong: three reps on the wheel, and the card keeps your best time." |
| 2:06 to 2:22 | A card from `devpost/design-brief.md` (the one spatial moment), the Lens Studio window, the 22 LEAF scenarios | "We planned it in a design brief, built it with Claude through Lens Studio's MCP, and tested it with LEAF: twenty-two scenarios that run the whole repair in the preview. All of them pass." |
| 2:22 to 2:39 | "Logic: proven" and "Feel: unproven" over the wide shot | "What's proven: the logic, every step, every mistake, every test. What isn't: how it feels on real glasses, lining up with a real wheel, how a lever feels in the hand. That's what we'd test next." |
| 2:39 to 2:43 | Title card: Bench Coach, repo link | "Bench Coach. The repair, on the part, for Specs." |

## How it was recorded and cut (Nov 5, pickups Nov 6, the one-take act Nov 7)

The recipe that stood here (Plane room, macOS screen recording, cursor visible) was not used. What happened instead:

- **Room:** the Garage preview room (`preview-room/Garage`), from the start eye.
- **Recording:** the Mac's screen was locked, and macOS refuses screen and window capture while locked. The footage was captured with the Preview panel's own screenshot call in a loop inside Lens Studio, through the MCP: the preview render only, 1392 x 1731, 25 to 28 frames a second, no cursor. See the design notes, "Pass R".
- **Sound:** the frames are silent. Every take's sound was rebuilt from the Lens log (`[Voice]` and `[Audio]` lines with wall-clock times) and the Lens's own audio files.
- **Takes:** 25 on Nov 5, about 13 minutes; 6 pickup takes on Nov 6 after pass P changed what five shots show (the `-p` takes below); and on Nov 7, after passes S1 and S2, one unbroken take of Watch first from the start card to the far side (`t13-unbroken-c`, four attempts, the one with no recorder gap inside a camera move), the compact Finish card (`t14-finish`) and the drill driven by the `practise-step` scenario (`t15-practise-b`). Watch first drives steps 1 to 5 and 7 to 10. Real preview mouse input drives Found it, the glint, Continue and the mistake (the second lever grabbed first). Ask shows the offline answer.
- **Narration:** the table above, read by an ElevenLabs voice. Two rows were split so the coach's own voice can be heard in between. The 2:10 row's clip names the design brief (`devpost/design-brief.md`); a clip without that clause was used in the cuts before the brief existed.
- **Cut:** 2:43 long, 1920 x 1080 (the sixth cut, Nov 7 evening, rebuilt against the rubric). The first nine seconds are Anudeep's generated clip of the problem, full frame, with its own voice, run at 1.15 times speed so the Lens is on screen at 0:09. From there the preview render sits at full height in the centre of the frame on a blurred copy of itself, with a small title and a one-line honesty label in the left margin and the captions under them; no header, no chapter rail, no notes (the earlier split layout, a title column on the left, is kept as `bench-coach-demo.split.mp4`). The first Lens shot is the second lever on the rim with the coach speaking, under the title "Presenting Bench Coach". The middle act, from the start card to the tube coming out on the far side, is one take with no cuts at real speed, 46 s, and the coach's own voice carries it: the narrator speaks only before the coach starts (the honest note) and once at the far side, after the coach's line. The judges asked for an unbroken minute at the Nov 5 live review and for "what it feels like"; the coach being heard is that. After the repair: the dense Finish card recorded on Nov 5 against the compact one, which is the Nov 5 rule ("a website on your face") applied; then the drill; then a card from the design brief, the Lens Studio window and the tests; then proven and unproven.

| At | On screen | Footage |
| --- | --- | --- |
| 0:00 | The problem | `t00-intro` 0 to 10.0267 s, 1.15x speed, full frame |
| 0:09 | Bench Coach | `t04-step4-p` 14.25 to 22.15 s |
| 0:17 | Something broken, and no one to ask | `t11-wide-right` 3.9 to 10.4 s |
| 0:23 | Something broken, and no one to ask | `t11-wide-left` 4.3 to 10.4 s |
| 0:29 | Found it, then Watch first | `t13-unbroken-c` 32.6 to 43.9 s |
| 0:40 | It names what it sees | `t13-unbroken-c` 43.9 to 48.33 s |
| 0:45 | Let the air out, loosen the bead | `t13-unbroken-c` 48.33 to 54.3 s |
| 0:51 | A ghost shows where the lever goes | `t13-unbroken-c` 54.3 to 58.62 s |
| 0:55 | Hook, slide, peel | `t13-unbroken-c` 58.62 to 66.81 s |
| 1:03 | The next step is behind the wheel | `t13-unbroken-c` 66.81 to 78.6 s |
| 1:15 | Second lever before the first | `t07-mistake` 13.5 to 16 s |
| 1:18 | Do it wrong and the coach says why | `t07-mistake` 38 to 45 s |
| 1:25 | Find what caused the flat | `t06-inspect` 18.3 to 23.8 s |
| 1:30 | A question, answered next to the part | `t06-ask` 5.8 to 13 s |
| 1:37 | New tube in, bead on, pump | `t09-refit-p` 14.74 to 31.02 s, 2.6x speed |
| 1:44 | "A website on your face" | `t10-report` 42 to 47.5 s |
| 1:49 | Three lines and one tip | `t14-finish` 23.8 to 31.8 s |
| 1:57 | Practise the step you got wrong | `t15-practise-b` 26.4 to 27.5 s |
| 1:58 | Practise the step you got wrong | `t15-practise-b` 28.9 to 31.6 s |
| 2:01 | Practise the step you got wrong | `t15-practise-b` 41.9 to 45.45 s, last frame held 1.5 s |
| 2:06 | devpost/design-brief.md | text card from the design brief |
| 2:11 | Built in Lens Studio | still of the Lens Studio window |
| 2:14 | 22 of 22 scenarios pass | `t12-tests` 10.4 to 13.15 s |
| 2:17 | 22 of 22 scenarios pass | `t12-tests` 14.5 to 19.4 s |
| 2:22 | Logic: proven | `t04-wide-left` 4 to 10.5 s |
| 2:28 | Feel: unproven | `t04-wide-left` 10.5 to 20.9 s |
| 2:39 | Bench Coach | title card |

Differences from the plan above:

- The testing shot shows the `lever-snap` scenario driving the Lens next to the list of the 22 scenarios. The LEAF panel itself could not be captured.
- The Finish card is from the `coach-report` test run (two wrong lever drops, one early pinch), so it shows real numbers. The video says so on screen.
- The refit (steps 8 to 10) plays at 2.6 times speed, and the video says so on screen.
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
