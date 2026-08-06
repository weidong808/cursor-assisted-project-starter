# Handoff — cursor-assisted-project-starter

Companion repo for the **Seven Files That Never Ship to Production** LinkedIn
post. Written for the next agent to pick up; cross-read
`weidong-website/docs/linkedin-cursor-structure/HANDOFF.md` for the full picture.

## Scope — three surfaces, one story

| Surface                                         | State                                      |
| ----------------------------------------------- | ------------------------------------------ |
| **A.** `weidong-website/docs/linkedin-cursor-structure/` — post package | ✅ complete (see website handoff) |
| **B.** `weidong-website/src/` — hub integration | ❌ not started (website handoff task 5)    |
| **C.** this repo — starter                      | ✅ public — `validate-starter.sh` passes |

They depend on each other. The post (A) promises this repo in its first comment
and on the card footer, so **C gates publication**. The hub card (B) needs a
live LinkedIn URL, so it can only come last. Order is **A → C → publish → B**.

## C. This repo — status

**Repo:** https://github.com/weidong808/cursor-assisted-project-starter  
**Visibility:** public  
**Validate:** `bash scripts/validate-starter.sh`

### Contract with the post

The caption names seven layers; the card tags them CONTEXT / BEHAVIOR / TOOLS /
WORKFLOW / DELEGATION / ENFORCEMENT / BOUNDARY. This repo must use the same
names and keep **hooks as the enforcement differentiator** — rules are advisory,
hooks run.

| Path                 | In repo                                           |
| -------------------- | ------------------------------------------------- |
| `AGENTS.md`          | Operating manual — replace TODOs when forking     |
| `.cursor/rules/`     | Scoped `.mdc` rules                               |
| `.cursor/mcp.json`   | Example MCP; secrets via env, not committed       |
| `.cursor/commands/`  | Repeatable workflows                              |
| `.cursor/skills/`    | Reusable expertise                                |
| `.cursor/agents/`    | Focused subagents                                 |
| `.cursor/hooks.json` | Deterministic guards (`scripts/guard-command.sh`) |

### Done means (publication gate)

A reader who runs `git clone` gets a Cursor project where the agent behaves
differently on the first prompt. When that holds, tick the blocker in
`weidong-website/docs/linkedin-cursor-structure/PLAYBOOK.md` pre-flight and the
post can ship as written.

### Remaining work here

1. **Fork customization** — replace runtime `TODO` commands in `AGENTS.md` when
   copying into a real project (expected).
2. **After publish (website task 5)** — prepend hub entry to `videos.ts` with the
   live lnkd.in URL; GIF already staged on the site.

## Constraints

- No secrets in git. Hooks improve consistency; they are not a security boundary.
- Keep the repo small enough to read in ten minutes — a reference, not a framework.
- Commit author for website deploys: `Weidong Shi <weidongshi@hotmail.com>`.
