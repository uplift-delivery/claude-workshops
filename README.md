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
in-session exercise inside it is sized for roughly forty minutes of hands-on
work; the rest is discussion and debrief. Between sessions, you continue the
build on your own from [`system/backlog.md`](system/backlog.md), which holds
the ordered list of work still to do. There is no pre-work — environment
setup happens inside session one, so you can arrive with nothing prepared.

## What ships here

| Directory | Holds |
|---|---|
| `system/` | The end-state vision, the API contract, the GTFS reference, and the acceptance criteria for each slice of work. |
| `fixtures/` | A hand-built GTFS feed (and a second version of it) with a known set of defects, plus the answer key for both. |
| `workshops/` | The participant and facilitator guides for each of the three sessions. |
| `.claude/skills/` | A skill provided for workshop 2, and a template for the one you author there. |

## Bring your own stack

This repository defines contracts and observable behavior, not an
implementation. Pick your own cloud and runtime and build to satisfy what
`system/` describes; any stack that satisfies the contract is correct.
