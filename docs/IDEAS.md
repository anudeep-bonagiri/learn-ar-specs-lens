# Idea deep dive

Compiled 2026-10-16, after the organizers' welcome email.
Use this to walk into the `plan-lens` interview with a sharp answer to every question.
The interview is learner-led, so treat these as your own prepared thinking, not a script to paste.

## 1. The filter judges actually apply

The welcome email says the concept video covers "the design ideas the judges look for."
The skill pack's design rules spell those ideas out.

**The three strengths of glasses.** The skill pack says good AR uses one and great AR combines them.

1. **Shares your view.** It uses what you are looking at.
2. **Draws in the world.** Content sits on the table or the floor, at real size.
3. **Leaves your body free.** Hands and eyes stay available while you move.

**The four design habits:**

- Put information on the thing it is about, not on a floating panel.
- Show it only when needed.
- Use a few big targets.
- Keep it where the user is already looking.

**Constraints that kill ideas in this contest:**

- **The core moment must work in preview.** Preview is a simulated room with a virtual table, driven by keyboard and mouse.
- **The can't-show list stays out of the core.** That covers live camera vision, two-hand or custom gestures, hand pose and speed, persistence across sessions, and multi-person use.
- **"Shares your view" can only be faked in preview.** Use a "found it" pinch or a hard-coded result. So the safest wins lean on *draws in the world* plus *leaves your body free*, with at most one stand-in.
- **The phone test.** The brief's judging step asks: "Would a phone do just as well?" If yes, the idea loses on Design.

**What everyone else will build.** The skill pack's own worked example is a risotto cooking coach with timers over pots.
Expect a wave of cooking coaches, recipe helpers, translators and floating AI chat panels. Avoid all of them.

## 2. Scorecard

The three pillars are share view (S), draws in world (W) and body free (B).

| Idea | Pillars | Core works in preview? | Beats a phone? | Novelty | Verdict |
|---|---|---|---|---|---|
| **Loci: a memory palace in your room** | W, B, S stand-in | Yes, fully | Yes | High on glasses | **Top pick** |
| **Smoke Line: a home fire drill** | W, B | Yes, fully | Yes, crouching and hands-free PASS | Medium; Kidde has a phone AR drill | **Strong** |
| **Land It: a predict-then-drop physics lab** | W, B | Yes, fully | Mostly | Medium | **Solid backup** |
| Bench Coach repair guide | W, B, S stand-in | Needs a recognition stand-in | Yes | Low; an enterprise AR staple | Maybe |
| SunSpot sun-path visualizer | W | Yes | **No**, Sun Seeker already does this on phones | Low | Dropped |
| Cooking or recipe coach | W, B | Yes | Yes | **Very low**; it's the skill pack's own example | Avoid |
| Furniture fit check | W | Yes | **No**, phone AR furniture apps exist | Low | Dropped |
| Sign or menu translator | S | **No**, needs live camera vision | Yes | Low | Dropped |
| CPR or first-aid trainer | W, B | Partly; hand pose can't be shown | Yes | **Low**; Proximity Pulse already won | Dropped |
| Air drums or rhythm game | W, B | Partly; hand speed can't be shown | Yes | Low | Dropped |
| Shared board game | W | **No**, multi-person can't be shown | Yes | Medium | Dropped |
| Calm or breathing room | B | Yes | Weak; it doesn't use the world | Low | Dropped |

## 3. Deep dive: Loci, a memory palace in your room (top pick)

**Pitch:** "Walk your room to memorize anything. Loci pins what you need to learn onto the places around you, then quizzes you by walking the route."

**Why it fits you:** Your neuroscience background gives you a credible, personal "why it matters" for the video.
The method of loci is one of the best-studied memory techniques. It is also, literally, a technique about putting information in places.

**Evidence, stated honestly:**
- A 2022 VR study found people recalled about 20% more after one session than with traditional techniques. It was small, with about 21 participants.
- Legge et al. (2012) found a briefly learned virtual space worked as well as a familiar real place.
- So don't claim "your home works better than VR." Claim this instead: **glasses remove the setup cost.** Your room is already there, and you walk it hands-free, with notes down and eyes up.

