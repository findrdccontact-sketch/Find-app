## 2025-05-18 - Accessibility tooltips for action icon buttons
**Learning:** Icon-only buttons (such as favorite heart icons, share buttons, and report buttons in real estate listing cards and detail screens) lack textual descriptions by default, making them inaccessible to screen readers and non-intuitive to desktop users without tooltips.
**Action:** Always provide descriptive `tooltip` strings (localized to French for this app) on `IconButton` components to ensure proper semantics and desktop hover hints.
