#!/usr/bin/env bash
set -euo pipefail

required=(
  "AGENTS.md"
  "ADOPT.md"
  ".env.example"
  ".cursorignore"
  ".cursorindexingignore"
  ".cursor/rules/production-minded-changes.mdc"
  ".cursor/rules/protect-sensitive-paths.mdc"
  ".cursor/rules/api-boundaries.mdc"
  ".cursor/rules/testing-expectations.mdc"
  ".cursor/commands/code-review.md"
  ".cursor/commands/ship.md"
  ".cursor/skills/release-readiness/SKILL.md"
  ".cursor/skills/ship-check/SKILL.md"
  ".cursor/agents/code-reviewer.md"
  ".cursor/agents/security-auditor.md"
  ".cursor/mcp.json"
  ".cursor/mcp.example.json"
  ".cursor/hooks.json"
  ".cursor/hooks/guard-command.sh"
  ".cursor/hooks/scan-secrets.sh"
  ".cursor/hooks/audit-edit.sh"
  ".cursor/hooks/README.md"
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
  python3 -m json.tool .cursor/mcp.example.json >/dev/null
  python3 -m json.tool .cursor/hooks.json >/dev/null
else
  printf 'Warning: python3 unavailable; JSON syntax was not checked.\n'
fi

while IFS= read -r skill_file; do
  dir_name="$(basename "$(dirname "$skill_file")")"
  skill_name="$(python3 -c "import re, pathlib; t=pathlib.Path('$skill_file').read_text(); m=re.search(r'^name:\\s*(.+)$', t, re.M); print(m.group(1).strip() if m else '')")"
  if [[ -z "$skill_name" || "$dir_name" != "$skill_name" ]]; then
    printf 'Skill folder/name mismatch: %s (folder) vs %s (name)\n' "$dir_name" "$skill_name"
    failed=1
  fi
done < <(find .cursor/skills -name SKILL.md | sort)

if grep -RIEq '(api[_-]?key|secret|token)[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_./+=-]{12,}' .   --exclude-dir=.git --exclude='mcp.example.json' --exclude='validate-starter.sh' --exclude='scan-secrets.sh'; then
  printf 'Potential hard-coded secret found.\n'
  failed=1
fi

if ! grep -q 'disable-model-invocation: true' .cursor/skills/ship-check/SKILL.md; then
  printf 'Missing disable-model-invocation on ship-check skill.\n'
  failed=1
fi

if command -v python3 >/dev/null 2>&1; then
  deny="$(printf '%s' '{"command":"rm -rf /"}' | bash .cursor/hooks/guard-command.sh)"
  if ! printf '%s' "$deny" | python3 -c "import json,sys; d=json.load(sys.stdin); sys.exit(0 if d.get('permission')=='deny' else 1)"; then
    printf 'guard-command.sh did not deny a destructive command.\n'
    failed=1
  fi

  allow="$(printf '%s' '{"command":"npm test"}' | bash .cursor/hooks/guard-command.sh)"
  if ! printf '%s' "$allow" | python3 -c "import json,sys; d=json.load(sys.stdin); sys.exit(0 if d.get('permission')=='allow' else 1)"; then
    printf 'guard-command.sh blocked a safe command.\n'
    failed=1
  fi
else
  printf 'Warning: python3 unavailable; hook behavior was not checked.\n'
fi

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

printf 'Starter structure, skills, and hooks look valid.\n'
