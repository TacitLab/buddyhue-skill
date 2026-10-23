# BuddyHue Skill

这是一个遵循 [Agent Skills 规范](https://agentskills.io/specification)的 WorkBuddy Skill，用于通过 [BuddyHue](https://github.com/TacitLab/BuddyHue) 制作、应用和管理声明式皮肤。

## 能力

- 检查本机环境，并补齐 BuddyHue 所需依赖。
- 在选择可定制模块和选择器之前，查询当前 WorkBuddy 精确版本的能力记录。
- 创建、校验、打包、检查和安装 `.buddyhue-theme` 皮肤文件。
- 对皮肤进行预检、应用、验证、切换和恢复，并在重启 WorkBuddy 或尝试未经验证的版本前征得用户同意。

## 从 SkillHub 安装（推荐）

在 WorkBuddy 中通过 SkillHub 安装：

[安装 BuddyHue Skill](https://skillhub.cn/skills/user_bf54c80c/buddyhue-skill)

安装后，可以直接在 WorkBuddy 中提出这类请求：

- “检查 BuddyHue 环境并安装缺少的依赖。”
- “先确认我的 WorkBuddy 版本支持修改哪些模块，再制作一个企业皮肤。”
- “应用这个 `.buddyhue-theme`，如果需要重启先问我。”
- “恢复 WorkBuddy 默认外观。”

> SkillHub 安装的是供 WorkBuddy 调用的 Skill。BuddyHue CLI 是它执行皮肤制作与应用时使用的运行依赖；若本机尚未安装，Skill 会先检查环境，再按照参考文档完成本地安装。

## 目录结构

```text
buddyhue-skill/
├── SKILL.md
├── scripts/check-environment.sh
├── references/setup-and-cli.md
├── references/theme-authoring.md
├── references/version-compatibility.md
└── evals/evals.json
```

`SKILL.md` 定义任务判断与执行流程；BuddyHue 命令细节和 WorkBuddy 精确版本兼容规则只在相关任务中按需读取。
