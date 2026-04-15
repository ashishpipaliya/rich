# Agent Skills

This project has skills installed in `.agents/skills/`. Each skill is a guide describing how to implement a specific feature or pattern in this codebase.

## Available Skills

| Skill | Path |
|---|---|
| clean-architecture | `.agents/skills/clean-architecture/SKILL.md` |
| di-injectable | `.agents/skills/di-injectable/SKILL.md` |
| freezed-generation | `.agents/skills/freezed-generation/SKILL.md` |
| localization | `.agents/skills/localization/SKILL.md` |
| networking | `.agents/skills/networking/SKILL.md` |
| notifications | `.agents/skills/notifications/SKILL.md` |
| permissions | `.agents/skills/permissions/SKILL.md` |
| project-architecture | `.agents/skills/project-architecture/SKILL.md` |
| routing | `.agents/skills/routing/SKILL.md` |
| solid-oop | `.agents/skills/solid-oop/SKILL.md` |
| state-management | `.agents/skills/state-management/SKILL.md` |
| testing | `.agents/skills/testing/SKILL.md` |
| theme | `.agents/skills/theme/SKILL.md` |
| ui-patterns | `.agents/skills/ui-patterns/SKILL.md` |

## Rules

- Before implementing any feature or pattern, check if a relevant skill exists in the table above.
- If a matching skill exists, read its `SKILL.md` file first and follow its conventions exactly.
- Multiple skills may apply to a single task — read all relevant ones before starting.
- Never skip reading a skill just because you have general knowledge of the topic. The skill defines this project's specific conventions.
- New skills installed via `npx skills add` will appear in `.agents/skills/` — update this file when new skills are added.
