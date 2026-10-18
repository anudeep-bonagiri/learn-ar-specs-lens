# Council debate: Fit Check vs Bench Coach

Run 2026-10-17 with hex/claude-council (--debate), seats: codex (gpt-6-sol) and claude-cli. Input: the official Devpost overview, judging criteria and FAQ fetched that day, plus the skill pack's preview limits. Market numbers are the models' estimates and citations were not checked.

## Round 1: Initial Responses


---
## ● Claude-cli - default
# Fit Check vs. Bench Coach

**Short answer:** Go with **Bench Coach, aimed at home bike maintenance, starting with fixing a flat.** More people need it, they need it more than once, and "my hands are greasy and busy" is the clearest reason glasses beat a phone. The wheelchair version of Fit Check has the most striking "why glasses" story, but too few people would use it often, and it's very hard to make believable in a simulated room.

All market sizes below are my rough estimates, not verified data.

---

## Direction A: Fit Check

**Audiences**

| Who | When / problem | Rough size (US, estimate) |
|---|---|---|
| People buying large furniture online | "Will this sofa fit, and will it get through my hallway and door?" Happens on purchase or move day. | Tens of millions of households a year, but each one only a few times |
| Wheelchair users moving, renovating, or checking a rental or hotel | "Can I turn around in this bathroom or kitchen?" ADA uses a 1.5 m (60 in) turning circle. | About 3–5M wheelchair users; maybe a few hundred thousand in a given year are changing spaces |
| Occupational therapists and home-modification contractors | Weekly home assessments for clearances, grab bars, and ramps | About 150k OTs; a smaller share do home assessments |

**My bet within A:** the **doorway pivot** ("will it get through"). It's broader than the wheelchair angle, and it's a problem the existing apps don't really solve. The OT audience is the most frequent user, but it's a professional tool, which makes the story harder to tell in a short video.

**Existing products:** IKEA Kreativ/Place, Amazon AR View, Wayfair, Houzz, Apple RoomPlan, Magicplan, and Quest/Vision Pro furniture apps. True-size placement is probably **the best-known consumer AR use case there is.** To stand out, the Lens has to do one of these:
- Move the object along a path (pivot it through a doorway, with collision shown in red).
- Make your body the measuring tool (a 1.5 m turning disc that follows you).

**Spatial moment for the video:** you grab the sofa, walk it down the hall, and rotate it through the doorway. It turns red where it hits the frame, then clears once you tilt it.

For the wheelchair version, the moment is a turning disc locked to the user that clips the vanity. The phone is clearly worse here because **a wheelchair user's hands are on the push rims.** That's the strongest hands-free argument in either direction.

**Stand-ins and tech-demo risk**
- **Stand-ins needed:**
  - The real room becomes the simulated room. I haven't verified whether you can add a doorway or hallway to it, so you may need to build your own walls.
  - Seated eye height may not be possible to simulate. Movement uses WASD, not a wheelchair.
- **Biggest risk:** placing virtual furniture in a virtual room looks exactly like a 3D editor. "Drop a couch and walk around it" is basically the default Lens Studio demo, and the fake room means the "fit" proves nothing.

---

## Direction B: Bench Coach

**Audiences**

| Who | When / problem | Rough size (US, estimate) |
|---|---|---|
| Home cyclists doing their own maintenance | Flat tire, brake pads, chain. Several times a year, with dirty hands. | Tens of millions ride; a few million do their own repairs |
| Flat-pack furniture assemblers | Saturday afternoon: "which bolt, which side?" | Tens of millions a year, but every product needs its own guide |
| First-time PC builders | Once every few years: RAM seating, header pins | About 1–3M a year |

**My bet within B: bike maintenance.**
- The procedures are fairly standard across bikes, so one guide works for many users. Flat-pack needs a new guide for every product.
- People repeat these repairs. A flat happens again, which passes the "would I use it twice" test.
- A bike on a repair stand naturally sits 0.6–1.6 m away and slightly below eye level, which is where SPECS content works best.

