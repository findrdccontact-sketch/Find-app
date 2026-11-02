# Palette's Journal - Critical UX/Accessibility Learnings

## 2026-09-10 - Destructive Action Guard and Tooltip on Icon-Only Actions
**Learning:** Icon-only action buttons (such as delete icons in listing management dashboards) are prone to accidental taps on mobile and touch devices. Without confirmation and accessibility tooltips, users risk irreversible data loss and screen reader users lack context on the button's purpose.
**Action:** Always provide an explicit French `tooltip` attribute on Flutter `IconButton`s and intercept destructive actions with an `AlertDialog` confirmation dialog before executing state deletion.
