---
status: approved
lens: Bench Coach
planned: 2026-10-22
written: 2026-11-07
approved: 2026-11-07, Anudeep Bonagiri
---

# Design brief: Bench Coach

Bench Coach was planned on Oct 22, 2026, the day of the live build session, as written answers to the seven plan-lens questions: the idea, the one moment, product or overlay, where things live, hands, when things show, and done. The first build started from those answers on Oct 23. This file puts them in the plan-lens template with the numbers as they were planned, and ends with what the build changed. Values nobody chose at the time are marked (default). The dated record of every pass since is in `design-notes.md`.

## The one spatial moment
You stand at the front of the wheel with a tire lever hooked under the bead. The next step lights up on the far side of the wheel, opposite the valve, with a chime from that direction. You walk round the stand, grab the end of the tube and pull, and the tube slides out of the tire.

## Why it belongs on glasses
- Uses: draws in the world (ghost tools and markers sit on the rim, tire and valve at true scale); leaves your body free (both hands stay on the wheel and the levers, eyes on the work); shares your view (in real use the glasses would find your wheel; in the preview a pinch stands in for that).
- Who it's for: anyone with something broken and no one to ask. The first repair is a bike flat.
- Why it's better than the phone or laptop version: a phone is propped on the bench. You scrub a video with a greasy thumb and turn its camera angle into your own wheel in your head. Here the instruction is on your wheel, from your angle, and the next marker makes you walk to where the work is. A screen on the bench cannot follow you round the stand.

## Product or overlay
- Type: product. A trainer on a virtual wheel, designed so the same callouts could sit on a real wheel once the glasses can find one.
- What the real version would sense: the user's own rear wheel in a repair stand (rim, valve, tire), and the levers and tube in their hands.
- Stand-in for the preview: a start card with one big Found it button places a 70 cm wheel in a stand 90 cm ahead. A badge on the card says the wheel was placed by a pinch. The levers and the tube are virtual parts you grab.

