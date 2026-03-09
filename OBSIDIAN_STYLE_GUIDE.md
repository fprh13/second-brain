# Obsidian Style Guide

## 목적
이 문서는 Vault 전체에서 일관된 작성 스타일을 유지하기 위한 기준이다. 기본 원칙은 `짧게`, `명확하게`, `연결 가능하게`이다.

## 1) 노트 위치 규칙
- `00 Inbox`: 빠른 캡처, 미분류 메모
- `01 Permanent`: 장기 지식 노트
- `02 MOCs`: 주제 허브/목차
- `10 Projects`: 기간성 작업
- `11 Areas`: 지속 관리 영역
- `12 Resources`: 참고 자료/정리
- `13 Archive`: 종료된 프로젝트/노트

## 2) 파일명 규칙
- 형식: `핵심주제 중심 명사형`
- 불필요한 접두어/특수문자 최소화
- 잦은 리네임 금지 (백링크 안정성 우선)
- 예시: `API 인증 전략`, `캐시 무효화 패턴`

## 3) Frontmatter 규칙
- 템플릿의 frontmatter 키를 유지하고 임의 키 추가를 최소화한다.
- 공통 권장 키: `type`, `created`, `tags`, `status`
- 날짜/시간 포맷: `YYYY-MM-DD`, `HH:mm` (Obsidian Templates 설정 준수)

## 4) 헤딩/본문 스타일
- 헤딩 계층은 `# -> ## -> ###`까지만 권장
- 한 섹션은 3~6줄 내 요약 중심으로 작성
- 긴 문단보다 불릿 우선
- 체크박스는 실행 가능한 항목에만 사용

## 5) 링크/연결 규칙
- 내부 링크는 위키링크 `[[노트명]]` 사용
- 구조 링크는 현재 폴더 체계를 따른다:
  - `[[01 Permanent/]]`, `[[02 MOCs/]]`, `[[10 Projects/]]`, `[[11 Areas/]]`, `[[12 Resources/]]`, `[[13 Archive/]]`
- Permanent 노트는 최소 2개 이상 관련 노트와 연결
- MOC는 단순 링크 목록이 아니라 탐색 순서를 제공

## 6) 태그 규칙
- 태그는 최소 집합만 사용 (`#permanent`, `#project`, `#resource` 등)
- 중복 의미 태그 금지 (`#dev`와 `#development` 동시 사용 금지)
- 상태 태그보다 frontmatter `status` 우선

## 7) 코드/예시 블록
- 코드/설정/명령은 fenced code block으로 작성
- 언어 지정 가능하면 명시 (`bash`, `js`, `yaml`)
- 긴 로그는 요약 후 핵심 라인만 남긴다

## 8) 첨부파일 규칙
- 첨부는 `attachments/` 하위에 저장
  - 다이어그램: `attachments/diagrams`
  - 스크린샷: `attachments/screenshots`
  - 기타 파일: `attachments/files`
- 노트 본문에는 파일 경로를 직접 쓰기보다 링크로 참조

## 9) 작성 흐름 표준
1. `00 Inbox`에 캡처
2. 노트 성격에 따라 분류 (`Permanent/Resource/Project/Area`)
3. 관련 노트 연결
4. `02 MOCs`에 반영
5. 완료된 항목은 `13 Archive`로 이동

## 10) 품질 점검 체크리스트
- [ ] 제목이 노트 내용을 정확히 설명하는가
- [ ] Frontmatter 필수 키가 채워졌는가
- [ ] 최소 1개 이상의 내부 링크가 있는가
- [ ] MOC 또는 관련 허브와 연결되었는가
- [ ] 첨부 링크가 올바른 경로를 가리키는가
- [ ] 중복 노트 생성 가능성이 없는가

## 11) 변경 관리 규칙
- 구조/템플릿/가이드 변경 시 `README.md`, `AGENTS.md`, `AGENT_KOR.md`와 정합성을 유지한다.
- 가이드 문서 갱신 시 예시 경로가 실제 Vault 구조와 일치하는지 확인한다.
