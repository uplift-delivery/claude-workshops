# Agent conventions

## Purpose

This repository creates workshop content for **humans** to read and learn
from: how to use AI for software development. Every document here is written
for a person working through a session, not for an agent.

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
