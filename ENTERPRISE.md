# Enterprise alignment

How this starter maps to Cursor's [Security and Privacy Hardening](https://cursor.com/docs/enterprise/security-hardening)
checklist. Items marked **Dashboard** require Cursor Enterprise/Teams admin configuration.

## Admin quickstart ↔ starter coverage

| # | Enterprise control | Covered by starter | Notes |
| --- | --- | --- | --- |
| 1 | Privacy Mode org-wide | — | **Dashboard** |
| 2 | Auto-review Run Mode + sandbox | Documented | **Dashboard** policy; user default Auto-review |
| 3 | Distribute hooks | ✅ | Commit `.cursor/hooks.json` — [team distribution via git](https://cursor.com/docs/hooks#team-distribution) |
| 4 | Network allowlisting | — | **Dashboard** + network team |
| 5 | Team Rules baseline | Partial | Project rules here; **Dashboard** for org-wide enforceable rules |
| 6 | Plugin + MCP governance | Partial | Empty `mcp.json`; **Dashboard** MCP allowlist |
| 7 | `.cursorignore` for secrets | ✅ | Expand per app — see `SECURITY.md` limits |
| 8 | SSO, SCIM, MDM | — | **Dashboard** / IT |
| 9 | Model access restrictions | — | **Dashboard** |
| 10 | Audit logs → SIEM | Partial | `audit-edit.sh` is local; **Dashboard** audit logs for admin events |
| 11 | CMEK | — | **Dashboard** |

## AGENTS.md vs `.cursor/rules/` (2026 best practice)

Research consensus ([Cursor docs](https://cursor.com/docs/rules), [agentskills.io](https://agentskills.io)):

| Put in `AGENTS.md` | Put in `.cursor/rules/*.mdc` |
| --- | --- |
| Stack, architecture, commands | File-scoped conventions (`globs`) |
| Cross-tool standards (Codex, Copilot read it too) | Cursor-specific activation modes |
| Definition of done, boundaries | Rules that should **not** load everywhere |
| One place for the whole team | `@`-mention manual rules |

**Do not duplicate** the same instruction in both — maintain one source of truth.

## Rule activation modes (use the narrowest that works)

| Mode | Frontmatter | When to use |
| --- | --- | --- |
| Always | `alwaysApply: true` | Universal baselines only (keep count low) |
| File-scoped | `globs: "..."` | API rules, test rules, migration rules |
| Agent-selected | `description: "..."` | Plan-first, verify-before-done |
| Manual | no globs, no description | Rare policies invoked with `@rule-name` |

Keep each rule **under ~500 lines**, focused, actionable ([rules best practices](https://cursor.com/docs/rules)).

### Rules in this starter

| Rule | Mode |
| --- | --- |
| `production-minded-changes` | Always |
| `protect-sensitive-paths` | Always |
| `api-boundaries` | Globs |
| `testing-expectations` | Globs |
| `database-migrations` | Globs |
| `plan-before-change` | Agent-selected |
| `verify-before-done` | Agent-selected |
| `small-focused-diffs` | Agent-selected |

## Skills vs commands vs subagents

| Use | When |
| --- | --- |
| **Skill** (auto) | Multi-step expertise the agent should offer when relevant |
| **Skill** + `disable-model-invocation: true` | Side effects — deploy, publish, ship (explicit `/name` only) |
| **Command** `.cursor/commands/` | Legacy slash workflows; migrate with `/migrate-to-skills` |
| **Subagent** | Long review, parallel work, isolated context — not one-shot chores |

Folder name **must equal** `name:` in skill frontmatter.

## MCP enterprise controls

- **Project:** `.cursor/mcp.json` (team-shared, pin packages)
- **Local:** `.cursor/mcp.local.json` (gitignored personal tokens)
- **Enterprise:** [MCP allowlist](https://cursor.com/docs/enterprise/model-and-integration-management#mcp-allowlist) — command patterns + URL patterns + per-tool allowlists
- **Interpolation:** `${env:VAR}`, `${workspaceFolder}` ([MCP config](https://cursor.com/docs/mcp))

## Hooks at scale

Distribution options:

1. **Git** (this starter) — project hooks travel with the repo; Cloud Agents load them
2. **MDM** — org-wide hook scripts on managed devices
3. **Dashboard** — Enterprise team hooks

Integrate SIEM/DLP by calling your APIs from hook scripts ([compliance logging](https://cursor.com/docs/enterprise/compliance-and-monitoring#using-hooks-for-compliance-logging)).

## Applying to production apps

See [ADOPT.md](./ADOPT.md). Recommended enterprise rollout:

1. Pilot one repo (e.g. internal tool, not prod-critical)
2. Add `AGENTS.md` + ignore files + `protect-sensitive-paths`
3. Enable hooks; tune `guard-command.sh` for your stack
4. Add scoped rules for API/test/migrations
5. Wire `/ship` to CI commands
6. Expand to fleet; add **Dashboard** Team Rules for org-wide non-negotiables

## Further reading

- [LLM Safety and Controls](https://cursor.com/docs/enterprise/llm-safety-and-controls)
- [Agent Security](https://cursor.com/docs/agent/security)
- [Trust Center](https://trust.cursor.com/)
