# Palette's Journal - Critical UX & Accessibility Learnings

## 2025-05-18 - Tooltip and State Feedback on Actionable IconButtons
**Learning:** In Flutter mobile & desktop interfaces, icon-only buttons (like `IconButton` for favorites or bookmarks) need explicit `tooltip` attributes in French for screen reader semantics and hover tooltips. In addition, when state toggles without navigation, displaying short snackbar feedback confirms the action for users with cognitive or visual impairments.
**Action:** Always provide meaningful, localized tooltips to `IconButton` widgets in listing cards and detail app bars, paired with brief feedback confirmations where appropriate.
