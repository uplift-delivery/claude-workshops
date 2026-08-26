# Slice 01: Health

## Goal

A running, reachable HTTP endpoint that reports the service is alive,
deployed to your cloud or running locally.

## Preconditions

None. This is the first slice.

## Done when

1. Requesting `GET /health` returns status 200.
2. The response body is exactly `{ "status": "ok" }`.
3. You reached it over HTTP, from outside the process that serves it (a
   separate terminal, browser tab, or HTTP client — not a unit test calling
   a function directly).
4. You can state the URL you hit out loud.

## Notes

The point is a reachable endpoint, not a complete architecture. Resist the
urge to scaffold the whole service here — routing for endpoints that don't
exist yet, a data layer with nothing to store, deployment automation for
slices you haven't built. Get one endpoint answering, over the network, and
stop.
