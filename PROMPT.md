
This session is being continued from a previous conversation that ran out of context. The summary below covers the earlier portion of the conversation.

Summary:
1. Primary Request and Intent:
   The user asked for help planning and scaffolding a reusable multi-agent "crew" for personal software development projects. Requirements:
   - A general-purpose dev team covering the full lifecycle: architecture → requirements → design → implementation → quality → security → content → devops
   - Sub-agents and skills organized around an agreed tech stack
   - Discrete functional capabilities with clear boundaries (for token efficiency)
   - Each capability with 3 phases: design-plan, implement, validate-verify (3 sub-agents per domain)
   - Reusable across projects, with per-project skills for customization
   - UX domain specifically split into: ux-planner (plans research activities, designs studies, identifies participants), ux-implementer (executes research: synthesizes findings, builds personas, maps journeys), ux-validator (usability, accessibility, goal/task validation)
   - Most recently: user wants a `/kickoff` skill that conducts an interactive project discovery interview invoking requirements agents before scaffolding

2. Key Technical Concepts:
   - Claude Code sub-agents: markdown files with frontmatter at `~/.claude/agents/{name}.md`; fields include name, description, model, tools
   - Claude Code skills: markdown files at `~/.claude/skills/{name}/SKILL.md`; user-invocable via `/skill-name`
   - Global scope (`~/.claude/`) vs. project scope (`.claude/`) for agents and skills
   - Skills inject prompts into the conversation; interviews must happen in the main session (not subagents) because they require multi-turn back-and-forth
   - Symlink-based install pattern: source repo at `~/Projects/crew/`, symlinked to `~/.claude/`
   - Model selection: sonnet for planners/implementers, haiku for most validators, sonnet for security-validator and ux-validator
   - Tool restriction per phase: planners get Read/Glob/Grep/WebSearch; implementers get Read/Write/Edit/Glob/Grep/Bash; validators get Read/Glob/Grep (some get Bash)
   - Tech stack: Python 3.12+/FastAPI (async), Vue.js 3+Vite+TypeScript, PostgreSQL, SQLAlchemy 2.x async, Hugo, Digital Ocean App Platform, Docker Compose, uv, pnpm, pytest+httpx, Vitest

3. Files and Code Sections:
   - `/home/drew/Projects/crew/CLAUDE.md`
     - Global tech stack table, Python/Vue code style, conventional commits, testing expectations, standard project structure, crew agent guide
     - Symlinked to `~/.claude/CLAUDE.md`
   
   - `/home/drew/Projects/crew/install.sh`
     - Symlinks CLAUDE.md, all agents/*.md, all skills/*/ into `~/.claude/`
     - Backs up existing CLAUDE.md if not already a symlink
     - Reports: "✓ 27 agents, ✓ 7 skills"
   
   - **27 agent files** at `/home/drew/Projects/crew/agents/`:
     - `arch-planner.md`, `arch-implementer.md`, `arch-validator.md`
     - `req-planner.md`, `req-implementer.md`, `req-validator.md`
     - `ux-planner.md`, `ux-implementer.md`, `ux-validator.md`
     - `design-planner.md`, `design-implementer.md`, `design-validator.md`
     - `impl-planner.md`, `impl-implementer.md`, `impl-validator.md`
     - `quality-planner.md`, `quality-implementer.md`, `quality-validator.md`
     - `security-planner.md`, `security-implementer.md`, `security-validator.md`
     - `content-planner.md`, `content-implementer.md`, `content-validator.md`
     - `devops-planner.md`, `devops-implementer.md`, `devops-validator.md`
     - All symlinked to `~/.claude/agents/`
   
   - **7 skill files** at `/home/drew/Projects/crew/skills/`:
     - `new-project/SKILL.md` — scaffold fullstack/api/hugo project (user-invocable, arguments: project_name, project_type)
     - `adr/SKILL.md` — create Architecture Decision Record (user-invocable, argument: title)
     - `pr-review/SKILL.md` — pre-merge review across impl/quality/security (user-invocable)
     - `daily-check/SKILL.md` — project status at session start (user-invocable)
     - `project-context/SKILL.md` — template for project background (disable-model-invocation: false, user-invocable: false)
     - `project-criteria/SKILL.md` — template for quality bar and DoD (not user-invocable)
     - `project-patterns/SKILL.md` — template for project-specific conventions (not user-invocable)
     - All symlinked to `~/.claude/skills/`
   
   - `/home/drew/.claude/projects/-home-drew-Projects-crew/memory/MEMORY.md` — memory index
   - `/home/drew/.claude/projects/-home-drew-Projects-crew/memory/project_crew.md` — crew project memory
   - `/home/drew/.claude/projects/-home-drew-Projects-crew/memory/user_stack.md` — user tech stack memory

4. Errors and fixes:
   - **First plan rejection**: Plan had only 8 domains and no dedicated UX domain. Design-planner/validator were covering too broad a scope (both craft AND user research).
     - Fix: Added `ux` as 9th domain. Established clear boundary: ux-* = user-centered research ("are we building the right thing?"); design-* = technical craft ("is it built correctly?"). Total agents went from 24 to 27.
   - **Second plan rejection**: ux-implementer was described as creating wireframes and user flows (wrong — those belong to design).
     - Fix: Corrected ux-implementer to: "Execute research plans: synthesize findings, build personas from data, map journeys from evidence." ux-planner updated to: "Plan research activities, design studies/questions, identify participant criteria, write discussion guides."

5. Problem Solving:
   - Identified that `/new-project` skill is purely structural (scaffold only) with no discovery/interview capability
   - Identified the gap: no orchestrated onboarding flow tying interview → requirements → architecture → project skills → scaffold
   - Proposed `/kickoff` skill as the solution:
     1. Interview phase (main session, conversational — requires multi-turn back-and-forth so cannot be a subagent)
     2. Formalize with req-planner (user stories, acceptance criteria)
     3. Architecture fit with arch-planner (stack implications flagged)
     4. Write project skill templates pre-filled from interview (project-context, project-criteria, project-patterns)
     5. Scaffold file structure (new-project logic)

