# Handoff — cursor-assisted-project-starter

**Status: finalized** — Cursor-accurate reference template. Post copy is separate;
refine on `weidong-website` when ready.

## For agents

| Doc | Use |
| --- | --- |
| [README.md](./README.md) | Overview and file guide |
| [ADOPT.md](./ADOPT.md) | Copy into app repos (ArchLens, hub site, etc.) |
| [AGENTS.md](./AGENTS.md) | Operating manual — rewrite per target app |
| [.cursor/hooks/README.md](./.cursor/hooks/README.md) | Hook behavior and smoke tests |

**Validate:** `bash scripts/validate-starter.sh`

## Publish chain (website)

See `weidong-website/docs/linkedin-cursor-structure/HANDOFF.md` for A → C → publish → B.
This repo is surface **C**. Not listed in `projects.ts` — linked from the post first comment only.

## Constraints

- No secrets in git
- Skill folder name must match `name:` in frontmatter
- Keep the template readable in ~10 minutes — reference, not a framework
