# Orchestration Skill

## 목적
사용자 요청을 해석하고, `workflow.md` 기준으로 어떤 에이전트 순서로 처리할지 결정하며, 최종 응답을 조합한다.

## 에이전트 순서
1. `VaultPM`
2. `InboxClassifier`
3. `KnowledgeWriter`
4. `LinkArchitect`
5. `Reviewer`

## 운영 규칙
- 실제 Vault 구조를 우선한다.
- 기존 의미를 보존한다.
- 대량 이동이나 리네임 전에는 추천안을 먼저 제시한다.
- 결과는 `Inbox -> 분류 -> 연결 -> MOC 반영` 흐름을 따른다.
- MOC는 자동 생성하지 않고 기존 허브가 있을 때만 반영 여부를 판단한다.
- 하나의 노트는 가장 적합한 단일 MOC를 우선 연결 대상으로 삼는다.
- 여러 MOC에 같은 노트를 중복 반영하지 않는다.
- 적합한 MOC가 없으면 새 MOC를 만들지 말고 필요 여부만 제안한다.

## 최종 출력 형식
- 분류 결과
- 수정 또는 재작성 결과
- 추천 링크
- 검토 결과
- 이동 여부
- 사용자 확인 필요 여부

## 요청 예시
```text
00 Inbox의 인증 관련 메모 하나를 정리해줘.
분류하고, 제목 다듬고, 관련 링크도 추천해줘.
파일은 바로 옮기지 말고 추천만 보여줘.
```

## 응답 예시
```yaml
classification:
  recommended_type: project
  recommended_folder: 10 Projects
  recommended_project_folder: 10 Projects/인증 개선 프로젝트
rewrite:
  recommended_title: 인증 흐름 개선 메모
  summary: 현재 인증 오류 원인과 수정 방향을 짧게 정리
links:
  related_notes:
    - "[[인증 전략]]"
  related_mocs:
    - "[[MOC: 인증]]"
  primary_moc_candidate: "[[MOC: 인증]]"
review:
  checks_passed:
    - title_matches_content
  issues: []
  moc_review_result:
    status: linked
    selected_moc: "[[MOC: 인증]]"
    reason: 인증 관련 기존 허브가 있어 단일 MOC로 연결
  ready_to_apply: true
move_file: false
needs_confirmation: true
```

## 적용 메모
- 사용자가 수정만 원하면 `KnowledgeWriter`와 `LinkArchitect`만 호출할 수 있다.
- 사용자가 구조 정리를 원하면 전체 순서를 따른다.
- `project`로 확정되면 프로젝트 폴더 생성과 대표 노트 이동을 같은 작업 단위로 처리한다.
- 사용자가 "검토만" 원하면 `Reviewer` 중심으로 기존 노트 상태를 점검한다.
