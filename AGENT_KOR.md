# Repository Guidelines

## 프로젝트 구조 및 모듈 구성
이 저장소는 개인 지식 관리를 위한 Obsidian 볼트입니다.

- `README.md`: 볼트 아키텍처(Zettelkasten + PARA), 링크 흐름, 작성 절차의 기준 문서
- `OBSIDIAN_STYLE_GUIDE.md`: 네이밍, frontmatter, 링크, 태그, 첨부 규칙을 담은 작성 스타일 기준 문서
- 루트 폴더: `00 Inbox`, `01 Permanent`, `02 MOCs`, `10 Projects`, `11 Areas`, `12 Resources`, `13 Archive`
- `attachments/`: `diagrams/`, `screenshots/`, `files/`로 분류된 첨부 자산
- `.obsidian/`: 로컬 Obsidian 설정(Git 추적 제외)

정렬 안정성과 의미 유지를 위해 폴더명 숫자 접두어(예: `00 Inbox`, `01 Permanent`, `10 Projects`)를 유지합니다.

## 빌드, 테스트, 개발 명령
이 저장소에는 소프트웨어 빌드/CI 테스트 파이프라인이 없습니다. 커밋 전 아래 점검을 사용합니다.

- `git status --short`: 의도한 파일만 변경되었는지 확인
- `git diff -- README.md OBSIDIAN_STYLE_GUIDE.md AGENTS.md AGENT_KOR.md`: 가이드/구조 문서 변경 검토
- `find . -maxdepth 1 -type d | sort`: 루트 볼트 구조 확인
- `rg "TODO|FIXME" README.md OBSIDIAN_STYLE_GUIDE.md AGENTS.md AGENT_KOR.md`: 미완료 표시 검색

로컬에서 Obsidian을 사용하는 경우 PR 전 링크 탐색(MOC, 백링크 포함)을 앱에서 확인합니다.

## 코딩 스타일 및 네이밍 규칙
문서는 Markdown으로 작성하며, 짧고 명확한 섹션을 유지합니다.

- 헤딩 계층 `#`, `##`, `###`를 일관되게 사용
- 긴 문단보다 간결한 문장과 목록 우선
- 볼트 폴더는 두 자리 번호 접두어(`00`, `01`, ...) 유지
- 노트/폴더명은 설명 가능하고 안정적으로 유지하여 링크 손상을 방지
- 노트 단위 스타일(frontmatter, 링크, 태그, 첨부)은 `OBSIDIAN_STYLE_GUIDE.md`를 기준으로 적용

## 테스트 가이드라인
테스트는 콘텐츠 검증 중심입니다.

- Obsidian 그래프/뷰에서 내부 링크가 정상 해석되는지 확인
- 노트 구조가 `README.md` 흐름(`Inbox -> 분류 -> 연결 -> MOC 반영`)을 따르는지 확인
- 첨부 참조가 `attachments/` 하위 파일을 올바르게 가리키는지 확인

대규모 변경 시 `Permanent`, `Projects`, `Resources`에서 샘플 노트를 만들어 수동 점검합니다.

## 커밋 및 PR 가이드라인
현재 히스토리는 간결한 범위 기반 형식(예: `init: second-brain`)을 사용합니다.

- 커밋 형식: `<scope>: <summary>` (예: `structure: add attachments subfolders`)
- 한 커밋에는 하나의 개념적 변경만 포함
- PR에는 목적, 변경 경로, 마이그레이션/리네임 영향, UI 동작 관련 시 스크린샷 포함

관련 이슈/작업이 있으면 연결하고, 백링크 깨짐 가능성이 있으면 명시합니다.

## 이중 언어 가이드 동기화 규칙
루트의 기여자 가이드는 항상 동기화합니다.

- `AGENTS.md`를 수정하면 같은 변경에서 `AGENT_KOR.md`도 함께 수정합니다.
- `AGENT_KOR.md`를 수정하면 동일 정책/내용 변경을 `AGENTS.md`에도 반영합니다.
- 두 파일 중 하나를 수정하는 PR은 번역 전용 변경이 아닌 한 두 파일을 모두 포함합니다.
