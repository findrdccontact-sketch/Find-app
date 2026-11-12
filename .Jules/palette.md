# Palette's Journal - Critical UX & Accessibility Learnings

## 2025-05-18 - Tooltips and Semantics on Flutter Icon-Only Action Buttons in French Localization
**Learning:** In Flutter mobile & web applications, icon-only buttons (such as `IconButton` in `AppBar` actions or overlay cards) are invisible to screen readers without a `tooltip` attribute, and mouse/hover users receive no hint of their function. For bilingual/localized real estate apps (such as FIND in DRC), icon buttons like Favorites, Share, and Report require concise French tooltips (e.g., 'Ajouter aux favoris' / 'Retirer des favoris') and immediate feedback confirmations (e.g., SnackBar with undo action) to reassure users when modifying personal collections.
**Action:** Always provide dynamic `tooltip` attributes on interactive icon-only buttons and pair state toggles with clear, reversible user feedback.
