# Workshops

Three one-hour sessions. Each one teaches one thing and builds the piece of
the system the next session needs. Nothing is required between sessions.

| Session | You learn | You build |
|---|---|---|
| [1. Setup and usage](01-setup-and-usage/README.md) | Drive an agent with no extra context: plan, then verify | Health check, feed ingest |
| [2. Skills and context](02-skills-and-context/README.md) | Give the agent memory: `CLAUDE.md`, skills, conventions | Validation endpoint and its first rule |
| [3. Parallel agents](03-parallel-agents/README.md) | Split work across an agent team or parallel threads | The remaining four validation rules |

## Before session 1 (15 minutes)

1. Install an LLM coding tool and sign in. These guides use Claude Code;
   [other-tools.md](other-tools.md) maps each step to Copilot and Cursor.
2. Create an empty repository for your service and copy in the spec:

   ```sh
   mkdir transit-service && cd transit-service && git init
   cp -r <this-repo>/system <this-repo>/fixtures .
   git add . && git commit -m "Add spec and fixtures"
   ```

3. Pick a language and runtime you are comfortable with. Any stack works.

## Missed a session or didn't finish?

Each session starts with a **Catch up** step: one prompt that builds what the
previous session built. Run it before the session starts.

## Requirements and reference

| File | Use it for |
|---|---|
| [`system/features/`](../system/features/) | Requirements, as Gherkin scenarios. Hand these to the agent. |
| [`system/api-contract.md`](../system/api-contract.md) | Exact request and response shapes |
| [`system/gtfs-reference.md`](../system/gtfs-reference.md) | What the GTFS files and fields mean |
| [`fixtures/ANSWER-KEY.md`](../fixtures/ANSWER-KEY.md) | Correct answers. If your output disagrees, your code is wrong. |

Want more after session 3? See [extras.md](extras.md).
