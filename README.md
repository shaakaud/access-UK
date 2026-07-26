# WSL Ubuntu Development Environment Setup Guide

💡 **Interactive Setup Available**: Use the [@wsl_dev_setup](agents/WSL_DEV_SETUP/agent.md) VS Code Copilot agent for guided, step-by-step assistance with automatic error recovery.

Complete guide for setting up a professional WSL Ubuntu development environment with all tools, configurations, and best practices. Steps are numbered 0, 0.5, 1-28 with a few fractional helper steps for use with the @wsl_dev_setup VS Code Copilot agent.

---

## STEP 0: Clone access-UK Repository

**What will happen:**
- Create SSH key for GitHub authentication
- Clone access-UK repository into WSL
- Preserve all scripts and configurations locally

**SSH Key Setup:**
```bash
# Generate ed25519 SSH key (recommended for GitHub)
ssh-keygen -t ed25519 -a 100

# Display public key to add to GitHub
cat ~/.ssh/id_ed25519.pub
```

**Add Key to GitHub:**
1. Copy output from above command
2. Go to: https://github.com/settings/ssh/new
3. Paste key, add title, save

**Clone Repository:**
```bash
git clone git@github.com:shaakaud/access-UK.git ~/access-UK

# Verify clone location (should be in Linux filesystem, not /mnt/)
ls -la ~/access-UK
```

**Troubleshooting:**
- If SSH key permission denied: Check `~/.ssh/` permissions (`chmod 700 ~/.ssh`)
- If repository not found: Ensure SSH key is added to GitHub account
- If clone fails: Test SSH connection with `ssh -T git@github.com`

---

## STEP 0.5: Make Agents Globally Available

**What will happen:**
- Create symlink to access-UK agents
- Enable @wsl_dev_setup agent in any VS Code workspace
- Setup logging directory for setup transcripts

**Commands:**
```bash
# Create VS Code agents directory
mkdir -p ~/.vscode

# Link agents from access-UK repo
ln -sfn ~/access-UK/agents ~/.vscode/agents

# Create logging directory
mkdir -p ~/access-UK/.wsl_setup_logs
```

**Verify:**
```bash
# Check symlink exists
ls -la ~/.vscode/agents/

# Should show: agents -> ~/access-UK/agents

# Verify logging directory
ls -la ~/access-UK/.wsl_setup_logs/
```

**Using the Agent:**
- In VS Code Copilot chat, type: `@wsl_dev_setup`
- Agent will guide step-by-step through setup
- Logs automatically saved to: `~/access-UK/.wsl_setup_logs/wsl_setup.<timestamp>.log`

---

## STEP 1: Install Base Development Tools

**What will happen:**
- Cache sudo credentials (required for 46+ sudo commands in setup)
- Install essential utilities: curl, wget, unzip, tar, ca-certificates
- Install build tools: build-essential, make, pkg-config
- Install processors: jq (JSON), yq (YAML)

**Backups created:** None (no config files modified)

**Important - Sudo Password:**
The first command in STEP 1 is `sudo -v`, which will prompt for your password
once. This caches credentials for 15 minutes (default; may vary per system
configuration). All subsequent sudo commands will work without additional
password prompts. If cache expires mid-setup, run `sudo -v` again.

**Commands:**
```bash
# Cache sudo credentials (will prompt for password, valid 15 minutes)
sudo -v

# Essential utilities
sudo apt update
sudo apt install -y curl wget unzip tar ca-certificates

# Build tools
sudo apt install -y build-essential make pkg-config

# Processors
sudo apt install -y jq yq
```

**Verify:**
```bash
curl --version
wget --version
jq --version
yq --version
```

**Troubleshooting:**
- If `apt update` fails: Check internet connection
- If missing packages: Run `sudo apt install -y <package>` individually
- If `sudo` asks for password mid-setup: Cache expired (15 min default).
  Run `sudo -v` again to refresh, or check if you've switched terminals

---

## STEP 2: Set Up Shell Dotfiles (Bash) — ⏭️ SKIP FOR ZSH-ONLY SETUP

