# Transit Feed Service Workshops — Design

Date: 2026-08-26
Status: Approved for planning

## Purpose

Three one-hour facilitated workshops that teach experienced engineers to use
LLM coding tools effectively. The workshops progress from basic effective use,
through consuming and authoring skills, to defining agents and running several
agent threads at once.

The workshops are delivered as markdown. The markdown describes a system to
build; participants build it with their LLM tooling. No starter code ships in
any language.

## Audience and delivery

Experienced engineers at a consulting company whose engagements are commonly
cloud, most often AWS or Azure. They are used to building systems
incrementally.

- Three sessions, one hour each, facilitated live.
- A fixed cohort: the same people attend all three, and the system they build
  carries forward across sessions.
- No pre-work. Environment setup happens inside session one, using the agent.
- Participants continue building between sessions from a shared backlog.
- The facilitator coaches live and offers LLM-usage suggestions as situations
  arise. The facilitator guides capture those prompts so they are repeatable.

## The system: Transit Feed Service

A serverless system over GTFS transit feeds. GTFS is a public specification, so
the domain rules are external and real rather than invented for the exercise.
Public feeds are widely available, and the repo ships a small fixture feed.

Components, as the specification describes them:

- **Ingest function** — reads a GTFS feed from object storage, parses it, and
  writes a normalized representation to a data store.
- **Validation function** — runs a set of rules against an ingested feed and
  writes a validation report.
- **HTTP API** — serverless endpoints exposing feeds, validation reports, and
  service queries such as a departure board.
- **UI** — a browser client over that API: list feeds, view a validation
  report, view a departure board.

No authentication or authorization. It is out of scope for every session.

### Why this domain

- The GTFS specification supplies validation rules, so "our conventions" are
  externally defined rather than arbitrary.
- The rules are numerous, small, and independent, which gives session three
  genuinely non-colliding parallel work.
- The data contains traps that produce confident, plausible, wrong code from an
  unverified agent. Those traps are the pedagogical core.

### The traps

These appear in the fixture feed and drive the curriculum:

- `stop_times` values may exceed `24:00:00`. A trip departing at `25:10:00`
  runs at 1:10 AM the following day. Naive time parsing breaks.
- `calendar_dates` exception types: `1` adds service on a date, `2` removes it.
  Reversing them is easy and silent.
- Service on a given date requires combining `calendar` weekday flags, the
  service date range, and `calendar_dates` exceptions.
- Two stops close in time but far apart in space imply an impossible travel
  speed.
- A stop at latitude 0, longitude 0.
- A `feed_info` end date in the past, meaning the feed has expired.

## Technology stance

**Cloud-neutral.** The repo defines HTTP contracts and observable behavior.
Participants choose their cloud, runtime, IaC tooling, and UI framework. This
maximizes transfer to the work they actually do, and it models a real practice:
the contract is the specification, the implementation is a choice.

Consequences accepted:

- The facilitator cannot debug every stack. Acceptance criteria are written so a
  participant can self-verify without facilitator help.
- Acceptance criteria never name a test framework, a language, or a command.
  They state inputs and expected observable outputs.
- The fixture feed and its answer key are the shared source of truth for
  correctness, since there is no common test suite.

**Deployment.** Session one's first exercise is scaffolding and deploying a
health endpoint using the agent. This front-loads setup risk into the session
where the facilitator is freshest, and it turns setup into a lesson:
bootstrapping unfamiliar cloud scaffolding is a genuine, high-value use of an
agent. Later work may run locally or deployed; acceptance says "running and
reachable."

## Repository layout

```
README.md
system/
  overview.md         # end-state vision, component responsibilities
  api-contract.md     # endpoints, request/response shapes, status codes
  gtfs-reference.md   # trimmed spec excerpt for the fields in scope
  backlog.md          # ordered slices; the between-session work
  acceptance/
    01-health.md
    02-ingest.md
    03-query.md
    04-validation.md
    05-ui.md
    06-diff.md
fixtures/
  demo-feed/          # hand-built GTFS text files containing the traps
  ANSWER-KEY.md       # correct answers to every question the workshops ask
workshops/
  01-foundations/
    participant.md
    facilitator.md
  02-skills/
    participant.md
    facilitator.md
  03-agents/
    participant.md
    facilitator.md
.claude/skills/
  gtfs-fixture-builder/
    SKILL.md          # provided skill, consumed in workshop two
```

Shared assets live once at the root. Workshop folders reference them rather
than copying them, so the "one system, three increments" story is visible in the
structure and the material cannot drift between copies.

## Content specification

### system/overview.md

Describes the end-state service: the four components, their responsibilities,
the data that flows between them, and what is explicitly out of scope
(authentication, authorization, multi-tenancy, realtime feeds). Written so a
participant can always locate the current slice within the whole.

### system/api-contract.md

The neutral contract. For each endpoint: method, path, request shape, response
shape, status codes, and error behavior. Endpoints cover feed upload and
listing, triggering and retrieving validation reports, and service queries.
Written as the authority any implementation must satisfy, on any cloud.

### system/gtfs-reference.md

A trimmed, self-contained summary of the GTFS files and fields the workshops
touch: `agency`, `stops`, `routes`, `trips`, `stop_times`, `calendar`,
`calendar_dates`, `feed_info`. Included deliberately so the exercise is "supply
the agent real reference material" rather than "hope it recalls the spec
correctly."

