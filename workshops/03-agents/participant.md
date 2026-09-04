# Workshop 3: Agents

## The technique

Delegate scoped work to a subagent instead of steering it turn by turn, and
run more than one agent thread at once when the work genuinely splits into
independent pieces.

## Why it matters

You have spent two sessions reading everything an agent did before trusting
it. That does not scale to four threads running at once — you cannot read
four transcripts in real time, and if you catch yourself trying to, running
the four threads sequentially would have cost you less attention. Delegation
only pays off when you have written a brief good enough that you can judge
the finished artifact — the diff, the report, the fixture — without having
watched it get produced. A subagent that needs constant correction mid-task
was never delegated to; it was supervised through an extra layer of
indirection.

## The exercise

Two parts, then integration.

Three words this session uses precisely, because they are three different
things. A **session** is one conversation you are steering, with its own
transcript. A **subagent** is a brief a session hands scoped work to and
gets a result back from — it runs inside your session and reports into it.
A **thread** is a separate session, doing its own work at the same time as
yours. Subagents report back, so two of them cannot collide; threads do
not, which is why threads need isolating and subagents do not. When the
checkpoint asks how many threads you ran, it means the third one.

**Part one, roughly twenty minutes.** Define one subagent and delegate one
scoped task to it. In Claude Code a subagent is a markdown file under
`.claude/agents/` whose YAML frontmatter carries a `name`, a `description`
saying when to delegate to it, and optionally the tools it may use; the body
is the brief it runs on.
[`gtfs-adversary.md`](../../.claude/agents/gtfs-adversary.md) is the worked
example to copy that shape from, the way `gtfs-fixture-builder` was in
session 2. Pick either:

- A validator implementer, briefed with the convention skill you wrote in
  session 2, and handed one new rule from
  [`../../system/acceptance/04-validation.md`](../../system/acceptance/04-validation.md)
  to add.
- An adversary whose only job is to use
  [`../../.claude/skills/gtfs-fixture-builder/`](../../.claude/skills/gtfs-fixture-builder/)
  to build a hostile feed that breaks a validator you already have. The
  shipped `gtfs-adversary` is deliberately general; narrowing its brief to
  the one validator you actually have is the exercise, not a shortcut past
  it.

Review the artifact it produced — the diff, the fixture, the finding — not
the transcript of how it got there.

Then confirm it actually ran. Invoke it by name, and check that the
subagent appears in the transcript doing the work rather than your main
session doing the same work with a file sitting unread on disk. This is
session 2's checkpoint again in a different costume: if it did not fire,
the fix is the `description`, not the brief. A subagent that never ran and
a subagent that ran well produce the same rule and look identical
afterwards, which is exactly why this has to be checked at the time.

**Part two, roughly twenty minutes.** Start two threads on independent work
from [`../../system/backlog.md`](../../system/backlog.md) — two different
validation rules, or a rule and a UI view whose data already exists. Isolate
them with a worktree per thread so they cannot collide:

```
git worktree add ../svc-rule-a -b rule-a
git worktree add ../svc-rule-b -b rule-b
```

A worktree is a second checkout of the same repository on its own branch,
sharing one history with the original. The part that costs you time if you
discover it mid-exercise is that it really is a fresh checkout:
dependencies are not installed in it, and anything gitignored — an `.env`,
a local database file, a credentials JSON — is not there either. Install
and copy those in before you start the threads, not after a thread has
already failed on a missing module.

**Integration, roughly ten minutes after that.** Merge both threads' work and
confirm the whole system still satisfies its acceptance criteria — if you
built the re-runnable check session 1 asked for, this is what it was for.
Integration is timed separately from the threads on purpose: this is the
part the session is measuring.

**Checkpoint** — two things, one about the code and one about the cost.

Every validation rule you have implemented produces exactly the findings
[`../../fixtures/ANSWER-KEY.md`](../../fixtures/ANSWER-KEY.md#validation-findings)
attributes to that rule under "Validation findings", and no finding appears
that none of your rules should produce. Do not measure yourself against all
five: part one adds at most one rule and part two adds two, so five is the
end state after the continuation work, not today's bar. Over-flagging is the
signal to chase — a finding no implemented rule accounts for usually means
two threads implemented overlapping rules and the same defect is reported
twice under two names.

Then write down, somewhere you will find it again: how many threads you ran
and why that number rather than one more, how long integration took measured
from the last thread finishing to acceptance passing again, and what you had
to fix by hand to get there. Two or three lines is enough. The continuation
work asks you to make the same decision at a larger scale, and this is what
you will check it against.

## What to notice

How much of the brief you had to write down before delegating felt safe —
anything left in your head is a question the subagent had to guess the
answer to. Whether the two threads produced code in the same shape, and if
they did, what actually caused that: a convention skill, a shared file both
threads read, or plain luck. How long integration took relative to the work
each thread did on its own.

## Continue on your own

Break slices 4, 5, and 6 into their independent pieces — the five
validation rules, the feed diff, which needs only ingest, and the UI views
whose data already exists. Before you open a single thread, decide how many
you are going to run at once, and write down why that number and not the
maximum available is the right one for what you know about the pieces and
about each other. Then run it — a worktree and a session per piece, in
whatever tool you used today, is enough; tools that manage the threads for
you, like Zed's agent panel or Cursor's background agents, change the
plumbing and not the decision — and check that decision against what
integration actually cost once everything is merged. The
number of threads is a decision with a cost attached to it, not a default —
getting that decision right, more than any code this system ends up with,
is what you will take back to client work.

## In other tools

The technique carries over; only how much of it you watch happen, and how,
changes.

- **Copilot** — hand a task to the coding agent by assigning it an issue or
  using the agents panel; it works independently in its own sandbox and
  comes back as a pull request you review, not a session you sit through.
- **Cursor** — background agents run in isolated environments on separate
  branches; the Agents window launches several at once, each landing as its
  own diff to review.

The isolation-and-review pattern is the same everywhere: give the agent a
scope it cannot wander outside of, let it run unwatched, and judge what it
produced. Only the plumbing changes.