**SKIP this step.** This setup uses **zsh as primary shell** (STEP 3 installs zsh).
Bash files are not needed for zsh-only workflow.

Only use this step if maintaining both bash and zsh shells.

**What will happen (if running for bash users):**
- Backup existing bash configuration files
- Link bash files from access-UK repository
- Preserve aliases and bash settings

**Backups created:**
```bash
cp ~/.bashrc ~/.bashrc.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
cp ~/.bashrc.local ~/.bashrc.local.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
cp ~/.bash_profile ~/.bash_profile.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
```

**Commands:**
```bash
# Link bash configuration files from repo
ln -sfn ~/access-UK/bash/bashrc ~/.bashrc
ln -sfn ~/access-UK/bash/bashrc.local ~/.bashrc.local
ln -sfn ~/access-UK/bash/bash_profile ~/.bash_profile
ln -sfn ~/access-UK/bash/aliases_bash ~/.aliases_bash
ln -sfn ~/access-UK/bin ~/bin

# Reload bash configuration
source ~/.bashrc
```

**GUI Aliases (Optional):**
- `alias gv='gvim'` - Open GVim editor (WSLg)
- `alias xtw='xterm ... &'` - Launch xterm (WSLg)
- Only use these aliases if running GUI apps via WSLg

**Verify:**
```bash
# Check symlinks created correctly
ls -la ~/ | grep bashrc
ls -la ~/ | grep bash_profile
ls -la ~/bin
```

**Troubleshooting:**
- If symlinks already exist: -sfn flags handle re-creation
- If bin directory not found: Check access-UK is cloned in STEP 0

---

## STEP 3: Install Zsh and Oh-My-Zsh

**What will happen:**
- Install Zsh shell (improved bash alternative)
- Install oh-my-zsh framework for plugins/themes
- Install zsh-git-prompt plugin
- Configure Zsh as default login shell

**Backups created:**
```bash
cp ~/.zshrc ~/.zshrc.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
cp ~/.zshrc.local ~/.zshrc.local.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
```

**Commands:**
```bash
sudo apt update
sudo apt install -y zsh

# Link zsh configuration
ln -sfn ~/access-UK/zsh/zshrc ~/.zshrc
ln -sfn ~/access-UK/zsh/zshrc.local ~/.zshrc.local

# Install oh-my-zsh framework (unattended mode)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true

# Install zsh-git-prompt plugin
git clone https://github.com/shaakaud/zsh-git-prompt.git ~/access-UK/zsh/zsh-git-prompt

# Set Zsh as default login shell
chsh -s /usr/bin/zsh
```

**Post-Installation:**
1. Close and reopen terminal (starts new Zsh session)
2. Or manually start: `exec zsh`

**Verify:**
```bash
echo $SHELL
# Should output: /usr/bin/zsh

zsh --version

# Verify oh-my-zsh sourced
grep "source.*oh-my-zsh.sh" ~/.zshrc | grep -v "#"
```

**Troubleshooting:**
- If error `/home/<user>/access-UK/zsh/zsh-git-prompt/zshrc.sh: no such file`:
  - Re-clone zsh-git-prompt: `git clone https://github.com/shaakaud/zsh-git-prompt.git ~/access-UK/zsh/zsh-git-prompt`
  - Then start new shell: `exec zsh`
- If oh-my-zsh not loading: Verify `.zshrc` contains line `source $ZSH/oh-my-zsh.sh` (not commented)

**Make Zsh Your Default Login Shell (Recommended):**
```bash
# Set zsh as default shell
chsh -s $(which zsh)

# Verify (exit and log back in)
echo $SHELL
# Should output: /usr/bin/zsh
```

---

## STEP 3.5: Install DejaVu Font (Recommended Default)

**What will happen:**
- Install DejaVu Sans Mono on Windows side (required for Windows Terminal)
- Install DejaVu fonts in WSL for consistency
- Configure Windows Terminal to use font

**STEP 1: Install on Windows Side (REQUIRED):**

