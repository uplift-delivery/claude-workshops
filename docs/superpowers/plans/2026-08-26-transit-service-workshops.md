# Transit Feed Service Workshops Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Author the markdown, fixture data, and provided skill for three
one-hour facilitated workshops in which experienced engineers incrementally
build a cloud-neutral serverless GTFS feed service using LLM tooling.

**Architecture:** Shared assets live once at the repository root
(`system/`, `fixtures/`, `.claude/skills/`); each workshop folder holds a
participant guide and a facilitator guide that reference them. The repository
contains no implementation code in any language — participants generate all of
it. Correctness is verifiable because a hand-built fixture feed ships with an
answer key stating the correct result for every question the material asks.

**Tech Stack:** Markdown and GTFS text (CSV) files only. Verification scripts
are written to the scratchpad and never committed.

**Spec:** `docs/superpowers/specs/2026-08-26-transit-service-workshops-design.md`

## Adaptation note for executors

The deliverables are prose and data, not code, so there is no test framework.
The test-first rhythm is preserved as follows:

- "Write the failing test" means: write the verification checks for the file
  into the scratchpad first, and run them to confirm they fail (the file does
  not exist yet, or lacks the required content).
- "Implement" means: author the file.
- "Run the tests" means: re-run those checks and confirm they pass.

Verification checks are `grep`/`test` invocations and, for the fixture feed, a
Python cross-check script. Every task ends with a commit.

Throughout this plan, `$SCRATCH` refers to:
`/private/tmp/claude-501/-Users-bryceklinker-code-uplift-delivery-claude-workshops/7ef300f8-0078-42f7-a27c-704a807872e3/scratchpad`

## Global Constraints

These apply to every task. Every task's requirements implicitly include this
section.

- **No implementation code in any language is committed to the repository.**
  Participants generate all of it. Verification scripts live in the scratchpad
  only.
- **Cloud-neutral.** No acceptance criterion, backlog item, or exercise names a
  language, framework, IaC tool, cloud provider, test framework, or shell
  command. They state inputs and expected observable outputs only.
- **No authentication or authorization** appears anywhere in the system spec,
  contracts, acceptance criteria, or exercises. It is out of scope.
- **No prompts to paste.** Exercises state a goal and a done condition.
  Copying prompts teaches nothing.
- **Sessions are one hour.** In-session exercises are sized for roughly forty
  minutes of hands-on time.
- **Fixed cohort, continuous build, no pre-work.** Workshop 2 and 3 assume the
  participant's own system from prior sessions. Environment setup happens
  inside workshop 1.
- **Participant guides follow this six-part spine, in this order:** the
  technique this session teaches; why it matters; the in-session exercise; what
  to notice; continue on your own; in other tools.
- **Facilitator guides contain, in this order:** minute-by-minute timing for the
  hour; failure modes to watch for and deliberately allow; debrief questions;
  answer-key references; coaching prompts to offer live.
- **All dates in fixture data and examples are real calendar dates in 2026** and
  their weekday must be correct.
- **Relative links only.** Every markdown link between repository files is
  relative and must resolve.

## Spec addendum

The spec's layout lists a single `fixtures/demo-feed/`. Acceptance slice 06
(feed diff) requires two feed versions to compare, so this plan adds
`fixtures/demo-feed-v2/`. This is an addition to the spec, made explicit here.

## File Structure

| Path | Responsibility |
|---|---|
| `README.md` | Repository orientation: what this is, how the three sessions work, where to start. |
| `system/overview.md` | End-state vision of the Transit Feed Service; component responsibilities; out of scope. |
| `system/gtfs-reference.md` | Trimmed GTFS excerpt covering only the files and fields in scope. |
| `system/api-contract.md` | Neutral HTTP contract: endpoints, shapes, status codes, error behavior. |
| `system/backlog.md` | Ordered slices for between-session work, each pointing at an acceptance file. |
| `system/acceptance/01-health.md` | Done conditions for the health endpoint slice. |
| `system/acceptance/02-ingest.md` | Done conditions for feed ingest. |
| `system/acceptance/03-query.md` | Done conditions for service-on-date and departure board. |
| `system/acceptance/04-validation.md` | Done conditions for the validation rule set and reports. |
| `system/acceptance/05-ui.md` | Done conditions for the three UI views. |
| `system/acceptance/06-diff.md` | Done conditions for the feed-version diff report. |
| `fixtures/demo-feed/*.txt` | The hand-built GTFS feed containing every trap. |
| `fixtures/demo-feed-v2/*.txt` | A changed version of the same feed, for diffing. |
| `fixtures/ANSWER-KEY.md` | Correct answers to every question the material asks of the fixtures. |
| `.claude/skills/gtfs-fixture-builder/SKILL.md` | Provided skill consumed in workshop 2. |
| `workshops/01-foundations/participant.md` | Session 1 participant guide. |
| `workshops/01-foundations/facilitator.md` | Session 1 facilitator guide. |
| `workshops/02-skills/participant.md` | Session 2 participant guide. |
| `workshops/02-skills/facilitator.md` | Session 2 facilitator guide. |
| `workshops/03-agents/participant.md` | Session 3 participant guide. |
| `workshops/03-agents/facilitator.md` | Session 3 facilitator guide. |

## Canonical fixture data

Tasks 3, 4, and 5 depend on exact values. They are fixed here so that every
task uses the same ones.

**Agency timezone:** `America/Los_Angeles`.

**Service calendar range:** `20260601` to `20261231`.

**Weekday verification (all 2026):** `2026-07-03` is a Friday. `2026-08-08` is
a Saturday. `2026-09-14` is a Monday. `2026-09-19` is a Saturday.

**Intentional traps, and where each lives:**

| Trap | Location in `demo-feed` |
|---|---|
| Times past `24:00:00` | Trip `T4` stop times `24:35:00`, `24:52:00`, `25:05:00` |
| `calendar_dates` removal (`exception_type` 2) | `WEEKDAY` on `20260703` |
| `calendar_dates` addition (`exception_type` 1) | `WEEKEND` on `20260703`, `WEEKDAY` on `20260808` |
| Implausible travel speed | Trip `T3`, stop `S2` to `S4`, ~18.2 km in 2 minutes |
| Stop at latitude 0, longitude 0 | Stop `S5` |
| Stop served by no trip | Stop `S5` |
| Poor route color contrast | Route `R1`, `FFFFFF` background with `FFFF00` text |
| Expired / inconsistent feed window | `feed_info.feed_end_date` is `20260731`, earlier than the calendar's `20261231` |

---

### Task 1: Repository orientation and system vision

**Files:**
- Create: `README.md` (replaces the existing two-line file)
- Create: `system/overview.md`

**Interfaces:**
- Consumes: nothing.
- Produces: the canonical component names used by every later file —
  **ingest function**, **validation function**, **HTTP API**, **UI**. Later
  tasks must use these exact names.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-task1.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }

check "test -f README.md" "README.md exists"
check "test -f system/overview.md" "system/overview.md exists"
check "grep -q 'ingest function' system/overview.md" "overview names the ingest function"
check "grep -q 'validation function' system/overview.md" "overview names the validation function"
check "grep -q 'HTTP API' system/overview.md" "overview names the HTTP API"
check "grep -qi 'out of scope' system/overview.md" "overview has an out-of-scope section"
check "grep -qi 'authentication' system/overview.md" "overview states auth is out of scope"
check "grep -q 'workshops/01-foundations' README.md" "README links to workshop 1"
check "grep -q 'system/overview.md' README.md" "README links to the overview"
check "! grep -qiE '\\b(aws|azure|lambda|terraform|bicep|typescript|python)\\b' system/overview.md" "overview names no cloud or language"

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-task1.sh`
Expected: FAIL lines for `system/overview.md` and the README link checks.

- [ ] **Step 3: Write `system/overview.md`**

Required sections and content:

- **What we are building** — the Transit Feed Service: a serverless system that
  ingests GTFS transit feeds, validates them against specification rules,
  answers questions about service, and exposes a browser UI over it.
- **Why GTFS** — GTFS is a public specification, so the rules the system
  enforces are external and real rather than invented for the exercise. Public
  feeds are widely available and a fixture feed ships in this repository.
- **Components** — four subsections, one per component, each stating its single
  responsibility and the data crossing its boundary:
  - *Ingest function*: reads a GTFS feed from object storage, parses it, writes
    a normalized representation to a data store, and records what it ingested.
  - *Validation function*: runs the rule set against an ingested feed and writes
    a validation report with a severity per finding.
  - *HTTP API*: exposes feeds, validation reports, and service queries. Points
    at `api-contract.md` as the authority.
  - *UI*: lists feeds, renders a validation report, and shows a departure board.
- **How you build it** — the technology choice is yours. This repository defines
  contracts and observable behavior; the implementation is a choice. State that
  the contract is the specification, which is also the practice being modelled.
- **Out of scope** — authentication and authorization; realtime feeds
  (GTFS-Realtime); multi-tenancy; any starter implementation.
- **Where to start** — relative link to `backlog.md` and to
  `../workshops/01-foundations/participant.md`.

- [ ] **Step 4: Write `README.md`**

Required content:

- Title and a one-paragraph statement: three one-hour facilitated workshops
  teaching experienced engineers to use LLM coding tools effectively, built
  around one system that grows across the sessions.
- **The arc** — a three-row list: workshop 1 foundations (context, planning,
  verification); workshop 2 skills (consuming, then authoring); workshop 3
  agents (delegation and parallel threads). Each row links to that workshop's
  `participant.md`.
- **The system** — one sentence plus a link to `system/overview.md`.
- **How the sessions work** — same cohort throughout; sessions are one hour;
  the in-session exercise is roughly forty minutes; participants continue
  between sessions from `system/backlog.md`; no pre-work, setup happens inside
  session one.
- **What ships here** — a short table of the top-level directories and what
  each holds.
- **Bring your own stack** — the repository defines contracts and behavior, not
  implementation. Pick your cloud and runtime.

- [ ] **Step 5: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-task1.sh`
Expected: every line PASS, exit code 0.

