---
name: new-project
description: Scaffold a new project following the agreed stack conventions. Produces the full directory structure, Docker Compose setup, and initial configuration for a FastAPI + Vue project (or Hugo static site if specified).
argument-hint: "[project-name] [type: api|fullstack|hugo]"
arguments: [project_name, project_type]
user-invocable: true
allowed-tools: Write Edit Bash Read
---

# New Project Scaffold

Scaffold a new project named **$project_name** of type **$project_type**.

## Project types

**`api`** — Python FastAPI backend only (no frontend)
**`fullstack`** — FastAPI backend + Vue 3 frontend + PostgreSQL
**`hugo`** — Hugo static site

## What to create

### For `fullstack` or `api`:

**Directory structure** (from CLAUDE.md conventions):
```
$project_name/
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── core/
│   │   │   ├── config.py
│   │   │   └── db.py
│   │   ├── routers/
│   │   ├── models/
│   │   ├── schemas/
│   │   └── services/
│   ├── tests/
│   │   └── conftest.py
│   ├── pyproject.toml
│   ├── Dockerfile
│   └── .python-version
├── frontend/           # (fullstack only)
│   ├── src/
│   │   ├── components/
│   │   ├── views/
│   │   ├── stores/
│   │   ├── composables/
│   │   └── api/
│   ├── package.json
│   └── Dockerfile
├── docker-compose.yml
├── .env.example
├── .gitignore
├── CLAUDE.md           # project-specific overrides
└── README.md
```

**Key files to write:**
1. `backend/app/main.py` — FastAPI app factory with health endpoint
2. `backend/app/core/config.py` — pydantic-settings with DATABASE_URL and APP_SECRET
3. `backend/app/core/db.py` — SQLAlchemy async engine and session factory
4. `backend/tests/conftest.py` — pytest fixtures (async client, test session)
5. `backend/pyproject.toml` — uv-compatible with fastapi, sqlalchemy[asyncio], asyncpg, pydantic-settings, pytest, httpx
6. `docker-compose.yml` — backend + frontend + postgres services with health checks
7. `.env.example` — all required variables with placeholder values
8. `.gitignore` — Python + Node + env files
9. `CLAUDE.md` — project stub (copy template from project-context skill)
10. `README.md` — basic setup instructions

### For `hugo`:
- `hugo new site $project_name`
- Add a theme (note: user must add manually, flag this)
- Basic config.toml with sensible defaults
- Dockerfile for building and serving

## After scaffolding
- Confirm the structure looks correct
- Tell the user the next steps: `cd $project_name && docker compose up`
- Remind them to copy `.env.example` to `.env` and fill in values
