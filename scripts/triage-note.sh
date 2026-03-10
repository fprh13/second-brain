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

TITLE="$(awk '
  /^# / { sub(/^# /, ""); print; exit }
' "$NOTE_PATH")"

CONTENT="$(cat "$NOTE_PATH")"

recommended_type="resource"
recommended_folder="12 Resources"
reason="외부 자료 또는 일반 정리 메모로 해석됨"
confidence="medium"
recommended_project_folder=""

if printf '%s' "$CONTENT" | rg -qi "^type: project$|^deadline:|^repo:|^## 다음 액션$|^## 진행 메모$|^기간:|^인원:|^담당 업무:|^기술 스택:"; then
  recommended_type="project"
  recommended_folder="10 Projects"
  project_name="${TITLE:-Untitled Project}"
  recommended_project_folder="10 Projects/$project_name"
  reason="프로젝트 운영 정보나 기간/역할/기술 스택 정보가 포함됨"
  confidence="high"
elif printf '%s' "$CONTENT" | rg -qi "정의|개념|원리|패턴|왜 중요한지|핵심 주장"; then
  recommended_type="permanent"
  recommended_folder="01 Permanent"
  reason="장기적으로 재사용 가능한 개념 지식 성격이 강함"
  confidence="medium"
elif printf '%s' "$CONTENT" | rg -qi "source_url:|source_type:|문서|아티클|레퍼런스|참고"; then
  recommended_type="resource"
  recommended_folder="12 Resources"
  reason="출처 기반 정리나 참고 자료 성격이 강함"
  confidence="medium"
elif printf '%s' "$CONTENT" | rg -qi "운영|책임|지속 관리|루틴"; then
  recommended_type="area"
  recommended_folder="11 Areas"
  reason="종료 시점이 없는 관리 영역 성격이 강함"
  confidence="medium"
fi

moc_candidates=()
while IFS= read -r line; do
  moc_candidates+=("$line")
done < <(
  find "$ROOT_DIR/02 MOCs" -type f -name '*.md' 2>/dev/null \
    | sed "s|$ROOT_DIR/||" \
    | sort \
    | head -n 20
)

primary_moc_candidate=""
if [[ ${#moc_candidates[@]} -gt 0 ]]; then
  primary_moc_candidate="[[${moc_candidates[0]%.md}]]"
fi

if [[ "$APPLY_MODE" == "true" ]]; then
  ensure_frontmatter_key "$NOTE_PATH" "recommended_type"
  ensure_frontmatter_key "$NOTE_PATH" "recommended_folder"
  ensure_frontmatter_key "$NOTE_PATH" "recommended_title"
  ensure_frontmatter_key "$NOTE_PATH" "recommended_project_folder"
  ensure_frontmatter_key "$NOTE_PATH" "confidence"
  ensure_frontmatter_key "$NOTE_PATH" "classifier"
  ensure_frontmatter_key "$NOTE_PATH" "moc_candidate"

  set_frontmatter_value "$NOTE_PATH" "classifier" "triage-note.sh"
  set_frontmatter_value "$NOTE_PATH" "recommended_type" "$recommended_type"
  set_frontmatter_value "$NOTE_PATH" "recommended_folder" "$recommended_folder"
  set_frontmatter_value "$NOTE_PATH" "recommended_title" "${TITLE:-Untitled}"
  set_frontmatter_value "$NOTE_PATH" "recommended_project_folder" "$recommended_project_folder"
  set_frontmatter_value "$NOTE_PATH" "confidence" "$confidence"
  set_frontmatter_value "$NOTE_PATH" "moc_candidate" "$primary_moc_candidate"
fi

echo "classification:"
echo "  recommended_type: $recommended_type"
echo "  recommended_folder: $recommended_folder"
if [[ -n "$recommended_project_folder" ]]; then
  echo "  recommended_project_folder: $recommended_project_folder"
fi
echo "  recommended_title: ${TITLE:-Untitled}"
echo "  confidence: $confidence"
echo "  reason: $reason"
echo
echo "moc_candidates:"
if [[ ${#moc_candidates[@]} -eq 0 ]]; then
  echo "  - none"
else
  for moc in "${moc_candidates[@]}"; do
    echo "  - [[${moc%.md}]]"
  done
fi
echo
echo "apply_mode: $APPLY_MODE"
