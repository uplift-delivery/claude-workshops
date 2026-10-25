# Claude workshops

Three one-hour, hands-on sessions on working with LLM coding tools. Across
them you build one small system: the Transit Feed Service, which ingests and
validates public transit schedules ([overview](system/overview.md)).

| Session | Focus |
|---|---|
| [1. Setup and usage](workshops/01-setup-and-usage/README.md) | Prompt, plan, verify. No extra context. |
| [2. Skills and context](workshops/02-skills-and-context/README.md) | `CLAUDE.md`, skills, conventions |
| [3. Parallel agents](workshops/03-parallel-agents/README.md) | Agent teams and parallel threads |

**Start here:** [workshops/README.md](workshops/README.md). It has the 15-minute setup.

Nothing is required between sessions. Bring any language or stack.

## What's here

| Path | Holds |
|---|---|
| `workshops/` | Participant guide (`README.md`) and `facilitator.md` per session |
| `system/features/` | Requirements as Gherkin scenarios |
| `system/` | API contract, GTFS reference, overview |
| `fixtures/` | Two small GTFS feeds with seeded defects, and the answer key |
| `.claude/skills/` | `gtfs-fixture-builder`, the skill session 2 installs |
| `.claude/agents/` | `gtfs-adversary`, an example subagent |
