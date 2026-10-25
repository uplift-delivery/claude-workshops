# Session 1 facilitator guide

Read the [participant guide](README.md) first.

**The one lesson:** an agent without context guesses confidently. Plan mode
and checking the output yourself are how you catch it.

## Before

Check every participant finished [Before session 1](../README.md#before-session-1-15-minutes).
Anyone installing a tool during the session loses the exercise.

## Timing

| Min | What |
|---|---|
| 0–5 | Arc of the three sessions. Show plan mode and the permission mode once, on screen. |
| 5–50 | Hands-on. Circulate. Early finishers start step 4, then [extras](../extras.md). |
| 50–60 | Debrief. |

## Let it happen

- Someone accepts "done" without calling the endpoint. Use it in the debrief.
- The agent scaffolds the whole service instead of one endpoint. Let them hit the wall.
- Ingest returns 11 stop times or `20260601`. The feature file catches it; that is the lesson.

## Step in

- Cloud credentials still failing at minute 20: switch them to local.
- Ingest not started by minute 30: have them finish health, commit, and
  use the session 2 catch-up prompt at home.

## Coaching prompts

| You see | Say |
|---|---|
| Paraphrasing the requirement | "`@` the feature file instead." |
| Surprising output | "Ask it what it assumed." |
| Big diff, no plan | "Revert. Plan mode first." |
| Agent repeating a failed fix | "New session, start from the feature file." |
| Arguing with a bad change | "`git restore .` and rewrite the prompt." |

## Debrief

1. Who called their own endpoint, and who trusted the summary?
2. What did the agent assume that you never told it?
3. What did you correct in the plan, and what would have broken otherwise?
