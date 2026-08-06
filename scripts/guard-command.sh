#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"
command_text="$(printf '%s' "$input" | tr '\n' ' ')"

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