## Where things live
- Where the user is looking during the main task: at the wheel, 90 cm away, hub 100 cm off the floor, a little below eye level. On step 5, at the far side of the wheel, after walking round the stand.
- Repair stand: on the floor, 90 cm in front of where the user starts; post 120 cm tall, light grey.
- Wheel: in the stand's clamp, hub at 100 cm; 70 cm across (a 700c wheel), mid grey tire, tube inside, valve at 12 o'clock.
- Step marker: a 3 cm glowing ring, 1 cm off the part the step is about. Finished steps leave a small dim tick.
- Step label: 10 cm off its marker, facing the user, one line on a light plate, about 16 x 5 cm.
- Ghost tool: on the wheel at the exact target pose, same shape as the lever, see-through cyan.
- Tool tray: low on the right, 40 cm out and 25 cm below the eye line, 20 x 10 cm, holding two 12 cm tire levers.
- Control bar: low in front, 45 cm out and 25 cm below the eye line. Back 5 cm, Next 6 cm, Replay 5 cm, 2 cm gaps (default, from Snap's 4 to 6 cm target size).
- Edge arrow: at the edge of the view, 45 cm out, 3 cm, only while the current marker is out of view.
- Start card and Done card: 24 x 14 cm, in front of the wheel at 90 cm; the Done card above the wheel.
- Thorn: a 1 cm glint in the tire at 4 o'clock, inside face.

## Hands and input
- Pinch: Found it, Next, Back and Replay (buttons); the valve to let the air out; the four lit bead sections to loosen the bead; the glint to find the cause.
- Grab and drop: lever A from the tray onto the ghost. Within 4 cm of the socket it snaps in and the bead lifts. Further away it plays a "nope" and goes back to the tray.
- Grab, drop and drag: lever B onto its ghost 5 cm along, then along the rim. The bead peels up behind it with a zipper sound.
- Grab and pull: the tube end, 15 cm away from the rim, and the tube slides out.
- Targets are big and highlight when aimed at.
- Voice (if any) and the button that does the same job: no voice input. Everything is a button or a part you can pinch. No two-hand or custom gestures.

## When things show
- Step marker and label: one step at a time; show on entering the step, hide when it is done, leaving a dim tick on the part.
- Ghost tool: shows for the current lever step only, hides the moment the lever is placed.
- Tool tray: shows on the two lever steps, hides otherwise.
- Start card: step 0 only. Done card: the last step only, with the time taken.
- Thorn glint: the inspect step only.
- No panel ever sits between the user and the wheel.
- If something needs attention out of view: a chime from the marker's position, once per step, and a small arrow at the edge of the view.

## Done criteria
Each one can be checked in Lens Studio's preview.
1. Pinching Found it places a 70 cm wheel in a stand 90 cm ahead, and step 1's marker sits on the valve.
2. Steps 1 and 2 complete by pinching the valve and the four lit bead sections, and only the current step's marker is visible.
3. Dropping lever A on the ghost snaps it in and lifts the bead. Dropping it 10 cm away rejects it and returns it to the tray.
4. Dragging lever B along the rim peels the bead, then the far-side marker and chime fire, and pulling the tube end removes the tube.
5. Pinching the thorn ends the repair with a timed Done card. Back and Replay work at every step. Try again returns to step 0.

## Out of scope
- Taking the wheel off the bike, and taking the second bead off. The wheel is already in the stand.
- Fitting the new tube. Version 1 ends at tube out and cause found.
- Any repair other than a flat. "Next skill: brake pads" on the Done card is a name only.
- Recognising a real wheel, and running on SPECS hardware. Nobody on the team has the glasses.
- Custom or two-hand gestures, hand pose or speed, voice input, memory across sessions, two people in one Lens.

## Risks and open questions
- It could read as a step-by-step slideshow with a Next button. Kept, and answered by design: every step needs a body action, the wheel changes as you act, step 5 is behind the wheel, and finding the cause is a search.
- Grab and drop may be fiddly with a mouse. A 4 cm snap radius and a reject that returns the lever. If it fails twice in the first session, levers become pinch-the-ghost.
- Black and dark grey vanish on an additive display. The wheel is mid grey and every overlay is bright. Checked on Oct 23: a black cube did not render at all in the SPECS preview.
- Only real glasses can answer: lining the virtual wheel up with a real one, how much force a lever takes and how it feels, whether a ghost tool reads against a real tire, and whether the chime lands while your hands are busy.

## Build notes for CLAD
- Build for SPECS so it runs and can be demonstrated in Lens Studio's preview. No SPECS device is available.
- Use Spectacles Interaction Kit (SIK) and UI Kit for all interactions, so they work with the mouse in Interactive Preview and with LEAF.
- Build any stand-in exactly as described above, and keep it obvious in the scene.
- Use real-world scale in centimeters. Keep content inside the user's view during the main task.
- The display is additive: black renders as transparent. Don't rely on black or very dark content to be seen; keep text light and readable from where the user stands.
- Get the basic flow working first, then add detail.
- Write LEAF scenarios for each done criterion, run them in preview, and report which pass. Say which criteria have no test.
- Don't record, identify, or follow people.

## After the build: judge it
This part is for you, after CLAD finishes.

1. **Does it work?** Ask your agent which LEAF tests passed and which done criteria have no test.
2. **Walk around it.** Open the preview in Interactive Preview. Use WASD to move, Q and E to go down and up, and right-drag (or hold Shift) to look around. Clicking acts as a pinch. Stand where a user would and look at the task.
3. **Ask the three questions.**
   - Does it use what I'm looking at?
   - Does it put something in my space, where it belongs?
   - Does it free my hands or let me keep my eyes up?
   - Would it be just as good on a phone? If so, what would make it need the glasses?
4. **Check comfort.**
   - Everything I need is in view while I do the task. Nothing sits at the edges, behind me, or stuck to my face.
   - Every control is within reach of someone standing there.
   - Text reads easily from where I stand. No dark UI disappearing.
   - Things show when needed and get out of the way.
5. **Label what you know.** Write "logic proven" next to anything the tests and preview show working, and "feel unproven" next to anything only real glasses could tell you (comfort over time, real hand tracking, real recognition).
6. **Fix with design notes, not code.** Tell your agent what to change in design terms, for example: "Move the step card 15 cm lower and next to the pan. Make the Next button twice as big. Re-run the tests." If a fix takes under a minute, like nudging a panel, do it yourself in the scene.
7. **Submit.** Record a video under 3 minutes of your Lens in the preview, public on YouTube. Make your repo public with your Lens Studio project and this `devpost/` folder. Details are on the hackathon site: https://learn-specs.devpost.com/resources

## What the build changed
Added Nov 7, 2026, after the last pass. Each line has its date in `design-notes.md`.

**Kept as planned.** The one moment: the chime, the edge arrow and the walk round the stand. The virtual wheel as the stand-in, said out loud in the video and on the page. Every instruction on its part, one step at a time. Pinch, grab, drop and drag, and nothing the mouse cannot do. The mid grey wheel. All five done criteria, each with its own LEAF test.

**Found in the first session (Oct 23).** `PinchButton` does not exist in SIK 2.0; buttons are UI Kit Buttons. The mesh presets could not make a thin 62 cm rim, so the rim, the bead sections and the tube are built in code with MeshBuilder, which is also what lets them lift, peel and deflate one section at a time.

**Grew.** The repair now runs to the end: feed the new tube in, seat the bead, hold the valve to pump (Oct 24). That made 10 steps instead of 7 and a halfway card at tube out. The flat has one of three causes, a thorn, glass or a pinch, and the Finish card names it. Seven kinds of mistake are explained on the callout and, since Nov 5, out loud: the coach speaks 30 recorded lines, with a Voice switch. The preview cannot see your wheel or hear you, so the AI in the Lens is a question at a time: Ask puts three questions under the step and answers next to the part, live from Gemini when there is a token and internet, otherwise from a built-in answer tagged "Offline answer" (Oct 24). What's this? names any part you pinch. Watch first plays the whole repair by itself (Oct 24); after the Nov 5 review it waits at step 5 for you to walk round before it pulls the tube (Nov 6). The far-side cue gained a path of arrows on the floor and a stand-here marker (Oct 24).

**Moved.** The floor was assumed to be 150 cm below the eye. It is now found with World Query and the stand, the mat and the path stand on it (Oct 28). The control bar became a four-button dock, Back, Replay, Next and More, after a hand reaching for the wheel kept pressing Next; every button now answers a ray pinch only (Oct 28). Type sizes, plates and colours live in one file after the Oct 29 info session: bigger text, fewer buttons, show it only when needed, no signal by colour alone (Nov 1). The Done card became a Finish card with the time, one tip for next time, and the rest behind More (Nov 6). Its Practise button names the step you got wrong most and drills it three times (Nov 7). The drill is optional and behind one button on purpose: the person this is for has something broken and wants it fixed, so the default card is three lines and one tip for next time.

**Judged.** The five tests became 22, run in two preview rooms, including one that fails if any text is too small or crosses its plate. Logic proven: the step order, the snap, the peel, the pull and the refit, every mistake, the far-side cue, what shows when, when the coach speaks. Feel unproven: the Lens has never run on SPECS, and the camera is not used.
