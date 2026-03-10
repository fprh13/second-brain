#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_dirs=(
  "00 Inbox"
  "01 Permanent"
  "02 MOCs"
  "10 Projects"
  "11 Areas"
  "12 Resources"
  "13 Archive"
  "14 Templates"
  "attachments"
  "skills"
)

echo "== Git Status =="
git -C "$ROOT_DIR" status --short
echo

echo "== Root Directories =="
for dir in "${required_dirs[@]}"; do
  if [[ -d "$ROOT_DIR/$dir" ]]; then
    printf '[ok] %s\n' "$dir"
  else
    printf '[missing] %s\n' "$dir"
  fi
done
echo

echo "== TODO / FIXME =="
if rg -n "TODO|FIXME" \
  "$ROOT_DIR/README.md" \
  "$ROOT_DIR/AGENTS.md" \
  "$ROOT_DIR/AGENT_KOR.md" \
  "$ROOT_DIR/workflow.md" \
  "$ROOT_DIR/skills"; then
  true
else
  echo "No TODO/FIXME markers found."
fi
echo

echo "== MOC Tracking Fields =="
if rg -n "moc_candidate|moc_decision|needs_moc_review" \
  "$ROOT_DIR/14 Templates" \
  "$ROOT_DIR/00 Inbox" \
  "$ROOT_DIR/01 Permanent" \
  "$ROOT_DIR/10 Projects" \
  "$ROOT_DIR/12 Resources"; then
  true
else
  echo "No MOC tracking fields found."
fi
echo

echo "== Reviewer Schema =="
if rg -n "moc_review_result|primary_moc_candidate" \
  "$ROOT_DIR/workflow.md" \
  "$ROOT_DIR/skills"; then
  true
else
  echo "Reviewer schema keys not found."
fi
