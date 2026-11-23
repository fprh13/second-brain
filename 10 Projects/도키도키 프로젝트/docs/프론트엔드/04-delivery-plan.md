# 구현 작업과 검증 계획

## 작업 단위와 의존성

각 작업은 검토 가능한 PR 단위이며 API/MSW/화면/관련 테스트를 함께 완료합니다. API 서버 없이 P0~P7을 진행할 수 있습니다. 화면을 일괄 정적 마크업한 뒤 동작을 붙이지 않고 사용자 흐름별로 완성합니다. P0-1~P0-4의 코드 구성을 완료했으며 CI 원격 실행 확인은 남아 있습니다. P1의 스타일 기반은 사용자 요청에 따라 선행 완료했으며, P1-2 공통 UI도 선행 완료했습니다. P2 인증과 P3 작품 탐색, P4 시청 이력·기록 등록을 완료했습니다. P5 수정·삭제도 완료했습니다. P6 마이·프로필도 완료했습니다. P7은 16개 화면 Chromium Visual QA·UI 개선을 진행했으며 Mock 전체 흐름 E2E를 확장했습니다. 실제 기기·접근성 잔여 항목은 남아 있습니다. P8 실제 서버 연결은 후속 단계입니다.

|작업|선행|변경 범위·산출물|완료 기준|
|---|---|---|---|
|P0 기반·계약|없음|루트 Vite/TS, 버전 고정, router/query provider, API client, OpenAPI 타입 생성, MSW, CI|typecheck/lint/build/test 실행, mock 없는 production 검증, 미처리 API가 테스트 실패|
|P1 토큰·UI 골격|P0|토큰 복사/보정, 폰트, AppShell/AppBar/Tabs/CTA, Button/FormField/Poster/ResultView|375px 토큰·구조 대조, 3개 팔레트 및 키보드 focus, 320px overflow 없음|
|P2 인증 흐름|P1|login/signup/signup-done, 세션 가드·CSRF, auth handlers|로그인/신규가입/중복/401/네트워크 실패, 첫 기록 CTA, 깊은 링크 로그인 후 복귀|
|P3 작품 탐색|P2|home/recommendations/detail/search, 작품·추천 handlers와 cards|다른 작품 2개 이상이 서로 다른 상세로 이동, 10개·부족·0개·updating 처리, 기존 기록 수정 분기|
|P4 기록 등록·목록|P3|history/record/record-done, record handlers, summary query|완료 1~5/중단 필수 사유, URL 검색·필터·더 보기, 새 기록 이후 이력·건수·추천 반영|
|P5 기록 수정·삭제|P4|edit/edit-done/delete-done, shared form, 확인 dialog|완료↔중단 요청 필드 교체, 삭제 취소/성공, 409/412/404/timeout 복구|
|P6 내 정보|P4|my/profile/profile-done, 로그아웃|닉네임 저장·전체 건수 갱신, 실패 시 입력 보존, 사용자 전환 시 이전 데이터 없음|
|P7 통합 품질|P5,P6|누락 상태·접근성·반응형·시각 회귀, 전체 흐름 E2E|16개 화면+조건부 폼+오류 시나리오 통과, 원본 비교 이슈 해소|
|P8 실제 서버 연결|P7+계약 합의|proxy/env, 실제 계약 검증, staging smoke|인증/권한/추천 갱신 검증, 실제 데이터로 CRUD, mock 비활성, 출시 차단 항목 해소|

P3의 기본 추천/검색은 fixture로 제공하되 P4 뒤 실제 handler db 변경과 연결합니다. P0의 첫 검증 수직 단위는 GET `/me`의 성공/401/500이며 라우트 가드는 P2에서 연결합니다. P1에서는 WatchRecordForm 전체를 미리 추상화하지 않고 P4/P5에서 공유합니다.

## P0 세부 진행 상태

