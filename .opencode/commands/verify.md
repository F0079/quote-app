---
description: Run static analysis and the test suite at the defined scope
---
Run the repository verification steps and report the results.

1. Detect available tooling (`ls`, `./gradlew tasks`). If there is no build yet, say so and run only the document checks instead.
2. Run static analysis per the `static-analysis` skill (ktlint, detekt, Android Lint) and report violations with file and line.
3. Run tests per the `testing` skill and summarize failures with the smallest reproduction and the affected FR IDs.
4. Flag anything that could only run on a device or emulator.

$ARGUMENTS
