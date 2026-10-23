#!/usr/bin/env bash

set -u

buddyhue_root="${BUDDYHUE_ROOT:-}"
workbuddy_app="${WORKBUDDY_APP_PATH:-/Applications/WorkBuddy.app}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --buddyhue-root)
      buddyhue_root="${2:-}"
      shift 2
      ;;
    --app-path)
      workbuddy_app="${2:-}"
      shift 2
      ;;
    -h|--help)
      printf '%s\n' "Usage: check-environment.sh [--buddyhue-root PATH] [--app-path PATH]"
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      exit 2
      ;;
  esac
done

missing_tools=0
buddyhue_ready=0
workbuddy_found=0

printf 'BuddyHue environment check\n'
printf 'OS: %s %s\n' "$(uname -s 2>/dev/null || printf unknown)" "$(uname -m 2>/dev/null || printf unknown)"

if command -v node >/dev/null 2>&1; then
  node_version="$(node --version 2>/dev/null || printf unknown)"
  if node -e 'const [major, minor] = process.versions.node.split(".").map(Number); process.exit(major > 20 || (major === 20 && minor >= 12) ? 0 : 1)' >/dev/null 2>&1; then
    printf 'OK Node.js: %s\n' "$node_version"
  else
    printf 'ERROR Node.js: %s; version 20.12 or newer is required\n' "$node_version"
    missing_tools=1
  fi
else
  printf 'ERROR Node.js: not found; version 20.12 or newer is required\n'
  missing_tools=1
fi

if command -v npm >/dev/null 2>&1; then
  printf 'OK npm: %s\n' "$(npm --version 2>/dev/null || printf unknown)"
else
  printf 'ERROR npm: not found\n'
  missing_tools=1
fi

if command -v git >/dev/null 2>&1; then
  printf 'OK Git: %s\n' "$(git --version 2>/dev/null || printf unknown)"
else
  printf 'ERROR Git: not found\n'
  missing_tools=1
fi

cli_kind=""
cli_value=""
if command -v wbhue >/dev/null 2>&1; then
  cli_kind="binary"
  cli_value="$(command -v wbhue)"
elif [ -n "$buddyhue_root" ] && [ -f "$buddyhue_root/bin/wbhue.mjs" ]; then
  cli_kind="source"
  cli_value="$buddyhue_root/bin/wbhue.mjs"
fi

if [ -n "$cli_kind" ]; then
  printf 'OK BuddyHue CLI: %s\n' "$cli_value"
  buddyhue_ready=1
else
  printf 'MISSING BuddyHue CLI: set BUDDYHUE_ROOT or install/link wbhue\n'
fi

if [ -e "$workbuddy_app" ]; then
  printf 'OK WorkBuddy: %s\n' "$workbuddy_app"
  workbuddy_found=1
else
  printf 'MISSING WorkBuddy: %s\n' "$workbuddy_app"
fi

if [ "$missing_tools" -ne 0 ]; then
  printf 'RESULT base dependencies are incomplete\n'
  exit 10
fi

if [ "$buddyhue_ready" -eq 0 ]; then
  printf 'RESULT install BuddyHue before continuing\n'
  exit 11
fi

if [ "$workbuddy_found" -eq 0 ]; then
  printf 'RESULT authoring is available, but live apply and restore are unavailable\n'
  exit 12
fi

printf 'Doctor output follows:\n'
if [ "$cli_kind" = "binary" ]; then
  "$cli_value" doctor --json --app-path "$workbuddy_app"
  doctor_status=$?
else
  node "$cli_value" doctor --json --app-path "$workbuddy_app"
  doctor_status=$?
fi

if [ "$doctor_status" -ne 0 ]; then
  printf 'RESULT BuddyHue doctor requires attention; exit code %s\n' "$doctor_status"
  exit "$doctor_status"
fi

printf 'RESULT environment is ready\n'
