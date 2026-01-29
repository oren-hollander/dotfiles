# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository containing configuration files for Neovim, WezTerm, tmux, and Starship prompt. The `bootstrap.sh` script symlinks configs from this repo into `~/.config`.

## Commands

### Installation
```bash
./bootstrap.sh                  # Link all configs to ~/.config and ~/.tmux.conf
./bootstrap.sh --no-tmux-compat # Skip creating ~/.tmux.conf symlink
```

Existing files are backed up to `~/.dotfiles-backup-YYYYmmddHHMMSS`.

### Validation (no automated tests)
- **Neovim**: Open `nvim` and check for startup errors
- **WezTerm**: Config auto-reloads; confirm no errors on launch
- **tmux**: Run `tmux source-file ~/.config/tmux/tmux.conf` to reload

## Project Structure

```
.config/
├── nvim/
│   ├── init.lua           # Entry point: sets leader keys, loads config modules
│   ├── lazy-lock.json     # Plugin lockfile (lazy.nvim)
│   └── lua/
│       ├── config/        # Core Neovim behavior
│       │   ├── lazy.lua   # Plugin manager bootstrap
│       │   ├── options.lua
│       │   ├── keymaps.lua
│       │   └── autocmds.lua
│       └── plugins/       # Plugin specs (lazy.nvim format)
│           ├── lsp.lua
│           ├── dap.lua
│           ├── editor.lua
│           ├── formatting.lua
│           └── ui.lua
├── wezterm/
│   └── wezterm.lua
├── tmux/
│   └── tmux.conf
└── starship.toml
```

## Coding Style

- **Indentation**: 2 spaces in Lua and shell scripts
- **Strings**: Prefer double quotes in Lua
- **Commits**: Short imperative summaries (e.g., "Add dotfiles configs"), one tool per commit when possible
- **Paths**: Avoid hard-coding machine-specific paths; call them out in PR descriptions if unavoidable
