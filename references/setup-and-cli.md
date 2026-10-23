# BuddyHue 环境配置与命令操作

处理环境配置、依赖安装、皮肤应用、默认外观恢复或 BuddyHue 退出码时，阅读本参考文档。

## 环境要求

- Node.js 20.12 或更高版本
- npm
- Git
- macOS 版 WorkBuddy（当前已验证的运行环境）
- 首次获取源码及执行 `npm install` 时需要网络访问

BuddyHue 官方源码仓库：

```text
https://github.com/TacitLab/BuddyHue
```

## 查找已有命令行工具

按以下顺序检查：

1. `command -v wbhue`
2. 用户提供且包含 `bin/wbhue.mjs` 的 BuddyHue 源码目录
3. 附近目录中 `package.json` 的 `"name"` 为 `"buddyhue"` 的源码目录

直接使用源码目录时，调用：

```bash
node <buddyhue-root>/bin/wbhue.mjs <命令>
```

不要假设系统已经存在全局链接。

## 首次本地安装

选择一个不会覆盖已有目录的位置，然后运行：

```bash
git clone https://github.com/TacitLab/BuddyHue.git <buddyhue-root>
npm install --prefix <buddyhue-root>
node <buddyhue-root>/bin/wbhue.mjs --help
node <buddyhue-root>/bin/wbhue.mjs doctor --json
```

这种方式将安装范围限制在源码目录内。如果用户明确希望获得全局 `wbhue` 命令，应先说明它会修改整台机器的 npm 全局命令集合，再从源码目录执行 `npm link`。

不要使用 `curl | sh`，不要为了安装 BuddyHue 修改 WorkBuddy，也不要降低 macOS 安全设置。

## 常用命令

```text
wbhue doctor --json
wbhue status --json
wbhue home --json
wbhue install <皮肤包> --json
wbhue ls --json
wbhue info <标识[@版本]> --json
wbhue preflight <皮肤包|标识[@版本]> --json
wbhue apply <皮肤包|标识[@版本]> --json
wbhue verify <皮肤包|标识[@版本]> --json
wbhue restore --json
wbhue probe [皮肤包|标识[@版本]] --json
wbhue snapshot <输出文件.json>
wbhue theme create <目录> --id <标识> --name <名称>
wbhue theme validate <buddyhue.json> --json
wbhue theme pack <buddyhue.json> --output <名称.buddyhue-theme> --json
wbhue theme inspect <名称.buddyhue-theme> --json
```

## 影响任务判断的退出码

| 退出码 | 含义 | 处理方式 |
| --- | --- | --- |
| `0` | 成功 | 继续下一项校验。 |
| `2` | 命令或参数无效 | 修正调用方式。 |
| `3` | WorkBuddy 版本未经验证 | 停止，或在使用 `--allow-untested` 前询问用户。 |
| `4` | 必须重启 WorkBuddy | 在使用 `--restart` 重试前询问用户。 |
| `5` | DOM 兼容或验证失败 | 报告回滚情况并检查界面标志。 |
| `6` | 皮肤包或完整性校验失败 | 修复或重新构建皮肤包。 |
| `7` | 主题兼容版本范围不匹配 | 改用兼容主题，不要强制应用。 |
| `8` | 未找到 WorkBuddy | 确认安装位置或 `--app-path`。 |
| `9` | 未找到已安装主题 | 安装皮肤包或修正主题标识。 |
| `10` | 主题库冲突或当前版本保护 | 核实主题库的精确状态，不得删除当前主题。 |

## 会改变状态的选项

- `--restart` 授权 BuddyHue 重启 WorkBuddy，使用前必须立即询问用户。
- `--allow-untested` 会尝试超出已验证适配范围的 WorkBuddy 版本，使用前必须立即询问用户。
- `install --force` 会用相同主题标识和版本替换不同内容。优先提高主题版本号；只有用户明确要求替换时才使用强制安装。

## 处理 JSON 结果

主要命令都会返回稳定的结果结构，其中包含 `schemaVersion`、`tool`、`command` 和 `ok`。应读取命令专属字段，不要解析显示文本。用户不需要本地路径时，应在报告中隐藏或省略这些路径。
