# Palette's Journal - Critical Learnings Only

## 2025-11-06 - Dynamic Tooltips on Toggleable Action Buttons
**Learning:** In Flutter mobile & web applications, icon-only buttons (such as heart/favorite, share, or report buttons) are frequently navigated via talkback/voiceover or hover without visual text labels. Supplying dynamic, state-aware `tooltip` properties in Flutter's `IconButton` directly informs screen reader accessibility APIs (via internal `Semantics` wrapper) as well as desktop/web cursor hover hints, without requiring extra wrapper widgets or custom semantics nodes.
**Action:** Always provide stateful localized tooltips (e.g., "Retirer des favoris" when active vs "Ajouter aux favoris" when inactive) on icon-only toggle buttons in Flutter component cards and detail views.
