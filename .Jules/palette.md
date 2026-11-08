# Palette's Journal - Critical Learnings

## 2025-05-18 - Destructive Actions in Dashboard Management
**Learning:** In property management dashboards, icon-only destructive actions (like trash icons) require both an explicit accessible tooltip (`tooltip`) for screen readers and an irreversible action confirmation dialog (`AlertDialog`) to prevent accidental permanent deletion of user-generated listings.
**Action:** Always pair destructive list item actions with confirmation dialogs and accessible tooltip labels before invoking provider delete methods.
