# 설계 검증 기록

검증일: 2026-11-05. 앱 실행 검증이 아니라 전달물 분석과 설계·계약 검증입니다.

|검사|결과|
|---|---|
|FigCraft MCP 원본 열기|정상, repairs 없음, dirty=false 상태로 읽음|
|페이지·화면 구조|4개 페이지, 4개 화면 그룹, 16개 화면의 노드/375×812/readyForDev 확인|
|동작 근거|각 화면 텍스트·Action 링크, 노드 1065의 완료/중단 조건, 1069의 handoff 명세 확인|
|시각 확인|MCP screenshot으로 홈·추천·상세 확인; 나머지는 구조 및 원본 HTML 대조|
|화면 매핑|`out/screens.json`의 16개 ID가 화면 설계표에 모두 존재|
|문서 링크|AGENTS.md와 docs Markdown의 로컬 링크 대상 존재 확인|
|OpenAPI 기본 검사|JSON 파싱, 내부 `$ref` 해석, 15개 operationId 중복 없음|
|OpenAPI 공식 구조 대응 검사|Swagger Parser로 3.1.1 명세 validate 통과|
|예시 데이터|Ajv 2020 + formats로 20개 스키마 예시 검증 통과|
|경계·배타 조건|완료 평가 1/5 허용, 0/6/소수 거부; 중단 공백/빈 값/201자 거부·200자 허용; 양쪽 필드 동시 전송 거부; 닉네임 경계 등 16개 통과|

검증 도구는 `/tmp/dokidoki-contract-review`에 임시 설치했습니다. 사용 버전은 `@apidevtools/swagger-parser 13.1.0`, `ajv 8.20.0`, `ajv-formats 3.0.1`입니다. 프로젝트 package.json/lockfile은 만들지 않았습니다. 초기 npm 기본 캐시 권한 오류가 있어 임시 캐시로 재실행했으며 기존 사용자 캐시의 소유권이나 내용을 수정하지 않았습니다.

## 재검증 방법

P0에서 버전이 고정된 검증 도구와 아래 동등 절차를 CI에 등록합니다.

1. `SwaggerParser.validate('docs/openapi.draft.json')`로 구조를 검증합니다.
2. Ajv 2020 인스턴스에 `ajv-formats`를 연결하고, 계약의 components를 포함하는 root schema에 `$id`를 부여합니다.
3. 각 `#/components/schemas/{name}`을 resolve하여 `examples`를 검사합니다. 이 계약의 examples는 20개입니다.
4. WatchEntry의 완료/중단 양수·음수 사례, 사유와 닉네임 경계를 검사합니다. `oneOf`뿐 아니라 `additionalProperties:false` 위반도 실패해야 합니다.
5. 화면 목록/문서 링크/operationId 일치 검사를 실행합니다.

## 남은 검증

실제 인증 쿠키·CSRF·권한·멱등성·추천 계산은 서버가 없어 검증하지 않았습니다. OpenAPI가 유효하다는 결과는 해당 서버 정책이 구현되었거나 합의되었다는 뜻이 아닙니다. React의 typecheck/build/브라우저 테스트, 전체 화면 픽셀 비교, 접근성 검사는 구현 작업 P0~P8에서 수행합니다. MSW handlers도 이번에는 전략만 작성했습니다.


## P1-2 검증 (2026-11-18)

- `npm run typecheck`, `npm run lint`, `npm run build`를 통과했습니다.
- `npm test`: Chromium 46개(기존 회귀 34개 + 공통 UI 12개)를 통과했습니다. 초기 시각 테스트의 잘못된 banner 선택자는 main 내부 header에 맞게 수정한 뒤 전체 재검증했습니다.
- FigCraft 버튼 상태 세트·헤더·검색·결과 화면을 렌더링하고 React의 375×812 결과와 대조했습니다. 버튼 327×56, 헤더 56px, 결과 메시지 263px 및 주요 여백·모서리를 확인했습니다. 팔레트 3개의 렌더도 확인했습니다. 자동 픽셀 차이의 승인 기준은 아직 없습니다.
- 320/375/390/430/1280px, 모의 비대칭 safe area, 높이 500px와 여러 줄 하단 CTA에서 넘침·마지막 행동 가림이 없었습니다. 오류의 label/description/invalid 연결, keyboard focus·링크/필터, pending 차단과 입력 보존, 이미지 실패/URL 변경 복구, reduced-motion을 확인했습니다.
- `dist`에서 테스트 fixture 식별자가 없음을 확인했습니다. 생성 토큰·OpenAPI·원본 디자인은 변경하지 않았습니다. 새 의존성은 없습니다.
- 새 문서 링크를 검사했습니다. 기존 README가 링크하던 부재 `out/` 자료는 최초 분석 자료임을 밝히고 코드 경로 표기로 바꿨습니다.
- 실제 OS IME, 모바일 키보드·safe area, WebKit, 실제 200% 브라우저 확대, 스크린리더와 전체 16개 완성 화면 시각 회귀는 환경/기능 구현 범위상 수행하지 않았습니다. P7에서 검증합니다.

## P0-3 API 기반 검증 (2026-11-19)

- api:generate/api:check, typecheck, lint, production build/build:check를 통과했습니다. VITE_API_MODE=mock을 주입한 production build에서도 Worker·fixture가 제외되었습니다.
- Vitest 22개: 15개 API 실제 fetch 요청과 성공 응답 스키마, /me 200/401/500, CRUD 반영, 중복/멱등키/24시간 만료, 소유권, 412/428, 조건부 입력 경계, 검색/한글 cursor/21개 페이지/빈 결과, CSRF, timeout/취소/네트워크/429/잘못된 JSON, Query 재시도·mutation·무효화·캐시 초기화를 검증했습니다.
- Playwright Chromium 47개: Worker 준비와 동일 API 함수의 로그인/CRUD/로그아웃, 기존 라우팅·공통 UI·3개 팔레트·320~1280px·모의 safe area 회귀가 통과했습니다. Worker 비동기 부팅에 맞춰 스타일 테스트는 실제 화면 렌더를 기다립니다.
- 최초 E2E는 샌드박스 포트 제한으로 실행 불가하여 권한 확장 후 실행했습니다. 초기 스타일 5개 실패는 DOM 대기 추가로 해결했습니다. 병렬 실행 중 생성된 Playwright trace를 ESLint가 읽던 문제는 산출물 제외 규칙으로 수정했습니다.
- 실제 Spring Boot 연결, 쿠키/CORS/CSRF 보안, 다중 탭 세션, 16개 완성 기능 화면·새 시각 대조·WebKit·실기기는 미검증입니다. 준비 화면 UI 변경은 없습니다. CI는 P0-4에 남습니다.
