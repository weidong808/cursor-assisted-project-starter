#!/usr/bin/env bash
# afterFileEdit — append a line to a local audit log.
#
# Pure bash, like every hook here. Observational only: it never blocks, never
# fails the edit, and swallows any error writing the log.

set -uo pipefail

input="$(cat 2>/dev/null || true)"
log_file="$(dirname "$0")/.edit-audit.log"

file_path="$(printf '%s' "$input" \
  | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | head -n 1 | cut -d'"' -f4 2>/dev/null || true)"
[ -n "$file_path" ] || file_path="unknown"

timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || echo unknown)"

printf '[%s] edited %s\n' "$timestamp" "$file_path" >>"$log_file" 2>/dev/null || true

exit 0
