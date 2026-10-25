# Extras

Optional. Do these after session 3, or during a session if you finish early.
Each is independent and has its own feature file.

| Extra | Feature | Good practice for |
|---|---|---|
| Service queries | [`03-query.feature`](../system/features/03-query.feature) | Domain traps: exception dates and past-midnight times. Write a skill for them. |
| Feed diff | [`06-diff.feature`](../system/features/06-diff.feature) | Describing changes for humans, not rows |
| UI | [`05-ui.feature`](../system/features/05-ui.feature) (needs queries) | A third parallel thread beside the other two |
| Adversary | [`gtfs-adversary`](../.claude/agents/gtfs-adversary.md) | Delegating to a subagent that tries to break your validator |

Try queries and diff as two parallel threads, using what session 3 taught you.
