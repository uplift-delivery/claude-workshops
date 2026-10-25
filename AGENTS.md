# Agent conventions

## Purpose

This repository creates workshop content for **humans** to read and learn
from: how to use AI for software development. Every document here is written
for a person working through a session, not for an agent.

## Writing workshop content

- **Be succinct.** Participants read these docs during a one-hour session.
  Prefer short steps, tables, and checklists over paragraphs.
- **Reference, don't repeat.** Link to static data (`system/api-contract.md`,
  `system/gtfs-reference.md`, `fixtures/ANSWER-KEY.md`) instead of restating it.
- **Write requirements as Gherkin.** They live in `system/features/*.feature`.
  Every scenario has exactly one `When`.
- **Keep sessions self-contained.** Participants have day jobs and do little
  between sessions. Each session builds what the next one needs, and starts
  with a catch-up step for anyone who is behind.
- **One goal per session.** Each session demonstrates only its own goal:
  1. Setup and usage, with little extra context
  2. Skills, context, and conventions
  3. Agent teams or multiple parallel threads of work

## Development workflow

- Do all development in a git worktree, never directly in the main checkout.
- Create worktrees under `.worktrees/` at the repository root, one per branch:

  ```sh
  git worktree add .worktrees/<branch> -b <branch>
  ```

- `.worktrees/` is gitignored. Do not commit anything inside it.
- Remove the worktree once its branch is merged:

  ```sh
  git worktree remove .worktrees/<branch>
  ```
