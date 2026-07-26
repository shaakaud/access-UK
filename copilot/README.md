# Copilot Folder

Configuration files for GitHub Copilot Chat in VS Code.

## Files

- **`instructions.md`** — Copilot Chat instructions, coding standards, git workflow rules

## Global Setup

To use these instructions globally across all your projects:

```bash
# Create ~/.copilot/instructions directory
mkdir -p ~/.copilot/instructions

# Link the instructions (automatically loaded by VS Code across all workspaces)
ln -sfn ~/access-UK/copilot/instructions.md ~/.copilot/instructions/access-uk.instructions.md
```

## Contents

### `instructions.md`
- **Skills**: grill-me (interview mode)
- **Coding Standards**: 80-character line length enforcement
- **Git Workflow Rules**: CRITICAL — Never commit/push without permission
- **Conventions**: Commit format (52-72 rule), file references
- **YAML Frontmatter**: Automatically applies to all files in the workspace (`applyTo: "**"`)

## How It Works

When you have the symlink in place:
- `~/.copilot/instructions/` is automatically detected by VS Code
- The instructions apply to **any project** you open in VS Code
- Copilot Chat will enforce the rules and standards automatically

VS Code workspace settings (rulers, word wrap, etc.) are managed in `access-UK.code-workspace` file at the repository root and apply only to this workspace.
