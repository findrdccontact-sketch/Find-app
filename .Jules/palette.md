# Palette's Journal - Critical UX Learnings

## 2025-11-05 - Accessible Tooltips for Icon-Only Buttons in Flutter
**Learning:** In Flutter apps designed for French-speaking regions (e.g. DRC), icon-only buttons such as favorite, back, share, and report buttons in app bars and card overlays require explicit French tooltips (`tooltip: 'Ajouter aux favoris' / 'Retirer des favoris'`). Tooltips provide dual benefits: hover/long-press visual tooltips on desktop/web/touch, and automatic accessibility labels for screen readers without needing redundant Semantics wrappers.
**Action:** Always provide explicit, localized `tooltip` strings to all `IconButton` widgets across cards and screen app bars.
