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
      printf '%s\n' "用法：check-environment.sh [--buddyhue-root 路径] [--app-path 路径]"
      exit 0
      ;;
    *)
      printf '未知选项：%s\n' "$1" >&2
      exit 2
      ;;
  esac
done

missing_tools=0
buddyhue_ready=0
workbuddy_found=0

printf 'BuddyHue 环境检查\n'
printf '操作系统：%s %s\n' "$(uname -s 2>/dev/null || printf 未知)" "$(uname -m 2>/dev/null || printf 未知)"

if command -v node >/dev/null 2>&1; then
  node_version="$(node --version 2>/dev/null || printf 未知)"
  if node -e 'const [major, minor] = process.versions.node.split(".").map(Number); process.exit(major > 20 || (major === 20 && minor >= 12) ? 0 : 1)' >/dev/null 2>&1; then
    printf '正常 Node.js：%s\n' "$node_version"
  else
    printf '错误 Node.js：%s；需要 20.12 或更高版本\n' "$node_version"
    missing_tools=1
  fi
else
  printf '错误 Node.js：未找到；需要 20.12 或更高版本\n'
  missing_tools=1
fi

if command -v npm >/dev/null 2>&1; then
  printf '正常 npm：%s\n' "$(npm --version 2>/dev/null || printf 未知)"
else
  printf '错误 npm：未找到\n'
  missing_tools=1
fi

if command -v git >/dev/null 2>&1; then
  printf '正常 Git：%s\n' "$(git --version 2>/dev/null || printf 未知)"
else
  printf '错误 Git：未找到\n'
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
  printf '正常 BuddyHue CLI：%s\n' "$cli_value"
  buddyhue_ready=1
else
  printf '缺少 BuddyHue CLI：请设置 BUDDYHUE_ROOT，或安装并链接 wbhue\n'
fi

if [ -e "$workbuddy_app" ]; then
  printf '正常 WorkBuddy：%s\n' "$workbuddy_app"
  workbuddy_found=1
else
  printf '缺少 WorkBuddy：%s\n' "$workbuddy_app"
fi

if [ "$missing_tools" -ne 0 ]; then
  printf '结果：基础依赖不完整\n'
  exit 10
fi

if [ "$buddyhue_ready" -eq 0 ]; then
  printf '结果：继续前需要安装 BuddyHue\n'
  exit 11
fi

if [ "$workbuddy_found" -eq 0 ]; then
  printf '结果：可以制作皮肤，但无法实时应用或恢复\n'
  exit 12
fi

printf '以下是 doctor 检查结果：\n'
if [ "$cli_kind" = "binary" ]; then
  "$cli_value" doctor --json --app-path "$workbuddy_app"
  doctor_status=$?
else
  node "$cli_value" doctor --json --app-path "$workbuddy_app"
  doctor_status=$?
fi

if [ "$doctor_status" -ne 0 ]; then
  printf '结果：BuddyHue doctor 检查需要处理；退出码 %s\n' "$doctor_status"
  exit "$doctor_status"
fi

printf '结果：环境已就绪\n'