DejaVu Font must be installed on **Windows**, not just WSL, to work in Windows Terminal.

```bash
# On Windows PowerShell (run as Administrator):

# Download URL: https://github.com/dejavu-fonts/dejavu/releases
# Extract ZIP to: C:\Users\YourUsername\Downloads\dejavu-fonts\

cd "$env:USERPROFILE\Downloads\dejavu-fonts\ttf"
Copy-Item *.ttf "C:\Windows\Fonts\"

# Verify in Windows Settings:
# Settings → Fonts → Search "DejaVu" → Should see "DejaVu Sans Mono"
```

**STEP 2: Install on WSL Side (for consistency):**

```bash
sudo apt update
sudo apt install -y fonts-dejavu fonts-dejavu-core

# Verify
fc-list | grep -i dejavu
```

**STEP 3: Configure Windows Terminal:**

```bash
# Open Windows Terminal settings (Ctrl+,)
# In Ubuntu profile, find/add:
"fontFace": "DejaVu Sans Mono"

# Save and restart Windows Terminal
```

**DejaVu Font Pros:**
- ✓ Simple, clean, professional look
- ✓ No special font installation complexity
- ✓ Faster prompt rendering
- ✓ Works consistently across all terminals
- ✓ Pre-installed on most Ubuntu systems

**DejaVu Font Cons:**
- ✗ Less visual flair than Nerd Fonts
- ✗ No git icons in prompt

**OPTIONAL ALTERNATIVE: Powerlevel9k Theme**

If you want fancy prompt with git status icons (requires Nerd Font):

**Powerlevel9k Pros:**
- Beautiful multi-line prompt with git status
- Shows branch, commit status, uncommitted changes
- Customizable colors and icons
- Great for visual developers

**Powerlevel9k Cons:**
- Requires CaskaydiaCove Nerd Font installed on Windows
- Slower prompt rendering on large repos
- More setup complexity
- Font config issues harder to troubleshoot

**To use Powerlevel9k:**

1. Download CaskaydiaCove Nerd Font from: https://www.nerdfonts.com/font-downloads
2. Install on Windows same way as DejaVu (PowerShell as Admin, copy .ttf to C:\Windows\Fonts\)
3. In WSL:
```bash
git clone https://github.com/Powerlevel9k/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
```

4. Uncomment in ~/.zshrc:
```
ZSH_THEME="powerlevel9k/powerlevel9k"
```

5. Update Windows Terminal settings.json:
```
"fontFace": "CaskaydiaCove NF"
```

---

## STEP 4: Configure General Dotfiles

**What will happen:**
- Link inputrc (readline configuration)
- Link gdbinit (GDB debugger configuration)

**Commands:**
```bash
ln -sfn ~/access-UK/others/inputrc ~/.inputrc
ln -sfn ~/access-UK/gdb/gdbinit ~/.gdbinit
```

**Verify:**
```bash
ls -la ~/.inputrc ~/.gdbinit
file ~/.inputrc ~/.gdbinit
```

---

## STEP 5: Configure Git

**What will happen:**
- Backup existing gitconfig
- Link git configuration from repository
- Install git (if not present)

**Git Pager Configuration:**
The gitconfig contains `pager = less -FX` which:
- `-F` (--quit-if-one-screen): Exit immediately if content fits one screen
- `-X` (--no-init): Don't clear screen after quitting, preserving output
This prevents terminal content from disappearing after `git diff`.

**Backups created:**
```bash
cp ~/.gitconfig ~/.gitconfig.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
```

**Commands:**
```bash
sudo apt update
sudo apt install -y git

# Link git configuration
ln -sfn ~/access-UK/git/gitconfig ~/.gitconfig
ln -sfn ~/access-UK/git/git-prompt.sh ~/.git-prompt.sh
ln -sfn ~/access-UK/bin/git ~/bin/git

# ⚠️ DO NOT run git lfs install
# Git LFS is only needed if tracking large binaries (>100MB)
# This repo does NOT use git-lfs, so DO NOT run this:
# ❌ git lfs install  ← SKIP THIS
```

