Feature: Feed validation
  Run a rule set against an ingested feed and report findings.
  Each rule is added on its own: adding one never edits another.
  Reference: system/api-contract.md (finding shape), fixtures/ANSWER-KEY.md "Validation findings"

  | Rule                     | Severity | Detects                                                |
  | implausible-travel-speed | error    | a hop between consecutive stops no vehicle could make  |
  | null-island-stop         | error    | a stop at latitude 0, longitude 0                      |
  | unused-stop              | warning  | a stop referenced by no stop_times row                 |
  | route-color-contrast     | warning  | route color and text color too close to read           |
  | feed-window-coverage     | warning  | the feed window does not cover the calendars' dates    |

  Scenario: Validation run is accepted
    Given demo-feed has been ingested
    When I POST /feeds/{feedId}/validation
    Then the response status is 202

  Scenario Outline: Each rule flags exactly its expected entities
    Given <feed> has been ingested and validated
    When I GET /feeds/{feedId}/validation
    Then the findings from rule <rule> are exactly <expected>
    And each has severity <severity>

    Examples: demo-feed
      | feed      | rule                     | severity | expected               |
      | demo-feed | implausible-travel-speed | error    | trip T3 (S2 to S4)     |
      | demo-feed | null-island-stop         | error    | stop S5                |
      | demo-feed | unused-stop              | warning  | stop S5                |
      | demo-feed | route-color-contrast     | warning  | route R1               |
      | demo-feed | feed-window-coverage     | warning  | the feed (ends early)  |

    Examples: demo-feed-v2
      | feed         | rule                     | severity | expected                 |
      | demo-feed-v2 | implausible-travel-speed | error    | nothing                  |
      | demo-feed-v2 | null-island-stop         | error    | stop S5                  |
      | demo-feed-v2 | unused-stop              | warning  | stops S4 and S5          |
      | demo-feed-v2 | route-color-contrast     | warning  | route R1                 |
      | demo-feed-v2 | feed-window-coverage     | warning  | the feed (starts late)   |

  Scenario: Report has no unexplained findings
    Given demo-feed has been ingested and validated with all five rules
    When I GET /feeds/{feedId}/validation
    Then there are exactly 5 findings
    # More than 5 usually means two rules report the same defect.
