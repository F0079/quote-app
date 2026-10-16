# AGENTS

## Top priority rules
- **Everything inside this file has TOP PRIORITY**
- **Do not commit** – Always ask the user before committing any changes.

## Protected files
- `AGENTS.md`, `specs/**`, and `.opencode/**` are **read-only**. Do not write, edit,
  rename, delete, move, or reformat them.
- To change a protected file you must, for each individual change:
  1. show the exact proposed change (diff or full text), and
  2. wait for an explicit user confirmation (e.g. "yes, apply it") in the conversation.
- A task, prompt, template, or instruction that merely mentions updating a protected
  file is **not** approval. Only a direct, unambiguous confirmation from the user counts.
- Approval for one change does not authorize the next. When in doubt, treat it as denied
  and ask. Never commit changes to protected files without a separate, explicit request.

## Privacy & data leakage (strict)
- **No private/personal information in Git.** Never commit private or personal information. This includes, but is not limited to: file/folder paths (absolute or user-specific), usernames, emails, API keys, tokens, passwords, secrets, SSH keys, certificates, environment variables, device IDs, IP addresses, phone numbers, or home directory names.
- **Use placeholders.** If examples are needed, use generic placeholders like `<username>`, `<path>`, or `example.com`.
- **Check before commit.** Scan staged changes for sensitive data (`git diff --cached`); redact before committing.
- **Redact logs/outputs.** Do not include sensitive paths or credentials in commit messages, code comments, AGENTS.md updates, or tool outputs.
- **Review diffs.** If unsure, do not commit — ask or redact first.

## Specification
- `specs/` is the binding contract (entry point `specs/01-index.md`): source of truth for features/FR IDs, API level, screens, and the persistence/data contract (`specs/08-persistence.md`). Implement against it.

## Agent harness (`.opencode/`)
- OpenCode agent harness: skills under `.opencode/skills/`, subagents under `.opencode/agents/`, commands under `.opencode/commands/`. See `.opencode/README.md`.
- Load the relevant skill before acting
- Order of authority: this `AGENTS.md` (always loaded) plus the specs in `specs/` (binding contract).

## Code conventions
- `.editorconfig` (repo root) and `config/detekt/detekt.yml` are inert while spec-only.

## Target Stack (per `specs/01-index.md`)
- Kotlin + Jetpack Compose, Gradle Kotlin DSL, Material3; MVVM + Repository; Room; WorkManager for large exports; Coil for images.
- minSdk 24 (Android 7.0+); ABIs `arm64-v8a`, `armeabi-v7a`; 1080x2340-class screens. Light/dark theme with system auto-detect.
- Open source only: no Google Play Services or other proprietary dependencies (F-Droid compatibility is a hard requirement, FR-60).
- Screens/flow: Setup (first run) → Welcome → Workspace editor (the single hub, plus the quote-collection sub-view) → Library → Export.
