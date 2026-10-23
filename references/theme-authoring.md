# BuddyHue v1 皮肤制作规范

创建或编辑 BuddyHue 皮肤时，阅读本参考文档。

## 主题源项目

最小主题包含：

```text
my-theme/
├── buddyhue.json
└── workbuddy.css
```

本地图片可以放在 `assets/` 中。

## 清单示例

```json
{
  "$schema": "<buddyhue-path>/schemas/buddyhue-manifest.schema.json",
  "schemaVersion": 1,
  "id": "ocean-brand",
  "name": "海洋品牌",
  "version": "1.0.0",
  "description": "一款沉稳的企业级 WorkBuddy 主题。",
  "author": "示例设计团队",
  "license": "保留所有权利",
  "tags": ["企业", "蓝色"],
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

`$schema` 应使用从实际主题目录出发能够正确解析的相对路径。条件允许时，优先通过 `wbhue theme create` 生成初始文件。

## 兼容版本范围

BuddyHue v1 接受以下固定格式：

```text
>=最低版本 <最高版本
```

兼容范围只能覆盖已经存在精确版本能力记录且拥有等效验证证据的版本。宽泛的版本范围不能代替实际测试。

## CSS 与资源限制

- CSS 不得超过 1 MiB。
- 打包后的主题不得超过 30 MiB。
- 每个皮肤包最多包含 32 张图片。
- 图片格式可以是 PNG、JPEG、WebP 或 GIF。
- 图片标识必须匹配 `[A-Za-z0-9][A-Za-z0-9_-]*`。
- 不得使用 `@import`。
- CSS 中不得使用非 `data:` 地址。
- 不得包含 JavaScript、渲染器插件、命令或生命周期脚本。
- 源文件和资源必须位于主题项目内；拒绝绝对路径以及通过 `..` 跨越目录的路径。

打包后的图片会以 CSS 变量形式提供：

```css
background-image: var(--codedrobe-image-background);
```

## 选择器规则

适当时，应将规则限定在 BuddyHue 宿主类名下：

```css
html.codedrobe-theme.codedrobe-host-workbuddy {
  --theme-accent: #2f6dd5;
}
```

只使用 WorkBuddy 精确版本记录中列出的语义选择器。不得把 `_grid_*`、生成的哈希类名或基于文本内容的选择器作为长期兼容契约。

覆盖版本记录所暴露的全部状态：默认、悬停、选中、展开、键盘聚焦、启用和禁用。保持文字对比度；装饰层不得覆盖消息、输入区域、菜单或按钮。

## 必须遵循的制作顺序

1. 阅读 WorkBuddy 精确版本能力记录。
2. 创建主题源项目。
3. 添加 CSS 和本地资源。
4. 校验清单与资源。
5. 修复错误并审阅警告。
6. 打包为 `.buddyhue-theme`。
7. 检查皮肤包及其完整性元数据。
8. 安装到本地 BuddyHue 主题库。
9. 用户要求时，对实时 WorkBuddy 窗口执行预检、应用和验证。
10. 检查代表性页面与交互状态后，才能宣告皮肤完成。

每次打包内容发生变化时，优先提高主题版本号，以便保持结果可复现并避免 `install --force` 冲突。
