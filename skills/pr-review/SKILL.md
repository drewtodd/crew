---
name: pr-review
description: Run a full pre-merge review across implementation, quality, and security dimensions. Use before merging a branch or considering a feature done. Produces a structured review report.
user-invocable: true
allowed-tools: Read Glob Grep Bash
---

# Pre-Merge Review

Run a comprehensive review of the current changes before merge.

## Step 1: Get the diff

```bash
git diff main...HEAD --stat
git diff main...HEAD
```

Identify: which files changed, what kind of changes (new features, bug fixes, refactors, config).

## Step 2: Implementation review (impl-validator checklist)

- All function signatures have type hints (Python)
- No bare `except:` blocks
- No debug prints or `console.log` left in
- SQLAlchemy sessions handled correctly
- No commented-out code
- Vue props and emits typed
- No `any` type in TypeScript
- Naming consistent with surrounding code

## Step 3: Quality review (quality-validator checklist)

- Do the changed code paths have test coverage?
- Are error paths tested, not just happy paths?
- Do existing tests still pass? (`uv run pytest -q` / `pnpm test --run`)

## Step 4: Security review (security-validator checklist)

- No secrets or credentials in the diff
- New endpoints have authentication where needed
- New inputs are validated via Pydantic
- No raw string SQL
- No new dependencies that are unvetted

## Step 5: Content review

- Is the CHANGELOG.md updated?
- Are new environment variables in `.env.example`?
- Does the README need updating?

## Output format

```
## Pre-Merge Review: [branch name]

### Summary of changes
[2-3 sentences on what this PR does]

### Implementation
[PASS / issues found]

### Tests
[PASS / issues found — include test run output]

### Security
[PASS / issues found]

### Documentation
[PASS / items missing]

### Verdict
✓ Ready to merge
OR
✗ Needs work: [list blocking issues]
```
