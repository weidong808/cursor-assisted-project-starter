---
name: ship-check
description: Manual release checklist before merge or deploy. Use only when explicitly invoked.
disable-model-invocation: true
---

# Ship check

Run only when the user explicitly invokes this skill — same workflow as `/ship`, but packaged as a skill with auto-invocation disabled.

1. Confirm scope against `AGENTS.md` and the current diff.
2. Run `bash scripts/validate-starter.sh` if Cursor configuration changed.
3. Run applicable validation commands documented in `AGENTS.md`.
4. Return GO, CONDITIONAL GO, or NO-GO with evidence, blockers, and smallest next actions.

Never deploy, publish, or perform external writes unless explicitly authorized.
