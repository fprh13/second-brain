#!/usr/bin/env bash

set -euo pipefail

APPLY_MODE="false"

usage() {
  echo "Usage: $(basename "$0") [--apply] <note-path>" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      APPLY_MODE="true"
      shift
      ;;
    -*)
      usage
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -ne 1 ]]; then
  usage
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NOTE_INPUT="$1"

if [[ "$NOTE_INPUT" = /* ]]; then
  NOTE_PATH="$NOTE_INPUT"
else
  NOTE_PATH="$ROOT_DIR/$NOTE_INPUT"
fi

if [[ ! -f "$NOTE_PATH" ]]; then
  echo "Note not found: $NOTE_INPUT" >&2
  exit 1
fi

get_frontmatter_value() {
  local file="$1"
  local key="$2"
  awk -F': ' -v target="$key" '
    BEGIN { in_frontmatter = 0 }
    /^---$/ && in_frontmatter == 0 { in_frontmatter = 1; next }
    /^---$/ && in_frontmatter == 1 { exit }
    in_frontmatter == 1 && $1 == target {
      sub("^" target ": ?", "", $0)
      print $0
      exit
    }
  ' "$file"
}

set_frontmatter_value() {
  local file="$1"
  local key="$2"
  local value="$3"
  local tmp_file
  tmp_file="$(mktemp)"
  awk -v key="$key" -v value="$value" '
    BEGIN { in_frontmatter = 0 }
    /^---$/ && in_frontmatter == 0 { in_frontmatter = 1; print; next }
    /^---$/ && in_frontmatter == 1 { in_frontmatter = 2; print; next }
    in_frontmatter == 1 && index($0, key ":") == 1 { print key ": " value; next }
    { print }
  ' "$file" > "$tmp_file"
  mv "$tmp_file" "$file"
}

title="$(awk '/^# / { sub(/^# /, ""); print; exit }' "$NOTE_PATH")"
recommended_type="$(get_frontmatter_value "$NOTE_PATH" "recommended_type")"
recommended_folder="$(get_frontmatter_value "$NOTE_PATH" "recommended_folder")"
recommended_title="$(get_frontmatter_value "$NOTE_PATH" "recommended_title")"
recommended_project_folder="$(get_frontmatter_value "$NOTE_PATH" "recommended_project_folder")"

if [[ -z "$recommended_type" || -z "$recommended_folder" ]]; then
  echo "Missing recommended_type or recommended_folder. Run triage-note.sh --apply first." >&2
  exit 1
fi

final_title="${recommended_title:-${title:-Untitled}}"
target_dir="$ROOT_DIR/$recommended_folder"
target_path="$target_dir/$final_title.md"
move_mode="move"

if [[ "$recommended_type" == "project" ]]; then
  if [[ -z "$recommended_project_folder" ]]; then
    echo "Missing recommended_project_folder for project note." >&2
    exit 1
  fi
  target_dir="$ROOT_DIR/$recommended_project_folder"
  target_path="$target_dir/$final_title.md"
fi

if [[ "$NOTE_PATH" == "$target_path" ]]; then
  move_mode="noop"
fi

echo "promotion:"
echo "  source: ${NOTE_PATH#$ROOT_DIR/}"
echo "  recommended_type: $recommended_type"
echo "  target_dir: ${target_dir#$ROOT_DIR/}"
echo "  target_path: ${target_path#$ROOT_DIR/}"
echo "  mode: $move_mode"
echo "  apply_mode: $APPLY_MODE"

if [[ "$APPLY_MODE" != "true" ]]; then
  exit 0
fi

mkdir -p "$target_dir"

if [[ "$move_mode" != "noop" ]]; then
  if [[ -e "$target_path" ]]; then
    echo "Target already exists: ${target_path#$ROOT_DIR/}" >&2
    exit 1
  fi
  mv "$NOTE_PATH" "$target_path"
  NOTE_PATH="$target_path"
fi

set_frontmatter_value "$NOTE_PATH" "type" "$recommended_type"

case "$recommended_type" in
  project)
    set_frontmatter_value "$NOTE_PATH" "status" "active"
    ;;
  permanent)
    set_frontmatter_value "$NOTE_PATH" "status" "evergreen"
    ;;
  resource)
    set_frontmatter_value "$NOTE_PATH" "status" "reference"
    ;;
  area)
    set_frontmatter_value "$NOTE_PATH" "status" "active"
    ;;
esac

echo "applied:"
echo "  final_path: ${NOTE_PATH#$ROOT_DIR/}"
