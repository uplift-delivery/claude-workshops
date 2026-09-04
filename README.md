# Claude workshops

Three one-hour facilitated workshops teaching experienced engineers to use
LLM coding tools effectively. All three sessions are built around a single
system that grows across them, so what you learn in session one is still
load-bearing in session three.

## The arc

| Session | Focus |
|---|---|
| [Workshop 1 — Foundations](workshops/01-foundations/participant.md) | Context, planning, and verification: giving an LLM coding tool the right material to work from and checking what it hands back. |
| [Workshop 2 — Skills](workshops/02-skills/participant.md) | Consuming a provided skill, then authoring your own convention as one. |
| [Workshop 3 — Agents](workshops/03-agents/participant.md) | Delegation and parallel threads of work. |

## The system

Across the three sessions you incrementally build the Transit Feed Service,
a system that ingests, validates, and answers questions about public transit
schedule data — see [`system/overview.md`](system/overview.md) for the full
vision.

## How the sessions work

The same cohort attends all three sessions. Each session is one hour, and the
in-session exercise inside it is sized for forty to fifty minutes of hands-on
work; the rest is discussion and debrief. There is no pre-work on the build —
you can arrive at session one having written nothing. You do need an LLM
coding tool installed and signed in before session one starts, because
everything in that hour assumes a working agent at minute zero.

Between sessions, you continue the build on your own from
[`system/backlog.md`](system/backlog.md), which holds the ordered list of work
still to do. Budget roughly three to six hours between sessions one and two,
and two to four between sessions two and three. If you have less time than
that, do slice 2 and stop rather than half-finishing three slices, and tell
your facilitator — both later sessions have a path that runs without it. And
know what the acceptance criteria actually require: every condition from
slice 2 onward is HTTP behaviour that a single local process satisfies.
Deploying to a cloud is optional throughout, and skipping it costs you
nothing this program measures.

## What ships here

| Directory | Holds |
|---|---|
| `system/` | The end-state vision, the API contract, the GTFS reference, and the acceptance criteria for each slice of work. |
| `fixtures/` | A hand-built GTFS feed (and a second version of it) with a known set of defects, plus the answer key for both. |
| `workshops/` | The participant and facilitator guides for each of the three sessions. |
| `.claude/skills/` | The GTFS fixture-builder skill workshop 2 consumes, and uses as the worked example for the skill you author there. |
| `.claude/agents/` | The adversary subagent workshop 3 uses as the worked example for the subagent you define there. |

## Bring your own stack

This repository defines contracts and observable behavior, not an
implementation. Pick your own cloud and runtime and build to satisfy what
`system/` describes; any stack that satisfies the contract is correct.