- [x] P0-1: Vite + React + TypeScript 초기화, npm lockfile, strict 타입 검사, ESLint, 기본 개발 서버와 production build 검증입니다.
- [x] P0-2: React Router와 Query provider, 기본 라우트·오류 경계입니다.
- [x] P0-3: fetch client, OpenAPI 생성 타입, MSW와 테스트 기반, `/me` 성공/401/500 검증입니다.
- [x] P0-4: GitHub Actions 타입·린트·빌드·계약·테스트 구성과 7일 리포트 보관을 추가했습니다. 로컬 검증과 구분하며 원격 Actions 실행은 아직 수행하지 않았습니다.

P0-2는 16개 경로 등록, 공통 준비 화면, 결과 경로 replace 복귀, AppShell/TabLayout, 404/오류 경계, Query Provider를 포함합니다. Playwright 라우팅 smoke 기반을 앞당겨 추가했으며, Vitest/MSW·HTTP 계약 테스트는 P0-3에서 완료했고 세션 가드는 P2에 남아 있습니다. 디자인 토큰과 공통 UI 완성은 P1 범위입니다.

초기화 범위와 실행 방법은 [프론트엔드 README](../README.md)를 참고합니다. P0 전체 완료를 의미하지 않습니다.

## P1 세부 진행 상태

- [x] P1-1: FigCraft 토큰 복사·모든 모드 단위 보정, Pretendard 자체 호스팅, 최소 reset/global, 기존 AppShell/TabLayout 토큰 적용을 완료했습니다.
- [x] P1-2: AppHeader/BottomNavigation/BottomAction 및 Button/FormField/Poster/ResultView 등 공통 UI, 독립 컴포넌트 검증과 주요 원본 시각 대조를 완료했습니다.

2026-11-09 사용자 요청으로 API와 독립적인 P1-1을 선행했습니다. 당시에는 P0-3/4와 P1-2가 미완료였습니다. 현재 P1-2 결과는 아래 완료 기록을 참고합니다. [스타일 사용 안내](07-style-foundation.md)에 변수 참조, 폰트 출처, 레이아웃 책임과 검증 한계를 기록했습니다. 토큰·폰트·소비 스타일은 함께 검증해야 하므로 하나의 논리적 커밋으로 묶습니다.

## 테스트 계층

|계층|핵심 사례|도구·실행 시점|
|---|---|---|
|순수 로직|완료 0/1/5/6·소수 거부, 중단 공백/200/201, inactive 필드 제거, 닉네임 경계, URL 정규화|Vitest, 관련 PR|
|컴포넌트 통합|한글 조합 검색, 필터 키보드, 상태별 필드, 오류 focus, pending 2중 클릭, 삭제 dialog focus|Playwright 실제 DOM + MSW, 관련 PR|
|HTTP 계약|entry oneOf, 인증/CSRF 오류, 409/412/428, cursor, idempotency, 응답 schema|OpenAPI validator + MSW handler tests, 모든 계약 변경|
|브라우저 흐름|가입→검색→완료 기록→이력; 중단 기록→수정→삭제; 추천→서로 다른 상세; 프로필→로그아웃→재로그인|Playwright, PR 핵심 smoke + merge 전체|
|복구 흐름|직접 URL·새로고침·결과 state 없음, 검색 뒤로 복원, 401·통신 끊김·재시도, 쓰기 timeout, 다른 탭 버전 충돌|Playwright/MSW 시나리오|
|시각|16개 화면 375×812, 완료/중단 폼, 긴 문구/0개/오류, 3개 테마 대표 화면|Playwright screenshot, 최초 기준 승인 후 변경분|
|접근성·기기|자동 검사+키보드 수동, 200% 확대, 모바일 키보드·safe area, 320/390/430 및 데스크톱|axe 도입 또는 동등 검사, Chromium/WebKit; 모바일 실제 기기 smoke|

