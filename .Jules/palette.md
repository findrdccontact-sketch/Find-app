## 2025-05-18 - Tooltip Accessibility for Icon Buttons
**Learning:** Icon-only `IconButton` widgets in Flutter lack accessibility descriptions by default for screen readers and hover states unless the `tooltip` parameter is explicitly defined.
**Action:** Always provide localized French `tooltip` strings (e.g. 'Retour', 'Ajouter aux favoris', 'Partager', 'Signaler l\'annonce') on icon-only `IconButton`s throughout the application.
