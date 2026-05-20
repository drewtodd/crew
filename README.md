# Dev Crew

A structured multi-agent framework for Claude Code that brings specialized expertise to every phase of software development — from initial concept through deployment.

---

## The idea

Most AI-assisted development treats Claude as a single generalist. That works for simple tasks, but it breaks down on complex projects where different phases of work require genuinely different kinds of thinking: you don't want the same mindset planning your system architecture as you do when writing tests, and neither of those is right for a UX research session.

Dev Crew solves this by giving Claude a team structure. Instead of one assistant doing everything, you get a crew of specialized agents — each scoped to a specific domain and phase of work. They share a common set of standards, use the same tech stack, and hand off cleanly between phases.

The result is more focused work, smaller context windows (better token efficiency), and a consistent approach across everything you build.

---

## How it's structured

### Domains

The crew is organized around nine capability domains, each covering a distinct area of the development lifecycle:

| Domain | What it covers |
|---|---|
| `arch` | System design, data models, Architecture Decision Records |
| `req` | User stories, specifications, acceptance criteria |
| `ux` | User research, usability, accessibility |
| `design` | Component design, visual systems, layout |
| `impl` | Feature development, code implementation |
| `quality` | Testing strategy, test writing, coverage |
| `security` | Threat modeling, vulnerability review, hardening |
| `content` | Documentation, READMEs, changelogs |
| `devops` | Infrastructure, CI/CD, deployment |

### Phases

Every domain has three agents, one per phase:

| Phase | Agent suffix | What it does | Can it write files? |
|---|---|---|---|
| Design | `-planner` | Researches, proposes, and documents a plan | No — read only |
| Build | `-implementer` | Executes the plan and produces output | Yes |
| Check | `-validator` | Reviews the output and flags issues | No — read only |

So the full crew is **27 agents**: 9 domains × 3 phases.

### The planner → implementer → validator pattern

This three-phase pattern enforces a discipline that's easy to skip when you're working alone: design before you build, and verify before you ship. In practice:

1. **Planner** researches the problem and produces a plan — it reads the codebase but doesn't touch it. You review and approve the plan.
2. **Implementer** executes against the plan — writes code, creates files, makes changes.
3. **Validator** audits the result — reads the code, runs checks, and reports findings without modifying anything.

You don't have to use all three phases for every task. A small bug fix might go straight to the implementer. A major architectural decision might only involve the planner.

---

## What's included

### Agents (`agents/`)

27 agent files. Claude Code loads these automatically and routes to the appropriate agent based on what you ask for. You can also ask directly: *"use the security-planner to review the auth flow."*

### Skills (`skills/`)

Skills are commands that inject structured prompts into your conversation. They're invoked with a `/` prefix.

**Cross-cutting skills** — available in every project:

| Skill | How to use | What it does |
|---|---|---|
| `/kickoff` | `/kickoff my-app` | Structured project discovery interview → requirements → architecture → project files → scaffold |
| `/new-project` | `/new-project my-app fullstack` | Scaffold a project (api / fullstack / hugo) without the interview |
| `/adr` | `/adr "use PostgreSQL for primary storage"` | Create an Architecture Decision Record |
| `/pr-review` | `/pr-review` | Pre-merge review across implementation, quality, and security |
| `/daily-check` | `/daily-check` | Session-start status: recent commits, test health, open items |

**Project skill templates** — copied into each project to provide context:

| Template | Purpose |
|---|---|
| `project-context` | What the project is, who it's for, stack deviations, constraints |
| `project-criteria` | Definition of done, quality bar, testing requirements |
| `project-patterns` | Project-specific conventions, naming patterns, things to avoid |

### `CLAUDE.md`

The global conventions file — tech stack, code style, commit format, testing expectations. Installed to `~/.claude/CLAUDE.md` so every Claude Code session inherits these defaults automatically.

---

## Installation

**Prerequisites:** [Claude Code](https://claude.ai/code) installed and authenticated.

```bash
git clone https://github.com/drewtodd/crew.git ~/Projects/crew
cd ~/Projects/crew
bash install.sh
```

The install script symlinks everything into `~/.claude/`. Updates to the repo are picked up immediately — no re-install needed.

Open a new Claude Code session to activate the agents and skills.

### Verify the install

```
ls ~/.claude/agents/   # should show 27 .md files
ls ~/.claude/skills/   # should show 8 directories
```

In a Claude Code session, type `/` — you should see the crew skills appear in the autocomplete list.

---

## Starting a new project

Run `/kickoff` at the start of any new project. It will:

1. **Interview you** — walks through what you're building, who it's for, MVP scope, maturity level, and any stack constraints
2. **Formalize requirements** — routes to `req-planner` to produce user stories and acceptance criteria
3. **Check architecture fit** — routes to `arch-planner` to flag any structural implications
4. **Write project skill files** — creates pre-filled `project-context`, `project-criteria`, and `project-patterns` files in your project
5. **Scaffold the project** — generates the directory structure and boilerplate

The interview runs as a real conversation, not a form. Claude asks questions one at a time and follows up on your answers.

---

## Daily workflow

Once a project is set up:

```
/daily-check          — orient yourself at the start of a session
                        (recent commits, test health, open items)

[describe what you want to do]
                        — Claude routes to the right agent automatically

/pr-review            — before merging, runs impl/quality/security review
/adr "..."            — document a significant decision
```

For domain-specific work, you can be explicit:

> *"Use the ux-planner to design a research study for the onboarding flow"*
> *"Use the security-validator to audit the new auth endpoints"*
> *"Use the quality-implementer to write tests for the user service"*

---

## Per-project customization

Each project gets its own skill files in `.claude/skills/`. These tell the crew agents what they're working on without you having to re-explain it every session.

Copy the templates from `skills/project-context/`, `skills/project-criteria/`, and `skills/project-patterns/` into your project's `.claude/skills/` directory and fill them in. `/kickoff` does this automatically; you can also do it manually.

```
your-project/
└── .claude/
    └── skills/
        ├── project-context/SKILL.md   ← what is this project?
        ├── project-criteria/SKILL.md  ← what does "done" mean here?
        └── project-patterns/SKILL.md  ← how do we do things in this codebase?
```

These files are loaded automatically when agents work in your project directory.

---

## Adapting the crew for your team

The agents and skills in this repo are built around a specific personal tech stack (Python/FastAPI, Vue 3, PostgreSQL). To adapt them for a different stack or team context:

1. **Fork this repo**
2. **Update `CLAUDE.md`** — change the tech stack table and code style conventions to match your team's standards
3. **Review the agent files** — most are stack-agnostic, but implementers reference specific tools (`uv`, `pnpm`, `pytest`). Update any stack-specific references.
4. **Add team-specific skills** — the skill format is simple markdown with a frontmatter header; any workflow your team repeats is a candidate for a skill.
5. **Run `install.sh`** — each team member installs from the fork

The `CLAUDE.md` conventions propagate automatically to all agents once updated, so most customization happens in one file.

---

## The tech stack (default)

| Layer | Choice |
|---|---|
| Backend | Python 3.12+ + FastAPI (async) |
| Frontend | Vue 3 + Vite + TypeScript |
| Static sites | Hugo |
| Database | PostgreSQL 16+ |
| ORM | SQLAlchemy 2.x async + asyncpg |
| Hosting | Digital Ocean App Platform |
| Local dev | Docker Compose |
| Python packages | uv |
| JS packages | pnpm |
| Python testing | pytest + httpx |
| Vue testing | Vitest + Vue Test Utils |

See `CLAUDE.md` for the full conventions including code style and commit format.
