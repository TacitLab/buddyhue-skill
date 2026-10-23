# BuddyHue setup and CLI operations

Read this reference for environment setup, dependency installation, application, restoration, or BuddyHue exit-code handling.

## Requirements

- Node.js 20.12 or newer
- npm
- Git
- macOS WorkBuddy for the currently verified runtime workflow
- Network access for the initial clone and `npm install`

The canonical BuddyHue repository is:

```text
https://github.com/TacitLab/BuddyHue
```

## Locate an existing CLI

Try these options in order:

1. `command -v wbhue`
2. A user-provided BuddyHue checkout containing `bin/wbhue.mjs`
3. A nearby checkout whose `package.json` has `"name": "buddyhue"`

When using a checkout directly, invoke:

```bash
node <buddyhue-root>/bin/wbhue.mjs <command>
```

Do not assume a global link is present.

## Fresh local setup

Choose a destination that does not overwrite an existing directory, then run:

```bash
git clone https://github.com/TacitLab/BuddyHue.git <buddyhue-root>
npm install --prefix <buddyhue-root>
node <buddyhue-root>/bin/wbhue.mjs --help
node <buddyhue-root>/bin/wbhue.mjs doctor --json
```

This keeps the installation local to the checkout. If the user explicitly wants a global `wbhue` command, run `npm link` from the checkout after explaining that it changes the machine-wide npm command set.

Do not use `curl | sh`, modify WorkBuddy, or weaken macOS security to install BuddyHue.

## Common commands

```text
wbhue doctor --json
wbhue status --json
wbhue home --json
wbhue install <package> --json
wbhue ls --json
wbhue info <id[@version]> --json
wbhue preflight <package|id[@version]> --json
wbhue apply <package|id[@version]> --json
wbhue verify <package|id[@version]> --json
wbhue restore --json
wbhue probe [package|id[@version]] --json
wbhue snapshot <output.json>
wbhue theme create <directory> --id <id> --name <name>
wbhue theme validate <buddyhue.json> --json
wbhue theme pack <buddyhue.json> --output <name.buddyhue-theme> --json
wbhue theme inspect <name.buddyhue-theme> --json
```

## Decision-relevant exit codes

| Code | Meaning | Response |
| --- | --- | --- |
| `0` | Success | Continue to the next validation step. |
| `2` | Invalid command or argument | Correct the invocation. |
| `3` | WorkBuddy version is not verified | Stop or ask before `--allow-untested`. |
| `4` | WorkBuddy restart is required | Ask before retrying with `--restart`. |
| `5` | DOM compatibility or verification failed | Report rollback and inspect landmarks. |
| `6` | Package or integrity failure | Repair or rebuild the package. |
| `7` | Theme compatibility range mismatch | Use a compatible theme; do not force it. |
| `8` | WorkBuddy was not found | Confirm installation or `--app-path`. |
| `9` | Installed theme was not found | Install the package or correct the ID. |
| `10` | Theme library conflict or active-version protection | Resolve the exact library state; do not delete the active theme. |

## State-changing options

- `--restart` authorizes BuddyHue to restart WorkBuddy. Ask immediately before using it.
- `--allow-untested` attempts a WorkBuddy version outside the verified adapter range. Ask immediately before using it.
- `install --force` replaces different content using the same theme ID and version. Prefer a version bump; use force only when the user explicitly wants replacement.

## JSON result handling

All primary commands return a stable envelope containing `schemaVersion`, `tool`, `command`, and `ok`. Read command-specific fields rather than parsing display strings. Redact or omit local paths in reports when the user does not need them.
