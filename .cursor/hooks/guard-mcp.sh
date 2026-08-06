#!/usr/bin/env bash
# beforeMCPExecution — block MCP calls whose arguments carry live credentials.
#
# Also failClosed in .cursor/hooks.json, so the same rules as scan-prompt.sh
# apply: pure bash, no `set -e`, exactly one JSON object printed on every path.
# A missing `python3` must never be able to stop MCP calls from running.

set -uo pipefail

emit() {
  printf '%s\n' "$1"
  exit 0
}

input="$(cat 2>/dev/null || true)"

# Best-effort tool name for the message. Never fatal if it can't be found.
tool_name="$(printf '%s' "$input" \
  | grep -oE '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | head -n 1 | cut -d'"' -f4 2>/dev/null || true)"
[ -n "$tool_name" ] || tool_name="(unknown)"

credential_pattern='AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9_]{20,}|sk_(live|test)_[0-9a-zA-Z]{16,}|xox[abposr]-[A-Za-z0-9-]{10,}|-----BEGIN( [A-Z]+)* PRIVATE KEY-----'

if printf '%s' "$input" | grep -Eq "$credential_pattern" 2>/dev/null; then
  emit "{\"permission\":\"deny\",\"user_message\":\"MCP tool ${tool_name} blocked: arguments appear to contain live credentials. Pass env var names, not values.\",\"agent_message\":\"The arguments to ${tool_name} contain what looks like a live credential. Never pass secret values through tool arguments — reference the env var name instead and let the server read it.\"}"
fi

emit '{"permission":"allow"}'
