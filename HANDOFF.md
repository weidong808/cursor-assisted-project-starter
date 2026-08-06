# Handoff — cursor-assisted-project-starter

Companion repo for the **Seven Files That Never Ship to Production** LinkedIn
post. Cross-read
`weidong-website/docs/linkedin-cursor-structure/HANDOFF.md` for the full
three-surface publish chain (A → C → publish → B).

## Status

**Repo:** https://github.com/weidong808/cursor-assisted-project-starter  
**Visibility:** public  
**Validate:** `bash scripts/validate-starter.sh` (includes hook smoke tests)

## Contract with the post

| Path | Status |
| --- | --- |
| `AGENTS.md` | Filled for this starter; runtime TODOs are for forking into app repos |
| `.cursor/rules/` | 3 scoped `.mdc` files + 1 global baseline |
| `.cursor/mcp.json` | Empty (safe default) + `mcp.example.json` (GitHub/Sentry/Linear via env) |
| `.cursor/commands/` | `/code-review`, `/ship` |
| `.cursor/skills/` | Auto `release-readiness` + manual `ship-check` (`disable-model-invocation`) |
| `.cursor/agents/` | `code-reviewer`, `security-auditor` (readonly) |
| `.cursor/hooks.json` | `beforeShellExecution`, `beforeReadFile`, `afterFileEdit` |
| `.cursorignore` / `.cursorindexingignore` | Block vs de-index split from post item 7 |

Hooks live in `.cursor/hooks/` per Cursor convention. `guard-command.sh` parses
JSON stdin (required by the hooks spec — raw-text parsing does not work).

## Not in scope

- **`projects.ts` on weidong-shi.com** — template repo only; linked from the post
  first comment, not listed as a Work app.
- **Hub card** — website handoff task 5 after LinkedIn publish (`videos.ts` entry).

## Constraints

- No secrets in git. Hooks are not a security boundary.
- Small enough to read in ten minutes — a reference, not a framework.