6. All user messages:
   - "Okay Claude. I need to build a viable general purpose dev team (architecture > requirements > design > implementation > quality > security > content > etc) that I can use to collaborate and create my personal projects. This 'crew' should center around an agreed up tech stack and consist of sub-agents and skills that keep things consistent and of high quality. I'd like for my agent team to be broken into discreet and functional capabilities and boundaries so that I can use them to manage resources and optimize token usage while still getting great results. Each capability should center around three facets: design-plan, implement, and validate-verify (so... depending upon how we decide to do this, that might mean three sub-agents per capability). The team will be reusable from project to project, as will many of the skills. But each project will have its own skills to provide guidance, identify ground rules, and define criteria for it. Can you help me plan and scaffold this reusable 'go-to' team?"
   - [Answered questions]: Tech stack: Python, PostgreSQL, Vue.js (willing to discuss), Hugo for static sites, lightweight/low-maintenance, Dreamhost (outdated), Digital Ocean (struggled with containers). Phase structure: 3 agents per domain. Domains selected: Architecture, Requirements, UI/UX Design, Implementation, Content creation, Quality/Testing, Security, Content/Docs, DevOps/Infra.
   - [First plan rejection]: "This is almost there. I need some kind of affordance for UX research (planning, exploration, understanding) and UX validation (usability and accessibility testing; goal and task-driven validation). I see design planner and design validator, but those seem to be more worried about the nuts-and-bolts compliance. I also need some agents to facilitate the value, usefulness, and usability of whatever we happen to be building."
   - [Second plan rejection]: "Not exactly: UX planner needs to plan UX research activities, design research questions and studies, identify recruitment candidates, etc. UX implementer does the actual execution of the UX research plans. Validator is correct, I think."
   - [Plan approval]: approved
   - "I'd like for this system to include an interactive project spin-up process that invokes the requirements agent(s) and has a standard (to start with) process for interviewing the user/project owner to define the project. Maybe that already exists? Can you walk me through how this process would work?"
   - "Yes, please. But /compact first."

7. Pending Tasks:
   - Build the `/kickoff` skill at `/home/drew/Projects/crew/skills/kickoff/SKILL.md`
   - This skill should:
     - Conduct a structured discovery interview in the main conversation (multi-turn, not delegated)
     - Cover: what is it, who's it for, MVP scope, constraints, stack deviations
     - Delegate to `req-planner` to formalize user stories and acceptance criteria
     - Delegate to `arch-planner` to flag architecture/stack implications
     - Fill in and write the three project skill templates (project-context, project-criteria, project-patterns) into the project
     - Run the scaffold logic (create directory structure, boilerplate files)
   - Run `install.sh` again after creating the kickoff skill to add it to `~/.claude/skills/`

8. Current Work:
   The conversation was at the point of having fully built and installed the crew (27 agents + 7 skills, all symlinked and verified), and the user had just asked about and received an explanation of the gap in the project spin-up process. The user confirmed they want the `/kickoff` skill built, asked for a /compact first.

   The explanation given was:
   > "A dedicated kickoff skill that orchestrates the full discovery-to-scaffold flow... Phase 1 — Interview (main session, conversational)... Phase 2 — Formalize (req-planner routes)... Phase 3 — Architecture fit (arch-planner)... Phase 4 — Write project skills... Phase 5 — Scaffold"
   > "The key thing to understand: the interview itself runs in the main conversation, not in a subagent. Skills inject a prompt that tells Claude how to behave — in this case, to ask structured questions and wait for answers."

9. Optional Next Step:
   Build the `/kickoff` skill. The user explicitly said: "Yes, please. But /compact first." — meaning after compaction, create `/home/drew/Projects/crew/skills/kickoff/SKILL.md` and then run `install.sh` to register it.

   The skill should orchestrate: structured discovery interview → req-planner (requirements) → arch-planner (architecture fit) → write project skill templates → scaffold project files.

If you need specific details from before compaction (like exact code snippets, error messages, or content you generated), read the full transcript at: /home/drew/.claude/projects/-home-drew-Projects-crew/19ac5bd7-8df9-4320-9b54-5e5809480ec0.jsonl
Show less
/compact
Going back to:

```
I'd like for this system to include an interactive project spin-up process that invokes the requirements agent(s) and has a standard (to start with) process for interviewing the user/project owner to define the project. Maybe that already exists? Can you walk me through how this process would work?
Good instinct — this is a real gap. Let me walk you through what exists and where the current process falls short.

What currently exists
The /new-project skill is structural only — it takes a name and type and scaffolds directories and boilerplate. It doesn't ask "what are you building?" It assumes you already know.

The req-planner agent exists and can conduct a discovery interview, but only if you explicitly invoke it and know to do so. There's no orchestrated onboarding flow that ties:


interview → requirements → architecture fit → fill project skills → scaffold
How it would work today (without changes)
If you started a new project right now, the flow would be:

You describe the idea to Claude in natural language
Claude might (or might not) route to req-planner — but it has no prompt to conduct a structured interview
You'd manually /new-project my-app fullstack
You'd manually copy and fill in the three project skill templates
That's too much manual coordination. The project skill templates (project-context, project-criteria, project-patterns) are supposed to capture what an interview would surface — but right now they're just blank forms.

What should exist: a /kickoff skill
A dedicated kickoff skill that orchestrates the full discovery-to-scaffold flow. It would work like this:

Phase 1 — Interview (main session, conversational)
The skill loads a structured prompt that tells Claude to conduct a discovery interview covering:

What is the app / site? What problem does it solve?
Who are the users (just you? public? a specific group)?
What does success look like for an MVP?
Any known constraints (timeline, integrations, data sensitivity)?
Stack deviations from the crew defaults?
This happens as a real back-and-forth conversation — the skill prompts Claude to ask, you answer, Claude follows up.

Phase 2 — Formalize (req-planner routes)
Once the interview wraps, Claude delegates to req-planner to turn the conversation into structured user stories and acceptance criteria.

Phase 3 — Architecture fit (arch-planner)
arch-planner reviews the requirements and flags any implications for the stack or structure — e.g., "this needs file uploads, so we'll need DO Spaces."

Phase 4 — Write project skills
Claude fills in the three project skill templates from what was learned:

project-context — from the interview
project-criteria — from the MVP definition and maturity level
project-patterns — mostly defaults until there's actual code
Phase 5 — Scaffold
/new-project logic runs, creating the directory structure with the project skills pre-filled.

The key thing to understand: the interview itself runs in the main conversation, not in a subagent. Skills inject a prompt that tells Claude how to behave — in this case, to ask structured questions and wait for answers. Subagents take on tasks that don't require back-and-forth with you.

Want me to build the /kickoff skill? It would replace the current /new-project as the starting point for any project.
```
Let's proceed.
Let me check the existing skills for format reference before writing the kickoff skill.

Read SKILL.md, SKILL.md
Now let me check the project skill templates to understand what the kickoff skill needs to fill in:

Read SKILL.md
Good. Now I have a clear picture of the format. Let me write the kickoff skill:

Bash Create kickoff skill directory
IN
mkdir -p /home/drew/Projects/crew/skills/kickoff

OUT
mkdir: created directory '/home/drew/Projects/crew/skills/kickoff'
Write SKILL.md
236 lines
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
Now run install.sh to register the new skill:

Bash Run install.sh to symlink kickoff skill
IN
bash install.sh

OUT
Installing crew from: /home/drew/Projects/crew
Installing to:        /home/drew/.claude

✓ CLAUDE.md
✓ 27 agents
✓ 8 skills

Crew installed. Open a new Claude Code session to pick up the changes.
Done. /kickoff is now installed (8 skills total). Here's how it flows when you use it:

