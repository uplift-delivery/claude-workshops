# GTFS reference

GTFS (General Transit Feed Specification) defines a set of comma-separated
files that together describe a transit agency's routes, stops, and schedule.
This document is a trimmed excerpt: it covers only the files and fields these
workshops touch, with the exact meaning you need to ingest, validate, and
query the fixture feed correctly. It is not the full specification. For every
file, field, and enum value not listed here, consult the official
specification: https://gtfs.org/documentation/schedule/reference/

Each file below is a table of rows; each row is a single record. A GTFS feed
is the whole set of files distributed together as one unit — the thing the
ingest function reads and the validation function checks.

## `agency.txt`

One row per transit agency operating the service described by the feed.

| Field | Required | Type | Meaning |
|---|---|---|---|
| `agency_id` | Conditionally required | string | Unique identifier for the agency. Required if the feed contains more than one agency; otherwise optional. |
| `agency_name` | Required | string | The agency's full, human-readable name. |
| `agency_url` | Required | string (URL) | The agency's public website. |
| `agency_timezone` | Required | string (IANA timezone) | The timezone this feed's times are interpreted in, e.g. `America/New_York`. |

`agency_timezone` governs interpretation of every time value in the feed. A
`stop_times.txt` value of `08:15:00` means 08:15 in `agency_timezone`, not in
whatever timezone the reader happens to be in.

## `stops.txt`

One row per physical location where vehicles pick up or drop off riders.

| Field | Required | Type | Meaning |
|---|---|---|---|
| `stop_id` | Required | string | Unique identifier for the stop. |
| `stop_name` | Required | string | Human-readable name shown to riders. |
| `stop_lat` | Required | decimal | Latitude in degrees, WGS84. |
| `stop_lon` | Required | decimal | Longitude in degrees, WGS84. |

## `routes.txt`

One row per route: a named, advertised service a rider can identify, such as
"Route 12" or "Blue Line."

| Field | Required | Type | Meaning |
|---|---|---|---|
| `route_id` | Required | string | Unique identifier for the route. |
| `agency_id` | Conditionally required | string | Which agency operates this route. Required under the same condition as `agency.txt`'s `agency_id`. |
| `route_short_name` | Conditionally required | string | Short rider-facing name, e.g. `12`. Required if `route_long_name` is empty. |
| `route_long_name` | Conditionally required | string | Full rider-facing name, e.g. `Downtown - Airport`. Required if `route_short_name` is empty. |
| `route_type` | Required | integer (enum) | The mode of travel. See enum below. |
| `route_color` | Optional | string (hex color) | Background color for route branding. |
| `route_text_color` | Optional | string (hex color) | Text color used against `route_color`. |

`route_type` values used in this repository:

| Value | Mode |
|---|---|
| 0 | Tram |
| 1 | Subway |
| 2 | Rail |
| 3 | Bus |
| 4 | Ferry |

`route_color` and `route_text_color` are six-digit hex color codes with no
leading `#` — `FFFFFF`, not `#FFFFFF`. The pair must have sufficient contrast
to be legible; a light color on a light background, or a dark color on a dark
background, is a defect even though both values are individually well-formed.

## `trips.txt`

One row per scheduled trip: a single vehicle's run over a route on the
service pattern named by `service_id`.

| Field | Required | Type | Meaning |
|---|---|---|---|
| `route_id` | Required | string | The route this trip belongs to. References `routes.txt`. |
| `service_id` | Required | string | The service pattern that determines which dates this trip runs on. References `calendar.txt` and/or `calendar_dates.txt`. |
| `trip_id` | Required | string | Unique identifier for the trip. |
| `trip_headsign` | Optional | string | Text shown to riders describing the trip's destination or direction. |
| `direction_id` | Optional | integer (0 or 1) | Distinguishes the two directions of travel on a bidirectional route. Has no fixed meaning (neither value means "outbound" specifically) beyond separating one direction from the other within a route. |

## `stop_times.txt`

One row per stop visited by a trip, in order. This is the file that turns a
trip into an actual schedule.

| Field | Required | Type | Meaning |
|---|---|---|---|
| `trip_id` | Required | string | The trip this stop visit belongs to. References `trips.txt`. |
| `arrival_time` | Required | time (`HH:MM:SS`) | When the vehicle arrives at this stop. |
| `departure_time` | Required | time (`HH:MM:SS`) | When the vehicle leaves this stop. |
| `stop_id` | Required | string | The stop being visited. References `stops.txt`. |
| `stop_sequence` | Required | non-negative integer | Order of this stop within the trip. |

**Read this section carefully; it is the most important explanation in this
document.**

`arrival_time` and `departure_time` are **not** wall-clock times tied to a
calendar date. They are `HH:MM:SS` offsets measured from noon minus twelve
hours — effectively midnight — **on the trip's service date**, the date on
which the trip's `service_id` says it runs. This distinction matters because:

- **`HH` may exceed 23.** GTFS allows times past 24:00:00 specifically so a
  trip that starts before midnight and continues past it can be represented
  as one continuous, increasing sequence of times, all attributed to the
  single service date the trip started on. Do not reject or wrap these
  values; they are valid and expected.
- **A departure of `25:05:00` on service date 2026-09-14 (a Monday) occurs at
  01:05 on 2026-09-15 (the following Tuesday), in wall-clock terms.** To
  convert a `stop_times.txt` value to an actual instant, take the trip's
  service date, add the `HH:MM:SS` offset, and let the hours roll over into
  following calendar dates as needed. This is the single detail every part of
  this system that reads times — ingestion, validation, and the departure
  board in the UI — must get right.

