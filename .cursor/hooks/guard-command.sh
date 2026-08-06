#!/usr/bin/env bash
# beforeShellExecution — refuse to run commands that destroy things.
#
# Pure bash. Nothing in .cursor/hooks/ depends on an interpreter being
# installed: a hook that can't answer is worse than no hook at all, and on a
# failClosed hook it locks the agent out entirely.
#
# The payload is scanned as raw JSON rather than parsed. These patterns don't
# occur incidentally, and it removes the parser as a failure mode.

set -uo pipefail

emit() {
  printf '%s\n' "$1"
  exit 0
}

input="$(cat 2>/dev/null || true)"

blocked_patterns=(
  'rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f[[:space:]]+(/|~|\$HOME)'
  'git[[:space:]]+reset[[:space:]]+--hard'
  'git[[:space:]]+push[[:space:]].*--force'
  'git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*f'
  'DROP[[:space:]]+(DATABASE|SCHEMA|TABLE)'
  'TRUNCATE[[:space:]]+TABLE'
  'terraform[[:space:]]+destroy'
  'kubectl[[:space:]]+delete[[:space:]]+(namespace|ns)'
  'chmod[[:space:]]+-R[[:space:]]+777'
  'curl[^|]*\|[[:space:]]*(ba)?sh'
)

for pattern in "${blocked_patterns[@]}"; do
  if printf '%s' "$input" | grep -Eiq "$pattern" 2>/dev/null; then
    emit '{"permission":"deny","user_message":"Blocked by repository safety guard. Review and run manually only with explicit authorization."}'
  fi
done

emit '{"permission":"allow"}'