**Prior art:** MemoryVaultAR is an iPad app, and there are VR memory palaces and academic AR prototypes.
No glasses-first version showed up in search. On an iPad you hold the screen up and out of the way of the walk. On glasses the walk *is* the interface.

### The one spatial moment

You stand in your room in recall mode. Each station glows softly as you walk toward it.
You say the answer in your head, pinch the station, and the card blooms open to confirm. Then a chime pulls you on to the next station.

### Pillar check
- **Draws in the world:** each fact lives at a place in your room at real scale, which is the whole point.
- **Body free:** you walk the route with hands free and eyes up. There is no phone held at arm's length.
- **Shares your view (stand-in):** in real use you would pinch a real object to drop a station there. In preview you pinch a spot on the virtual table, floor or wall.

### Product or overlay
It is a **product**, a trainer, with a light overlay. Stations attach to places, not to recognized objects, so no recognition is needed.

### Where things live

The numbers follow the skill pack's usable-area table.

| Element | Anchor | Distance | Height | Size |
|---|---|---|---|---|
| Station marker (orb) | A pinched spot on the table, floor or wall | Wherever you placed it | Where placed | 6 cm sphere |
| Memory card (open) | Above its station, facing you | Read at 60–110 cm | About 20 cm above the station | 24 × 16 cm, light text |
| Route line | Floor, connecting stations in order | — | Floor | 2 cm wide dotted line, recall mode only |
| Mode panel (Build / Recall / Score) | Body-locked lower left, appears on a palm-up or menu button | 45 cm | 25 cm below eye level | 18 × 10 cm, 3 large buttons |
| Score card | In front of you at the last station | 90 cm | Slightly below eye level | 40 × 25 cm |

### Hands and input
- **Build mode:** pinch an empty spot to drop the next station, which auto-fills the next card from the deck. Pinch and drag to move a station.
- **Recall mode:** pinch a glowing station to reveal it. Two big buttons follow: "Got it" and "Missed".
- No voice is needed. The deck is hard-coded, so voice and AI are out of the core.

### When things show
- **In build mode,** cards stay open while you place them, then shrink to orbs.
- **In recall mode,** only orbs show. The nearest unvisited orb pulses, and the others stay dim.
- A card opens only on a pinch and closes after "Got it" or "Missed".
- If the next station is out of view, a soft chime plays and a small arrow appears at the edge of the view.
- The route line appears only in recall mode, so it guides without giving answers away.

### Sample deck
Use the 12 cranial nerves (Olfactory → Hypoglossal), a classic neuroscience memorization list. It makes a crisp demo with a clear right answer per station.
For a bonus, add a second, unrelated deck to show it works for anything, such as a 7-point speech outline.

### Done criteria

All of these can be tested in preview with LEAF.

1. In build mode, 7 pinches at 7 different spots create 7 stations, each holding the next deck item in order.
2. Switching to recall mode hides every card's text and shows only orbs and the route line.
3. Pinching a station opens its card. Pressing "Got it" or "Missed" closes it and lights the next station.
4. When the next station is behind the user, a chime plays and an edge arrow points toward it.
5. After the last station, the score card shows correct out of total, and lists the missed items.

### Out of scope
- Saving the palace between sessions, because persistence can't be shown in preview. Say "feel unproven" in the video.
- Spaced-repetition scheduling.
- AI-generated decks.
- Recognizing real objects.

### Risks
- Placing stations by pinching in the preview room may feel fiddly with a mouse. Mitigate with snap-to-surface and a generous placement radius.
- Twelve stations is a lot of walking for a 3-minute video. Use 7 in the demo.

### 3-minute video plan

| Time | Shot |
|---|---|
| 0:00–0:15 | Problem hook: "Med students memorize hundreds of lists. The memory palace is a famous technique, and nobody uses it because building one is work." |
| 0:15–0:30 | Why glasses: "Your room is already a palace. Loci lets you walk it hands-free." |
| 0:30–1:15 | Build mode: place 7 cranial nerve stations around the room. |
| 1:15–2:15 | Recall mode: walk the route, pulse, pinch, reveal, chime and arrow to a station behind you, then the score card. |
| 2:15–2:40 | LEAF test results on screen, plus "logic proven" and "feel unproven" labels. |
| 2:40–3:00 | Built with plan-lens, CLAD and the Lens Studio MCP. Next steps: real-object anchors, persistence, any deck. |

