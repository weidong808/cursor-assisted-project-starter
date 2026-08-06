# Cursor-Assisted Project Starter

A production-minded, reusable control layer for Cursor projects — the companion
repo for **Seven Files That Never Ship to Production** (AI in Action).

Most teams repeatedly explain architecture, conventions, tests, and safety
boundaries to their coding agent. This starter moves that knowledge into the
repository so Cursor can begin each task with useful context and deterministic
guardrails.

## Map to the post

The LinkedIn caption lists **seven ideas**; the card lists **seven rows**. Item 4
combines `commands/` and `skills/`; item 7 splits into `.cursorignore` and
`.cursorindexingignore`. This repo implements all of them.

| Post # | Card tag | What to open in this repo |
| --- | --- | --- |
| 1 | CONTEXT | `AGENTS.md` |
| 2 | BEHAVIOR | `.cursor/rules/` (3 scoped `.mdc` examples) |
| 3 | TOOLS | `.cursor/mcp.json` (empty) + `.cursor/mcp.example.json` |
| 4 | WORKFLOW | `.cursor/commands/` **and** `.cursor/skills/` |
| 5 | DELEGATION | `.cursor/agents/` |
| 6 | ENFORCEMENT | `.cursor/hooks.json` → `.cursor/hooks/*.sh` |
| 7 | BOUNDARY | `.cursorignore` + `.cursorindexingignore` |

**Rules are advice. Hooks are enforcement.** Rules tell the agent what to do;
hooks in this repo veto destructive shell commands, block reads of likely secrets,
and audit agent edits.

## Start here

1. Use this repository as a template or copy the `.cursor/` tree into an existing project.
2. Read `AGENTS.md`, then run `bash scripts/validate-starter.sh`.
3. Copy `.cursor/mcp.example.json` into a local MCP config; set env vars from `.env.example`.
4. When forking into an app repo, replace the runtime command section in `AGENTS.md`.
5. Delete examples you do not need — focused context beats more context.
6. Ask Cursor to read `AGENTS.md` and propose project-specific refinements before coding.

## File guide — what each piece does

| Path | Purpose | Customize when |
| --- | --- | --- |
| `AGENTS.md` | Operating manual, architecture, commands, definition of done | Always — first file to rewrite for your stack |
| `.cursor/rules/production-minded-changes.mdc` | Global baseline (`alwaysApply: true`) | Tune boundaries for your team |
| `.cursor/rules/api-boundaries.mdc` | API/route conventions (glob-scoped) | Point globs at your API paths |
| `.cursor/rules/testing-expectations.mdc` | Test quality bar (glob-scoped) | Match your test layout |
| `.cursor/commands/code-review.md` | `/code-review` workflow | Align with your review checklist |
| `.cursor/commands/ship.md` | `/ship` workflow | Point at your real validation commands |
| `.cursor/skills/release-readiness/SKILL.md` | Auto-loaded release expertise | Trim for your deploy model |
| `.cursor/skills/ship-check/SKILL.md` | Manual-only skill (`disable-model-invocation: true`) | Shows skills-as-commands pattern |
| `.cursor/agents/code-reviewer.md` | Read-only correctness reviewer | Adjust focus areas |
| `.cursor/agents/security-auditor.md` | Read-only security reviewer | Add org-specific threat model |
| `.cursor/mcp.json` | Committed team MCP config | Add pinned servers after review |
| `.cursor/mcp.example.json` | GitHub / Sentry / Linear shape with env vars | Replace placeholder packages |
| `.cursor/hooks/guard-command.sh` | `beforeShellExecution` — blocks destructive commands | Add org-specific shell patterns |
| `.cursor/hooks/scan-secrets.sh` | `beforeReadFile` — blocks likely secret reads | Tighten patterns for your stack |
| `.cursor/hooks/audit-edit.sh` | `afterFileEdit` — append-only edit log | Swap for a real formatter if you have one |
| `.cursorignore` | Block agent access (including @-mentions) | List secret and vendor paths |
| `.cursorindexingignore` | De-index without blocking reads | List generated / vendored trees |
| `scripts/validate-starter.sh` | Self-check for structure, JSON, and hook behavior | Extend for your app's CI commands |

## What is included

- Three scoped rules plus one global baseline
- `/code-review` and `/ship` commands
- Auto-loaded `release-readiness` and manual-only `ship-check` skills
- Read-only `code-reviewer` and `security-auditor` subagents
- Empty committed `mcp.json` plus a multi-server example using env vars
- Three working hooks (shell guard, secret scan, edit audit)
- Ignore split demonstrated concretely
- `.env.example`, validation script, and contribution guidance

## Design principles

- **Specific over generic:** encode commands and constraints that can be verified.
- **Scoped over giant:** attach rules and expertise only where they matter.
- **Advisory plus deterministic:** use instructions for judgment and scripts for invariants.
- **Safe by default:** no secrets, destructive commands, or automatic external writes.
- **Human accountable:** the agent proposes; the team reviews and owns the result.

## Security notes

`mcp.json` ships empty so cloning is safe. Enable MCP only after pinning packages
and setting env vars locally. Never commit API keys, tokens, private URLs, customer
data, or machine-specific paths.

Hooks improve consistency, but they are not a security boundary. Keep branch
protection, CI checks, code review, secret scanning, and least-privilege credentials
in place.

## Official references

- [Cursor Rules](https://cursor.com/docs/rules)
- [Cursor Agent Skills](https://cursor.com/docs/skills)
- [Cursor Subagents](https://cursor.com/docs/subagents)
- [Cursor MCP](https://cursor.com/docs/mcp)
- [Cursor Hooks](https://cursor.com/docs/hooks)

## License

MIT

---

Built by [Weidong Shi](https://weidong-shi.com) as part of **AI in Action**.
