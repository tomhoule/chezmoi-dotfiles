```yaml
---
name: pullfrog
description: Pullfrog-style independent code review of a local branch or PR. Manual invocation only; use exclusively when the user explicitly invokes pullfrog by name.
disable-model-invocation: true
---
```

# Pullfrog review

Reviews run through fresh-context, read-only subagents. The primary reviewer
owns complete coverage and the final report; optional sibling specialists answer
only narrow questions that could change its disposition. This preserves the
same firewall Pullfrog gets on GitHub: an agent that wrote or discussed the
change never reviews or synthesizes it. Delta gives each reviewer a private fork
of every attached worktree at spawn time, and successful edits would merge back,
so every review task must prohibit project edits.

**Role check:** if your task says you are the Pullfrog reviewer and gives a
worktree name plus an exact review scope, skip to "Review procedure." Otherwise
you are the dispatcher: execute sections 1 and D, then section C only when the
primary reviewer requests specialists.

## 1. Dispatcher: establish neutral scope

Identify the target Delta worktree by its **name**, not its UUID or parent-side
absolute path. Ask only when multiple attached worktrees make the target
ambiguous.

Determine one exact scope:

- **Local branch or working tree:** determine the target base ref from branch or
  pull-request metadata when available; otherwise default to `origin/main` if it
  exists. Fetch the corresponding remote ref when possible. Never hide a fetch
  failure: if the base still resolves locally, continue with a stale-ref caveat;
  if it does not resolve, report the blocker. Record both
  `git merge-base HEAD <base>` and `git rev-parse HEAD` as immutable commit SHAs.
  The reviewer will include committed, staged, unstaged, and untracked work from
  its spawn-time worktree fork.
- **GitHub PR:** require an unambiguous PR URL or `owner/repo#number`. Use PR
  metadata to record its base and head commit SHAs, and verify the attached
  worktree is for that repository and checked out at the PR head. If not, ask
  the user to attach or check out matching code rather than reviewing a remote
  patch against unrelated surrounding files.

Capture the stated intent verbatim from an existing artifact when one exists
(PR description, issue body, task file, or commit message), and record its
source. If there is no written artifact, say `Intent artifact: none`; do not
write an intent summary yourself.

Do not create a diff file for cross-agent handoff. Delta snapshots the worktree
for the child; the reviewer generates its authoritative diff inside that fork.

## D. Dispatcher: spawn the fresh reviewer

Spawn exactly one subagent with `model: "frontier"`. `frontier` is Delta's role
alias for complex work such as code review, so Delta resolves it through the
current provider's model-role preferences instead of hardcoding a provider or
model ID. Do not call the model-listing tool and do not request thinking effort.
If Thread settings disallow parent model overrides, accept the configured
subagent default.

The task must contain only neutral execution context:

- Tell it to read `~/.agents/skills/pullfrog/SKILL.md`, identify itself as the
  Pullfrog reviewer, and execute the "Review procedure."
- State that the work is read-only: never edit files, change branches, commit,
  push, post a GitHub review, or spawn subagents.
- Give the target worktree **name** and scope mode.
- Give the immutable merge-base and recorded HEAD SHAs for local scope, or the
  PR locator and immutable base/head SHAs for PR scope.
- Give any stale-ref caveat from section 1.
- Give the intent artifact source and its content verbatim, or
  `Intent artifact: none`.

Do not add an implementation summary, curated file list, suspected problem,
expected finding, severity guidance, or anything else from this conversation.
Those additions leak author bias into the reviewer.

`spawn_subagent` returns after acceptance, not completion. If no independent
work remains, end the turn; do not poll. Delta automatically delivers either the
final review or a `PULLFROG_SPECIALISTS_REQUIRED` coordination request. For the
latter, execute section C. For a final review, do not paste, rewrite, soften,
filter, or re-rank it; only surface an operational failure if the review could
not run.

## C. Dispatcher: coordinate optional sibling specialists

Execute this section only when the primary reviewer completes with
`PULLFROG_SPECIALISTS_REQUIRED`. The primary's completion contains one or more
self-contained dispatch packets and a model-role alias for each.

