#!/usr/bin/env bash
# beforeSubmitPrompt — refuse to send a prompt that carries a live credential.
#
# This hook runs failClosed in .cursor/hooks.json: if it prints nothing, Cursor
# blocks the prompt. So it must print exactly one JSON object on EVERY path,
# including failure paths. Two consequences, both deliberate:
#
#   1. No interpreter dependency. Pure bash + grep. `python3` is absent on many
#      Windows setups (and is a no-op Store stub on others), which would fail
#      this hook closed and lock the agent out entirely.
#   2. No `set -e`. An unexpected non-zero exit must not terminate the script
#      before it prints.
#
# Scanning the raw payload rather than parsing out the prompt field is
# intentional: these patterns are high-entropy and unambiguous, JSON escaping
# does not alter them, and it removes the parser as a failure mode.

set -uo pipefail

emit() {
  printf '%s\n' "$1"
  exit 0
}

input="$(cat 2>/dev/null || true)"

patterns=(
  'AKIA[0-9A-Z]{16}'
  'gh[pousr]_[A-Za-z0-9_]{20,}'
  'sk_(live|test)_[0-9a-zA-Z]{16,}'
  'xox[abposr]-[A-Za-z0-9-]{10,}'
  '-----BEGIN( [A-Z]+)* PRIVATE KEY-----'
)

labels=(
  'an AWS access key'
  'a GitHub token'
  'a Stripe-style secret key'
  'a Slack token'
  'a private key block'
)

for i in "${!patterns[@]}"; do
  if printf '%s' "$input" | grep -Eq "${patterns[$i]}" 2>/dev/null; then
    emit "{\"continue\":false,\"user_message\":\"Prompt appears to contain ${labels[$i]}. Remove the secret from chat — reference the env var name instead, and list secret paths in .cursorignore.\",\"agent_message\":\"The prompt contains what looks like ${labels[$i]}. Never paste live credentials into chat — reference the env var name (e.g. OPENAI_API_KEY) and ensure secret paths are in .cursorignore. Do not retry with the secret re-encoded or split.\"}"
  fi
done

emit '{"continue":true}'