**Optional: Git PPA (latest version)**

```bash
# Use only if you need specific new features from newer Git versions
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install -y git
```

**Verify:**
```bash
git --version
git config --list | head -5
```

**Troubleshooting:**
- If gitconfig not found: Check symlink created correctly
- If git command not found: Run apt install again

---

## STEP 6: Install Tmux

**What will happen:**
- Install tmux terminal multiplexer
- Link tmux configuration
- Install TPM (Tmux Plugin Manager)
- Setup session persistence with resurrect/continuum plugins

**Backups created:**
```bash
cp ~/.tmux.conf ~/.tmux.conf.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
```

**Commands:**
```bash
sudo apt update
sudo apt install -y tmux

# Link tmux config
ln -sfn ~/access-UK/tmux/tmux.conf ~/.tmux.conf

# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Load config
tmux source-file ~/.tmux.conf
```

**Plugins Included:**
- `tmux-resurrect`: Saves/restores tmux sessions, windows, panes
- `tmux-continuum`: Auto-saves state periodically

**Plugin Installation:**
- Inside tmux session, press: `prefix + I` (Shift + I)
- Expected output: `TMUX environment reloaded. Done, press ENTER to continue.`

**Verify:**
```bash
tmux -V

# Check plugin directory
ls ~/.tmux/plugins/

# Check resurrect save files
ls ~/.local/share/tmux/resurrect/
```

**Troubleshooting:**
- If plugins not installing: Run `prefix + I` inside active tmux session
- If config not loading: Verify symlink with `ls -la ~/.tmux.conf`

---

## STEP 7: Clone Docs-UK (Optional)

**What will happen:**
- Clone Docs-UK repository from GitLab
- Reuse SSH key from STEP 0 or create new one

**SSH Key Setup (if not done in STEP 0):**
```bash
ssh-keygen -t ed25519 -a 100
cat ~/.ssh/id_ed25519.pub
# Add key to: https://gitlab.com/profile/keys
```

**Commands:**
```bash
cd ~
git clone git@gitlab.com:shaakaud/Docs-UK.git

# Verify
ls -la ~/Docs-UK
```

---

## STEP 8: Terminal Colors and Fonts (Optional)

**⏭️ SKIP THIS STEP - DO NOT RUN**

Dircolors-solarized is already configured in ~/.zshrc.local (added during merge from bash/bashrc.local_for_zsh).

**Why skip:**
- Running manual dircolors setup would add duplicate lines to zshrc.local
- Would pollute git diff with unnecessary changes
- Setup is 100% complete in zshrc.local already

**Verify already configured:**
```bash
grep 'dircolors.ansi-dark' ~/.zshrc.local
# Should show: eval "$(dircolors -b ~/software/dircolors-solarized/dircolors.ansi-dark)"
```

**Legacy Information (for reference only, do NOT run these):**
If you need to understand the original manual setup:
```bash
# ❌ DO NOT RUN THESE - Already configured above
# mkdir -p ~/software
# cd ~/software
# git clone https://github.com/seebi/dircolors-solarized
```

**Nerd Font Setup (Alternative to DejaVu):**

For fancy terminal icons and glyphs, install a Nerd Font on Windows:

1. Download from: https://www.nerdfonts.com/font-downloads
2. Extract ZIP file
3. Install to Windows Fonts:
   - Open Settings → Personalization → Fonts
   - Drag and drop all .ttf files into Fonts area
4. Configure Windows Terminal: `"fontFace": "MesloLGS NF"` or chosen font
5. Restart Windows Terminal

**Verify:**
```bash
# Check LS colors
ls --color=auto ~/ | head
```

---

## STEP 9: Install fzf — ⏭️ SKIP THIS STEP - DO NOT RUN

**Do NOT run the fzf installer.**

**Why skip:**
- Zsh already includes fzf via Oh-My-Zsh plugin (enabled by default)
- fzf installer will pollute bash files despite --no-update-rc flag
- Running it adds fzf sourcing to ~/.bashrc even though you don't use bash
- Installer auto-modifications cannot be prevented (breaks tool independence)

