# Slice 06: Diff

## Goal

Compare two ingested feed versions and report the service changes in terms
a transit planner would recognize, not in terms of which file rows changed.

## Preconditions

Slice 02 complete; both `fixtures/demo-feed` and `fixtures/demo-feed-v2`
ingested.

## Done when

`GET /feeds/{feedId}/diff?against={otherFeedId}`, called with `demo-feed` as
`feedId` and `demo-feed-v2` as `against`, returns changes covering all of:

1. Route `R2` is removed.
2. Trip `T3` is removed.
3. Trip `T2` is removed, leaving route `R1` with no weekend service.
4. Stop `S3` is relocated by roughly 500 m (a reported displacement of
   400-650 m matches; anything outside that range does not).
5. Trip `T1` shifts five minutes later at every stop it serves.
6. The `2026-08-08` added-service exception is removed.
7. The feed version and date window change.
8. Each change names the entity it concerns and describes the change in one
   sentence.

## Notes

The value here is the rendering, not the detection. "Route 1 no longer runs
on weekends" is a useful finding. "`trips.txt` row count decreased by 2" is
not — it is true, but it tells a transit planner nothing they can act on.
Detecting that rows changed is the easy half of this slice; describing what
that change means for riders and schedules is the half that counts.

## Verify against

[`fixtures/ANSWER-KEY.md`](../../fixtures/ANSWER-KEY.md#feed-diff)'s "Feed
diff" section, for the complete list of expected changes.
