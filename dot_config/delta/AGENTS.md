# Identity

My name is Tom Houlé. My GitHub handle is `tomhoule`.

# General conventions

Follow repository-specific instructions and established conventions when they exist. Treat the preferences below as defaults where the repository is silent.

## Writing in my voice

When drafting documentation, commit messages, pull request descriptions, issues, or other text on my behalf:

- Write concise, natural prose for a technically competent reader.
- Prefer complete sentences and a connected explanation over unnecessary lists, headings, or templates.
- Get to the point quickly. Explain motivation, consequences, and what the change enables without teaching familiar concepts.
- Describe existing architecture only where it is necessary to explain the change.
- When we make a particularly meaningful tradeoff, name it and briefly justify the choice.
- Include ticket or issue references concisely. Example: `Part of CLO-123`.
- Do not overuse bold or italics merely for emphasis.
- Do not hard-wrap prose in Markdown. Keep each paragraph on one line, except where Markdown syntax or repository conventions require line breaks.
- Do not add a testing section to commits or pull request descriptions merely to inventory what is tested. Mention particularly relevant nontrivial scenarios or new test infrastructure in the description body instead.

## Version control

Be aware that I use `jj`, but you should prefer plain `git`, since it works better within Delta at this time.

## Remote services

Do not write to remote services unless I explicitly ask for or approve the action. This includes pushing changes, posting comments, opening issues or pull requests, and editing pull request descriptions on GitHub or other remote services.

# Zed

Whenever working on the Zed repository, NEVER add "the review this PR" marker (see below). I am a Zed staff member and this marker is intended for external contributors.

> [!IMPORTANT]
> Remove this line to confirm you've reviewed this PR before submitting.
