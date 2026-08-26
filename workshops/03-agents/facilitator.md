# Workshop 3: Agents — facilitator guide

Companion to [`participant.md`](participant.md). Read that first; this
guide assumes you know what participants were asked to do.

## Timing

| Minutes | What happens |
|---|---|
| 0–5 | Framing. State plainly, before anyone starts a thread, that parallelism is not free — the goal today is a scoped brief and an honest accounting of what integration costs, not a higher thread count. |
| 5–25 | Part one: one subagent, one scoped task, reviewed as an artifact rather than a transcript. |
| 25–45 | Part two: two threads, isolated by worktree, on independent backlog work. |
| 45–55 | Integration. This will run over — let it. Integration is the lesson of this session, not the overhead standing in front of it. |
| 55–60 | Debrief. |

If integration is still running at minute 55, do not let it silently eat the
debrief — that is the one slot where this session's lesson gets said out
loud. Call time on new merge attempts, and run the debrief with whatever has
landed so far; unmerged threads are themselves debrief material. If you are
down to two minutes, drop the other two questions and ask only "did this
finish sooner than doing it sequentially, honestly measured" — it is the one
question the room cannot answer later from memory.

## If the week's build didn't happen

Part one's adversary option is the fallback, and it runs from nothing: it
needs `fixtures/demo-feed`, the provided
[`gtfs-fixture-builder`](../../.claude/skills/gtfs-fixture-builder/) skill,
and a brief — none of the participant's own validators. Steer anyone whose
codebase is behind there instead of letting them spend the hour catching up.

For someone still back on slice 2, say it plainly: "Do not try to catch up in
the next twenty minutes. Hand an adversary the fixture and the fixture-builder
skill, have it build a feed that breaks the ingest you do have, and judge what
it hands back. That is the whole technique, and it does not need slice 4." For
part two, pair them with someone whose codebase has independent pieces left in
it and have them drive one of the two threads.

## Failure modes to allow

- Two threads editing the same file and conflicting. This is the whole
  lesson about decomposition; let the conflict happen rather than warning it
  away, and use it in the debrief.
- A brief too thin for the subagent to succeed on, producing work that
  looks plausible and fails acceptance anyway. This is the trust-but-verify
  lesson from session 1, now arriving as a bad brief instead of a bad
  summary.
- Four threads started when two would have finished sooner. Let people find
  this out at integration; it lands harder than being told in advance.

## Failure modes to interrupt

Anyone who merges a thread's work without re-running its acceptance checks.
This is the verification lesson from session 1 returning at a larger scale,
and it is exactly as cheap to catch here as it was then.

## Debrief questions

- Did the parallel run finish sooner than doing the same work sequentially,
  honestly measured — including the time integration took, not just the
  time the threads spent running?
- Whose threads produced consistent code, and what did they have in place
  beforehand that the others didn't?
- What would you refuse to parallelize on a client project?

## Integration tax

Say this section out loud if nothing else: the point of today is not that
parallel is faster. It is that parallel is a tool with a cost, and the cost
is paid at integration, not while the threads are running. A room that
finishes the exercise and concludes "two threads would have beaten four
here" has learned the real lesson, even though it sounds like a smaller win
than "we ran four agents at once." Do not let the room grade itself on
thread count. Ask what integration cost each pairing, and let that number,
not how many threads were started, decide whose run actually succeeded. Make
sure everyone writes their own number down before the debrief ends — the
checkpoint asks for it, and it is the only part of today they cannot
reconstruct from memory next week.

## Answer key references

After integration, each rule a participant has actually implemented must
produce exactly the findings
[`../../fixtures/ANSWER-KEY.md`](../../fixtures/ANSWER-KEY.md#validation-findings)
attributes to that rule under "Validation findings", and no finding may
appear that none of their rules accounts for. Do not hold the room to all
five findings today. Part one adds at most one rule and part two adds two, so
five is reachable only for someone who arrived with three already done; the
full set is the end state after the continuation work, not this session's bar.

Over-flagging is the number to chase. It is usually not a new bug; it is two
threads independently implementing overlapping rules, so the same defect gets
reported twice under two different rule names. If a finding turns up that no
implemented rule explains, look there before assuming a rule itself is
wrong.

## Coaching prompts to offer live

- Before a thread starts: ask what the agent would need to know that exists
  only in someone's head right now, and have them write it into the brief
  before they hit go.
- When two threads collide: ask what boundary — a file, a directory, a rule
  name — would have kept them apart, rather than whose fault the collision
  was.
- When someone is reading a transcript line by line: ask what artifact they
  could check instead that would answer the same question faster.
