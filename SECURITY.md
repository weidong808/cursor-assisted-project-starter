# Security model

How this starter fits Cursor's **shared responsibility** model and enterprise
hardening guidance ([Security Hardening](https://cursor.com/docs/enterprise/security-hardening)).

## Two layers — do not confuse them

| Layer | Mechanism | Deterministic? | Role |
| --- | --- | --- | --- |
| **Steering** | `AGENTS.md`, rules, skills, commands | No | Guide the model toward better behavior |
| **Enforcement** | Hooks, Run Mode, approvals, sandbox | Yes | Block or require approval regardless of model output |

**Rules are advice. Hooks are enforcement.** Enterprise deployments need both.

## What `.cursorignore` does and does not do

Per [Cursor docs](https://cursor.com/docs/reference/ignore-file):

- **Does:** exclude paths from Agent/Tab context and @-mentions
- **Does not:** block terminal access, MCP tools, or determined bypass attempts
- **Is not:** a security boundary — use hooks + permissions for secrets

Terminal and MCP can still reach ignored paths. Never store live secrets in repos
you open with Cursor.

## Defense in depth (recommended stack)

1. **Org:** Privacy Mode, SSO/SCIM, MCP allowlist, Team Rules (Enterprise dashboard)
2. **Repo:** `.cursorignore` + hooks in git + scoped rules
3. **User:** Auto-review Run Mode (not Run Everything), version control, manual review
4. **CI:** lint, test, secret scanning — independent of the agent

## Hooks in this repo

| Hook | Event | `failClosed` | Purpose |
| --- | --- | --- | --- |
| `scan-prompt.sh` | `beforeSubmitPrompt` | **true** | Block secrets pasted into chat |
| `scan-secrets.sh` | `beforeReadFile` | false | Block reads of likely secret files/content |
| `guard-command.sh` | `beforeShellExecution` | false | Deny destructive shell patterns |
| `guard-mcp.sh` | `beforeMCPExecution` | **true** | Deny credential material in MCP args |
| `audit-edit.sh` | `afterFileEdit` | — | Append-only edit log |

Set `failClosed: true` on security-critical hooks so crashes/timeouts block the
action instead of failing open ([hooks docs](https://cursor.com/docs/hooks)).

**`failClosed` cuts both ways.** A hook that crashes, times out, or prints
nothing blocks the operation — so a broken security hook is not a missed check,
it is an agent that cannot submit a prompt. Every hook here is therefore pure
bash and `grep` with no interpreter dependency, avoids `set -e`, carries an
explicit `timeout`, and prints exactly one JSON object on every path.
`scripts/validate-starter.sh` enforces all of that, and CI runs it with
`python3` removed to prove it. See [.cursor/hooks/README.md](./.cursor/hooks/README.md).

## MCP

- Committed `mcp.json` stays **empty** — safe clone
- Enable servers only after **pinning packages** and reviewing permissions
- Use `${env:VAR}` — never commit tokens
- Enterprise: use dashboard **MCP allowlist** + per-tool allowlists

## Subagents

Review subagents (`code-reviewer`, `security-auditor`) use `readonly: true`.
They cannot edit files — use for isolated verification, not implementation.

## Prompt injection

Rules cannot prevent prompt injection. Assume retrieved content and tool output
is untrusted. Hooks and human review catch what steering misses.

## Reporting

Cursor vulnerabilities: [security-reports@cursor.com](mailto:security-reports@cursor.com)