## 4. Deep dive: Smoke Line, a home fire drill (strong alternative)

**Pitch:** "Practice a house fire in your own home before you ever have one. Learn when to fight it and when to get out, and how to get out under the smoke."

**Why it matters:** Smoke, not flames, causes most home-fire deaths. Most people have never touched an extinguisher.
Live-fire training is rare and expensive, while a drill in your own space makes the plan concrete.

**Prior art:** Kidde's free "Prepare. Plan. Practice." tool, launched Oct 2025, is a phone and tablet AR fire drill. That cuts novelty.
**It also hands you the phone-test argument.** On a phone you can't keep both hands free for the extinguisher motions. You also can't feel the smoke ceiling drop onto your head as you duck under it.

### The one spatial moment
A virtual smoke layer pours down from your real ceiling. A line of glowing floor arrows leads to the door you marked.
Stand up and the view fills with haze and an alarm. Crouch below the smoke line and the view clears, so you crawl the route out.

### Pillar check
- **Draws in the world:** fire in your kitchen, smoke at your ceiling height, arrows on your floor to your door.
- **Body free:** you crouch and move, and your hands do the PASS steps (pull, aim, squeeze, sweep) without holding a phone.
- **Shares your view (stand-in):** "mark your real extinguisher" and "mark your door" become pinch-to-mark in preview.

### Product or overlay
It is a **product**, a trainer, staged in your space. Stand-ins mark the door and the extinguisher location, using a pinch.

### Flow
1. **Set up.** Pinch to mark your exit door and your extinguisher spot. You get two big buttons.
2. **Small-fire round.** A wastebasket-sized fire, about 40 cm, appears on the floor. Grab the extinguisher marker, then follow the four PASS prompts:
   - Pinch the pin to pull it.
   - Drag the nozzle to aim at the base.
   - Hold a pinch to squeeze.
   - Drag left and right to sweep.
   The fire shrinks only when you aim at the base.
3. **Decision round.** The fire grows past the ceiling-height threshold, and the prompt says "Too big. Get out."
4. **Escape round.** The smoke layer descends. Crouch under it and follow the arrows. The drill times your escape.
5. **Score.** You see escape time, whether you stayed low, and PASS accuracy.

### Where things live

| Element | Anchor | Distance | Height | Size |
|---|---|---|---|---|
| Fire | Floor, at a pinched spot | 1–2 m | Floor | 40 cm to start, grows to 120 cm |
| Smoke layer | Ceiling plane, descending | All around | Drops from 240 cm to 90 cm | Room-wide, light gray-white |
| Exit arrows | Floor, along the path to the marked door | Ahead | Floor | 30 cm chevrons |
| PASS prompt | Next to the fire, never on your face | 1 m | Below eye level | 20 × 12 cm, one word plus an icon |
| Timer and score | Score only at the end, beside the door | 1 m | Eye level | 40 × 25 cm |

### Additive display gotcha
Black renders as transparent, so dark smoke would vanish. Render smoke as **light, bright haze with a crisp glowing boundary line** at its lower edge.
The visibility effect can be a white-out overlay that fades as you crouch. Fire renders great, since it is bright. Calling this out in the video shows design depth.

### Done criteria
1. Pinching twice marks a door and an extinguisher location, shown as glowing markers.
2. The four PASS steps in order shrink the 40 cm fire to zero. Aiming anywhere but the base does not shrink it.
3. When the fire passes 120 cm, the "Get out" prompt appears and the extinguisher stops working.
4. The smoke layer descends to 90 cm within 30 seconds. With the camera above it, a white-out overlay shows. Below it, the overlay is clear.
5. Reaching the door marker ends the drill and shows escape time and "stayed low" yes or no.

LEAF can drive pinches and drags. Crouch checks run against camera height in the preview, where Q and E move you down and up.

