#!/usr/bin/env bash
# Structural and behavioural checks for the starter.
#
# Everything here runs without python3. The previous version gated its hook
# tests behind `command -v python3`, which is exactly the condition under which
# the hooks break — so on the machines that needed the check most, it skipped
# the tests and reported success.

set -uo pipefail

failed=0

# ---------------------------------------------------------------- structure --

required=(
  "AGENTS.md"
  "ADOPT.md"
  "SECURITY.md"
  "ENTERPRISE.md"
  "templates/AGENTS.app.md"
  ".env.example"
  ".gitattributes"
  ".cursorignore"
  ".cursorindexingignore"
  ".cursor/rules/production-minded-changes.mdc"
  ".cursor/rules/protect-sensitive-paths.mdc"
  ".cursor/rules/plan-before-change.mdc"
  ".cursor/rules/verify-before-done.mdc"
  ".cursor/rules/small-focused-diffs.mdc"
  ".cursor/rules/api-boundaries.mdc"
  ".cursor/rules/testing-expectations.mdc"
  ".cursor/rules/database-migrations.mdc"
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
  ".cursor/hooks/guard-mcp.sh"
  ".cursor/hooks/scan-prompt.sh"
  ".cursor/hooks/scan-secrets.sh"
  ".cursor/hooks/audit-edit.sh"
  ".cursor/hooks/README.md"
)

for file in "${required[@]}"; do
  if [[ ! -s "$file" ]]; then
    printf 'Missing or empty: %s\n' "$file"
    failed=1
  fi
done

# ------------------------------------------------------------ hook hygiene --

CR="$(printf '\r')"

while IFS= read -r script; do
  # The outage this check exists for: scan-prompt.sh was commented out top to
  # bottom. It ran, printed nothing, and failClosed blocked every prompt.
  if ! grep -qE '^[[:space:]]*[^#[:space:]]' "$script"; then
    printf 'Hook has no executable lines (entirely commented out?): %s\n' "$script"
    failed=1
  fi
  if LC_ALL=C grep -q "$CR" "$script"; then
    printf 'Hook has CRLF line endings; bash will fail on it: %s\n' "$script"
    failed=1
  fi
done < <(find .cursor/hooks -name '*.sh' | sort)

# A hook that cannot print is a lockout when failClosed is set. None of them may
# depend on anything that might be missing, or exit before printing.
for script in .cursor/hooks/*.sh; do
  # Strip comments first — the scripts explain in prose why they avoid these.
  if grep -vE '^[[:space:]]*#' "$script" | grep -qE '\b(python3?|node|perl|ruby)\b'; then
    printf 'Hook depends on an interpreter (breaks where it is missing): %s\n' "$script"
    failed=1
  fi
  if grep -qE '^[[:space:]]*set -[a-z]*e' "$script"; then
    printf 'Hook uses set -e and may exit before printing: %s\n' "$script"
    failed=1
  fi
done

# ---------------------------------------------------------- hook behaviour --

assert_hook() {
  local label="$1" script="$2" payload="$3" expect="$4" out
  out="$(printf '%s' "$payload" | bash "$script" 2>/dev/null)"
  if [[ -z "$out" ]]; then
    printf 'Hook produced NO OUTPUT (fails closed): %s — %s\n' "$script" "$label"
    failed=1
  elif ! printf '%s' "$out" | grep -q "$expect"; then
    printf 'Hook assertion failed: %s — %s\n  expected: %s\n  got:      %s\n' \
      "$script" "$label" "$expect" "$out"
    failed=1
  fi
}

assert_hook "denies destructive command" .cursor/hooks/guard-command.sh \
  '{"command":"rm -rf /"}' '"permission":"deny"'
assert_hook "allows safe command" .cursor/hooks/guard-command.sh \
  '{"command":"npm test"}' '"permission":"allow"'
assert_hook "blocks secret-like prompt" .cursor/hooks/scan-prompt.sh \
  '{"prompt":"key sk_live_abcdefghijklmnopqrst"}' '"continue":false'
assert_hook "allows safe prompt" .cursor/hooks/scan-prompt.sh \
  '{"prompt":"refactor the auth module"}' '"continue":true'
assert_hook "blocks AWS key in prompt" .cursor/hooks/scan-prompt.sh \
  '{"prompt":"use AKIAIOSFODNN7EXAMPLE"}' '"continue":false'
assert_hook "denies credential in MCP args" .cursor/hooks/guard-mcp.sh \
  '{"tool_name":"db","tool_input":"AKIAIOSFODNN7EXAMPLE"}' '"permission":"deny"'
assert_hook "allows clean MCP call" .cursor/hooks/guard-mcp.sh \
  '{"tool_name":"db","tool_input":"select 1"}' '"permission":"allow"'
assert_hook "allows ordinary file read" .cursor/hooks/scan-secrets.sh \
  '{"file_path":"src/app.ts","content":"export const x = 1;"}' '"permission":"allow"'
assert_hook "empty payload still answers" .cursor/hooks/scan-prompt.sh \
  '' '"continue":true'

# ------------------------------------------------------------- file hygiene --

# A UTF-8 BOM makes the first line of a config file not match what it looks like.
# .cursorignore shipped with one; its first pattern was silently a different string.
while IFS= read -r f; do
  if [[ "$(head -c 3 "$f" | od -An -tx1 | tr -d ' \n')" == "efbbbf" ]]; then
    printf 'File starts with a UTF-8 BOM: %s\n' "$f"
    failed=1
  fi
done < <(git ls-files 2>/dev/null || find . -type f -not -path './.git/*')

# ------------------------------------------------------------------- rules --

# Quoted globs are parsed as ONE malformed pattern, so the rule never attaches
# and fails silently. Cursor wants bare comma-separated values.
while IFS= read -r rule; do
  if ! grep -q '^description:' "$rule"; then
    printf 'Rule missing description (needed for agent-requested rules): %s\n' "$rule"
    failed=1
  fi
  if ! grep -q '^alwaysApply:' "$rule"; then
    printf 'Rule missing alwaysApply: %s\n' "$rule"
    failed=1
  fi
  globs_line="$(grep -m1 '^globs:' "$rule" || true)"
  if [[ -n "$globs_line" ]]; then
    if printf '%s' "$globs_line" | grep -q '["'"'"']'; then
      printf 'Rule has QUOTED globs (parsed as one bad pattern, never matches): %s\n' "$rule"
      failed=1
    fi
    if printf '%s' "$globs_line" | grep -q ', '; then
      printf 'Rule has a space after a glob comma (breaks the pattern): %s\n' "$rule"
      failed=1
    fi
  fi
done < <(find .cursor/rules -name '*.mdc' | sort)

# --------------------------------------------------------------- subagents --

while IFS= read -r agent; do
  for field in name description; do
    if ! grep -q "^${field}:" "$agent"; then
      printf 'Subagent missing %s: %s\n' "$field" "$agent"
      failed=1
    fi
  done
done < <(find .cursor/agents -name '*.md' | sort)

# ------------------------------------------------------------------ hooks --

# Every hook command referenced in hooks.json must actually exist.
while IFS= read -r ref; do
  if [[ ! -f "$ref" ]]; then
    printf 'hooks.json references a missing script: %s\n' "$ref"
    failed=1
  fi
done < <(grep -oE '\.cursor/hooks/[A-Za-z0-9_.-]+\.sh' .cursor/hooks.json | sort -u)

# ------------------------------------------------------------------ content --

while IFS= read -r skill_file; do
  dir_name="$(basename "$(dirname "$skill_file")")"
  skill_name="$(grep -m1 -E '^name:[[:space:]]*' "$skill_file" \
    | sed -e 's/^name:[[:space:]]*//' -e 's/[[:space:]]*$//' | tr -d '\r')"
  if [[ -z "$skill_name" || "$dir_name" != "$skill_name" ]]; then
    printf 'Skill folder/name mismatch: %s vs %s\n' "$dir_name" "$skill_name"
    failed=1
  fi
