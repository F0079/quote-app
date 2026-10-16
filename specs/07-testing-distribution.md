# Testing, Distribution and Roadmap

## Distribution and release

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-59 | Distribution channels | Release via Google Play, F-Droid, Obtainium (GitHub releases) and as a direct APK download from a website | Signed APKs, release automation | Medium |
| FR-60 | No proprietary dependencies | No dependency on Google Play Services or other proprietary libraries, to stay F-Droid-compatible | Open-source libraries only (e.g. Coil) | High |

**Note:** Obtainium and the website download require signed APK releases; the signing keys
are stored securely.

## Test strategy (QA)

| ID | Scenario | Expected result | Priority |
|----|----------|-----------------|----------|
| **TC-01** | Take a photo with the camera | The image is adopted without distortion | High |
| **TC-02** | Select a gallery image (another app) | Access works correctly | High |
| **TC-03** | Black text colour on a dark image | Contrast is automatically recommended / a warning is shown | Medium |
| **TC-04** | Frame limits (0% / 50%) | Validation without a crash | Medium |
| **TC-05** | Welcome screen shows a greeting + direct entry | No random quote, no third-party content | High |
| **TC-06** | Library shows all images correctly | The grid layout works without scroll errors | High |
| **TC-07** | Re-editing opens the image in the editor | The state is restored correctly (Room) | High |
| **TC-08** | Export saves to the user folder | The file is visible in the host folder ✅ | High |
| **TC-09** | Device restart → library present | The Room DB persists across the restart ✅ | **High** ⭐ |
| **TC-10** | SetupScreen chooses a new export path | The path is saved in settings and the DB | **High** ⭐ |
| **TC-11** | Export an empty canvas (solid colour only) | A valid JPG/PNG without photo/quote | High |
| **TC-12** | Choose the aspect ratio without a photo | The output adopts the chosen ratio without distortion | High |
| **TC-13** | Quote without a photo, then add a photo | The content is preserved; any order works | Medium |

### Tools and practices

- **Unit tests**: JUnit5 for logic tests
- **Integration tests**: Espresso + Compose testing API
- **Leaks**: LeakCanary (optional)
- **Performance**: Android Profiler for export duration

## Development roadmap

| Phase | Period | Milestone | Status |
|-------|--------|-----------|--------|
| **Setup & DB** | Wk 1 | SetupScreen, Room schema, export path choice | 🟢 In progress ✅ |
| **MVP core** | Wk 2-3 | Camera, gallery, quote text, export JPG | 🟡 In progress |
| **Workspace UI & preview** | Wk 4-5 | Overlay, fonts, frames, theme support | ⬜ TODO |
| **Library & persistence** | Wk 6 | SavedProject model, Room integration ✅ | ⬜ TODO |
| **Polish & API** | Wk 7-8 | Quote database, social sharing, bug fixes | ⬜ FUTURE |

## Open points / to-dos

- [ ] **Asset sourcing**: Where do the fonts/frames come from? (check the Open Font License – e.g. Google Fonts)
- [ ] **Export path choice**: SetupScreen with the StorageManager API (Android 10+ runtime permission check) ✅
- [ ] **UI design**: dark mode vs. light mode decision – both supported ✅
- [ ] **Performance**: how do we scale with 4K images (>10 MB)? – WorkManager for large files
- [ ] **Monetization**: free/paid model? (decision: free & open source ✅)
- [ ] **Library**: Room database instead of JSON ✅
  - ✅ **Persistence**: survives a device restart
  - ✅ **Stores**: metadata + path to the image in the DB
  - ❌ **JSON alone not recommended** (no query, no atomic writes, no indexing)
- [ ] **Quote data package**: curate and version the content, topics, and license status of the embedded collection (data governance)
- [ ] **Source & license view (later)**: show the source and license details of the quotes in the app
- [ ] **Release automation**: maintain signed APK releases for GitHub/website and the F-Droid metadata
- [ ] **Custom templates (later)**: add user-defined templates via the existing `is_builtin` flag, without a migration
- [ ] **Portable project files (later)**: export/import a project as one file (e.g. a ZIP with `project.json` + photo)
- [ ] **Backup/restore (later)**: transfer the personal collection to another device
- [ ] **Share intent**: allowlist for specific apps on Android 10+
- [ ] **Theming**: Material3 with a theme colour system (accent/primary)
- [ ] **Export path validation**: check write access before export (catch IOException)
