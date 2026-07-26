# WSL Dev Setup Agent

An interactive VS Code Copilot agent for setting up a complete WSL Ubuntu development environment.

## Quick Start

### Setup (One-Time)

Make the agent globally available in VS Code:

```bash
mkdir -p ~/.vscode
ln -s ~/access-UK/agents ~/.vscode/agents
```

### Usage

In VS Code Copilot chat, type:

```
@wsl_dev_setup Please help me set up my WSL environment
```

The agent will:
1. Perform pre-flight system checks
2. Guide you through 28 setup steps (0, 0.5, 1-27)
3. Ask for approval before each step
4. Create backups automatically
5. Handle errors with rollback options
6. Save a transcript log

## Features

✅ **Interactive Guidance**: Step-by-step approval for each action
✅ **Automatic Backups**: All dotfile modifications backed up with timestamps
✅ **Error Recovery**: Multiple rollback options if something fails
✅ **Checkpoint Support**: Resume from where you left off
✅ **Transcript Logging**: Complete log saved to `~/access-UK/.wsl_setup_logs/`
✅ **Custom Recovery**: Free-text option to ask the LLM for help

## What Gets Installed

- **Shell**: Zsh with oh-my-zsh, powerlevel9k, zsh-git-prompt
- **Editor**: Neovim (official release) with NvChad config
- **Git**: Git tools, diffconflicts merge helper, gh CLI
- **Terminal**: Tmux with TPM plugin manager
- **Dev Tools**: Python, Node.js (via nvm), Go, .NET SDK
- **Cloud**: Azure CLI, azd (Azure Developer CLI)
- **Other**: fzf, ripgrep, GitHub Copilot CLI, and more

## Backups

Before modifying any dotfiles, the agent creates timestamped backups:

```
~/.bashrc.bak.20260725_163012
~/.zshrc.bak.20260725_163012
~/.gitconfig.bak.20260725_163012
~/.tmux.conf.bak.20260725_163012
~/.config/nvim.bak.20260725_163012
```

To restore from backup:
```bash
# Example: restore zshrc
cp ~/.zshrc.bak.20260725_163012 ~/.zshrc
```

## Logs

Setup transcript logs are saved to:

```
~/access-UK/.wsl_setup_logs/wsl_setup.2026-07-25_16-30-12.log
~/access-UK/.wsl_setup_logs/wsl_setup.2026-07-25_14-20-05.log
```

Each log contains:
- Timestamp of each action
- User approvals/decisions
- Success/failure status
- Commands executed
- Complete transcript

## Error Recovery

If a step fails, the agent offers options:

**a) Undo this step only**
- Reverses the failed step
- Restores backup files
- Continues to next step

**b) Undo multiple steps**
- Rolls back N steps
- Useful if later steps depend on failed ones
- Continues from earlier checkpoint

**c) Rollback all**
- Returns to pristine state
- All backups restored
- All created directories removed
- Clean checkpoints deleted

**d) Keep and skip**
- Keeps current state
- Skips failed step
- Continues to next step
- Useful if failure is non-critical

**e) Something else**
- Free-text prompt to ask the LLM
- For custom fixes or troubleshooting
- LLM will reason through the issue

## Resuming From Checkpoints

If you interrupt the setup:

```
@wsl_dev_setup I was setting up but had to stop. Can I resume?
```

The agent will:
1. Detect previously completed steps
2. Offer to resume from the last incomplete step
3. OR start fresh if preferred

## Updating the Agent

When README.WSL is updated, update agents/WSL_DEV_SETUP/agent.md manually in
the same change set.

Recommended workflow:
```bash
git diff README.WSL agents/WSL_DEV_SETUP/agent.md
git add README.WSL agents/WSL_DEV_SETUP/agent.md
git commit -m "docs: Update README.WSL and agent"
```

## Troubleshooting

### Agent not found

If you get "agent not found", verify the symlink:
```bash
ls -la ~/.vscode/agents/
# Should show: agents -> /home/youruser/access-UK/agents
```

### Step fails with error

Use rollback option (e) to ask the agent for help with the specific error.

### Want to see what would happen (dry-run)

Ask the agent:
```
@wsl_dev_setup What would step 19 (Neovim) do? Don't execute yet.
```

The agent will explain without making changes.

### Restore from backup manually

```bash
# Find backups
ls -la ~/*.bak.*

# Restore specific file
cp ~/.bashrc.bak.20260725_163012 ~/.bashrc

# Or restore all backups
for file in ~/*.bak.*; do
  original="${file%.bak.*}"
  cp "$file" "$original"
done
```

## For New Laptops

When setting up a new machine:

```bash
# Clone the repo
git clone https://github.com/yourusername/access-UK.git
cd access-UK

# Open in VS Code
code .

# In Copilot chat:
@wsl_dev_setup Please help me set up WSL on this new machine
```

That's it! Agent handles the rest interactively.

## Questions?

- Review the log files: `~/.wsl_setup_logs/wsl_setup.*.log`
- Check README.WSL for detailed step-by-step instructions
- Ask the agent directly in chat (option e for custom recovery)

---

**Agent Version**: 1.0
**Last Updated**: 2026-07-25
**Maintained By**: access-UK project