- [ ] **Step 6: Commit**

```bash
git add README.md system/overview.md
git commit -m "docs: add repository orientation and system vision"
```

---

### Task 2: GTFS reference excerpt

**Files:**
- Create: `system/gtfs-reference.md`

**Interfaces:**
- Consumes: component names from Task 1.
- Produces: the authoritative in-repo description of GTFS files and fields.
  Tasks 3, 4, 5, 7, and 8 reference it by relative link.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-task2.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
F=system/gtfs-reference.md

check "test -f $F" "file exists"
for t in agency.txt stops.txt routes.txt trips.txt stop_times.txt calendar.txt calendar_dates.txt feed_info.txt; do
  check "grep -q '$t' $F" "documents $t"
done
check "grep -q '24:00:00' $F" "explains times past 24:00:00"
check "grep -q 'exception_type' $F" "documents exception_type"
check "grep -q 'stop_sequence' $F" "documents stop_sequence"
check "grep -q 'route_type' $F" "documents route_type"
check "grep -qi 'service date' $F" "defines the service date concept"

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-task2.sh`
Expected: every check FAILs; the file does not exist.

- [ ] **Step 3: Write `system/gtfs-reference.md`**

Scope note at the top: this is a trimmed excerpt covering only the files and
fields these workshops touch, not the full specification. Link to the official
specification for anything else.

One section per file, each listing field name, whether it is required, its type,
and a one-line meaning. Cover exactly these:

- `agency.txt` — `agency_id`, `agency_name`, `agency_url`, `agency_timezone`.
  Note that `agency_timezone` governs interpretation of all times in the feed.
- `stops.txt` — `stop_id`, `stop_name`, `stop_lat`, `stop_lon`.
- `routes.txt` — `route_id`, `agency_id`, `route_short_name`,
  `route_long_name`, `route_type`, `route_color`, `route_text_color`. Include
  the `route_type` enum values used here: 0 tram, 1 subway, 2 rail, 3 bus,
  4 ferry. Note that colors are six-digit hex without a leading `#`, and that
  `route_color` and `route_text_color` need sufficient contrast to be legible.
- `trips.txt` — `route_id`, `service_id`, `trip_id`, `trip_headsign`,
  `direction_id`.
- `stop_times.txt` — `trip_id`, `arrival_time`, `departure_time`, `stop_id`,
  `stop_sequence`. This section carries the most important explanation in the
  file, and must state plainly:
  - Times are `HH:MM:SS` relative to **noon minus twelve hours** on the trip's
    service date, not wall-clock time on a calendar date.
  - Consequently `HH` **may exceed 23**. A departure of `25:05:00` on service
    date 2026-09-14 occurs at 01:05 on 2026-09-15.
  - `stop_sequence` increases along the trip but need not be consecutive.
  - `arrival_time` is never later than `departure_time` at the same stop.
- `calendar.txt` — `service_id`, the seven weekday flags, `start_date`,
  `end_date`. Dates are `YYYYMMDD`. Flags are 1 for running, 0 for not.
- `calendar_dates.txt` — `service_id`, `date`, `exception_type`. State
  explicitly and prominently: **`1` adds service on that date, `2` removes it.**
  Exceptions override the weekday flags in `calendar.txt`.
- `feed_info.txt` — `feed_publisher_name`, `feed_publisher_url`, `feed_lang`,
  `feed_start_date`, `feed_end_date`, `feed_version`.

Close with a **Resolving service on a date** section giving the algorithm in
prose: a service runs on a date when the date falls inside the service's
start/end range and that weekday's flag is 1, unless a `calendar_dates` row for
that service and date says otherwise — `exception_type` 1 forces it on,
`exception_type` 2 forces it off, regardless of the weekday flag or the range.

- [ ] **Step 4: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-task2.sh`
Expected: every line PASS, exit code 0.

- [ ] **Step 5: Commit**

```bash
git add system/gtfs-reference.md
git commit -m "docs: add trimmed GTFS reference excerpt"
```

---

### Task 3: Primary fixture feed

**Files:**
- Create: `fixtures/demo-feed/agency.txt`
- Create: `fixtures/demo-feed/stops.txt`
- Create: `fixtures/demo-feed/routes.txt`
- Create: `fixtures/demo-feed/trips.txt`
- Create: `fixtures/demo-feed/stop_times.txt`
- Create: `fixtures/demo-feed/calendar.txt`
- Create: `fixtures/demo-feed/calendar_dates.txt`
- Create: `fixtures/demo-feed/feed_info.txt`
- Create: `fixtures/demo-feed/README.md`

**Interfaces:**
- Consumes: field definitions from `system/gtfs-reference.md`.
- Produces: stop IDs `S1`–`S6`, route IDs `R1`–`R3`, trip IDs `T1`–`T4`, and
  service IDs `WEEKDAY`, `WEEKEND`, `NIGHT`. Tasks 4, 5, 7, 8, 11, 12, and 13
  reference these identifiers.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-feed.py`. This checks referential integrity, monotonic
stop sequences, and that every intended trap is present:

```python
#!/usr/bin/env python3
import csv, math, os, sys

FEED = sys.argv[1] if len(sys.argv) > 1 else "fixtures/demo-feed"
fails = []

def check(ok, msg):
    print(("PASS: " if ok else "FAIL: ") + msg)
    if not ok:
        fails.append(msg)

def read(name):
    path = os.path.join(FEED, name)
    if not os.path.exists(path):
        return None
    with open(path, newline="", encoding="utf-8") as fh:
        return list(csv.DictReader(fh))

required = ["agency.txt", "stops.txt", "routes.txt", "trips.txt",
            "stop_times.txt", "calendar.txt", "calendar_dates.txt",
            "feed_info.txt"]
tables = {}
for name in required:
    rows = read(name)
    check(rows is not None, f"{name} present")
    tables[name] = rows or []

stops = {r["stop_id"]: r for r in tables["stops.txt"]}
routes = {r["route_id"]: r for r in tables["routes.txt"]}
trips = {r["trip_id"]: r for r in tables["trips.txt"]}
services = {r["service_id"] for r in tables["calendar.txt"]}

# referential integrity
for t in tables["trips.txt"]:
    check(t["route_id"] in routes, f"trip {t['trip_id']} route resolves")
    check(t["service_id"] in services, f"trip {t['trip_id']} service resolves")
for st in tables["stop_times.txt"]:
    check(st["trip_id"] in trips, f"stop_time trip {st['trip_id']} resolves")
    check(st["stop_id"] in stops, f"stop_time stop {st['stop_id']} resolves")
for cd in tables["calendar_dates.txt"]:
    check(cd["service_id"] in services, f"exception service {cd['service_id']} resolves")

# monotonic sequences, arrival <= departure
def secs(hms):
    h, m, s = (int(x) for x in hms.split(":"))
    return h * 3600 + m * 60 + s

by_trip = {}
for st in tables["stop_times.txt"]:
    by_trip.setdefault(st["trip_id"], []).append(st)
for tid, sts in by_trip.items():
    sts.sort(key=lambda r: int(r["stop_sequence"]))
    seqs = [int(r["stop_sequence"]) for r in sts]
    check(seqs == sorted(set(seqs)), f"{tid} stop_sequence strictly increasing")
    times = [secs(r["departure_time"]) for r in sts]
    check(times == sorted(times), f"{tid} departure times non-decreasing")
    for r in sts:
        check(secs(r["arrival_time"]) <= secs(r["departure_time"]),
              f"{tid} seq {r['stop_sequence']} arrival <= departure")

# intended traps
check(any(secs(r["departure_time"]) >= 24 * 3600 for r in tables["stop_times.txt"]),
      "TRAP: at least one departure past 24:00:00")
check(any(r["exception_type"] == "1" for r in tables["calendar_dates.txt"]),
      "TRAP: an added-service exception exists")
check(any(r["exception_type"] == "2" for r in tables["calendar_dates.txt"]),
      "TRAP: a removed-service exception exists")
check(any(float(r["stop_lat"]) == 0.0 and float(r["stop_lon"]) == 0.0
          for r in tables["stops.txt"]), "TRAP: a stop sits at (0, 0)")
used = {st["stop_id"] for st in tables["stop_times.txt"]}
check(bool(set(stops) - used), "TRAP: at least one stop is served by no trip")

def km(a, b):
    lat1, lon1 = float(a["stop_lat"]), float(a["stop_lon"])
    lat2, lon2 = float(b["stop_lat"]), float(b["stop_lon"])
    dlat = (lat2 - lat1) * 111.32
    dlon = (lon2 - lon1) * 111.32 * math.cos(math.radians((lat1 + lat2) / 2))
    return math.hypot(dlat, dlon)

fastest = 0.0
for tid, sts in by_trip.items():
    for a, b in zip(sts, sts[1:]):
        dt = secs(b["arrival_time"]) - secs(a["departure_time"])
        if dt <= 0:
            continue
        speed = km(stops[a["stop_id"]], stops[b["stop_id"]]) / (dt / 3600)
        fastest = max(fastest, speed)
        if speed > 200:
            print(f"  note: {tid} {a['stop_id']}->{b['stop_id']} = {speed:.0f} km/h")
check(fastest > 200, f"TRAP: an implausible hop exists (fastest {fastest:.0f} km/h)")

r1 = routes.get("R1", {})
check(r1.get("route_color") == "FFFFFF" and r1.get("route_text_color") == "FFFF00",
      "TRAP: R1 has low-contrast colors")
fi = tables["feed_info.txt"][0]
check(fi["feed_end_date"] < max(r["end_date"] for r in tables["calendar.txt"]),
      "TRAP: feed_info window ends before service coverage does")

print()
print("FAILURES:", len(fails))
sys.exit(1 if fails else 0)
```

