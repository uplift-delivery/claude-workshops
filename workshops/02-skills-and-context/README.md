# Session 2: Skills and context

**Goal:** stop repeating yourself. Put always-true facts in `CLAUDE.md`,
install a skill someone else wrote, and write a convention skill of your own.

**You build:** the validation endpoint and one rule from
[`04-validation.feature`](../../system/features/04-validation.feature).

## Catch up (before the session)

Health and ingest not finished? In a fresh session:

`Implement @system/features/01-health.feature and @system/features/02-ingest.feature. Show me a plan first.`

## Steps

### 1. Project context: `CLAUDE.md` (10 min)

1. Run `/init`.
2. Trim the result to what is true on every request: stack, how to run,
   how to test, where code lives, your check script.
3. Fresh session: `How do I run the tests?` It should answer without searching.

| Belongs in `CLAUDE.md` | Belongs in a skill |
|---|---|
| Always true, every request | Needed only for some tasks |
| Run and test commands, layout | "How to add a validation rule" |
| No description needed | Lives or dies by its `description` |

### 2. Use someone else's skill (5 min)

1. Copy [`.claude/skills/gtfs-fixture-builder/`](../../.claude/skills/gtfs-fixture-builder/)
   into your repo's `.claude/skills/`.
2. Fresh session: `Build a fixture feed with one stop at null island.`
3. Confirm the skill fired (it shows in the transcript). Read its `description`.
   That one line is why it fired.

### 3. Write a convention skill and use it (30 min)

1. Plan mode:
   `Add POST and GET /feeds/{feedId}/validation and the null-island-stop rule from @system/features/04-validation.feature. Design it so each rule is one file and adding a rule never edits another.`
2. Build it. Check the `null-island-stop` rows of the scenario outline.
3. Ask the agent to write `.claude/skills/add-validation-rule/SKILL.md` from
   what it just built: where a rule file goes, how it registers, the finding
   shape, how to test it.
4. Rewrite the `description` yourself. Say **when** to use it, not what it
   is. Model it on `gtfs-fixture-builder`'s.
5. Commit. Session 3 starts from this commit.

## Done when

In a fresh session, `Add the unused-stop rule` makes the
`add-validation-rule` skill fire without you naming it. Stop it once you see
the skill fire; session 3 builds the rule.

Not firing? Fix the `description`, not the body.

## Notice

- Which facts did you stop typing today?
- Session 3 runs four agents at once. This skill is the only reason their
  code will match.
