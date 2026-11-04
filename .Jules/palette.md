# Palette's Critical Learnings

## 2025-05-18 - Tooltips and Immediate Feedback on Icon-Only Actions
**Learning:** In Flutter applications, icon-only `IconButton` widgets default to having no assistive semantics label or desktop/web hover tooltip unless the `tooltip` property is explicitly specified. For critical actions like toggling favorites, users without screen readers also benefit from immediate transient confirmation (`SnackBar` feedback: "Ajouté aux favoris" / "Retiré des favoris") since icon color changes alone can be subtle or missed.
**Action:** Always provide explicit `tooltip` strings on `IconButton` and trigger transient `SnackBar` confirmations on state toggles.
