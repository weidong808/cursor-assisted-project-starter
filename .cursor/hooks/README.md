# Hook scripts

Command-based hooks receive JSON on stdin and return JSON on stdout.
See [Cursor Hooks](https://cursor.com/docs/hooks) and [SECURITY.md](../../SECURITY.md).

| Script | Event | failClosed | Behavior |
| --- | --- | --- | --- |
| `scan-prompt.sh` | `beforeSubmitPrompt` | yes | Block secrets pasted into user prompts |
| `scan-secrets.sh` | `beforeReadFile` | no | Block reads of `.env*` and high-confidence secret content |
| `guard-command.sh` | `beforeShellExecution` | no | Deny destructive shell patterns |
| `guard-mcp.sh` | `beforeMCPExecution` | yes | Deny credential material in MCP tool arguments |
| `audit-edit.sh` | `afterFileEdit` | — | Append-only log at `.edit-audit.log` (gitignored) |

## Customize for your organization

- **scan-prompt.sh / scan-secrets.sh** — extend patterns; wire to DLP API for Enterprise
- **guard-command.sh** — add prod kubectl, `aws`, `terraform` blocks
- **guard-mcp.sh** — pair with dashboard MCP allowlist; add tool-name allowlists here if needed
- **audit-edit.sh** — replace with formatter or forward to SIEM

Requires `bash` and `python3` (Git Bash on Windows).

## Smoke tests

```bash
printf '%s' '{"prompt":"token sk_live_abc123def456ghi789"}' | bash .cursor/hooks/scan-prompt.sh
printf '%s' '{"command":"rm -rf /"}' | bash .cursor/hooks/guard-command.sh
printf '%s' '{"tool_name":"example","tool_input":"plain text"}' | bash .cursor/hooks/guard-mcp.sh
```
