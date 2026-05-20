---
name: adr
description: Create an Architecture Decision Record documenting a technical decision, the context that drove it, the options considered, and the chosen outcome. Use when making a significant technical choice that future-you should understand.
argument-hint: "[short-title]"
arguments: [title]
user-invocable: true
allowed-tools: Read Write Glob
---

# Architecture Decision Record

Create an ADR titled: **$title**

## ADR format

Write the file to `docs/decisions/NNNN-$title.md` where NNNN is the next sequential number (check existing files in `docs/decisions/` to determine the number, starting at 0001).

```markdown
# NNNN. $title

Date: YYYY-MM-DD
Status: Proposed | Accepted | Deprecated | Superseded by [NNNN]

## Context

What is the situation that necessitates this decision?
What forces are at play (technical, team, time, cost)?

## Decision

What is the change being proposed or made?
State it clearly in one or two sentences.

## Options considered

### Option A: [name]
[Description]
Pros: ...
Cons: ...

### Option B: [name]
[Description]
Pros: ...
Cons: ...

## Consequences

### Positive
- ...

### Negative / Trade-offs
- ...

### Neutral
- ...

## Notes
[Anything else relevant — links, related ADRs, follow-up work]
```

## Steps
1. Check `docs/decisions/` for existing ADRs to get the next number
2. Create `docs/decisions/` directory if it doesn't exist
3. Write the ADR with today's date and Status: Accepted (or Proposed if still under discussion)
4. Ask the user to fill in the details if they haven't provided them, or draft from context if they have

The goal is a document that makes the decision understandable to someone (including future-you) who wasn't in the room when it was made.
