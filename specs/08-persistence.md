# Persistence and Data

The storage contract for the app: the store of record, the Room schema, the data models,
and the repository interfaces. The library is the app's memory, so this file is part of
the binding contract.

## Store of record

| Question | Answer | Rationale |
|----------|--------|-----------|
| **Is JSON enough?** | ❌ Not optimal | JSON has no query capabilities and no indexing |
| **Recommended: Room Database** | ✅ Yes | Persists across app restarts, supports queries and transactions |
| **Schema evolution** | Live migration with DataMigration | Automatically migratable for future changes |

## Persistence rules

- The library must survive a device restart (see `04-library-export.md` and TC-09).
- Schema changes require a migration; never use a destructive fallback for the library.
- A saved project keeps its own copy of the photo and stays independent of the original
  gallery image (FR-55).

## Room schema

```kotlin
@Entity(tableName = "saved_projects")
data class SavedProjectEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    @ColumnInfo(name = "background_type") val backgroundType: String = "COLOR", // IMAGE | COLOR
    @ColumnInfo(name = "image_path") val imagePath: String?,              // null = no photo; app-internal photo copy
    // Crop (fractions of the original, 0.0 .. 1.0)
    @ColumnInfo(name = "crop_x") val cropX: Float = 0f,
    @ColumnInfo(name = "crop_y") val cropY: Float = 0f,
    @ColumnInfo(name = "crop_w") val cropW: Float = 1f,
    @ColumnInfo(name = "crop_h") val cropH: Float = 1f,
    @ColumnInfo(name = "background_color") val backgroundColor: String = "#FFFFFF",
    // Image effects (only effective with a photo; strengths adjustable)
    @ColumnInfo(name = "effect_brightness") val effectBrightness: Float = 0f,   // -1.0 .. 1.0
    @ColumnInfo(name = "effect_blur") val effectBlur: Float = 0f,               // 0.0 .. 1.0
    @ColumnInfo(name = "effect_monochrome") val effectMonochrome: Boolean = false,
    @ColumnInfo(name = "effect_temperature") val effectTemperature: Float = 0f, // -1.0 cool .. 1.0 warm
    @ColumnInfo(name = "effect_vignette") val effectVignette: Float = 0f,       // 0.0 .. 1.0
    @ColumnInfo(name = "background_gradient") val backgroundGradient: Boolean = false,
    @ColumnInfo(name = "background_gradient_strength") val backgroundGradientStrength: Float = 0.5f,
    @ColumnInfo(name = "quote_text") val quoteText: String?,              // null when there is no quote
    @ColumnInfo(name = "quote_author") val quoteAuthor: String?,
    // Quote – text styling & position
    @ColumnInfo(name = "quote_font_id") val quoteFontId: Int,
    @ColumnInfo(name = "quote_font_size") val quoteFontSize: Int,
    @ColumnInfo(name = "quote_text_color") val quoteTextColor: String,
    @ColumnInfo(name = "quote_bold") val quoteBold: Boolean = false,
    @ColumnInfo(name = "quote_italic") val quoteItalic: Boolean = false,
    @ColumnInfo(name = "quote_alignment") val quoteAlignment: String = "CENTER",
    @ColumnInfo(name = "quote_line_height") val quoteLineHeight: Float = 1.2f,
    @ColumnInfo(name = "quote_width_percent") val quoteWidthPercent: Float = 80f,
    @ColumnInfo(name = "quote_shadow") val quoteShadow: Boolean = false,
    @ColumnInfo(name = "quote_outline") val quoteOutline: Boolean = false,
    @ColumnInfo(name = "quote_scrim") val quoteScrim: Boolean = false,
    @ColumnInfo(name = "quote_mark_style") val quoteMarkStyle: String = "NONE", // NONE | NORMAL | DECORATIVE
    @ColumnInfo(name = "quote_x") val quoteX: Float = 0f,
    @ColumnInfo(name = "quote_y") val quoteY: Float = 0f,
    // Author – text styling & position
    @ColumnInfo(name = "author_font_id") val authorFontId: Int,
    @ColumnInfo(name = "author_font_size") val authorFontSize: Int,
    @ColumnInfo(name = "author_text_color") val authorTextColor: String,
    @ColumnInfo(name = "author_bold") val authorBold: Boolean = false,
    @ColumnInfo(name = "author_italic") val authorItalic: Boolean = false,
    @ColumnInfo(name = "author_alignment") val authorAlignment: String = "CENTER",
    @ColumnInfo(name = "author_line_height") val authorLineHeight: Float = 1.2f,
    @ColumnInfo(name = "author_width_percent") val authorWidthPercent: Float = 80f,
    @ColumnInfo(name = "author_shadow") val authorShadow: Boolean = false,
    @ColumnInfo(name = "author_outline") val authorOutline: Boolean = false,
    @ColumnInfo(name = "author_scrim") val authorScrim: Boolean = false,
    @ColumnInfo(name = "author_x") val authorX: Float = 0f,
    @ColumnInfo(name = "author_y") val authorY: Float = 0f,
    @ColumnInfo(name = "frame_style_id") val frameStyleId: Int?,          // null = no frame
    @ColumnInfo(name = "frame_width_percent") val frameWidthPercent: Float,
    @ColumnInfo(name = "frame_color") val frameColor: String,
    @ColumnInfo(name = "aspect_ratio") val aspectRatio: String = "ORIGINAL", // ORIGINAL | SQUARE | PORTRAIT | LANDSCAPE
    @ColumnInfo(name = "export_format") val exportFormat: String,
    @ColumnInfo(name = "export_quality") val exportQuality: Int,
    @ColumnInfo(name = "created_at") val createdAt: Long = System.currentTimeMillis(),
    @ColumnInfo(name = "last_modified") val lastModifiedAt: Long = System.currentTimeMillis(),
    @ColumnInfo(name = "display_order") val displayOrder: Int = 0
)

@Entity(tableName = "app_settings")
data class AppSettingsEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    @ColumnInfo(name = "export_path") val exportPath: String = "/sdcard/Quoted",
    @ColumnInfo(name = "theme_mode") val themeMode: Int = 1, // 0=System, 1=Light, 2=Dark
)

@Entity(tableName = "text_styles")
data class TextStyleEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    @ColumnInfo(name = "name") val name: String,
    @ColumnInfo(name = "font_id") val fontId: Int,
    @ColumnInfo(name = "font_size") val fontSize: Int,
    @ColumnInfo(name = "text_color") val textColor: String,
    @ColumnInfo(name = "bold") val bold: Boolean = false,
    @ColumnInfo(name = "italic") val italic: Boolean = false,
    @ColumnInfo(name = "alignment") val alignment: String = "CENTER",
    @ColumnInfo(name = "line_height") val lineHeight: Float = 1.2f,
    @ColumnInfo(name = "width_percent") val widthPercent: Float = 80f,
    @ColumnInfo(name = "shadow") val shadow: Boolean = false,
    @ColumnInfo(name = "outline") val outline: Boolean = false,
    @ColumnInfo(name = "scrim") val scrim: Boolean = false,
    @ColumnInfo(name = "created_at") val createdAt: Long = System.currentTimeMillis()
)

@Entity(tableName = "templates")
data class TemplateEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    @ColumnInfo(name = "name") val name: String,
    @ColumnInfo(name = "is_builtin") val isBuiltin: Boolean = true, // for custom templates later
    @ColumnInfo(name = "aspect_ratio") val aspectRatio: String,
    @ColumnInfo(name = "quote_x") val quoteX: Float,
    @ColumnInfo(name = "quote_y") val quoteY: Float,
    @ColumnInfo(name = "author_x") val authorX: Float,
    @ColumnInfo(name = "author_y") val authorY: Float,
    @ColumnInfo(name = "quote_style") val quoteStyleJson: String,  // TextStyle payload
    @ColumnInfo(name = "author_style") val authorStyleJson: String
)

@Entity(tableName = "quotes")
data class QuoteEntity(
    @PrimaryKey val id: Long,
    @ColumnInfo(name = "text") val text: String,
    @ColumnInfo(name = "author") val author: String,
    @ColumnInfo(name = "topic") val topic: String,
    @ColumnInfo(name = "language") val language: String,
    @ColumnInfo(name = "source_work") val sourceWork: String?,   // work
    @ColumnInfo(name = "source_ref") val sourceRef: String?,     // reference
    @ColumnInfo(name = "translator") val translator: String?,
    @ColumnInfo(name = "license") val license: String,
    @ColumnInfo(name = "attribution_status") val attributionStatus: String // ATTESTED | UNCERTAIN
)

@Entity(tableName = "quote_user_state")
data class QuoteUserStateEntity(
    @PrimaryKey val quoteId: Long,
    @ColumnInfo(name = "favorite") val favorite: Boolean = false,
    @ColumnInfo(name = "last_used_at") val lastUsedAt: Long? = null
)
```