**Verify fzf is already working:**
```bash
# Test fzf is available in zsh
echo "test" | fzf --filter "test"  # Should return "test"

# List fzf keybindings
bindkey -l | grep fzf  # Should show fzf entries
```

**Legacy Information (for bash users only, do NOT run for zsh-only setup):**
If you were using bash:
```bash
# ❌ DO NOT RUN - fzf installer is known to pollute files
# mkdir -p ~/software
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/software/fzf
# ln -s ~/software/fzf ~/.fzf
# cd ~/software/fzf
# ./install --no-update-rc  ← installer ignores this flag!
```
- Link fzf configuration

**Legacy for bash users:**
```bash
mkdir -p ~/software
cd ~/software

# Clone latest fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/software/fzf

# Install
ln -sfn ~/software/fzf ~/.fzf
cd ~/.fzf
./install --no-update-rc

# Note: Installer may attempt to modify ~/.bashrc or ~/.zshrc despite --no-update-rc flag
# For bash users: verify ~/.bashrc has fzf sourced
# For zsh users: verify fzf plugin is enabled in ~/.zshrc
```

**Verify:**
```bash
which fzf
fzf --version
```

---

## STEP 10: Clipboard Tools (Optional)

**What will happen:**
- Install optional clipboard utilities for WSL
- Provide Windows Terminal integration examples

**Commands (Optional):**
```bash
# For WSLg/Wayland clipboard support
sudo apt install -y wl-clipboard

# For legacy X11 clipboard
sudo apt install -y xsel
```

**Windows Terminal Integration:**

Windows Terminal natively provides `clip.exe` for clipboard:
```bash
echo "Hello from WSL" | clip.exe  # Copy to Windows clipboard
```

---

## STEP 11: Install Asciidoc (⚠️ SKIP UNLESS NEEDED)

**What will happen:**
- Install asciidoc (text-to-document converter)
- **Only install if you need to convert .asciidoc files to HTML/PDF**
- Not required for standard WSL development

**Commands (Skip this step unless needed):**
```bash
sudo apt update
sudo apt install -y asciidoc
```

**Verify:**
```bash
asciidoc --version
```

---

## STEP 12: Install Mergetool Helper

**What will happen:**
- Download and install diffconflicts merge helper script
- Used by git/gitconfig for merge conflict resolution

**Commands:**
```bash
cd ~/bin

if wget -O diffconflicts https://github.com/whiteinge/dotfiles/raw/master/bin/diffconflicts; then
    chmod +x diffconflicts
    echo "✓ diffconflicts installed"
else
    echo "✗ Failed to download diffconflicts"
    exit 1
fi
```

**Verify:**
```bash
ls -la ~/bin/diffconflicts
file ~/bin/diffconflicts
```

**Usage:**
```bash
# When running git mergetool, diffconflicts handles conflict resolution
git mergetool
```

---

## STEP 13: Install Mosh (Optional)

**What will happen:**
- Install mosh (mobile shell - resilient over unstable connections)

**Commands:**
```bash
sudo apt update
sudo apt install -y mosh
```

**Use Case:**
- Remote connections over WiFi/cellular
- Persistent sessions over network changes

---

## STEP 14: Ensure Executable Permissions for Scripts

**What will happen:**
- Set executable permissions on all scripts in ~/bin

**Commands:**
```bash
chmod +x ~/access-UK/bin/*
```

**Verify:**
```bash
ls -la ~/access-UK/bin/ | head
# Should see 'x' permissions
```

---

## STEP 15: FZF-Related Helper Files

**What will happen:**
- Create tmux buffer directory for fzf integration
- Install inotify-tools for filesystem watching
- Configure fzf helpers for command history/tags

**Commands:**
```bash
mkdir -p ~/tmuxbuffer
touch ~/tmuxbuffer/resultcmdsh

sudo apt update
sudo apt install -y inotify-tools
```

**Helper Functions:**

These are already configured in your dotfiles:

