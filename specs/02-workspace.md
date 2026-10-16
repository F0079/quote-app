# Workspace and Canvas

The canvas is the single working area. Photo, quote, and frame are each optional and are
added in any order — there is no forced entry ("photo first" or "quote first"). An empty
canvas can be saved or exported at any time. Every change is rendered immediately in the
preview.

## Canvas model

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-25 | Canvas as the only working area | Empty canvas at start; photo/quote/frame can be added independently; saving/export is possible at any time | Compose `Canvas`/`Box` | High |
| FR-26 | Background | Without a photo, a selectable solid colour is the background (colour picker); with a photo, the photo is the background | `Modifier.background()` / bitmap composite | High |
| FR-27 | Aspect ratio | Always selectable — with or without a photo: original, square, portrait, landscape | Compose `aspectRatio()` / export preset | High |

**Output size:** the internal canvas resolution is fixed; for export, size presets are
selectable (long edge, e.g. 1080/1440/2048 px). The app shows the resolution that is
actually available.

## Photo

| ID | Requirement | Description | Android API / library | Priority |
|----|-------------|-------------|-----------------------|----------|
| FR-05 | Camera capture | Integrate the Android camera API for live view and capture (full resolution) | CameraX, MediaStore | High |
| FR-06 | Gallery selection | Access `ContentResolver` to select image files | MediaStore API (`MediaStore.Images.Media`) | High |
| FR-07 | Image scaling and crop | Crop when a photo is present; the aspect ratio can additionally be chosen independently of this (with or without a photo) | Jetpack Compose `ImageZoomable`, ImageFilter | Medium |
| FR-08 | Format support | Input (optional): JPEG, PNG (max 5 MB); output: JPG/PNG; without a photo the canvas is rendered as a solid colour | Android MediaStore, `BitmapFactory.decodeFile()` | High |

## Frames

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-14 | Frame styles | Optional: "no frame" (default) plus ≥6 styles: Vintage, Minimalist, Gold, Silver, Nature, Fancy | PNG assets with `ImageLoader` (Coil) | High |
| FR-15 | Frame colour | Adjustable frame colour (e.g. white/silver/gold) | Colour picker for the overlay frame colour | Medium |
| FR-16 | Frame width | Adjustable in % or px (e.g. 5%–30%) | Compose `Modifier.padding()` or bitmap overlay | Medium |

## Quote collection

The app contains an embedded quote collection that is available offline. It is reachable
as a sub-view of the editor (not its own entry flow); a selected quote is applied to the
canvas. Curation and source/license details are maintained as part of data governance.

| ID | Requirement | Description | Implementation | Priority |
|----|-------------|-------------|----------------|----------|
| FR-34 | Quote browser | Searchable list of the embedded collection in an editor sub-view; selection applies text and author to the canvas | Compose list, `QuoteRepository` | High |
| FR-35 | Search | Search by quote text and author | Room query / `QuoteRepository` | High |
| FR-36 | Topic filter | Filter by topic (e.g. calmness, courage, transience, self-determination) | `QuoteEntity.topic` | High |
| FR-37 | Favourites | Mark and unmark quotes as favourites; stored locally | `quote_user_state.favorite` | Medium |
| FR-38 | Recently used | Show recently applied quotes | `quote_user_state.last_used_at` | Medium |
| FR-39 | Random selection | Show a random quote from the collection ("discover") | Room random query | Medium |
| FR-58 | Report errors / suggest quotes | Users can report errors and suggest new quotes with a source, via an external link (no server) | `Intent.ACTION_VIEW` (web/email link) | Medium |

**Not in v1:** detail/source view (work, reference, translator) and filters by
language/text length. Source attributions are introduced with data governance.
