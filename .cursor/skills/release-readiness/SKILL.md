---
name: release-readiness
description: Evaluate whether a change is safe and operationally ready to release. Use for release reviews, deployment preparation, and production-readiness checks.
---

# Release Readiness

## Workflow

1. Read `AGENTS.md`, the current diff, affected tests, and deployment documentation.
2. Identify user-visible behavior and affected dependencies.
3. Run the relevant format, lint, type, test, and build commands that actually exist.
4. Evaluate:
   - backward compatibility and migrations;
   - authentication, authorization, secrets, and data exposure;
   - failure handling, timeouts, retries, and idempotency;
   - logs, metrics, traces, alerts, and support diagnostics;
   - performance and cost changes;
   - rollout, feature flags, and rollback;
   - documentation and operator impact.
5. Produce a GO, CONDITIONAL GO, or NO-GO recommendation.
6. List evidence, blockers, owners, and the smallest next actions.

Never perform a deployment or external write unless explicitly requested and authorized.
