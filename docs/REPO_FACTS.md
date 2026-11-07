# Repo facts

Written by scripts/collect_facts.py at 2026-11-07T23:16:51+00:00. Nothing in it is typed by hand; every value is the output of the command beside it.

| Fact | Value | Command |
| --- | --- | --- |
| commits | 124 | `git rev-list --count HEAD` |
| first commit | 2026-10-16T00:31:31Z | `git log --reverse --format=%cI / head -1` |
| last commit | 2026-11-07T16:31:24-06:00 | `git log -1 --format=%cI` |
| authors | 4 | `git shortlog -sn --no-merges HEAD / wc -l / tr -d ' '` |
| tracked files | 467 | `git ls-files / wc -l / tr -d ' '` |
| remote | https://github.com/anudeep-bonagiri/learn-ar-specs-lens.git | `git remote get-url origin` |
| lines of .glsl | 73551 | `git ls-files '*.glsl' / xargs wc -l` |
| lines of .metal | 54465 | `git ls-files '*.metal' / xargs wc -l` |
| lines of .mesh | 39373 | `git ls-files '*.mesh' / xargs wc -l` |
| lines of .pvr | 37270 | `git ls-files '*.pvr' / xargs wc -l` |
| lines of .ts | 17769 | `git ls-files '*.ts' / xargs wc -l` |
| lines of .lspkg | 13645 | `git ls-files '*.lspkg' / xargs wc -l` |
| LEAF scenarios registered | 24 | `grep -c "typename:" Assets/BenchCoach/Tests/LeafIndex.ts` |
| LEAF criterion scenarios (without the jump-to-step helper) | 23 | `grep "id:" Assets/BenchCoach/Tests/LeafIndex.ts / grep -vc jump-to-step` |
| Lens script files (own TypeScript) | 50 | `ls Assets/BenchCoach/Scripts/*.ts / wc -l / tr -d ' '` |
| lines of own Lens TypeScript | 13830 | `cat Assets/BenchCoach/Scripts/*.ts / wc -l / tr -d ' '` |
| lines of LEAF test TypeScript | 3881 | `cat Assets/BenchCoach/Tests/*.ts / wc -l / tr -d ' '` |
| repair steps with a spoken line | 10 | `grep -c '"id": "step-' Assets/BenchCoach/Voice/voice-lines.json` |
| mistake kinds with a spoken reason | 7 | `grep -c '"id": "mistake-' Assets/BenchCoach/Voice/voice-lines.json` |
| voice lines | 30 | `grep -c '"id":' Assets/BenchCoach/Voice/voice-lines.json` |
| voice clips | 30 | `ls Assets/BenchCoach/Voice/*.mp3 / wc -l / tr -d ' '` |
| sound cue files | 9 | `ls Assets/GeneratedSFX/*.wav / wc -l / tr -d ' '` |
| build passes written up in the design notes | 36 | `grep -c "^## 20" devpost/design-notes.md` |
| lines of design notes | 2428 | `wc -l < devpost/design-notes.md / tr -d ' '` |
| garage preview room size in MB | 23 | `du -sm preview-room/Garage / cut -f1` |
| build sessions on this machine (build log) | 22 | `grep "^/ build sessions" devpost/build-log.md / awk -F'/' '{print $3}' / tr -d ' '` |
| Lens Studio MCP calls in those sessions (build log) | 3406 | `grep "^/ Lens Studio MCP calls" devpost/build-log.md / awk -F'/' '{print $3}' / tr -d ' '` |
| LEAF scenario runs through the MCP (build log) | 1005 | `grep "^/ LEAF scenario runs" devpost/build-log.md / awk -F'/' '{print $3}' / tr -d ' '` |
