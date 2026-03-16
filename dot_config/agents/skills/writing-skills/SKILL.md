---
name: writing-skills
description: How to author Agent Skills (agentskills.io) — the open SKILL.md format for giving agents reusable capabilities. Use when creating, editing, or reviewing a SKILL.md file.
---

# Writing Agent Skills

Agent Skills are folders containing a `SKILL.md` file that teaches an agent how to perform a specific task. The format is specified at https://agentskills.io/specification.

## Directory layout

```
skill-name/
  SKILL.md          # Required: YAML frontmatter + Markdown instructions
  scripts/          # Optional: executable code the agent can run
  references/       # Optional: detailed docs loaded on demand
  assets/           # Optional: templates, schemas, data files
```

## SKILL.md structure

Every `SKILL.md` starts with YAML frontmatter, followed by Markdown body content.

### Required frontmatter

```yaml
---
name: my-skill-name
description: What this skill does and when to use it. Be specific enough that an agent can decide whether to activate it.
---
```

`name` must be 1-64 characters, lowercase alphanumeric and hyphens only, no leading/trailing/consecutive hyphens. It must match the parent directory name.

`description` must be 1-1024 characters. Include keywords that help agents match the skill to relevant tasks. Describe both what the skill does and when to use it.

### Optional frontmatter

| Field | Purpose |
|---|---|
| `license` | License name or reference to a bundled LICENSE file. |
| `compatibility` | Environment requirements — intended product, system packages, network access. Max 500 chars. |
| `metadata` | Arbitrary key-value pairs (string to string). Use reasonably unique key names. |
| `allowed-tools` | Space-delimited list of pre-approved tools (experimental, support varies). |

## Writing good instructions

The body after the frontmatter is free-form Markdown. These principles matter most:

### Lead with what the agent doesn't know

Skip explanations of well-known concepts. Focus on project-specific conventions, domain procedures, non-obvious edge cases, and which tools or APIs to use. If the agent would get it right without the instruction, cut it.

### Design coherent units

A skill should cover one logical capability that composes well with others. Too narrow forces multiple skills to load for one task; too broad makes activation imprecise.

### Aim for moderate detail

Concise step-by-step guidance with a working example outperforms exhaustive documentation. The agent has judgment — let it use it for the non-critical parts.

### Provide defaults, not menus

When multiple tools or approaches work, pick the default and mention alternatives briefly. Don't present them as equal choices.

### Favor procedures over declarations

Teach the agent how to approach a class of problems, not what to produce for one specific instance. The approach should generalize even when individual details are specific.

### Use progressive disclosure

Keep `SKILL.md` under 500 lines / ~5000 tokens — just the core instructions needed on every run. Move detailed reference material into `references/` and tell the agent when to load each file: "Read `references/api-errors.md` if the API returns a non-200 status code" is better than a generic pointer to a directory.

## Useful patterns

### Templates for output format

Provide a concrete template rather than describing the format in prose. Short templates go inline; longer ones go in `assets/` and are referenced from `SKILL.md`.

### Checklists for multi-step workflows

Explicit step lists with checkboxes help the agent track progress and avoid skipping steps with dependencies.

### Validation loops

Instruct the agent to validate its own work before proceeding: do the work, run a validator (script, checklist, or self-check), fix issues, repeat until clean.

### Plan-validate-execute

For batch or destructive operations: create a plan in structured format, validate it against a source of truth, then execute. The validation step is the key ingredient.
