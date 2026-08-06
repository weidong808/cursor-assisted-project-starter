# Handoff — cursor-assisted-project-starter

**Status: finalized (enterprise-aligned)** — ready to adopt into app repos.
Post copy on `weidong-website` is separate.

## Documentation map

| Doc | Audience |
| --- | --- |
| [README.md](./README.md) | Overview |
| [ADOPT.md](./ADOPT.md) | Copy into ArchLens, hub site, etc. |
| [ENTERPRISE.md](./ENTERPRISE.md) | Maps to Cursor security hardening checklist |
| [SECURITY.md](./SECURITY.md) | Steering vs enforcement; ignore limits |
| [templates/AGENTS.app.md](./templates/AGENTS.app.md) | Blank AGENTS.md for app repos |

**Validate:** `bash scripts/validate-starter.sh`

## Coverage summary

- **8 rules** — 2 always-on, 3 glob-scoped, 3 agent-selected
- **2 commands** + **2 skills** (auto + manual-only)
- **2 readonly subagents**
- **5 hooks** — prompt, read, shell, MCP, edit audit
- **MCP** — empty committed config + stdio example with env interpolation
- **Ignore split** — block vs de-index

## Not in scope

- `projects.ts` on weidong-shi.com (template repo; linked from post first comment)
- Hub `videos.ts` entry (after LinkedIn publish)
