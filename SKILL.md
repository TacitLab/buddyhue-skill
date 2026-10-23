---
name: buddyhue-skill
description: Set up BuddyHue and create, validate, package, install, apply, verify, or restore WorkBuddy skins. Use this skill whenever a user asks to customize or brand WorkBuddy, make a BuddyHue theme, inspect which UI modules an exact WorkBuddy version supports, apply a .buddyhue-theme package, switch an installed theme, or return WorkBuddy to its default appearance.
metadata:
  author: TacitLab
  version: "1.0.0"
---

# BuddyHue for WorkBuddy

Use BuddyHue as the only execution layer for WorkBuddy skins. Keep the skill as a thin orchestrator: gather requirements, author declarative CSS and local assets, call `wbhue`, interpret its structured results, and preserve the user's control over restarts or unverified versions.

## Compatibility

Require Node.js 20.12 or newer, npm, and Git. Applying or restoring a skin requires WorkBuddy and is currently verified on macOS WorkBuddy 5.9.x. Network access is needed only for initial setup or reading version records that are not available locally.

## Route the request

- For setup, dependency installation, or environment diagnosis, read [references/setup-and-cli.md](references/setup-and-cli.md), then run `scripts/check-environment.sh`.
- Before creating or editing a skin, read [references/version-compatibility.md](references/version-compatibility.md) and the exact WorkBuddy version record it resolves. Then read [references/theme-authoring.md](references/theme-authoring.md).
- For applying, switching, verifying, or restoring a skin, read [references/setup-and-cli.md](references/setup-and-cli.md) for command behavior and exit codes.

## Shared operating rules

1. Prefer `wbhue ... --json` and decide from the returned fields and exit code instead of matching human-readable output.
2. Inspect existing theme files before editing them. Preserve unrelated changes and avoid overwriting an existing package unless the user requested replacement.
3. Treat exact WorkBuddy version compatibility as evidence, not an assumption. Read the version record before selecting modules or selectors.
4. Build only declarative themes: CSS, manifest metadata, and local PNG, JPEG, WebP, or GIF assets. Do not add JavaScript, lifecycle hooks, remote CSS, remote fonts, or remote images.
5. Do not modify `app.asar`, the WorkBuddy application signature, system security settings, or business data.
6. Request explicit authorization immediately before either of these actions:
   - restarting or closing WorkBuddy, including retrying with `--restart`;
   - attempting an unverified WorkBuddy version with `--allow-untested`.
7. Explain warnings and partial results. Do not report success until BuddyHue validation and the relevant runtime verification pass.

## Check and prepare the environment

1. Run the bundled environment checker from the skill directory:

   ```bash
   scripts/check-environment.sh
   ```

2. If Node.js, npm, Git, or BuddyHue is missing, follow [references/setup-and-cli.md](references/setup-and-cli.md). Prefer a local BuddyHue checkout and direct `node <buddyhue-root>/bin/wbhue.mjs` invocation; use `npm link` or another global installation only when the user wants it.
3. Run `wbhue doctor --json`. Report the WorkBuddy version, whether it is in the verified range, whether WorkBuddy is running, and whether the skin channel is available.
4. Resolve the exact version record using [references/version-compatibility.md](references/version-compatibility.md) before authoring or applying a theme.

## Create a BuddyHue skin

1. Collect the theme name, brand colors, available logos or mascots, background preference, tone, accessibility needs, and elements that must not change. Reuse supplied assets instead of recreating them unless the user asks for new artwork.
2. Identify the exact WorkBuddy version with `wbhue doctor --json`, then read its capability record. Limit the design to the documented modules and stable selectors.
3. Create a source project:

   ```bash
   wbhue theme create <theme-directory> --id <theme-id> --name <theme-name>
   ```

4. Edit `buddyhue.json`, `workbuddy.css`, and local assets according to [references/theme-authoring.md](references/theme-authoring.md). Use semantic selectors from the version record; do not promote hashed or diagnostic classes into the compatibility contract.
5. Validate, package, inspect, and install:

   ```bash
   wbhue theme validate <theme-directory>/buddyhue.json --json
   wbhue theme pack <theme-directory>/buddyhue.json --output <theme-id>.buddyhue-theme --json
   wbhue theme inspect <theme-id>.buddyhue-theme --json
   wbhue install <theme-id>.buddyhue-theme --json
   ```

6. Fix validation errors before continuing. Explain non-blocking warnings and their likely visual impact.
7. When the user wants a live preview, continue with the application workflow and visually inspect important states where a UI inspection tool is available.

## Apply or switch a skin

1. Run `wbhue doctor --json` and resolve the exact version record.
2. If no theme was specified, run `wbhue ls --json` and choose only from installed themes with the user.
3. Run a read-only preflight:

   ```bash
   wbhue preflight <theme-id[@version]|package> --json
   ```

4. Stop on package integrity, compatibility, or required-landmark failures. Do not bypass them silently.
5. Apply without restart first:

   ```bash
   wbhue apply <theme-id[@version]|package> --json
   ```

6. If BuddyHue returns exit code `4`, explain that WorkBuddy must restart and ask for authorization before retrying with `--restart`.
7. If the version is unverified, ask before any retry with `--allow-untested` and describe the increased risk of selector drift or incomplete restoration.
8. Verify after application:

   ```bash
   wbhue verify <theme-id[@version]|package> --json
   ```

9. Report the applied theme ID and version, WorkBuddy version, checked windows, missing landmarks, layout warnings, and whether rollback occurred.

## Restore the default appearance

1. Read the current state with `wbhue status --json`.
2. Run:

   ```bash
   wbhue restore --json
   ```

3. Run `wbhue status --json` again. Confirm that the active BuddyHue theme receipt is cleared and report whether a disconnected WorkBuddy window prevented live renderer cleanup.
4. If live cleanup requires restarting WorkBuddy, ask before restarting it.

## Completion report

Keep the handoff concise and include:

- environment and exact WorkBuddy version;
- version capability record used, or that no exact record exists;
- created or applied theme name, ID, and version;
- validation, preflight, and verification status;
- warnings, approvals used, and any remaining manual check;
- paths to the source theme and packaged `.buddyhue-theme` file when one was created.
