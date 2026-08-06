# Cursor-Assisted Project Starter

A production-minded, reusable control layer for Cursor projects.

Most teams repeatedly explain architecture, conventions, tests, and safety boundaries to their coding agent. This starter moves that knowledge into the repository so Cursor can begin each task with useful context and deterministic guardrails.

## The seven layers

| Layer | Purpose |
|---|---|
| `AGENTS.md` | Project operating manual and definition of done |
| `.cursor/rules/` | Persistent, scoped engineering decisions |
| `.cursor/commands/` | Repeatable workflows invoked on demand |
| `.cursor/skills/` | Reusable expertise loaded when relevant |
| `.cursor/agents/` | Focused specialists with isolated responsibilities |
| `.cursor/mcp.json` | Safe, project-level connections to external tools |
| `.cursor/hooks.json` | Deterministic checks around agent actions |
| `.cursorignore` / `.cursorindexingignore` | Block vs de-index boundaries |

## Start here

1. Use this repository as a template or copy the files into an existing project.
2. Replace every `TODO` with your project's actual commands and boundaries.
3. Delete examples you do not need; focused context beats more context.
4. Keep credentials out of git. Use environment variables or your approved secret manager.
5. Run `bash scripts/validate-starter.sh`.
6. Ask Cursor to read `AGENTS.md` and propose project-specific refinements before coding.

## What is included

- A concise operating manual
- A scoped rule for production-minded changes plus API and testing examples
- `/code-review` and `/ship` commands
- Release-readiness and manual-only `ship-check` skills
- Read-only code-review and security-auditor subagents
- A disabled-by-default MCP example using environment variables
- Hooks plus portable validation scripts
- `.cursorignore` and `.cursorindexingignore` with the block vs de-index split
- A starter self-check and contribution guidance

## Design principles

- **Specific over generic:** encode commands and constraints that can be verified.
- **Scoped over giant:** attach rules and expertise only where they matter.
- **Advisory plus deterministic:** use instructions for judgment and scripts for invariants.
- **Safe by default:** no secrets, destructive commands, or automatic external writes.
- **Human accountable:** the agent proposes; the team reviews and owns the result.

## Customize without creating noise

Start with three questions:

- What does every contributor need to know before changing this repository?
- Which mistakes have already happened twice?
- Which requirements can be checked deterministically?

Encode the answers in the smallest appropriate layer. Do not turn the repository into a prompt archive.

## Security notes

The MCP configuration is an inert example until you deliberately configure a server. Never commit API keys, tokens, private URLs, customer data, or machine-specific paths. Review any third-party MCP server and pin dependencies before enabling it.

Hooks improve consistency, but they are not a security boundary. Keep branch protection, CI checks, code review, secret scanning, and least-privilege credentials in place.

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
