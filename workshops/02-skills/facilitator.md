# Workshop 2: Skills — facilitator guide

Companion to [`participant.md`](participant.md). Read that first; this
guide assumes you know what participants were asked to do.

## Timing

| Minutes | What happens |
|---|---|
| 0–5 | Recap. Collect from the room what bit people during the week — the specific things they had to re-explain. This is the raw material for part two. |
| 5–20 | Part one: the same fixture task without the provided skill, then with it. |
| 20–45 | Part two: authoring their own skill. |
| 45–55 | Fresh-session tests. Run several out loud, in front of the room. |
| 55–60 | Debrief and the setup for session 3. |

## If the week's build didn't happen

Part one runs from nothing. It needs `fixtures/demo-feed/README.md`, the
provided [`gtfs-fixture-builder`](../../.claude/skills/gtfs-fixture-builder/)
skill, and a working agent — none of the participant's own code. So the
only thing at risk is part two, and the fix is to point it at what part
one just produced rather than at a week that did not happen.

Say it plainly: "Your first fixture run just showed you something you had
to tell your agent that it should have known — a file it left out, a
second defect it bundled in by accident, a `stop_sequence` that repeated
instead of increasing. That is your skill. Write that one." A skill
capturing a mistake made twenty minutes ago passes the fresh-session test
exactly as well as one capturing a mistake made on Tuesday, and the
technique being taught is identical.

Keep this as the fallback rather than the default. Anyone who did build
during the week has better raw material, and offering the part-one route
to the room at large gets you eleven skills about `stop_sequence`.

## Failure modes to allow

- Writing a skill that restates the GTFS specification rather than the
  mistake that actually happened. Let it through; the fresh-session test
  is what exposes it, not you telling them in advance.
- Writing a description that describes the skill instead of when to use
  it — "Helper for GTFS fixtures" instead of naming the cases it covers.
  It will not fire, and that failure is the lesson.
- Writing one enormous skill that tries to cover everything they know
  about GTFS. Let it happen once; it's the setup for the coaching prompt
  about splitting domain knowledge from house style.

## Failure modes to interrupt

Anyone who skips the fresh-session test and declares their skill done
without running it. That test is the entire point of the second half —
without it, "I wrote a skill" and "I wrote a skill that fires" are
indistinguishable, and only one of those is worth anything.

## Debrief questions

- Whose skill fired without being asked for?
- For the ones that didn't fire, what was wrong with the description?
- What did you almost put in the body that would have been noise —
  spec restated rather than a mistake captured?

## Answer key references

Part one's fixtures can be checked directly against the integrity
checklist in the skill body — no separate answer key needed there. Slice
3 answers, which people should have hit during the week, are in
[`../../fixtures/ANSWER-KEY.md`](../../fixtures/ANSWER-KEY.md) under
"Services on a date" and "Departure boards". Expect disagreement about
`2026-07-03`: that date is Friday, and it's the inverted-exception trap
— weekday service removed by exception, weekend service added by
exception, on a weekday. It reliably splits the room and makes an
excellent five-minute detour.

## Coaching prompts to offer live

- Someone unsure what belongs in a skill: ask what they have now
  explained twice. Twice is the threshold, not once.
- A skill will not fire: have them read the description alone, with the
  body hidden, and ask whether it says when to use the skill or only
  what the skill is named.
- A skill is growing long: suggest splitting the part that is domain
  knowledge (GTFS semantics) from the part that is house style (where a
  validator's file goes, how it registers) — these are different
  lifetimes and different audiences, and slice 4's convention skill only
  needs the second kind.
- Someone has written something always true about their own repository —
  the run command, the stack, where things live — into a skill: point
  them at the always-on project file instead (`CLAUDE.md`, `AGENTS.md`,
  `.github/copilot-instructions.md`). Knowledge that is relevant every
  single time does not need a description deciding whether it is
  relevant, and giving it one is how it ends up not firing.
