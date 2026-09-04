# Backlog

## How to use this

This is the work you do between sessions. Slices are ordered so each one
leaves the system working and each is completable on its own. Take the next
one, or skip ahead if a session pointed you somewhere specific. Every slice
has an acceptance file that says exactly when it is done.

Budget roughly three to six hours between sessions one and two — that is
slices 2 and 3 — and two to four between sessions two and three. If you have
less time than that, do slice 2 and stop rather than half-finishing three
slices, and tell your facilitator: both later sessions have a path that runs
without your own build behind it.

Nothing past slice 1 requires a deployment. Every acceptance condition from
slice 2 onward is HTTP behaviour a single local process satisfies, and the
contract leaves storage, runtime and language entirely to you. If your cloud
account is the thing standing between you and slice 2, run it locally and
deploy later, or not at all.

## Slices

| Slice | Goal | Acceptance |
|---|---|---|
| 1. Health endpoint | Get something running and reachable, deployed to your cloud or running locally. | [`./acceptance/01-health.md`](./acceptance/01-health.md) |
| 2. Feed ingest | Parse the fixture feed into a normalized store and report what landed. | [`./acceptance/02-ingest.md`](./acceptance/02-ingest.md) |
| 3. Service queries | Which services run on a date, and a departure board. | [`./acceptance/03-query.md`](./acceptance/03-query.md) |
| 4. Validation | The five-rule set and a report. | [`./acceptance/04-validation.md`](./acceptance/04-validation.md) |
| 5. UI | Feed list, validation report, departure board. | [`./acceptance/05-ui.md`](./acceptance/05-ui.md) |
| 6. Feed diff | Compare two versions into a readable service-change report. | [`./acceptance/06-diff.md`](./acceptance/06-diff.md) |

## Where the sessions land you

After workshop 1 you should have slice 1 done and be working on slices 2 and
3. Workshop 2's skills are drawn straight from whatever bit you in slice 3 —
the exception-date and past-midnight traps that are easy to get wrong once
and worth having a convention for the second time. By workshop 3, slices 2
and 3 are behind you, and what remains breaks apart cleanly: five
independent validation rules, a feed diff that only needs ingest, and UI
views whose data already exists once the API serves it. Workshop 3 fans
that work — not whole slices — across parallel agents, one independent
piece per agent, because each piece stands on its own without waiting on a
sibling to finish first. This is why three one-hour sessions add up to one
system instead of three separate toys: each session's technique exists
because of a scar the previous slices left, and by the last session the
system itself is what makes the parallel work possible.
