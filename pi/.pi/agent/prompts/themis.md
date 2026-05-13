---
description: Verify Hermes work with independent review and improvement suggestions
argument-hint: "<plan path, request, or scope>"
---

Use `pi-subagents` to verify work that was just implemented, usually after `/hermes`.

Verification scope:

$ARGUMENTS

Act as the parent orchestrator. This is a review, verification, and improvement workflow. Do not make code changes unless I explicitly approve fixes after your review synthesis.

Workflow:
1. Read the original plan/request when provided, then inspect the current repository state and current diff.
2. Identify the intended scope, files changed, likely behavioral impact, and validation already performed.
3. Launch parallel fresh-context `reviewer` subagents with distinct angles:
   - correctness, regressions, and edge cases
   - test coverage, validation quality, and missing checks
   - simplicity, maintainability, repository fit, and whether the solution can be better
4. Give every reviewer a self-contained brief. Tell them to inspect the repository and diff directly, stay read-only, avoid style nitpicks, and report only evidence-backed findings with file/symbol references.
5. Independently inspect the most important changed files yourself. Do not just relay subagent output.
6. Run focused validation yourself when practical, or clearly state why you did not run it.
7. Synthesize all evidence into:
   - `Verdict`: ship / fix first / unclear
   - `Blockers`: must-fix correctness or scope issues
   - `Fixes worth doing now`: safe improvements inside the approved scope
   - `Optional improvements`: nice-to-have or future work
   - `Feedback to ignore/defer`: reviewer points that are not worth acting on now
   - `Validation`: checks run, results, and gaps
8. If fixes are needed, ask for my approval before launching a `worker` to apply them.
9. Do not commit changes.

Expected final response:
- Verdict
- Highest-priority findings
- Whether Hermes's work matches the approved scope
- Checks run and results
- Recommended next action
