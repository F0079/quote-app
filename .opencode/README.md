# Agent harness

OpenCode agent harness for this project. Skills, subagents, and commands live in
this directory (`.opencode/`) and are discovered natively by OpenCode.

## Layout

| Path | Purpose |
|------|---------|
| `agents/*.md` | Subagents (`mode: subagent`), e.g. `spec-guardian`, `implementer`, `test-author`. |
| `commands/*.md` | Slash/reusable command templates (e.g., `/spec-check`, `/verify`). |
| `skills/<id>/SKILL.md` | Task-specific instructions loaded on demand. |
| (repo root) `opencode.jsonc` | OpenCode config: permissions, policies, references. |
| (repo root) `AGENTS.md` | Always-on project rules; the source of top-priority instructions. |

## Contents

- `agents/spec-guardian` — read-only guard that checks docs and code against the binding contract.
- `agents/implementer` — implements features strictly from the contract.
- `agents/test-author` — writes and updates tests at the scope defined by the testing conventions.
- `commands/spec-check`, `commands/verify`
- `skills/coding-conventions` — Kotlin/Compose/Room conventions, layout, naming, dependency policy.
- `skills/static-analysis` — linters/static analysis, when to run, blocking rules.
- `skills/testing` — test scope and definition of done.

## Notes

- Always-on rules live in root `AGENTS.md`. Skills are loaded on demand.
- Subagent and command frontmatter is OpenCode-specific; skills use the portable `SKILL.md` convention.
