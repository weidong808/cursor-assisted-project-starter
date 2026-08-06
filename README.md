# Cursor-Assisted Project Starter

Production-minded Cursor control layer you can copy into any repository.

Most teams re-explain architecture, conventions, tests, and safety boundaries on
every agent session. This starter encodes them once — rules, skills, subagents,
hooks, and ignore boundaries — so Cursor starts with useful context and
deterministic guardrails.

**Adopting in your app?** [ADOPT.md](./ADOPT.md) · **Enterprise?** [ENTERPRISE.md](./ENTERPRISE.md) · **Security model?** [SECURITY.md](./SECURITY.md)

## What's in the box

| Surface | Location | Cursor behavior |
| --- | --- | --- |
| Context | `AGENTS.md` | Operating manual (rewrite per app) |
| Rules | `.cursor/rules/*.mdc` | 2 always-on + 3 scoped + 3 agent-selected |
| Commands | `.cursor/commands/*.md` | `/code-review`, `/ship` |
| Skills | `.cursor/skills/*/SKILL.md` | Auto-loaded or manual-only expertise |
| Subagents | `.cursor/agents/*.md` | Isolated reviewers (readonly) |
| MCP | `.cursor/mcp.json` + example | Team tool connections via env vars |
| Hooks | `.cursor/hooks.json` + scripts | 5 hooks — prompt, read, shell, MCP, edit audit |
| Boundaries | `.cursorignore`, `.cursorindexingignore` | Block vs de-index |

**Rules advise. Hooks enforce.** That split is intentional.

## Quick start

```bash
git clone https://github.com/weidong808/cursor-assisted-project-starter.git
cd cursor-assisted-project-starter
bash scripts/validate-starter.sh
```

Then open in Cursor → **Customize** → confirm rules, skills, and agents loaded.

## File guide

| Path | Customize when |
| --- | --- |
| `AGENTS.md` | **Always first** — stack, architecture, real commands |
| `production-minded-changes.mdc` | Rarely — global baseline |
| `protect-sensitive-paths.mdc` | Add app-specific sensitive paths |
| `api-boundaries.mdc` | Point globs at your API/actions layer |
| `testing-expectations.mdc` | Point globs at your test files |
| `database-migrations.mdc` | SQL/migration paths |
| `plan-before-change.mdc` | Agent-selected — plan before multi-file work |
| `verify-before-done.mdc` | Agent-selected — run real CI before "done" |
| `small-focused-diffs.mdc` | Agent-selected — minimal diffs |
| `.cursor/commands/*` | Align with your review/ship checklist |
| `.cursor/skills/*` | Trim or extend workflows |
| `.cursor/agents/*` | Tune delegation descriptions |
| `.cursor/hooks/*` | Add blocked commands; swap audit for formatter |
| `.cursor/mcp.example.json` | Pin reviewed MCP packages |
| ignore files | Secrets → block; vendor/build → de-index |

Details: [ADOPT.md](./ADOPT.md) · hook behavior: [.cursor/hooks/README.md](./.cursor/hooks/README.md)

## Design principles

- **Specific over generic** — verifiable commands and constraints
- **Scoped over giant** — rules and skills attach where they matter
- **Advisory + deterministic** — markdown for judgment, scripts for invariants
- **Safe by default** — empty MCP, no secrets, hooks fail open except explicit denies
- **Human accountable** — agent proposes; team reviews and owns the result

## LinkedIn post mapping (optional)

Companion repo for *Seven Files That Never Ship to Production* (AI in Action). The
post combines commands+skills as one idea and splits ignore into two files — this
repo implements every surface. Post copy may change; this repo is the source of
truth for Cursor behavior.

## Security

`mcp.json` ships empty. Enable MCP only after pinning packages and setting env vars
from `.env.example`. Hooks are not a security boundary — keep CI, branch protection,
and secret scanning in place.

## References

- [Cursor Rules](https://cursor.com/docs/rules)
- [Agent Skills](https://cursor.com/docs/skills)
- [Subagents](https://cursor.com/docs/subagents)
- [MCP](https://cursor.com/docs/mcp)
- [Hooks](https://cursor.com/docs/hooks)

## License

MIT — [Weidong Shi](https://weidong-shi.com) · **AI in Action**
