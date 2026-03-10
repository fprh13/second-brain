# Vault Multi-Agent Workflow

## 목적
이 문서는 이 볼트에서 AI가 노트를 다룰 때 사용하는 멀티 에이전트 구조를 설명한다. 목표는 기존 Zettelkasten + PARA 흐름을 유지하면서, 분류·정리·연결 작업을 역할별로 분리하는 것이다.

## 에이전트 구성
- `VaultPM`: 요청 해석, 작업 순서 결정, 최종 출력 조합
- `InboxClassifier`: 노트 타입 판별, 대상 폴더 추천
- `KnowledgeWriter`: 문장 정리, 구조 개선, 제목 보정
- `LinkArchitect`: 관련 노트, MOC, 백링크 후보 제안
- `Reviewer`: 분류, 구조, 링크, 누락 항목을 최종 점검

## 처리 흐름
```text
User Request
  -> VaultPM
  -> InboxClassifier
  -> KnowledgeWriter
  -> LinkArchitect
  -> Reviewer
  -> Final Recommendation
```

## 기본 워크플로우
1. `VaultPM`이 요청 범위와 수정 가능 여부를 판단한다.
2. `InboxClassifier`가 노트 성격을 `Permanent`, `Project`, `Area`, `Resource`, `Archive` 중 하나로 분류한다.
3. `Project`로 분류되면 프로젝트명을 기준으로 `10 Projects/<프로젝트명>/` 폴더를 만들고 대표 노트 위치를 결정한다.
4. `KnowledgeWriter`가 제목, 본문, frontmatter를 가다듬는다.
5. `LinkArchitect`가 관련 노트와 MOC 연결을 제안한다.
6. `Reviewer`가 구조, 누락, 링크, 과도한 변형 여부를 점검한다.
7. 필요 시에만 파일 이동, 리네임, 아카이브를 수행한다.

## 표준 입출력 계약
모든 에이전트는 가능한 한 구조화된 입력과 출력을 사용한다.

### 공통 입력
```yaml
request:
source_note:
target_mode:
allow_move:
allow_rename:
```

### 공통 출력
```yaml
agent:
status:
summary:
artifacts:
risks:
needs_confirmation:
```

## 에이전트별 출력 계약
- `InboxClassifier`: `recommended_type`, `recommended_folder`, `recommended_project_folder`, `recommended_title`, `confidence`, `reason`
- `KnowledgeWriter`: `title`, `frontmatter`, `body_summary`, `rewrite_notes`
- `LinkArchitect`: `related_notes`, `related_mocs`, `primary_moc_candidate`, `backlink_targets`, `link_reason`
- `Reviewer`: `checks_passed`, `issues`, `missing_fields`, `link_gaps`, `moc_review_result`, `ready_to_apply`

## 운영 원칙
- 기존 의미를 보존한다.
- 실제 Vault 구조를 우선한다.
- 태그보다 위키링크를 선호한다.
- Permanent 노트는 가능한 한 2개 이상의 관련 연결을 만든다.
- 결과는 `Inbox -> 분류 -> 연결 -> MOC 반영` 흐름에 맞춘다.
- MOC는 자동 생성하지 않는다.
- 기존 MOC가 있을 때만 반영 여부를 판단한다.
- 하나의 노트는 가장 적합한 단일 MOC를 우선 연결 대상으로 선택한다.
- 여러 MOC에 같은 노트를 중복 반영하지 않는다.
- 다른 MOC와의 관련성은 본문 링크나 관련 노트 링크로 연결한다.
- 적합한 MOC가 없으면 새 MOC를 만들지 말고 필요 여부만 제안한다.
- 자동 이동이나 대량 리네임 전에는 추천안을 우선 보여준다.
- Project 노트의 최종 위치는 `10 Projects/<프로젝트명>/<프로젝트명>.md`를 기본값으로 한다.

## 스킬 참조
- 작성 규칙: `skills/writing/SKILL.md`
- 분류 규칙: `skills/classification/SKILL.md`
- 링크 규칙: `skills/linking/SKILL.md`
- 오케스트레이션 규칙: `skills/orchestration/SKILL.md`
- 검토 규칙: `skills/review/SKILL.md`
