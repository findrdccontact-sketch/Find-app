# Palette Journal - Critical UX & Accessibility Learnings

## 2025-05-18 - Tooltips on Flutter Overlay IconButtons
**Learning:** Overlay IconButtons in Flutter cards (such as favorite buttons on image cards) often lack textual context for screen readers and accessibility tools unless explicitly provided with `tooltip` labels in local UI language (e.g., French).
**Action:** Always provide accessible tooltips on icon-only `IconButton` widgets that dynamically reflect the state changes (e.g. 'Ajouter aux favoris' / 'Retirer des favoris').