Spawn all requested specialists as **siblings** of the primary reviewer in one
parallel tool batch. Copy each packet's task verbatim and pass exactly its
requested `small`, `balanced`, or `frontier` alias. Do not call the model-listing
tool, add conversation context, summarize the diff, reinterpret the question, or
run a review yourself. If Thread settings disallow model overrides, accept the
configured default.

Each specialist completion arrives automatically in the root thread. Do not
poll. If some siblings remain active, end the turn and wait for their completion.
After all requested specialists have completed or failed:

1. Retrieve the complete retained output for any bounded or paginated result.
2. Build one message headed `PULLFROG_SPECIALIST_RESULTS` containing every
   specialist result or exact failure verbatim, identified only by request
   number.
3. Send that one message to the original primary reviewer with
   `send_subagent_message`; do not aggregate or judge the evidence yourself.
4. End the turn. The follow-up wakes the primary reviewer in its original private
   worktree, where it validates the evidence and writes the final review.

The root is a router only. The automatically delivered final review is
authoritative and must not be duplicated or rewritten.

## Review procedure

You are the sole reviewer and synthesizer. Read the complete diff, investigate
surrounding code, validate every finding, and write the review yourself. This is
strictly read-only: never edit project files, change branches, commit, push, or
post review results to an external service.

## 2. Build and read the complete review surface

Use the supplied worktree name with Delta's tools so commands run in your private
fork. Verify the recorded commits exist before reviewing, then create the diff
inside **your own turn's** scratch directory.

For local scope, verify `HEAD` still equals the recorded HEAD SHA and run:

```bash
mkdir -p "$DELTA_SCRATCH_DIR/pullfrog"
git diff --no-ext-diff --no-textconv <merge-base-sha> > "$DELTA_SCRATCH_DIR/pullfrog/review.diff"
git status --short
git diff --stat <merge-base-sha>
git diff --name-status <merge-base-sha>
git ls-files --others --exclude-standard
wc -l "$DELTA_SCRATCH_DIR/pullfrog/review.diff"
grep -n '^diff --git ' "$DELTA_SCRATCH_DIR/pullfrog/review.diff"
```

For PR scope, verify `HEAD` equals the recorded PR head SHA and run:

```bash
mkdir -p "$DELTA_SCRATCH_DIR/pullfrog"
git diff --no-ext-diff --no-textconv <base-sha> <head-sha> > "$DELTA_SCRATCH_DIR/pullfrog/review.diff"
git diff --stat <base-sha> <head-sha>
git diff --name-status <base-sha> <head-sha>
wc -l "$DELTA_SCRATCH_DIR/pullfrog/review.diff"
grep -n '^diff --git ' "$DELTA_SCRATCH_DIR/pullfrog/review.diff"
```

Exclude unrelated local working-tree changes from PR scope. If the commits or
matching checkout are unavailable, report the blocker instead of substituting a
nearby branch or stale patch.

Read `scratch://pullfrog/review.diff` end-to-end. Use its `diff --git` boundaries,
`--name-status`, and the untracked-file list as a coverage checklist. Read every
untracked, non-ignored file in local scope directly; classify binary or generated
files explicitly when their content cannot be reviewed as text. Before drafting,
re-check that every changed and untracked path was covered. No sampling or
skimming.

The local merge-base diff intentionally compares the merge base to the fork's
current file contents, covering committed and tracked working-tree changes in a
single view. The separate untracked list closes the gap that `git diff` leaves.

## 3. Investigate behavior and negative space

Read applicable `AGENTS.md` files and review each hunk in the context of its whole
function or file. Pull enough surrounding evidence for a confident disposition:
grep callers, inspect sibling paths and tests, and trace external contracts.
Focus on correctness, security, data integrity, compatibility, concurrency,
lifecycle, error handling, performance, and missing behavior—not stylistic
preference.

- **Tests:** check whether each added or changed test would fail with the bug
  present. Reject truthiness, loose bounds, snapshots, or mocks that merely
  mirror the implementation when the contract requires stronger evidence.
- **Impact pass:** collect symbol-shaped identifiers removed or renamed by the
  diff and grep the repository for stale callers, docs, comments, configuration,
  serialization names, and match arms.
