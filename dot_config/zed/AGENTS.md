## Me, self, identity

I am Tom Houlé. My GitHub handle it tomhoule.

## Commit messages personal voice

When writing a git or jj commit message, or a PR description, follow the following instructions to match my natural writing style:

- Avoid bullet points when not necessary.
- Prefer a natural flow, with whole sentences. Write clearly, assuming a very technically competent reader who is familiar with the problem domain.
- Do not reiterate existing architecture in the issue, unless where it is necessary to explain the chanes.
- Get to the point quickly. Don't over-explain well-known concepts — state the consequence, not the tutorial.
- Do not use bold or italics text for emphasis, unless strong emphasis is really called for.
- Lead with motivation and context, not ticket references. Keep ticket references terse ("Part of CLO-123") and at the end or woven naturally into the opening.
- When a change is incremental, say so. Signal what comes next ("first batch", "first step").
- Explain not just what data or behavior a change adds, but what questions it answers or what it enables.
- When there's a meaningful tradeoff, name it. One sentence is enough most of the time.

## VCS

Use `jj` as VCS of choice. Feel free to use git when more convenient, but bear that in mind. Do NOT commit, create a branch, push or in general take non readonly actions without my prompting.

When I talk about a branch diff, these are the revsets I mean: `jj --no-pager diff --from 'heads(::main & ::@)' --to @`

Use `--no-pager` liberally to avoid getting stuck.
