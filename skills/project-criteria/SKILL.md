---
name: project-criteria
description: Defines the quality bar and definition of done for this project — what "good enough to ship" means here, what standards apply, and what corners are acceptable to cut for a prototype vs. a production app.
user-invocable: false
disable-model-invocation: false
---

# Project Quality Criteria

<!--
  TEMPLATE: Copy this file into your project at .claude/skills/project-criteria/SKILL.md
  Set the quality expectations for this specific project.
  These override or extend the global defaults in CLAUDE.md.
-->

## Project maturity level

<!-- Choose one and delete the others: -->
- **Prototype / Throwaway**: Speed matters more than quality. Tests optional. No performance requirements.
- **Personal Production**: I use it regularly. Basic tests required. Should not break without warning.
- **Public / Shared**: Others depend on it. Full test coverage, security review, proper error handling.

## Definition of done for a feature

A feature is done when:
- [ ] [Add your criteria here, e.g. "The happy path works end-to-end"]
- [ ] [e.g. "At least one happy path test and one error path test exist"]
- [ ] [e.g. "No new console errors in the browser"]
- [ ] [e.g. "I've used it myself and it doesn't feel broken"]

## Testing requirements

[What level of test coverage is expected for this project?]
- API endpoints: [e.g. "Happy path only" or "All status codes"]
- Services: [e.g. "Skip for now" or "All branches"]
- Vue components: [e.g. "Skip" or "User interactions"]

## Performance requirements

[Any specific performance constraints? e.g. "Page load < 2s", "API responses < 200ms", "None — it's just me"]

## Accessibility requirements

[e.g. "WCAG AA — this is public facing" or "Basic — keyboard nav required" or "Not a priority for this prototype"]

## Security requirements

[e.g. "Full OWASP review before launch" or "Basic auth, no sensitive data" or "No auth needed — internal tool"]

## Acceptable shortcuts for this project

[What are we explicitly allowing that we wouldn't normally allow? Be honest.]
- [e.g. "No pagination — data set is small"]
- [e.g. "No rate limiting — private tool"]
- [e.g. "Minimal error messages — just me using this"]
