This is the same transit agency's feed one schedule pick later, generated
for the next quarter. It is the comparison target for slice 6's feed diff:
route `R2` and its trip are gone, route `R1` loses its weekend trip, stop
`S3` moves, trip `T1` shifts five minutes later, and the declared feed
window moves from 20260601-20260731 to 20260901-20261231.

Like `demo-feed`, this feed carries deliberate defects and they must not be
"fixed." They are not the same defects. Removing route `R2` left stop `S4`
served by no trip, so this feed has two unused stops rather than one. The
impossible-speed hop went with trip `T3` and no longer exists here. And the
declared feed window now starts after the calendars begin, rather than
ending before they do.

See [../ANSWER-KEY.md](../ANSWER-KEY.md#validation-findings) for the
expected finding set for both feeds, and
[../ANSWER-KEY.md](../ANSWER-KEY.md#feed-diff) for the full list of changes
between them.
