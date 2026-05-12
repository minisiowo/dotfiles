---
description: Create or refine AGENTS.md guidance using pi-subagents
argument-hint: "[target path]"
---

Use `pi-subagents` to create or refine a sparse network of repository-specific `AGENTS.md` files.

Target path:

$ARGUMENTS

If no target path is provided, use the current project root.

Act as the parent orchestrator. This workflow may edit only `AGENTS.md` files.

Workflow:
1. Check whether the target root already has `AGENTS.md`; preserve useful existing instructions.
2. Survey the root enough to understand project purpose, languages/frameworks, package boundaries, important docs, build/test entrypoints, and ignored/generated areas.
3. Use `scout` or `context-builder` subagents for independent subtree reconnaissance where useful. Ask them to stay read-only and report whether local `AGENTS.md` guidance is warranted.
4. Create nested `AGENTS.md` files only where local guidance materially helps future agents: distinct apps/packages/services/libs, tests with special harnesses, infra, migrations, generated-code boundaries, or local hazards.
5. Write/update the root `AGENTS.md` last with concise project-wide guidance.
6. Use durable headings:
   - root: `# Project Agent Guide`
   - nested: `# Agent Guide: <path>`
7. Avoid volatile status claims, duplicated command boilerplate, invented commands, and exhaustive file catalogs.
8. Do not commit changes.

Expected final response:
- Files created or updated
- Directories intentionally skipped
- Commands/checks used
- Any remaining uncertainty
