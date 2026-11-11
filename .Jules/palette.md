# Palette's Journal

## 2025-05-18 - State-Aware Tooltips on Flutter IconButtons
**Learning:** In Flutter, icon-only action buttons (such as favorite toggles, share, back, and report buttons) default to having no semantic label or hover tooltip unless `tooltip` is explicitly provided. For toggleable actions like favoriting, setting a dynamic tooltip based on current state (e.g., `'Retirer des favoris'` vs `'Ajouter aux favoris'`) satisfies both mouse hover feedback and screen reader accessibility via semantic labels.
**Action:** When adding or auditing `IconButton`s in Flutter screens and cards, always specify a localized, descriptive `tooltip` attribute reflecting the button's action and state.
