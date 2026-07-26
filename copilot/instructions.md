---
name: "UK Development Standards"
description: "Coding conventions, git workflow rules, and project standards for access-UK workspace"
applyTo: "**"
---

# GitHub Copilot Chat Instructions

This file contains configuration and conventions for GitHub Copilot Chat when working in this workspace.

## Skills

### grill-me
Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

## Coding Standards

- Enforce a strict 80-character maximum line length.
- Break long statements across multiple lines using appropriate indentation.

## Git Workflow Rules

### 🔴 CRITICAL — ALWAYS ENFORCE:

**NEVER commit or push WITHOUT explicit user permission**

- ❌ Do NOT auto-commit changes
- ❌ Do NOT auto-push to remote
- ✅ DO ask user before any git commit/push: "Ready to commit?" + show summary
- ✅ DO wait for explicit approval: "commit" / "push" / "yes"
- ✅ DO describe what will be committed before asking

**Why?** User wants full control over commit timing, message composition, and batching multiple changes.

**Exceptions:** NONE. Always ask first, even if changes are obvious.

**Before any git operation:**
- STOP and ask the user
- Describe the changes being committed
- Wait for explicit permission
- Only then run the git command

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

### File References
- Use workspace-relative paths without backticks
- Always include line numbers when referencing specific locations
- Format: `[file.ts](file.ts#L10)` for links to code
