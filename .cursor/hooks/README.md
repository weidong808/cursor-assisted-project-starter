# Hook scripts

Command-based hooks receive JSON on stdin and return JSON on stdout. See [Cursor Hooks](https://cursor.com/docs/hooks).

| Script | Event | Behavior |
| --- | --- | --- |
| `guard-command.sh` | `beforeShellExecution` | Deny destructive shell patterns (`rm -rf /`, force push, etc.) |
| `scan-secrets.sh` | `beforeReadFile` | Deny reads of `.env*` and high-confidence secret material |
| `audit-edit.sh` | `afterFileEdit` | Append-only log at `.edit-audit.log` (gitignored) |

## Customize for your app

- **guard-command.sh** — add org-specific blocked commands (e.g. prod kubectl, `aws s3 rm`).
- **scan-secrets.sh** — tighten patterns; set `failClosed: true` on the hook in `hooks.json` for stricter reads.
- **audit-edit.sh** — replace with a real formatter (`prettier`, `gofmt`) or CI telemetry.

Requires `bash` and `python3` on the PATH (Git Bash on Windows).

## Smoke test

```bash
printf '%s' '{"command":"rm -rf /"}' | bash .cursor/hooks/guard-command.sh
printf '%s' '{"command":"npm test"}' | bash .cursor/hooks/guard-command.sh
```
