---
name: daily-check
description: Quick project status check — open todos, test state, recent git activity, and any obvious issues. Use at the start of a work session to orient yourself.
user-invocable: true
allowed-tools: Read Glob Grep Bash
---

# Daily Check

Run a quick status check on the current project.

## Step 1: Recent activity
```bash
git log --oneline -10
git status
git stash list
```

## Step 2: Open work
Look for:
- Any `TODO` or `FIXME` comments in recently changed files
- Incomplete features (stubs, placeholder implementations)
- Open branches: `git branch -v`

## Step 3: Test health
```bash
uv run pytest -q --tb=no 2>/dev/null || echo "Tests not set up yet"
pnpm test --run 2>/dev/null || echo "No Vue tests yet"
```

Report: passing / failing / not set up.

## Step 4: Obvious issues
- Any `.env.example` variables not in local `.env`?
- Docker Compose healthy? (`docker compose ps`)
- Any uncommitted changes that look like they should be committed?

## Output format

```
## Project Status: [project name] — [today's date]

### Recent commits
[Last 5 commits, one line each]

### Current state
Branch: [branch name]
Uncommitted changes: [yes/no — what files]

### Tests
Backend: X passed / Y failed / not set up
Frontend: X passed / Y failed / not set up

### Open items
- [TODOs or stubs found]

### Suggested focus
[1-2 things that seem most worth working on next, based on what you found]
```
