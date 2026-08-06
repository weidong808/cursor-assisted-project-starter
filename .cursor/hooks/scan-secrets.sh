#!/usr/bin/env bash
set -euo pipefail

python3 <<'PY'
import json
import re
import sys

payload = json.load(sys.stdin)
file_path = payload.get("file_path", "")
content = payload.get("content", "")

allow = {"permission": "allow"}

# Teaching repo: skip files that intentionally document secret patterns.
basename = file_path.replace("\\", "/").split("/")[-1]
if basename in {"validate-starter.sh", "scan-secrets.sh", "mcp.example.json"}:
    print(json.dumps(allow))
    raise SystemExit(0)

if basename.endswith(".example") or basename.endswith(".sample"):
    print(json.dumps(allow))
    raise SystemExit(0)

high_confidence = [
    re.compile(r"AKIA[0-9A-Z]{16}"),
    re.compile(r"sk_(live|test)_[0-9a-zA-Z]{16,}"),
    re.compile(r"-----BEGIN (RSA |EC )?PRIVATE KEY-----"),
]

for pattern in high_confidence:
    if pattern.search(content):
        print(
            json.dumps(
                {
                    "permission": "deny",
                    "user_message": (
                        f"Blocked read of likely secret material in {basename}. "
                        "Store secrets in env vars and list paths in .cursorignore."
                    ),
                }
            )
        )
        raise SystemExit(0)

# Block real env files even if they slip past .cursorignore.
if basename == ".env" or basename.startswith(".env."):
    print(
        json.dumps(
            {
                "permission": "deny",
                "user_message": (
                    f"Blocked read of {basename}. Use .env.example for shape; "
                    "keep live values out of the repo."
                ),
            }
        )
    )
    raise SystemExit(0)

print(json.dumps(allow))
PY
