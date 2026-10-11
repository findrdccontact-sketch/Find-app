## 2025-05-18 - Accessibility Tooltips on Icon Buttons
**Learning:** Icon-only buttons (favorite, notifications, clear search, share, report) require explicit tooltips in Flutter to expose accessible text for screen readers and hover descriptions on web/desktop.
**Action:** Always provide contextual `tooltip` properties on `IconButton` widgets matching the app's language (French).
