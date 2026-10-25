Feature: Service queries
  Which services run on a date, and the departure board for a stop.
  Reference: system/gtfs-reference.md "Resolving service on a date",
             fixtures/ANSWER-KEY.md "Services on a date" and "Departure boards"

  Scenario Outline: Services active on a date
    Given demo-feed has been ingested
    When I GET /feeds/{feedId}/services?date=<date>
    Then "serviceIds" is exactly <services>

    Examples:
      | date       | services                | why                                         |
      | 2026-09-14 | NIGHT, WEEKDAY          | ordinary Monday                             |
      | 2026-09-19 | NIGHT, WEEKEND          | ordinary Saturday                           |
      | 2026-07-03 | NIGHT, WEEKEND          | Friday: exceptions remove WEEKDAY, add WEEKEND |
      | 2026-08-08 | NIGHT, WEEKDAY, WEEKEND | Saturday: exception adds WEEKDAY            |

  Scenario: Departure board includes a past-midnight trip
    Given demo-feed has been ingested
    When I GET /feeds/{feedId}/stops/S2/departures?date=2026-09-14
    Then "departures" is, in order:
      | tripId | feedTime | scheduledAt      |
      | T1     | 06:09:00 | 2026-09-14T06:09 |
      | T3     | 07:00:00 | 2026-09-14T07:00 |
      | T4     | 24:52:00 | 2026-09-15T00:52 |
    # 24:52:00 belongs to the 14th's board but happens at 00:52 on the 15th.

  Scenario Outline: Departure board size on other dates
    Given demo-feed has been ingested
    When I GET /feeds/{feedId}/stops/S2/departures?date=<date>
    Then there are <count> departures, matching fixtures/ANSWER-KEY.md

    Examples:
      | date       | count |
      | 2026-07-03 | 2     |
      | 2026-08-08 | 4     |
      | 2026-09-19 | 2     |
