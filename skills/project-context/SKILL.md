---
name: project-context
description: Provides background context about this specific project — what it is, who it's for, key decisions made, and non-obvious constraints. Loaded automatically to give agents the context they need for this project.
user-invocable: false
disable-model-invocation: false
---

# Project Context

<!-- 
  TEMPLATE: Copy this file into your project at .claude/skills/project-context/SKILL.md
  Fill in each section. Delete sections that don't apply.
  This file is loaded into agent context automatically.
-->

## What this project is

[One paragraph: what does this app/site do? What problem does it solve?]

## Who it's for

[Audience: just you? A specific group? Public?]

## Current state

[Is this a new project, prototype, or mature app? What phase of development?]

## Stack deviations from global defaults

[List any stack choices that differ from CLAUDE.md — e.g., "Using Flask not FastAPI because...", "No frontend — API only", "Hugo instead of Vue"]

## Key decisions already made

[Decisions that new agents should know about without having to re-derive them. Reference ADRs if they exist: `docs/decisions/0001-*.md`]

## Non-obvious constraints

[Anything that would surprise someone jumping in — performance requirements, specific integrations, legacy decisions, data sensitivity, etc.]

## What's explicitly out of scope (for now)

[Features or concerns we've decided not to tackle yet]
