---
name: Coding conventions
description: Coding, formatting, naming, dependency, and project-structure conventions for the quote app. Load before writing or changing Kotlin/Compose/Room code.
---

# Coding conventions — quote app

This repo is spec-first: the specs in `specs/` (entry point `specs/01-index.md`) are the binding contract. Read the
relevant FR IDs and schema sections before coding. When the contract and these
conventions disagree, the contract wins.

## Stack

- Kotlin + Jetpack Compose, Gradle Kotlin DSL, Material3.
- Persistence: Room. Architecture: MVVM + Repository. WorkManager for large exports. Coil for images.
- minSdk 24 (Android 7.0+); ABIs `arm64-v8a` and `armeabi-v7a`; targets 1080x2340-class screens.
- Open source only: no Google Play Services or other proprietary dependencies (FR-60).

## Language of writing

- All documents are English (`specs/**`, `.opencode/**`, `AGENTS.md`).
- Code, identifiers, KDoc, and code comments are English.
- User-facing text lives in `res/values/strings.xml`; never hard-code UI strings.

## Package & module layout

- One Gradle module until there is a reason to split.
- Layers: `data` (Room, repository implementations, seed loaders), `domain` (models, repository interfaces, use cases), `ui` (screens, components, view models, theme).
- `ui` must not depend on Room entities; map entity <-> domain model in `data`.

## Naming & style

- Types `UpperCamelCase`; functions/properties `lowerCamelCase`; constants `UPPER_SNAKE_CASE`. Follow Kotlin conventions for objects and backing properties.
- Composables are noun-like `UpperCamelCase`. Function-returning composables are `lowerCamelCase`; `@Composable` functions that return `Unit` are `UpperCamelCase`. (The `.editorconfig` and ktlint naming ignore `@Composable` on purpose.)
- Room entities end in `Entity`; domain models use the plain name (see the contract's data models).
- Booleans read as predicates (`isDraft`, `hasPhoto`).
- Follow the contract's field and column names exactly (e.g. `quoteMarkStyle`, `cropX`).
- Use four spaces, LF, UTF-8, final newline. Max line length 120 chars (ktlint exceptions as needed).
- Opening braces on declaration line; always use braces for `if/else`.
- Trailing commas in multiline parameter/argument lists (ktlint enforced).
- Explicit imports only; no wildcard imports.
- Prefer `val` and read-only collection interfaces. Use `var`/mutable collections only when required.
- Declare return types on non-private functions (including `Unit`). Local inferred types are fine when clear.
- Expression bodies for short obvious expressions; block bodies for multistep operations.
- Early returns when they reduce nesting; avoid unnecessary abstraction.
- Use `it` only for short unambiguous lambdas; name parameters in nested lambdas.
- Avoid nested scope functions; use intermediate variables when they clarify.
- Include units in numeric names where ambiguous (e.g., `exportLongEdgePx`). Document normalized coordinates/anchors/permitted ranges in KDoc where non-obvious.
- Avoid catch-all names like `Utils`/`Helpers`; use meaningful domain names (Quote, SavedProject, TextStyle, Crop, ExportConfig).

## Compose

- Screens are stateless where possible: pass state down, events up. View models expose `StateFlow`.
- Hoist state; no business logic in composables.
- Use Material3 theming and support light/dark through the theme; never hard-code colors.
- Keep `@Preview` functions for visual components.
- Reusable components accept `modifier: Modifier = Modifier` as the first optional parameter and apply it to the root element.
- Event callbacks use `on*` naming (e.g., `onQuoteSelected`, `onTextChanged`, `onExportClicked`).
- Parameter order: required params first, then `modifier`, then remaining optional params; trailing `content` lambda where applicable.

## Room

- Entities are plain data holders. Use `@ColumnInfo(name = ...)` matching the contract.
- Schema changes require a migration; never use destructive fallback for the library.
- The library must survive a device restart (see the contract).

## Errors & logging

- No silent failures; surface user-relevant problems (e.g. the overflow warning, FR-53) in the UI.
- Catch specific exceptions; never swallow without handling.
- Do not log personal data or file paths at info level.
- Explain non-obvious contracts, reasons, and side effects with KDoc/comments. Do not add boilerplate to trivial declarations.

## Dependencies

- Add a dependency only if the contract needs it and it is open source. Check the license and the F-Droid policy (no Play Services) first.
- Keep the set small; prefer platform APIs.

## When unsure

- If the contract does not specify behavior, do not invent it — flag the gap instead (see the `spec-guardian` agent).
