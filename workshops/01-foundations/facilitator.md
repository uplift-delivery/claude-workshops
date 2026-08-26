# Workshop 1: Foundations — facilitator guide

Companion to [`participant.md`](participant.md). Read that first; this
guide assumes you know what participants were asked to do.

## Before the session

Confirm every participant has an LLM coding tool installed, signed in, and
working — Claude Code, Copilot, Cursor, whichever they use. "No pre-work"
covers the build, not the tooling: nothing in this session asks anyone to
prepare code, but all of it assumes a working agent at minute zero. Say so in
the invitation and check it as people arrive. Someone installing a tool during
the hands-on block loses the exercise, not just the setup time.

## Timing

| Minutes | What happens |
|---|---|
| 0–5 | Framing. State the arc: this system grows across all three sessions, and slice 1 done today is still load-bearing in session three. |
| 5–10 | Walk through the exercise brief. Do not hand out a prompt — point at the goal and the done condition and let people write their own. |
| 10–50 | Hands-on. Circulate; do not sit at the front. People will finish the endpoint at very different times — the ones who finish early should start slice 2 rather than wait on the room. |
| 50–60 | Debrief. |

## Failure modes to allow

- Someone accepts "successfully deployed" without ever calling the endpoint.
  Let it happen. It is the most useful thing that can occur in the room, and
  you will use it in the debrief.
- Someone lets the agent scaffold the entire service — routing, a data
  layer, deployment automation — instead of one endpoint, and then cannot
  get any of it running. This is the scope lesson. Let it play out; it is
  worth spending ten minutes on once they hit the wall.
- Someone's cloud account is not ready — no credentials, no project set up.
  Have them run the endpoint locally instead and move on. The lesson here
  does not depend on a real deploy; it depends on calling the thing and
  reading what comes back.

## Failure modes to interrupt

Anyone still fighting credentials at the thirty-minute mark. Switch them to
local immediately and let them deploy later, on their own time. Thirty
minutes lost to an account setup problem teaches nothing about this
session's technique and costs them the exercise.

## Debrief questions

- Who called their own endpoint, and who read the agent's summary and
  stopped there?
- What did the agent assume that you never told it?
- What did you correct in the plan before it wrote code, and what would
  have happened if you had not caught it?

## Answer key references

This session touches no fixture data — slice 1 has no data to get right or
wrong. Point people at
[`../../fixtures/ANSWER-KEY.md`](../../fixtures/ANSWER-KEY.md) anyway,
before they leave. They will need it during the week for slice 3, and it is
worth saying explicitly now: it is the arbiter of correctness, not their own
implementation's output. If the two disagree, their code is wrong, not the
key.

## Coaching prompts to offer live

- Someone is stuck trying to describe the problem to their agent in their
  own words: suggest they paste the contract section in instead of
  paraphrasing it.
- An agent produces something surprising — a shape you didn't expect, an
  extra dependency, a design choice nobody asked for: suggest asking it
  directly what it assumed.
- Someone is about to accept a large diff without having seen a plan first:
  suggest they stop, ask for the plan, and only then ask for the code.
- Someone is stuck in a loop of an agent guessing at the same error:
  suggest they paste the actual error text rather than describe the error
  in their own words.
