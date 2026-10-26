## 2025-05-18 - Accessibility Tooltips on IconButtons
**Learning:** In Flutter, `IconButton` widgets without an explicit `tooltip` parameter fail to provide screen readers (Semantics) with a descriptive text label. Always supply a localized `tooltip` on icon-only buttons to guarantee keyboard/hover tooltips and screen reader accessibility.
**Action:** Include localized `tooltip` descriptions on all `IconButton` components across screens and widgets.
