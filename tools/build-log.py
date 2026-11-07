#!/usr/bin/env python3
"""Writes devpost/build-log.md from Claude Code session transcripts: how many sessions built the
Lens, and how many calls went through the Lens Studio MCP, by tool. Nothing is typed by hand.

usage: tools/build-log.py <transcripts dir> [<transcripts dir> ...] [--out devpost/build-log.md]

Each transcript is a .jsonl file; assistant messages carry tool_use blocks with the tool's name.
Lens Studio MCP tools are the ones named mcp__lens-studio__<Tool>. A session's label is the first
line of its first user prompt, cut at the first colon, so a pass brief like "Pass P: fix the flaws"
shows as "Pass P"."""
import argparse, collections, datetime, glob, json, os, sys

ap = argparse.ArgumentParser()
ap.add_argument("dirs", nargs="+")
ap.add_argument("--out", default="devpost/build-log.md")
a = ap.parse_args()

sessions = []
tools = collections.Counter()
for d in a.dirs:
    for f in sorted(glob.glob(os.path.join(os.path.expanduser(d), "*.jsonl"))):
        s = {"id": os.path.basename(f)[:8], "label": "", "first": None, "last": None, "assistant": 0, "tools": collections.Counter()}
        for line in open(f, errors="replace"):
            try:
                o = json.loads(line)
            except Exception:
                continue
            t = o.get("type")
            ts = o.get("timestamp")
            if ts and t in ("user", "assistant"):
                s["first"] = s["first"] or ts
                s["last"] = ts
            m = o.get("message")
            if t == "user" and not s["label"] and isinstance(m, dict):
                c = m.get("content")
                text = c if isinstance(c, str) else " ".join(x.get("text", "") for x in c if isinstance(x, dict)) if isinstance(c, list) else ""
                text = text.strip().splitlines()[0] if text.strip() else ""
                if text and not text.startswith("<"):
                    s["label"] = text.split(":")[0][:48]
            if t == "assistant" and isinstance(m, dict):
                s["assistant"] += 1
                for c in m.get("content") or []:
                    if isinstance(c, dict) and c.get("type") == "tool_use":
                        s["tools"][c.get("name") or "?"] += 1
        if s["assistant"] == 0:
            continue
        tools.update(s["tools"])
        sessions.append(s)

sessions.sort(key=lambda s: s["first"] or "")
mcp = {k: v for k, v in tools.items() if k.startswith("mcp__lens-studio__")}
mcp_total = sum(mcp.values())
all_total = sum(tools.values())
day = lambda ts: ts[:10] if ts else "?"

L = []
L.append("# Build log")
L.append("")
L.append(f"Written by `tools/build-log.py` at {datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%S+00:00')} from the Claude Code session transcripts on one machine. Nothing in it is typed by hand. Sessions run on teammates' machines are not in it.")
L.append("")
L.append("| Fact | Value |")
L.append("| --- | --- |")
L.append(f"| build sessions | {len(sessions)} |")
L.append(f"| first session | {day(sessions[0]['first']) if sessions else '?'} |")
L.append(f"| last session | {day(sessions[-1]['last']) if sessions else '?'} |")
L.append(f"| assistant turns | {sum(s['assistant'] for s in sessions)} |")
L.append(f"| tool calls, all tools | {all_total} |")
L.append(f"| Lens Studio MCP calls | {mcp_total} |")
L.append(f"| LEAF scenario runs through the MCP | {mcp.get('mcp__lens-studio__run_leaf_scenario', 0)} |")
L.append(f"| TypeScript recompiles through the MCP | {mcp.get('mcp__lens-studio__RecompileTypeScriptTool', 0)} |")
L.append(f"| preview captures through the MCP | {mcp.get('mcp__lens-studio__CapturePanelScreenshotTool', 0)} |")
L.append("")
L.append("## Lens Studio MCP calls by tool")
L.append("")
L.append("| Tool | Calls |")
L.append("| --- | --- |")
for k, v in sorted(mcp.items(), key=lambda kv: -kv[1]):
    L.append(f"| `{k.replace('mcp__lens-studio__', '')}` | {v} |")
L.append("")
L.append("## Sessions")
L.append("")
L.append("| Date | Session | Assistant turns | MCP calls |")
L.append("| --- | --- | --- | --- |")
for s in sessions:
    n = sum(v for k, v in s["tools"].items() if k.startswith("mcp__lens-studio__"))
    L.append(f"| {day(s['first'])} | {s['label'] or s['id']} | {s['assistant']} | {n} |")
L.append("")
L.append("Regenerate: `tools/build-log.py ~/.claude/projects/<project transcript folders>`.")
os.makedirs(os.path.dirname(a.out) or ".", exist_ok=True)
open(a.out, "w").write("\n".join(L) + "\n")
print(f"{len(sessions)} sessions, {mcp_total} Lens Studio MCP calls, written to {a.out}")
