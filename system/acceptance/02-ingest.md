# Slice 02: Ingest

## Goal

Parse `fixtures/demo-feed` into a normalized store and report what was
ingested.

## Preconditions

Slice 01 complete.

## Done when

1. `POST /feeds` with a reference to `fixtures/demo-feed` returns status 202
   with a body containing a `feedId`.
2. After ingestion completes, `GET /feeds` lists a feed with that `feedId`.
3. `GET /feeds/{feedId}` returns counts matching exactly:
   - 1 agency
   - 6 stops
   - 3 routes
   - 4 trips
   - 12 stop times
4. The same response's `feedStartDate` is `2026-06-01` and `feedEndDate` is
   `2026-07-31`.

## Traps in this slice

`stop_times.txt` values may exceed `24:00:00`. Parsing them as ordinary clock
times — rejecting the value, wrapping it into a 24-hour range, or truncating
the hour — fails; see
[`gtfs-reference.md`'s `stop_times.txt` section](../gtfs-reference.md#stop_timestxt)
for why this is expected, not a defect.

`feed_info.txt` stores dates as `YYYYMMDD` (for example `20260601`), while
the HTTP API returns `YYYY-MM-DD` (`2026-06-01`). Passing the feed's raw date
string straight through produces a value that fails done-condition 4.

## Notes

Do not "fix" the fixture's defects during ingest. Some rows in `demo-feed`
are deliberately wrong — an out-of-range stop location, an unused stop, a
route with poor color contrast — and slice 04's validation function is the
part of this system that detects them. Ingest records the feed as given.
