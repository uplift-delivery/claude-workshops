# Other tools

The guides use Claude Code. The technique is the same everywhere; only the
controls change.

| Step | Claude Code | Copilot (VS Code) | Cursor |
|---|---|---|---|
| Attach a file | `@path` | `#file` or the attachment button | `@file` |
| Plan before code | Shift+Tab to plan mode | Plan mode | Plan mode (Shift+Tab) |
| Always-on context | `CLAUDE.md` | `.github/copilot-instructions.md` | `.cursor/rules/` set to always apply |
| Skill that fires on its own | `.claude/skills/<name>/SKILL.md` | No direct equivalent; prompt files (`.github/prompts/`) run by name | `.cursor/rules/` with only a description |
| Parallel agents | Agent teams, or `claude -w` per worktree | Assign an issue to the coding agent; it returns a PR | Background/cloud agents, one branch each |

Many tools also read `AGENTS.md` as always-on context.
