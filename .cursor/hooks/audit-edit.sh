#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"
log_file="$(dirname "$0")/.edit-audit.log"

if command -v python3 >/dev/null 2>&1; then
  file_path="$(INPUT="$input" python3 -c 'import json,os; print(json.loads(os.environ["INPUT"]).get("file_path","unknown"))')"
else
  file_path="unknown"
fi

timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date '+%Y-%m-%dT%H:%M:%SZ')"
printf '[%s] edited %s\n' "$timestamp" "$file_path" >>"$log_file"

exit 0
