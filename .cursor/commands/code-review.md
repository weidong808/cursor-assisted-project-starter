# Code review

Review the current diff as a skeptical senior engineer.

1. Establish intended behavior from the request and nearby code.
2. Inspect the diff and relevant call sites.
3. Check correctness, regressions, security, privacy, concurrency, error handling, accessibility, observability, and maintainability.
4. Verify tests exercise observable behavior and important failure paths.
5. Run the narrowest relevant validation commands documented in `AGENTS.md`.
6. Report findings by severity with file references and concrete fixes.
7. If there are no findings, say so explicitly and list residual risks or untested areas.

Do not edit files unless asked to implement the findings.

Consider delegating to the `code-reviewer` subagent for an isolated read-only pass on large diffs.