1. **vim/vimfiles/vundle_vimrc**: FZF function search (right side vim)
2. **tmux/tmux.conf**: `prefix + y` shows command tags from cheat sheets
3. **bash/bashrc.local_for_zsh**: `cmdsh` functions use fzf-tmux

**Setup Cheat Sheet Index:**

If using Docs-UK:
```bash
# Populate ~/Docs-UK/txtfiles.txt with file references
# Then tmux prefix+y will search these files via fzf
```

---

## STEP 16: Noip Dynamic DNS (Optional)

**What will happen:**
- Install noip dynamic DNS updater (optional)

**Use Case:**
- Update DNS records from home/lab servers
- Typically not needed for WSL office/dev usage

**Installation (if needed):**
```bash
sudo apt update
sudo apt install -y noip2
```

---

## STEP 17: Vim Legacy Plugins (Optional)

**What will happen:**
- Reference legacy Vim plugin setup from original README

**Note:**
- Unite.vim and vimproc are legacy/optional
- Use only if maintaining old Vim workflow
- Neovim is recommended instead (STEP 19)

---

## STEP 18: Install Python Base Toolchain

**What will happen:**
- Install Python 3, pip, venv
- Optionally install uv (fast Python package manager)

**Commands:**
```bash
sudo apt update
sudo apt install -y python3 python3-pip python3-venv

# Optional: Install uv (modern Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Verify:**
```bash
python3 --version
pip3 --version
```

---

## STEP 19: Neovim Setup (NvChad Only)

**What will happen:**
- Install latest Neovim from GitHub releases
- Install NvChad configuration (recommended single path)
- Install Mason for LSP/formatter/linter management

**Backups created:**
```bash
cp -r ~/.config/nvim ~/.config/nvim.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
```

**Commands:**
```bash
mkdir -p ~/software
cd ~/software
sudo apt remove -y neovim || true
sudo apt install -y curl tar jq ripgrep python3-pip clangd nodejs npm

# Install globally required tools
sudo npm install -g pyright

# Get latest Neovim release with error handling
# Check if jq is available for version parsing
if ! command -v jq &> /dev/null; then
    echo "Warning: jq not found. Using Neovim v0.9.0 fallback"
    NVIM_TAG="v0.9.0"
else
    NVIM_TAG=$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest 2>/dev/null | jq -r '.tag_name' 2>/dev/null || echo "")
    if [ -z "$NVIM_TAG" ]; then
        echo "Failed to fetch Neovim version. Using v0.9.0"
        NVIM_TAG="v0.9.0"
    fi
fi
echo "Installing Neovim: $NVIM_TAG"

NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_TAG}/nvim-linux-x86_64.tar.gz"
curl -fLO "$NVIM_URL" || { echo "Failed to download Neovim"; exit 1; }
tar xzf nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo mv nvim-linux-x86_64 /opt/nvim
# Create symlink with -n flag for idempotency (no-dereference)
sudo ln -sfn /opt/nvim/bin/nvim /usr/local/bin/nvim
```

**Install NvChad Configuration (Recommended):**
```bash
mv ~/.config/nvim ~/.config/oldnvim 2>/dev/null || true
mkdir -p ~/software/nvimcfg
git clone https://github.com/shaakaud/starter ~/software/nvimcfg/starter
ln -sfn ~/software/nvimcfg/starter ~/.config/nvim
```

**Post-Installation (in Neovim):**
```
:MasonInstallAll
```

**Key Notes:**
- lazy.nvim and Mason pre-configured in NvChad
- Use `:Lazy` and `:Mason` inside nvim
- Single configuration path (NvChad only, not multiple alternatives)

**Verify:**
```bash
which nvim
nvim --version | head -n 1
nvim -c ":MasonInstallAll | quit"
```

---

## STEP 20: WSLg GUI Apps (⚠️ SKIP UNLESS NEEDED)

**What will happen:**
- Install optional GUI applications for WSL GUI (WSLg)
- **NOT REQUIRED for standard development workflow**
- Only install if you specifically need graphical applications in WSL

**SKIP THIS STEP** unless you need to run GUI applications from Linux in WSL.

**If you need GUI apps, proceed with:**
```bash
# Update WSL components from Windows PowerShell (run on Windows, not WSL)
wsl --update
wsl --shutdown
```

**Optional: Install GUI Applications (Skip unless needed):**
```bash
sudo apt update
sudo apt install -y gnome-text-editor x11-apps nautilus
```

**Test WSLg:**
```bash
xeyes  # Should open X11 window
```

**Example GUI Apps:**
- `gnome-text-editor` - Text editor
- `nautilus` - File manager
- `x11-apps` - X11 utilities (xeyes, xcalc, etc.)

---

## STEP 21: Sharing Files with Windows

**What will happen:**
- Enable file sharing between WSL and Windows

**Access WSL Files from Windows:**
```
\\wsl$  in Windows Explorer
```

**Recommendation:**
- Do NOT setup Samba inside WSL for normal file sharing
- \\wsl$ integration is built-in and sufficient

---

## STEP 22: Workspace Helper

**What will happen:**
- Configure pwd.sh helper for workspace navigation
- Setup aliases for quick folder access

**Commands:**
```bash
source ~/.zshrc
source ~/bin/pwd.sh
```

**Usage:**
- `pwd.sh` stores current directory in `$WS` variable
- `base` alias (from aliases_bash) returns to `$WS`
- Quick workspace navigation

---

## STEP 23: DISPLAY/X11 Note

**Important for WSLg:**

On modern Windows 11 WSLg:
- Do **NOT** manually set `DISPLAY=localhost:0.0`
- WSLg handles DISPLAY automatically
- Only use manual DISPLAY for old non-WSLg setups with X server

---

## STEP 24: GitHub Copilot CLI (Optional)

**What will happen:**
- Install GitHub CLI (gh)
- Install Copilot extension for CLI
- Setup command aliases

**Commands:**
```bash
sudo apt update
sudo apt install -y gh

# Authenticate with GitHub
gh auth login

# Install Copilot extension
gh extension install github/gh-copilot

# Setup aliases for your shell
gh copilot alias -- zsh > ~/.gh-copilot-aliases.zsh
```

**Usage:**
```bash
# `ask` and `explain` commands now available
ask "how to list files recursively"
explain "find . -type f -name '*.txt'"
```

**Verify:**
```bash
gh --version
gh extension list
```

---

## STEP 25: Claude Code Config (Optional)

**What will happen:**
- Link Claude Code editor configuration
- Backup existing config if present

**Backups created:**
```bash
cp -r ~/.claude ~/.claude.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
```

**Commands:**
```bash
ln -sfn ~/access-UK/claude/settings.json ~/.claude/settings.json
ln -sfn ~/access-UK/claude/CLAUDE.md ~/.claude/CLAUDE.md
```

**Verify:**
```bash
ls -la ~/.claude/
cat ~/.claude/settings.json
```

---

## STEP 26: Verify All Symlinks

**What will happen:**
- Verify all critical symlinks are properly created

**Command:**
```bash
pwd
/home/youruser
```

**Expected Output:**
```bash
ls -lart ~ | grep -E "bashrc|zshrc|gitconfig|tmux|bin"
```

Should show:
```
lrwxrwxrwx ... .bashrc -> ~/.bashrc
lrwxrwxrwx ... .zshrc -> ~/.zshrc
lrwxrwxrwx ... .gitconfig -> ~/.gitconfig
lrwxrwxrwx ... .tmux.conf -> ~/.tmux.conf
lrwxrwxrwx ... bin -> ~/access-UK/bin
```

**Troubleshooting:**
- If symlinks missing: Re-run respective STEP commands
- If symlinks point to wrong location: Remove and recreate with `-sfn` flags

---

## STEP 27: Azure + C# + Go Setup (Optional)

**What will happen:**
- Install Azure CLI and azd
- Install .NET SDK 8 for C# development
- Install Go toolchain
- Install optional Kubernetes tools

**Azure Tools:**
```bash
# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Azure Developer CLI
curl -fsSL https://aka.ms/install-azd.sh | bash
```

**.NET SDK 8:**
```bash
wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt update
sudo apt install -y dotnet-sdk-8.0
```

**Go Toolchain:**
```bash
sudo apt update
sudo apt install -y golang-go

