# Setup and Welcome

## Welcome screen

| ID | Requirement | Description | Android API / library | Priority |
|----|-------------|-------------|-----------------------|----------|
| FR-01 | Greeting text | A warm, time-of-day-dependent start greeting | Material3 `Text` component | High |
| FR-02 | ~~Random quote~~ | **Removed:** the start screen is deliberately distraction-free — no random quote, no third-party content | – | – |
| FR-03 | New-quote button | The only, prominently visible entry point "New quote" | `Modifier.clickable()` with high contrast | High |
| FR-04 | Theme switch | Light/dark mode selection + auto-detection | MaterialTheme.dark()/light() | High |

## App screen and setup

| ID | Requirement | Description | Android API / library | Priority |
|----|-------------|-------------|-----------------------|----------|
| FR-23 | Export path configuration | Setup function on first start with a storage-permission check | StorageManager API (Android 10+) | **High** ✅ |
| FR-24 | Dark/light mode toggle | System detection + manual switch in settings | `AppCompatDelegate.setDefaultNightMode()` | High |

## UI/UX and user flow

### Screen layouts

| Screen | Elements | Purpose |
|--------|----------|---------|
| **SetupScreen** | Export path choice, theme setting | First-time configuration ✅ |
| **WelcomeScreen** | Warm greeting text, direct entry "New quote" | Distraction-free start |
| **WorkspaceActivity** | Canvas (photo or solid colour), image effects and readability aids, quote and author separately styleable/positionable, optional frame, aspect ratio, text styles and templates, quote collection, export/share | Single working area |
| **QuoteCollectionScreen** | List/search/topic filter, favourites, recently used, random selection | Sub-view of the editor |
| **LibraryActivity** | Grid/list layout of the saved images, detail view, rename/duplicate/delete | Management |
| **ExportActivity** | Export quality, export size (presets) + actual resolution, file name, save/share/library | Final action |

### Sequence diagram (logic)

```text
[1] User starts the app → SetupScreen (on first run)
[2] Setup: choose export path + theme setting
[3] Setup: save settings in the Room DB
[4] App starts → WelcomeScreen (greeting + direct entry)
[5] User taps "New quote" → Workspace/Canvas (empty)
[6] Optional: take/choose a photo OR enter a quote (any order)
[7] Without a photo: choose the background solid colour
[8] Optional: choose the aspect ratio
[9] Optional: adjust quote/frame/colours
[10] App renders the preview (Compose Canvas)
[11] User presses Save or Export (possible at any time)
[12] App writes the file to the exportPath from settings
[13] Metadata saved in the Room DB for the library ✅
```

### Example: Jetpack Compose UI structure

```kotlin
@Composable
fun SetupScreen(
    onSetupComplete: () -> Unit,
    darkMode: Boolean = false
) {
    var exportPath by remember { mutableStateOf("/sdcard/Quoted") }

    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text("Choose export folder", style = MaterialTheme.typography.headlineSmall)
        Spacer(modifier = Modifier.height(16.dp))

        OutlinedTextField(
            value = exportPath,
            onValueChange = { exportPath = it },
            label = "Folder path",
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(16.dp))

        Button(onClick = onSetupComplete) {
            Text("Done")
        }
    }
}

@Composable
fun WelcomeScreen(
    onNewProjectClicked: () -> Unit,
    darkMode: Boolean = true
) {
    val greeting = remember { Greeting.random() }

    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(text = greeting.greeting, style = MaterialTheme.typography.headlineSmall)
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = greeting.quote,
            style = MaterialTheme.typography.bodyMedium,
            color = if (darkMode) Color.White else Color.Black
        )
        Spacer(modifier = Modifier.height(48.dp))

        Button(onClick = onNewProjectClicked) {
            Text("New quote")
        }
    }
}

@Composable
fun WorkspaceScreen(
    imageLoader: ImageLoader,
    onNewProjectClicked: (SavedProject) -> Unit
) {
    // As above, with the editing fields
}

@Composable
fun LibraryScreen() {
    LazyColumn {
        itemsIndexed(SAVED_PROJECTS.toList()) { index, project ->
            ItemCard(project) { /* open/edit */ }
        }
    }
}
```

### Settings screen (theme and export path)

```kotlin
@Composable
fun SettingsScreen(
    exportPath: String = "/sdcard/Quoted",
    themeMode: Int = 1, // 0=System, 1=Light, 2=Dark
    onExportPathChanged: (String) -> Unit,
    onThemeChanged: (Int) -> Unit
) {
    Column(modifier = Modifier.padding(16.dp)) {
        Text("Settings", style = MaterialTheme.typography.headlineSmall)

        Spacer(modifier = Modifier.height(32.dp))

        Text("Export folder")
        OutlinedTextField(
            value = exportPath,
            onValueChange = onExportPathChanged,
            label = "Path",
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(16.dp))

        Text("Theme")
        Row {
            RadioRowItem(text = "Automatic", value = 0)
            RadioRowItem(text = "Light", value = 1)
            RadioRowItem(text = "Dark", value = 2)
        }

        Spacer(modifier = Modifier.height(32.dp))

        Button(onClick = { onThemeChanged(themeMode) }) {
            Text("Save")
        }
    }
}
```