## Data models

### Text models (Kotlin data classes)

```kotlin
data class TextStyle(
    val fontId: Int = 1,
    val fontSize: Int = 28,
    val color: String = "#FFFFFF",
    val bold: Boolean = false,
    val italic: Boolean = false,
    val alignment: String = "CENTER", // LEFT | CENTER | RIGHT
    val lineHeight: Float = 1.2f,     // line height (multiplier)
    val widthPercent: Float = 80f,    // text width in % of the canvas
    val shadow: Boolean = false,      // text shadow
    val outline: Boolean = false,     // text outline
    val scrim: Boolean = false        // semi-transparent text surface
)

data class TextElement(
    val text: String = "",              // empty = element not present
    val style: TextStyle = TextStyle(),
    val x: Float = 0f,
    val y: Float = 0f
)
```

### Frame model (Kotlin data class)

```kotlin
data class FrameData(
    val styleId: Int = 0,        // 0 = no frame
    val widthPercent: Float = 10f,
    val color: String = "#FFFFFF"
)
```

### Export config (Kotlin data class)

```kotlin
data class ExportConfig(
    val format: String = "JPEG",
    val quality: Int = 90,
    val longEdge: Int = 1080,     // export preset (long edge in px)
    val path: String? = null
)
```

### Project/save model (library – Room entity)

