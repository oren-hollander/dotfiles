#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_COMPAT=1

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [--no-tmux-compat]

Creates symlinks from this repo into ~/.config (and ~/.tmux.conf by default).
Existing files are moved into a timestamped backup directory.
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--no-tmux-compat" ]]; then
  TMUX_COMPAT=0
fi

BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"

resolve_path() {
  local path="$1"
  local dir
  local base

  dir="$(dirname "$path")"
  base="$(basename "$path")"

  if [[ -d "$dir" ]]; then
    dir="$(cd "$dir" && pwd -P)"
  fi

  echo "$dir/$base"
}

backup_if_needed() {
  local dest="$1"
  local src="$2"

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest")"
    if [[ "$current" == "$src" ]]; then
      echo "ok: $dest -> $src"
      return 0
    fi
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    echo "backup: $dest -> $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/"
  fi
}

link() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    echo "missing: $src"
    return 1
  fi

  mkdir -p "$(dirname "$dest")"

  local src_real
  local dest_real
  src_real="$(resolve_path "$src")"
  dest_real="$(resolve_path "$dest")"
  if [[ "$src_real" == "$dest_real" ]]; then
    echo "skip: $dest resolves to $src"
    return 0
  fi

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest")"
    if [[ "$current" == "$src" ]]; then
      echo "ok: $dest -> $src"
      return 0
    fi
  fi

  backup_if_needed "$dest" "$src"
  ln -s "$src" "$dest"
  echo "link: $dest -> $src"
}

link "$DOTFILES_DIR/.config/wezterm" "$HOME/.config/wezterm"
link "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
link "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES_DIR/.config/tmux" "$HOME/.config/tmux"

if [[ "$TMUX_COMPAT" -eq 1 ]]; then
  link "$DOTFILES_DIR/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
fi
