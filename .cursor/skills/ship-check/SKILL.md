---
name: ship-check
description: Manual pre-ship checklist — invoke explicitly before merge or deploy. Same intent as /ship but as a manual-only skill.
disable-model-invocation: true
---

# Ship check

Run only when the user explicitly invokes `/ship-check`.

## Steps

1. Confirm scope against `AGENTS.md` and the current diff.
2. If Cursor configuration changed, run `bash scripts/validate-starter.sh` (or your app's equivalent self-check).
3. Run applicable validation commands from `AGENTS.md`.
4. Return **GO**, **CONDITIONAL GO**, or **NO-GO** with evidence, blockers, and smallest next actions.

Never deploy, publish, or perform external writes unless explicitly authorized.
