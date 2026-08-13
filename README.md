# access-UK: WSL Ubuntu Development Environment

Personal dotfiles and setup scripts for a WSL Ubuntu development
environment (zsh, tmux, neovim, git, Go, Azure, and more).

## Full setup guide

The complete, authoritative step-by-step guide lives in
**[README.WSL](README.WSL)** — that is the single source of truth for
all setup commands, backups, verification, and troubleshooting.

## Interactive setup (recommended)

A VS Code Copilot agent walks you through README.WSL with per-step
approval and error recovery. It is committed at
[.github/agents/wsl_dev_setup.agent.md](.github/agents/wsl_dev_setup.agent.md),
so VS Code discovers it automatically — no symlink or manual setup.

1. Clone the repo:
   ```bash
   git clone git@github.com:shaakaud/access-UK.git ~/access-UK
   ```
2. Open it in VS Code (Remote - WSL):
   ```bash
   cd ~/access-UK && code .
   ```
3. Open Copilot Chat, use the agent/mode picker, and select
   `wsl_dev_setup` (reload the window if it does not appear yet).
4. Ask it to begin; it drives the rest of README.WSL interactively.

Logs are saved to `~/access-UK/.wsl_setup_logs/`.

## What gets installed

Zsh + Oh-My-Zsh, tmux, Neovim (NvChad), Git + gh CLI, fzf, Python,
Go, .NET SDK, Azure CLI + azd, DejaVu fonts, and assorted helper
scripts. See [README.WSL](README.WSL) for the exact steps and which
are optional or skipped.

## Maintenance

README.WSL is the source of truth. When setup steps change, update
[.github/agents/wsl_dev_setup.agent.md](.github/agents/wsl_dev_setup.agent.md)
in the same change so the agent stays in sync. No sync script is used.