**Existing products:**
- Phone and web: iFixit, Park Tool's guides, YouTube.
- Enterprise headsets: Dynamics 365 Guides, Vuforia, TeamViewer Frontline.
- Past SPECS winners (CPR trainer, card-game tutor), plus **the skill pack's own cooking-coach example.**

That means "step coach next to the work" is the pattern judges will see most often. What sets this one apart has to be that **the instructions live on the bike itself**, not in a floating panel:
- Ghost tools shown at true scale.
- Markers on the far side of the wheel that you have to walk around to see.
- Steps where you physically place a part.

**Spatial moment for the video:** a ghost tire lever animates into the tire bead at the valve. The user grabs a real-size virtual lever and hooks it where the ghost was. Then they walk around the stand, and the next marker is waiting on the back of the wheel.

The phone is clearly worse here: it's propped across the room, you're scrubbing a video with a greasy thumb, and you have to translate the video's camera angle onto your own bike.

**Stand-ins and tech-demo risk**
- **Stand-ins needed:**
  - The bike is a 3D model, anchored with a "found it" pinch.
  - Voice "next" becomes a button.
  - Step completion is confirmed by a grab-and-place action or a pinch.
- **Biggest risk:** **a slideshow.** An animated exploded diagram plus a "Next" button is just a 3D manual. Every step should involve your body: walking, grabbing, or placing something.

---

## The three angles

**1. Real target user (would they use it twice?)**
- **A:** Mostly no. You buy a sofa or move rarely. The wheelchair version is valued more highly but used rarely.
- **B:** Yes for cyclists, since flats come back. The real question is whether it beats a YouTube video they already know. It only does if hands-free use and on-bike markers save real fumbling.

**2. Judges (Devpost staff, not Snap, judging from video only)**

| | A: Fit Check | B: Bench Coach (bike) |
|---|---|---|
| Design (a complete product) | Weak, because the fake room undercuts the fit | Strong, because a full repair has a clear start, middle, and end |
| Technical (CLAD/MCP use) | Similar for both. Show the planning docs and the agent building in the video | Similar for both |
| Innovation ("differs from existing concepts") | Low as plain furniture placement; moderate with the pivot or wheelchair angle | Moderate. The pattern is familiar, but the object and on-object content are fresh |
| Presentation | The wheelchair story is emotionally powerful, but only if it's credible | "Fix a flat in 3 minutes" is an easy story to follow |

The developer marketing judge will reward a one-sentence pitch with a clear "who." The AI-learning judge will look for evidence that you followed the skill-pack process.

**3. Skeptic**
- **A:** "IKEA did this in 2017. A tape measure and a floor plan with a 1.5 m circle do the job. And a wheelchair tool built without wheelchair users risks being patronizing."
- **B:** "A phone propped on the bench is free and good enough. Writing guides is the real bottleneck. Without real object recognition, the app can't tell whether you actually did the step. And this is the most common SPECS hackathon idea."

The skeptic lands harder on A, because its core claim (that it fits) can't be shown in the preview. B's weaknesses can be handled in the design.

---

## Verdict

**Bench Coach for home cyclists, starting with fixing a flat.** It has the largest group of people who would use it more than once and the clearest hands-busy reason to wear glasses. It also suits the preview: one object at the right distance, walk-around content, and grab interactions. The way to stand out from the cooking coach and past winners is to keep the guidance on the bike and make every step involve your body.

**What would most change my mind:** real access to wheelchair users or an OT who shapes the design and appears in the video. That would make Fit Check's wheelchair version the most memorable and distinctive entry in the field, and it would outweigh its smaller audience with these judges.

The second thing would be the Discord showing lots of repair or step-coach entries. You can check this before committing.


---
## ● Codex - gpt-6-sol
## 1. Would someone use it twice?