Two structural rules complete the picture:

- **`stop_sequence` increases along the trip but need not be consecutive.**
  `10, 20, 30` is as valid as `1, 2, 3`; do not assume a step of exactly one,
  and do not treat gaps as an error.
- **`arrival_time` is never later than `departure_time` at the same stop.**
  A vehicle cannot leave a stop before it arrives at it. The two may be equal
  when a stop has no dwell time.

## `calendar.txt`

One row per named weekly service pattern (`service_id`), stating which
weekdays it runs on and over what date range.

| Field | Required | Type | Meaning |
|---|---|---|---|
| `service_id` | Required | string | Unique identifier for this service pattern. Referenced by `trips.txt` and `calendar_dates.txt`. |
| `monday` | Required | integer (0 or 1) | Whether this service runs on Mondays. |
| `tuesday` | Required | integer (0 or 1) | Whether this service runs on Tuesdays. |
| `wednesday` | Required | integer (0 or 1) | Whether this service runs on Wednesdays. |
| `thursday` | Required | integer (0 or 1) | Whether this service runs on Thursdays. |
| `friday` | Required | integer (0 or 1) | Whether this service runs on Fridays. |
| `saturday` | Required | integer (0 or 1) | Whether this service runs on Saturdays. |
| `sunday` | Required | integer (0 or 1) | Whether this service runs on Sundays. |
| `start_date` | Required | date (`YYYYMMDD`) | First date this service pattern is in effect. |
| `end_date` | Required | date (`YYYYMMDD`) | Last date this service pattern is in effect (inclusive). |

Each weekday flag is `1` if the service runs on that weekday, `0` if it does
not. For example, a service_id of `weekday` with `monday` through `friday` set
to `1`, `saturday` and `sunday` set to `0`, `start_date` `20260101`, and
`end_date` `20261231` runs every Monday through Friday in calendar year 2026,
and does not run on any Saturday or Sunday in that range — before
`calendar_dates.txt` exceptions are applied.

## `calendar_dates.txt`

One row per date-specific exception to a `service_id`'s pattern from
`calendar.txt`. This file can also define a service pattern entirely made of
exceptions, with no corresponding row in `calendar.txt` at all.

| Field | Required | Type | Meaning |
|---|---|---|---|
| `service_id` | Required | string | The service pattern this exception applies to. |
| `date` | Required | date (`YYYYMMDD`) | The single date the exception applies to. |
| `exception_type` | Required | integer (1 or 2) | Whether service is added or removed on this date. See below. |

**This is the single most commonly reversed rule in this file. State it to
yourself plainly: `exception_type` `1` adds service on that date;
`exception_type` `2` removes it.**

- `exception_type` `1` — this service runs on `date`, even if `calendar.txt`
  says it normally would not (or has no row at all for this `service_id`).
  Example: `service_id` `weekday` does not run on Saturdays per `calendar.txt`,
  but a row of `weekday, 20261128, 1` adds it for Saturday, 2026-11-28 — a
  special-event service day.
- `exception_type` `2` — this service does **not** run on `date`, even if
  `calendar.txt` says it normally would. Example: `service_id` `weekday`
  normally runs every weekday, but a row of `weekday, 20261126, 2` removes it
  for Thursday, 2026-11-26, a holiday.

Exceptions always override the weekday flags in `calendar.txt` for the exact
date named. They never apply to any other date, and they do not shift or
repeat.

## `feed_info.txt`

At most one row, describing the feed itself rather than the service it
contains.

| Field | Required | Type | Meaning |
|---|---|---|---|
| `feed_publisher_name` | Required | string | Name of the organization that publishes this feed. |
| `feed_publisher_url` | Required | string (URL) | Website of the feed publisher. |
| `feed_lang` | Required | string (language code) | Default language of text in this feed, e.g. `en`. |
| `feed_start_date` | Optional | date (`YYYYMMDD`) | First date the feed's service data is valid for. |
| `feed_end_date` | Optional | date (`YYYYMMDD`) | Last date the feed's service data is valid for. |
| `feed_version` | Optional | string | Publisher-defined version string for this feed, useful for tracking which feed a report was generated from. |

`feed_start_date` and `feed_end_date` are declarative metadata about the
feed, not a filter on queries. Whether a service runs on a date is decided by
`calendar.txt` and `calendar_dates.txt` alone, using the algorithm below; a
date outside the `feed_info.txt` window is still answered from the calendars,
and answered normally. A window that fails to cover the dates the calendars
actually serve is not a query problem — it is precisely what the
`feed-window-coverage` validation rule exists to report.

## Resolving service on a date

Every query that asks "what runs on date X" — including the departure board
the UI shows for a stop — answers it with the same algorithm:

A service (`service_id`) runs on a given date if the date falls within that
service's `start_date`–`end_date` range in `calendar.txt` **and** the flag for
that date's weekday is `1`, **unless** `calendar_dates.txt` contains a row for
that same `service_id` and date, in which case the exception wins outright:
`exception_type` `1` forces the service on for that date, and `exception_type`
`2` forces it off, regardless of what the weekday flag or the date range say.
A `service_id` with no row in `calendar.txt` runs only on the dates that an
`exception_type` `1` row in `calendar_dates.txt` explicitly adds for it.

A trip runs on a date whenever its `service_id` runs on that date. Once you
know the date a trip runs on, `stop_times.txt` tells you exactly when, using
the offset-from-midnight rule described above — including any time past
`24:00:00` that rolls into the next calendar date.
