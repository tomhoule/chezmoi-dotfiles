---
name: random
description: Use when the user wants creative lenses, random design perspectives, personas, cultural viewpoints, or structured randomness for AI-assisted work. Triggers on phrases like "give me a random perspective", "generate a design lens", "pick a random style", "creative constraint", or "random persona".
---

# Random MCP — REST API Skill

Generate creative lenses and perspectives via the Random MCP REST API. No auth required — open CORS, no API keys.

## Base URL

`https://www.randommcp.com/api/random/{generator_id}`

## Endpoints

- **Catalog:** `GET /api/random/catalog` — list all generators (optional `?category=` filter)
- **Single generator:** `GET /api/random/{generator_id}` — optional `?seed=` for reproducibility
- **Batch:** `POST /api/random/batch` — up to 10 requests in one call

### Batch example

```json
POST /api/random/batch
{ "requests": [{ "generator_id": "designer" }, { "generator_id": "ux_style", "seed": 42 }] }
```

## Generator categories

- **Design & Creative:** `design_school`, `thinker`, `culture_lens`, `era`, `constraint`, `ux_style`, `color_system`, `design_brief`
- **Business & Strategy:** `company_dna`, `founder`, `brand_archetype`, `product_philosophy`, `industry`
- **Technical & Analytical:** `architect`, `framework`, `mental_model`
- **People & Perspectives:** `designer`, `writer`, `user`, `occupation`, `character_archetype`, `onet_occupation`, `onet_occupation_pair`, `onet_skill_profile`

## Special parameters

- **O*NET generators:** `job_zone` (1–5), `interest` (R/I/A/S/E/C), `soc_group` (2-digit SOC code)
- **Constraint:** `category` (audience, sensory, technical, temporal, philosophical, resource, medium)
- **All generators:** `seed` (integer) for reproducible results

## Tips

- Use `seed` for reproducible results across runs
- Use the batch endpoint to fetch multiple generators in a single call
- Use `GET /api/random/catalog` to discover all available generators
- Chain generators: get a `ux_style`, then use it as context for your design work
- Use `constraint` to force lateral thinking when stuck
