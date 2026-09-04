# Answer key

## How to use this

This file is the shared source of truth for correctness across every
workshop implementation. Participants build the ingest function, the
validation function, the HTTP API, and the UI in different stacks; their
outputs will look different from each other. What must not differ is the
data those outputs report. If your system disagrees with a value in this
file, your system is wrong, not this file.

Where a value is approximate (distances, speeds), the key states an accepted
range. Anything outside that range is a mismatch; anything inside it is
correct regardless of the exact number your implementation produces.

## Services on a date

| Date | Weekday | Active service IDs | Why |
|---|---|---|---|
| `2026-07-03` | Friday | `NIGHT`, `WEEKEND` | Weekday service removed by exception; weekend service added by exception |
| `2026-08-08` | Saturday | `NIGHT`, `WEEKDAY`, `WEEKEND` | Weekday service added by exception on top of normal weekend service |
| `2026-09-14` | Monday | `NIGHT`, `WEEKDAY` | No exceptions; ordinary weekday calendar |
| `2026-09-19` | Saturday | `NIGHT`, `WEEKEND` | No exceptions; ordinary weekend calendar |

## Departure boards

Four boards for stop `S2`, one per date above. Columns are the raw feed
time from `stop_times.txt`, the trip, and the wall-clock instant that feed
time resolves to once the service date is applied.

### 2026-07-03 (Friday)

| Feed time | Trip | Wall-clock instant |
|---|---|---|
| `09:13:00` | `T2` | `2026-07-03T09:13` |
| `24:52:00` | `T4` | `2026-07-04T00:52` |

### 2026-08-08 (Saturday)

| Feed time | Trip | Wall-clock instant |
|---|---|---|
| `06:09:00` | `T1` | `2026-08-08T06:09` |
| `07:00:00` | `T3` | `2026-08-08T07:00` |
| `09:13:00` | `T2` | `2026-08-08T09:13` |
| `24:52:00` | `T4` | `2026-08-09T00:52` |

### 2026-09-14 (Monday)

| Feed time | Trip | Wall-clock instant |
|---|---|---|
| `06:09:00` | `T1` | `2026-09-14T06:09` |
| `07:00:00` | `T3` | `2026-09-14T07:00` |
| `24:52:00` | `T4` | `2026-09-15T00:52` |

### 2026-09-19 (Saturday)

| Feed time | Trip | Wall-clock instant |
|---|---|---|
| `09:13:00` | `T2` | `2026-09-19T09:13` |
| `24:52:00` | `T4` | `2026-09-20T00:52` |

Every one of these dates has a `24:52:00` departure that falls on the
following calendar day. A departure board that omits it, or that renders it
as `00:52` on the queried date instead of rolling over, is wrong.

## Validation findings

A report with extra findings is over-flagging; a report with fewer is
under-flagging. Both feeds have an expected set, and they are not the same
set — check your report against the feed you actually validated.

### `demo-feed`

The complete expected set is five findings.

| Rule | Severity | Location | Detail |
|---|---|---|---|
| `implausible-travel-speed` | error | trip `T3`, `S2` to `S4` | 18.2 km in 120 s, 546 km/h (accept 500-600 km/h) |
| `null-island-stop` | error | stop `S5` | latitude 0, longitude 0 |
| `unused-stop` | warning | stop `S5` | appears in no `stop_times` row |
| `route-color-contrast` | warning | route `R1` | `FFFFFF` background, `FFFF00` text |
| `feed-window-coverage` | warning | `feed_info.txt` | `feed_end_date` 20260731 precedes the calendars' 20261231 |

### `demo-feed-v2`

Slice 5 renders a report for every ingested feed and slice 6 needs this one
ingested, so you will validate it too. Its expected set is also five
findings, but three of the rules land differently.

| Rule | Severity | Location | Detail |
|---|---|---|---|
| `null-island-stop` | error | stop `S5` | latitude 0, longitude 0 |
| `unused-stop` | warning | stop `S4` | removing route `R2` and trip `T3` left it served by no trip |
| `unused-stop` | warning | stop `S5` | appears in no `stop_times` row |
| `route-color-contrast` | warning | route `R1` | `FFFFFF` background, `FFFF00` text |
| `feed-window-coverage` | warning | `feed_info.txt` | `feed_start_date` 20260901 begins after the calendars' 20260601 |

Two of those are worth stating outright, because they are what a rule
written only against `demo-feed` gets wrong.

`implausible-travel-speed` produces nothing here. Trip `T3` carried the only
impossible hop and it is gone; the fastest hop in v2 is `T4` between `S6`
and `S3` at roughly 24 km/h. A rule that reports anything on this feed is
over-flagging.

`feed-window-coverage` fires from the other end. In `demo-feed` the declared
window closes too early; here it opens too late, leaving 2026-06-01 through
2026-08-31 uncovered while the end date is fine. A rule that only compares
end dates reports nothing on this feed and is under-flagging.

## Feed diff

Changes from `demo-feed` to `demo-feed-v2`:

- Route `R2` (Airport Express) is removed, along with its trip `T3`.
- Route `R1` loses its weekend trip `T2`. Route 1 has no Saturday or Sunday
  service in v2.
- Stop `S3` is relocated roughly 500 m northwest. Accept a displacement of
  400-650 m as matching.
- Trip `T1` shifts five minutes later at every stop.
- The `20260808` added-service exception (`WEEKDAY`, exception type 1) is
  removed.
- `feed_version` changes from `2026-06-01-A` to `2026-09-01-B`.
- `feed_start_date` and `feed_end_date` move to `20260901` and `20261231`.