DOM 내부 구현과 함수 호출 횟수를 검증하기보다 사용자가 읽는 결과와 실제 요청 body를 확인합니다. 단순 CSS 상수마다 unit test를 만들지 않습니다. query retry·clock·fixture를 고정해 비결정적 테스트를 피합니다.

## 시각 검증 기준

- `designs/verification/source`와 `figcraft`를 비교 자료로 사용합니다. HANDOFF-QA의 기존 MAE 수치는 새 React의 합격 점수가 아닙니다. 브라우저/폰트 렌더 차이를 허용하되 포스터 crop, 24px/16px 여백, 버튼·탭 높이, 마지막 콘텐츠 접근 가능 여부를 직접 확인합니다.
- 모든 이미지·폰트 로딩을 기다리고 고정 fixture·동일 viewport에서 캡처합니다. 긴 화면은 최초 viewport 외에 전체 콘텐츠와 하단 CTA를 검사합니다.
- 승인된 캡처 이후 프로젝트별 차이 임계값을 정합니다. 픽셀 점수만으로 문구 누락·버튼 가림·잘못된 작품 링크를 통과시키지 않습니다. 기본 밀리 전체 16개, 대안 테마는 로그인/추천/폼/오류 대표 화면을 검사합니다.

## 구현 완료와 리뷰 기준

- 16개 라우트가 각자의 데이터와 정상 이동을 제공합니다. 새로고침·직접 진입·로그인 만료에서도 무한 리다이렉트가 없습니다.
- 모든 읽기에 로딩/빈 상태/오류/재시도, 모든 쓰기에 검증/pending/성공/실패가 있습니다. 결과 화면은 2xx 이후만 노출됩니다.
- 계약과 MSW가 동일한 HTTP 동작을 사용하고 실제 서버 전환에 UI 수정이 필요하지 않습니다. fixture 문구를 운영 응답으로 오인하지 않습니다.
- 생성 타입 변경 누락, lint/typecheck/build 실패, 테스트 실패, 심각한 접근성 문제는 병합 전에 해결합니다. PR에는 연결 화면·작업 ID, 동작 변화, 검증, 남은 가정을 명시합니다.
- 자산 출처·폰트 라이선스, 디자인 보완, 인증·추천 정책이 합의되어야 출시할 수 있습니다. 설계 초안 작성 완료와 출시 준비 완료를 구분합니다.

## P1-2 완료 기록 (2026-11-18)

사용자 요청으로 API와 독립적인 공통 UI를 선행했습니다. [컴포넌트 매핑과 사용법](08-shared-ui.md)에 Props·Variant·추가 상태·도메인 경계를 기록했습니다. 기본 UI·레이아웃·테스트를 하나의 재사용 기반으로 검증합니다. P0-3/4는 여전히 미완료이며 다음 개발은 API client·생성 타입·MSW·세션 검증입니다. P2 인증, P3 카드/추천, P4~P5 기록, P6 내 정보, P7 통합 품질, P8 실제 연결 순서를 유지합니다.

## P0-3 완료 기록 (2026-11-19)

fetch client·OpenAPI 생성 타입·15개 API 함수와 MSW handler·Query 옵션/기록·프로필 mutation·Vitest HTTP 계약 검증·브라우저 Worker 검증을 완료했습니다. [상세 인계](09-api-foundation.md)를 확인합니다. P0-4 CI는 미완료이고 P1은 기존 완료 상태를 유지합니다. P2~P6의 API handler 기반을 앞당겨 구축했으며 기능 화면·인증 가드·오류 복구 UI·추천 polling을 완료한 것은 아닙니다. P7/P8도 미착수입니다.

## P2 완료 기록 (2026-11-19)

