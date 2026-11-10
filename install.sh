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

# Claude Code follows @imports, so each machine keeps its own CLAUDE.md for
# machine-specific notes and imports the shared rules from this repo.
import_claude_md() {
  file=$1/CLAUDE.md
  line="@$repo/CLAUDE.md"
  if [ -L "$file" ] && [ "$(readlink "$file")" = "$repo/CLAUDE.md" ]; then
    rm "$file"
  fi
  if [ -f "$file" ] && grep -qxF "$line" "$file"; then
    return 0
  fi
  if [ -e "$file" ] || [ -L "$file" ]; then
    mkdir -p "$backup"
    cp -P "$file" "$backup/$(printf '%s' "${file#"$HOME"/}" | tr / _ | sed 's/^\.//')"
    { printf '%s\n\n' "$line"; cat "$file"; } > "$file.tmp.$$"
  else
    printf '%s\n' "$line" > "$file.tmp.$$"
  fi
  mv "$file.tmp.$$" "$file"
  echo "added shared rules import to $file"
}

install_skills() {
  home=$1
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
}

claude_home=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
codex_home=${CODEX_HOME:-$HOME/.codex}
install_skills "$claude_home"
install_skills "$codex_home"
if [ -d "$claude_home" ]; then
  import_claude_md "$claude_home"
fi
if [ -d "$codex_home" ]; then
  link "$repo/CLAUDE.md" "$codex_home/AGENTS.md"
fi
