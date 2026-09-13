# Palette's Journal

## 2025-05-15 - Icon-only buttons accessibility in Flutter cards
**Learning:** In Flutter, icon-only buttons like favorite/bookmark buttons inside listing cards lack accessibility tooltips by default unless explicitly supplied via `tooltip`.
**Action:** Always provide dynamic `tooltip` text on `IconButton` components to enhance screen reader support and visual hover feedback for desktop/web users.
