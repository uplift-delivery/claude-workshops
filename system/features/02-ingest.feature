Feature: Feed ingest
  Parse a GTFS feed into a store and report what landed.
  Ingest records the feed as given. It never "fixes" the seeded defects.
  Reference: system/api-contract.md, system/gtfs-reference.md

  Scenario: Feed submission is accepted
    Given the service is running
    When I POST /feeds with {"name": "demo-feed", "location": "fixtures/demo-feed"}
    Then the response status is 202
    And the body contains a "feedId" and "status": "pending"

  Scenario: Ingested feed is listed
    Given demo-feed has been submitted and ingestion has finished
    When I GET /feeds
    Then the list contains that feedId with status "ingested"

  Scenario: Ingested feed reports its record counts
    Given demo-feed has been ingested
    When I GET /feeds/{feedId}
    Then "counts" is:
      | agencies | stops | routes | trips | stopTimes |
      | 1        | 6     | 3      | 4     | 12        |
    # One stop time is 24:52:00. Rejecting hours past 23 gives 11.

  Scenario: Feed window dates are returned in ISO format
    Given demo-feed has been ingested
    When I GET /feeds/{feedId}
    Then "feedStartDate" is "2026-06-01"
    And "feedEndDate" is "2026-07-31"
    # feed_info.txt stores 20260601. Passing it through unchanged fails.
