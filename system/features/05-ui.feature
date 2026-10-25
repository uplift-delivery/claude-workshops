Feature: Browser UI
  A feed list, a validation report, and a departure board over the API.
  No login. Styling is not assessed.

  Scenario: Feed list shows every feed
    Given demo-feed and demo-feed-v2 have been ingested
    When I open the feed list
    Then I see both feeds, each with its status and ingest time

  Scenario: Validation report lists errors before warnings
    Given demo-feed has been validated
    When I select demo-feed in the feed list
    Then I see its findings grouped by severity, errors first
    And each finding names the entity it concerns

  Scenario: Departure board labels a past-midnight trip with its real date
    Given demo-feed has been ingested
    When I request the departure board for stop S2 on 2026-09-14
    Then I see exactly these entries:
      | feedTime | tripId | label                   |
      | 06:09:00 | T1     | 2026-09-14              |
      | 07:00:00 | T3     | 2026-09-14              |
      | 24:52:00 | T4     | 2026-09-15 (next day)   |
    # A reader must not mistake 24:52 for 00:52 on the 14th.