- [ ] **Step 2: Run the checker to verify it fails**

Run: `python3 $SCRATCH/check-feed.py fixtures/demo-feed`
Expected: FAIL on every `present` check; the directory does not exist.

- [ ] **Step 3: Write the feed files**

`fixtures/demo-feed/agency.txt`:

```
agency_id,agency_name,agency_url,agency_timezone
BTA,Bayside Transit Authority,https://example.com/bta,America/Los_Angeles
```

`fixtures/demo-feed/stops.txt`:

```
stop_id,stop_name,stop_lat,stop_lon
S1,Harbor Terminal,47.5980,-122.3350
S2,Market & 3rd,47.6120,-122.3400
S3,Riverside Park,47.6450,-122.3550
S4,Airport Station,47.4500,-122.3090
S5,Null Island Stop,0.0,0.0
S6,Eastgate Transit Center,47.5800,-122.1400
```

`fixtures/demo-feed/routes.txt`:

```
route_id,agency_id,route_short_name,route_long_name,route_type,route_color,route_text_color
R1,BTA,1,Harbor - Riverside,3,FFFFFF,FFFF00
R2,BTA,2,Airport Express,3,0B5394,FFFFFF
R3,BTA,3,Night Owl,3,000000,FFFFFF
```

`fixtures/demo-feed/trips.txt`:

```
route_id,service_id,trip_id,trip_headsign,direction_id
R1,WEEKDAY,T1,Riverside Park,0
R1,WEEKEND,T2,Riverside Park,0
R2,WEEKDAY,T3,Airport Station,0
R3,NIGHT,T4,Harbor Terminal,1
```

`fixtures/demo-feed/stop_times.txt`:

```
trip_id,arrival_time,departure_time,stop_id,stop_sequence
T1,06:00:00,06:00:00,S1,1
T1,06:08:00,06:09:00,S2,2
T1,06:20:00,06:20:00,S3,3
T2,09:00:00,09:00:00,S1,1
T2,09:12:00,09:13:00,S2,2
T2,09:28:00,09:28:00,S3,3
T3,07:00:00,07:00:00,S2,1
T3,07:02:00,07:02:00,S4,2
T4,23:50:00,23:50:00,S6,1
T4,24:35:00,24:35:00,S3,2
T4,24:52:00,24:52:00,S2,3
T4,25:05:00,25:05:00,S1,4
```

`fixtures/demo-feed/calendar.txt`:

```
service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
WEEKDAY,1,1,1,1,1,0,0,20260601,20261231
WEEKEND,0,0,0,0,0,1,1,20260601,20261231
NIGHT,1,1,1,1,1,1,1,20260601,20261231
```

`fixtures/demo-feed/calendar_dates.txt`:

```
service_id,date,exception_type
WEEKDAY,20260703,2
WEEKEND,20260703,1
WEEKDAY,20260808,1
```

`fixtures/demo-feed/feed_info.txt`:

```
feed_publisher_name,feed_publisher_url,feed_lang,feed_start_date,feed_end_date,feed_version
Bayside Transit Authority,https://example.com/bta,en,20260601,20260731,2026-06-01-A
```

`fixtures/demo-feed/README.md`: one paragraph stating this is a hand-built feed
small enough to read by eye and deliberately seeded with defects; a link to
`../ANSWER-KEY.md`; and an explicit warning that the defects are intentional and
must not be "fixed."

- [ ] **Step 4: Run the checker to verify it passes**

Run: `python3 $SCRATCH/check-feed.py fixtures/demo-feed`
Expected: all PASS, `FAILURES: 0`, exit code 0. The implausible-hop note should
report trip `T3` from `S2` to `S4` at 546 km/h.

- [ ] **Step 5: Commit**

```bash
git add fixtures/demo-feed
git commit -m "test: add primary GTFS fixture feed with seeded defects"
```

---

### Task 4: Second fixture feed version for diffing

**Files:**
- Create: `fixtures/demo-feed-v2/agency.txt`
- Create: `fixtures/demo-feed-v2/stops.txt`
- Create: `fixtures/demo-feed-v2/routes.txt`
- Create: `fixtures/demo-feed-v2/trips.txt`
- Create: `fixtures/demo-feed-v2/stop_times.txt`
- Create: `fixtures/demo-feed-v2/calendar.txt`
- Create: `fixtures/demo-feed-v2/calendar_dates.txt`
- Create: `fixtures/demo-feed-v2/feed_info.txt`
- Create: `fixtures/demo-feed-v2/README.md`

**Interfaces:**
- Consumes: identifiers from Task 3.
- Produces: the changed-feed counterpart. Task 5's answer key and Task 8's
  `06-diff.md` enumerate exactly these changes:
  route `R2` removed; trip `T2` removed; stop `S3` relocated; trip `T1` shifted
  five minutes later; the `20260808` exception removed; `feed_version` bumped.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-feed-v2.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
D=fixtures/demo-feed-v2

check "! grep -q '^R2,' $D/routes.txt" "route R2 removed"
check "! grep -q ',T2,' $D/trips.txt" "trip T2 removed"
check "! grep -q '^T2,' $D/stop_times.txt" "trip T2 stop_times removed"
check "! grep -q '^T3,' $D/stop_times.txt" "trip T3 stop_times removed with its route"
check "grep -q '^S3,Riverside Park,47.6480,-122.3600' $D/stops.txt" "stop S3 relocated"
check "grep -q '^T1,06:05:00,06:05:00,S1,1' $D/stop_times.txt" "trip T1 shifted five minutes later"
check "! grep -q '20260808' $D/calendar_dates.txt" "the 20260808 exception is gone"
check "grep -q '2026-09-01-B' $D/feed_info.txt" "feed_version bumped"
check "diff -q fixtures/demo-feed/agency.txt $D/agency.txt" "agency.txt unchanged"

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-feed-v2.sh`
Expected: every check FAILs; the directory does not exist.

- [ ] **Step 3: Write the v2 feed files**

Copy `agency.txt` from `fixtures/demo-feed/` unchanged.

`fixtures/demo-feed-v2/stops.txt` — identical to v1 except `S3`:

```
stop_id,stop_name,stop_lat,stop_lon
S1,Harbor Terminal,47.5980,-122.3350
S2,Market & 3rd,47.6120,-122.3400
S3,Riverside Park,47.6480,-122.3600
S4,Airport Station,47.4500,-122.3090
S5,Null Island Stop,0.0,0.0
S6,Eastgate Transit Center,47.5800,-122.1400
```

`fixtures/demo-feed-v2/routes.txt`:

```
route_id,agency_id,route_short_name,route_long_name,route_type,route_color,route_text_color
R1,BTA,1,Harbor - Riverside,3,FFFFFF,FFFF00
R3,BTA,3,Night Owl,3,000000,FFFFFF
```

`fixtures/demo-feed-v2/trips.txt`:

```
route_id,service_id,trip_id,trip_headsign,direction_id
R1,WEEKDAY,T1,Riverside Park,0
R3,NIGHT,T4,Harbor Terminal,1
```

`fixtures/demo-feed-v2/stop_times.txt`:

```
trip_id,arrival_time,departure_time,stop_id,stop_sequence
T1,06:05:00,06:05:00,S1,1
T1,06:13:00,06:14:00,S2,2
T1,06:25:00,06:25:00,S3,3
T4,23:50:00,23:50:00,S6,1
T4,24:35:00,24:35:00,S3,2
T4,24:52:00,24:52:00,S2,3
T4,25:05:00,25:05:00,S1,4
```

`fixtures/demo-feed-v2/calendar.txt` — identical to v1.

`fixtures/demo-feed-v2/calendar_dates.txt`:

```
service_id,date,exception_type
WEEKDAY,20260703,2
WEEKEND,20260703,1
```

`fixtures/demo-feed-v2/feed_info.txt`:

```
feed_publisher_name,feed_publisher_url,feed_lang,feed_start_date,feed_end_date,feed_version
Bayside Transit Authority,https://example.com/bta,en,20260901,20261231,2026-09-01-B
```

`fixtures/demo-feed-v2/README.md`: one paragraph stating this is the same
agency's feed one schedule pick later, that it is the comparison target for the
diff slice, and a link to `../ANSWER-KEY.md`.

- [ ] **Step 4: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-feed-v2.sh`
Expected: every line PASS, exit code 0.

Also run: `python3 $SCRATCH/check-feed.py fixtures/demo-feed-v2`
Expected: `FAILURES: 2`, and both failures are these exact lines:

```
FAIL: TRAP: an implausible hop exists (fastest 24 km/h)
FAIL: TRAP: feed_info window ends before service coverage does
```

Both are correct for v2: route `R2` and its implausible hop were removed, and
v2's feed window now covers its calendars. Every `present`, referential-
integrity, and sequencing check must PASS. Any other failure means the v2 feed
is broken — fix it before committing.

- [ ] **Step 5: Commit**

```bash
git add fixtures/demo-feed-v2
git commit -m "test: add second fixture feed version for diffing"
```

---

### Task 5: Answer key

**Files:**
- Create: `fixtures/ANSWER-KEY.md`

