This is a hand-built GTFS feed small enough to read by eye. It is
deliberately seeded with defects to serve as a teaching fixture. The defects
are intentional and must not be "fixed."

Five kinds of defect are seeded:

- A stop at Null Island — latitude and longitude both zero.
- A stop served by no trip, referenced by no `stop_times` row.
- A hop between two consecutive stops on a trip at an impossible speed.
- A route whose color and text color are too close in luminance to read
  against each other.
- A declared feed window that does not cover the service dates the calendars
  actually contain.

See [../ANSWER-KEY.md](../ANSWER-KEY.md#validation-findings) for which entity
carries each defect and what a correct validator reports for it.
