# Editor, Image, Text and Style

## Quote overlay

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-09 | Text input | Input fields for "quote" (max 512 characters) and "author" | Jetpack Compose `TextField`/`TextEditor` | High |
| FR-10 | Fonts | At least 8 preconfigured fonts (.ttf/.otf) plus the system font; separately selectable for quote and author | Asset/res with `AssetManager`, `FontMetrics` | High |
| FR-11 | Font colour | Freeform colour palette (`#RRGGBB`) with a colour-picker dialog; separately for quote and author | Material3 `ColorPicker`/`Palette` | High |
| FR-12 | Font size | Range: 12px–72px with preview adjustment; separately for quote and author | Compose `Text.fontSize()` with slider | Medium |
| FR-13 | Positioning and alignment | Quote and author are independently positionable; horizontal alignment (centre/left/right) and vertical alignment (top/bottom/centre) are separately adjustable | Compose `Modifier.offset()`, `Box` alignment | Medium |
| FR-31 | Line height | Line height (multiplier, e.g. 1.0–2.0) separately adjustable for quote and author | Compose `Text` with `lineHeight` / slider | Medium |
| FR-32 | Text width | Text width as a percentage of the canvas, separately adjustable for quote and author; controls the line break | Compose `Modifier.widthIn(max = …)` | Medium |
| FR-33 | Quotation marks | Quotation marks can be shown as normal punctuation or as large design elements; hideable for your own thoughts | Compose text rendering (`NONE` / `NORMAL` / `DECORATIVE`) | Medium |

## Text styles and templates

A **style** bundles text design only (font, size, colour, bold/italic, alignment, line
height, text width, shadow, outline, semi-transparent surface) and is reusable across
projects. A **template** is a built-in recommendation and bundles aspect ratio, element
positions, and text styles. The two concepts are deliberately separate.

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-28 | Manage text styles | Users can create, rename, and delete text styles | Room `text_styles`, `TextStyleRepository` | High |
| FR-29 | Apply a style | A style can be applied to the quote or the author; the values are adopted into the project as a snapshot. Application is cross-project | Repository + update `SavedProjectEntity` | High |
| FR-30 | Recommended templates | Built-in templates set the aspect ratio, element positions, and text styles; the content stays freely adjustable afterwards. Templates change neither the background nor the frame | `assets/templates.json`, seeding into Room `templates` | High |

**Note:** custom (user-defined) templates are not planned for now; the `templates` table
carries an `is_builtin` flag so a later extension needs no migration.

## Image effects and readability

Image effects act on the photo and only take effect when a photo is present; the strength
is adjustable for each. Shadow, outline, and the semi-transparent surface are part of the
text style; the background gradient acts on the background layer and also works without a
photo.

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-40 | Brighten/darken | Adjustable brightness (strength) | ColorMatrix / `RenderEffect` | Medium |
| FR-41 | Blur | Adjustable background blur (strength) | `RenderEffect.createBlurEffect()` | Medium |
| FR-42 | Black and white | Monochrome toggle | Saturation 0 via ColorMatrix | Medium |
| FR-43 | Colour tone | Adjustable warm/cool | Colour temperature matrix | Medium |
| FR-44 | Vignette | Subtle edge darkening, adjustable strength | Radial gradient as an overlay | Medium |
| FR-45 | Text shadow | Shadow behind the quote and/or author (part of the text style) | Compose `Shadow` | Medium |
| FR-46 | Text outline | Outline around the glyphs (part of the text style) | Compose text stroke | Medium |
| FR-47 | Text surface | Semi-transparent surface behind the text (part of the text style) | Compose `background()` behind the text | Medium |
| FR-48 | Background gradient | Gradient over the background layer, adjustable strength; also without a photo | Compose `Brush.verticalGradient` | Medium |

## Editor behaviour

All changes are shown immediately in the preview (Compose canvas). The following
behaviour requirements concern how the editor is operated.

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-49 | Drag positioning | The quote and author can be positioned by dragging | Compose `detectDragGestures`, update `x`/`y` | High |
| FR-50 | Alignment guides | Guides while dragging (edges and centre of the canvas) | Compose overlay during the drag | Medium |
| FR-51 | Undo/redo | Undo/redo via an editor history | In-memory state stack | High |
| FR-52 | Autosave | The project is saved automatically while editing | Room update (`last_modified`) | High |
| FR-53 | Overflow warning | Notice when the text exceeds the set width; no silent truncation | Layout measurement against the text width | Medium |
