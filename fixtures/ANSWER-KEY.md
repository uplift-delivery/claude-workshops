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

The complete expected set of findings for `demo-feed` is five. A report with
extra findings is over-flagging; a report with fewer is under-flagging.

| Rule | Severity | Location | Detail |
|---|---|---|---|
| `implausible-travel-speed` | error | trip `T3`, `S2` to `S4` | 18.2 km in 120 s, 546 km/h (accept 500-600 km/h) |
| `null-island-stop` | error | stop `S5` | latitude 0, longitude 0 |
| `unused-stop` | warning | stop `S5` | appears in no `stop_times` row |
| `route-color-contrast` | warning | route `R1` | `FFFFFF` background, `FFFF00` text |
| `feed-window-coverage` | warning | `feed_info.txt` | `feed_end_date` 20260731 precedes the calendars' 20261231 |

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
