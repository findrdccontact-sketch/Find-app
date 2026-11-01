# Palette's Journal - Critical UX Learnings

## 2025-05-18 - Destructive Action Protection in Dashboard Lists
**Learning:** Icon-only destructive actions (like a red trash icon) inside item cards are prone to accidental clicks on mobile screens and lack accessible screen-reader explanations unless explicitly assigned a `tooltip` and guarded with an `AlertDialog` confirmation step.
**Action:** Always provide an explicit `tooltip` on icon-only action buttons in Flutter (`IconButton(tooltip: ...)`) and gate irreversible operations behind a standard confirmation dialog followed by a SnackBar confirming the outcome.
