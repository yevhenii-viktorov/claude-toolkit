#!/bin/sh
# Link this repo's skills and CLAUDE.md into Claude Code and Codex.
# Safe to re-run: correct links are kept, anything else in the way is moved to a backup folder.
set -eu

repo=$(cd "$(dirname "$0")" && pwd)
if [ -d "$HOME/.Trash" ]; then backup_root="$HOME/.Trash"; else backup_root="$HOME/.local/share/claude-toolkit-backups"; fi
backup="$backup_root/claude-toolkit-replaced-$(date +%Y%m%d-%H%M%S)"

link() {
  src=$1
  dest=$2
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return 0
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$backup"
    mv "$dest" "$backup/$(printf '%s' "${dest#"$HOME"/}" | tr / _ | sed 's/^\.//')"
    echo "moved old $dest to $backup"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "linked $dest"
}

install_into() {
  home=$1
  instructions=$2
  if [ ! -d "$home" ]; then
    return 0
  fi
  for skill in "$repo"/skills/*/; do
    name=$(basename "$skill")
    link "$repo/skills/$name" "$home/skills/$name"
  done
  for entry in "$home"/skills/*; do
    if [ -L "$entry" ] && [ ! -e "$entry" ]; then
      case $(readlink "$entry") in
        "$repo"/*) rm "$entry" && echo "removed stale $entry" ;;
      esac
    fi
  done
  link "$repo/CLAUDE.md" "$home/$instructions"
}

install_into "${CLAUDE_CONFIG_DIR:-$HOME/.claude}" CLAUDE.md
install_into "${CODEX_HOME:-$HOME/.codex}" AGENTS.md
