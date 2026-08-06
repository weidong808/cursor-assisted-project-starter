#!/usr/bin/env bash
# beforeReadFile — refuse to feed likely secret material to the model.
#
# Pure bash, like the other hooks. Nothing in .cursor/hooks/ depends on an
# interpreter being installed: these run anywhere bash runs, which is the only
# way a hook can be trusted to answer on every machine that clones this repo.
#
# failClosed is false for this one, so a crash would only cost a retry — but it
# still prints on every path. Silence from a hook is never useful.

set -uo pipefail

emit() {
  printf '%s\n' "$1"
  exit 0
}

input="$(cat 2>/dev/null || true)"

file_path="$(printf '%s' "$input" \
  | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | head -n 1 | cut -d'"' -f4 2>/dev/null || true)"
basename="${file_path##*/}"
basename="${basename##*\\}"

# Files that legitimately contain credential-shaped text: this repo's own
# scanners, and the example/sample files that exist to show shape.
case "$basename" in
  validate-starter.sh | scan-secrets.sh | scan-prompt.sh | guard-mcp.sh | guard-command.sh)
    emit '{"permission":"allow"}'
    ;;
  *.example | *.sample | mcp.example.json)
    emit '{"permission":"allow"}'
    ;;
esac

# Live secret material, wherever it appears in the payload.
secret_pattern='AKIA[0-9A-Z]{16}|sk_(live|test)_[0-9a-zA-Z]{16,}|gh[pousr]_[A-Za-z0-9_]{20,}|-----BEGIN( [A-Z]+)* PRIVATE KEY-----'

if printf '%s' "$input" | grep -Eq "$secret_pattern" 2>/dev/null; then
  emit "{\"permission\":\"deny\",\"user_message\":\"Blocked read of likely secret material in ${basename:-that file}. Store secrets in env vars and list the paths in .cursorignore.\"}"
fi

# Real env files, whatever they contain. .env.example is allowed above.
case "$basename" in
  .env | .env.*)
    emit "{\"permission\":\"deny\",\"user_message\":\"Blocked read of ${basename}. Use .env.example for shape; keep live values out of the repo.\"}"
    ;;
esac

emit '{"permission":"allow"}'
