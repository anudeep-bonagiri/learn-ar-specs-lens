#!/usr/bin/env python3
"""Write Assets/BenchCoach/Voice/voice-lines.json from Assets/BenchCoach/Scripts/StepDefinitions.ts.

The ids and texts follow voiceLines() in StepDefinitions.ts: step-01..step-10 (each
step's voiceLine), mistake-<code> (MISTAKES), idle-step-NN (each step's hint),
floor-found, halfway, finish. Run from the repo root after changing any of them:

    python3 tools/export-voice-lines.py
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "Assets/BenchCoach/Scripts/StepDefinitions.ts"
OUT = ROOT / "Assets/BenchCoach/Voice/voice-lines.json"

STR = r'"((?:[^"\\]|\\.)*)"'


def unquote(s: str) -> str:
    return json.loads('"' + s + '"')


def main() -> int:
    src = SRC.read_text()
    steps = {}
    for m in re.finditer(r"\n  \{\n    id: (\d+),\n(.*?)\n  \}", src, re.S):
        body = m.group(2)
        voice = re.search(r"voiceLine: " + STR, body)
        hint = re.search(r"hint: " + STR, body)
        if voice and hint:
            steps[int(m.group(1))] = (unquote(voice.group(1)), unquote(hint.group(1)))
    last = max(steps)
    mistakes_block = re.search(r"export const MISTAKES[^{]*\{(.*?)\n\}", src, re.S).group(1)
    mistakes = [(k, unquote(v)) for k, v in re.findall(r"\n  (\w+): " + STR, mistakes_block)]
    extra = {}
    for name, key in (("VOICE_FLOOR_FOUND", "floor-found"), ("VOICE_HALFWAY", "halfway"), ("VOICE_FINISH", "finish")):
        extra[key] = unquote(re.search(r"export const " + name + r" = " + STR, src).group(1))

    lines = []
    for i in range(1, last):
        lines.append({"id": f"step-{i:02d}", "text": steps[i][0]})
    for code, text in mistakes:
        lines.append({"id": f"mistake-{code}", "text": text})
    for i in range(1, last):
        lines.append({"id": f"idle-step-{i:02d}", "text": steps[i][1]})
    for key in ("floor-found", "halfway", "finish"):
        lines.append({"id": key, "text": extra[key]})

    too_long = [l for l in lines if len(l["text"].split()) > 12]
    for l in too_long:
        print(f"over 12 words: {l['id']}: {l['text']}", file=sys.stderr)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(lines, indent=2, ensure_ascii=False) + "\n")
    print(f"wrote {len(lines)} lines to {OUT.relative_to(ROOT)}")
    return 1 if too_long else 0


if __name__ == "__main__":
    sys.exit(main())
