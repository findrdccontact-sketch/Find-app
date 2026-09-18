## 2025-05-18 - Icon-Only Button Tooltips & Confirmation Dialogs
**Learning:** Icon-only `IconButton` widgets in Flutter lack default screen reader descriptions unless a `tooltip` parameter is provided. Furthermore, destructive deletion actions should always require confirmation to prevent accidental data loss.
**Action:** Always provide localized `tooltip` descriptions on `IconButton` widgets and prompt users with an `AlertDialog` before executing destructive actions.
