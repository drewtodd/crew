---
name: project-patterns
description: Defines project-specific patterns, conventions, and recurring code idioms that agents should follow when working in this codebase. Use to capture "how we do things here" that isn't obvious from reading the code.
user-invocable: false
disable-model-invocation: false
---

# Project Patterns & Conventions

<!--
  TEMPLATE: Copy this file into your project at .claude/skills/project-patterns/SKILL.md
  Document patterns that are specific to this project.
  Delete sections that don't apply.
-->

## Naming conventions

[Any naming patterns specific to this project beyond the global defaults?]
- [e.g. "API endpoints use /v1/ prefix"]
- [e.g. "Background tasks are named task_{verb}_{noun}"]
- [e.g. "Database tables are singular: user, not users"]

## Data model patterns

[How is the data structured? Any recurring patterns in models?]
- [e.g. "All models have created_at, updated_at, is_deleted (soft delete)"]
- [e.g. "UUIDs as primary keys throughout"]
- [e.g. "All models inherit from Base in app/models/base.py"]

## API patterns

[How are APIs structured in this project?]
- [e.g. "Paginated list endpoints always return {items: [], total: int, page: int, per_page: int}"]
- [e.g. "Errors always return {detail: string, code: string}"]
- [e.g. "Auth via Bearer token in Authorization header"]

## Frontend patterns

[How is the Vue code organized?]
- [e.g. "Global state in Pinia stores at src/stores/"]
- [e.g. "API calls centralized in src/api/ — never fetch() directly in components"]
- [e.g. "All forms use VeeValidate + Zod schema"]

## Error handling patterns

[How are errors handled in this project?]
- [e.g. "API errors surfaced via global toast notifications"]
- [e.g. "All service methods raise specific exception types from app/core/exceptions.py"]
- [e.g. "Frontend errors logged to console in dev, silently in prod"]

## Testing patterns

[Project-specific testing patterns?]
- [e.g. "User factory in tests/factories.py — always use it, don't create users directly"]
- [e.g. "All tests that hit the DB use the session fixture from conftest.py"]
- [e.g. "Component tests use data-testid attributes, not CSS selectors"]

## Things to avoid in this project

[Project-specific don'ts — things that seem reasonable but cause problems here]
- [e.g. "Don't use synchronous SQLAlchemy — everything is async"]
- [e.g. "Don't add global CSS — everything scoped"]
