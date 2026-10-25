# Session 2 facilitator guide

Read the [participant guide](README.md) first.

**The one lesson:** always-true facts go in `CLAUDE.md`; task knowledge goes
in a skill, and a skill only fires if its `description` says when to use it.

## Timing

| Min | What |
|---|---|
| 0–5 | Ask: what did you re-explain to your agent last session? That is skill material. |
| 5–15 | Step 1, `CLAUDE.md`. |
| 15–20 | Step 2. **Demo live first:** ask for the null-island fixture with no skill, then with it. Compare against the skill's checklist. |
| 20–50 | Step 3, convention skill. |
| 50–60 | Run three or four fresh-session tests on screen, then debrief. |

## Behind on the build?

Anyone without ingest pairs with a neighbour for step 3 and writes the skill
against the neighbour's code. Steps 1 and 2 need no prior build.

## Let it happen

- A `description` that names the skill ("Validation helper") instead of when
  to use it. It won't fire. That is the lesson.
- One huge skill covering everything. Use it to explain the `CLAUDE.md` split.

## Step in

Anyone calling their skill done without the fresh-session test. "I wrote a
skill" and "I wrote a skill that fires" look identical until you test.

## Coaching prompts

| You see | Say |
|---|---|
| Unsure what goes in a skill | "What have you explained twice?" |
| Skill won't fire | "Read only the description. Does it say *when*?" |
| Run commands in a skill | "That's always true. Move it to `CLAUDE.md`." |
| Skill restates the GTFS spec | "The spec already exists. What did you get wrong?" |

## Debrief

1. Whose skill fired without being named?
2. For the ones that didn't, what was wrong with the description?
3. What will four parallel agents need to agree on next session?
