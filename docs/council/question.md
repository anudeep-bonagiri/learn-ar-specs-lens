<!-- Council input question (Round 1). Round 2 results are summarized in ../COUNCIL_DEBATE.md -->
QUESTION: From the sponsoring companies' standpoint (Snap and Devpost), what Lens idea should win "Learn AR with SPECS", and how should the current candidate ideas be improved, replaced, or combined? Ignore the builder's personal background entirely.

CONTEXT
- Contest: Devpost Learn "Learn AR with SPECS". Oct 15 to Nov 9 2026. Prizes $1,250 / $750 / $500. Winners Nov 19. Live project review Nov 5.
- Process: the Devpost skill pack "plan-lens" interviews the builder and writes devpost/design-brief.md. Snap's CLAD agents then build the Lens in Lens Studio through the Lens Studio MCP. The build uses the Spectacles Interaction Kit and UI Kit, plus LEAF tests for each done criterion. The demo is a video under 3 minutes recorded in the Lens Studio preview. No glasses are required.
- Judging: Design (complete, coherent product experience, not a tech demo); Technical Implementation (incl. use of CLAD, Lens Studio, Lens Studio MCP); Innovation/Idea; Presentation (video shows it working end to end; pitch explains problem, audience, why it matters).
- Concept video design ideas judges look for: AR that SHARES YOUR VIEW, DRAWS IN THE WORLD, and LEAVES YOUR BODY FREE. Good AR uses one; great AR combines them. Test: does a phone do it just as well?
- Design habits: put information on the thing it's about; show it only when needed; few big targets; keep content where the user already looks. View is about 37x32 degrees. The focus plane is 1 m, so content goes 0.6 to 1.6 m away, slightly below eye level. The display is additive, so black is transparent.
- PREVIEW LIMITS. The preview is a simulated room with a virtual table, driven by WASD/QE/mouse, where a click is a pinch.
  - Works in preview: walking around, real-scale objects, SIK pinch/grab/drag/throw, sliders, panels, spatial sound, physics, animation, text, 3D models.
  - Needs a stand-in: recognizing real things (use a "found it" pinch or a hard-coded result), real surfaces (use a virtual table), routes (use markers), AI (may work in the editor, but needs a hard-coded fallback), voice (pair it with a button), and outside data (hard-code it).
  - Can't be shown: two-hand or custom gestures, live camera vision, persistence or anchors across sessions, multi-person Connected Lenses, and feel factors.
  - One spatial moment done well is a complete project.
- The skill pack's own worked example is a risotto cooking coach, so many entrants will do cooking.
- Snap context: consumer Specs cost $2,195 and ship fall 2026. Snap OS 2.0 adds a browser, a Spotlight video Lens, a Gallery Lens, and AI Lenses with Gemini and ChatGPT. There is also a Commerce Kit, plus Claude Code, Codex and Cursor integrations in Lens Studio. Snap needs consumer reasons to buy, and proof that agentic Lens development works.
- Past SPECS winners:
  - Decisionator: point at two objects and AI picks one.
  - CartDB: barcode nutrition.
  - Fireside Tales: GenAI storytelling.
  - Card Master: card-game tutor with AI opponents, repeat winner.
  - Footprints: AR trails in places.
  - Noodle: GenAI node canvas in your room.
  - Proximity Pulse: CPR trainer.
  - SnapSign: sign-language translation.
  - Vestibular Eye: balance rehab.
  - HoloATC: live air traffic on your table.
  - Wi-Fi Speed: Wi-Fi strength visualized around the room.
  - Trajectory: story game.
  - AI Teleport: transforms the room into other eras.
  - ARcade Racer: real RC car plus AR.
  - Community challenges weight user experience, completeness, polish and retention.
- CURRENT CANDIDATES:
  1. Loci. A memory palace: pinch spots in your room to place cards from a hard-coded deck, then switch to recall mode and walk the route. Orbs pulse, a pinch reveals the card, you mark got it or missed, and a chime plus an arrow cue the next station. Ends with a score card. Prior art: the MemoryVaultAR iPad app and VR palaces.
  2. Smoke Line. A home fire drill: mark your door and extinguisher, put out a small fire with the PASS steps via pinch and drag, then the fire grows and you get out. A light smoke layer drops from the ceiling, you crouch under it (Q key) and follow floor arrows to the door. Prior art: Kidde's phone AR fire drill.
  3. Land It. A physics lab: set a ramp angle, pinch-predict where a ball lands on the floor, drop it, compare arcs, then land it in a cup.
  - Rejected: cooking coach, sun-path visualizer (Sun Seeker exists on phones), furniture fit (phone apps exist), translator (needs camera), CPR (done), air drums (hand speed), shared games (multi-person), breathing room.

WHAT TO DELIVER, through your role's lens:
(a) What this sponsor or stakeholder most wants to see in a winning submission, in concrete, checkable terms.
(b) A verdict on each current candidate, and the single most important improvement for each.
(c) One to three NEW or substantially improved idea proposals, each in one bullet. Give the name, the one spatial moment, which of the three strengths it uses, why a phone can't do it, and what (if anything) needs a stand-in in preview.
Use your Key points bullets for (a) to (c); you may use up to 8 bullets for this question.
You may run a couple of web searches to check prior art for an idea you propose, but stay focused.
