# Repository Guidelines

## Project Structure & Module Organization
This repo is a small dotfiles collection. The root `bootstrap.sh` script creates
symlinks into `~/.config` and (optionally) `~/.tmux.conf`. Tool configs live
under `.config/`, for example:
- `.config/nvim/` Neovim config (Lua modules in `lua/config/` and `lua/plugins/`).
- `.config/wezterm/wezterm.lua` WezTerm config.
- `.config/tmux/tmux.conf` tmux config.
- `.config/starship.toml` Starship prompt config.

## Build, Test, and Development Commands
There is no build step. Use the bootstrap script to install symlinks:
- `./bootstrap.sh` link all configs to `~/.config` and `~/.tmux.conf`, backing up
  existing files to `~/.dotfiles-backup-YYYYmmddHHMMSS`.
- `./bootstrap.sh --no-tmux-compat` skip creating the `~/.tmux.conf` symlink.

## Coding Style & Naming Conventions
- Indentation: 2 spaces in Lua and shell scripts.
- Strings: prefer double quotes in Lua to match existing configs.
- Files: keep tool configs in `.config/<tool>/`; Neovim modules belong in
  `lua/config/` (core behavior) or `lua/plugins/` (plugin specs).
- Keep changes focused to one tool per commit when possible.

## Testing Guidelines
There are no automated tests. Validate changes manually:
- Neovim: open `nvim` and check startup for errors.
- WezTerm: config reloads automatically; confirm no errors on launch.
- tmux: run `tmux source-file ~/.config/tmux/tmux.conf` to reload.

## Commit & Pull Request Guidelines
Commit messages use short, imperative summaries (e.g., "Add dotfiles configs").
For PRs, include a brief description of what changed, why it changed, and any
manual verification you performed. Add screenshots only if UI behavior changes.

## Configuration Notes
Avoid hard-coding machine-specific paths unless required; if unavoidable, call
them out in the PR description (e.g., background image paths in WezTerm).