- [x] 로그인·회원가입·가입 완료 화면과 RHF/Zod 입력 검증입니다.
- [x] 기존 HTTP API/MSW 연동, 가입 비밀번호 재로그인, 401/409/422/429·네트워크 오류·지연 처리입니다.
- [x] Query 세션·보호 경로·안전한 내부 복귀·성공 state·로그아웃 및 캐시 정리입니다.
- [x] FigCraft 인증 3개 화면과 375×812 브라우저 대조, 좁은 폭·모의 safe area 검증입니다.

상세 구조·검증·제약은 [인증 구현 안내](10-auth.md)를 확인합니다. P0-4 CI는 미완료, P1 완료 상태는 유지합니다. P3~P5 기능 화면, P6 마이/프로필 화면, P7 실제 기기/WebKit, P8 서버 연결은 남아 있습니다. P6의 로그아웃 기능만 이번 인증 작업에서 선행했습니다. Mock 새로고침 세션 초기화는 기존 가정이며 실제 로그인 지속성 완료로 간주하지 않습니다.

최종 검증: Vitest 27개·Chromium 56개 통과, typecheck/lint/build/api:check/build:check 및 diff 공백 검사 통과입니다. 실제 기기·WebKit은 수행하지 않았습니다.

## P3 탐색 화면 진행 기록 (2026-11-19)

- [x] 홈·추천 목록·작품 상세, 동적 ID 연결과 기존 인증 가드입니다.
- [x] 원본 포스터/제목 매핑, 추천 캐시 공유, 로딩·오류·빈 결과·starter·갱신 polling입니다.
- [x] 신규 기록/기존 수정 진입점과 404·직접 진입 복귀입니다.
- [x] 작품 검색 화면·URL 검색 및 복원입니다(2026-11-20 후속 구현).

[탐색 구현 안내](11-discovery.md)에 구성·시각 비교·API 가정과 제약을 기록했습니다. P0-4 CI, P4/P5 기록 화면, P6 마이/프로필, P7 실제 기기/WebKit, P8 서버 연결은 남아 있습니다.

검증 결과: Vitest 29개, Chromium 전체 68개가 통과했습니다. typecheck, lint, build, api:check, build:check, diff 공백 검사가 통과했습니다. Chromium 스크린샷을 직접 확인했으며 실제 기기/WebKit은 실행하지 않았습니다.

## P3 검색·P4 기록 완료 기록 (2026-11-20)

- [x] history/search/record/record-done 네 화면과 인증·기존 탐색 연결입니다.
- [x] 사용자별 이력, URL 검색·필터, 한글 조합과 300ms debounce, 취소 가능한 조회·더 보기입니다.
- [x] 완료 정수 1~5 / 중단 trim 사유 1~200 검증, 비활성 필드 제거, 실패 입력 유지·멱등키 재사용·중복 제출 방지입니다.
- [x] 성공 응답 이후 완료 화면, 사용자·기록 ID가 없는 결과 접근 복귀, 이력·작품·추천·집계 무효화입니다.
- [x] FigCraft 네 화면 MCP 확인과 375×812 브라우저 대조, 폼 320/375/430 및 대안 테마·safe area 검증입니다.

구현과 검증 상세는 [시청 기록 구현 안내](12-watch-records.md)를 확인합니다. 기존 수정 링크는 P5 준비 화면으로 연결합니다. 완료 사유와 나중에 보기는 기존 계약에 없으므로 A09 합의 후 반영합니다. P0-4 CI, P5, P6, P7의 실제 기기·WebKit, P8은 미완료입니다.

최종 검증: Vitest 32개, Chromium 전체 77개 통과입니다. typecheck/lint/build/api:check/build:check와 diff 공백 검사를 통과했습니다. 실제 기기·WebKit은 미실행이며 Vite 단일 청크 크기 경고는 남아 있습니다.


## P5 기록 수정·삭제 완료 기록 (2026-11-20)