/kickoff my-app (or /kickoff — it'll ask for the name)
Claude interviews you one topic at a time: idea, audience, MVP scope, maturity level, stack constraints
Delegates to req-planner → structured user stories + acceptance criteria
Delegates to arch-planner → project type recommendation + stack notes
Writes pre-filled .claude/skills/project-context/, project-criteria/, project-patterns/ into the new project
Scaffolds the full directory structure + boilerplate
The key design: the interview is conversational in the main session (no subagent), so it can actually ask follow-up questions based on your answers. The formalization steps are delegated once there's enough to work with.


image.png
2000×1125
dir.txt
There's a problem with recursive directories that we need to clean up. Or maybe it's a bug in VSCodium. See `dir.xt` and screenshot.
Read dir.txt
There's a real bug here. Each skill directory has a self-referential symlink inside it (e.g. skills/adr/adr -> crew/skills/adr/). This happened because ~/.claude/skills/ is itself a symlink to crew/skills/, so when install.sh ran a second time, it resolved ~/.claude/skills/adr to the actual crew/skills/adr/ directory and placed the new symlink inside it.

Let me read install.sh and fix both the script and the existing bad symlinks:

Read install.sh
Found the bug. When ln -sf src ~/.claude/skills/name runs and ~/.claude/skills/name is already a symlink to a directory, ln follows the symlink and creates the new link inside that directory instead of replacing the symlink. The fix is ln -sfn — the -n flag tells ln to treat a symlink-to-directory as a plain file (i.e., replace it).

Two things to fix:

install.sh — use ln -sfn for skills
Clean up the self-referential symlinks already inside the skill dirs
Edit install.sh
Modified
Now remove the bad symlinks and re-run:

Bash Remove self-referential symlinks inside skill directories
IN
cd /home/drew/Projects/crew/skills && for d in */; do name="${d%/}"; if [ -L "$d/$name" ]; then echo "Removing $d$name"; rm "$d/$name"; fi; done

OUT
Removing adr/adr
rm: remove symbolic link 'adr//adr'? Removing daily-check/daily-check
rm: remove symbolic link 'daily-check//daily-check'? Removing new-project/new-project
rm: remove symbolic link 'new-project//new-project'? Removing project-context/project-context
rm: remove symbolic link 'project-context//project-context'? Removing project-criteria/project-criteria
rm: remove symbolic link 'project-criteria//project-criteria'? Removing project-patterns/project-patterns
rm: remove symbolic link 'project-patterns//project-patterns'? Removing pr-review/pr-review
rm: remove symbolic link 'pr-review//pr-review'?
rm is prompting interactively. Let me force it:

Bash Force-remove self-referential symlinks inside skill directories
IN
for d in */; do name="${d%/}"; target="$d$name"; if [ -L "$target" ]; then rm -f "$target" && echo "Removed $target"; fi; done

OUT
removed 'adr/adr'
Removed adr/adr
removed 'daily-check/daily-check'
Removed daily-check/daily-check
removed 'new-project/new-project'
Removed new-project/new-project
removed 'project-context/project-context'
Removed project-context/project-context
removed 'project-criteria/project-criteria'
Removed project-criteria/project-criteria
removed 'project-patterns/project-patterns'
Removed project-patterns/project-patterns
removed 'pr-review/pr-review'
Removed pr-review/pr-review
Good. Now re-run install to verify the fix holds:

Bash Re-run install and verify no recursive symlinks created
IN
cd /home/drew/Projects/crew && bash install.sh && echo "---" && ls -la skills/adr/

OUT
Installing crew from: /home/drew/Projects/crew
Installing to:        /home/drew/.claude

✓ CLAUDE.md
✓ 27 agents
✓ 8 skills

Crew installed. Open a new Claude Code session to pick up the changes.
---
total 12
drwxrwxr-x  2 drew drew 4096 May 20 08:48 .
drwxrwxr-x 10 drew drew 4096 May 20 08:09 ..
-rw-rw-r--  1 drew drew 1733 May 20 07:48 SKILL.md
Clean — skills/adr/ now only contains SKILL.md, no recursive symlink. Running install again won't recreate the problem because ln -sfn replaces the symlink in ~/.claude/skills/ rather than following it into the source directory.

Okay. Let's create a git repo locally and push it up to my personal GitHub with `gh`...
Bash List crew directory contents
IN
ls -la

OUT
total 32
drwxrwxr-x  5 drew drew 4096 May 20 08:47 .
drwxrwxr-x 20 drew drew 4096 May 20 06:40 ..
drwxrwxr-x  2 drew drew 4096 May 20 07:47 agents
drwxrwxr-x  2 drew drew 4096 May 20 07:49 .claude
-rw-rw-r--  1 drew drew 3961 May 20 07:41 CLAUDE.md
-rw-rw-r--  1 drew drew 3726 May 20 08:44 dir.txt
-rwxrwxr-x  1 drew drew 1460 May 20 08:47 install.sh
drwxrwxr-x 10 drew drew 4096 May 20 08:09 skills
Bash Check GitHub auth status
IN
gh auth status

OUT
github.com
  ✓ Logged in to github.com account drewtodd (keyring)
  - Active account: true
  - Git operations protocol: https
  - Token: gho_************************************
  - Token scopes: 'gist', 'read:org', 'repo', 'workflow'
Good. Before committing, we should add a .gitignore for the dir.txt scratch file and anything from .claude/:

Write .gitignore
3 lines
dir.txt
.claude/
Bash Init git repo and stage files
IN
git init && git add CLAUDE.md install.sh .gitignore agents/ skills/ && git status

OUT
Initialized empty Git repository in /home/drew/Projects/crew/.git/
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   .gitignore
	new file:   CLAUDE.md
	new file:   agents/arch-implementer.md
	new file:   agents/arch-planner.md
	new file:   agents/arch-validator.md
	new file:   agents/content-implementer.md
	new file:   agents/content-planner.md
	new file:   agents/content-validator.md
	new file:   agents/design-implementer.md
	new file:   agents/design-planner.md
	new file:   agents/design-validator.md
	new file:   agents/devops-implementer.md
	new file:   agents/devops-planner.md
	new file:   agents/devops-validator.md
	new file:   agents/impl-implementer.md
	new file:   agents/impl-planner.md
	new file:   agents/impl-validator.md
	new file:   agents/quality-implementer.md
	new file:   agents/quality-planner.md
	new file:   agents/quality-validator.md
	new file:   agents/req-implementer.md
	new file:   agents/req-planner.md
	new file:   agents/req-validator.md
	new file:   agents/security-implementer.md
	new file:   agents/security-planner.md
	new file:   agents/security-validator.md
	new file:   agents/ux-implementer.md
	new file:   agents/ux-planner.md
	new file:   agents/ux-validator.md
	new file:   install.sh
	new file:   skills/adr/SKILL.md
	new file:   skills/daily-check/SKILL.md
	new file:   skills/kickoff/SKILL.md
	new file:   skills/new-project/SKILL.md
	new file:   skills/pr-review/SKILL.md
	new file:   skills/project-context/SKILL.md
	new file:   skills/project-criteria/SKILL.md
	new file:   skills/project-patterns/SKILL.md
Looks good — 38 files, nothing unexpected. Creating the commit and GitHub repo:

Bash Create initial commit
IN
git commit -m "$(cat <<'EOF'
feat: initial crew — 27 agents, 8 skills, install script

9 domains × 3 phase agents (planner/implementer/validator) covering
arch, req, ux, design, impl, quality, security, content, devops.

Cross-cutting skills: kickoff, new-project, adr, pr-review, daily-check.
Project skill templates: project-context, project-criteria, project-patterns.

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"

OUT
[main (root-commit) dae38e0] feat: initial crew — 27 agents, 8 skills, install script
 38 files changed, 2196 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 CLAUDE.md
 create mode 100644 agents/arch-implementer.md
 create mode 100644 agents/arch-planner.md
 create mode 100644 agents/arch-validator.md
 create mode 100644 agents/content-implementer.md
 create mode 100644 agents/content-planner.md
 create mode 100644 agents/content-validator.md
 create mode 100644 agents/design-implementer.md
 create mode 100644 agents/design-planner.md
 create mode 100644 agents/design-validator.md
 create mode 100644 agents/devops-implementer.md
 create mode 100644 agents/devops-planner.md
 create mode 100644 agents/devops-validator.md
 create mode 100644 agents/impl-implementer.md
 create mode 100644 agents/impl-planner.md
 create mode 100644 agents/impl-validator.md
 create mode 100644 agents/quality-implementer.md
 create mode 100644 agents/quality-planner.md
 create mode 100644 agents/quality-validator.md
 create mode 100644 agents/req-implementer.md
 create mode 100644 agents/req-planner.md
 create mode 100644 agents/req-validator.md
 create mode 100644 agents/security-implementer.md
 create mode 100644 agents/security-planner.md
 create mode 100644 agents/security-validator.md
 create mode 100644 agents/ux-implementer.md
 create mode 100644 agents/ux-planner.md
 create mode 100644 agents/ux-validator.md
 create mode 100755 install.sh
 create mode 100644 skills/adr/SKILL.md
 create mode 100644 skills/daily-check/SKILL.md
 create mode 100644 skills/kickoff/SKILL.md
 create mode 100644 skills/new-project/SKILL.md
 create mode 100644 skills/pr-review/SKILL.md
 create mode 100644 skills/project-context/SKILL.md
 create mode 100644 skills/project-criteria/SKILL.md
 create mode 100644 skills/project-patterns/SKILL.md
Bash Create private GitHub repo and push
IN
gh repo create crew --private --source=. --remote=origin --push --description="Reusable multi-agent dev crew for Claude Code — 27 agents across 9 domains, 8 cross-cutting skills"

OUT
https://github.com/drewtodd/crew
To https://github.com/drewtodd/crew.git
 * [new branch]      HEAD -> main
branch 'main' set up to track 'origin/main'.
Done. Repo is live at drewtodd/crew — private, main branch tracking origin.

It occurs to me we need a `README.md` file that explains what this is, the philosophy and how it is set up, and basic instructions for using it. The audience for this file is (honestly, my team right now, who I'm trying to get to build and use a similar system for our corporate projects) a mix of technical and non-technical practitioners who might have a use for such a framework.
Let me read a handful of agents to make sure I represent them accurately before writing:

Read arch-planner.md
Read ux-planner.md
Read SKILL.md
Good, I have a solid picture. Writing the README now:

Write README.md
205 lines
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
Bash Commit README
IN
git add README.md && git commit -m "docs: add README covering philosophy, structure, and usage

Audience: mixed technical/non-technical practitioners evaluating or
adopting the crew framework for their own projects or teams.

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

OUT
[main 3882e7b] docs: add README covering philosophy, structure, and usage
 1 file changed, 204 insertions(+)
 create mode 100644 README.md
Bash Push README to GitHub
IN
git push

OUT
To https://github.com/drewtodd/crew.git
   dae38e0..3882e7b  main -> main
Pushed. The README covers:

The idea — why a team structure rather than one generalist, and what it gets you
How it's structured — domains table, phases table, the planner→implementer→validator pattern explained in plain language
What's included — agents, skills (with usage examples), project templates, CLAUDE.md
Installation — three commands, verification steps
Starting a project — /kickoff flow explained without jargon
Daily workflow — concrete examples someone can copy
Per-project customization — the .claude/skills/ pattern
Adapting for your team — the five-step fork-and-customize path, which is probably what your colleagues will actually want to know
The "Adapting for your team" section in particular gives your non-technical colleagues a clear handoff path: fork, update CLAUDE.md, done.

README.md
TODO: Review/reconsider the `Content` domain. I was originally thinking this would be the public-facing content/artifact creation toolkit (with standards, styleguides, voicing, templates, etc.); not necessarily the documentation creation domain -- which I tend to see as an output/builder focus of `req`. Check my thinking on this, though. I could be wrong.
Good instinct — let me read the current content agents before weighing in:

Read content-planner.md, content-implementer.md
Read content-validator.md
Read req-planner.md
Your instinct is right, and so is your uncertainty about req. Let me read the impl agents too before taking a position:

Read impl-planner.md, impl-implementer.md
Your instinct is correct, and req is the wrong home for technical docs. Here's my full read:

The core distinction that's missing: there are actually two different kinds of written output in a project:

Developer-facing artifacts — READMEs, API docs, changelogs, code comments. These accompany code. A feature isn't done until they exist. They belong in impl, not as a separate domain.
Public-facing content — copy, voice, microcopy, style guides, help docs written for users, marketing content. This is a creative discipline — what a content strategist or UX writer does. That's what content should be.
req should stay focused on what it actually is: inputs to development (user stories, specs, acceptance criteria). Documentation is an output. Conflating them would blur a useful boundary.

Let me write the plan:

Edit iterative-strolling-music.md
Edit failed
Read iterative-strolling-music.md
Write iterative-strolling-music.md
85 lines
# Plan: Reframe `content` domain + move technical docs to `impl`

## Context

The `content` domain was originally built as a technical documentation domain (READMEs, API docs, changelogs). The user's original intent was different: a public-facing content creation discipline covering brand voice, style guides, UX writing, copy templates, and user-facing documentation. This reframe clarifies a boundary that was blurred:

- **`content`** → public-facing content strategy and creation (copy, voice, microcopy, style guides, user-facing help docs)
- **`impl`** → technical documentation as part of shipping code (READMEs, API docs, changelogs, code comments)
- **`req`** → stays focused on requirements as *inputs* to development, not documentation outputs

---

## Files to change

### Content agents — full rewrite

**`agents/content-planner.md`**
Reframe from "plan documentation" to "plan public-facing content strategy":
- Develop brand voice and tone of voice guidelines
- Design content architecture for user-facing surfaces (help docs, onboarding, error messages)
- Audit existing copy for voice consistency and clarity
- Plan UX writing for UI surfaces (microcopy: labels, CTAs, empty states, error messages, tooltips)
- Create content templates and style guides
- Identify content gaps across user-facing touchpoints

**`agents/content-implementer.md`**
Reframe from "write READMEs and changelogs" to "write public-facing copy and content artifacts":
- Write and edit UX copy: labels, error messages, tooltips, onboarding flows, empty states
- Write marketing and product copy (landing pages, feature descriptions, CTAs)
- Write user-facing help documentation (not API docs — those are for devs)
- Produce content that conforms to the voice and style guide
- Create and maintain content templates

**`agents/content-validator.md`**
Reframe from "verify docs are accurate" to "audit content for voice, clarity, and user appropriateness":
- Check copy against style guide and voice guidelines
- Evaluate clarity for the target audience (not developers — end users)
- Flag jargon, inconsistent tone, or terminology drift
- Check UX writing for usability: is the user told what they need to know, when they need to know it?
- Validate content completeness across user-facing surfaces

### Impl agents — add technical documentation responsibility

**`agents/impl-implementer.md`**
Add a section making clear that technical docs are part of implementation "done":
- Writing/updating README when adding a feature or changing setup
- Updating API docs when adding or modifying endpoints
- Writing code comments for non-obvious logic
- Updating CHANGELOG.md as part of shipping

**`agents/impl-planner.md`**
Add "documentation impact" as a planning consideration:
- Flag which docs will need updating as part of the implementation plan
- Technical documentation needs are identified upfront, not retrofitted

### README

**`README.md`** — update the `content` row in the domain table:
- Old: "Documentation, READMEs, changelogs"
- New: "Brand voice, UX writing, copy, style guides, user-facing content"

---

## Boundary notes to encode in the agents

One boundary worth making explicit in the agent files:

| What | Domain | Why |
|---|---|---|
| UX writing (microcopy, labels, error messages) | `content` | It's copy — a content discipline, not a code discipline |
| Usability of that copy | `ux-validator` | Usability review is UX's lane |
| Visual presentation of that copy | `design` | Typography, layout, component — design's lane |
| Technical API/code docs | `impl` | Accompanies code; part of shipping |
| Internal requirements, specs | `req` | Inputs to development, not outputs |

---

## Verification

After changes:
- Read each updated agent and confirm the framing is consistent
- The `content-*` agents should read like a content strategist / UX writer's job description, not a technical writer's
- The `impl-implementer` "done" criteria should include documentation as a checklist item
- The README domain table should reflect the updated framing
Claude’s Plan iterative-strolling-music.md
Stayed in plan mode
Good challenge. Let me actually think through the options, because there are a few viable answers:

Option A: Technical docs stay with content (broaden the domain)
content becomes "all prose output, regardless of audience" — READMEs for developers, help docs for users, copy for the landing page. The agents are writing specialists who handle different audiences differently.

Pro: clean boundary (code vs. prose, full stop)
Con: two very different disciplines in one domain — technical writing ≠ content strategy
Option B: Technical docs live inline, no dedicated home
Documentation is produced by whoever is already working in that area. The impl-implementer updates the README as part of a PR, the same way it updates tests... actually no, it explicitly punts tests to quality. But docs are lighter than tests — a single-sentence changelog entry is not a discipline.

Pro: reflects real practice (docs are part of shipping, not a phase)
Con: doc quality tends to suffer when it's "everyone's job"
Option C: A dedicated docs domain (separate from content)
Split the writing work: docs owns technical documentation (READMEs, API reference, changelogs), content owns public-facing content (copy, voice, UX writing).

Pro: clear separation, both get proper attention
Con: 3 more agents, and docs might feel thin as a domain for a solo-developer crew
My actual read:

For a crew that you're also pitching to mixed technical/non-technical practitioners, Option C probably makes the most sense long-term — it names a distinction that real teams make (technical writers vs. content strategists). But for a personal/small-team crew, it might be more machinery than needed.

Option A is the pragmatic middle ground if you want content to be genuinely useful without adding agents: reframe the agents as writing specialists who can serve any audience, and give them explicit guidance on how to handle technical vs. user-facing contexts differently.

Which way are you leaning? Do you want the explicit docs/content split, or a broader single domain?

I think, for my purposes, we should go with option C. Is it overkill for what I'm realistically going to be doing on a day-to-day basis? Probably. Is it more "proper?" Yes. It also serves my purpose of setting up a demo for my work team nicely, and I can live with the added complexity in my "normal" life. 😁
Good call. Let me update the plan to reflect the split properly before we execute.

Write iterative-strolling-music.md
105 lines
# Plan: Split `content` into `docs` + `content`, reframe both

## Context

The original `content` domain conflated two distinct disciplines: technical writing (READMEs, API docs, changelogs) and public-facing content strategy (brand voice, UX writing, copy, style guides). These require different mindsets and serve different audiences. The fix is to split into two proper domains:

- **`docs`** — technical documentation for developer audiences (READMEs, API reference, changelogs, architecture docs, code comments, runbooks)
- **`content`** — public-facing content for user/stakeholder audiences (brand voice, UX writing, microcopy, marketing copy, style guides, user-facing help)

Total agents goes from 27 → 30.

---

## Files to create

### `agents/docs-planner.md`
- Audit existing technical documentation for gaps, staleness, and organization
- Plan documentation coverage for a project or feature (what docs need to exist, for which audience)
- Outline individual technical documents before they're written
- Identify where inline code comments are needed vs. separate docs
- Output: documentation plan with inventory, priorities, and outlines

Model: `sonnet` | Tools: `Read, Glob, Grep, WebSearch`

### `agents/docs-implementer.md`
- Write READMEs (setup, project structure, configuration, deployment)
- Write API reference documentation (endpoints, parameters, response shapes, errors)
- Write architecture docs explaining design decisions and trade-offs
- Produce changelogs in Keep a Changelog format
- Add inline code comments for non-obvious logic
- Update outdated docs to reflect current reality

Model: `sonnet` | Tools: `Read, Write, Edit, Glob, Grep, Bash`

### `agents/docs-validator.md`
- Verify setup instructions work against current configuration
- Check commands and code examples for accuracy
- Identify outdated information (version numbers, deprecated APIs, moved files)
- Verify all links resolve
- Check that docs cover the common question set for the doc type (README checklist, API doc checklist, etc.)

Model: `haiku` | Tools: `Read, Glob, Grep, Bash`

---

## Files to update

### `agents/content-planner.md` — full rewrite
Reframe from "plan documentation" to "plan public-facing content strategy":
- Develop brand voice and tone of voice guidelines
- Plan content architecture across user-facing surfaces (onboarding, help, error states)
- Plan UX writing for UI surfaces (microcopy: labels, CTAs, empty states, tooltips, error messages)
- Audit existing copy for voice consistency
- Design content templates and style guides
- Identify content gaps across user-facing touchpoints

Model: `sonnet` | Tools: `Read, Glob, Grep, WebSearch`

### `agents/content-implementer.md` — full rewrite
Reframe from "write READMEs and changelogs" to "write public-facing copy and content artifacts":
- Write UX copy: labels, error messages, tooltips, onboarding flows, empty states
- Write marketing and product copy (landing pages, feature descriptions, CTAs)
- Write user-facing help documentation (for end users, not developers)
- Create and maintain style guides and voice documents
- Produce content that conforms to established voice and style guidelines

Model: `sonnet` | Tools: `Read, Write, Edit, Glob, Grep`

### `agents/content-validator.md` — full rewrite
Reframe from "verify doc accuracy" to "audit content for voice, clarity, and user-appropriateness":
- Check copy against style guide and voice guidelines
- Evaluate clarity for the target audience (end users, not developers)
- Flag jargon, inconsistent tone, or terminology drift
- Assess UX writing usability: does the user get what they need, when they need it?
- Validate content completeness across user-facing surfaces

Model: `haiku` | Tools: `Read, Glob, Grep`

### `README.md` — update domain table
Add `docs` row, update `content` row:
- `docs` → "READMEs, API reference, changelogs, architecture docs, runbooks"
- `content` → "Brand voice, UX writing, microcopy, copy, style guides, user-facing help"

---

## Domain boundary reference (to encode in agent files)

| Artifact | Domain | Audience |
|---|---|---|
| README, API docs, architecture docs, changelogs, code comments | `docs` | Developers |
| UX writing, error messages, onboarding copy, CTAs | `content` | End users |
| User-facing help documentation | `content` | End users |
| Usability of that copy | `ux-validator` | (review layer) |
| Visual presentation of copy | `design` | (presentation layer) |
| User stories, acceptance criteria, specs | `req` | Development team |

---

## Verification

- `ls agents/ | wc -l` → should show 30 agent files
- Each `docs-*` agent reads like a technical writer's job description
- Each `content-*` agent reads like a content strategist / UX writer's job description
- README domain table lists 10 domains with accurate descriptions
Claude’s Plan iterative-strolling-music.md
User approved the plan
Creating the three new docs agents and rewriting the three content agents in parallel:

Write docs-planner.md
57 lines
---
name: docs-planner
description: Plan technical documentation — audit what exists, identify gaps, and outline what needs to be written for developer audiences. Use when starting documentation for a project or feature, or when existing docs need reorganization.
model: sonnet
tools: Read, Glob, Grep, WebSearch
---

You are the technical documentation planner for a personal dev crew. Your job is to design documentation that developers (including future-you) can actually use to get things done.

## Your responsibilities
- Audit existing technical documentation for gaps, staleness, and structural problems
- Identify the developer audience for each doc (contributor, API consumer, operator, future maintainer)
- Plan documentation coverage: what needs to exist, in what form, at what priority
- Outline individual documents before they're written so the implementer can work without re-planning
- Identify where inline code comments are needed vs. where separate docs make more sense
- Plan changelogs and release notes cadence

## Documentation types to plan for

| Type | Audience | Location |
|---|---|---|
| README | Anyone starting fresh | Repo root |
| API reference | API consumers | `docs/api/` or auto-generated |
| Architecture docs | Contributors, future maintainers | `docs/architecture/` |
| ADRs | Future maintainers | `docs/decisions/` |
| Runbooks | Operators, on-call | `docs/runbooks/` |
| Changelog | Developers tracking changes | `CHANGELOG.md` |
| Code comments | Anyone reading the code | Inline |

## Output format

```
## Documentation Plan: [Project/Feature]

### Current state
[What exists, what's missing, what's outdated]

### Audience
[Who reads each doc and what do they need to be able to do after reading?]

### Document inventory
| Document | Audience | Priority | Status |
|---|---|---|---|
| README.md | New contributors | High | Needs update |

### Outlines
[For each high-priority doc, a bullet-level outline]

### What doesn't need docs
[Things that are self-evident, covered by the code, or not worth maintaining]
```

## Principles
- Document why and how to use — not how things work internally
- Outdated docs are worse than no docs: only plan what will be maintained
- Technical docs serve developers; if the reader is an end user, that's content's job
Write docs-implementer.md
72 lines
---
name: docs-implementer
description: Write technical documentation for developer audiences — READMEs, API reference, architecture docs, changelogs, and inline code comments. Use after docs-planner has outlined what to write, or when the documentation need is clear and immediate.
model: sonnet
tools: Read, Write, Edit, Glob, Grep, Bash
---

You are the technical writer for a personal dev crew. Your job is to write documentation that helps developers — including future-you — get things done without guessing.

## Your responsibilities
- Write READMEs that get someone from zero to running as fast as possible
- Write API documentation that fully describes endpoints, parameters, response shapes, and error cases
- Write architecture documents that explain decisions and trade-offs (not just what, but why)
- Produce changelogs in Keep a Changelog format
- Add inline code comments where logic is non-obvious — not to explain syntax, but to explain intent
- Update outdated docs to match current reality

## What you do NOT do
- Plan the documentation structure — that's docs-planner
- Review documentation quality — that's docs-validator
- Write content for end users (UX copy, help docs, marketing) — that's content-implementer
- Write code — that's impl-implementer

## README structure

```markdown
# Project Name

One sentence: what this is and who it's for.

## Quick start
[Minimum steps to get running — assume a fresh machine]

## Development setup
[Full local setup, including docker compose up]

## Project structure
[Brief tour of top-level directories and what they contain]

## Configuration
[Environment variables, what each one does, and where to set them]

## Deployment
[How to ship to production — match the actual hosting setup]

## Contributing
[If open source or multi-person — otherwise omit]
```

## Changelog format (Keep a Changelog)

```markdown
## [Unreleased]

## [1.2.0] - 2025-05-15
### Added
- User authentication with JWT

### Fixed
- Profile page crashes when avatar is null

### Changed
- Switched from pip to uv for package management
```

## Writing principles
- Lead with outcomes: "To do X, run Y" — not "Y is a command that does X"
- Use code blocks for all commands and file paths
- Keep setup instructions sequential and complete — don't assume prior knowledge
- Present tense: "Returns a list of items" — not "will return" or "returned"
- If you catch yourself explaining how the code works internally, stop — document how to use it instead
Write docs-validator.md
53 lines
---
name: docs-validator
description: Review technical documentation for accuracy, completeness, and freshness. Use after docs-implementer has written docs, or periodically to audit project documentation health.
model: haiku
tools: Read, Glob, Grep, Bash
---

You are the technical documentation reviewer for a personal dev crew. Your job is to make sure docs are trustworthy — that a developer can follow them without hitting surprises.

## Your responsibilities
- Verify that setup instructions actually work (check commands against current config and project files)
- Identify outdated information: version numbers, deprecated APIs, renamed files, removed features
- Check that code examples are syntactically correct and match the actual codebase
- Verify all links resolve
- Flag missing sections that are standard for the doc type
- Check that docs cover the most common developer questions for the project

## Checks by document type

### README
- [ ] Quick start instructions are complete and in the right order
- [ ] All commands in code blocks are accurate
- [ ] Environment variables match what's in `.env.example`
- [ ] Project structure section reflects the actual current directory layout
- [ ] Deployment instructions match the current hosting setup (DO App Platform, not a stale config)

### API docs
- [ ] Every endpoint is documented
- [ ] Request/response examples are valid and match current schemas
- [ ] Error responses documented for each endpoint
- [ ] Authentication requirements clearly stated
- [ ] Deprecated endpoints marked

### Architecture docs
- [ ] Diagrams or descriptions match the current system
- [ ] ADRs have a status: Proposed / Accepted / Deprecated / Superseded
- [ ] No references to removed components or old tech decisions

### Changelog
- [ ] Follows Keep a Changelog format
- [ ] [Unreleased] section exists
- [ ] Each release has a date
- [ ] Changes are written from the developer's perspective (what changed, not what was done)

## Output format

List each document reviewed, then for each:
- **Critical** — blocks a developer from succeeding (wrong command, missing step)
- **Warning** — confusing or likely to waste time
- **Nit** — minor clarity or formatting issue

End with: **Documentation health: Good / Needs updates / Significantly outdated**
Now rewrite the three content agents:

Write content-planner.md
59 lines
---
name: content-planner
description: Plan public-facing content strategy — brand voice, tone of voice, UX writing, copy architecture, and style guides. Use when establishing how a product communicates with its users, planning copy for a new surface, or auditing content consistency across the product.
model: sonnet
tools: Read, Glob, Grep, WebSearch
---

You are the content strategist for a personal dev crew. Your job is to define how a product speaks to its users — and plan the content that makes that real.

## Your responsibilities
- Develop and document brand voice and tone of voice guidelines
- Plan UX writing coverage: what microcopy needs to exist across the product (labels, CTAs, error messages, empty states, tooltips, onboarding flows)
- Plan user-facing help documentation (written for end users, not developers)
- Audit existing copy for voice consistency, clarity, and gaps
- Design content templates and style guides that the implementer can work from
- Identify the right content for the right moment in the user journey

## Content types to plan for

| Type | Purpose | Audience |
|---|---|---|
| Voice & tone guide | How the product speaks; rules for copy decisions | Writers, designers |
| UX writing / microcopy | Labels, buttons, errors, empty states, tooltips | End users (in-product) |
| Onboarding copy | First-run experience, welcome flows | New users |
| Error messages | What went wrong and what to do next | Users encountering problems |
| Help documentation | How to accomplish tasks in the product | Users seeking guidance |
| Marketing copy | Landing pages, feature descriptions, CTAs | Prospective users |
| Release announcements | What's new, written for users (not a changelog) | Existing users |

## Output format

```
## Content Plan: [Product/Feature/Surface]

### Voice snapshot
[How does this product sound? 3-5 adjectives + brief explanation of each]

### Content audit
[What exists, what's inconsistent, what's missing]

### User journey map
[Where does the user encounter content? What do they need to know at each point?]

### Content inventory
| Surface | Content type | Priority | Status |
|---|---|---|---|
| Sign-up flow | Onboarding copy | High | Missing |
| 404 page | Error messaging | Medium | Needs rewrite |

### Templates and guidelines needed
[Style guide, error message template, button copy rules, etc.]
```

## Principles
- Content serves the user's goal at a specific moment — plan for moments, not just pages
- Voice is consistent; tone adapts to context (error messages ≠ onboarding copy)
- If the reader is a developer, that's docs-planner's territory — content is for end users and stakeholders
- Simple, plain language beats clever copy almost every time
Write content-implementer.md
85 lines
---
name: content-implementer
description: Write public-facing copy and content artifacts — UX writing, microcopy, marketing copy, style guides, and user-facing help documentation. Use after content-planner has defined the strategy, or when the copy need is clear and immediate.
model: sonnet
tools: Read, Write, Edit, Glob, Grep
---

You are the content writer for a personal dev crew. Your job is to write copy that speaks to users clearly, in a consistent voice, at the right moment.

## Your responsibilities
- Write UX copy: button labels, form labels, placeholder text, error messages, empty states, tooltips, confirmation dialogs
- Write onboarding and first-run experience copy
- Write marketing and product copy: landing page content, feature descriptions, CTAs
- Write user-facing help documentation (task-oriented, written for people using the product — not developers)
- Create and maintain voice and style guides
- Write release announcements framed for users (what it means for them, not what changed in the code)

## What you do NOT do
- Write technical documentation for developers — that's docs-implementer
- Plan the content strategy — that's content-planner
- Review content quality — that's content-validator
- Write code — that's impl-implementer

## UX writing patterns

### Error messages
```
[What happened]. [Why, if helpful]. [What to do next].

✓ "We couldn't save your changes. Check your connection and try again."
✗ "Error 503: upstream service unavailable"
```

### Empty states
```
[What this space is for] + [action to fill it].

✓ "No projects yet. Create your first one to get started."
✗ "No records found."
```

### Buttons and CTAs
- Use verb phrases that describe the outcome: "Save changes", "Send message", "Create project"
- Avoid vague labels: "Submit", "OK", "Click here"
- Destructive actions name the thing being destroyed: "Delete project" not "Confirm"

### Confirmation dialogs
```
[Specific question about the action]
[Consequence if irreversible]
[Cancel] [Verb that matches the action]

✓ "Delete this project? This can't be undone." / [Cancel] [Delete project]
```

## Style guide format

```markdown
# [Product] Voice & Style Guide

## Voice
[3-5 core voice attributes with brief explanation and examples]

## Tone by context
| Context | Tone | Example |
|---|---|---|
| Onboarding | Warm, encouraging | "You're all set. Here's what you can do first." |
| Error states | Direct, helpful | "Something went wrong. Try refreshing the page." |
| Success | Brief, affirming | "Saved." |

## Word choices
| Prefer | Avoid | Why |
|---|---|---|
| "sign in" | "login" | Verb, not noun |

## Punctuation and formatting
[Capitalization rules, punctuation in UI elements, number formatting, etc.]
```

## Writing principles
- Write for the moment the user is in — error state copy should not sound like marketing
- Plain language over clever language; clarity is the job
- If you're explaining how the system works internally, stop — the user needs to know what to do
- Every piece of copy should either inform, instruct, or reassure
Write content-validator.md
54 lines
---
name: content-validator
description: Review public-facing copy and content for voice consistency, clarity, and user-appropriateness. Use after content-implementer has written copy, or to audit content quality across a product surface.
model: haiku
tools: Read, Glob, Grep
---

You are the content reviewer for a personal dev crew. Your job is to make sure public-facing copy is clear, consistent, and actually serves the user at the moment they encounter it.

## Your responsibilities
- Check copy against the established voice and style guide
- Evaluate clarity for the target audience (end users — not developers, not the team)
- Flag jargon, technical language, or internal terminology that leaked into user-facing copy
- Identify inconsistent tone across surfaces (error messages that sound like marketing, etc.)
- Check UX writing for usability: does the user know what happened, what it means, and what to do?
- Flag missing content: surfaces, states, or moments that have no copy
- Check that destructive actions, errors, and edge cases have appropriate messaging

## Checks by content type

### UX writing / microcopy
- [ ] Error messages say what happened and what to do — not just that something failed
- [ ] Empty states explain what the space is for and how to fill it
- [ ] Button labels are verb phrases describing the outcome
- [ ] Destructive action labels name the thing being destroyed
- [ ] Confirmation dialogs state consequences clearly before asking for confirmation
- [ ] No placeholder copy ("Lorem ipsum", "TBD", "TODO") in any user-visible surface

### Voice and tone
- [ ] Copy reads consistently — same product voice across surfaces
- [ ] Tone is appropriate to context (errors are not chipper; onboarding is not clinical)
- [ ] No jargon or technical terms a typical user wouldn't know
- [ ] No passive voice hiding accountability ("An error occurred" → "We couldn't load your data")

### Help documentation
- [ ] Written for the user's task, not the system's structure
- [ ] Steps are in order and complete
- [ ] Screenshots or examples match current UI
- [ ] Answers the question a user would actually ask, not the question the team thinks they'd ask

### Marketing copy
- [ ] Communicates user benefit, not feature list
- [ ] CTAs are specific about what happens next
- [ ] Claims are accurate and not overblown

## Output format

List each surface or document reviewed. For each issue:
- **Critical** — user cannot complete a task or is actively misled
- **Warning** — confusing, off-voice, or likely to erode trust
- **Nit** — minor polish: word choice, consistency, punctuation

End with: **Content health: Good / Needs polish / Significant issues**
Now update the README domain table:

Edit README.md
Added 1 line
Also update the total count in the README:

Edit README.md
Modified
Also fix the domain count reference and the Crew Agent Guide in CLAUDE.md:

Read CLAUDE.md
Edit CLAUDE.md
Modified
Now run install and verify:

Bash Run install and count agents
IN
bash install.sh && echo "---" && ls agents/ | wc -l

OUT
Installing crew from: /home/drew/Projects/crew
Installing to:        /home/drew/.claude

✓ CLAUDE.md
✓ 30 agents
✓ 8 skills

Crew installed. Open a new Claude Code session to pick up the changes.
---
30
30 agents. Commit and push:

Bash Commit and push the docs/content split
IN
git add agents/docs-planner.md agents/docs-implementer.md agents/docs-validator.md agents/content-planner.md agents/content-implementer.md agents/content-validator.md README.md CLAUDE.md && git commit -m "$(cat <<'EOF'
refactor(content): split into docs + content domains

docs-* handles technical documentation for developer audiences
(READMEs, API reference, changelogs, architecture docs, runbooks).

content-* handles public-facing content for user/stakeholder audiences
(brand voice, UX writing, microcopy, marketing copy, style guides,
user-facing help documentation).

Total agents: 27 → 30. Domain count: 9 → 10.

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)" && git push

OUT
[main 4fe2d49] refactor(content): split into docs + content domains
 8 files changed, 323 insertions(+), 115 deletions(-)
 create mode 100644 agents/docs-implementer.md
 create mode 100644 agents/docs-planner.md
 create mode 100644 agents/docs-validator.md
To https://github.com/drewtodd/crew.git
   3882e7b..4fe2d49  main -> main
Done. The crew is now 10 domains × 3 phases = 30 agents:

docs — technical writing for developers: READMEs, API reference, changelogs, architecture docs, runbooks
content — content strategy and creation for users: brand voice, UX writing, microcopy, marketing copy, style guides, user-facing help
The docs agents read like a technical writer's job description. The content agents read like a content strategist's — heavy on voice, tone, UX writing patterns (error messages, empty states, CTAs), and the principle that clarity is the job, not cleverness.

I can make this a public repo, right? No beans in here that I risk spilling...
Yes, safe to make public. The repo contains:

Agent and skill definitions — generic role instructions, no personal info
CLAUDE.md — tech stack preferences and code conventions, nothing sensitive
install.sh — a symlink script, no credentials or paths beyond ~/.claude/
README.md — documentation
The .gitignore excludes .claude/, so your memory files, plans, and any project-specific context never touched the repo.

The only "personal" things in there are your tech stack choices (FastAPI, Vue, DO App Platform) — which are just preferences, not anything you'd need to protect.


gh repo edit drewtodd/crew --visibility public
I think we need to update the "What's included" section of `README.md` to reflect 30 agents (not 27) -- and anywhere else we refer to the number of agents, domains, or skills, we should make sure we're reflecting the right number.
Grep "27|9 domains|nine" (in /home/drew/Projects/crew/README.md)
3 lines of output
Three spots to fix:

Edit README.md
Modified
Edit README.md
Modified
Edit README.md
Modified
Bash Commit and push count corrections
IN
git add README.md && git commit -m "docs: correct agent/domain counts to 30 agents, 10 domains

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>" && git push

OUT
[main efa513f] docs: correct agent/domain counts to 30 agents, 10 domains
 1 file changed, 3 insertions(+), 3 deletions(-)
To https://github.com/drewtodd/crew.git
   4fe2d49..efa513f  main -> main
All three references updated — the prose description, the agents section, and the install verification command. Pushed.

Okay. I've created a new directory (`../yahoo-fantasy-baseball`) where I'd like to use this "crew" to spin up a new project. What are the steps I need to go through to get up and running?
Since the crew is already installed globally, there's almost nothing to do:

Open Claude Code in the new directory — the agents and skills are already available everywhere via ~/.claude/

Run /kickoff — that's it. It will:

Interview you about the project
Formalize requirements via req-planner
Check architecture fit via arch-planner
Write the three project skill files into .claude/skills/
Scaffold the directory structure and boilerplate

cd /home/drew/Projects/yahoo-fantasy-baseball
# open Claude Code here, then:
/kickoff yahoo-fantasy-baseball
After kickoff, the project is self-contained — the .claude/skills/ files give any crew agent the project context it needs without you re-explaining things each session. From there, just start each session with /daily-check to orient the crew.

That's genuinely the whole thing. The complexity is all in the crew, not in the per-project setup.

