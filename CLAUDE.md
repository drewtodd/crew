# Drew's Dev Crew — Global Conventions

## Tech Stack

| Layer | Choice | Notes |
|---|---|---|
| Backend | Python 3.12+ + FastAPI | Async-first; use `async def` throughout |
| Frontend | Vue.js 3 + Vite | Composition API, `<script setup>`, TypeScript |
| Static sites | Hugo | For content-heavy or marketing sites |
| Database | PostgreSQL 16+ | Primary datastore for all projects |
| ORM / DB access | SQLAlchemy 2.x (async) + asyncpg | Use `async with session` pattern |
| Hosting | Digital Ocean App Platform | Git push to deploy; no manual container ops |
| Local dev | Docker Compose | `docker compose up` should be the only command needed |
| Python packages | uv | `uv add`, `uv run`, `uv sync` — no pip/poetry |
| JS packages | pnpm | `pnpm add`, `pnpm run` — no npm/yarn |
| Python testing | pytest + httpx (async) | `pytest-asyncio` for async tests |
| Vue testing | Vitest + Vue Test Utils | Co-locate test files as `*.test.ts` |

**Do not introduce new frameworks or major dependencies without explicit discussion.**

---

## Code Style

### Python
- Formatter: `black` (line length 88)
- Linter: `ruff` (replaces flake8/isort)
- Type hints required on all function signatures
- Pydantic v2 for data models and validation
- No bare `except:` — always catch specific exceptions

### Vue / TypeScript
- ESLint + Prettier (tabs = 2 spaces)
- `<script setup lang="ts">` on all components
- Props typed with `defineProps<{...}>()`
- No `any` type — use `unknown` and narrow
- Component filenames: PascalCase (`UserCard.vue`)

### General
- File/directory names: `kebab-case` everywhere except Vue components
- No commented-out code in commits
- No `TODO` comments without a linked issue

---

## Commits

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(auth): add JWT refresh token endpoint
fix(api): handle null user in profile response
docs(readme): add local dev setup instructions
chore(deps): bump fastapi to 0.111
```

Scopes map to domains: `auth`, `api`, `ui`, `db`, `infra`, `docs`, `tests`.

---

## Testing Expectations

- All new features need tests before merge
- API endpoints: at least one happy path + one error path test
- Vue components: test user interactions, not implementation details
- Aim for meaningful coverage, not 100% line coverage for its own sake
- Tests should be runnable with a single command: `uv run pytest` or `pnpm test`

---

## Project Structure (FastAPI + Vue)

```
{project}/
├── backend/
│   ├── app/
│   │   ├── main.py          # FastAPI app factory
│   │   ├── routers/         # One file per resource
│   │   ├── models/          # SQLAlchemy models
│   │   ├── schemas/         # Pydantic schemas
│   │   ├── services/        # Business logic
│   │   └── core/            # Config, db, deps
│   ├── tests/
│   ├── pyproject.toml
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── views/
│   │   ├── stores/          # Pinia stores
│   │   ├── composables/
│   │   └── api/             # API client layer
│   ├── package.json
│   └── Dockerfile
├── docker-compose.yml
└── CLAUDE.md                # Project-specific overrides
```

---

## Crew Agent Guide

This project uses a structured agent crew. Each domain has three specialized agents:

| Suffix | Phase | What it does |
|---|---|---|
| `-planner` | Design | Researches, designs, proposes — read-only |
| `-implementer` | Build | Writes code and files — full access |
| `-validator` | Check | Reviews and verifies — read-only |

**Domains:** `arch`, `req`, `ux`, `design`, `impl`, `quality`, `security`, `content`, `devops`

When asking Claude to do domain-specific work, it will route to the appropriate agent automatically. You can also ask directly: "use the arch-planner to..."
