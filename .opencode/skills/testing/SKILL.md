---
name: Testing
description: Which tests to write and at what scope for the quote app — unit, Room integration, Compose UI, instrumentation, image/golden tests. Load before writing or changing tests.
---

# Testing

Test behavior that an FR ID describes. Put the FR ID in the test name or a
comment. Prefer the smallest scope that can actually prove the behavior.

## Scope ladder

| Scope | Location | Use for | Tooling |
|-------|----------|---------|---------|
| Unit (JVM) | `src/test/` | domain models, mappers, repositories with fakes, view models, effect/crop math | JUnit, `kotlin.test`, Turbine for flows |
| Room integration | `src/test/` or `src/androidTest/` | DAO queries, migrations, seeding from `assets/quotes.json` and `templates.json` | Room in-memory DB, `MigrationTestHelper` |
| Compose UI | `src/androidTest/` | screen behavior, editor gestures, style/template application | `createComposeRule`, semantics |
| Instrumentation | `src/androidTest/` | camera (CameraX), MediaStore/gallery, export to storage, share intent | AndroidX Test, `ActivityScenario` |
| Image/golden | `src/androidTest/` | canvas composition (photo vs solid color, effects, frame, text) | Roborazzi/Robolectric or device screenshots |

## Rules

- One behavior per test; name describes the behavior, not the method (`warnsWhenTextOverflows`).
- Deterministic: fix time and randomness; no network; no real gallery. Seed data is bundled.
- Unit tests must not need a device; use Robolectric only when the framework is unavoidable.
- Do not test Compose or Android framework internals.
- Every bug fix gets a regression test.
- If behavior is not specified by the contract, do not encode a guess as a test — flag it.

## Definition of done for a change

1. Affected behavior is covered at the lowest sufficient scope.
2. Static analysis passes (see `static-analysis`).
3. Tests pass locally; report anything that could only run on a device or emulator.
