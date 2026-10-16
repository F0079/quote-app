# Quoted — Native Android App (Kotlin + Jetpack Compose)

This is the entry point of the binding contract for the Quoted app. The topic files below
hold the details; implement against them.

## Summary

| Aspect | Description |
|--------|-------------|
| **Purpose** | Create quote images: a canvas with an optional photo or solid colour, an optional quote, and an optional frame, plus a library |
| **Platform** | Native Android app (no WebView/Capacitor) |
| **Processing** | 100% local; no cloud sync in the MVP |
| **Audience** | Users who make creative photo combinations on Android |
| **Core function** | A quote card on a canvas: background (photo or solid colour) + optional quote + optional frame; always saveable and exportable, plus a library |
| **Export path** | User-selectable (setup on first run) |
| **UI design** | Light mode and dark mode (auto-detection + toggle) |
| **Monetization** | Free and open source (no in-app purchases in the MVP) |

## Topic files

| File | Contents |
|------|----------|
| [`02-workspace.md`](02-workspace.md) | Workspace and canvas, photo, frames, quote collection |
| [`03-editor-image-text-style.md`](03-editor-image-text-style.md) | Quote overlay, text styles and templates, image effects and readability, editor behaviour |
| [`04-library-export.md`](04-library-export.md) | Library and management, export and sharing |
| [`05-setup-screen.md`](05-setup-screen.md) | Welcome screen, app screen and setup, UI/UX and user flow |
| [`06-non-functional-and-architecture.md`](06-non-functional-and-architecture.md) | Non-functional requirements, technical architecture |
| [`07-testing-distribution.md`](07-testing-distribution.md) | Testing, distribution and release, roadmap, open points |
| [`08-persistence.md`](08-persistence.md) | Store of record, persistence rules, Room schema, data models, repository interfaces |

## Functional requirements map

| File | FR IDs |
|------|--------|
| `02-workspace.md` | FR-05…FR-08, FR-14…FR-16, FR-25…FR-27, FR-34…FR-39, FR-58 |
| `03-editor-image-text-style.md` | FR-09…FR-13, FR-28…FR-33, FR-40…FR-53 |
| `04-library-export.md` | FR-17…FR-22, FR-54…FR-57 |
| `05-setup-screen.md` | FR-01…FR-04, FR-23, FR-24 |
| `07-testing-distribution.md` | FR-59, FR-60 |

## Key decisions

| Decision | Value | Rationale |
|----------|-------|-----------|
| Library persistence | Room database | Survives a device restart; supports queries and atomic writes |
| Export path | User-selectable in setup | Flexibility; no assumptions about the app installation |
| UI theme | Light and dark both supported | Modern standard; user preference |
| Monetization | Free and open source | Audience: creative users; community building |
| Working area | Canvas with optional content | Photo, quote, and frame combine freely; it stays a single working area |
| Text elements | Quote and author separate | Independently styleable and positionable |
| Styles vs. templates | Separate concepts | A style is text design (reusable); a template is aspect ratio + positions + text styles (built in) |
| Style application | Snapshot | The project stays self-contained; later style changes do not apply retroactively |
| Custom templates | Off for now | The `is_builtin` flag keeps a later extension migration-free |
| Quote collection | Embedded and offline | Search, topics, favourites, recently used, random; a source view follows with data governance |
| Images and readability | Frames and effects coexist | Frames stay; effects and readability aids are additional, optional layers |
| Editor behaviour | Drag, undo/redo, autosave, warning, guides | Comfortable and safe editing |
| Project integrity | Photo copy, duplicate, crop | The project stays independent of the gallery image; portable project files and backup follow later |
| Export | Size presets, no watermark | Canvas resolution is fixed; export size is selectable and the actual resolution is shown |
| Quote provenance | Report/suggest via external link | No server; a source/license view and a versioned package follow later |
| Distribution | Play, F-Droid, Obtainium, website APK | Wider reach; no proprietary dependencies for F-Droid compatibility |
