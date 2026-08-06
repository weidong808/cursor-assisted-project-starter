---
name: release-readiness
description: Evaluate whether a change is safe and operationally ready to release. Use for release reviews, deployment preparation, and production-readiness checks before merge or ship.
---

# Release readiness

## When to use

- Before merge to main or a release branch
- After a feature is "code complete" but before deploy
- When the user asks about production readiness, rollback, or operational risk

## Workflow

1. Read `AGENTS.md`, the current diff, affected tests, and deployment documentation.
2. Identify user-visible behavior and affected dependencies.
3. Run the format, lint, type, test, and build commands documented in `AGENTS.md` — only those that exist.
4. Evaluate:
   - backward compatibility and migrations
   - authentication, authorization, secrets, and data exposure
   - failure handling, timeouts, retries, and idempotency
   - logs, metrics, traces, alerts, and support diagnostics
   - performance and cost changes
   - rollout, feature flags, and rollback
   - documentation and operator impact
5. Produce a **GO**, **CONDITIONAL GO**, or **NO-GO** recommendation.
6. List evidence, blockers, owners, and the smallest next actions.

Never perform a deployment or external write unless explicitly requested and authorized.