**Interfaces:**
- Consumes: both fixture feeds and `system/gtfs-reference.md`.
- Produces: the named answer sections that acceptance files and workshop guides
  link to by anchor: `#services-on-a-date`, `#departure-boards`,
  `#validation-findings`, `#feed-diff`.

- [ ] **Step 1: Write the answer-computing script**

Create `$SCRATCH/compute-answers.py`. This computes the answers independently so
the hand-written key can be reconciled against it:

```python
#!/usr/bin/env python3
import csv, datetime, os

FEED = "fixtures/demo-feed"

def read(name):
    with open(os.path.join(FEED, name), newline="", encoding="utf-8") as fh:
        return list(csv.DictReader(fh))

cal = read("calendar.txt")
cdates = read("calendar_dates.txt")
trips = read("trips.txt")
stimes = read("stop_times.txt")

DAYS = ["monday", "tuesday", "wednesday", "thursday", "friday",
        "saturday", "sunday"]

def services_on(datestr):
    d = datetime.date(int(datestr[:4]), int(datestr[4:6]), int(datestr[6:]))
    active = set()
    for row in cal:
        if row["start_date"] <= datestr <= row["end_date"]:
            if row[DAYS[d.weekday()]] == "1":
                active.add(row["service_id"])
    for row in cdates:
        if row["date"] == datestr:
            if row["exception_type"] == "1":
                active.add(row["service_id"])
            elif row["exception_type"] == "2":
                active.discard(row["service_id"])
    return d.strftime("%A"), sorted(active)

def board(stop_id, datestr):
    _, active = services_on(datestr)
    trip_service = {t["trip_id"]: t["service_id"] for t in trips}
    out = []
    for st in stimes:
        if st["stop_id"] != stop_id:
            continue
        if trip_service[st["trip_id"]] not in active:
            continue
        h, m, s = (int(x) for x in st["departure_time"].split(":"))
        base = datetime.datetime(int(datestr[:4]), int(datestr[4:6]),
                                 int(datestr[6:]))
        wall = base + datetime.timedelta(hours=h, minutes=m, seconds=s)
        out.append((st["departure_time"], st["trip_id"],
                    wall.strftime("%Y-%m-%d %H:%M")))
    return sorted(out)

for d in ["20260703", "20260808", "20260914", "20260919"]:
    day, active = services_on(d)
    print(f"{d} ({day}): {', '.join(active)}")

print()
for d in ["20260703", "20260808", "20260914", "20260919"]:
    print(f"S2 departures on {d}:")
    for feed_time, trip, wall in board("S2", d):
        print(f"  {feed_time}  {trip}  -> {wall}")
```

- [ ] **Step 2: Run it and capture the output**

Run: `python3 $SCRATCH/compute-answers.py`

Expected output — reconcile the written key against this exactly:

```
20260703 (Friday): NIGHT, WEEKEND
20260808 (Saturday): NIGHT, WEEKDAY, WEEKEND
20260914 (Monday): NIGHT, WEEKDAY
20260919 (Saturday): NIGHT, WEEKEND

S2 departures on 20260703:
  09:13:00  T2  -> 2026-07-03 09:13
  24:52:00  T4  -> 2026-07-04 00:52
S2 departures on 20260808:
  06:09:00  T1  -> 2026-08-08 06:09
  07:00:00  T3  -> 2026-08-08 07:00
  09:13:00  T2  -> 2026-08-08 09:13
  24:52:00  T4  -> 2026-08-09 00:52
S2 departures on 20260914:
  06:09:00  T1  -> 2026-09-14 06:09
  07:00:00  T3  -> 2026-09-14 07:00
  24:52:00  T4  -> 2026-09-15 00:52
S2 departures on 20260919:
  09:13:00  T2  -> 2026-09-19 09:13
  24:52:00  T4  -> 2026-09-20 00:52
```

If the script's actual output differs from the block above, the fixture from
Task 3 is wrong. Stop, reread `system/gtfs-reference.md`, fix the fixture, and
re-run both this and `$SCRATCH/check-feed.py` before continuing.

- [ ] **Step 3: Write `fixtures/ANSWER-KEY.md`**

Open with a **How to use this** section: this file is the shared source of truth
for correctness. Implementations differ, answers do not. If your system
disagrees with this file, your system is wrong. Note that where a value is
approximate (distances, speeds) the key gives a tolerance.

Then these sections, with exactly these headings so anchors resolve:

**## Services on a date** — a table with columns date, weekday, active service
IDs, and why. Rows for `2026-07-03` (Friday; `NIGHT`, `WEEKEND`; weekday service
removed by exception and weekend service added), `2026-08-08` (Saturday;
`NIGHT`, `WEEKDAY`, `WEEKEND`; weekday service added by exception on top of
normal weekend service), `2026-09-14` (Monday; `NIGHT`, `WEEKDAY`; no
exceptions), `2026-09-19` (Saturday; `NIGHT`, `WEEKEND`; no exceptions).

**## Departure boards** — four tables, one per date above, for stop `S2`, with
columns feed time, trip, and wall-clock instant, transcribed from the verified
script output. Write wall-clock instants in the ISO form the API contract
specifies — `2026-09-15T00:52`, not `2026-09-15 00:52` — so the key and the
contract agree; the verification script prints a space, which you convert. Add a note under the tables: every one of these dates has a
`24:52:00` departure that falls on the *following* calendar day. A departure
board that omits it, or that renders it as `00:52` on the queried date, is
wrong.

**## Validation findings** — a table of every finding the fixture must produce,
with columns rule, severity, location, and detail:

| Rule | Severity | Location | Detail |
|---|---|---|---|
| `implausible-travel-speed` | error | trip `T3`, `S2` to `S4` | 18.2 km in 120 s, 546 km/h (accept 500–600 km/h) |
| `null-island-stop` | error | stop `S5` | latitude 0, longitude 0 |
| `unused-stop` | warning | stop `S5` | appears in no `stop_times` row |
| `route-color-contrast` | warning | route `R1` | `FFFFFF` background, `FFFF00` text |
| `feed-window-coverage` | warning | `feed_info.txt` | `feed_end_date` 20260731 precedes the calendars' 20261231 |

Use these exact rule names; `system/acceptance/04-validation.md` specifies the
same set, and the two files must agree.

State that these five are the complete expected set for `demo-feed`, so a
report with extra findings is over-flagging and one with fewer is under-flagging.

**## Feed diff** — the complete list of changes from `demo-feed` to
`demo-feed-v2`: route `R2` (Airport Express) removed along with its trip `T3`;
route `R1` loses its weekend trip `T2`, so route 1 has no Saturday or Sunday
service in v2; stop `S3` relocated roughly 500 m northwest; trip `T1` shifted
five minutes later at every stop; the `20260808` added-service exception
removed; `feed_version` `2026-06-01-A` to `2026-09-01-B`; `feed_start_date` and
`feed_end_date` moved to 20260901 and 20261231. Note stop `S3`'s displacement
tolerance: accept 400–650 m.

- [ ] **Step 4: Verify the key against the computed output**

Create `$SCRATCH/check-answer-key.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
F=fixtures/ANSWER-KEY.md

check "test -f $F" "file exists"
for h in '## Services on a date' '## Departure boards' '## Validation findings' '## Feed diff'; do
  check "grep -qF '$h' $F" "section present: $h"
done
check "grep -q '2026-09-15T00:52' $F" "records the past-midnight wall clock instant"
check "grep -q '24:52:00' $F" "records the raw feed time"
check "grep -c 'T4' $F | grep -qv '^0$'" "references trip T4"
check "grep -q '2026-07-03' $F" "covers the exception-removal date"
check "grep -q '2026-08-08' $F" "covers the exception-addition date"
check "grep -q 'S5' $F" "covers the null island stop"
check "grep -q 'R1' $F" "covers the contrast finding"
for r in implausible-travel-speed null-island-stop unused-stop \
         route-color-contrast feed-window-coverage; do
  check "grep -q '$r' $F" "uses rule slug $r"
done

exit $fail
```

Run: `bash $SCRATCH/check-answer-key.sh`
Expected: every line PASS, exit code 0.

Then reread the departure-board tables against the Step 2 output line by line.
Every feed time and wall-clock instant must match.

- [ ] **Step 5: Commit**

```bash
git add fixtures/ANSWER-KEY.md
git commit -m "docs: add fixture answer key"
```

---

### Task 6: API contract

**Files:**
- Create: `system/api-contract.md`

**Interfaces:**
- Consumes: component names from Task 1; identifiers from Task 3.
- Produces: the endpoint set that acceptance slices 01, 02, 03, 04, and 06 and
  the UI slice all reference. Exact paths:
  `GET /health`, `POST /feeds`, `GET /feeds`, `GET /feeds/{feedId}`,
  `POST /feeds/{feedId}/validation`, `GET /feeds/{feedId}/validation`,
  `GET /feeds/{feedId}/services?date=YYYY-MM-DD`,
  `GET /feeds/{feedId}/stops/{stopId}/departures?date=YYYY-MM-DD`,
  `GET /feeds/{feedId}/diff?against={otherFeedId}`.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-contract.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
F=system/api-contract.md

check "test -f $F" "file exists"
for p in 'GET /health' 'POST /feeds' 'GET /feeds/{feedId}' \
         'POST /feeds/{feedId}/validation' 'GET /feeds/{feedId}/validation' \
         'GET /feeds/{feedId}/services' 'departures' 'diff'; do
  check "grep -qF '$p' $F" "documents $p"