**Fit Check has the sharper consequence; Bench Coach has the larger likely repeat-use audience.** These are U.S. audience estimates, not forecasts of Lens users.

| Direction | Audience and the day they need it | Rough size | Repeat-use case |
|---|---|---:|---|
| **A: Fit Check** | A wheelchair user or caregiver rearranges a room and needs to know whether the route around a new sofa still works. | Roughly **3.6–5.5 million** U.S. wheelchair users, based on differing published estimates; only a fraction are planning a room at a given time. [CMS](https://www.cms.gov/medicare-coverage-database/view/lcd.aspx?lcdid=40344&ver=12), [research article](https://pmc.ncbi.nlm.nih.gov/articles/PMC11398980/) | High value when needed, but room changes are occasional. |
| A | An occupational therapist or home-accessibility specialist visits a client and tests several furniture layouts before recommending one. | About **160,000 occupational therapists** in 2024; home visits are a subset. [BLS](https://www.bls.gov/opub/mlr/2026/article/industry-and-occupational-employment-projections-overview.htm) | The strongest repeat user: a new room or client each week. **This is my bet for A.** |
| A | A small-apartment renter moves and checks whether a bed or desk leaves usable walking space. | About **12% of Americans moved in 2024**, or roughly 40 million people. That is an upper bound on the relevant pool, not furniture-planning demand. [Census](https://www.census.gov/topics/population/migration/guidance/acs-1yr.html) | Large pool, weak frequency per person. |
| **B: Bench Coach** | A regular cyclist has a slipped chain, rubbing brake, or flat before the next ride and wants guidance while both hands are on the bike. | **112 million** Americans rode at least once in 2024, but the self-repairing subset is unmeasured. If 5–15% do their own basic maintenance, that suggests **6–17 million**—a scenario, not survey data. [PeopleForBikes](https://www.peopleforbikes.org/news/bicycling-participation-report-2024) | Several distinct maintenance jobs can bring a rider back. **This is my bet for B.** |
| B | An apartment maintenance worker encounters an unfamiliar fixture during a workday. | About **1.5 million** general maintenance and repair workers; apartment workers are a subset. [BLS](https://www.bls.gov/news.release/archives/ocwage_04022025.htm) | Frequent need, but covering varied fixtures requires a large, reliable guide library. |
| B | A new bike-shop or community-workshop mechanic needs a reminder at the bench. | About **12,600** employed bicycle repairers in 2024, before narrowing to novices. [BLS](https://www.bls.gov/news.release/archives/ocwage_04022025.pdf) | Frequent tasks, small audience; experienced mechanics may stop needing it. |

For **A**, I would make the question “Can this person get around *this* furniture arrangement?” rather than “Does this sofa look good here?” [IKEA Kreativ](https://www.ikea.com/ca/en/customer-service/knowledge/articles/6bg5c072-42g8-4d88-g2d9-bc8c2e86e681.html) already places furniture at scale, while [magicplan](https://help.magicplan.app/measure-the-distance-between-objects-and-walls/other-objects) measures gaps in a floor plan. Fit Check differs if it helps someone assess a usable route and turning area from their viewpoint. That would need validation with wheelchair users; a generic clearance circle is not proof that a particular person and chair can maneuver.

For **B**, I would choose **basic bicycle maintenance**, rather than a general repair library. [iFixit](https://www.ifixit.com/Device/Bicycle) already has bike repair guides, [BILT](https://biltapp.com/wp-content/uploads/2023/03/BILT_Media_Kit_2023_v3_digital.pdf) has interactive 3D instructions on phones, and [Microsoft Dynamics 365 Guides](https://learn.microsoft.com/en-us/dynamics365/mixed-reality/guides/index) has placed holographic work instructions on a headset. Bench Coach differs only if the next action is understandable *at the part being handled*, with less looking away and fewer interrupted hands.

## 2. What would the judges see?

These are my likely-read assessments against the four stated criteria, not predictions about the two judges personally.

| Criterion | A: accessibility-focused Fit Check | B: bicycle Bench Coach |
|---|---|---|
| **Design** | Strong if one placement leads to a clear “route blocked → move sofa → route usable” decision. | Strong if one repair has a beginning, a meaningful correction, and a finished check. |
| **Technical Implementation** | True-scale placement, movement, and a changing clearance visualization are demonstrable in preview. Accuracy in a real room is not. | Anchored 3D guidance, pinch interaction, and a simulated part-state change are demonstrable. Real-object recognition is not. |
| **Innovation** | Stronger of the two when focused on wheelchair maneuvering; generic furniture placement is familiar. | Weaker by default: repair guides and headset work instructions exist, and it resembles the cited past-winner pattern. A highly specific spatial teaching moment helps. |
| **Presentation** | A red-to-clear route can read instantly on video, provided the viewer understands the simulated room. | A visible mistake and correction at a bike part can tell a complete story in under three minutes. |

**A’s single spatial moment:** Place a true-size sofa so it cuts across a wheelchair turning area. From a seated-height viewpoint, move around it, shift it, and watch the usable route become clear. The [U.S. Access Board’s 60-inch turning circle](https://www.access-board.gov/ada/guides/chapter-3-clear-floor-or-ground-space-and-turning-space/) is a useful visual reference, but it does not replace testing with an individual’s chair. A phone can place the sofa too; glasses improve this moment by letting the user inspect the route at room scale without holding up a screen while moving.

**B’s single spatial moment:** At a bike’s rear wheel, show a misplaced chain and a restrained, anchored path beside the gears. The user looks around the wheel, pinches to reseat a *simulated* chain, and sees the guide respond with the next check. In the real task, a phone occupies a hand or pulls the rider’s gaze away just when both hands are dirty and working around the wheel. Keep the cue near the part and brief enough for the stated SPECS field of view.

## 3. The skeptic’s test

**A needs a simulated room and floor, a virtual sofa, and a simulated route.** The preview cannot prove room scanning or real-world measurement accuracy. Its biggest “tech demo” failure is a lovely furniture model plus a floating measurement graphic that never changes a decision. There is also an accessibility credibility risk if walking with WASD is presented as equivalent to maneuvering a wheelchair.

**B needs a virtual bike or wheel, a manually selected or hard-coded “found it” result, and pinch in place of the physical repair.** The preview cannot show live recognition of someone’s bike or verify that they completed a real step. Its biggest “slideshow” failure is clicking through text cards while a bike model sits nearby. The model must visibly participate in the problem, correction, and check. The harder product question is whether accurate guidance across enough bike models and repairs can be maintained; a good phone guide may win whenever the spatial cue adds little.

**Verdict:** I would build **Bench Coach for cyclists learning to maintain their own bikes**. It has the better chance of being wanted by more people *and* used again, while a single bike repair can make its hands-free advantage legible in preview. I would keep the submission tightly focused on one repair and one visible correction; a broad “AR repair manual” would lose the innovation case.

**What would change my mind:** a wheelchair-user-validated Fit Check trial in which the spatial clearance view changes a real furniture decision and the same decision is convincing in Lens Studio preview. That would give A a more distinctive, consequential experience than the repair-guide pattern.


## Round 2: Rebuttals


---
## ● Claude-cli REBUTTAL - default
# Critical review of the round-1 answers

Both answers recommend the same thing: **Bench Coach, aimed at home cyclists**. Two models agreeing is weak evidence, because we share priors and read the same prompt. So I focus below on where the answers differ and what both missed.

## 1. Strengths

**Codex**
- **Better evidence habits.** It cites sources for each size estimate, separates the measured pool (112M riders) from its own guess (5–15% self-repair), and labels its scenarios as scenarios. My answer just said "tens of millions" with no basis.
- **A better bet within Fit Check.** It picks occupational therapists. That is the only Fit Check audience with weekly use, which is exactly the "would they use it twice" test.
- **Sharper accessibility risks.** It warns that WASD walking is not wheelchair maneuvering, and that a generic 60-inch circle doesn't prove that *this* person and *this* chair can turn. Both points are more precise than my "risks being patronizing."
- **Honest about A's phone argument.** It admits a phone can place the sofa too, and claims only a modest advantage for glasses.

**Mine (Claude-CLI)**
- **More concrete differentiators.** Ghost tools at true scale, markers on the far side of the wheel that make you walk around, and steps where you place a part. Each turns walking and grabbing into the content, which directly counters the slideshow risk.
- **Matches the brief's limits.** It ties the bike-on-a-stand distance to the 0.6–1.6 m, below-eye-level sweet spot.
- **Names the field the judges will see.** It points out that the skill pack's own example is a cooking coach, so step-coach entries will likely be the most common pattern.
- **Gives a checkable next step:** look at the Discord before committing.

## 2. Weaknesses and blind spots

**Codex**
- **Unverified citations.** Some links look off, such as a BLS article dated 2026 and a Census "guidance" page cited for a 12% mover rate. Neither of us checked them. Cited-but-wrong is worse than clearly labeled estimates, because it looks verified.
- **A hard demo moment.** Reseating a slipped chain means modeling a chain wrapping around a cog, which is a poor fit for "simple physics" and for what CLAD can reliably build in one pass.
- **Thin on "how to differ."** It says the cue must sit at the part, but offers little beyond that.

**Mine**
- **My Fit Check bet was the wrong pick.** I chose the doorway pivot, which has three problems:
  - Tilting a sofa through a frame naturally wants a two-hand rotation, which the brief says the preview cannot show.
  - It needs a custom hallway and door, and whether the preview room can be changed is not verified.
  - "Existing apps don't really solve it" was an unverified claim.
- **"Fix a flat" is too big and too squishy.** It means wheel removal, levers, tube, tire bead, and inflation, much of it deformable. That is hard to build and hard to fit, together with planning docs and agent footage, into a video under 3 minutes.
- **Overstated claims.** "Basically the default Lens Studio demo" was asserted without evidence.

## 3. What both of us missed

1. **The additive display hides black objects.** On SPECS, black renders as transparent, and tires, chains, and grease are black. On real glasses the bike is real, so this doesn't matter. But in the preview the bike is a virtual stand-in, and if the preview simulates the additive display, the main object could vanish.
   - Fix: check this early, and if needed render the stand-in bike in mid-grey with bright overlays.
2. **Repeat use comes from new repairs, not the same one.** Once you have fixed a flat with a coach, you may not need the coach again. The use-twice case is a ladder of skills: flat, then brake pads, then chain. This also fits the hackathon's "Learn" framing, where the product proudly graduates you. Codex hinted at this only for mechanics.
3. **The demo step should use rigid parts.** The video's key interaction should involve solid pieces, such as a tire lever hooking a rim, a quick-release wheel coming out, or a brake pad lining up with the rim. Avoid chains and rubber.
4. **"Past SPECS winners" cuts both ways.** Those were other events, likely with Snap judges. This round's two Devpost judges may reward the familiar pattern or mark it down on "differs from existing concepts." Neither of us checked who judged those events.
5. **"Complete product" needs a start and an end.** The Design criterion asks for a coherent experience. That means the video should show a beginning (pick the repair, then "found it" on the bike) and an end (a completion check and the next skill). Without them, even a good spatial moment reads as a fragment.

## 4. What I would change

- **Keep the verdict:** Bench Coach for home cyclists.
- **Change the demo:** build the video around one rigid, spatially spread-out step instead of a full flat repair. My pick would be the tire lever at the valve, then walking around the stand to a marker on the back of the wheel. Show the full flow quickly before and after it.
- **Change the Fit Check bet** from doorway pivot to **OTs doing home assessments**, adopting Codex's reasoning.
- **Add two risks to verify** before building: whether black objects vanish in the preview, and whether CLAD can build the needed parts in one pass.
- **Treat every market number from both answers as unverified**, including Codex's cited ones, until someone opens the sources.
- **Strengthen the mind-changer:** if the Discord or project gallery already shows several step-coach entries, Fit Check for OTs, validated with a real OT on camera, becomes the better bet with these judges.


---
## ● Codex REBUTTAL - gpt-6-sol
## 1. Strengths of each response

**My response** kept the two decisions separate: how many people might return to the product, and what a judge could understand from a preview video. It gave Fit Check a credible repeat user in occupational therapists and treated wheelchair clearance as a personal usability question, not a universal measurement. It also identified Bench Coach’s central test: the bike model must change as the user acts, or the experience becomes a slideshow.

**Claude CLI’s response** made the choice easier to picture. Its doorway pivot is a distinctive Fit Check moment, and its bike repair scenario has a clear reason to keep both hands free. It also called out a practical risk my answer underplayed: furniture placement in a simulated room could look like a generic 3D editor.

## 2. Weaknesses and blind spots

**My response** gave audience figures more apparent precision than the evidence supports. Total cyclists, wheelchair users, and occupational therapists are not counts of people who need or would adopt these products. The assumed 5–15% of cyclists doing their own maintenance was explicitly a scenario, but it still carried too much weight in the verdict. I also left “basic bicycle maintenance” too broad: a compelling single repair does not establish a useful guide across repairs.

**Claude CLI’s response** made several plausible judgments sound settled. “A would mostly not be used twice” overlooks professionals assessing new rooms regularly. “The fake room undercuts Fit Check” is fair, but Bench Coach has the same simulation problem: its bike, repair, and confirmation are virtual. The claims about what each judge personally rewards are speculation based on their roles. Its doorway pivot is visually strong, but credible collision guidance depends on accurate doorway and furniture geometry that the preview cannot demonstrate. “Every step should involve your body” could also turn a useful guide into needless interaction.

Both responses should distinguish **a successful preview demonstration** from **evidence that the real product works**. A virtual “route clear” state cannot certify wheelchair access; a virtual completed repair cannot certify that a real bike is fixed.

## 3. What the responses missed

The main missing question is whether users would choose *glasses* for the task even if the Lens worked. A cyclist with a phone on a stand may already have an adequate solution. A person planning furniture might prefer a phone because it is readily available. The relevant audience is therefore much smaller than the broad population figures in either answer.

Neither response fully tests the hardest part of Bench Coach’s differentiation: keeping guidance aligned with the **correct part of a varied real object**. The preview permits a hard-coded “found it” step, so an impressive on-bike overlay would still leave that product risk open. For Fit Check, the corresponding unresolved risk is obtaining trustworthy room and object dimensions. These are the questions to validate with users; neither should be hidden behind polished animation.

## 4. What I would change

I would **keep Bench Coach for cyclists as the provisional recommendation**, but state it with less confidence. I would choose one common, repeatable repair for the submission, then test whether the spatial cue actually resolves a point of confusion better than a propped-up phone guide. A flat is a reasonable candidate, not yet a proven best choice.

I would also give Fit Check more credit **if aimed at occupational therapists or home-accessibility specialists**, whose repeated assessments answer the “use it twice” question better than a one-time furniture shopper. Its wheelchair-focused version may be more original to the judges, but it needs input from wheelchair users and must present its clearance result as a planning aid rather than a safety verdict.

The evidence most likely to reverse my choice is a small comparison with target users: if an accessibility specialist makes a better furniture decision using Fit Check’s spatial view, while cyclists find Bench Coach no easier than their existing phone guide, I would switch to Fit Check.



---
## Synthesis
