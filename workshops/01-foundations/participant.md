# Workshop 1: Foundations

## The technique

Supply context deliberately instead of letting an agent guess at it. Force a
plan out of it before it writes any code, and read that plan rather than
skim it. Verify what it hands back yourself instead of trusting its summary.

## Why it matters

An agent that lacks context does not stop and ask; it invents plausible
details and proceeds with confidence indistinguishable from an agent that
actually knows what it's doing. A summary that says "deployed successfully"
is a claim, not evidence — the agent is reporting what it expects to be
true, not what it checked. Both failures are cheap to catch in the room,
right now, and expensive to discover later, once you've built three more
slices on top of the wrong assumption.

## The exercise

Goal: get a health endpoint running and reachable — on your cloud if your
account is ready, running locally otherwise — using the agent to scaffold
it.

Two things before the first prompt. Run `git init` and commit, even on an
empty directory — an agent that writes something wrong is only cheap to
recover from if you can throw the change away without thinking about it.
Then find out which approval mode you are in: whether your tool asks before
it edits a file or runs a command, or whether it has been told not to ask.
In Claude Code the mode is named in the status bar at the bottom of the
session; Shift+Tab cycles it, and `/permissions` lists what has already
been allowed to run without asking. You are about to let something else
type into your repository; know which of those two situations you are in
first.

1. Open [`../../system/api-contract.md`](../../system/api-contract.md) and
   give the agent the health endpoint section directly, rather than
   describing it from memory. In Claude Code that is `@` and the path —
   `@system/api-contract.md` — which puts the file itself in front of the
   agent instead of your paraphrase of it.
2. Before it writes anything, get a plan out of it: what it will create,
   where, and how you will run it. Claude Code has a plan mode for exactly
   this — Shift+Tab into it and it will not touch a file until you accept
   what it proposes. Read the plan and correct at least one thing.
3. Let it implement. Do not accept "done" as a result.
4. Call the endpoint yourself and read the response body.
5. Confirm against
   [`../../system/acceptance/01-health.md`](../../system/acceptance/01-health.md).

**Checkpoint** — you can state the URL out loud and you have seen
`{"status":"ok"}` come back with your own eyes.

## What to notice

Did you read the plan or skim it? When the agent said it was done, what did
you actually check, rather than take on faith? If you corrected the plan
before it wrote anything, would the code have been wrong without that
correction?

## Working without a room

The next three weeks are the part nobody watches. Three habits carry the
technique into them.

Commit before you let the agent write, every time, and keep the commits
small enough that throwing one away costs nothing. A bad run is not an
argument to win — it is a change to revert and a brief to rewrite. The
second attempt with a better brief beats the fourth attempt at correcting
the first one, and it is not close.

Know when a session has gone stale. The signal is the agent re-proposing a
fix it already tried, or reaching for files that have nothing to do with
what you asked. That is not a prompt to escalate; it is a session carrying
too much wrong context to recover from. End it and start again from the
plan and the acceptance file, rather than from the transcript.

And make the check something you can run again. Before you start slice 2,
have the agent turn
[`../../system/acceptance/01-health.md`](../../system/acceptance/01-health.md)'s
done-conditions into a script in your own stack — a request and a
comparison is enough — then run it at the end of every slice after this
one. Calling the endpoint by hand is the right thing to do once. It is the
wrong thing to do forty times, and by session 3 you will have two threads'
work to confirm at once.

## Continue on your own

Take slices 2 and 3 from
[`../../system/backlog.md`](../../system/backlog.md). A warning about slice
3, stated plainly: it contains two traps that reliably produce confident
wrong answers. The fixture feed's own README already names what kind of
defects it carries, and the answer key names the traps outright, so there is
no secret here to preserve by looking away. Knowing a trap exists is not the
same as handling it correctly in your code — the week tests whether your
implementation gets the dates and the times right, not whether you could
recite the failure mode in advance. Bring what happened to session 2.

## In other tools

The technique carries over; only the mechanism changes.

- **Copilot** — attach files as context explicitly (in VS Code, `#` a
  filename or use the attachment button) rather than relying on whatever
  happens to be open in the editor. Use Plan mode to get a reviewable
  implementation plan before it starts making edits, rather than letting
  agent mode go straight to code.
- **Cursor** — reference files explicitly with `@` (`@file`, `@folder`)
  instead of assuming the right files are already in context. Use Plan mode
  (Shift+Tab) to get a plan you can read and edit before anything is
  written.

The mechanism differs by tool and will keep changing. Supplying context
deliberately and verifying output instead of trusting a summary do not.
