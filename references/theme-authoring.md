# BuddyHue v1 theme authoring

Read this reference when creating or editing a BuddyHue skin.

## Source project

A minimal theme contains:

```text
my-theme/
├── buddyhue.json
└── workbuddy.css
```

Local images may be placed in `assets/`.

## Manifest example

```json
{
  "$schema": "<path-to-buddyhue>/schemas/buddyhue-manifest.schema.json",
  "schemaVersion": 1,
  "id": "ocean-brand",
  "name": "Ocean Brand",
  "version": "1.0.0",
  "description": "A restrained enterprise WorkBuddy theme.",
  "author": "Example Studio",
  "license": "All Rights Reserved",
  "tags": ["enterprise", "blue"],
  "compatibility": {
    "workbuddy": ">=5.9.0 <5.10.0"
  },
  "css": "workbuddy.css",
  "images": {
    "background": "assets/background.webp"
  },
  "verification": {
    "recommended": [
      {
        "name": "workspace",
        "any": [".teams-main-content"]
      }
    ]
  }
}
```

Use a relative `$schema` path that is valid from the actual theme directory. Let `wbhue theme create` generate the initial files whenever possible.

## Compatibility range

BuddyHue v1 accepts the fixed form:

```text
>=minimum-version <maximum-version
```

Keep the range constrained to versions with exact capability records and equivalent validation evidence. A broad range is not a substitute for testing.

## CSS and asset constraints

- CSS must be no larger than 1 MiB.
- The packaged theme must be no larger than 30 MiB.
- A package may contain at most 32 images.
- Images may be PNG, JPEG, WebP, or GIF.
- Image IDs must match `[A-Za-z0-9][A-Za-z0-9_-]*`.
- Do not use `@import`.
- Do not use non-`data:` URLs in CSS.
- Do not include JavaScript, renderer plugins, commands, or lifecycle scripts.
- Source files and assets must remain inside the theme project; reject absolute paths and `..` traversal.

Packed images are exposed to CSS as:

```css
background-image: var(--codedrobe-image-background);
```

## Selector policy

Scope rules to the BuddyHue host classes when appropriate:

```css
html.codedrobe-theme.codedrobe-host-workbuddy {
  --theme-accent: #2f6dd5;
}
```

Use only semantic selectors documented for the exact WorkBuddy version. Do not use `_grid_*`, generated hashes, or text-content selectors as a long-lived contract.

Cover all states that the version record exposes: default, hover, selected, expanded, focus-visible, enabled, and disabled. Preserve readable contrast and do not place decorative layers above messages, input areas, menus, or buttons.

## Required authoring sequence

1. Read the exact version capability record.
2. Create the source project.
3. Add CSS and local assets.
4. Validate the manifest and resources.
5. Fix errors; review warnings.
6. Pack to `.buddyhue-theme`.
7. Inspect the package and integrity metadata.
8. Install it in the local BuddyHue library.
9. If requested, preflight, apply, and verify against the live WorkBuddy window.
10. Inspect representative screens and interaction states before declaring the skin complete.

Prefer incrementing the theme version whenever packaged content changes. This preserves reproducibility and avoids `install --force` conflicts.
