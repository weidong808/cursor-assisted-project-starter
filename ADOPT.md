# Adopting this starter in an app repo

Use this checklist when copying the control layer into a project such as
**ArchLens**, **weidong-website**, **HabitCheck**, or any Next.js / full-stack app.

## 1. Copy these paths

```text
AGENTS.md                 # start from templates/AGENTS.app.md — do not copy verbatim
.cursor/
  rules/
  commands/
  skills/
  agents/
  hooks/
  hooks.json
  mcp.json                # usually keep empty; enable via mcp.local.json
  mcp.example.json
.cursorignore
.cursorindexingignore
.env.example              # merge with app's existing env docs
scripts/validate-starter.sh   # rename or extend (see step 5)
```

Do **not** copy `HANDOFF.md` or LinkedIn-specific docs. **Do** read [SECURITY.md](./SECURITY.md) and [ENTERPRISE.md](./ENTERPRISE.md) before enabling hooks in production repos.

## 2. Rewrite `AGENTS.md` first

Start from [templates/AGENTS.app.md](./templates/AGENTS.app.md).

Replace the architecture and commands sections with facts from the target repo:

| Section | Source |
| --- | --- |
| Mission | One sentence about the app |
| Architecture | Entry points, key directories, stack |
| Commands | `package.json` scripts / Makefile targets that actually exist |
| Boundaries | App-specific (auth, billing, PII, deploy) |
| Definition of done | Same structure; point at the app's real CI gates |

Example for a Next.js app with Vitest:

```markdown
## Commands

- Install: `npm ci`
- Dev: `npm run dev`
- Lint: `npm run lint`
- Typecheck: `npm run typecheck`
- Test: `npm test`
- Build: `npm run build`
```

## 3. Tune rules (`.cursor/rules/`)

| Rule | Action |
| --- | --- |
| `production-minded-changes.mdc` | Keep as global baseline; tweak tone if needed |
| `protect-sensitive-paths.mdc` | Add app-specific sensitive paths (e.g. `fixtures/` with synthetic PII) |
| `api-boundaries.mdc` | Point `globs` at your API layer (`app/api/**`, `app/actions/**`, etc.) |
| `testing-expectations.mdc` | Point `globs` at your test layout (`tests/**`, `**/*.test.ts`) |

Remove rules that do not apply. Add focused rules only when the agent repeats the same mistake twice.

**Cursor rule types (quick reference):**

| `alwaysApply` | `globs` | `description` | When it loads |
| --- | --- | --- | --- |
| `true` | — | — | Every Agent session |
| `false` | set | — | When matching files are in context |
| `false` | — | set | When Agent decides it's relevant |
| `false` | — | — | Manual `@rule` mention only |

## 4. Workflows: commands vs skills vs agents

| Mechanism | Invoke | Auto-load? | Best for |
| --- | --- | --- | --- |
| **Command** `.cursor/commands/ship.md` | `/ship` | No | Short, explicit workflows you type |
| **Skill** `.cursor/skills/release-readiness/` | `/release-readiness` or auto | Yes, when relevant | Multi-step expertise |
| **Skill** with `disable-model-invocation: true` | `/ship-check` only | No | Side-effect workflows (deploy, publish) |
| **Subagent** `.cursor/agents/code-reviewer.md` | Agent delegates via Task | Agent decides | Isolated review in separate context |

Cursor 2.4+ migrates eligible commands to skills via `/migrate-to-skills`. Keeping both `/ship` and `/ship-check` in the starter shows the before/after pattern.

**Skill folder name must match `name:` in frontmatter.**

## 5. Validation script

Extend `scripts/validate-starter.sh` or add `scripts/validate-project.sh` that runs:

1. Structure checks (same as starter)
2. Your app's CI subset: `npm run lint && npm run typecheck && npm test`

Point `/ship` and `release-readiness` at this script once it exists.

## 6. MCP

1. Leave committed `.cursor/mcp.json` empty unless the whole team shares the same pinned servers.
2. Copy `.cursor/mcp.example.json` → `.cursor/mcp.local.json` for personal tokens.
3. Document required env vars in `.env.example`.

Never commit tokens. Use `${env:VAR_NAME}` in MCP config.

## 7. Hooks

1. Keep `guard-command.sh` — add prod-specific blocked commands.
2. Keep `scan-secrets.sh` — extend patterns for your secret formats.
3. Replace `audit-edit.sh` with your formatter when you have one (`prettier --write`, etc.).

On Windows, hooks run through Git Bash when configured as `bash .cursor/hooks/....sh`.

## 8. Ignore files

| File | Put here |
| --- | --- |
| `.cursorignore` | Secrets, local overrides, anything that must never enter context (including @-mentions) |
| `.cursorindexingignore` | `node_modules/`, build output, large vendored trees — still readable if explicitly requested |

## 9. Rollout order (recommended)

1. `AGENTS.md` + `protect-sensitive-paths` + ignore files
2. Scoped rules for your stack
3. `/ship` pointing at real CI commands
4. Subagents for review on larger PRs
5. Hooks last — after you know which commands actually run in your environment

## 10. Verify

```bash
bash scripts/validate-starter.sh
# then your app gates, e.g.:
npm run lint && npm run typecheck && npm test && npm run build
```

Open **Customize → Rules / Skills / Agents** in Cursor and confirm everything appears.

## Per-app notes (Weidong Shi stack)

| App | First customization |
| --- | --- |
| **archlens-ai** | Commands from `package.json`; globs for `app/actions/`, `lib/verify/`; eval gate in ship checklist |
| **weidong-website** | Content paths in rules; Vercel author commit convention in ship skill |
| **HabitCheck / RetireCheck / etc.** | Domain boundaries in `AGENTS.md`; PWA/offline rules if needed |

These are starting points — refine after the first agent session on each repo.

## 11. Enterprise rollout

For teams with Cursor Enterprise, pair this repo with dashboard controls —
see [ENTERPRISE.md](./ENTERPRISE.md) for the full mapping.

| Phase | Action |
| --- | --- |
| Pilot | One non-critical repo + `AGENTS.md` + ignore files |
| Steer | Always-on rules + agent-selected rules; keep always-on count ≤ 3 |
| Enforce | Enable hooks; set `failClosed: true` on prompt/MCP guards |
| Scale | Team Rules in dashboard for org non-negotiables; MCP allowlist |
| Monitor | Audit logs → SIEM; extend `audit-edit.sh` or use hook → DLP API |

**Context budget:** Prefer scoped rules over more always-on rules. Enterprise
research recommends the narrowest activation mode that still fires when needed.
