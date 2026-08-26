# API contract

This contract is the specification. Any implementation, on any cloud, in any
language, that satisfies it is correct. It defines every HTTP endpoint the
ingest function, validation function, HTTP API, and UI communicate through.
Where this document and any other document disagree about the HTTP API's
behavior, this document wins.

There is no authentication or authorization on any endpoint. This is
deliberate and out of scope for these workshops, not an oversight; do not add
it.

## Conventions

- All request and response bodies are JSON.
- Dates in query parameters and response fields use `YYYY-MM-DD`.
- Feed times — times as they appear in `stop_times.txt` — are returned
  exactly as given in the feed, as `HH:MM:SS`, and may exceed `23` in the
  hour position. See [`gtfs-reference.md`](gtfs-reference.md) for why: a feed
  time is an offset from midnight on a trip's service date, not a wall-clock
  time, and hours past 24 are valid and expected.
- A `feedTime` at or after `24:00:00` belongs to the queried service date —
  the date the trip started on — and its resolved `scheduledAt` falls on the
  following calendar day. `24:00:00` itself is included in this rule, not
  excluded from it: the comparison is against the full time value, not just
  whether the hour digit is strictly greater than `24`.
- Every response field that carries a feed time also carries the resolved
  wall-clock instant that feed time and its service date resolve to, as an
  ISO 8601 string with no UTC offset (for example `2026-09-15T00:52`). The
  resolved instant is in the feed's own timezone (`agency_timezone`), not a
  fixed offset, so no offset is appended.
- Every error response shares one shape: an object with `error` — a short,
  machine-readable code — and `message` — a human-readable description.
  Example: `{ "error": "feed_not_found", "message": "No feed with id abc123" }`.
- Path parameters in this document are written in `{curlyBraces}`; substitute
  the real value when calling the endpoint.

## Endpoints

### `GET /health`

Liveness check. Takes no parameters.

- **200** — `{ "status": "ok" }`

### `POST /feeds`

Registers a new feed for ingestion. Ingestion happens asynchronously; this
endpoint only records the request and returns immediately.

- **Request body** — a feed reference: a name and a location in object
  storage, e.g. `{ "name": "demo-feed", "location": "demo-bucket/demo-feed/" }`.
  The location's exact scheme is left to the implementation; only its
  presence is required by this contract.
- **202** — `{ "feedId": "...", "status": "pending" }`. Ingestion has been
  accepted but has not necessarily completed.
- **400** — the feed reference is missing or malformed.

### `GET /feeds`

Lists every feed known to the system, most recently ingested first.

- **200** — a list of `{ feedId, name, status, ingestedAt }`. `status` is
  one of `pending`, `ingested`, `failed`.

### `GET /feeds/{feedId}`

Returns the summary of one ingested feed.

- **Path parameters** — `feedId`.
- **200** — the feed summary: counts of agencies, stops, routes, trips, and
  stop times, plus `feedStartDate` and `feedEndDate` (from `feed_info.txt`,
  see [`gtfs-reference.md`](gtfs-reference.md)). Shape:
  `{ feedId, name, status, ingestedAt, counts: { agencies, stops, routes,
  trips, stopTimes }, feedStartDate, feedEndDate }`.
- **404** — no feed with that `feedId` exists.

### `POST /feeds/{feedId}/validation`

Runs the validation rule set against an already-ingested feed. Validation
happens asynchronously; this endpoint only records the request.

- **Path parameters** — `feedId`.
- **202** — `{ "reportId": "...", "status": "pending" }`.
- **404** — no feed with that `feedId` exists.

### `GET /feeds/{feedId}/validation`

Returns the most recent validation report for a feed.

- **Path parameters** — `feedId`.
- **200** —
  `{ reportId, status, findings: [ { rule, severity, entityType, entityId,
  message } ] }`. `severity` is one of `error`, `warning`, `info`. `rule` is
  the slug of the rule that produced the finding (for example
  `implausible-travel-speed`).

  `entityType` and `entityId` identify the single primary record the finding
  is attached to — `entityType` is one of `stop`, `route`, `trip`, or `feed`,
  and `entityId` is that record's own identifier. A finding that concerns a
  relationship between two or more records — for example
  `implausible-travel-speed`, which concerns a trip's travel between a pair
  of consecutive stops — is attached to the trip (`entityType: "trip"`,
  `entityId` the trip's ID); the specific stops involved are named in
  `message`, not in separate fields. This mapping is fixed for all five
  rules:

  | Rule | `entityType` | `entityId` |
  |---|---|---|
  | `implausible-travel-speed` | `trip` | the trip's ID |
  | `null-island-stop` | `stop` | the stop's ID |
  | `unused-stop` | `stop` | the stop's ID |
  | `route-color-contrast` | `route` | the route's ID |
  | `feed-window-coverage` | `feed` | the `feedId` the report is for |

  Example finding for `implausible-travel-speed`:

  ```json
  {
    "rule": "implausible-travel-speed",
    "severity": "error",
    "entityType": "trip",
    "entityId": "T3",
    "message": "18.2 km between stops S2 and S4 in 120 s (546 km/h)"
  }
  ```
- **404** — no feed with that `feedId` exists, or a feed exists but no
  validation report has been produced for it yet.

### `GET /feeds/{feedId}/services?date=YYYY-MM-DD`

Returns the service IDs active on a given calendar date, resolved per the
algorithm in [`gtfs-reference.md`](gtfs-reference.md)'s "Resolving service on
a date" section (`calendar.txt` weekday and date range, overridden by any
`calendar_dates.txt` exception for that exact date).