done < <(find .cursor/skills -name SKILL.md | sort)

if ! grep -q 'disable-model-invocation: true' .cursor/skills/ship-check/SKILL.md; then
  printf 'Missing disable-model-invocation on ship-check skill.\n'
  failed=1
fi

if grep -RIEq '(api[_-]?key|secret|token)[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_./+=-]{12,}' . \
  --exclude-dir=.git --exclude='mcp.example.json' --exclude='validate-starter.sh' \
  --exclude='scan-secrets.sh' --exclude='scan-prompt.sh' --exclude='guard-mcp.sh'; then
  printf 'Potential hard-coded secret found.\n'
  failed=1
fi

# JSON syntax, when a working parser happens to be available. Advisory only.
#
# `command -v python3` is not enough: a name can resolve to a stub that exits
# non-zero (common on Windows). Prove the parser works on known-good input
# before trusting its verdict — the same mistake the hooks used to make.
json_parser=""
if command -v python3 >/dev/null 2>&1 && printf '{}' | python3 -m json.tool >/dev/null 2>&1; then
  json_parser="python3 -m json.tool"
elif command -v node >/dev/null 2>&1 && node -e 'JSON.parse("{}")' >/dev/null 2>&1; then
  json_parser="node_json"
fi

if [[ -n "$json_parser" ]]; then
  for json in .cursor/mcp.json .cursor/mcp.example.json .cursor/hooks.json; do
    if [[ "$json_parser" == "node_json" ]]; then
      ok=$(node -e "require('fs').readFileSync('$json','utf8') && JSON.parse(require('fs').readFileSync('$json','utf8')); console.log('ok')" 2>/dev/null)
    else
      ok=$(python3 -m json.tool "$json" >/dev/null 2>&1 && echo ok)
    fi
    if [[ "$ok" != *ok* ]]; then
      printf 'Invalid JSON: %s\n' "$json"
      failed=1
    fi
  done
else
  printf 'Note: no working JSON parser found; syntax not checked (hooks were).\n'
fi

# ------------------------------------------------------------------- result --

if [[ "$failed" -ne 0 ]]; then
  printf '\nValidation FAILED.\n'
  exit 1
fi

printf 'Starter structure, rules, skills, and hooks look valid.\n'
