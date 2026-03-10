# Linking Skill

## 목적
관련 노트, MOC, 백링크 기회를 찾아 노트가 고립되지 않도록 연결한다.

## 규칙
- 위키링크 `[[노트명]]` 형식 사용
- 개념적 관계가 분명한 링크만 제안
- Permanent 노트는 관련 노트 2개 이상을 우선 탐색
- MOC가 있으면 단순 나열이 아니라 탐색 경로를 고려
- MOC는 자동 생성하지 않는다.
- 기존 MOC가 있을 때만 반영 여부를 판단한다.
- 하나의 노트는 가장 적합한 단일 MOC에 우선 연결한다.
- 여러 MOC에 같은 노트를 중복 반영하지 않는다.
- 다른 MOC와의 관련성은 본문 링크나 관련 노트 링크로 처리한다.

## 추천 출력 형식
- `related_notes`
- `related_mocs`
- `primary_moc_candidate`
- `backlink_targets`
- `link_reason`

## 연결 우선순위
1. 직접 참조 가능한 기존 노트
2. 해당 주제의 MOC
3. 상위 프로젝트나 영역 노트

## 입력 예시
```md
# 트랜잭션 격리 수준

## 핵심 주장
- 격리 수준 선택은 일관성과 동시성의 교환이다.
```

## 출력 예시
```yaml
related_notes:
  - "[[데이터베이스 락 전략]]"
  - "[[동시성 제어 패턴]]"
related_mocs:
  - "[[MOC: 데이터베이스]]"
primary_moc_candidate: "[[MOC: 데이터베이스]]"
backlink_targets:
  - "[[주문 처리 프로젝트]]"
link_reason: 데이터베이스 일관성과 성능 설계 맥락에서 함께 탐색 가능
```

## 템플릿 연결
- Permanent, Resource, Project 템플릿의 `연결`, `관련 노트`, `MOC` 항목을 채운다.
- 적합한 MOC가 없으면 새 MOC 필요 여부만 제안하고 자동 생성하지 않는다.
- `primary_moc_candidate`는 Reviewer가 최종 판정할 수 있도록 가장 유력한 기존 MOC 1개만 남긴다.