```kotlin
data class SavedProject(
    val id: Long = System.currentTimeMillis(),
    val imagePath: String? = null,            // null = no photo (solid colour); app-internal photo copy
    val crop: Crop = Crop(),                  // crop (fractions of the original)
    val backgroundColor: String = "#FFFFFF",
    val aspectRatio: String = "ORIGINAL",     // ORIGINAL | SQUARE | PORTRAIT | LANDSCAPE
    val effects: Effects = Effects(),         // image effects (only effective with a photo)
    val backgroundGradient: Boolean = false,  // gradient as a readability aid
    val quote: TextElement? = null,           // null = no quote
    val author: TextElement? = null,          // null = no author
    val quoteMarkStyle: String = "NONE",      // NONE | NORMAL | DECORATIVE
    val frameData: FrameData?,                // null = no frame
    val exportConfig: ExportConfig,
    val createdAt: Date = Date(),
    val lastModified: Date = Date()
)
```

### App settings model (Room entity)

```kotlin
data class AppConfig(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val exportPath: String = "/sdcard/Quoted", // user-selectable ✅
    val themeMode: Int = 1 // 0=System, 1=Light, 2=Dark
)
```

### Style and template models

```kotlin
data class SavedTextStyle(
    val id: Long = 0,
    val name: String,
    val style: TextStyle
)

data class Template(
    val id: Long = 0,
    val name: String,
    val isBuiltin: Boolean = true,
    val aspectRatio: String,
    val quote: TextElement,   // position + style (text empty)
    val author: TextElement
)

data class Quote(
    val id: Long,
    val text: String,
    val author: String,
    val topic: String,
    val language: String,
    val sourceWork: String? = null,
    val sourceRef: String? = null,
    val translator: String? = null,
    val license: String,
    val attributionStatus: String, // ATTESTED | UNCERTAIN
    val favorite: Boolean = false,
    val lastUsedAt: Long? = null
)
```

