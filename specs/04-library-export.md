# Library and Export

## Library and management

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-19 | Image library | View all saved images in a grid/list layout | `LazyColumn`/`LazyRow` with preview | High |
| FR-20 | Re-editing | Reopen and edit already created images | State save with `MutableStateMap` + Room DB | High |
| FR-21 | Export path choice | Setup on first start: choose a folder (`/sdcard/Quoted`, `/sdcard/Pictures/Quoted`, etc.) | `ActivityResultLauncher` + StorageManager | **High** ✅ |
| FR-22 | Metadata display | Show the creation date and last edit | Room DB with timestamps | Medium |
| FR-54 | Duplicate project | Create a saved project as an independent copy (new ID, its own photo copy) | Room insert with a new `id` | Medium |
| FR-55 | Independent photo copy | On save, the photo is copied into app storage; the project stays independent of the original gallery image | File copy in `filesDir`, path in `image_path` | High |

## Export and sharing

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-17 | Export formats | JPG and PNG with a quality setting (60–100%) | Android `Bitmap.compress()` / ImageIO | High |
| FR-18 | Sharing | Share via intent (WhatsApp, Instagram, etc.) | Android `Intent.ACTION_SEND` + share intent | High |
| FR-56 | Export size | Selectable size presets (long edge, e.g. 1080/1440/2048 px); the app shows the resolution actually available | Bitmap scaling, WorkManager | Medium |
| FR-57 | No watermark | Exports contain no watermark | — | Low |
