---
name: github-cli
description: Reference for using the GitHub CLI (gh) to interact with GitHub. Use when working with pull requests, issues, CI runs, releases, or the GitHub API from the command line.
---

# GitHub CLI (`gh`)

Use `gh` for GitHub operations instead of the web UI or raw API calls. Run `gh auth status` before anything else to confirm you're authenticated.

The top-level commands are `pr`, `issue`, `run`, `release`, `search`, `repo`, and `api`. Each has subcommands discoverable with `--help`. This skill focuses on the non-obvious patterns rather than cataloguing every subcommand.

## Avoiding interactive prompts

Always pass `--title` and `--body` when creating PRs or issues. Use `--no-pager` or pipe through `cat` when output might be long, since interactive paging blocks automated flows.

## Structured output

Most `gh` commands support `--json <fields>` for machine-readable output. Pass `--json` with no arguments to discover which fields are available. Once in JSON mode, chain `--jq '...'` to filter or reshape. Prefer this over parsing the human-readable table output — it's stable across versions.

```
gh pr view 42 --json title,state,reviews --jq '.reviews[].author.login'
```

`--template` is available too, using Go template syntax with helpers like `tablerow`, `timeago`, `hyperlink`, and `truncate`.

## Investigating PRs and issues

When summarizing or investigating a PR, always fetch comments and reviews alongside metadata — the conversation is often where the real context lives.

```
gh pr view <number> --json comments --jq '.comments[]'
gh api repos/{owner}/{repo}/pulls/<number>/reviews
```

Don't assume that searching for PRs authored by a user covers their full involvement — they may have commented on or reviewed someone else's PR.

## Search

`gh search prs`, `gh search issues`, `gh search code`, `gh search commits`. Use `--repo OWNER/REPO` to scope, and `--` before any query containing `-` to prevent flag parsing (e.g. `gh search issues --repo OWNER/REPO -- "-label:bug"`).

## The `gh api` escape hatch

`gh api <endpoint>` covers anything without a dedicated command. `{owner}` and `{repo}` placeholders auto-resolve from the current repo's git remote.

Key flags: `-X` (method), `-f` (string param), `-F` (typed param — bools, ints, file contents with `@`), `--jq`, `--paginate`, `--slurp` (combine paginated arrays), `--cache <duration>`, `--verbose` (dump full HTTP request/response).

## Cross-repo targeting

`-R OWNER/REPO` on any command, or the `GH_REPO` env var, targets a repo other than the one in the current directory.

## Environment variables worth knowing

- `GH_TOKEN` / `GITHUB_TOKEN` — override stored credentials (useful in CI).
- `GH_DEBUG=api` — log HTTP traffic for debugging.
- `NO_COLOR` — suppress ANSI escape sequences.
