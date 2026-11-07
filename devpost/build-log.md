# Build log

Written by `tools/build-log.py` at 2026-11-07T22:29:25+00:00 from the Claude Code session transcripts on one machine. Nothing in it is typed by hand. Sessions run on teammates' machines are not in it.

| Fact | Value |
| --- | --- |
| build sessions | 22 |
| first session | 2026-10-18 |
| last session | 2026-11-07 |
| assistant turns | 11430 |
| tool calls, all tools | 6519 |
| Lens Studio MCP calls | 3406 |
| LEAF scenario runs through the MCP | 1005 |
| TypeScript recompiles through the MCP | 135 |
| preview captures through the MCP | 373 |

## Lens Studio MCP calls by tool

| Tool | Calls |
| --- | --- |
| `run_leaf_scenario` | 1005 |
| `ExecuteEditorCode` | 698 |
| `MovePreviewCamera` | 500 |
| `CapturePanelScreenshotTool` | 373 |
| `PreviewPanelTool` | 163 |
| `RecompileTypeScriptTool` | 135 |
| `InjectPreviewGesture` | 134 |
| `QueryRuntimeSceneTool` | 129 |
| `PreviewInteractTool` | 88 |
| `RunAndCollectLogsTool` | 64 |
| `asset-graphql` | 31 |
| `scene-graphql` | 20 |
| `open_leaf_panel` | 16 |
| `list_leaf_scenarios` | 13 |
| `ListAllPanels` | 8 |
| `GetBoundingBox` | 6 |
| `GenerateTexture` | 6 |
| `IconSelector` | 5 |
| `SearchLensStudioAssetLibrary` | 3 |
| `InstallLensStudioPackage` | 2 |
| `GenerateFast3DAssets` | 2 |
| `QueryLensStudioKnowledgeBase` | 2 |
| `CaptureRuntimeViewTool` | 2 |
| `VirtualScene` | 1 |

## Sessions

| Date | Session | Assistant turns | MCP calls |
| --- | --- | --- | --- |
| 2026-10-18 | Read the agent brief and walk me through Section  | 161 | 1 |
| 2026-10-26 | You are the build agent for Bench Coach, a SPECS | 444 | 160 |
| 2026-10-26 | You are the build agent for Bench Coach, a SPECS | 487 | 147 |
| 2026-10-29 | Pass Q | 647 | 208 |
| 2026-10-29 | Pass F | 818 | 236 |
| 2026-10-29 | Pass D2 | 1219 | 519 |
| 2026-11-05 | Call the lens-studio ListAllPanels tool once and | 3 | 1 |
| 2026-11-05 | Probe only | 97 | 13 |
| 2026-11-05 | Pass M | 745 | 207 |
| 2026-11-05 | Pass H | 643 | 232 |
| 2026-11-05 | Pass V | 836 | 237 |
| 2026-11-05 | Pass R | 364 | 49 |
| 2026-11-06 | Pass R2 | 953 | 219 |
| 2026-11-06 | Pass P | 1162 | 287 |
| 2026-11-06 | Pass P, last part | 40 | 6 |
| 2026-11-06 | Pass P, last part | 425 | 172 |
| 2026-11-06 | Pickup takes after pass P. You are the recording | 306 | 54 |
| 2026-11-07 | Pass S1 | 469 | 161 |
| 2026-11-07 | Pass S2 | 345 | 125 |
| 2026-11-07 | Pass R5 | 598 | 130 |
| 2026-11-07 | Pass R5c | 143 | 25 |
| 2026-11-07 | Pass A | 525 | 217 |

Regenerate: `tools/build-log.py ~/.claude/projects/<project transcript folders>`.