- [x] edit/edit-done/delete-done 세 화면, ID 조회·기존 입력 초기화와 성공 state 검증입니다.
- [x] 등록·수정 공통 폼, 완료↔중단 활성 필드만 전송, 실패 입력 보존·중복/이탈 방지입니다.
- [x] 삭제 확인 dialog·취소/Escape/포커스 복원, 204 성공 후 이동과 상세 캐시 제거입니다.
- [x] 412 충돌 시 명시적 최신 조회·폼 초기화, 미존재/권한 오류·삭제 리소스 재접근 안내입니다.
- [x] 사용자별 이력·필터·집계·작품·추천 캐시 무효화, 삭제된 행의 목록 캐시 제거입니다.
- [x] FigCraft 699/741/757 구조·상호작용·렌더와 375×812 브라우저 캡처 비교입니다. 폼 320/375/430px·세 테마·모의 safe area를 확인했습니다.

P0-4 CI, P6 마이·프로필, P7 실제 기기/WebKit, P8 서버 연결은 남아 있습니다. API 계약은 기존 초안을 유지하며 완료 사유·나중에 보기는 A09 합의 후 진행합니다. 상세 구현·제약은 [기록 구현 안내](12-watch-records.md)를 확인합니다.


P5 최종 검증: Vitest 35개, Chromium 전체 85개가 통과했습니다. typecheck/lint/build/api:check/build:check, 문서 상대 링크 및 diff 공백 검사를 통과했습니다. 운영 MSW/fixture 제외도 확인했습니다. 실제 기기·WebKit·실제 백엔드는 미실행이며 단일 JS 청크 약 530kB의 Vite 경고는 남아 있습니다.


## P6 마이·프로필 완료 기록 (2026-11-20)

- [x] my/profile/profile-done 세 화면, 현재 사용자·전체 건수와 이력/프로필/로그아웃 이동입니다.
- [x] 닉네임 trim 1~16자·미변경 검증, PATCH 성공 이후 완료 표시, 실패 입력 보존·중복/이탈 방지입니다.
- [x] 기존 me 캐시 공유, 진행 중 GET 취소 후 저장 응답 반영, 사용자 전환·로그아웃 격리와 결과 소유자 검증입니다.
- [x] MSW 변경 후 GET/재로그인 반영, 401/403/422/429/5xx, 집계 0건·로딩·오류·재시도입니다.
- [x] FigCraft MCP 세 화면과 375×812 캡처 비교, 320/375/430px·세 테마·모의 safe area 검증입니다.

상세는 [마이·프로필 구현 안내](13-profile.md)를 확인합니다.

|현재 범위|상태|
|---|---|
|P0|P0-1~3 완료, P0-4 CI 미완료|
|P1|토큰·공통 UI 완료|
|P2|login/signup/signup-done 3개 완료|
|P3|home/recommendations/detail/search 4개 완료|
|P4|history/record/record-done 3개 완료|
|P5|edit/edit-done/delete-done 3개 완료|
|P6|my/profile/profile-done 3개 완료|
|P7|16개 화면 Chromium Visual QA·UI 개선 완료, 리디 대비 협의·실제 기기·WebKit·전체 흐름 E2E 후속 검증|
|P8|실제 서버 연결·계약 합의 미완료|

총 16개 화면의 Mock 기반 기능 구현을 완료했습니다. 출시 완료를 의미하지 않습니다.

P6 최종 검증: Vitest 38개, Chromium 전체 91개 통과입니다. typecheck/lint/build/api:check/build:check, 문서 상대 링크 및 diff 공백 검사를 통과했습니다. 운영 MSW/fixture 제외를 확인했습니다. 실제 기기·WebKit·실제 백엔드는 미실행이며 JS 단일 청크 약 534kB의 Vite 경고는 남아 있습니다.

## P7 Visual QA 진행 기록 (2026-11-21)

