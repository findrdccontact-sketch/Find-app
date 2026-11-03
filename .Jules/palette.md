## 2026-11-03 - Tooltips & Semantics on Icon-Only Buttons in Flutter
**Learning:** In Flutter, icon-only `IconButton` widgets without explicit `tooltip` attributes provide no screen reader announcement or hover/long-press feedback, hindering accessibility and confusing users about dynamic toggle actions (such as adding vs removing from favorites).
**Action:** Always provide descriptive and dynamic `tooltip` strings (localized in French for DRC apps) on `IconButton` instances.
