# Judges and how to tune for them

Compiled 2026-10-16 from the Devpost page and public professional sources.
LinkedIn itself couldn't be loaded from this environment, so profile details come from search snippets, Codecademy, CreateHER Fest and Devpost pages.
The "likely values" notes are inferences from public roles and work, not statements either judge has made.

## The panel

Both judges work at Devpost. **No Snap judge is listed.**

### Joe Holmes, AI Learning Hackathon Architect, Devpost

**Background:**
- Designs the Devpost Learn series and its skill packs. His LinkedIn headline describes simplifying complex AI topics into accessible educational resources.
- Was previously a Curriculum Developer in AI/ML at Codecademy. He is credited on "Intro to AI Agents" and "Learn How to Build AI Agents."
- His Codecademy bio describes him as a self-taught developer and machine learning engineer.
- He has also worked as a test-prep instructor, led an afterschool mentoring program, and freelanced as a journalist.
- His personal site, joeholmes.dev, covers AI, learning and civic tech.
- He ran the Build With AI: Basics process live and judged that event.

**What his skill packs reveal about his values.** These come from his team's sister skill pack, learn-ai-basics:
- **Learner-led by design.** The submission skill helps you prepare the video and repo, but says it **won't draft or rewrite your text**. You write the project name, description and submission fields yourself.
- **Plan first, then build in verified, committed steps,** with hands-on review and a short learning wrap-up.
- **Proof-of-concept sized.** "Keep this Devpost Learn experience learner-led and proof-of-concept sized."
- **Reflection connects a real moment from your build to a reusable practice.**
- **Hygiene:** check files and git history for secrets and private context before publishing.

**Likely values:**
- Evidence that you learned the method, not just that a Lens exists.
- A tight scope, an honest plan, tests and iteration.
- Clear explanation. He comes from teaching, curriculum work and journalism, so a well-told "why" matters.
- Civic and learning angles, given the topics on his personal site.

### Darlyze Calixte, Developer Marketing Manager, Devpost

**Background:**
- Joined Devpost as Developer Marketing Manager in 2026.
- Co-founder and Technical Director of CreateHER Fest, a launchpad for women in tech across more than 80 countries.
- CreateHER Fest runs "Hack for Social Good" hackathons with AI, blockchain and AR/VR tracks.
- Has judged:
  - CreateHER Fest: Hack for Social Good
  - #75HER Challenge 2026, where judges reviewed **commit history and README**
  - DIALED IN Builder Challenge ("Communication, reimagined!")
  - Build With AI: Basics
- Hosted a Devpost livestream with Arize AI on tracing agents through the Phoenix MCP. That puts agent tooling and observability in her wheelhouse.
- Listed as a speaker at the Blockchain Futurist Conference 2026. Studied at Kenzie Academy, a coding bootcamp.

**Likely values:**
- Social good and real-world impact, told as a human story.
- Accessible, inclusive framing that welcomes newcomers.
- A shareable project that makes a good newsletter feature or social post, since winners get exactly that.
- **Commit history and README quality.** She judged an event that explicitly reviewed both.
- Visible agent tooling. Her Arize livestream was about instrumenting agents through an MCP, so showing CLAD working through the Lens Studio MCP speaks her language.
- **Communication as a theme.** She judged DIALED IN, a "Communication, reimagined" challenge, and Walk the Talk is a communication tool.

## What this changes

1. **The Devpost Learn lens now matters most.** The council weighted Snap's consumer goals heavily. With a Devpost-only panel, process, learning, story and shareability lead.
2. **Walk the Talk still fits best.** It is a communication tool with a human, inclusive story, which suits Darlyze. It has a clean, testable, one-moment scope, which suits Joe.
   Call the Shot stays the backup. It is strong on process, but it's the weakest story for a marketing judge.
3. **Your own voice is a scoring factor.** The format is learner-led and its submission skill refuses to write your text.
   Write the README, Devpost description and reflection **in your own words**. Use the repo templates as scaffolding only.
4. **Commit history is judged.** Build in small, honest, dated commits during the submission window. Avoid one giant final commit.

## Important: research docs in the public repo

This repo's `docs/` folder holds AI-assisted research: winner analysis, idea scorecards and a council debate.
For a learner-led format, a public repo full of pre-planned AI strategy could undercut the story that *you* led the `plan-lens` interview.

**Recommendation:** before you make the repo public, move `docs/` (except `HACKATHON.md` and `SUBMISSION_CHECKLIST.md`) to a private repo or branch.
Keep the public repo to these:
- your Lens Studio project
- `devpost/`, with the brief and design notes the skill pack writes
- a README you wrote yourself

Go into `plan-lens` with your thinking prepared, but answer its questions in your own words.

## Tuning checklist

- [ ] **Open with the person.** Name the dreaded speaking moment and who it's for in the first 10 seconds.
- [ ] **Add an inclusive audience line.** For example: students giving a first presentation, people practicing in a second language, anyone with speaking anxiety. Claim only what the Lens does.
- [ ] **Frame it as communication, reimagined.** Hands empty, eyes on your audience, notes that fade.
- [ ] **Make process the second act.** Show the approved brief, CLAD building through the Lens Studio MCP, the LEAF tests going green, and one design-notes iteration with its reason.
- [ ] **Keep it to one moment.** That is run 3 with no notes and one recovered stall. Cut extras before cutting polish.
- [ ] **Write the README in your words, as a case study.** Cover the problem, the audience, the moment, the done criteria with test status, logic-proven vs. feel-unproven, what changed and why, and next steps.
- [ ] **Keep commit history clean.** Make small dated commits, with no secrets and no private context.
- [ ] **Make shareable assets.** A 10-second run-3 clip and one end-card still ("0 peeks · no notes").
- [ ] **Use honest labels as a strength.** Voice is a button stand-in in preview, and the feel on glasses is unproven.
- [ ] **Write a short reflection on one real build moment.** Connect it to a practice you'd reuse. That's the habit Joe's skill packs teach.

## Read their taste directly

- **Build With AI: Basics** had both of these judges. Its winners land around Nov 4. Study the top three READMEs and videos before your final recording.
- **The Nov 5 Live Project Review** assesses work in progress against the criteria. Bring the run-3 loop and ask: "What would make this stronger on Design?"
- **Ask in #specs-general** how judges weigh consumer use against craft. Do it before Nov 1, while there's still time to switch to Call the Shot.

## Sources
- Judges: https://learn-specs.devpost.com/
- Build With AI: Basics, judged by both: https://learn-ai-basics.devpost.com/
- Learn AI Basics skill pack: https://github.com/challengepost/learn-ai-basics
- Joe Holmes, LinkedIn: https://www.linkedin.com/in/joe-holmes-ai-ml/
- Joe Holmes, Codecademy: https://www.codecademy.com/pages/joe-holmes
- Intro to AI Agents course: https://www.codecademy.com/learn/intro-to-ai-agents
- Joe Holmes, personal site: https://joeholmes.dev/
- Darlyze Calixte, LinkedIn: https://www.linkedin.com/in/darveloper/
- CreateHER Fest about page: https://www.createherfest.com/about
- CreateHER Fest newsletter on her Devpost role: https://newsletter.createherfest.com/p/okay-so-hire-me-then-if-i-m-so-qualified
- CreateHER Fest: Hack for Social Good: https://createherfest.devpost.com/
- #75HER Challenge 2026: https://75her-challenge.devpost.com/
- DIALED IN Builder Challenge: https://dialedin.devpost.com/
- Arize Phoenix MCP livestream: https://www.youtube.com/watch?v=QAe6MTunRwE
