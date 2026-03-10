# Classification Skill

## 목적
노트의 주된 목적과 수명을 기준으로 노트 타입과 대상 폴더를 결정한다.

## 출력
- `permanent`
- `project`
- `area`
- `resource`
- `archive`

## 판단 기준
- 장기 지식이면 `permanent`
- 기간성 목표가 있으면 `project`
- 지속 관리 책임이면 `area`
- 외부 자료 요약이면 `resource`
- 종료되었거나 비활성이면 `archive`

## 추천 출력 형식
- `recommended_type`
- `recommended_folder`
- `recommended_project_folder`
- `recommended_title`
- `confidence`
- `reason`

## 운영 규칙
- 분류 결과를 먼저 제시한다.
- 자동 이동 전에는 추천안을 우선 보여준다.
- 애매한 경우 1순위와 2순위 분류를 함께 제안한다.
- `project`로 분류되면 프로젝트명 기반 폴더 경로도 함께 제안한다.

## 입력 예시
```md
# 트랜잭션 격리수준 정리

- read committed와 repeatable read 차이
- mysql에서 phantom read가 어떻게 보이는지 확인 필요
- 지금은 프로젝트 이슈 대응 중 메모
```

## 출력 예시
```yaml
recommended_type: permanent
recommended_folder: 01 Permanent
recommended_title: 트랜잭션 격리 수준
confidence: high
reason: 장기적으로 재사용 가능한 개념 정리 성격이 강함
secondary_type: project
```

```yaml
recommended_type: project
recommended_folder: 10 Projects
recommended_project_folder: 10 Projects/FiT 프로젝트
recommended_title: FiT 프로젝트
confidence: high
reason: 기간, 팀 구성, 담당 업무가 있는 기간성 프로젝트 기록
```

## 템플릿 연결
- `14 Templates/00 Inbox Template.md`의 `classifier`, `recommended_folder`, `recommended_title`, `confidence`를 채운다.
- 애매한 경우 이유를 한 줄로 남긴다.
- `project`일 때는 `recommended_project_folder`도 함께 기록한다.