### Risks
- Fire content can feel scary or trigger distress. Keep it calm and instructional: "drill" tone, no screams, no gore, and a clear skip button.
- The real PASS motion is two-handed. In preview it is mouse drags, so label the physical feel "feel unproven."
- Novelty is medium because of Kidde. Win on the crouch moment and the fight-or-flee decision.

### 3-minute video plan

| Time | Shot |
|---|---|
| 0:00–0:15 | "You have about two minutes to get out of a house fire. Have you ever practiced?" |
| 0:15–1:00 | Mark the door and extinguisher, then put out the small fire with PASS. |
| 1:00–1:20 | The fire grows and the drill says "Too big. Get out." |
| 1:20–2:15 | The smoke drops from the ceiling. Stand and it whites out. Crouch and it clears. Follow the arrows to the door. |
| 2:15–2:40 | Score, LEAF results, and proven vs. unproven labels. |
| 2:40–3:00 | Why glasses beat a phone here. |

## 5. Deep dive: Land It, a predict-then-drop physics lab (backup)

**Pitch:** "Guess where it lands, then drop it and see. Physics homework on your actual table."

**The one spatial moment:** You set a ramp's angle with a slider and pinch to place a glowing "my guess" marker on the floor.
Then you release the ball. It rolls off the real-height table edge and lands. A ghost arc shows the real path next to a dashed arc of your guess.

**Pillar check:**
- **Draws in the world:** the ramp sits on your table at real height, and the ball lands on your floor at true scale.
- **Body free:** you lean, walk around and look from the side to judge the arc, with nothing in your hands.

**Why it beats a phone:** you see the real-scale arc from any angle by walking around it. A phone shows it through a small window you have to hold up.

**Loop:**
1. Set the angle and height.
2. Predict the landing spot.
3. Drop the ball.
4. Compare.
5. The next challenge adds a target cup on the floor: "land it in the cup."

**Done criteria:**
1. The angle slider changes the ramp from 10° to 60°.
2. Pinching the floor places one guess marker.
3. The drop button releases the ball, which follows physics and lands.
4. Distance between the guess and the actual landing spot shows in cm.
5. Landing in the cup triggers success and loads the next level.

**Risks:** Physics determinism can make LEAF assertions flaky. Assert on "landed within X cm" ranges.
Novelty is medium, so lean into the target-cup challenge and a teacher or student audience.

## 6. Recommendation

**Build Loci.**

| Criterion | How Loci scores |
|---|---|
| Design | One complete loop with a build, a recall and a score. It uses two pillars natively, with a stand-in for the third. |
| Technical | Everything is SIK pinch and drag, UI Kit buttons and a hard-coded deck. LEAF can test every done criterion. |
| Innovation | No glasses-first memory palace showed up, and it is far from the cooking-coach crowd. |
| Presentation | A personal, credible story and a demo moment people instantly get. |

**Pick Smoke Line** if you want the more emotional, high-stakes story and are fine handling the Kidde prior art head-on.

## 7. Timeline to Nov 9

| When | Do |
|---|---|
| Now to Oct 21 | Install Lens Studio 5.22+, CLAD and the skill pack. Run `plan-lens` and approve the brief. |
| Thu Oct 22, 12pm ET | Live build session. Bring setup questions. |
| Oct 23–Nov 1 | CLAD build, LEAF tests, and preview judging. Iterate with design notes. |
| Thu Nov 5, 12pm ET | Live project review. Bring the working loop and ask about the Design score specifically. |
| Nov 6–8 | Polish, record the video, write the README, make the repo public. |
| Mon Nov 9, 5pm ET | Submit. Aim for Nov 8 to leave buffer. |
| Thu Nov 19 | Winners announced. |

## Sources
- Skill pack rules: https://github.com/challengepost/learn-specs (references/ar-design-rules.md, references/preview-limits.md)
- VR method of loci feasibility study: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9540171/
- Legge et al. 2012: https://www.psych.ualberta.ca/~cml/papers/LeggEtal2012.pdf
- MemoryVaultAR: https://apps.apple.com/mn/app/memoryvaultar/id6748365494
- Kidde AR fire drill: https://internationalfireandsafetyjournal.com/think-youd-escape-a-house-fire-in-time-kiddes-new-simulator-puts-you-to-the-test/