### Effects model

```kotlin
data class Effects(
    val brightness: Float = 0f,   // -1.0 .. 1.0
    val blur: Float = 0f,         // 0.0 .. 1.0
    val monochrome: Boolean = false,
    val temperature: Float = 0f,  // -1.0 cool .. 1.0 warm
    val vignette: Float = 0f      // 0.0 .. 1.0
)
```

### Crop model

```kotlin
data class Crop(
    val x: Float = 0f,       // 0.0 .. 1.0 (fraction of the original)
    val y: Float = 0f,
    val width: Float = 1f,
    val height: Float = 1f
)
```

## Repository interfaces

```kotlin
interface ProjectRepository {
    fun getAllProjects(): Flow<List<SavedProject>>
    fun getProjectById(id: Long): Single<SavedProject>
    fun insertProject(project: SavedProject)
    fun updateProject(project: SavedProject)
    fun deleteProject(id: Long)
    fun searchProjects(keyword: String): List<SavedProject>
}

interface SettingsRepository {
    fun getSettings(): AppConfig?
    fun saveExportPath(path: String)
    fun setThemeMode(mode: Int)
}

interface TextStyleRepository {
    fun getAllStyles(): Flow<List<SavedTextStyle>>
    fun insertStyle(style: SavedTextStyle)
    fun updateStyle(style: SavedTextStyle)
    fun deleteStyle(id: Long)
}

interface TemplateRepository {
    fun getBuiltInTemplates(): Flow<List<Template>>
    fun applyTemplate(project: SavedProject, template: Template): SavedProject
}

interface QuoteRepository {
    fun search(query: String, topic: String?): Flow<List<Quote>>
    fun getFavorites(): Flow<List<Quote>>
    fun getRecentlyUsed(limit: Int): Flow<List<Quote>>
    fun getRandom(): Quote?
    fun setFavorite(quoteId: Long, favorite: Boolean)
    fun markUsed(quoteId: Long)
}
```

## Asset and database directory tree

```text
assets/
├── fonts/              # Preconfigured fonts (.ttf/.otf)
│   ├── font_modern.ttf
│   └── font_serif.otf
├── frames/             # Frame assets (PNG with transparency)
│   ├── frame_vintage.png
│   └── frame_gold.png
├── quotes.json         # Embedded, curated quote collection (seeding)
├── templates.json      # Built-in, recommended templates (seeding)
└── icons/              # App icons for both themes

database/
├── db_assets.sql       # Initial backup for assets
└── schema_migration.xml # Room migration schema
```

## Image output structure (JSON)

```json
{
  "background": { "type": "COLOR", "color": "#FFFFFF" },
  "image": null,
  "effects": { "brightness": 0, "blur": 0, "monochrome": false, "temperature": 0, "vignette": 0 },
  "backgroundGradient": false,
  "quote": null,
  "frame": null,
  "aspectRatio": "PORTRAIT",
  "canvas": { "width": 1080, "height": 1920 },
  "export": { "format": "JPEG", "quality": 90, "longEdge": 1080 }
}
```

`"image"`, `"quote"`, and `"frame"` are `null` when the respective content is missing.
With content they keep using the known schema (`path`/`dimensions`/`format`,
`text`/`author`/`fontId`/`fontSize`/`color`, `styleId`/`widthPercent`/`color`).
