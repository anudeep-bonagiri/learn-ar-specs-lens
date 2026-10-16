# What wins on SPECS: past events, winners, and idea strategy

Compiled 2026-10-16. Most winner write-ups were reachable only through search summaries.
Official judges' reasons were almost never published, so the "why it won" notes are inferences from each event's criteria.

## Has this been run before?

**Devpost Learn** is a new monthly series. This is its first SPECS event.

| Event | Dates | Prizes | Status |
|---|---|---|---|
| Learning Hackathon: Spec Driven Development | Mar 31 – Apr 29, 2026 | None, completion badge only | Ended |
| Build With AI: Basics | Ends Oct 26, 2026 | $1,250 / $750 / $500 | Winners around Nov 4, 2026 |
| **Learn AR with SPECS** (this one) | Oct 15 – Nov 9, 2026 | $1,250 / $750 / $500 | Open |

The Build With AI: Basics winners land about five days before our deadline.
Check them for how Devpost Learn judges score planning docs and videos.

**Snap** runs SPECS hackathons constantly:

- Lens Fest Lensathon (a 25-hour hackathon, Oct 2025)
- Specs in the City NYC (May 2025) and Paris (Nov 2025)
- MIT Reality Hack Spectacles tracks (2025 and 2026)
- Monthly Spectacles Community Challenges with Lenslist, paying more than $20k a month
- Care XR, the 3EALITY hackathon, and AWE events

## Past winners

| Project | Event | What it does | Likely why it won |
|---|---|---|---|
| **Decisionator** | Lens Fest Lensathon 2025, 1st | Point at two objects; object detection and AI choose for you | A one-gesture, instantly understood use of the world plus AI |
| **CartDB** | Lens Fest Lensathon 2025, 2nd | Scan a barcode and see nutrition info in place | Everyday utility in a real moment with your hands full |
| **Fireside Tales** | Lens Fest Lensathon 2025, 3rd | Collaborative storytelling with GenAI | Social and emotional, with generative content |
| **Card Master** | Best Spectacles Lens, Lens Fest Awards 2025; Community Challenges #1 and #2 | Teaches card games step by step and lets you play AI opponents | Complete and polished, and kept improving over updates |
| **Footprints** | MIT Reality Hack 2025, Snap track | Leave AR trails and messages anchored in places for others | Ties content to real places, with a clear human story |
| **Noodle** | MIT Reality Hack 2026, Best Spatial AI | Node-based GenAI workbench that turns your room into a canvas | Novel interaction model, and it uses the space |
| **Proximity Pulse** | Snap hackathon, 1st Spectacles | CPR training with learn, practice and quiz modes | Clear social good, and hands-free guidance on glasses |
| **SnapSign** | Snap hackathon, 2nd | Two-way sign language and English translation | Accessibility with a strong "why glasses" argument |
| **Vestibular Eye** | Snap hackathon, 3rd | Balance rehab game steered by gaze and head tilt | Health use, gamified, and uses the body |
| **HoloATC** | Community Challenge #4, 1st | Live 3D air traffic for 40 airports on your table | Makes invisible data spatial and tangible |
| **Wi-Fi Speed** | Community Challenge #13 | Measures and visualizes Wi-Fi speed around your room | Makes the invisible visible, where it actually is |
| **Trajectory** | Community Challenge #2, 1st | Story-driven spatial game in your room | Story plus spatial gameplay |
| **AI Teleport** | Community Challenge #6, 1st | Transforms your surroundings into other eras | A big "wow" moment |
| **ASYM** | Community Challenge #11, 1st | Two-player asymmetric tower defense | Fresh game design |
| **ARcade Racer** | Community Challenge #3, 1st Open Source | Drive a real RC car through an AR course | Fuses a physical object with virtual play |

## Patterns in what wins

1. **One moment, explained in one sentence.** For example: "Point at two things and it picks." Or: "Follow someone's footprints."
2. **It needs glasses.** Hands are busy, eyes should stay up, or content belongs on a real place or object.
3. **It makes the invisible visible in place.** Examples: air traffic, Wi-Fi, trails, nutrition.
4. **Health, accessibility and training recur.** Look at CPR, sign language, vestibular rehab and Care XR.
5. **It feels finished.** Card Master won over and over by being complete and polished, not by being clever.
6. **Standard interactions are done well.** Pinch, grab and drag, with big targets and content about 1 m away.

