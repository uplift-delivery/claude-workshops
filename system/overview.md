# System overview

The Transit Feed Service reads a GTFS feed (a transit agency's published
schedule), checks it for defects, and answers questions about the service it
describes. GTFS is a real public standard: <https://gtfs.org>.

## Components

| Component | Does | Feature |
|---|---|---|
| Ingest | Parses a feed into a store and records counts and dates | [02](features/02-ingest.feature) |
| Queries | Services on a date, departure boards | [03](features/03-query.feature) |
| Validation | Runs five rules and writes a report | [04](features/04-validation.feature) |
| UI | Feed list, validation report, departure board | [05](features/05-ui.feature) |
| Diff | Describes changes between two feed versions | [06](features/06-diff.feature) |

All of it sits behind one HTTP API: [`api-contract.md`](api-contract.md) is
the authority on its shape.

## Rules of the build

- Any language, runtime, or cloud. A single local process satisfies every feature.
- No starter code. You and your agent write all of it.
- Out of scope: authentication, realtime feeds, multi-tenancy.
