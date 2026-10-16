# Non-Functional Requirements and Architecture

## Non-functional requirements

### Performance and resources

| Category | Target | Description |
|----------|--------|-------------|
| **Start time** | <2 seconds | Cold start without installation (splash screen optional) |
| **Export duration** | <5 seconds | For photos up to 4K resolution (local) |
| **Storage** | <150 MB | Total size of the installed app |
| **RAM usage** | <250 MB | With an active library of >50 images |

### Security and privacy

- ✅ No cloud sync (MVP)
- ✅ No data to third parties (local API cache optional)
- ✅ Only on demand: `CAMERA`, `READ_EXTERNAL_STORAGE` (Android 6+)
- ✅ Storage visible in the "Quoted" folder
- ✅ Encrypted temporary files on export

### Compatibility and platform

| Goal | Value |
|------|-------|
| Minimum Android version | API level 24+ (Android 7.0+) |
| Supported architectures | arm64-v8a, armeabi-v7a |
| Screen resolution | Adaptive UI for high-end and entry-level (1080x2340) |

### Offline capability

- ✅ All assets (fonts, frames) stay local
- ✅ Quotes are kept locally (no network needed; no random quote at the start)
- ✅ The library is fully reachable without a network

## Technical architecture

### Technology choices

```yaml
Language: Kotlin
Build tool: Gradle (Kotlin DSL)
UI framework: Jetpack Compose (Android Studio)
Data flow: Coroutines & Flow (async image processing)
Dependencies:
  - Coil / Glide (load images)
  - Material3 Components (UI design)
  - AndroidPermissions (runtime check)
  - ExifLib (metadata, if needed)
  - Room (database for library & metadata) ⚠️ NEW
  - Retrofit/OkHttp (API for quotes – optional)
  - Lifecycle ViewModels (lifecycle-aware components)
```

### Architecture patterns (extended)

| Pattern | Application | Description |
|---------|-------------|-------------|
| **MVVM** | UI screens | The view model binds state to the Compose UI |
| **Repository** | Asset management | Fonts/frames centrally manageable (assets + download) |
| **WorkManager** | Background | Export asynchronously for large files (>5 MB) |
| **StateFlow/MutableStateMap** | Library state | Persistence for edited images (Room DB) ✅ |

### Project components (modularization)

```text
┌──────────────────────────────────────────────────────────┐
│ MainActivity                                             │
│ ├─ SetupActivity            export path choice           │
│ └─ WelcomeScreen            → New project                │
│                                                          │
│ WorkspaceActivity → EditorScreen                         │
│ ├─ ImagePreview             preview                      │
│ ├─ QuoteEditor              text input                   │
│ ├─ FrameSelector            frame choice                 │
│ └─ ExportService            JPG/PNG output               │
│                                                          │
│ LibraryActivity                                          │
│ ├─ GalleryGrid              image overview               │
│ ├─ EditFromLibrary          open & edit image            │
│ └─ DeleteItem               delete/archive               │
│                                                          │
│ SettingsScreen                                           │
│ ├─ Theme Toggle             light/dark                   │
│ ├─ Export path              display (read-only)          │
│ └─ About Screen                                          │
│                                                          │
│ AssetManager                                             │
│ ├─ Fonts/                   preconfigured fonts          │
│ └─ Frames/                  PNG frames with transparency │
└──────────────────────────────────────────────────────────┘
```

## Data, models, and persistence

See [`08-persistence.md`](08-persistence.md) for the store of record, the Room schema, the
data models, and the repository interfaces.
