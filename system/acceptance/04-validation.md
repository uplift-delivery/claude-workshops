# Slice 04: Validation

## Goal

Run a rule set against an ingested feed and produce a validation report.

## Preconditions

Slice 02 complete.

## Done when

1. `POST /feeds/{feedId}/validation` returns status 202.
2. After validation completes, `GET /feeds/{feedId}/validation` returns a
   report whose findings are exactly the five the answer key lists for
   `demo-feed` — no more and no fewer. A report with extra findings is
   over-flagging; a report with fewer is under-flagging. Both are wrong.
   `demo-feed-v2` has its own set of five in the same section of the
   answer key; they are not the same five.
3. Each finding carries the rule's name, a severity, and the entity it
   concerns.

## The rule set

| Rule | Severity | Detects |
|---|---|---|
| `implausible-travel-speed` | error | A hop between two consecutive stops on a trip implying a speed no vehicle of that route's type could achieve. |
| `null-island-stop` | error | A stop whose latitude and longitude are both `0`. |
| `unused-stop` | warning | A stop referenced by no `stop_times` row. |
| `route-color-contrast` | warning | Insufficient contrast between a route's background color and its text color. |
| `feed-window-coverage` | warning | The feed's declared date window does not cover the service dates in its calendars. |

## Design note

Each rule should be independently addable — running one rule's detection
should not require touching the other four, and adding a sixth rule later
should not require reshaping the ones already in place. How you structure
that is your call. The shape you choose here is what workshop 2 encodes as
a convention skill, and what workshop 3's parallel agents extend when each
agent is handed one new rule to add on its own.

## Verify against

[`fixtures/ANSWER-KEY.md`](../../fixtures/ANSWER-KEY.md#validation-findings)'s
"Validation findings" section, for the exact five findings, their
locations, and their details.
