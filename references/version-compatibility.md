# WorkBuddy version capability records

Read this reference before creating, editing, applying, or validating a theme against a WorkBuddy release.

## Canonical source

BuddyHue maintains exact-version capability records in its main repository:

```text
docs/workbuddy-versions/README.md
docs/workbuddy-versions/<exact-version>.md
```

GitHub index:

```text
https://github.com/TacitLab/BuddyHue/tree/main/docs/workbuddy-versions
```

Raw record pattern:

```text
https://raw.githubusercontent.com/TacitLab/BuddyHue/main/docs/workbuddy-versions/<exact-version>.md
```

Each record identifies the modules and semantic selectors verified for that exact WorkBuddy build, supported CSS and image capabilities, version-specific implementation notes, unsupported surfaces, and validation evidence.

## Resolution procedure

1. Run `wbhue doctor --json` and read `installation.version`. Do not infer the version from screenshots or a theme compatibility range.
2. Prefer a record in the active BuddyHue checkout:

   ```text
   <buddyhue-root>/docs/workbuddy-versions/<exact-version>.md
   ```

3. If it is not available locally and network access is available, read the matching record from the canonical GitHub location.
4. Read the index as well when comparing releases or checking whether a newer exact record supersedes older guidance.
5. Record the exact document and commit or retrieval date in the theme design notes when compatibility decisions depend on it.

## How to use a record

- Design only the modules listed under the stable customization surface.
- Use the listed semantic selectors and state attributes as the compatibility contract.
- Apply the version-specific notes for background transparency, nested surfaces, focus states, hover states, layering, and independent panels.
- Treat hashed, generated, or diagnostic selectors as temporary evidence only.
- Set the manifest's `compatibility.workbuddy` range no wider than the versions for which equivalent records and validation evidence exist.

## When an exact record is missing

An adjacent version record is useful context but is not proof of compatibility.

1. Tell the user that the exact version has no verified capability record.
2. Use `wbhue probe --json` and a privacy-reduced `wbhue snapshot <output.json>` to inspect landmarks without reading conversation text, form values, accessible names, query parameters, or media addresses.
3. Create a new record from the BuddyHue template only after completing `doctor`, `probe`, `snapshot`, `preflight`, `apply`, `verify`, screenshot inspection, and `restore` for that exact version.
4. Do not widen the adapter or theme compatibility range merely because selectors appear similar.
5. Ask before attempting runtime application with `--allow-untested`.

## Maintained record format

New exact-version documents should start from:

```text
docs/workbuddy-versions/TEMPLATE.md
```

The record should contain validation metadata, stable customization surfaces, supported theme capabilities, explicit limitations, differences from the previous verified version, and reproducible validation evidence.
