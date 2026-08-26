---
name: gtfs-fixture-builder
description: Use when building, extending, or repairing a small GTFS fixture feed for testing - generates a minimal referentially-valid feed, optionally seeded with a named defect such as a past-midnight departure, an inverted calendar exception, an implausible travel speed, or a stop served by no trip
---

# GTFS fixture builder

## What this does

Produces the smallest GTFS feed that is referentially valid and exercises a
named edge case. It is for test fixtures, not for publishing: the goal is a
feed that resolves cleanly and isolates exactly one behavior under test,
optionally including exactly one seeded defect so a validator or ingest
function has something specific to catch. It does not cover the full GTFS
specification — only the eight files and fields these workshops use. For
anything else, consult `system/gtfs-reference.md` or the official spec.

## The minimum viable feed

A resolvable feed needs all eight files below, even when several are a
header plus a single row. Leaving one out is the single most common way a
fixture fails referential-integrity checking for a reason that has nothing
to do with the behavior it was built to test.

| File | Required columns |
|---|---|
| `agency.txt` | `agency_id, agency_name, agency_url, agency_timezone` |
| `stops.txt` | `stop_id, stop_name, stop_lat, stop_lon` |
| `routes.txt` | `route_id, agency_id, route_short_name, route_long_name, route_type, route_color, route_text_color` |
| `trips.txt` | `route_id, service_id, trip_id, trip_headsign, direction_id` |
| `stop_times.txt` | `trip_id, arrival_time, departure_time, stop_id, stop_sequence` |
| `calendar.txt` | `service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date` |
| `calendar_dates.txt` | `service_id, date, exception_type` |
| `feed_info.txt` | `feed_publisher_name, feed_publisher_url, feed_lang, feed_start_date, feed_end_date, feed_version` |

This is the same field set `fixtures/demo-feed` uses. Below is a complete,
copyable minimal feed: one agency, two stops, one route, one trip, two stop
times, one calendar entry. `calendar_dates.txt` is header-only — a service
with no exceptions still needs the file present, just with zero data rows.
`feed_info.txt` carries one row whose date window matches the calendar's, so
the feed is not accidentally seeded with the expired-window defect.

`agency.txt`:

```
agency_id,agency_name,agency_url,agency_timezone
AGY,Example Transit Authority,https://example.com/agy,America/Chicago
```

`stops.txt`:

```
stop_id,stop_name,stop_lat,stop_lon
STOP_A,Main St & 1st Ave,41.8785,-87.6298
STOP_B,Main St & 5th Ave,41.8825,-87.6255
```

`routes.txt`:

```
route_id,agency_id,route_short_name,route_long_name,route_type,route_color,route_text_color
R1,AGY,10,Main Street Line,3,10437E,FFFFFF
```

`trips.txt`:

```
route_id,service_id,trip_id,trip_headsign,direction_id
R1,WEEKDAY,T1,Main Street Line,0
```

`stop_times.txt`:

```
trip_id,arrival_time,departure_time,stop_id,stop_sequence
T1,08:00:00,08:00:00,STOP_A,10
T1,08:06:00,08:06:00,STOP_B,20
```

`calendar.txt`:

```
service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
WEEKDAY,1,1,1,1,1,0,0,20260101,20261231
```

`calendar_dates.txt`:

```
service_id,date,exception_type
```

`feed_info.txt`:

```
feed_publisher_name,feed_publisher_url,feed_lang,feed_start_date,feed_end_date,feed_version
Example Transit Authority,https://example.com/agy,en,20260101,20261231,2026-01-01-A
```

Note `stop_sequence` values of `10, 20`, not `1, 2` — a deliberate reminder
that sequence numbers must increase but need not be consecutive. Leave gaps
so a later edit can insert a stop without renumbering the trip.

## Rules that are easy to break

Run this checklist over any feed before calling it done, whether it started
from the template above or from an existing fixture you are extending:

- [ ] Every `trip_id` in `stop_times.txt` exists in `trips.txt`.
- [ ] Every `stop_id` in `stop_times.txt` (and any other file that names one)
      resolves in `stops.txt`.
- [ ] Every `service_id` in `trips.txt` and `calendar_dates.txt` resolves in
      `calendar.txt`, or is defined entirely by `calendar_dates.txt`
      exceptions if it has no `calendar.txt` row.
- [ ] `stop_sequence` strictly increases within each trip (gaps are fine,
      repeats and decreases are not).
- [ ] `arrival_time` never exceeds `departure_time` at the same stop (they
      may be equal).
