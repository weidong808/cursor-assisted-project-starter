#!/usr/bin/env bash
set -euo pipefail

required=(
  "AGENTS.md"
  ".cursor/rules/production-minded-changes.mdc"
  ".cursor/commands/review-change.md"
  ".cursor/skills/release-readiness/SKILL.md"
  ".cursor/agents/code-reviewer.md"
  ".cursor/mcp.json"
  ".cursor/hooks.json"
)

failed=0
for file in "${required[@]}"; do
  if [[ ! -s "$file" ]]; then
    printf 'Missing or empty: %s\n' "$file"
    failed=1
  fi
done

if command -v python3 >/dev/null 2>&1; then
  python3 -m json.tool .cursor/mcp.json >/dev/null
  python3 -m json.tool .cursor/hooks.json >/dev/null
else
  printf 'Warning: python3 unavailable; JSON syntax was not checked.\n'
fi

if grep -RIEq '(api[_-]?key|secret|token)[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_./+=-]{12,}' .   --exclude-dir=.git --exclude='mcp.example.json' --exclude='validate-starter.sh'; then
  printf 'Potential hard-coded secret found.\n'
  failed=1
fi

if grep -RIn 'TODO' AGENTS.md >/dev/null; then
  printf 'Customization required: replace TODO values in AGENTS.md.\n'
fi

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

printf 'Starter structure and configuration syntax look valid.\n'
