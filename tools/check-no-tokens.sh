#!/bin/bash
# check-no-tokens.sh — fail if a Remote Service Gateway token could be committed.
#
# Scans every tracked file, every untracked file that is not git-ignored, and the
# staged copy of every staged file. Fails (exit 1) when a snapToken / openAIToken /
# googleToken key carries a value that is not empty or a package placeholder
# ("[INSERT ... TOKEN ...]"), or when a line with one of those keys also holds a
# long bearer-like string (32+ characters of [A-Za-z0-9._-]).
#
# Usage: tools/check-no-tokens.sh            (repo scan)
#        tools/check-no-tokens.sh FILE...    (scan only these files; used to self-test)
# Prints at most the first 6 characters of anything it flags.
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2

python3 - "$@" <<'PY'
import re, subprocess, sys

KEYS = r"(?:snapToken|openAIToken|googleToken)"
QUOTED = re.compile(KEYS + r"""\s*[:=]\s*(["'])(.*?)\1""")
YAML_BARE = re.compile(r"^\s*" + KEYS + r"""\s*:\s*([^\s"'#][^\s#]*)\s*$""")
LONG = re.compile(r"[A-Za-z0-9._\-]{32,}")
KEYWORD = re.compile(KEYS)

def placeholder(v):
    v = v.strip()
    return v == "" or v.upper().startswith("[INSERT")

def scan(name, text, findings):
    for n, line in enumerate(text.splitlines(), 1):
        if not KEYWORD.search(line):
            continue
        for m in QUOTED.finditer(line):
            if not placeholder(m.group(2)):
                findings.append(f"{name}:{n}: non-placeholder token value '{m.group(2)[:6]}...'")
        m = YAML_BARE.match(line)
        if m and not placeholder(m.group(1)):
            findings.append(f"{name}:{n}: unquoted token value '{m.group(1)[:6]}...'")
        for m in LONG.finditer(KEYWORD.sub("", line)):
            findings.append(f"{name}:{n}: long bearer-like string next to a token key '{m.group(0)[:6]}...'")

def git(*args):
    return subprocess.run(["git", *args], capture_output=True).stdout

def is_text(data):
    return b"\0" not in data[:8192]

findings = []
files = sys.argv[1:]
if files:
    sources = [(f, open(f, "rb").read()) for f in files]
else:
    names = [n for n in git("ls-files", "-co", "--exclude-standard", "-z").decode().split("\0") if n]
    sources = []
    for n in names:
        try:
            sources.append((n, open(n, "rb").read()))
        except (IsADirectoryError, FileNotFoundError):
            pass
    staged = [n for n in git("diff", "--cached", "--name-only", "-z").decode().split("\0") if n]
    for n in staged:
        sources.append((f"(staged) {n}", git("show", f":{n}")))

checked = 0
for name, data in sources:
    if not is_text(data):
        continue
    checked += 1
    scan(name, data.decode("utf-8", "replace"), findings)

if findings:
    print("check-no-tokens: FAIL")
    for f in findings:
        print("  " + f)
    sys.exit(1)
print(f"check-no-tokens: OK ({checked} text files scanned, token fields empty or placeholders)")
PY
