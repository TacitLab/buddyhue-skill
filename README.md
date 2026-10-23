# BuddyHue Skill

An [Agent Skills](https://agentskills.io/specification)-compatible skill for creating and operating declarative WorkBuddy skins with [BuddyHue](https://github.com/TacitLab/BuddyHue).

## Capabilities

- Check the local environment and install BuddyHue dependencies.
- Resolve exact WorkBuddy version capability records before choosing customizable modules or selectors.
- Create, validate, package, inspect, and install `.buddyhue-theme` files.
- Preflight, apply, verify, switch, and restore WorkBuddy skins with explicit safeguards around restarts and unverified versions.

## Install for Claude Code

Clone the repository so the directory name remains `buddyhue-skill`:

```bash
git clone https://github.com/TacitLab/buddyhue-skill.git ~/.claude/skills/buddyhue-skill
```

Restart the Claude Code session after installation so the skill can be discovered.

## Structure

```text
buddyhue-skill/
├── SKILL.md
├── scripts/check-environment.sh
├── references/setup-and-cli.md
├── references/theme-authoring.md
├── references/version-compatibility.md
└── evals/evals.json
```

`SKILL.md` contains the decision workflow. Detailed BuddyHue behavior and exact-version compatibility rules load only when relevant.
