# WorkBuddy 版本能力记录

针对某个 WorkBuddy 版本创建、编辑、应用或验证主题前，阅读本参考文档。

## 权威来源

BuddyHue 在主仓库中维护精确版本能力记录：

```text
docs/workbuddy-versions/README.md
docs/workbuddy-versions/<精确版本>.md
```

GitHub 索引：

```text
https://github.com/TacitLab/BuddyHue/tree/main/docs/workbuddy-versions
```

原始记录地址格式：

```text
https://raw.githubusercontent.com/TacitLab/BuddyHue/main/docs/workbuddy-versions/<精确版本>.md
```

每份记录都会说明该 WorkBuddy 精确版本已经验证的模块和语义选择器、支持的 CSS 与图片能力、版本专属实现说明、不支持的界面区域以及验证证据。

## 定位流程

1. 运行 `wbhue doctor --json`，读取 `installation.version`。不得根据截图或主题兼容范围推断版本。
2. 优先读取当前 BuddyHue 源码目录中的记录：

   ```text
   <buddyhue-root>/docs/workbuddy-versions/<精确版本>.md
   ```

3. 本地没有记录且网络可用时，从 GitHub 权威地址读取匹配文档。
4. 比较多个版本或检查新记录是否取代旧指引时，同时阅读索引文件。
5. 兼容性决策依赖该记录时，在主题设计说明中记下精确文档以及提交版本或读取日期。

## 如何使用版本记录

- 只设计“稳定可定制范围”中列出的模块。
- 将文档列出的语义选择器和状态属性作为兼容契约。
- 遵循该版本关于背景透明度、嵌套表面、聚焦状态、悬停状态、层级和独立面板的专属说明。
- 哈希、自动生成或诊断用选择器只能视为临时证据。
- 清单中的 `compatibility.workbuddy` 范围不得超出已经具备等效版本记录和验证证据的版本。

## 缺少精确版本记录时

相邻版本的记录只能作为参考，不能证明兼容。

1. 告知用户当前精确版本没有经过验证的能力记录。
2. 使用 `wbhue probe --json` 和经过隐私缩减的 `wbhue snapshot <输出文件.json>` 检查界面标志；不得读取对话文本、表单值、无障碍名称、查询参数或媒体地址。
3. 只有为该精确版本完成 `doctor`、`probe`、`snapshot`、`preflight`、`apply`、`verify`、截图检查和 `restore` 后，才能根据 BuddyHue 模板创建新记录。
4. 不得仅因选择器看起来相似，就扩大适配器或主题的兼容版本范围。
5. 使用 `--allow-untested` 尝试实时应用前，必须询问用户。

## 版本记录格式

新的精确版本文档应从以下模板开始：

```text
docs/workbuddy-versions/TEMPLATE.md
```

记录应包含验证元数据、稳定可定制范围、支持的主题能力、明确限制、与上一个已验证版本的差异，以及可复现的验证证据。
