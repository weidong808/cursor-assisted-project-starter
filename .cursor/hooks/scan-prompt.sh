#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"

INPUT="$input" python3 -c '
import json
import os
import re
import sys

payload = json.loads(os.environ["INPUT"])
prompt = payload.get("prompt", "")

patterns = [
    (re.compile(r"AKIA[0-9A-Z]{16}"), "AWS access key"),
    (re.compile(r"gh[pousr]_[A-Za-z0-9_]{20,}"), "GitHub token"),
    (re.compile(r"sk_(live|test)_[0-9a-zA-Z]{16,}"), "Stripe-style secret key"),
    (re.compile(r"-----BEGIN (RSA |EC )?PRIVATE KEY-----"), "private key block"),
]

for pattern, label in patterns:
    if pattern.search(prompt):
        print(json.dumps({
            "continue": False,
            "user_message": (
                f"Prompt appears to contain a {label}. Remove secrets from "
                "chat; use env vars and .cursorignore instead."
            ),
        }))
        sys.exit(0)

print(json.dumps({"continue": True}))
'
