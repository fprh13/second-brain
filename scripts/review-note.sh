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

ensure_frontmatter_key() {
  local file="$1"
  local key="$2"
  local default_value="${3-}"

  if awk -v target="$key:" '
    BEGIN { in_frontmatter = 0; found = 0 }
    /^---$/ && in_frontmatter == 0 { in_frontmatter = 1; next }
    /^---$/ && in_frontmatter == 1 { exit found ? 0 : 1 }
    in_frontmatter == 1 && index($0, target) == 1 { found = 1 }
    END { if (in_frontmatter == 1 && found == 0) exit 1 }
  ' "$file"; then
    return
  fi

  local tmp_file
  tmp_file="$(mktemp)"
  awk -v key="$key" -v value="$default_value" '
    BEGIN { inserted = 0; in_frontmatter = 0 }
    /^---$/ && in_frontmatter == 0 { in_frontmatter = 1; print; next }
    /^---$/ && in_frontmatter == 1 && inserted == 0 {
      print key ": " value
      inserted = 1
      print
      next
    }
    { print }
  ' "$file" > "$tmp_file"
  mv "$tmp_file" "$file"
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
type_value="$(awk -F': ' '/^type:/ { print $2; exit }' "$NOTE_PATH")"
link_count="$(rg -o '\[\[[^]]+\]\]' "$NOTE_PATH" | wc -l | tr -d ' ')"
moc_candidate="$(awk -F': ' '/^moc_candidate:/ { print $2; exit }' "$NOTE_PATH")"
moc_decision="$(awk -F': ' '/^moc_decision:/ { print $2; exit }' "$NOTE_PATH")"
needs_moc_review="$(awk -F': ' '/^needs_moc_review:/ { print $2; exit }' "$NOTE_PATH")"

ready_to_apply="true"
checks_passed=()
issues=()
missing_fields=()
link_gaps=()
moc_status="skipped"
moc_reason="MOC 검토가 필요하지 않거나 아직 후보가 없음"

if [[ -n "$title" ]]; then
  checks_passed+=("title_present")
else
  issues+=("missing_title")
  ready_to_apply="false"
fi

if [[ -n "$type_value" ]]; then
  checks_passed+=("type_present")
else
  missing_fields+=("type")
  ready_to_apply="false"
fi

if [[ "$link_count" -gt 0 ]]; then
  checks_passed+=("has_internal_links")
else
  link_gaps+=("no_internal_links")
fi

if [[ -n "$moc_decision" ]]; then
  checks_passed+=("moc_tracking_present")
else
  missing_fields+=("moc_decision")
fi

if [[ "${needs_moc_review:-}" == "true" ]]; then
  moc_status="needs_review"
  moc_reason="MOC 검토가 아직 열려 있음"
fi

if [[ -n "${moc_candidate:-}" && "${moc_decision:-}" == "linked" ]]; then
  moc_status="linked"
  moc_reason="기존 MOC 연결이 확정됨"
fi

if [[ "${moc_decision:-}" == "skipped" ]]; then
  moc_status="skipped"
  moc_reason="적합한 기존 MOC가 없거나 연결을 보류함"
fi

if [[ "$APPLY_MODE" == "true" ]]; then
  ensure_frontmatter_key "$NOTE_PATH" "moc_decision" "pending"
  ensure_frontmatter_key "$NOTE_PATH" "needs_moc_review" "true"

  frontmatter_moc_decision="pending"
  if [[ "$moc_status" == "linked" ]]; then
    frontmatter_moc_decision="linked"
  elif [[ "$moc_status" == "skipped" ]]; then
    frontmatter_moc_decision="skipped"
  fi

  set_frontmatter_value "$NOTE_PATH" "moc_decision" "$frontmatter_moc_decision"
  if [[ "$moc_status" == "linked" ]]; then
    set_frontmatter_value "$NOTE_PATH" "needs_moc_review" "false"
  else
    set_frontmatter_value "$NOTE_PATH" "needs_moc_review" "true"
  fi
fi

echo "review:"
echo "  checks_passed:"
if [[ ${#checks_passed[@]} -eq 0 ]]; then
  echo "    - none"
else
  for item in "${checks_passed[@]}"; do
    echo "    - $item"
  done
fi

echo "  issues:"
if [[ ${#issues[@]} -eq 0 ]]; then
  echo "    - none"
else
  for item in "${issues[@]}"; do
    echo "    - $item"
  done
fi

echo "  missing_fields:"
if [[ ${#missing_fields[@]} -eq 0 ]]; then
  echo "    - none"
else
  for item in "${missing_fields[@]}"; do
    echo "    - $item"
  done
fi

echo "  link_gaps:"
if [[ ${#link_gaps[@]} -eq 0 ]]; then
  echo "    - none"
else
  for item in "${link_gaps[@]}"; do
    echo "    - $item"
  done
fi

echo "  moc_review_result:"
echo "    status: $moc_status"
echo "    selected_moc: ${moc_candidate:-}"
echo "    reason: $moc_reason"
echo "  ready_to_apply: $ready_to_apply"
echo "apply_mode: $APPLY_MODE"
