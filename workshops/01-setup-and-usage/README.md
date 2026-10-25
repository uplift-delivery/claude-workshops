# Session 1: Setup and usage

**Goal:** use an agent well with nothing but a prompt and the requirements.
No `CLAUDE.md`, no skills. Plan before it writes; verify before you believe it.

**You build:** [`01-health.feature`](../../system/features/01-health.feature)
and [`02-ingest.feature`](../../system/features/02-ingest.feature).

**Prerequisites:** [Before session 1](../README.md#before-session-1-10-minutes) is done.

## Steps

### 1. Set up (5 min)

1. Create your service repository with the spec in it, and commit, so any
   bad change is one `git restore .` away:

   ```sh
   mkdir transit-service && cd transit-service && git init
   cp -r <this-repo>/system <this-repo>/fixtures .
   git add . && git commit -m "Add spec and fixtures"
   ```

2. Start `claude` there. Find your permission mode in the status bar.
   **Shift+Tab** cycles it.

### 2. Health check (15 min)

1. Switch to plan mode (**Shift+Tab** until it says *plan*).
2. Prompt with the file, not your memory of it:
   `Implement @system/features/01-health.feature. Shapes are in @system/api-contract.md.`
3. Read the plan. Correct at least one thing before you accept it.
4. Let it build. Then call the endpoint yourself from another terminal.
5. Commit.

### 3. Feed ingest (25 min)

1. Plan mode again:
   `Implement @system/features/02-ingest.feature.`
2. Read the plan. Look for how it parses `24:52:00` and `20260601`.
3. Let it build. Run every scenario yourself with `curl` or your HTTP client.
4. Fix anything that fails. Commit.

### 4. Make the check repeatable (5 min)

`Write a script that runs every scenario in system/features/01-health.feature and 02-ingest.feature against the running service.`

You will re-run this in sessions 2 and 3.

## Done when

- You have seen every scenario in both feature files pass with your own eyes.
- Your check script passes.

## Notice

- What did the agent assume that you never told it?
- When it said "done", what had it actually checked?

## Habits to keep

- **Commit before every prompt.** Revert a bad run; don't argue with it.
- **Restart a stale session.** If the agent repeats a failed fix, start a
  fresh session from the feature file, not the transcript.
- **Paste real errors.** Don't describe them.