- **Path parameters** — `feedId`.
- **Query parameters** — `date`, required, `YYYY-MM-DD`.
- **200** — `{ date, serviceIds: [...] }`.
- **400** — `date` is missing or not a well-formed `YYYY-MM-DD` date.
- **404** — no feed with that `feedId` exists.

### `GET /feeds/{feedId}/stops/{stopId}/departures?date=YYYY-MM-DD`

Returns the departure board for one stop on one service date: every
`stop_times` row at that stop belonging to a trip whose service runs on
`date`, ordered by feed time.

- **Path parameters** — `feedId`, `stopId`.
- **Query parameters** — `date`, required, `YYYY-MM-DD`.
- **200** —
  `{ date, stopId, departures: [ { tripId, routeId, headsign, feedTime,
  scheduledAt } ] }`. `feedTime` is the raw `HH:MM:SS` value from
  `stop_times.txt`; `scheduledAt` is that feed time resolved against `date`
  into a wall-clock instant, per the Conventions section above.

  A departure whose `feedTime` is at or after `24:00:00` (comparing the full
  time value, so `24:00:00` itself qualifies) belongs to the queried service
  date — the trip started on `date` — and its `scheduledAt` resolves to the
  following calendar day. Such a departure must be included in the response
  for `date`; it must not be dropped, and it must not be re-attributed to
  the following date's own board.
- **400** — `date` is missing or not a well-formed `YYYY-MM-DD` date.
- **404** — no feed with that `feedId` exists, or the feed has no stop with
  that `stopId`.

### `GET /feeds/{feedId}/diff?against={otherFeedId}`

Compares two ingested feeds and reports what changed between them.

- **Path parameters** — `feedId`, the "from" feed.
- **Query parameters** — `against`, required, the "to" feed's `feedId`.
- **200** —
  `{ from, to, changes: [ { changeType, entityType, entityId, detail } ] }`.
  `changeType` is one of `added`, `removed`, `modified`. `from` and `to` are
  the two feed IDs compared. `detail` is a human-readable description of
  what changed; its exact shape is left to the implementation.
- **404** — `feedId` or `against` names a feed that does not exist.

## Worked example

The departure board for stop `S2` in `demo-feed` on `2026-09-14` (a Monday).
[`gtfs-reference.md`](gtfs-reference.md) and the answer key agree: on this
date the active services are `WEEKDAY` and `NIGHT`, so trips `T1` (route
`R1`, service `WEEKDAY`) and `T4` (route `R3`, service `NIGHT`) both run at
this stop, alongside `T3` (route `R2`, service `WEEKDAY`).

Request:

```
GET /feeds/{feedId}/stops/S2/departures?date=2026-09-14
```

Response:

```json
{
  "date": "2026-09-14",
  "stopId": "S2",
  "departures": [
    {
      "tripId": "T1",
      "routeId": "R1",
      "headsign": "Riverside Park",
      "feedTime": "06:09:00",
      "scheduledAt": "2026-09-14T06:09"
    },
    {
      "tripId": "T3",
      "routeId": "R2",
      "headsign": "Airport Station",
      "feedTime": "07:00:00",
      "scheduledAt": "2026-09-14T07:00"
    },
    {
      "tripId": "T4",
      "routeId": "R3",
      "headsign": "Harbor Terminal",
      "feedTime": "24:52:00",
      "scheduledAt": "2026-09-15T00:52"
    }
  ]
}
```

The third departure has a `feedTime` at or after `24:00:00` and resolves to
the next calendar day, `2026-09-15`, while `date` remains `2026-09-14` — the
service date the trip belongs to. This is exactly the case
[`gtfs-reference.md`](gtfs-reference.md) describes and must not be dropped or
misdated.

This is one of four departure boards for stop `S2` verified in the answer
key; see [`fixtures/ANSWER-KEY.md`'s Departure boards
section](../fixtures/ANSWER-KEY.md#departure-boards) for the full set,
including the other three calendar dates.