done
check "grep -q '404' $F" "documents not-found behavior"
check "grep -q '202\\|201' $F" "documents async or created status"
check "grep -qi 'no authentication' $F" "states auth is out of scope"
check "! grep -qiE '\\b(aws|azure|lambda|api gateway|express|fastapi)\\b' $F" "names no cloud or framework"

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-contract.sh`
Expected: every check FAILs.

- [ ] **Step 3: Write `system/api-contract.md`**

Open with: this contract is the specification. Any implementation on any cloud
that satisfies it is correct. There is no authentication on any endpoint; it is
out of scope for these workshops.

Conventions section: all request and response bodies are JSON; dates in query
parameters and response fields use `YYYY-MM-DD`; feed times are returned as
given in the feed, in `HH:MM:SS`, and may exceed `23`; every response that
carries a feed time also carries the resolved wall-clock instant as an ISO 8601
string with offset. Error responses share a shape: an object with `error` and
`message`.

Then one subsection per endpoint, each giving method and path, path and query
parameters, request body shape where applicable, success status and response
shape, and error statuses with their meaning. Specify:

- `GET /health` — 200 with `{ "status": "ok" }`.
- `POST /feeds` — accepts a feed reference (a name and a location in object
  storage); 202 with `{ "feedId": "...", "status": "pending" }`. 400 when the
  reference is missing.
- `GET /feeds` — 200 with a list of `{ feedId, name, status, ingestedAt }`.
- `GET /feeds/{feedId}` — 200 with the feed summary: counts of agencies,
  stops, routes, trips, and stop times, plus `feedStartDate` and `feedEndDate`.
  404 when unknown.
- `POST /feeds/{feedId}/validation` — 202 with
  `{ "reportId": "...", "status": "pending" }`. 404 when the feed is unknown.
- `GET /feeds/{feedId}/validation` — 200 with
  `{ reportId, status, findings: [ { rule, severity, entityType, entityId,
  message } ] }` where severity is one of `error`, `warning`, `info`. 404 when
  no report exists.
- `GET /feeds/{feedId}/services?date=YYYY-MM-DD` — 200 with
  `{ date, serviceIds: [...] }`. 400 on a malformed date.
- `GET /feeds/{feedId}/stops/{stopId}/departures?date=YYYY-MM-DD` — 200 with
  `{ date, stopId, departures: [ { tripId, routeId, headsign, feedTime,
  scheduledAt } ] }` where `feedTime` is the raw value and `scheduledAt` is the
  resolved instant. State explicitly that departures whose `feedTime` exceeds
  `24:00:00` belong to the queried service date and resolve to the following
  calendar day, and must be included. 404 for an unknown stop.
- `GET /feeds/{feedId}/diff?against={otherFeedId}` — 200 with
  `{ from, to, changes: [ { changeType, entityType, entityId, detail } ] }`
  where `changeType` is one of `added`, `removed`, `modified`. 404 when either
  feed is unknown.

Close with a **Worked example** section using `demo-feed`: the departures
response for stop `S2` on `2026-09-14`, showing all three departures including
`24:52:00` resolving to the next day, with a link to the answer key's
`#departure-boards` anchor.

- [ ] **Step 4: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-contract.sh`
Expected: every line PASS, exit code 0.

- [ ] **Step 5: Commit**

```bash
git add system/api-contract.md
git commit -m "docs: add cloud-neutral HTTP API contract"
```

---

### Task 7: Acceptance criteria, slices 01 to 03

**Files:**
- Create: `system/acceptance/01-health.md`
- Create: `system/acceptance/02-ingest.md`
- Create: `system/acceptance/03-query.md`

**Interfaces:**
- Consumes: endpoints from Task 6, fixture identifiers from Task 3, answers
  from Task 5.
- Produces: the slice files `system/backlog.md` links to in Task 9, and that
  workshop guides reference by relative path.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-acceptance.sh` (reused by Task 8):

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }

for f in "$@"; do
  check "test -f $f" "$f exists"
  check "grep -qi '^## Goal' $f" "$f has a Goal section"
  check "grep -qi '^## Done when' $f" "$f has a Done when section"
  check "! grep -qiE '\\b(aws|azure|lambda|terraform|bicep|npm|pytest|jest|dotnet|pip)\\b' $f" "$f names no tool or framework"
done

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-acceptance.sh system/acceptance/01-health.md system/acceptance/02-ingest.md system/acceptance/03-query.md`
Expected: every check FAILs; the files do not exist.

- [ ] **Step 3: Write `system/acceptance/01-health.md`**

- **## Goal** — a running, reachable HTTP endpoint that reports the service is
  alive, deployed to your cloud or running locally.
- **## Preconditions** — none. This is the first slice.
- **## Done when** — a numbered list of observable conditions: requesting
  `GET /health` returns status 200; the body is `{ "status": "ok" }`; you
  reached it over HTTP from outside the process that serves it; you can state
  the URL out loud.
- **## Notes** — the point is a reachable endpoint, not a complete
  architecture. Resist scaffolding the whole service here.

- [ ] **Step 4: Write `system/acceptance/02-ingest.md`**

- **## Goal** — parse `fixtures/demo-feed` into a normalized store and report
  what was ingested.
- **## Preconditions** — slice 01 complete.
- **## Done when** — `POST /feeds` referencing the fixture returns 202 with a
  feed identifier; after ingest completes, `GET /feeds` lists that feed;
  `GET /feeds/{feedId}` returns counts matching exactly: 1 agency, 6 stops,
  3 routes, 4 trips, 12 stop times, and `feedStartDate` 2026-06-01 with
  `feedEndDate` 2026-07-31.
- **## Traps in this slice** — `stop_times` values may exceed `24:00:00`;
  parsing them as clock times fails. `feed_info` dates are `YYYYMMDD` while the
  API returns `YYYY-MM-DD`.
- **## Notes** — do not "fix" the fixture's defects during ingest. They are
  deliberate and slice 04 detects them.

- [ ] **Step 5: Write `system/acceptance/03-query.md`**

- **## Goal** — answer which services run on a date, and produce a departure
  board for a stop on a date.
- **## Preconditions** — slice 02 complete.
- **## Done when** — a numbered list, each row citing the answer key:
  `GET /feeds/{feedId}/services?date=2026-09-14` returns `NIGHT` and `WEEKDAY`;
  `date=2026-09-19` returns `NIGHT` and `WEEKEND`; `date=2026-07-03` returns
  `NIGHT` and `WEEKEND`; `date=2026-08-08` returns `NIGHT`, `WEEKDAY`, and
  `WEEKEND`. Then: departures for stop `S2` on `2026-09-14` return exactly three
  entries with feed times `06:09:00`, `07:00:00`, and `24:52:00`, and the last
  resolves to `2026-09-15T00:52` local time; departures for `S2` on
  `2026-08-08` return exactly four entries.
- **## Traps in this slice** — the two exception dates invert if
  `exception_type` is read backwards, and 2026-07-03 is the one that catches it:
  a naive weekday lookup returns `WEEKDAY`, the correct answer is `WEEKEND`. The
  `24:52:00` departure is dropped entirely by naive time parsing, or is
  misplaced onto the queried date.
- **## Verify against** — relative link to `../../fixtures/ANSWER-KEY.md`
  sections `#services-on-a-date` and `#departure-boards`.

