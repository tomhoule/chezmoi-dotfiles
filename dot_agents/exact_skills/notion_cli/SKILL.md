---
name: notion-cli
description: Search an authenticated Notion workspace for pages or databases, read page content, and inspect page metadata using the ntn CLI. Use when asked to find, open, summarize, or verify documents in Notion.
compatibility: Requires the ntn CLI and an authenticated Notion workspace.
---

# Notion CLI

Use the `ntn` CLI directly in the shell for all Notion operations.

## Important request syntax

For `ntn api` inline inputs:

- `name==value` sets a URL query parameter.
- `path=value` sets a JSON request-body string.
- `path:=json` sets a typed JSON request-body value.

The Notion `v1/search` endpoint expects `query`, `filter`, `page_size`, and
`start_cursor` in the request body. Therefore, use `query="..."`, not
`query=="..."`.

## Check authentication

If a command reports an authentication or workspace error, inspect the active
identity:

```bash
ntn whoami
ntn doctor
```

Do not print credentials or authentication files.

## Search for pages

Search page titles across the workspace:

```bash
ntn api v1/search \
  query="<search term>" \
  filter:='{"property":"object","value":"page"}' \
  page_size:=20
```

Example:

```bash
ntn api v1/search \
  query="audit log" \
  filter:='{"property":"object","value":"page"}' \
  page_size:=20
```

Search for both pages and data sources by omitting the filter:

```bash
ntn api v1/search query="<search term>" page_size:=20
```

Notion search primarily finds objects by title. If the requested phrase may
appear only inside a document, search for several likely title fragments and
read the resulting candidates.

## Paginate search results

When the response has `"has_more": true`, repeat the search with its
`next_cursor`:

```bash
ntn api v1/search \
  query="<search term>" \
  filter:='{"property":"object","value":"page"}' \
  page_size:=20 \
  start_cursor="<next_cursor>"
```

## Read a page

Render a page as Markdown:

```bash
ntn pages get "<PAGE_ID_OR_URL>"
```

Read page content and metadata as JSON:

```bash
ntn pages get "<PAGE_ID_OR_URL>" --json
```

Prefer Markdown when reviewing or summarizing content. Use JSON when you need
the canonical URL, page ID, timestamps, creator ID, parent, or properties.

## Verify a result

Before reporting that a page is the requested document:

1. Check that the title is a strong match.
2. Read enough content to verify the topic and document type.
3. Return the canonical Notion URL from the search result or page metadata.
4. Mention ambiguity when multiple plausible pages exist.

Do not infer a named author from `created_by.id` alone. Some tokens cannot
resolve other users' profiles. Only attribute authorship when a page property,
page content, or resolvable user profile confirms it.
