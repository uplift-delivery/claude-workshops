Feature: Feed diff
  Compare two feed versions and describe changes the way a transit planner would.
  "Route R1 no longer runs on weekends" is useful. "trips.txt lost 2 rows" is not.
  Reference: fixtures/ANSWER-KEY.md "Feed diff"

  Scenario: Diff describes every service change in one sentence each
    Given demo-feed and demo-feed-v2 have been ingested
    When I GET /feeds/{demo-feed id}/diff?against={demo-feed-v2 id}
    Then "changes" covers all of:
      | entity                    | change                                     |
      | route R2                  | removed                                    |
      | trip T3                   | removed                                    |
      | trip T2                   | removed; route R1 has no weekend service   |
      | stop S3                   | moved 400 to 650 m                         |
      | trip T1                   | five minutes later at every stop           |
      | exception 2026-08-08      | added WEEKDAY service removed              |
      | feed                      | version and date window changed            |
    And each change names its entity and describes it in one sentence
