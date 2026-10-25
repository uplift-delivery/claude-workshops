# Session 3 facilitator guide

Read the [participant guide](README.md) first.

**The one lesson:** parallel work costs you at integration. A good brief and
a shared convention keep that cost low. More agents is not the goal.

## Before

Track A needs Claude Code with agent teams enabled. Track B needs
dependencies installed in each worktree. Ask for both in the invitation.

## Timing

| Min | What |
|---|---|
| 0–5 | Framing: we grade on integration cost, not agent count. |
| 5–10 | Step 1, the brief. Read two briefs aloud. |
| 10–35 | Step 2, agents running. |
| 35–50 | Step 3, integration. It will run over. Let it, until minute 50. |
| 50–60 | Debrief, even if merges are unfinished. Unfinished merges are debrief material. |

## Behind on the build?

No validation endpoint or skill: pair with someone who has them and own one
of their agents' briefs. Or run the shipped
[`gtfs-adversary`](../../.claude/agents/gtfs-adversary.md) subagent against
their ingest. Either way they practice delegating and judging the result.

## Let it happen

- Two agents edit the same file and conflict. That is the decomposition lesson.
- A thin brief produces plausible code that fails the scenarios.
- Someone runs four agents where two would have finished sooner.

## Step in

- Still installing dependencies in worktrees at minute 20: switch them to
  Track A or to two sessions in one checkout on separate rule files.
- Anyone merging without re-running the scenarios.

## Coaching prompts

| You see | Say |
|---|---|
| Before an agent starts | "What does it need that's only in your head?" |
| A merge conflict | "What file boundary would have prevented this?" |
| Reading transcripts line by line | "What artifact answers that faster?" |
| More than 5 findings | "Two rules are probably reporting the same defect." |

## Debrief

1. Faster than sequential, honestly counting integration time?
2. Whose rules came out the same shape, and what did they have in place?
3. What would you refuse to parallelize on client work?

Make sure everyone has written down their integration time before they leave.
