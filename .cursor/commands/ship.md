# Ship

Prepare the current change for merge or release.

1. Read `AGENTS.md` and confirm the diff matches the stated scope.
2. Run the project's validation commands that actually exist (see `AGENTS.md`).
3. If this repo's Cursor config changed, run `bash scripts/validate-starter.sh`.
4. Summarize user-visible behavior, validation evidence, rollback notes, and remaining risk.
5. Stop before any deploy, publish, or external write unless explicitly authorized.

Do not claim a check passed unless it was actually run.

For a structured checklist, use `/ship-check` (manual-only skill) or delegate to `release-readiness` when the agent should load release expertise automatically.