# Go development tools
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

**Kubernetes Tools (Optional):**
```bash
sudo apt update
sudo apt install -y kubectl

# Install Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

**Azure Login (Optional):**
```bash
# Optional: Login to Azure if using Azure services
# az login
# az account set --subscription <your-subscription>
# az account show

echo "✓ Azure tools installed. Run 'az login' if you need Azure access."
```

**Verify:**
```bash
az --version
azd version
dotnet --version
dotnet --list-sdks
go version
kubectl version --client
```

---

## Additional Setup Details

### Zsh README Details

Additional setup from [zsh/README](zsh/README):

**Git Completion:**
```bash
mkdir -p ~/software
cd ~/software
curl -L https://github.com/git/git/raw/master/contrib/completion/git-completion.zsh -OL
cd ~/
ln -sfn ~/software/git-completion.zsh git-completion.zsh
```

**Autojump (Directory Navigation):**
```bash
cd ~/software
git clone https://github.com/wting/autojump.git
cd autojump
./install.py
# Installs to ~/.autojump/etc/profile.d/autojump.sh
# zshrc already sources this if installed
```

**Git Binary Verification:**
```bash
# If git status issues in prompt:
cd ~/access-UK/zsh/zsh-git-prompt
# Edit gitstatus.py and verify git binary path matches:
type git
# Example: gitbinary='/usr/bin/git'
```

---

## Items Intentionally Skipped from Old CentOS README

- Old CentOS/yum/epel specific commands
- Parcellite clipboard manager on Linux desktop
- Samba server setup inside WSL
- VNC server and full ubuntu-desktop setup inside WSL
- Manual DISPLAY export for modern WSLg environments
- Legacy percol flow (replaced by fzf)
- Legacy Vundle patching flow unless keeping old Vim path

---

## Maintenance: Keeping README.WSL and Agent in Sync

**Future Architecture (Single Source of Truth for WSL):**

README.WSL is the source of truth for WSL setup. When README.WSL is updated,
update agents/WSL_DEV_SETUP/agent.md in the same change.

**Workflow:**
1. Edit README.WSL with your changes.
2. Update agents/WSL_DEV_SETUP/agent.md manually to match.
3. Review both files together with git diff.
4. Commit both files together.

**For Future Linux/Ubuntu Direct Setup:**

Keep the same manual pattern for other setup docs:
- Add markers: `<!-- WSL ONLY -->`, `<!-- LINUX ONLY -->`, `<!-- ALL -->`
- Agent intelligently shows context-specific instructions
- One documentation source for all deployment scenarios

---

## Agent Usage

**In VS Code Copilot Chat:**
```
@wsl_dev_setup Please guide me through WSL setup
```

**Agent Features:**
- Per-step approval and feedback
- Error recovery with troubleshooting
- Progress tracking across sessions
- Logs saved to: `~/access-UK/.wsl_setup_logs/wsl_setup.<timestamp>.log`

---

## Coverage Checklist from Original README

✓ SSH clone, Vim, Bash, Zsh, dotfiles (netrc/screen/inputrc/gdbinit)
✓ Git, Tmux, Docs-UK, Solarized/dircolors, fzf
✓ Clipboard tools (wl-clipboard, xsel), asciidoc
✓ Diffconflicts mergetool, Mosh, executable bits
✓ NoIP DNS, Vim plugins, Terminal fonts
✓ Neovim (NvChad only, single path), Fugitive/git integration
✓ Python, GitHub Copilot CLI, Claude Code config
✓ pwd.sh workspace helper, Azure/C#/Go setup
✓ WSLg GUI apps and Windows file sharing

---

**Last Updated:** 2026-07-25
**Format:** Markdown with structured steps for agent parsing
