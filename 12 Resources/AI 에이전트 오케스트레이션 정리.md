---
type: resource
created: 2026-03-11 04:22
tags: [resource, ai, workflow]
status: reference
source: chat
moc_candidate: 
moc_decision: pending
needs_moc_review: true
recommended_type: resource
recommended_folder: 12 Resources
recommended_title: AI 에이전트 오케스트레이션 정리
recommended_project_folder: 
confidence: high
classifier: manual-review
---

# AI 에이전트 오케스트레이션 정리

## 요약
- 이 볼트는 `VaultPM -> InboxClassifier -> KnowledgeWriter -> LinkArchitect -> Reviewer` 순서로 노트를 처리한다.
- 기본 흐름은 `Inbox -> 분류 -> 연결 -> MOC 반영`이다.
- 자동 이동이나 리네임 전에는 추천안을 먼저 보여준다.
- 새 MOC는 만들지 않고, 기존 MOC가 있을 때만 반영 여부를 판단한다.

## 핵심 규칙
- 새 MOC는 자동 생성하지 않는다.
- 기존 MOC가 있을 때만 반영 여부를 판단한다.
- 하나의 노트는 가장 적합한 단일 MOC에 우선 연결한다.
- 여러 MOC에 같은 노트를 중복 삽입하지 않는다.
- 다른 주제와의 연결은 본문 링크나 관련 노트 링크로 처리한다.
- 적합한 MOC가 없으면 필요 여부만 제안한다.

## 에이전트 역할과 출력
- `VaultPM`: 전체 순서 결정과 최종 조합
- `InboxClassifier`: `recommended_type`, `recommended_folder`, `recommended_project_folder`, `recommended_title`, `confidence`
- `KnowledgeWriter`: 제목, 본문, frontmatter 정리
- `LinkArchitect`는 `related_notes`, `related_mocs`, `primary_moc_candidate`를 제안한다.
- `Reviewer`는 `moc_review_result.status`, `selected_moc`, `reason`으로 최종 판정한다.
- `moc_review_result.status`는 `linked`, `skipped`, `needs_review` 중 하나로 남긴다.

## 용어 정리
- `VaultPM`: 요청을 읽고 전체 작업 순서를 정하는 오케스트레이터
- `InboxClassifier`: 노트가 `project`, `permanent`, `resource`, `area` 중 어디에 가까운지 판단하는 역할
- `KnowledgeWriter`: 제목, 본문, frontmatter를 사람이 읽기 쉽게 정리하는 역할
- `LinkArchitect`: 관련 노트, 기존 MOC, 백링크 후보를 찾는 역할
- `Reviewer`: 분류, 링크, MOC 판단이 규칙에 맞는지 마지막으로 점검하는 역할
- `triage`: 노트를 바로 옮기지 않고 우선 분류 추천과 메타데이터 추천을 남기는 단계
- `review`: 제목, 타입, 링크, MOC 상태를 점검해서 적용 가능 여부를 판단하는 단계
- `promote`: Inbox 노트를 추천된 대상 폴더로 실제 승격하는 단계
- `MOC`: 관련 노트를 묶는 허브 노트
- `primary_moc_candidate`: 여러 MOC 후보 중 가장 유력한 기존 MOC 1개
- `moc_decision`: frontmatter에 남기는 MOC 처리 상태. `pending`, `linked`, `skipped`를 사용
- `moc_review_result`: Reviewer가 반환하는 MOC 최종 판정 결과

## Frontmatter 메모
- `recommended_type`: 분류 추천 결과
- `recommended_folder`: 추천 대상 폴더
- `recommended_project_folder`: Project일 때 추천 프로젝트 폴더
- `recommended_title`: 추천 제목
- `confidence`: 추천 신뢰도
- `classifier`: 어떤 스크립트나 에이전트가 분류를 기록했는지
- `moc_candidate`: 가장 유력한 기존 MOC 후보
- `moc_decision`: 현재 MOC 처리 상태
- `needs_moc_review`: MOC 검토가 아직 필요한지 표시

## 셸 스크립트로 할 수 있는 것
- `vault-check.sh`: 볼트 구조, TODO/FIXME, MOC 추적 필드, 리뷰 스키마를 점검
- `triage-note.sh`: 단일 노트의 분류, 추천 경로, 추천 제목, MOC 후보를 출력
- `triage-note.sh --apply`: 분류 추천값과 `moc_candidate`를 frontmatter에 기록
- `review-note.sh`: 제목, 타입, 내부 링크, MOC 추적 필드를 검토
- `review-note.sh --apply`: `moc_decision`, `needs_moc_review`를 frontmatter에 기록
- `promote-note.sh`: 추천된 대상 경로를 계산하는 dry-run
- `promote-note.sh --apply`: 실제 폴더 생성과 파일 이동 수행

## 지금까지 한 작업
- `workflow.md`, `README.md`, `AGENTS.md`, `AGENT_KOR.md`에 MOC 자동 생성 금지 규칙을 반영했다.
- `skills/linking`, `skills/review`, `skills/orchestration`, `skills/writing`에 MOC 후보와 리뷰 결과 스키마를 반영했다.
- `14 Templates`의 Inbox, Permanent, Project, Resource 템플릿에 MOC 추적 필드를 추가했다.
- `00 Inbox/AI 에이전트 오케스트레이션 정리.md`를 새로 만들고, 현재 오케스트레이션 규칙을 기록했다.
- `scripts/` 아래에 `vault-check.sh`, `triage-note.sh`, `review-note.sh`, `promote-note.sh`를 추가했다.
- `00 Inbox/FiT 프로젝트.md`에 `triage-note.sh --apply`를 실행해서 프로젝트 승격 추천값을 기록했다.
- `promote-note.sh` dry-run으로 `FiT 프로젝트`가 `10 Projects/FiT 프로젝트/FiT 프로젝트.md`로 이동할 경로를 확인했다.

## 검토 결과
- 분류는 `12 Resources`가 적합하다. 운영 책임보다 참조 문서 성격이 강하다.
- 현재 `02 MOCs`에는 파일이 없어 연결할 기존 MOC가 없다.
- 그래서 `moc_decision`은 `pending` 상태를 유지하고, MOC 필요 여부만 나중에 검토한다.
- 내부 링크 후보는 있지만 실제 대상 노트 존재 여부는 추후 확인이 필요하다.

## 다음 액션
- [ ] `FiT 프로젝트`에 `promote-note.sh --apply`를 실제 실행할지 결정
- [ ] Project 승격 후 본문 정리용 스크립트를 추가할지 판단
- [ ] AI 운영 관련 노트가 늘어나면 기존 MOC 대신 허브 노트가 정말 필요한지 다시 판단

## 메모
- 템플릿 frontmatter에는 `moc_candidate`, `moc_decision`, `needs_moc_review`를 추가했다.
- Reviewer 출력에는 `moc_review_result`를 추가했다.
- 셸 스크립트는 기본적으로 추천과 점검을 우선하고, 구조 변경은 `--apply`가 있을 때만 수행한다.

## 연결 후보 (선택)
- [[workflow]]
- [[AI]]
- [[Projects]]
