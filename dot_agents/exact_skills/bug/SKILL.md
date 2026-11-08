---
name: bug
disable-model-invocation: true
user-invocable: true
description: Only when user specifically requests a "bug bash"
---

# Root cause and fix

Get to the bottom of the reported bug and find out what's actually going on.
Find irrefutable proof that you've identified the lowest-level issue, not
just a symptom. Make sure the fix addresses the actual root cause of the
behavior I reported rather than masking or working around its symptoms.

Once you've found the root cause, attack the premise. Does this expose a
simple bug, or a hole in the system's design? Consider whether reworking that
design would solve the problem properly rather than patching around it.
Don't assume the existing decisions are worth preserving.

If there is one obvious fix, implement and verify it. Otherwise, implement each
of the potential fixes and explain each one clearly so I can choose between
them. The potential fixes can but do not have to include fixing the code from getting into the bad state,
fixing the handlign of the bad state after the system gets in the bad state, or fixing the symptoms of the bad state.
Whatever leads to the simplest most correct fix.

You can keep pushing on this for as long as you need. You're not done until
you've root caused the issue—with irrefutable proof—and implemented either
the fix or options for me to choose from.

Uncertainty is a reason to investigate, not a reason to stop. Pause only for
a concrete blocker you cannot resolve independently, and explain exactly
what you need from me to proceed. Don't guess or claim completion.

Explain the cause, the decisive proof, and each fix in plain language.
