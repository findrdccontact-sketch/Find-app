## 2025-05-18 - Tooltip Property for Flutter IconButton Accessibility
**Learning:** In Flutter, `IconButton`'s `tooltip` property automatically configures accessible screen reader semantics in addition to displaying hover/long-press tooltips. Icon-only buttons lacking a `tooltip` parameter render without accessible labels for screen readers.
**Action:** Always provide concise, localized `tooltip` strings on `IconButton` widgets across the app.
