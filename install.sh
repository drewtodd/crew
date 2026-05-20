#!/usr/bin/env bash
# Install Drew's dev crew into ~/.claude/
# Symlinks agents and skills so updates to this repo are live immediately.
set -euo pipefail

CREW_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing crew from: $CREW_DIR"
echo "Installing to:        $CLAUDE_DIR"
echo

# Ensure target dirs exist
mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/skills"

# --- CLAUDE.md ---
if [ -f "$CLAUDE_DIR/CLAUDE.md" ] && [ ! -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  echo "WARNING: ~/.claude/CLAUDE.md exists and is not a symlink. Backing up to CLAUDE.md.bak"
  mv "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak"
fi
ln -sf "$CREW_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "✓ CLAUDE.md"

# --- Agents ---
count=0
for f in "$CREW_DIR/agents/"*.md; do
  [ -f "$f" ] || continue
  name="$(basename "$f")"
  ln -sf "$f" "$CLAUDE_DIR/agents/$name"
  count=$((count + 1))
done
echo "✓ $count agents"

# --- Skills ---
count=0
for d in "$CREW_DIR/skills/"/*/; do
  [ -d "$d" ] || continue
  name="$(basename "$d")"
  # Remove existing symlink or warn about directory
  if [ -d "$CLAUDE_DIR/skills/$name" ] && [ ! -L "$CLAUDE_DIR/skills/$name" ]; then
    echo "WARNING: ~/.claude/skills/$name is a real directory, skipping"
    continue
  fi
  ln -sfn "$d" "$CLAUDE_DIR/skills/$name"
  count=$((count + 1))
done
echo "✓ $count skills"

echo
echo "Crew installed. Open a new Claude Code session to pick up the changes."
