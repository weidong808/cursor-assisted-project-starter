# Hook scripts

Command-based hooks receive JSON on stdin and return JSON on stdout.
See [Cursor Hooks](https://cursor.com/docs/hooks) and [SECURITY.md](../../SECURITY.md).

| Script             | Event                  | failClosed | Behavior                                                    |
| ------------------ | ---------------------- | ---------- | ----------------------------------------------------------- |
| `scan-prompt.sh`   | `beforeSubmitPrompt`   | yes        | Block secrets pasted into user prompts                      |
| `scan-secrets.sh`  | `beforeReadFile`       | no         | Block reads of `.env*` and high-confidence secret content   |
| `guard-command.sh` | `beforeShellExecution` | no         | Deny destructive shell patterns                             |
| `guard-mcp.sh`     | `beforeMCPExecution`   | yes        | Deny credential material in MCP tool arguments              |
| `audit-edit.sh`    | `afterFileEdit`        | —          | Append-only log at `.edit-audit.log` (gitignored)           |

## Requirements

**`bash` and `grep`. Nothing else.** Git Bash on Windows is enough.

That constraint is deliberate, and it was learned the hard way — see below.

## The rule these scripts follow

**A hook must print exactly one JSON object on every path, including failure
paths.**

When `failClosed` is set, a hook that prints nothing blocks the operation. So the
failure mode of a badly written hook isn't a missed check — it's a locked agent
that can't submit a prompt at all, with an error message that points at the hook
rather than the cause.

Three things follow, and every script here obeys them:

1. **No interpreter dependency.** These originally shelled out to `python3`.
   On Windows `python3` is frequently absent, or resolves to a Store stub that
   exits non-zero — the hook produced no output and locked the agent out. Pure
   bash and `grep` run wherever Cursor's hooks run.
2. **No `set -e`.** An unexpected non-zero exit must never terminate the script
   before it prints. The scripts use `set -uo pipefail` and an `emit` helper
   that prints and exits 0.
3. **Scan the raw payload, don't parse it.** The patterns matched here are
   high-entropy and unaffected by JSON escaping, so parsing buys nothing and
   adds a failure mode.

`scripts/validate-starter.sh` enforces all three, plus checks that no hook is
empty, entirely commented out, or carrying CRLF line endings. Those tests run
without `python3` — a check that skips itself on the machines where it matters
is not a check.

## Customize for your organization

- **scan-prompt.sh / scan-secrets.sh** — extend patterns; wire to a DLP API for Enterprise
- **guard-command.sh** — add prod `kubectl`, `aws`, `terraform` blocks
- **guard-mcp.sh** — pair with a dashboard MCP allowlist; add tool-name allowlists here
- **audit-edit.sh** — replace with a formatter, or forward to SIEM

If you add a dependency to a `failClosed` hook, make it degrade to a printed
`allow` when the dependency is missing. Never let it exit silently.

## Smoke tests

```bash
printf '%s' '{"prompt":"token sk_live_abc123def456ghi789"}' | bash .cursor/hooks/scan-prompt.sh
printf '%s' '{"prompt":"refactor the auth module"}'         | bash .cursor/hooks/scan-prompt.sh
printf '%s' '{"command":"rm -rf /"}'                        | bash .cursor/hooks/guard-command.sh
printf '%s' '{"tool_name":"example","tool_input":"plain"}'  | bash .cursor/hooks/guard-mcp.sh
printf '%s' '{"file_path":".env","content":"X=1"}'          | bash .cursor/hooks/scan-secrets.sh
```

Every one of those must print JSON. Silence is the bug.

Full suite:

```bash
bash scripts/validate-starter.sh
```
