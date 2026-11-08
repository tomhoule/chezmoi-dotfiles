---
name: catch-up
description: Give the current participant a short recap of how the thread started, its key journey, what is done, and what remains open. Use for /catch-up or when someone asks what they missed.
---
```

# /catch-up — recap what you missed

Catch up the person who invoked this skill on the current thread.

## Choose the range

Summarize the whole thread by default. If the person explicitly asks about a narrower period, summarize only that period. Do not recap the `/catch-up` request itself.

## Write the recap

- Use the plain, direct style of `/bro`, but never call the person "bro." No jargon, ceremony, or exhaustive timeline.
- Refer to any model as "the agent," not by its model name.
- Focus on decisions, requests, completed work, results, blockers, and meaningful changes. Skip tool calls and intermediate steps unless they explain a failure or blocker.
- Treat work as done only when the thread says it was completed. A proposal, attempt, or plan is not done.
- Put unanswered questions, unaddressed feedback, failed work, and stated next steps under still open.
- Do not guess. If the thread does not establish whether something was completed, call that out under still open.

Use exactly this shape:

**How it started**
- One sentence explaining the original goal or problem.

**Journey**
- At most three one-sentence bullets covering the key decisions, changes in direction, and turning points in order.

**Done**
- At most three one-sentence bullets.

**Still open**
- At most three one-sentence bullets.

Use `- Nothing yet.` or `- Nothing open.` when the Done or Still open section is empty. Do not add an introduction, conclusion, or extra section.
