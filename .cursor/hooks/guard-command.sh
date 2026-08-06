#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"

if command -v python3 >/dev/null 2>&1; then
  command_text="$(printf '%s' "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('command',''))")"
else
  command_text="$input"
fi

blocked_patterns=(
  'rm[[:space:]]+-rf[[:space:]]+(/|~|\$HOME)'
  'git[[:space:]]+reset[[:space:]]+--hard'
  'git[[:space:]]+push[[:space:]].*--force'
  'DROP[[:space:]]+(DATABASE|SCHEMA)'
  'terraform[[:space:]]+destroy'
  'kubectl[[:space:]]+delete[[:space:]]+namespace'
)

for pattern in "${blocked_patterns[@]}"; do
  if printf '%s' "$command_text" | grep -Eiq "$pattern"; then
    printf '{"permission":"deny","user_message":"Blocked by repository safety guard. Review and run manually only with explicit authorization."}\n'
    exit 0
  fi
done

printf '{"permission":"allow"}\n'
