# System overview

This document is the end-state vision for the system these workshops build.
It does not change from session to session; what changes is how much of it
exists. Read it once at the start and return to it whenever you need to
remember what a piece you're building is for.

## What we are building

The Transit Feed Service is a system built around GTFS, the General Transit
Feed Specification. It ingests a GTFS feed, validates that feed against a
set of specification rules, answers questions about the service the feed
describes, and exposes a browser UI over all of it. A transit agency
publishes a feed; this system tells you whether the feed is sound and what
service it describes on a given day.

The components below are described as functions because that is how their
boundaries fall, not because anything here requires a serverless
deployment. Every acceptance condition in this repository is satisfied by a
single local process if that is what you want to run.

## Why GTFS

GTFS is a public specification, not something invented for this exercise.
The rules your validation function enforces are real rules that real transit
agencies violate in real feeds, and the questions your query paths answer are
questions a transit planner actually asks. Public feeds are widely available
if you want more material to test against, and a small fixture feed ships in
this repository so every exercise has a fixed, known input to build and check
against.

## Components

The system has four components. Each has one responsibility and a defined
boundary; nothing here dictates how you build any of them.

### Ingest function

The ingest function reads a GTFS feed from object storage, parses it, and
writes a normalized representation to a data store. It records what it
ingested — counts, dates, and enough metadata for the rest of the system to
know a feed exists and what it contains.

### Validation function

Runs the rule set against an already-ingested feed and writes a validation
report. Each finding in that report carries a severity, so the report can be
sorted and read in order of what matters most.

### HTTP API

Exposes feeds, validation reports, and service queries over HTTP. It is the
single point of contact between the ingest and validation functions and
everything downstream, including the UI. `api-contract.md` is the authority
on its exact shape; nothing in this document overrides it.

### UI

A browser interface that lists feeds, renders a validation report, and shows
a departure board for a stop on a date. It calls the HTTP API for everything;
it holds no logic of its own about feeds, validation, or schedules.

## How you build it

The technology choice is yours — language, runtime, cloud, storage, all of
it. This repository defines contracts and observable behavior: what an
endpoint returns, what a validation report contains, what a departure board
must show. It does not define how you produce those outcomes. Treat the
contract as the specification. Reading a specification and building
something that satisfies it, rather than being handed an implementation to
extend, is also the practice these workshops are teaching you to do well
with an LLM coding tool at your side.

## Out of scope

The following are explicitly not part of this system, in any workshop:

- Authentication and authorization. No endpoint checks who is calling it.
- Realtime feeds (GTFS-Realtime). Everything here is static, published-in-
  advance schedule data.
- Multi-tenancy. There is one feed store, not one per organization or user.
- Any starter implementation. Nothing in this repository runs; you build
  every line of the system yourself, with the tools these workshops teach.

## Where to start

The ordered list of work is in [`backlog.md`](backlog.md). If this is your
first session, start with
[the workshop 1 participant guide](../workshops/01-foundations/participant.md)
instead — it will bring you back here at the right moment.