- **Symmetry pass:** check sibling execution paths such as create/update,
  open/reopen, local/collaborative, native/web, keyboard/pointer, and
  success/retry/recovery where the change's domain makes them relevant.
- **Triviality:** judge behavioral surface, not line count. A one-line change to
  authentication, money, persistence, SQL, comparison logic, redirects, or
  configuration defaults is not trivial.
- **Third-party semantics:** verify load-bearing API, SDK, framework, database,
  or protocol claims against authoritative current sources and include URLs.

After completing your own coverage, name any questions you still cannot answer
confidently. A question qualifies for a specialist only when additional evidence
could change the final verdict or remove a must-fix finding. Most reviews need no
specialist. Generic "another look," extra confidence, broad review lenses, and
work you can resolve directly do not qualify.

Delta attached subagents cannot spawn children, so request sibling specialists
through the root. If none qualify, continue to section 4. If one or more qualify,
stop before sections 4 and 5 and make this turn's entire response a coordination
request with this exact shape:

```text
PULLFROG_SPECIALISTS_REQUIRED

### Request 1
Model role: small | balanced | frontier
Task:
<complete specialist task>
```

Use `small` only for mechanical lookup, `balanced` for a narrow ordinary
investigation, and `frontier` for complex or cross-cutting reasoning. Each task
must:

- ask exactly one falsifiable question and state the domain lens that makes its
  failure modes concrete;
- identify the worktree by name and include the immutable base/head scope;
- include the exact relevant diff excerpt, especially for uncommitted local
  changes whose content may differ in a later sibling fork;
- say that the excerpt is authoritative for the changed lines while the
  specialist's fork supplies surrounding repository evidence;
- prohibit edits, branch changes, commits, pushes, external review posting,
  further subagents, and unsupported guesses;
- request evidence with clickable file links and require authoritative URLs for
  load-bearing third-party semantics.

Do not summarize the full diff or prescribe a finding. Your coordination response
is not a verdict or partial review. When the root later sends
`PULLFROG_SPECIALIST_RESULTS`, regenerate the diff in your preserved private
worktree, validate every specialist claim yourself, and continue with sections 4
and 5. If a specialist failed or a disposition-changing question remains
unresolved, state that limitation and do not approve.

## 4. Validate and filter findings

Trace each candidate finding through the current code before accepting it. Treat
specialist reports as hypotheses, not directives, and de-duplicate overlapping
evidence. A finding must be introduced or materially amplified by the reviewed
change and must have a concrete consequence.

Drop praise, style preferences, speculative claims, pre-existing issues, and
bloat-shaped recommendations such as impossible-case guards, one-use
abstractions, tautological tests, or comments that restate code. The bar is
**sound, correct, and proportionate**: do not trade simplicity away for nominal
safety against a case the system rules out.

Then check for concrete concerns that may not anchor to one added line: missing
cleanup for replaced code, rollout or revert sequencing, in-flight state,
coverage gaps, scope decisions only a human can make, and architectural risks.
Report these only when evidence supports them; never invent one to make the
review look thorough.

## 5. Write the review

Open with exactly one verdict matching the author's next action:

- 🚨 **Critical** — will break something: security, data loss, or broken core flow
- ⚠️ **Important** — a real issue that must be addressed before merging
- ℹ️ **Minor suggestions only** — mergeable, with deferrable polish or nits
- ✅ **No issues found** — mergeable as reviewed

Then include:

1. **Reviewed changes** — identify the exact reviewed base/head scope and any
   stale-ref caveat, followed by one bullet per substantive change. Derive this
   only from the reviewed artifacts.
2. **Anchored findings** — highest severity first. Use a clickable Delta
   worktree link whose label is `file:line`, then explain the defect and blast
   radius in 2–3 sentences. For cross-file fixes, add affected sites, the
   required behavioral outcome, and any genuine open question.
3. **Non-anchored concerns** — one `### {emoji} {what is wrong}` section per
   evidence-backed concern. Omit the section when there are none.
4. **Nitpicks** — a flat list at the bottom, only when present.

Headings state what is wrong, not what to do. Do not add changelog filler,
boilerplate praise, or severity inflation. If there are no findings, say so
plainly after the reviewed-scope summary.