- [ ] `departure_time` never decreases from one stop to the next along a
      trip, including across the `24:00:00` boundary.
- [ ] Every date (`calendar.txt`, `calendar_dates.txt`, `feed_info.txt`) is
      `YYYYMMDD` with no separators, and is a real calendar date.
- [ ] Every color (`route_color`, `route_text_color`) is six hex digits with
      no leading `#`.

## Seeding a named defect

Add at most one seeded defect per fixture when the fixture's job is to prove
that a single validator check fires in isolation — a feed with two defects
can't tell you which one a validator actually caught. Set that rule aside
when the goal is different: probing for interactions or gaps, or building an
adversarial feed meant to find what a validator misses when several defects
compound. In that case, combine or intensify defects on purpose. Each row
below names the defect, how to introduce it starting from a clean feed, and
what a correct validator should report — use the last column to check your
own validator's output, not just the fixture's.

| Defect | How to seed it | What a correct validator should say |
|---|---|---|
| Past-midnight departure | Give a trip a `stop_times.txt` row with `departure_time` at `24:35:00` or later (`25:05:00` also works), keeping every departure time on that trip non-decreasing up to and including it. | Nothing — this is valid GTFS, not an error. A `24:35:00` departure on service date 2026-09-14 (a Monday) resolves to 2026-09-15T00:35, the following Tuesday. A validator that rejects or wraps it is the thing under test failing, not the fixture. |
| Inverted calendar exception | Pick a `service_id` and a date where the weekday flag already says what you want, then write the `exception_type` that contradicts it instead of confirms it. Example: `WEEKDAY` runs Thursdays (`thursday` = `1`); to represent a holiday closure on Thursday, 2026-11-26, the correct row is `WEEKDAY,20261126,2`. The inverted defect is `WEEKDAY,20261126,1` — a no-op "add" for a day the service already runs, which silently discards the intended closure. | An added-service (`exception_type` `1`) exception on a date the calendar already serves is redundant and almost always a sign the author meant `2`. Flag it, and say which value would make the exception meaningful. |
| Implausible travel speed | These rows are additive: append them only when you want this defect. The minimal feed above stays defect-free without them. Add a second trip so the base trip stays clean — to `trips.txt`: `R1,WEEKDAY,T2,Speed Defect Probe,0`. Add two stops to `stops.txt`: `STOP_FAR1,Market & 3rd,47.6120,-122.3400` and `STOP_FAR2,Airport Station,47.4500,-122.3090`. Add two rows to `stop_times.txt`: `T2,07:00:00,07:00:00,STOP_FAR1,10` and `T2,07:02:00,07:02:00,STOP_FAR2,20`. This is the same geometry `fixtures/demo-feed` uses for trip `T3` — 18.2 km covered in 120 seconds, roughly 546 km/h. | An error naming trip `T2`, stops `STOP_FAR1` and `STOP_FAR2`, and a computed speed in the neighborhood of 500-600 km/h — an implausible-travel-speed finding, for a mode that cannot go that fast. |
| Orphan stop | Add a row to `stops.txt` for a stop that no `stop_times.txt` row references. | A warning that the stop appears in no trip and is unreachable — an unused-stop finding, naming the stop. |
| Null island stop | Set both `stop_lat` and `stop_lon` to `0` for one stop. | An error naming the stop and its coordinates — a null-island-stop finding. This is a distinct defect from an orphan stop even though a single stop can carry both at once, as `fixtures/demo-feed`'s stop `S5` does. |
| Low route color contrast | Set `route_color` and `route_text_color` to a pair too close in luminance to read against each other — `FFFFFF` background with `FFFF00` text is the reference case in `fixtures/demo-feed`'s route `R1`. | A warning naming the route and both color values — a route-color-contrast finding. Both values are individually well-formed hex codes; the defect is contrast, not format. |
| Expired feed window | Set `feed_info.txt`'s `feed_end_date` to a date earlier than the latest `end_date` across `calendar.txt`. `fixtures/demo-feed` seeds this with a `feed_end_date` of 20260731 against calendars running through 20261231. | A warning naming the gap — a feed-window-coverage finding — because the feed claims validity for a shorter span than the service data it actually contains. |

## Before you hand the feed over

Run the checklist above one more time, against the finished feed, not the
template you started from. A fixture whose referential integrity is broken
by accident — a typo'd `stop_id`, a `service_id` that resolves nowhere, a
sequence that repeats a number — teaches nothing, because the failure it
produces is not the failure under test. Whoever consumes this fixture should
see exactly one thing go wrong: the defect you meant to seed, if any, and
nothing else.