- [x] FigCraft MCP로 16개 프레임·레이어를 조회하고 전체 PNG를 새로 내보냈습니다.
- [x] 실제 React 16개 화면의 준비 조건과 폰트·이미지 로딩 후 375×812에서 촬영·대조했습니다.
- [x] 320/375/390/430/1280px, 낮은 높이·모의 safe area·가로 넘침·고정 영역을 검증했습니다.
- [x] 가로 카드 키보드 스크롤·포커스 테두리, 가입 safe area 중복, 선택창·라벨·보조 타이포그래피를 개선했습니다.
- [x] 하단 safe area의 padding 변경에도 콘텐츠 여유 공간이 갱신되도록 BottomDock의 ResizeObserver를 border-box 관찰로 수정했습니다.
- [x] 승인되지 않은 픽셀 기준 이미지 대신 재촬영과 레이아웃·접근성 검증을 `npm run test:visual`로 자동화했습니다.
- [ ] 리디 대안 모드 주요 버튼 대비 3.05:1은 디자인 협의 후 보완해야 합니다.
- [ ] 실제 기기·WebKit·스크린리더·200% 확대 및 후속 전체 흐름 통합 E2E는 남아 있습니다.

범위·화면별 결과·실행 결과·제약은 [Visual QA 보고서](14-visual-qa.md)를 확인합니다. P0-4 CI와 P8 실제 서버 연결은 미완료입니다. P7 전체를 완료 처리하지 않습니다.

최종 검증: Chromium 107개, Vitest 38개 통과입니다. typecheck/lint/build/api:check/build:check와 문서 링크·diff 공백 검사를 통과했습니다. 리디 대비·실제 기기 검증·약 535kB 단일 청크 경고는 남아 있습니다.

## P7 Mock 통합 E2E 및 P0-4 CI 구성 (2026-11-21)

기존 107개 브라우저 검증을 재사용하고 신규 CRUD 전체 흐름·추천 응답 일치·사용자 전환/초기화·독립 오류 복구 9개를 추가했습니다. 실패 입력 마스킹 PNG, 인증 이후 제한된 행동 Trace, HTML 리포트, 반복 실행 명령과 최소 CI 구성을 제공합니다. 결과와 제한은 [E2E 보고서](15-e2e-regression.md)를 확인합니다. P1~P6 완료 상태를 유지하며 P7 실제 기기·리디 대비·접근성 잔여 검증과 P8 서버 통합은 미완료입니다.

## 성능·접근성·운영 빌드 준비 (2026-11-21)

P0-4에 운영 설정 실패 검증과 production smoke를 연결했습니다. P1~P6 기능 완료 상태를 유지합니다. P7에 전후 Lighthouse 측정, route lazy·폰트 서브셋, 16개 화면 axe, 키보드 이동, 리디 버튼 대비 보정을 추가했습니다. [성능·접근성 결과](16-performance-accessibility.md)와 [배포 안내](17-production-deployment.md)를 확인합니다.

|현재 작업|상태|
|---|---|
|P0|기반·CI 구성 및 로컬 검증 완료, 원격 Actions 실행 확인 미완료|
|P1~P6|16개 Mock 기능 완료 상태 유지|
|P7|성능 전후 기준·자동 접근성·키보드·Mock 회귀 완료, 실제 기기/스크린리더/확대·실사용 CWV·디자인 최종 승인 미완료|
|P8|운영 설정·배포 절차·산출물 smoke 준비, 실제 서버 계약·인증·staging·실제 배포 미완료|

이전 날짜별 완료 기록의 미완료 항목은 당시 상태입니다. 최신 상태는 이 표를 기준으로 확인합니다. 배포 플랫폼을 정하거나 실제 배포·원격 push를 수행하지 않았습니다.

최종 로컬 검증은 Chromium 131개·production smoke 2개·Vitest 38개, 타입·린트·운영 빌드·계약·Mock 제외·환경 차단 검사를 통과했습니다. npm audit은 0건입니다. 최초 검색 이동 타이밍 테스트 실패와 보정 내역은 품질 결과에 남겼습니다.
