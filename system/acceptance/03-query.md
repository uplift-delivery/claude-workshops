# Slice 03: Query

## Goal

Answer which services run on a date, and produce a departure board for a
stop on a date.

## Preconditions

Slice 02 complete.

## Done when

1. `GET /feeds/{feedId}/services?date=2026-09-14` returns service IDs `NIGHT`
   and `WEEKDAY`.
2. `GET /feeds/{feedId}/services?date=2026-09-19` returns service IDs `NIGHT`
   and `WEEKEND`.
3. `GET /feeds/{feedId}/services?date=2026-07-03` returns service IDs `NIGHT`
   and `WEEKEND`.
4. `GET /feeds/{feedId}/services?date=2026-08-08` returns service IDs
   `NIGHT`, `WEEKDAY`, and `WEEKEND`.
5. `GET /feeds/{feedId}/stops/S2/departures?date=2026-09-14` returns exactly
   three entries, with feed times `06:09:00`, `07:00:00`, and `24:52:00`.
6. In that same response, the `24:52:00` entry's resolved wall-clock instant
   is `2026-09-15T00:52` — the following calendar day, not `2026-09-14`.
7. `GET /feeds/{feedId}/stops/S2/departures?date=2026-08-08` returns exactly
   four entries.

## Traps in this slice

The two exception dates invert if `calendar_dates.txt`'s `exception_type` is
read backwards — `1` meaning "removed" and `2` meaning "added" instead of the
other way around. `2026-07-03` is the date that catches this: a naive weekday
lookup, ignoring the exception or reading it backwards, returns `WEEKDAY`;
the correct answer, per done-condition 3, is `WEEKEND`.

The `24:52:00` departure is dropped entirely by naive time parsing that
rejects or clamps any `HH` past `23`, or it is misplaced onto the queried
date (`2026-09-14T00:52` instead of `2026-09-15T00:52`) by code that resolves
the offset but forgets to roll the calendar day over. Either failure mode is
wrong per done-conditions 5 and 6.

## Verify against

[`fixtures/ANSWER-KEY.md`](../../fixtures/ANSWER-KEY.md#services-on-a-date)'s
"Services on a date" section, and its
[Departure boards section](../../fixtures/ANSWER-KEY.md#departure-boards),
for the full set of dates and entries these done-conditions draw from.
