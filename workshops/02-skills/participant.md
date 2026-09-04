# Workshop 2: Skills

## The technique

Stop re-explaining yourself. Use a skill someone else wrote instead of
restating the same background every session. Then encode your own
hard-won knowledge into one, so the next session — yours or a
teammate's — starts already knowing it.

## Why it matters

Somewhere during the week you explained the same GTFS quirk to your
agent more than once: the past-midnight rollover, an inverted calendar
exception, whatever your slice 3 traps turned out to be. Every one of
those re-explanations is knowledge that belongs in a file, not in your
typing. A skill is that file: a name, a description that tells an agent
when to reach for it, and a body it reads once it does.

## The exercise

Two parts.

**Part one, roughly fifteen minutes.** Do this in your own service
repository, not in a clone of this one. The mechanic matters here: a
skill your agent can already see is not withheld by you declining to
read it, and running both halves inside this repository gets you two
identical feeds and no lesson.

Ask your agent to build a small fixture feed that exercises one specific
defect — pick one of the five defect kinds named in
[`../../fixtures/demo-feed/README.md`](../../fixtures/demo-feed/README.md),
and do not open
[`.claude/skills/gtfs-fixture-builder/`](../../.claude/skills/gtfs-fixture-builder/)
yourself either. Check the result against that skill's own checklist
once it's built. Then copy the whole `gtfs-fixture-builder/` directory
into your repository's `.claude/skills/` — that is the entire
installation step — start a fresh session so it gets picked up, and do
the same job again. (`~/.claude/skills/` works too and makes it
available in every repository. Project scope is the right default while
you are still deciding whether a skill is any good.) Compare the two
feeds against the checklist directly. Note what the second run got
right that the first one didn't — a missing file, a defect that came
bundled with an accidental second defect, a `stop_sequence` that
repeated instead of increased.

**Part two, roughly twenty-five minutes.** Author one skill capturing a
GTFS trap that actually bit you during the week — most likely
past-midnight times or calendar exception semantics. In Claude Code a
skill is a directory under `.claude/skills/` holding a `SKILL.md` whose
YAML frontmatter carries a `name` and a `description`;
[`gtfs-fixture-builder/SKILL.md`](../../.claude/skills/gtfs-fixture-builder/SKILL.md)
is the worked example to copy that shape from. Write the body first:
what the trap is, how to get it right. Then spend real effort on the
description. Look at how `gtfs-fixture-builder`'s own description is
worded — it says what the skill is *for* and lists the specific cases it
covers, not just its name — and hold your description to the same bar.
The description is what an agent reads to decide whether your skill is
relevant before it ever reads the body.

One thing a skill is not the answer to. Some of what you know about
your own repository is true every time and needs no deciding — where the
code lives, how it runs, what the test command is, which stack you
picked in session 1. That belongs in an always-on project file your tool
loads on every request: `CLAUDE.md` in Claude Code, `AGENTS.md` in a
growing number of other tools, `.github/copilot-instructions.md` in
Copilot. The split is worth getting right, because it is the same split
this session keeps circling: house style is always on and needs no
description, while domain knowledge fires selectively and lives or dies
by one. If you have not written the always-on file for your service yet,
write it this week. It is ten lines, and it stops you re-explaining your
own repository to every session you open.

**Checkpoint** — open a fresh session with no context and ask for
something the skill should govern. Watch whether it fires on its own,
unprompted. If it doesn't, the fix is the description, not the body.

## What to notice

The description is the whole ballgame. A perfect body behind a vague
description never runs — an agent that never reads the body can't be
helped by anything written in it. Notice also what you left out: a
skill that restates the GTFS specification is worthless, because the
spec is already there to read. A skill that captures the specific thing
you got wrong is not.

## Continue on your own

Author a second skill describing how a validator is written in your
system: where the file goes, how it registers, what its output looks
like. Then use that skill to build two or three of slice 4's five rules
from [`../../system/backlog.md`](../../system/backlog.md) — two or
three, not all five. The point of this homework is proving the skill
produces consistent rules without you restating the convention each
time, and two or three demonstrate that as well as five do. The rules
you leave undone are what session 3 splits across parallel agents;
arriving with slice 4 finished leaves you nothing to delegate. This
convention skill is what makes session 3 work — parallel agents produce
mergeable code only when they agree on shape, and a skill is how that
agreement gets written down once instead of repeated to every agent
separately.

## In other tools

The technique carries over; only the mechanism, and how firing gets
decided, changes.

- **Copilot** — a repository custom-instructions file
  (`.github/copilot-instructions.md`) is added to every chat request
  automatically, with no description deciding relevance; it's always on,
  closer to a house style file than a skill that fires selectively.
  Separate prompt files (`.github/prompts/*.prompt.md`) package a
  reusable task, but you invoke one by name — it doesn't decide on its
  own to apply.
- **Cursor** — rules under `.cursor/rules/` can be set to always apply,
  to auto-attach by file glob, or, closest to what you built today, to
  carry only a description and let the agent judge relevance itself.
  That last mode is the one this session's checkpoint is really testing
  for.

All three answer the same question: where knowledge lives so you stop
retyping it. Which one decides to fire on its own, and on what basis, is
where they actually differ.
