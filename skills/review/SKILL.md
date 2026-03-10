# Review Skill

## 목적
분류, 작성, 링크 결과가 볼트 규칙에 맞는지 최종 점검한다.

## 점검 항목
- 노트 타입이 내용과 맞는가
- 제목이 내용을 설명하는가
- frontmatter가 과하지 않은가
- 최소한의 내부 링크가 있는가
- Project 노트가 올바른 폴더 구조를 따르는가
- MOC 반영이 기존 허브 기준으로 이뤄졌는가
- 같은 노트가 여러 MOC에 불필요하게 중복 반영되지 않았는가
- 원래 의미가 과도하게 바뀌지 않았는가

## 추천 출력 형식
- `checks_passed`
- `issues`
- `missing_fields`
- `link_gaps`
- `moc_review_result`
- `ready_to_apply`

## 입력 예시
```yaml
classification:
  recommended_type: project
  recommended_project_folder: 10 Projects/FiT 프로젝트
rewrite:
  title: FiT 프로젝트
links:
  related_notes:
    - "[[실시간 음성 스트리밍]]"
```

## 출력 예시
```yaml
checks_passed:
  - project_folder_valid
  - title_matches_content
issues: []
missing_fields:
  - repo
link_gaps:
  - "[[MOC: 오디오 스트리밍]]"
moc_review_result:
  status: skipped
  selected_moc:
  reason: 적합한 기존 MOC가 아직 없음
ready_to_apply: true
```

## 운영 규칙
- 문제를 찾으면 수정 제안부터 한다.
- 사소한 누락과 구조적 문제를 구분해서 보고한다.
- 링크가 부족해도 핵심 내용이 맞으면 작업 전체를 막지는 않는다.
- 새 MOC 생성이 필요한 경우에도 자동 생성하지 말고 제안으로만 남긴다.
- `moc_review_result.status`는 `linked`, `skipped`, `needs_review` 중 하나로 남긴다.