### system/backlog.md

An ordered list of slices with a one-line goal each, pointing to the matching
acceptance file. This is what participants pull from between sessions. Ordered
so each slice is independently completable and leaves the system working.

### system/acceptance/*.md

One file per slice. Each states the goal, the preconditions, and the done
conditions as observable behavior: given this input against the fixture feed,
this output. No language, framework, or command names. Each references the
answer key for expected values.

Slices:

1. **Health** — a deployed or running endpoint returning a health response.
2. **Ingest** — parse the fixture feed into a normalized store; report what was
   ingested.
3. **Query** — service on a date, and a departure board for a stop on a date.
   This is where the past-midnight and calendar-exception traps bite.
4. **Validation** — the rule set, reports, severity levels.
5. **UI** — feed list, validation report view, departure board view.
6. **Diff** — compare two feed versions into a human-readable service-change
   report.

### fixtures/demo-feed/

A hand-built GTFS feed: small enough to read by eye, large enough to exercise
every trap listed above. Roughly a dozen small text files.

### fixtures/ANSWER-KEY.md

The correct answer to every question the workshops or acceptance criteria ask
of the fixture feed: which services run on which dates, what the departure board
shows for given stops and dates, which validation rules fire and at what
severity. This is the single most important asset in the repo, because it makes
verification possible without a shared test suite.

### .claude/skills/gtfs-fixture-builder/SKILL.md

A working skill that generates small GTFS feeds exercising a named edge case.
Chosen over a specification-lookup skill because the contrast is sharper:
hand-building a valid minimal feed is tedious and easy to get subtly wrong, so
the with-and-without comparison in workshop two is visceral rather than
academic. It also seeds workshop three, where an adversary agent uses it to
attack the room's validators.

## Workshop specification

Every participant guide follows the same spine:

1. **The technique this session teaches** — stated plainly, in two or three
   sentences.
2. **Why it matters** — tied to something that went wrong, or will go wrong,
   without it.
3. **The in-session exercise** — one exercise, sized for roughly forty minutes,
   with a checkpoint.
4. **What to notice** — an observation prompt at the checkpoint.
5. **Continue on your own** — specific backlog slices to pull next.
6. **In other tools** — a short callout mapping the session's mechanism to
   Copilot and Cursor equivalents, so the lesson survives contact with whatever
   tool someone uses at work.

Exercises state a goal and a done condition. They never supply a prompt to
paste; copying prompts teaches nothing.

Every facilitator guide contains: minute-by-minute timing for the hour, the
failure modes to watch for and deliberately allow, debrief questions, answer-key
references, and coaching prompts to offer live.

### Workshop 1 — Foundations

**Technique:** supplying context, planning before code, and verifying rather
than trusting.

**In session:** use the agent to scaffold and deploy a health endpoint on the
participant's cloud of choice. Supply it the API contract from the repo rather
than describing the goal from memory. Make it produce a plan before it produces
code, and correct the plan. Confirm the deploy by calling the endpoint, not by
reading the agent's summary.

**What to notice:** the room will split between people who called the endpoint
and people who read the summary and believed it. That split is the debrief.

**Continue after:** ingest and the first query endpoint, where the traps live.

### Workshop 2 — Skills

**Technique:** stop re-explaining yourself. Consuming a skill someone else
wrote, then encoding your own knowledge into one.

**In session:** invoke the provided fixture-builder skill on a task and compare
against doing the same task without it. Then author one skill capturing a GTFS
trap that bit during continuation work — most likely past-midnight times or
calendar exception semantics. Prove it by opening a fresh session with no
context and asking for something the skill should govern.

**What to notice:** the description is what decides whether a skill fires at
all. A perfect skill body with a vague description never runs.

**Continue after:** a project-convention skill describing how a validator is
written here — file layout, registration, output contract — and then validators
written with it.

### Workshop 3 — Agents

**Technique:** delegating scoped work, and running several agent threads at
once.

**In session:** define a subagent — a validator implementer, or an adversary
whose job is to build hostile fixture feeds that break the room's validators.
Delegate one scoped task and review the artifact rather than the transcript.
If time holds, start a short parallel run across two threads.

**What to notice:** parallelism carries an integration tax. Part of the lesson
is recognizing when several agents are slower than one.

**Continue after:** fan out the remaining validators and the UI views across
parallel threads in Zed or Omnigent, then integrate and reconcile.

## The through-line

The dependency between sessions is deliberate and is stated explicitly in each
guide so participants feel the payoff rather than being told about it:

- Workshop 1's traps surface during continuation work and become workshop 2's
  skill content.
- Workshop 2's convention skill is what makes workshop 3's parallel agents
  produce mergeable validators instead of four incompatible styles.

## Out of scope

- Authentication and authorization.
- Realtime feeds (GTFS-Realtime).
- Any starter implementation in any language.
- Cloud-specific infrastructure templates. Participants generate their own.
- A shared test suite. The fixture feed and answer key serve that role.

## Open questions

None blocking. Two items to confirm during authoring:

- The exact fixture feed contents must be validated against the real GTFS
  specification before the answer key is written, since the answer key's
  authority depends on the fixture being genuinely spec-conformant where it
  intends to be, and genuinely non-conformant only where a trap is intended.
- The Copilot and Cursor equivalence callouts should be checked against those
  tools' current mechanisms at authoring time rather than written from memory.