## The catch for this hackathon

Many past winners rely on live camera vision, object recognition, AI, voice, shared multi-user use, or real GPS places.
**The Lens Studio preview can't show those, or needs a stand-in.** Judging happens on a preview video.

| Works in preview | Needs a stand-in | Can't be shown |
|---|---|---|
| Walking around, room-scale objects, mouse interactions, spatial sound, physics, animation, models, text | Recognizing real things, real places and routes, AI and voice | Custom or two-hand gestures, hand pose, live camera vision, memory across sessions, multi-person |

So the winning move here is to **take the winners' patterns and pick a version whose core moment works in preview**.
Use stand-ins only for the secondary pieces.

## How to land each judging criterion

- **Design:** Ship one complete loop with a start, a core moment and an end state. Avoid a tech demo of a feature.
  Follow the brief's placement rules: about 1 m away, slightly below eye level, inside the view, no dark UI (black renders transparent).
- **Technical implementation:** Show that CLAD and the Lens Studio MCP did the build. Have LEAF tests pass for every done criterion.
  Report the test results in the README.
- **Innovation:** Avoid the obvious picks, such as a basic recipe assistant, a generic AI chatbot panel, or a plain shooting game.
  Twist a known pattern toward a specific audience.
- **Presentation:** In the first 15 seconds, state the problem, who it's for, and why glasses.
  Then show the full loop in preview. End with "logic proven" and "feel unproven" labels.

## Preview-friendly idea directions

Each idea borrows a winning pattern and keeps its core moment inside what the preview can show.

1. **SunSpot (make the invisible visible).** Scrub a slider and watch where sunlight will fall across your room through the day and year.
   It helps you place plants, a desk, or solar panels. The sun path is pure math. The window can be a simple stand-in, and the moment works fully in preview.
2. **Bench Coach (hands-busy training).** A step-by-step assembly or repair guide anchored next to a stand-in object, such as a bike wheel or flat-pack shelf.
   Big next and back buttons, a ghost animation of each step, and a done-check finish the loop. It follows the Proximity Pulse and Card Master patterns.
3. **Quiet Room (calm and accessibility).** A spatial breathing and sensory-reset space for overwhelmed moments.
   Sound-led objects drift at arm's length and respond to slow pinches. It is health-adjacent, uses spatial sound, and works in preview.
4. **Table Physics Lab (education).** Drag ramps, balls and springs onto a table and predict where the ball lands before releasing it.
   Physics works in preview, and the predict-then-check loop is a complete experience for students.
5. **Fit Check (spatial planning).** Drop true-scale furniture or a TV at real centimeter size into your room, walk around it, and check clearances.
   Room scale and walking around both work in preview. Sharpen it with a specific audience, such as renters or wheelchair users checking turning space.

**Strongest pick: SunSpot.** It is novel and the moment is instantly understood.
It needs no stand-in for its core, and it clearly belongs on glasses because the answer is about your actual space.

## Sources

- https://learn-specs.devpost.com/
- https://learn-ai.devpost.com/
- https://learn-ai-basics.devpost.com/rules
- https://ar.snap.com/lensfest-2025
- https://blog.lenslist.co/2025/11/06/lens-fest-2025-awards-lensathon-recap-%F0%9F%8F%86/
- https://voicesofvr.com/1676-1st-place-spectacles-lensathon-team-decisionator-object-detection-ai-decision-maker/
- https://voicesofvr.com/1675-2nd-place-spectacles-lensathon-team-cartdb-barcode-scanning-nutrition-app/
- https://developers.snap.com/spectacles/spectacles-community/hackathon-showcase
- https://developers.snap.com/spectacles/spectacles-community/community-challenge
- https://www.realityhackatmit.com/2025-tracks-prizes
- https://www.realityhackatmit.com/2026-tracks-prizes
- https://github.com/ColeKaplan/Footprints
- https://github.com/rbkavin/noodle_creative_collab
- https://developers.snap.com/spectacles/best-practices/design-for-spectacles/design-best-practices
- https://developers.snap.com/spectacles/best-practices/design-for-spectacles/positioning-sizing-content
