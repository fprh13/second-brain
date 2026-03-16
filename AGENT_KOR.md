---
created: 2026-03-15 03:27:29
---
# Repository Guidelines

## 프로젝트 구조 및 모듈 구성
이 저장소는 개인 지식 관리를 위한 Obsidian 볼트입니다.

- `README.md`: 저장소 소개 문서
- `VAULT_RULES.md`: 상세 볼트 운영 정책 문서
- 루트 폴더: `00 Inbox`, `01 Permanent`, `02 MOCs`, `10 Projects`, `11 Areas`, `12 Resources`, `13 Archive`
- `14 Templates`: Obsidian 및 AI 보조 작업에서 사용하는 템플릿
- `attachments/`: `diagrams/`, `screenshots/`, `files/`로 구분된 첨부 자산
- `.obsidian/`: 로컬 Obsidian 설정(Git 추적 제외)

정렬 안정성과 의미 유지를 위해 숫자 접두어 폴더명을 유지합니다.

## 빌드, 테스트, 개발 명령
이 저장소에는 소프트웨어 빌드나 CI 파이프라인이 없습니다. 커밋 전 아래 점검을 사용합니다.

- `git status --short`: 의도한 파일만 변경되었는지 확인
- `git diff -- README.md VAULT_RULES.md AGENTS.md AGENT_KOR.md '14 Templates'`: 규칙 및 템플릿 변경 검토
- `find . -maxdepth 1 -type d | sort`: 루트 볼트 구조 확인
- `find '00 Inbox' '01 Permanent' '02 MOCs' '10 Projects' '11 Areas' '12 Resources' '13 Archive' -type f -name '*.md' | sed 's#.*/##' | sort | uniq -d`: 중복 노트 파일명 확인
- `rg "TODO|FIXME" README.md VAULT_RULES.md AGENTS.md AGENT_KOR.md '14 Templates'`: 미완료 표시 검색

로컬에서 Obsidian을 사용하는 경우 내부 링크와 그래프 가독성을 함께 확인합니다.

## 실행 규칙
볼트 운영 정책은 `VAULT_RULES.md`를 따릅니다. 이 문서는 실행 시 필요한 가드레일만 추가합니다.

- 사용자가 요청하지 않으면 노트 파일을 이동하지 않음
- 노트 위치는 사용자가 결정하고, AI는 추천만 수행
- 스크린샷, 파일 같은 첨부는 필요 시 `attachments/`로 이동 가능
- 치명적 오타 외에는 사용자 문장을 재작성하지 않음
- 기존 `##` 섹션 간 내용 이동 금지
- Markdown 가독성 편집만 허용
- 코드, 명령어, 설정, 로그는 fenced code block으로 작성
- 노트 링크는 `관련 노트` 섹션 하나로 관리
- Obsidian 그래프가 꼬이지 않도록 불필요한 교차 링크를 줄임
- 템플릿 갱신 시 `created`, 노트 유형 tag 같은 최소 필수 frontmatter만 유지하고 불필요한 메타데이터는 제거

## 테스트 가이드라인
테스트는 콘텐츠 검증 중심입니다.

- 내부 링크가 Obsidian에서 정상 해석되는지 확인
- 관련 노트 링크가 자연스러운지 확인
- 중복 파일이나 중복 노트명이 있는지 확인
- 위치가 어색한 노트는 추천만 하고 자동 이동하지 않는지 확인
- 첨부가 `attachments/` 아래를 올바르게 가리키는지 확인
- 템플릿이 최소 필수 메타데이터를 유지하면서도 불필요한 메타데이터를 다시 도입하지 않는지 확인

대규모 수정 시 `Permanent`, `Projects`, `Resources`, `MOCs`에서 샘플 노트를 수동 점검합니다.

## 커밋 및 PR 가이드라인
모든 커밋 메시지는 `notes: sync`를 사용합니다.

- 커밋 메시지: `notes: sync`
- scope나 summary를 변경하지 않음
- PR에는 목적, 변경 경로, 마이그레이션 메모, UI 동작 관련 시 스크린샷 포함

백링크나 그래프 구조 위험이 있으면 명시합니다.

## 이중 언어 가이드 동기화 규칙
루트의 기여자 가이드는 항상 동기화합니다.

- `AGENTS.md`를 수정하면 같은 변경에서 `AGENT_KOR.md`도 함께 수정합니다.
- `AGENT_KOR.md`를 수정하면 동일 정책 변경을 `AGENTS.md`에도 반영합니다.
- 두 파일 중 하나를 수정하는 PR은 번역 전용이 아닌 한 두 파일을 모두 포함합니다.
