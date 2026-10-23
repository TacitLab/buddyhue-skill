---
name: buddyhue-skill
description: 为 WorkBuddy 配置 BuddyHue，并创建、校验、打包、安装、应用、验证或恢复皮肤。当用户要求定制或品牌化 WorkBuddy、制作 BuddyHue 主题、查询某个 WorkBuddy 精确版本可修改的界面模块、应用 .buddyhue-theme 包、切换已安装主题或恢复默认外观时使用此 Skill。
metadata:
  author: TacitLab
  version: "1.0.0"
---

# WorkBuddy 的 BuddyHue 皮肤能力

将 BuddyHue 作为 WorkBuddy 皮肤的唯一执行层。本 Skill 只负责任务编排：收集需求、编写声明式 CSS 与本地资源、调用 `wbhue`、解释结构化结果，并确保是否重启 WorkBuddy、是否尝试未经验证的版本始终由用户决定。

## 兼容条件

需要 Node.js 20.12 或更高版本、npm 和 Git。应用或恢复皮肤时必须已经安装 WorkBuddy；当前运行流程已在 macOS WorkBuddy 5.9.x 上完成验证。仅在首次安装或本地缺少版本能力记录时需要网络访问。

## 根据任务读取资料

- 环境检查、依赖安装或故障诊断：先阅读 [references/setup-and-cli.md](references/setup-and-cli.md)，再运行 `scripts/check-environment.sh`。
- 创建或修改皮肤：先阅读 [references/version-compatibility.md](references/version-compatibility.md) 及其定位到的 WorkBuddy 精确版本记录，再阅读 [references/theme-authoring.md](references/theme-authoring.md)。
- 应用、切换、验证或恢复皮肤：阅读 [references/setup-and-cli.md](references/setup-and-cli.md)，了解命令行为和退出码。

## 通用执行规则

1. 优先使用 `wbhue ... --json`，根据返回字段和退出码做判断，不要匹配面向用户的显示文本。
2. 修改主题前先检查已有文件。保留无关改动；除非用户明确要求替换，否则不要覆盖已有皮肤包。
3. 将 WorkBuddy 精确版本兼容性视为必须核实的证据，不能凭经验假设。选择模块或选择器前必须阅读对应版本记录。
4. 只制作声明式主题：CSS、清单元数据以及本地 PNG、JPEG、WebP 或 GIF 资源。不得加入 JavaScript、生命周期钩子、远程 CSS、远程字体或远程图片。
5. 不得修改 `app.asar`、WorkBuddy 应用签名、系统安全设置或业务数据。
6. 执行下列操作前必须立即向用户取得明确授权：
   - 重启或关闭 WorkBuddy，包括使用 `--restart` 重试；
   - 使用 `--allow-untested` 尝试未经验证的 WorkBuddy 版本。
7. 解释警告和部分完成的结果。BuddyHue 校验及相关运行时验证通过前，不得宣称任务成功。

## 检查并准备环境

1. 在 Skill 目录运行随附的环境检查脚本：

   ```bash
   scripts/check-environment.sh
   ```

2. 如果缺少 Node.js、npm、Git 或 BuddyHue，按照 [references/setup-and-cli.md](references/setup-and-cli.md) 处理。优先使用本地 BuddyHue 源码目录，并直接调用 `node <buddyhue-root>/bin/wbhue.mjs`；只有用户明确希望全局安装时，才使用 `npm link` 或其他全局安装方式。
3. 运行 `wbhue doctor --json`。报告 WorkBuddy 版本、是否处于已验证范围、WorkBuddy 是否正在运行，以及皮肤通道是否可用。
4. 制作或应用主题前，按照 [references/version-compatibility.md](references/version-compatibility.md) 定位并阅读当前精确版本记录。

## 制作 BuddyHue 皮肤

1. 收集主题名称、品牌色、已有标志或吉祥物、背景偏好、整体气质、无障碍要求，以及不得改变的元素。除非用户要求创作新图，否则优先复用用户提供的资源。
2. 通过 `wbhue doctor --json` 识别 WorkBuddy 精确版本，再阅读其能力记录。设计范围必须限定在文档列出的模块和稳定选择器内。
3. 创建主题源项目：

   ```bash
   wbhue theme create <主题目录> --id <主题标识> --name <主题名称>
   ```

4. 按照 [references/theme-authoring.md](references/theme-authoring.md) 编辑 `buddyhue.json`、`workbuddy.css` 和本地资源。只使用版本记录中的语义选择器，不得把哈希类名或诊断类名写入长期兼容契约。
5. 校验、打包、检查并安装：

   ```bash
   wbhue theme validate <主题目录>/buddyhue.json --json
   wbhue theme pack <主题目录>/buddyhue.json --output <主题标识>.buddyhue-theme --json
   wbhue theme inspect <主题标识>.buddyhue-theme --json
   wbhue install <主题标识>.buddyhue-theme --json
   ```

6. 所有校验错误都必须修复后才能继续。说明非阻断警告及其可能造成的视觉影响。
7. 用户要求实时预览时，继续执行应用流程；如有界面检查工具，应检查关键页面及交互状态。

## 应用或切换皮肤

1. 运行 `wbhue doctor --json`，并定位当前精确版本记录。
2. 用户未指定主题时，运行 `wbhue ls --json`，并只从已安装主题中与用户确认选择。
3. 执行只读预检：

   ```bash
   wbhue preflight <主题标识[@版本]|皮肤包> --json
   ```

4. 如发现皮肤包完整性、兼容性或必要界面标志失败，应停止操作，不得静默绕过。
5. 先尝试不重启应用：

   ```bash
   wbhue apply <主题标识[@版本]|皮肤包> --json
   ```

6. BuddyHue 返回退出码 `4` 时，说明必须重启 WorkBuddy，并在使用 `--restart` 重试前征得用户同意。
7. 当前版本未经验证时，任何使用 `--allow-untested` 的重试都必须先询问用户，并说明选择器漂移或无法完整恢复的风险会增加。
8. 应用后进行验证：

   ```bash
   wbhue verify <主题标识[@版本]|皮肤包> --json
   ```

9. 报告已应用的主题标识和版本、WorkBuddy 版本、检查过的窗口、缺失的界面标志、布局警告，以及是否发生回滚。

## 恢复默认外观

1. 使用 `wbhue status --json` 读取当前状态。
2. 运行：

   ```bash
   wbhue restore --json
   ```

3. 再次运行 `wbhue status --json`。确认 BuddyHue 当前主题凭据已经清除，并报告是否有未连接的 WorkBuddy 窗口导致实时渲染清理未完成。
4. 实时清理需要重启 WorkBuddy 时，必须先询问用户。

## 完成报告

交付说明保持简洁，并包含：

- 环境状态和 WorkBuddy 精确版本；
- 使用的版本能力记录，或明确说明没有对应的精确记录；
- 创建或应用的主题名称、标识和版本；
- 校验、预检和验证结果；
- 警告、获得的授权，以及仍需人工确认的事项；
- 若创建了皮肤，提供源主题和 `.buddyhue-theme` 皮肤包路径。
