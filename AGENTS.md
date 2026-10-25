# Agent conventions

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
