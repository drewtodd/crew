---
name: kickoff
description: Run a structured project discovery interview, formalize requirements and architecture fit, write pre-filled project skill files, and scaffold the project. Use this at the start of every new project instead of /new-project.
argument-hint: "[project-name] (optional — will ask if not provided)"
arguments: [project_name]
user-invocable: true
allowed-tools: Read Write Edit Bash Glob Grep Agent
---

# Project Kickoff

You are running the project kickoff flow. Your job is to guide the user through discovery, formalize what you learn, and produce a working project scaffold with pre-filled context files.

Work through the phases below in order. Do not skip ahead — each phase informs the next.

---

## Phase 1: Discovery Interview

Conduct a structured interview **in this conversation**. Ask questions one topic at a time — do not dump all questions at once. Wait for the user's answer before proceeding to the next topic. Follow up if an answer is vague or raises a new question.

Cover these topics, in roughly this order:

### 1. The idea
> "What are you building? Describe it in a sentence or two — what does it do and what problem does it solve?"

Follow up if needed: Is this a new idea or something you've built pieces of before?

### 2. Who it's for
> "Who will use this — just you, a specific group, or the public?"

Follow up: How many users are you expecting, at least initially?

### 3. MVP scope
> "What does success look like for a first version? What's the smallest thing that would be genuinely useful?"

Follow up: What's explicitly out of scope for now?

### 4. Maturity level
> "How are you treating this project — throwaway prototype, something you'll use regularly, or something others will depend on?"

This determines the quality bar and testing expectations.

### 5. Stack and constraints
> "Any deviations from the standard stack? Special integrations, third-party APIs, data sensitivity, or unusual performance requirements?"

Remind them: the default stack is Python/FastAPI + Vue 3 + PostgreSQL + DO App Platform (or Hugo for static sites).

### 6. Project name
If `$project_name` was not provided as an argument, ask: "What do you want to call this project?" (used for the directory and scaffold).

---

When you have enough to proceed (all six topics covered), say:

> "Got it — I have what I need. Let me formalize the requirements, check the architecture fit, and set up the project."

Then move to Phase 2.

---

## Phase 2: Formalize Requirements

Use the `req-planner` agent to turn the interview into structured requirements.

Delegate the following task:

> Based on this project discovery interview, produce:
> 1. A one-paragraph project summary (what it is, who it's for, what problem it solves)
> 2. A list of user stories in "As a [user], I want [action] so that [value]" format covering the MVP scope
> 3. Acceptance criteria for each user story (Given/When/Then or bullet list)
> 4. A list of explicitly out-of-scope items
>
> Interview notes: [paste the key points from Phase 1]

Capture the output — you will use it to fill in the project skill files.

---

## Phase 3: Architecture Fit

Use the `arch-planner` agent to review the requirements and flag any implications.

Delegate the following task:

> Review these requirements and identify:
> 1. Which project type fits best: `api`, `fullstack`, or `hugo`?
> 2. Any stack deviations from CLAUDE.md that this project requires (special integrations, storage, auth, etc.)
> 3. Any non-obvious structural decisions the implementer should know about upfront
> 4. Anything that would affect the project skill files (patterns, constraints)
>
> Requirements: [paste Phase 2 output]

Capture the output — especially the recommended project type and any stack notes.

---

## Phase 4: Write Project Skill Files

Write the three project skill files into `.claude/skills/` inside the project directory (create it if it doesn't exist). Use what you learned in Phases 1–3 to fill in the templates — do not leave placeholder text.

### `.claude/skills/project-context/SKILL.md`

```
---
name: project-context
description: Background context for [project name] — what it is, who it's for, key decisions, and constraints.
user-invocable: false
disable-model-invocation: false
---

# Project Context

## What this project is
[From Phase 1 + Phase 2: one paragraph summary]

## Who it's for
[From Phase 1: audience, expected user count]

## Current state
[New project, prototype phase]

## Stack deviations from global defaults
[From Phase 3: any deviations, or "None — using standard stack"]

## Key decisions already made
[From Phase 3: structural decisions, project type choice]

## Non-obvious constraints
[From Phase 1/3: integrations, data sensitivity, performance]

## What's explicitly out of scope (for now)
[From Phase 2: out-of-scope list]
```

### `.claude/skills/project-criteria/SKILL.md`

```
---
name: project-criteria
description: Quality bar and definition of done for [project name].
user-invocable: false
disable-model-invocation: false
---

# Project Quality Criteria

## Project maturity level
[From Phase 1, topic 4: Prototype / Personal Production / Public]

## Definition of done for a feature

A feature is done when:
- [ ] The happy path works end-to-end
- [ ] At least one happy path test exists
[Add any project-specific criteria from the interview]

## Testing requirements
[Based on maturity level:
- Prototype: happy path only, tests optional
- Personal Production: happy path + error path per endpoint
- Public: full coverage, all branches]

## Performance requirements
[From Phase 1: any stated constraints, or "None — personal use"]

## Accessibility requirements
[From Phase 1: audience-driven — WCAG AA if public, basic if personal]

## Security requirements
[From Phase 1: auth needs, data sensitivity]

## Acceptable shortcuts for this project
[From Phase 1: explicitly stated, based on maturity level]
```

### `.claude/skills/project-patterns/SKILL.md`

```
---
name: project-patterns
description: Project-specific patterns and conventions for [project name].
user-invocable: false
disable-model-invocation: false
---

# Project Patterns & Conventions

## Naming conventions
[From Phase 3: any project-specific naming, or "Following global defaults from CLAUDE.md"]

## Data model patterns
[From Phase 3: any known data model decisions, or "TBD — following global defaults"]

## API patterns
[From Phase 3: known API shape decisions, or "Following global defaults from CLAUDE.md"]

## Frontend patterns
[From Phase 3: if frontend exists, or "No frontend — API only"]

## Error handling patterns
[Following global defaults unless Phase 3 flagged something specific]

## Testing patterns
[From maturity level and Phase 3 notes]

## Things to avoid in this project
[From Phase 3: any project-specific don'ts, or "None identified yet — add as patterns emerge"]
```

---

## Phase 5: Scaffold

Run the scaffold using the project type identified in Phase 3 (`api`, `fullstack`, or `hugo`).

Follow the same scaffold logic as `/new-project`:

- Create the directory structure per CLAUDE.md conventions
- Write the key boilerplate files (main.py, pyproject.toml, docker-compose.yml, etc.)
- The `CLAUDE.md` at the project root should summarize the project in 2-3 sentences and note any stack deviations (pull from project-context)

---

## Wrap-up

When all phases are complete, tell the user:

1. What was created (directory structure summary)
2. Where the project skill files are (`.claude/skills/`)
3. Next steps:
   - `cd [project-name] && docker compose up` (or `hugo server` for Hugo)
   - Copy `.env.example` to `.env` and fill in values
   - Review and refine the project skill files — they're starting points, not final
   - Run `/daily-check` at the start of each session to orient the crew
