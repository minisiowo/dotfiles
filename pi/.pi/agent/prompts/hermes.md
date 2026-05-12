---
description: Execute an approved plan using worker and reviewers
argument-hint: "<plan path or approved request>"
---

Use `pi-subagents` to execute this approved plan or approved implementation request.

Approved scope:

$ARGUMENTS

Act as the parent orchestrator and keep implementation authority clear.

Workflow:
1. Read the approved plan/request and inspect the current repository state.
2. If the scope is still ambiguous, ask one focused clarification before writing code.
3. Launch a single `worker` subagent to implement the approved scope. Give it a concrete handoff with:
   - approved requirements
   - relevant plan path or summary
   - non-goals
   - files/areas to inspect
   - acceptance criteria
   - validation expectations
4. After implementation, inspect the changed files and current diff yourself.
5. Launch parallel fresh-context `reviewer` subagents with distinct angles:
   - correctness and regressions
   - tests and validation gaps
   - simplicity and maintainability
6. Synthesize reviewer feedback into:
   - blockers
   - fixes worth doing now
   - optional/deferred improvements
   - feedback to ignore
7. If fixes are needed and stay within the approved scope, launch `worker` again with the synthesized fix list.
8. Run focused validation yourself when practical.
9. Do not commit changes.

Expected final response:
- What was implemented
- Files changed
- Checks run and results
- Remaining risks or follow-up items
