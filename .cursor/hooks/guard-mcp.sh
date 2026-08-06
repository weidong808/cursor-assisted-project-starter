#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"

INPUT="$input" python3 -c '
import json
import os
import re
import sys

payload = json.loads(os.environ["INPUT"])
tool_name = payload.get("tool_name", "")
tool_input = payload.get("tool_input", "") or ""

if re.search(
    r"(AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9_]{20,}|sk_(live|test)_[0-9a-zA-Z]{16,})",
    tool_input,
):
    print(json.dumps({
        "permission": "deny",
        "user_message": (
            f"MCP tool \"{tool_name}\" blocked: arguments appear to contain "
            "live credentials. Pass env var names, not values."
        ),
    }))
    sys.exit(0)

print(json.dumps({"permission": "allow"}))
'
