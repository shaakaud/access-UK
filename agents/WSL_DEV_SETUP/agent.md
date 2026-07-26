---
name: wsl_dev_setup
applyTo: ["**/README.md", "**/README.WSL", "**/wsl*"]
---

# @wsl_dev_setup: Interactive WSL Development Environment Setup Agent

> **Single Source of Truth:** All steps, commands, and configurations are in [README.WSL](../../README.WSL). This agent guides you through each step interactively with per-step approval and error recovery.

## Quick Start

1. **One-time setup** (if not already done):
   ```bash
   mkdir -p ~/.vscode
   ln -sfn ~/access-UK/agents ~/.vscode/agents
   ```

2. **Start setup in any VS Code workspace:**
   - In VS Code Copilot Chat, type: `@wsl_dev_setup`
   - Agent will guide you through each STEP interactively

3. **🔴 Primary Shell: Zsh**
   - This setup assumes **zsh as your primary shell** (installed in STEP 3)
   - Bash files are skipped (not needed for zsh-only workflow)
   - fzf installer is skipped (fzf included in Oh-My-Zsh plugin)

3.5 **GitHub Copilot Chat Integration**
   - Global instructions auto-load from `~/.copilot/instructions/` (see STEP 7.5 in README.WSL)
   - Copilot Chat will enforce git workflow rules and coding standards automatically
   - CRITICAL: Always ask before committing/pushing

4. **Important - Sudo Password:**
   - STEP 1 will cache your sudo credentials (you'll enter password once)
   - This allows all 46+ sudo commands to work without repeated prompts
   - Credentials cached for 15 minutes during setup

5. **Logs saved to:**
   ```
   ~/access-UK/.wsl_setup_logs/wsl_setup.<timestamp>.log
   ```

---

## Architecture: README.WSL is Single Source of Truth

- **README.WSL** contains all WSL STEPS with complete commands, backups, verification, and troubleshooting
- **Agent (this file)** is a lightweight **interactive wrapper** that:
   - Displays each STEP from README.WSL
  - Asks for approval before running commands
  - Handles errors and recovery
  - Tracks progress across sessions

## Why This Approach?

✅ **No duplication** - Changes to README.WSL are manually mirrored in agent
✅ **Easy maintenance** - Edit README.WSL, then update agent.md in the same change
✅ **Future-proof** - Same manual pattern for WSL-specific setup docs
✅ **Single source of truth** - One place to maintain all instructions

---

## WSL Setup Steps

All steps documented in [README.WSL](../../README.WSL) with:
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
   "Open README.WSL and locate the numbered step X"
      "Run commands from README.WSL"
       [Skips STEP 2 (bash) and STEP 9 (fzf) — zsh-only setup]

You:   "Done! Output: [paste]"
  or   "Skip this step"
  or   "Error: [describe issue]"

Agent: [Validates or troubleshoots]
       [Checks for existing changes before appending to zshrc.local]
       "Proceeding to STEP X+1..."
```

**Per-Step Options:**
- ✅ **Approve & Continue** - "Done, next step"
- ⏭️ **Skip Step** - Optional or already done
- 🔧 **Error Recovery** - Help fix issues
- ❓ **Questions** - Understand or customize

---

## What Gets Installed (Zsh-Optimized)

All installations optimized for **zsh as primary shell**:
- **Shells**: Zsh, Oh-My-Zsh (bash files skipped — not used for zsh)
- **Version Control**: Git, GitHub CLI
- **Terminal**: Tmux + plugins
- **Editors**: Neovim (NvChad)
- **Utilities**: fzf (via Oh-My-Zsh plugin, installer skipped), diffconflicts, mosh, asciidoc
- **Languages**: Python 3, Go, .NET SDK 8
- **Cloud**: Azure CLI, azd
- **Fonts**: DejaVu Sans Mono
- **Helpers**: GitHub Copilot CLI, Claude Code

**Smart Installation:**
- **Skips STEP 2**: Bash configuration (not needed for zsh)
- **Skips STEP 9**: fzf installer (redundant with Oh-My-Zsh plugin)
- **Checks before appending**: Verifies changes don't already exist in ~/.zshrc.local
- **Prevents repo pollution**: No installation tools modify repo files

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

## Steps: Zsh-Optimized Workflow

**All users follow this flow:**
- ✅ STEP 1: Base Tools (always)
- ⏭️ **STEP 2: Bash** — **SKIP** (not needed for zsh-only)
- ✅ STEP 3-4: Zsh/Oh-My-Zsh (always)
- ✅ STEP 5-7: Git (skip git-lfs auto-install), Tmux, Docs-UK (as desired)
- ⏭️ **STEP 8: Dircolors** — **SKIP** (already in ~/.zshrc.local from merge)
- ⏭️ **STEP 9: fzf installer** — **SKIP** (fzf already in Oh-My-Zsh plugin)
- ✅ STEP 10+: Continue as desired

⚠️ **CRITICAL - Do NOT run these steps manually:**
- **STEP 2**: No bash symlinks — would pollute repo
- **STEP 8**: Dircolors already configured in zshrc.local
- **STEP 9**: fzf installer will pollute bash files despite --no-update-rc flag
- **git lfs install** (in STEP 5): SKIP unless you track large binaries

**After Setup (Make Zsh Your Default Login Shell):**
```bash
chsh -s $(which zsh)
```

**Always Optional:**
- STEP 7: Clone Docs-UK
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
1. Check **Verify** section in README.WSL STEP
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
   - Open [README.WSL](../../README.WSL)
   - Find the numbered "STEP X" entry
   - Read: What will happen, Backups, Commands, Verify
   - Run commands
   - Report results to agent

3. **Progress:**
   - Agent tracks completed steps
   - Resume later from checkpoint
   - Logs: `~/access-UK/.wsl_setup_logs/`

---

**Last Updated:** 2026-07-25  
**Architecture:** Single source of truth (README.WSL) with interactive agent wrapper  
**Steps:** 0, 0.5, 1-28 plus fractional helper steps | **Estimated Time:** 60-90 minutes
