# Session 3: Parallel agents

**Goal:** split independent work across several agents at once, then
integrate it. Parallel work is only as good as your brief and your merge.

**You build:** the four remaining rules in
[`04-validation.feature`](../../system/features/04-validation.feature).

## Catch up (before the session)

No validation endpoint or `add-validation-rule` skill yet? Do
[session 2, step 3](../02-skills-and-context/README.md#3-write-a-convention-skill-and-use-it-30-min)
first. Without the skill, the agents will each invent a different shape.

## Steps

### 1. Write the brief (5 min)

Each agent owns exactly one rule file. Write down what the agent needs and
can't guess:

- the rule name and its rows in `04-validation.feature`
- "Use the add-validation-rule skill"
- "Edit only your rule file and its test"
- "Done when your rule's scenario rows pass"

### 2. Run the agents (25 min)

Pick one track.

**Track A: agent team (Claude Code)**

1. Enable it once, in `.claude/settings.json`:

   ```json
   { "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
   ```

2. Restart Claude Code, then prompt the lead:
   `Create an agent team with four teammates, one per remaining rule in @system/features/04-validation.feature. <your brief>`
3. **Up/Down** selects a teammate, **Enter** opens it, **Ctrl+T** shows the
   task list. Watch the task list, not the transcripts.

Teammates share one working tree. The "one file per rule" brief is what
keeps them apart.

**Track B: parallel sessions (any tool)**

1. One worktree and session per rule:

   ```sh
   claude -w travel-speed     # repeat for unused-stop, color-contrast, window-coverage
   ```

   Worktrees land in `.claude/worktrees/`; add that to `.gitignore`. Each is
   a fresh checkout, so install dependencies and copy any `.env` first.
2. Paste your brief into each. Commit in each worktree when it passes.

### 3. Integrate and verify (15 min)

1. Track B only: merge each branch from your main checkout
   (`git merge worktree-travel-speed`, and so on).
2. Run your check script and the full validation scenario outline.
3. Validate `demo-feed-v2` too. Its expected findings differ.

## Done when

- Every row of `04-validation.feature` passes for both feeds.
- `demo-feed` has exactly 5 findings.
- You wrote down: how many agents you ran, minutes from last agent done to
  all green, and what you fixed by hand.

## Notice

- Was it faster than doing the rules one at a time, counting integration?
- Did the four rules come out the same shape? Why?
- What would you never split this way on real work?
