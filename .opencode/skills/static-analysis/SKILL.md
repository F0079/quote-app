---
name: Static analysis
description: Static analysis, linting, and formatting rules for the quote app. Which tools run, when, and what blocks a change.
---

# Static analysis

Static analysis runs on every change. There is no build yet; enable the tooling
below as soon as the Gradle project exists, then treat these as required checks.

## Tools & responsibilities

| Tool | Scope | Blocks the change on |
|------|-------|----------------------|
| `ktlint` | Kotlin style/format (single formatting authority) | any error |
| `detekt` | Selective naming/structure rules (buildUponDefaultConfig=false, allRules=false) | `error` severity |
| Android Lint | Android/manifest/resource issues | `error` severity; review warnings |
| Dependency check | proprietary / Play-Services dependencies (FR-60) | any match |

**Formatting:** ktlint is the single formatting authority. Do not add detekt-formatting or Spotless. OpenCode's formatter remains off; use `./gradlew ktlintFormat` to fix formatting once Gradle exists.

## Commands (once the Gradle project exists)

```sh
./gradlew ktlintCheck detekt :app:lintDebug
./gradlew ktlintFormat  # for fixups
./gradlew :app:dependencies | grep -Ei 'play-services|com\.google\.android\.gms'   # must be empty
```

Use the actual module/variant if not `app/debug`. The conventions package pins: ktlint-gradle 14.2.0, ktlint engine 1.7.1, detekt 1.23.8; verify Kotlin/AGP/Gradle/JDK compatibility before upgrading detekt (API/config differ for 2.x).

## Rules

- Fix violations. Do not suppress with `@Suppress` unless the suppression is justified in a nearby comment.
- Never lower a rule's severity, generate/expand baselines, or disable rules merely to make a build pass.
- Generated code under `build/` and `**/generated/**` are excluded from analysis.
- Do not claim a check passed unless it ran successfully. Report missing SDK/dependency resolution/toolchain errors separately.

## While the repo is spec-only

The applicable checks are on the documents:

- Markdown tables parse; FR IDs are unique and referenced IDs resolve (run `/spec-check`).
- JSON/JSONC examples in the contract are valid.
- No dangling references in `AGENTS.md` or `.opencode/**`.
- `.editorconfig` and `config/detekt/detekt.yml` exist in the repo root; they remain inert until the Gradle project is initialized. When Gradle exists, apply the conventions package's integration snippets (root/module build files) with the pinned versions.
