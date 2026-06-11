## Skills

### grill-me
Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

## Coding Standards
- Enforce a strict 80-character maximum line length.
- Break long statements across multiple lines using appropriate indentation.

## Conventions

### Git Commit Format (52-72 rule)
- **Line 1:** Subject line — 52 characters or less
- **Line 2:** Blank line (required)
- **Line 3+:** Body text — each line wrapped at 72 characters

Example:
```
Bug 147271: Fix login timeout on session expiry

Update session handler to reset the timer on
each authenticated request. Prevents users from
being logged out during active workflows.
```
