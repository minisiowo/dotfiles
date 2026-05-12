---
description: Plan-first workflow using pi-subagents
argument-hint: "<request>"
---

Use `pi-subagents` for a plan-first workflow.

Request:

$ARGUMENTS

Act as the parent orchestrator. Do not implement code yet.

Workflow:
1. Clarify only if the request is blocking-ambiguous. Otherwise proceed from repository evidence.
2. Launch one or more `scout` or `context-builder` subagents to inspect the relevant repository areas. Use `context: "fresh"` for independent repository reconnaissance, and give each child a concrete scope.
3. Synthesize their findings into a repository-grounded implementation plan.
4. Include exact files, symbols, integration points, risks, edge cases, and verification commands/checks.
5. Save the plan as a new markdown file. Prefer `./plans/` if it exists; otherwise use `./athena-plans/`.
6. Do not edit source files, configs, or tests. Only create/update the plan file and its directory.
7. Ask for my approval before any implementation.

Expected final response:
- Plan file path
- Short summary of the implementation path
- Any assumptions or open questions
