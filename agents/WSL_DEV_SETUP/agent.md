---
name: wsl_dev_setup
applyTo: ["**/README.md", "**/README.WSL", "**/wsl*"]
---

# @wsl_dev_setup: Interactive WSL Development Environment Setup Agent

> **Single Source of Truth:** All steps, commands, and configurations are in [README.md](../../README.md). This agent guides you through each step interactively with per-step approval and error recovery.

## Quick Start

1. **One-time setup** (if not already done):
   ```bash
   mkdir -p ~/.vscode
   ln -sfn ~/access-UK/agents ~/.vscode/agents
   ```

2. **Start setup in any VS Code workspace:**
   - In VS Code Copilot Chat, type: `@wsl_dev_setup`
   - Agent will guide you through each STEP interactively

3. **Important - Sudo Password:**
   - STEP 1 will cache your sudo credentials (you'll enter password once)
   - This allows all 47+ sudo commands to work without repeated prompts
   - Credentials cached for 15 minutes during setup

4. **Logs saved to:**
   ```
   ~/access-UK/.wsl_setup_logs/wsl_setup.<timestamp>.log
   ```

---

## Architecture: README.md is Single Source of Truth

- **README.md** contains all 28 STEPS with complete commands, backups, verification, and troubleshooting
- **Agent (this file)** is a lightweight **interactive wrapper** that:
  - Displays each STEP from README.md
  - Asks for approval before running commands
  - Handles errors and recovery
  - Tracks progress across sessions

## Why This Approach?

✅ **No duplication** - Changes to README.md auto-reflected in agent
✅ **Easy maintenance** - Edit README.md, agent automatically updated
✅ **Future-proof** - Same README.md for WSL, Linux, Ubuntu direct
✅ **Single source of truth** - One place to maintain all instructions

---

## 28 Complete Steps (STEP 0 to STEP 27)

All steps documented in [README.md](../../README.md) with:
- **What will happen** - Pre-flight briefing
- **Backups created** - What gets backed up before changes
- **Commands** - Exact commands to run
- **Verify** - How to confirm step success
- **Troubleshooting** - Common issues and solutions

---

## Interactive Workflow

**Standard Flow:**

```
Agent: "Ready for STEP X: [Title]?"
       "Open README.md STEP X"
       "Run commands from README.md"

You:   "Done! Output: [paste]"
  or   "Skip this step"
  or   "Error: [describe issue]"

Agent: [Validates or troubleshoots]
       "Proceeding to STEP X+1..."
```

**Per-Step Options:**
- ✅ **Approve & Continue** - "Done, next step"
- ⏭️ **Skip Step** - Optional or already done
- 🔧 **Error Recovery** - Help fix issues
- ❓ **Questions** - Understand or customize

---

## What Gets Installed

- **Shells**: Zsh, Oh-My-Zsh
- **Version Control**: Git, GitHub CLI
- **Terminal**: Tmux + plugins
- **Editors**: Neovim (NvChad)
- **Utilities**: fzf, diffconflicts, mosh, asciidoc
- **Languages**: Python 3, Go, .NET SDK 8
- **Cloud**: Azure CLI, azd
- **Fonts**: DejaVu Sans Mono
- **Helpers**: GitHub Copilot CLI, Claude Code

---

## Key Features

### Backup Strategy
- Timestamped `.bak.YYYYMMDD_HHMMSS` files before modifications
- Safe to restore: `cp ~/.bashrc.bak.YYYYMMDD_HHMMSS ~/.bashrc`

### Error Recovery
If a step fails:
- **Undo step** - Remove files created
- **Skip step** - Continue to next
- **Restore backups** - Restore all .bak files
- **Custom help** - Get targeted assistance

### Resume Capability
- Restart agent anytime
- Detects completed steps
- Continue from checkpoint
- Multi-session setup supported

---

## Optional Steps (Can Skip)

- STEP 7: Clone Docs-UK
- STEP 8: Terminal Colors/Fonts
- STEP 10: Clipboard Tools
- STEP 13: Mosh
- STEP 16: Noip DNS
- STEP 20: WSLg GUI Apps
- STEP 24: GitHub Copilot CLI
- STEP 25: Claude Code
- STEP 27: Azure/C#/Go

---

## Troubleshooting

### Agent Not Found
```bash
mkdir -p ~/.vscode
ln -sfn ~/access-UK/agents ~/.vscode/agents
```

### Step Failed
1. Check **Verify** section in README.md STEP
2. Check **Troubleshooting** section
3. Run `sudo apt update` if packages missing

### Symlinks Issues
- All use `-sfn` flags (idempotent, safe to re-run)
- Check: `ls -la ~/ | grep bashrc`

### Start Fresh
```bash
for bak in ~/*.bak.YYYYMMDD_*; do
  original="${bak%.bak.*}"
  cp "$bak" "$original"
done
```

---

## How to Use

1. **In VS Code Copilot Chat:**
   ```
   @wsl_dev_setup
   ```

2. **For each STEP:**
   - Open [README.md](../../README.md)
   - Find "## STEP X: [Title]"
   - Read: What will happen, Backups, Commands, Verify
   - Run commands
   - Report results to agent

3. **Progress:**
   - Agent tracks completed steps
   - Resume later from checkpoint
   - Logs: `~/access-UK/.wsl_setup_logs/`

---

**Last Updated:** 2026-07-25  
**Architecture:** Single source of truth (README.md) with interactive agent wrapper  
**Steps:** 0-27 (28 total) | **Estimated Time:** 60-90 minutes
