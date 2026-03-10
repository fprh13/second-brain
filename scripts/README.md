# Scripts

이 디렉터리는 볼트 운영을 보조하는 작은 셸 스크립트를 둔다.

## 원칙
- 기본은 읽기 전용 점검과 추천 출력에 집중한다.
- 자동 이동, 리네임, MOC 삽입 같은 구조 변경은 스크립트 기본 동작에 넣지 않는다.
- 출력은 사람이 바로 읽을 수 있는 YAML 유사 형식을 우선한다.
- `--apply`는 frontmatter의 추천/검토 필드만 갱신한다.

## 포함 스크립트
- `vault-check.sh`: 볼트 구조, TODO/FIXME, MOC 추적 필드, 리뷰 스키마를 한 번에 점검
- `triage-note.sh [--apply] <note-path>`: 단일 노트의 분류와 MOC 후보를 추천하고, 선택 시 추천 필드를 frontmatter에 기록
- `review-note.sh [--apply] <note-path>`: 단일 노트의 제목, 타입, 링크, MOC 추적 필드를 검토하고, 선택 시 MOC 검토 상태를 frontmatter에 기록
- `promote-note.sh [--apply] <note-path>`: triage 결과를 기준으로 대상 폴더와 경로를 계산하고, 선택 시 실제 폴더 생성과 파일 이동을 수행

## 예시
```sh
scripts/vault-check.sh
scripts/triage-note.sh "00 Inbox/AI 에이전트 오케스트레이션 정리.md"
scripts/review-note.sh "00 Inbox/AI 에이전트 오케스트레이션 정리.md"
scripts/triage-note.sh --apply "00 Inbox/AI 에이전트 오케스트레이션 정리.md"
scripts/review-note.sh --apply "00 Inbox/AI 에이전트 오케스트레이션 정리.md"
scripts/promote-note.sh "00 Inbox/AI 에이전트 오케스트레이션 정리.md"
```