- [ ] **Step 6: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-acceptance.sh system/acceptance/01-health.md system/acceptance/02-ingest.md system/acceptance/03-query.md`
Expected: every line PASS, exit code 0.

Then confirm the counts stated in `02-ingest.md` against the fixture:

Run: `wc -l fixtures/demo-feed/*.txt`
Expected: `stops.txt` 7 lines, `routes.txt` 4, `trips.txt` 5,
`stop_times.txt` 13, `agency.txt` 2 — each including a header row, so the
documented counts of 6 stops, 3 routes, 4 trips, 12 stop times, 1 agency are
correct.

- [ ] **Step 7: Commit**

```bash
git add system/acceptance/01-health.md system/acceptance/02-ingest.md system/acceptance/03-query.md
git commit -m "docs: add acceptance criteria for health, ingest, and query slices"
```

---

### Task 8: Acceptance criteria, slices 04 to 06

**Files:**
- Create: `system/acceptance/04-validation.md`
- Create: `system/acceptance/05-ui.md`
- Create: `system/acceptance/06-diff.md`

**Interfaces:**
- Consumes: the five expected findings and the diff list from Task 5; endpoints
  from Task 6.
- Produces: the rule names workshop 2 and 3 reference when participants add
  validators: `implausible-travel-speed`, `null-island-stop`, `unused-stop`,
  `route-color-contrast`, `feed-window-coverage`.

- [ ] **Step 1: Write the verification checks**

Reuse `$SCRATCH/check-acceptance.sh` from Task 7 and add rule-name checks.
Create `$SCRATCH/check-acceptance-2.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
F=system/acceptance/04-validation.md

for r in implausible-travel-speed null-island-stop unused-stop \
         route-color-contrast feed-window-coverage; do
  check "grep -q '$r' $F" "names rule $r"
done
check "grep -q 'error' $F && grep -q 'warning' $F" "documents severities"
check "grep -q 'ANSWER-KEY' $F" "links the answer key"
check "grep -q 'ANSWER-KEY' system/acceptance/06-diff.md" "diff slice links the answer key"
check "grep -q 'demo-feed-v2' system/acceptance/06-diff.md" "diff slice names the v2 feed"

exit $fail
```

- [ ] **Step 2: Run both check scripts to verify they fail**

Run: `bash $SCRATCH/check-acceptance.sh system/acceptance/04-validation.md system/acceptance/05-ui.md system/acceptance/06-diff.md`
Run: `bash $SCRATCH/check-acceptance-2.sh`
Expected: checks FAIL; the files do not exist.

- [ ] **Step 3: Write `system/acceptance/04-validation.md`**

- **## Goal** — run a rule set against an ingested feed and produce a report.
- **## Preconditions** — slice 02 complete.
- **## Done when** — `POST /feeds/{feedId}/validation` returns 202;
  `GET /feeds/{feedId}/validation` returns a report whose findings are exactly
  the five in the answer key, no more and no fewer; each finding carries the
  rule name, a severity, and the entity it concerns.
- **## The rule set** — a table with columns rule name, severity, and what it
  detects, using exactly these names: `implausible-travel-speed` (error, a hop
  between consecutive stops implying a speed no vehicle of that route type could
  achieve); `null-island-stop` (error, a stop at latitude 0 and longitude 0);
  `unused-stop` (warning, a stop referenced by no stop time);
  `route-color-contrast` (warning, insufficient contrast between a route's
  background and text colors); `feed-window-coverage` (warning, the feed's
  declared date window does not cover the service dates in its calendars).
- **## Design note** — each rule should be independently addable. How you
  structure that is your call, but the shape you choose here is what workshop 2
  encodes as a convention skill and what workshop 3's parallel agents extend.
- **## Verify against** — link to `../../fixtures/ANSWER-KEY.md#validation-findings`.

- [ ] **Step 4: Write `system/acceptance/05-ui.md`**

- **## Goal** — a browser UI over the API with three views.
- **## Preconditions** — slices 03 and 04 complete.
- **## Done when** — the feed list view shows every ingested feed with its
  status and ingest time; selecting a feed shows its validation report grouped
  by severity, with errors before warnings, and each finding naming the entity
  it concerns; the departure board view accepts a stop and a date and shows the
  results for stop `S2` on `2026-09-14` matching the answer key, including the
  `24:52:00` departure labelled with its next-day date so a reader cannot
  mistake it for 00:52 on the queried day.
- **## Notes** — no authentication. Styling is not assessed. The
  next-day labelling is the part that matters: it is the visible proof the
  service date concept survived all the way to the screen.
- **## Verify against** — link to `../../fixtures/ANSWER-KEY.md#departure-boards`.

- [ ] **Step 5: Write `system/acceptance/06-diff.md`**

- **## Goal** — compare two ingested feed versions and report the service
  changes in terms a transit planner would recognize.
- **## Preconditions** — slice 02 complete; both `fixtures/demo-feed` and
  `fixtures/demo-feed-v2` ingested.
- **## Done when** — `GET /feeds/{feedId}/diff?against={otherFeedId}` returns
  changes covering all of: route `R2` removed; trip `T3` removed; trip `T2`
  removed, leaving route `R1` with no weekend service; stop `S3` relocated by
  roughly 500 m; trip `T1` shifted five minutes later at every stop; the
  `2026-08-08` added-service exception removed; the feed version and date window
  changed. Each change names the entity and describes the change in one
  sentence.
- **## Notes** — the value is the rendering, not the detection. "Route 1 no
  longer runs on weekends" is useful; "trips.txt row count decreased by 2" is
  not.
- **## Verify against** — link to `../../fixtures/ANSWER-KEY.md#feed-diff`.

- [ ] **Step 6: Run both check scripts to verify they pass**

Run: `bash $SCRATCH/check-acceptance.sh system/acceptance/04-validation.md system/acceptance/05-ui.md system/acceptance/06-diff.md`
Run: `bash $SCRATCH/check-acceptance-2.sh`
Expected: every line PASS, exit code 0 from both.

- [ ] **Step 7: Commit**

```bash
git add system/acceptance/04-validation.md system/acceptance/05-ui.md system/acceptance/06-diff.md
git commit -m "docs: add acceptance criteria for validation, UI, and diff slices"
```

---

### Task 9: Backlog

**Files:**
- Create: `system/backlog.md`

**Interfaces:**
- Consumes: all six acceptance files.
- Produces: the between-session work list that all three participant guides link
  to under "Continue on your own."

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-backlog.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
F=system/backlog.md

check "test -f $F" "file exists"
for a in 01-health 02-ingest 03-query 04-validation 05-ui 06-diff; do
  check "grep -q 'acceptance/$a.md' $F" "links acceptance/$a.md"
done

# every relative link in the backlog must resolve
while read -r target; do
  check "test -e system/$target" "link resolves: $target"
done < <(grep -o '](\./[^)]*)' $F | sed 's/](\.\///; s/)$//')

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-backlog.sh`
Expected: FAIL on file existence and every acceptance link.

- [ ] **Step 3: Write `system/backlog.md`**

Open with **How to use this**: this is the work you do between sessions. Slices
are ordered so each one leaves the system working and each is completable on its
own. Take the next one, or skip ahead if a session pointed you somewhere
specific. Every slice has an acceptance file that says exactly when it is done.

Then a table with columns slice, goal (one line), and acceptance, one row per
slice, linking `./acceptance/01-health.md` through `./acceptance/06-diff.md`:

1. Health endpoint — get something running and reachable on your cloud.
2. Feed ingest — parse the fixture feed into a store and report what landed.
3. Service queries — which services run on a date, and a departure board.
4. Validation — the five-rule set and a report.
5. UI — feed list, validation report, departure board.
6. Feed diff — compare two versions into a readable service-change report.

Close with **Where the sessions land you**: after workshop 1 you should have
slice 1 done and be working on 2 and 3; workshop 2's skills are drawn from what
bit you in 3; workshop 3 fans slices 4, 5, and 6 across parallel agents.

- [ ] **Step 4: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-backlog.sh`
Expected: every line PASS, exit code 0.

- [ ] **Step 5: Commit**

```bash
git add system/backlog.md
git commit -m "docs: add ordered slice backlog for between-session work"
```

---

### Task 10: Provided fixture-builder skill

**Files:**
- Create: `.claude/skills/gtfs-fixture-builder/SKILL.md`

**Interfaces:**
- Consumes: `system/gtfs-reference.md` semantics; the fixture layout from Task 3.
- Produces: the skill workshop 2 exercise 1 invokes, and workshop 3's adversary
  agent uses. Its frontmatter `name` is `gtfs-fixture-builder`.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-skill.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
F=.claude/skills/gtfs-fixture-builder/SKILL.md

check "test -f $F" "file exists"
check "head -1 $F | grep -q '^---$'" "starts with frontmatter"
check "grep -q '^name: gtfs-fixture-builder$' $F" "declares its name"
check "grep -q '^description: Use when' $F" "description starts with a trigger phrase"
check "awk '/^description:/ { if (length(\$0) > 60 && length(\$0) < 600) ok=1 } END { exit !ok }' $F" "description is substantive but not bloated"
check "grep -q 'exception_type' $F" "covers calendar exceptions"
check "grep -q '24:00:00\\|25:' $F" "covers past-midnight times"
check "grep -q 'stop_sequence' $F" "covers stop sequencing"

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-skill.sh`
Expected: every check FAILs.

- [ ] **Step 3: Write the skill**

Frontmatter:

```markdown
---
name: gtfs-fixture-builder
description: Use when building, extending, or repairing a small GTFS fixture feed for testing - generates a minimal referentially-valid feed, optionally seeded with a named defect such as a past-midnight departure, an inverted calendar exception, an implausible travel speed, or a stop served by no trip
---
```

Body sections:

- **What this does** — produces the smallest GTFS feed that is referentially
  valid and exercises a named edge case. It is for test fixtures, not for
  publishing.
- **The minimum viable feed** — the eight files required and, for each, the
  minimum columns needed for the feed to resolve: exactly the field set used in
  `fixtures/demo-feed`. Include a complete, copyable minimal feed of one agency,
  two stops, one route, one trip, two stop times, and one calendar entry. All
  eight files must appear, including a header-only `calendar_dates.txt` and a
  `feed_info.txt` carrying one row, so that a feed produced from this template
  passes referential-integrity checking without further edits.
- **Rules that are easy to break** — a checklist to run over any feed produced:
  every `trip_id` in `stop_times.txt` exists in `trips.txt`; every `stop_id`
  resolves; every `service_id` resolves; `stop_sequence` strictly increases
  within a trip; `arrival_time` never exceeds `departure_time` at the same stop;
  departure times never decrease along a trip; dates are `YYYYMMDD` with no
  separators; colors are six hex digits with no leading `#`.
- **Seeding a named defect** — a table with columns defect, how to seed it, and
  what a correct validator should say. Cover: past-midnight departure (use
  `24:35:00` or later and keep the trip's times non-decreasing); inverted
  calendar exception (`exception_type` 1 adds, 2 removes — seed the one that
  contradicts the weekday flag); implausible travel speed (place consecutive
  stops far apart with a short interval); orphan stop (define it in `stops.txt`
  and reference it nowhere); null island stop (latitude and longitude both 0);
  low route color contrast; expired feed window.
- **Before you hand the feed over** — restate the checklist as a final gate, and
  say plainly that a fixture whose referential integrity is broken by accident
  teaches nothing, because the failure it produces is not the failure under test.

- [ ] **Step 4: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-skill.sh`
Expected: every line PASS, exit code 0.

- [ ] **Step 5: Verify the skill's own example feed is valid**

Extract the minimal feed from the skill body into
`$SCRATCH/minimal-feed/`, writing all eight files, and run the Task 3 checker:

Run: `python3 $SCRATCH/check-feed.py $SCRATCH/minimal-feed`
Expected: every `present`, referential-integrity, and sequencing check PASSes.
The trap checks FAIL, which is correct — the minimal example seeds no defects.
Confirm that every failure reported is a line beginning `TRAP:`. A failure on
any other line means the skill's example feed is broken and must be fixed before
committing, because a template that produces an invalid feed teaches the wrong
lesson.

- [ ] **Step 6: Commit**

```bash
git add .claude/skills/gtfs-fixture-builder/SKILL.md
git commit -m "feat: add gtfs-fixture-builder skill for workshop 2"
```

---

### Task 11: Workshop 1 — Foundations

**Files:**
- Create: `workshops/01-foundations/participant.md`
- Create: `workshops/01-foundations/facilitator.md`

**Interfaces:**
- Consumes: `system/acceptance/01-health.md`, `system/api-contract.md`,
  `system/backlog.md`.
- Produces: the guide format that tasks 12 and 13 follow exactly.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-workshop.sh` (reused by Tasks 12 and 13):

```bash
#!/usr/bin/env bash
set -u
DIR=$1
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
P=$DIR/participant.md
F=$DIR/facilitator.md

check "test -f $P" "$P exists"
check "test -f $F" "$F exists"

for h in 'The technique' 'Why it matters' 'The exercise' 'What to notice' \
         'Continue on your own' 'In other tools'; do
  check "grep -qi '## .*$h' $P" "participant has section: $h"
done
for h in 'Timing' 'Failure modes' 'Debrief' 'Answer key' 'Coaching prompts'; do
  check "grep -qi '## .*$h' $F" "facilitator has section: $h"
done

check "grep -q 'backlog.md' $P" "participant links the backlog"
check "grep -qi 'copilot' $P" "participant mentions Copilot"
check "grep -qi 'cursor' $P" "participant mentions Cursor"

# all relative links resolve
while read -r target; do
  check "test -e $DIR/$target" "link resolves: $target"
done < <(grep -oh '](\.\.\/[^)]*)' $P $F | sed 's/](//; s/)$//' | sort -u)

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-workshop.sh workshops/01-foundations`
Expected: every check FAILs.

- [ ] **Step 3: Write `workshops/01-foundations/participant.md`**

Follow the six-part spine exactly.

- **## The technique** — supplying context, planning before code, and verifying
  rather than trusting. Three sentences.
- **## Why it matters** — an agent that lacks context invents plausible details,
  and a summary that says "deployed successfully" is a claim, not evidence. Both
  failures are cheap to catch and expensive to discover later.
- **## The exercise** — get a health endpoint running and reachable on the cloud
  you choose, using the agent to scaffold it. Numbered instructions stating
  goals, not prompts:
  1. Open `../../system/api-contract.md` and give the agent the health endpoint
     section directly, rather than describing it from memory.
  2. Before it writes anything, get a plan out of it: what it will create, where,
     and how you will run it. Read the plan and correct at least one thing.
  3. Let it implement. Do not accept "done" as a result.
  4. Call the endpoint yourself and read the response body.
  5. Confirm against `../../system/acceptance/01-health.md`.
  - **Checkpoint** — you can state the URL out loud and you have seen
    `{"status":"ok"}` come back with your own eyes.
- **## What to notice** — did you read the plan or skim it? When it said it was
  done, what did you actually check? If you corrected the plan, would the code
  have been wrong without that correction?
- **## Continue on your own** — take slices 2 and 3 from
  `../../system/backlog.md`. Warning, stated plainly: slice 3 contains two traps
  that reliably produce confident wrong answers. Do not look them up in advance.
  Bring what happened to session 2.
- **## In other tools** — Copilot: the equivalent moves are attaching files as
  context in chat rather than relying on the open editor, and asking for a plan
  before an edit. Cursor: referencing files explicitly with `@` and using its
  planning step. The mechanism differs; supplying context and verifying output
  do not.

- [ ] **Step 4: Write `workshops/01-foundations/facilitator.md`**

- **## Timing** — a table for sixty minutes: 0–5 framing and the arc across three
  sessions; 5–10 the exercise brief; 10–50 hands-on with you circulating;
  50–60 debrief. Note that people will finish the endpoint at very different
  times; the ones who finish early should start slice 2 rather than wait.
- **## Failure modes to allow** — someone accepts "successfully deployed" without
  calling the endpoint; let it happen and use it in the debrief. Someone lets the
  agent scaffold the entire service instead of one endpoint, then cannot get it
  running; this is the scope lesson and is worth ten minutes. Someone's cloud
  account is not ready; have them run locally and move on, since the lesson does
  not depend on a real deploy.
- **## Failure modes to interrupt** — anyone still fighting credentials at the
  thirty-minute mark. Switch them to local and let them deploy later.
- **## Debrief questions** — who called their endpoint versus who read the
  summary? What did the agent assume that you did not tell it? What did you
  correct in the plan, and what would have happened if you had not?
- **## Answer key references** — this session touches no fixture answers; slice
  1 has no data. Point people at `../../fixtures/ANSWER-KEY.md` now anyway, since
  they will need it for slice 3 during the week, and tell them it is the
  arbiter, not their implementation.
- **## Coaching prompts to offer live** — when someone is stuck describing the
  problem, suggest pasting the contract section instead of paraphrasing it. When
  an agent produces something surprising, suggest asking it what it assumed.
  When someone is about to accept a large diff, suggest asking for the plan
  first and only then the code. When someone hits an error loop, suggest they
  give the agent the actual error text rather than a description of it.

- [ ] **Step 5: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-workshop.sh workshops/01-foundations`
Expected: every line PASS, exit code 0.

- [ ] **Step 6: Commit**

```bash
git add workshops/01-foundations
git commit -m "docs: add workshop 1 foundations guides"
```

---

### Task 12: Workshop 2 — Skills

**Files:**
- Create: `workshops/02-skills/participant.md`
- Create: `workshops/02-skills/facilitator.md`

**Interfaces:**
- Consumes: the guide format from Task 11; the skill from Task 10; traps from
  slice 03.
- Produces: the convention-skill idea that workshop 3 depends on for mergeable
  parallel work.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-workshop2.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
P=workshops/02-skills/participant.md

check "grep -q 'gtfs-fixture-builder' $P" "names the provided skill"
check "grep -qi 'description' $P" "discusses the description field"
check "grep -qi 'fresh session' $P" "requires a fresh-session test"
check "! grep -qiE 'paste (this|the following) prompt' $P" "supplies no prompt to paste"

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-workshop.sh workshops/02-skills` and
`bash $SCRATCH/check-workshop2.sh`
Expected: checks FAIL; the files do not exist.

- [ ] **Step 3: Write `workshops/02-skills/participant.md`**

- **## The technique** — stop re-explaining yourself. Use a skill someone else
  wrote, then encode your own hard-won knowledge into one.
- **## Why it matters** — during the week you explained the same GTFS quirk to
  the agent more than once. Everything you re-explain in every session is
  knowledge that belongs in a file.
- **## The exercise** — two parts.
  - *Part one, roughly fifteen minutes.* Ask your agent to build a small fixture
    feed that exercises one specific defect, without invoking the provided skill.
    Then do the same task with `.claude/skills/gtfs-fixture-builder/` available.
    Compare the two results against the checklist in the skill body. Note what
    the second run got right that the first did not.
  - *Part two, roughly twenty-five minutes.* Author one skill capturing a GTFS
    trap that actually bit you during the week — most likely past-midnight times
    or calendar exception semantics. Write the body first, then spend real effort
    on the description, since that is what decides whether it fires.
  - **Checkpoint** — open a fresh session with no context and ask for something
    the skill should govern. If it does not fire, fix the description, not the
    body.
- **## What to notice** — the description is the whole ballgame. A perfect body
  with a vague description never runs. Notice also what you left out: a skill
  that restates the specification is worthless, while a skill that captures the
  thing you got wrong is not.
- **## Continue on your own** — author a second skill describing how a validator
  is written in your system: where the file goes, how it registers, what its
  output looks like. Then use it to build the rule set in slice 4 from
  `../../system/backlog.md`. This convention skill is what makes session 3 work,
  because parallel agents produce mergeable code only when they agree on shape.
- **## In other tools** — Copilot: custom instructions files and reusable
  prompt files play a similar role, though they load differently. Cursor: rules
  files, scoped by glob. All three answer the same question, which is where
  knowledge lives so you stop retyping it.

- [ ] **Step 4: Write `workshops/02-skills/facilitator.md`**

- **## Timing** — 0–5 recap of what bit people during the week, collected from
  the room; 5–20 part one with the provided skill; 20–45 part two authoring;
  45–55 fresh-session tests, several out loud; 55–60 debrief and the setup for
  session 3.
- **## Failure modes to allow** — writing a skill that restates the GTFS
  specification rather than the mistake; the fresh-session test is what exposes
  it. Writing a description that describes the skill instead of when to use it,
  so it never fires. Writing one enormous skill covering everything.
- **## Failure modes to interrupt** — anyone who skips the fresh-session test.
  That test is the entire point of the second half.
- **## Debrief questions** — whose skill fired without being asked for? For
  those that did not, what was wrong with the description? What did you almost
  put in that would have been noise?
- **## Answer key references** — part one's fixtures can be checked against the
  integrity checklist in the skill body. Slice 3 answers, which people should
  have hit during the week, are in `../../fixtures/ANSWER-KEY.md` under
  `#services-on-a-date` and `#departure-boards`. Expect disagreement about
  2026-07-03; that is the inverted-exception trap and it makes an excellent
  five-minute detour.
- **## Coaching prompts to offer live** — when someone is unsure what belongs in
  a skill, ask what they have now explained twice. When a skill will not fire,
  have them read the description alone and ask whether it says when to use it.
  When a skill is growing long, suggest splitting the part that is domain
  knowledge from the part that is house style.

- [ ] **Step 5: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-workshop.sh workshops/02-skills` and
`bash $SCRATCH/check-workshop2.sh`
Expected: every line PASS, exit code 0 from both.

- [ ] **Step 6: Commit**

```bash
git add workshops/02-skills
git commit -m "docs: add workshop 2 skills guides"
```

---

### Task 13: Workshop 3 — Agents

**Files:**
- Create: `workshops/03-agents/participant.md`
- Create: `workshops/03-agents/facilitator.md`

**Interfaces:**
- Consumes: the guide format from Task 11; the convention skill from Task 12;
  slices 4, 5, and 6.
- Produces: nothing downstream. This is the last authored guide.

- [ ] **Step 1: Write the verification checks**

Create `$SCRATCH/check-workshop3.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }
P=workshops/03-agents/participant.md
F=workshops/03-agents/facilitator.md

check "grep -qi 'subagent' $P" "covers defining a subagent"
check "grep -qi 'zed\\|omnigent' $P" "names the parallel-thread tooling"
check "grep -qi 'worktree' $P" "covers isolating parallel work"
check "grep -qi 'integration' $F" "facilitator addresses the integration tax"
check "grep -q 'gtfs-fixture-builder' $P" "adversary agent uses the provided skill"

exit $fail
```

- [ ] **Step 2: Run the checks to verify they fail**

Run: `bash $SCRATCH/check-workshop.sh workshops/03-agents` and
`bash $SCRATCH/check-workshop3.sh`
Expected: checks FAIL; the files do not exist.

- [ ] **Step 3: Write `workshops/03-agents/participant.md`**

- **## The technique** — delegating scoped work to a subagent, and running
  several agent threads at once.
- **## Why it matters** — you cannot supervise four threads the way you
  supervise one. Delegation only pays when the brief is good enough that you can
  judge the artifact without reading the transcript.
- **## The exercise** — two parts.
  - *Part one, roughly twenty minutes.* Define one subagent. Pick either a
    validator implementer, briefed with your convention skill from session 2, or
    an adversary whose job is to use `.claude/skills/gtfs-fixture-builder/` to
    build hostile feeds that break the validators you already wrote. Delegate one
    scoped task to it. Review the artifact it produced, not the transcript.
  - *Part two, roughly twenty minutes.* Start two threads on independent work
    from `../../system/backlog.md` — two different validation rules, or a rule
    and a UI view. Isolate them so they cannot collide, using a worktree per
    thread. Then integrate both and confirm the whole system still satisfies its
    acceptance criteria.
  - **Checkpoint** — both threads' work is merged and slice 4's findings still
    match the answer key exactly.
- **## What to notice** — how much of the brief you had to write before
  delegation was safe. Whether the two threads produced code in the same shape,
  and if so, what made that happen. How long integration took relative to the
  work itself.
- **## Continue on your own** — fan slices 4, 5, and 6 across parallel threads
  in Zed or Omnigent and finish the system. Keep a note of every time
  parallelism cost more than it saved. That note is the most useful thing you
  will take back to client work.
- **## In other tools** — Copilot: coding agent tasks assigned to work
  independently, reviewed as pull requests. Cursor: background agents on
  separate branches. The isolation-and-review pattern is the same everywhere;
  only the plumbing changes.

- [ ] **Step 4: Write `workshops/03-agents/facilitator.md`**

- **## Timing** — 0–5 framing, including the honest claim that parallelism is
  not free; 5–25 part one; 25–45 part two; 45–55 integration, which will run
  over and should be allowed to; 55–60 debrief.
- **## Failure modes to allow** — two threads editing the same file and
  conflicting, which is the whole lesson about decomposition. A brief too thin
  for the agent to succeed, producing plausible work that fails acceptance. Four
  threads started when two would have been faster.
- **## Failure modes to interrupt** — anyone who merges without re-running their
  acceptance checks. That is the verification lesson from session 1 returning at
  a larger scale.
- **## Debrief questions** — did the parallel run finish sooner than doing it
  sequentially, honestly measured? Whose threads produced consistent code, and
  what did they have in place that others did not? What would you refuse to
  parallelize on a client project?
- **## Integration tax** — a short section stating that the point of this
  session is not that parallel is faster. It is that parallel is a tool with a
  cost, and the cost is paid at integration. A room that concludes "two was
  better than four here" has learned the right thing.
- **## Answer key references** — after integration, slice 4's findings must
  still be exactly the five in
  `../../fixtures/ANSWER-KEY.md#validation-findings`. Over-flagging after a
  parallel run usually means two threads implemented overlapping rules.
- **## Coaching prompts to offer live** — before a thread starts, ask what the
  agent would need to know that only exists in someone's head. When threads
  collide, ask what boundary would have prevented it. When someone is reading a
  transcript closely, ask what artifact they could check instead.

- [ ] **Step 5: Run the checks to verify they pass**

Run: `bash $SCRATCH/check-workshop.sh workshops/03-agents` and
`bash $SCRATCH/check-workshop3.sh`
Expected: every line PASS, exit code 0 from both.

- [ ] **Step 6: Commit**

```bash
git add workshops/03-agents
git commit -m "docs: add workshop 3 agents guides"
```

---

### Task 14: Repository-wide consistency pass

**Files:**
- Modify: any file with an unresolved link or an inconsistent identifier

**Interfaces:**
- Consumes: everything.
- Produces: a verified-consistent repository.

- [ ] **Step 1: Write the whole-repository check**

Create `$SCRATCH/check-all.sh`:

```bash
#!/usr/bin/env bash
set -u
fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "PASS: $2"; else echo "FAIL: $2"; fail=1; fi; }

# every relative markdown link in the DELIVERABLE markdown resolves.
# docs/ is excluded deliberately: the plan and spec are process artifacts, and
# their fenced bash blocks contain grep patterns that look like markdown links.
while read -r file; do
  dir=$(dirname "$file")
  while read -r target; do
    base=${target%%#*}
    [ -z "$base" ] && continue
    check "test -e '$dir/$base'" "$file -> $target"
  done < <(grep -oh '](\([^)]*\))' "$file" 2>/dev/null \
           | sed 's/](//; s/)$//' \
           | grep -v '^http' | grep -v '^mailto')
done < <(git ls-files '*.md' | grep -v '^docs/')

# no committed implementation code
check "! git ls-files | grep -qE '\\.(ts|js|py|cs|go|java|rb|tf|bicep|yaml|yml|json)$'" "no implementation or config code committed"

# global constraint: acceptance files stay tool-neutral
check "! grep -rqiE '\\b(aws|azure|lambda|terraform|bicep|pytest|jest)\\b' system/acceptance/" "acceptance criteria stay tool-neutral"

# every fixture identifier mentioned in prose must exist in the fixture feed.
# The check runs prose -> fixture, not the reverse: an identifier that lives
# only in the feed (S1, S6) is legitimate, but a typo in prose is not.
for id in $(grep -rhoE '\\b[SRT][0-9]\\b' system/ workshops/ fixtures/ANSWER-KEY.md | sort -u); do
  check "grep -rq '$id' fixtures/demo-feed/" "prose identifier $id exists in the fixture"
done
for id in WEEKDAY WEEKEND NIGHT; do
  check "grep -q '$id' fixtures/demo-feed/calendar.txt" "service $id exists in the fixture"
done

exit $fail
```

- [ ] **Step 2: Run it**

Run: `bash $SCRATCH/check-all.sh`
Expected: some FAIL lines are likely on the first run, from anchor links or a
path typo.

- [ ] **Step 3: Fix every failure**

Fix broken links by correcting the path in the referring file. Fix an identifier
mismatch by correcting the referring file, never the fixture — the fixture and
answer key are the source of truth.

- [ ] **Step 4: Re-run every check script**

Run each in order and confirm all pass:

```bash
bash $SCRATCH/check-task1.sh
bash $SCRATCH/check-task2.sh
python3 $SCRATCH/check-feed.py fixtures/demo-feed
bash $SCRATCH/check-feed-v2.sh
bash $SCRATCH/check-answer-key.sh
bash $SCRATCH/check-contract.sh
bash $SCRATCH/check-acceptance.sh system/acceptance/*.md
bash $SCRATCH/check-acceptance-2.sh
bash $SCRATCH/check-backlog.sh
bash $SCRATCH/check-skill.sh
bash $SCRATCH/check-workshop.sh workshops/01-foundations
bash $SCRATCH/check-workshop.sh workshops/02-skills
bash $SCRATCH/check-workshop2.sh
bash $SCRATCH/check-workshop.sh workshops/03-agents
bash $SCRATCH/check-workshop3.sh
bash $SCRATCH/check-all.sh
```

Expected: exit code 0 from every one.

- [ ] **Step 5: Re-run the answer computation and reconcile**

Run: `python3 $SCRATCH/compute-answers.py`
Expected: output identical to the block recorded in Task 5 Step 2, and matching
the tables in `fixtures/ANSWER-KEY.md` line for line.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "docs: fix cross-references and verify repository consistency"
```

---

## Authoring-time confirmations from the spec

Two items the spec flagged, to be handled during execution rather than deferred:

1. **Fixture conformance.** Task 3's checker enforces referential integrity and
   confirms every intended defect is present. Task 5's computation independently
   derives the answers. Between them, the fixture is genuinely conformant where
   it intends to be and non-conformant only where a trap is intended.
2. **Copilot and Cursor equivalences.** Tasks 11, 12, and 13 each contain an
   "In other tools" section. Before writing each one, verify the named mechanism
   still exists and is called what the guide says. If a mechanism has changed,
   describe the current one rather than the one in this plan.
