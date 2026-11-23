# 시청 이력·검색·기록 CRUD 구현 안내

2026-11-20 기준 P3 검색과 P4 네 화면을 구현했습니다. 실제 백엔드 없이 기존 MSW HTTP 경계에서 검색 → 선택 → 등록 → 완료 → 이력 확인 흐름이 동작합니다.

## 화면과 컴포넌트

- `HistoryPage`: 사용자 이력, 제목 검색, 전체/완료/중단 필터, 더 보기와 새로고침입니다. 행은 동적 recordId 수정 경로, 추가는 검색으로 연결합니다. 수정·삭제는 P5의 RecordEditPage로 연결합니다.
- `SearchPage`: 초기 목록과 제목 검색, 기존 기록 여부 분기, 더 보기입니다. query는 URL이 소유하고 `UrlSearchInput`은 한글 조합이 끝난 뒤 300ms debounce합니다. 초기화 버튼과 뒤로 복원을 지원합니다.
- `RecordPage`/`RecordForm`: 실제 animeId로 작품 조회, RHF 로컬 입력·Zod 상태별 검증·생성 Mutation입니다. 작품 미존재/기존 기록/실패를 구분합니다. 기본 평점은 5입니다.
- `RecordDonePage`: 생성 응답으로 만든 사용자·기록 ID·summary state를 검증합니다. 직접 진입·잘못된 state는 이력으로 replace합니다. 확인 버튼도 replace하여 폼 재제출을 방지합니다.
- 신규 `AnimeRow`는 이력/검색/등록 요약에서 제목·포스터·보조 설명을 공유합니다. 기존 Poster, SearchInput, SelectField, TextAreaField, FilterChip, AppHeader, BottomAction, Button, QueryFeedback, EmptyState, ResultView를 재사용합니다.

## 계약과 데이터

GET `/records`, GET `/anime`, GET `/anime/{animeId}`, POST `/records`를 기존 API client로 사용합니다. OpenAPI·생성 타입·MSW handler를 확장하지 않았습니다. MSW 메모리 DB의 생성 결과가 목록/작품 recordId/집계/추천에 반영됩니다. 운영 화면은 fixture를 직접 읽지 않습니다.

- 완료는 `{status:'completed',rating:1..5}` 정수만 보냅니다.
- 중단은 `{status:'stopped',reason}`이며 앞뒤 공백 제거 후 1~200자입니다.
- 상태 변경 시 로컬 입력을 유지하지만 비활성 필드는 검증 변환과 기존 `activeEntry`에서 제거합니다.
- 완료 사유와 나중에 보기는 기존 계약에 없어 구현하지 않았습니다. [A09 협의 항목](05-open-questions.md)을 확인합니다.
- POST 진행 중 동기 ref 잠금과 disabled 버튼으로 중복을 차단합니다. 동일 body 재시도는 같은 Idempotency-Key, body 변경은 새 키를 사용합니다. 입력과 키는 메모리에서만 유지합니다.
- 409는 기존 수정 링크, 422는 필드 오류, 403은 재제출 안내, 401은 세션/캐시 정리입니다. 실패 후 입력은 유지합니다. 미저장 이동은 인라인 안내, 탭 닫기는 beforeunload 경고로 처리합니다. 저장 중 내부 이탈은 차단합니다.

## Query와 복원

기존 사용자별 키의 하위 `infinite` 키에 페이지를 누적합니다. 일반 페이지 Query와 데이터 형태를 분리하고 사용자 prefix 무효화는 공유합니다. 서버 nextCursor만 사용하며 q/status가 바뀌면 다른 키의 첫 페이지로 조회합니다. 검색 캐시는 5분입니다. Query의 AbortSignal을 기존 HTTP client에 전달하므로 이전 응답이 현재 검색 키를 덮지 않습니다.

성공 시 기존 생성 Mutation이 detail 캐시를 설정하고 사용자 이력·집계·작품·추천을 무효화합니다. 실패한 추천 재조회는 기록 저장 실패로 취급하지 않습니다. 로그인/가입/로그아웃 때 기존 `replaceSession`이 개인 캐시를 제거합니다. 결과 state도 현재 사용자와 ID를 검증하며 인증 근거로 쓰지 않습니다.

검색→폼→뒤로는 검색 URL과 앱 ScrollRestoration을 사용합니다. 직접 진입의 뒤로는 이력으로 이동합니다. 이력 필터는 history entry로 남기고 검색 타이핑은 replace합니다.

## 디자인 검증

FigCraft MCP로 422(history), 524(search), 641(record), 681(record-done)의 구조·상호작용과 스크린샷을 확인했습니다. 브라우저 375×812 캡처와 직접 비교해 72×72 행 포스터, 24/16px 여백, 상태 선택, 56px 버튼, 고정 CTA·탭, 결과 메시지를 확인했습니다. fieldset 기본 여백과 행 높이, 결과 요약 왼쪽 정렬을 보정했습니다.

캡처는 E2E 실행 시 `test-results/records-{history,search,form,done}.png`에 생성되며 Git에는 포함하지 않습니다. 검색 결과는 계약의 제목 정렬이므로 원본 예시 순서와 다릅니다. 긴 제목은 자연 줄바꿈하며 강제 개행을 복제하지 않습니다. 이력 새로고침/오류·빈 상태/미저장 안내는 원본에 없는 최소 복구 UI입니다. 디자인 최종 승인이나 픽셀 단위 동일성을 뜻하지 않습니다.

폼의 320/375/430px, 세 테마와 모의 하단 safe area 34px에서 가로 넘침·CTA 접근을 검사했습니다. 실제 모바일 키보드·기기·WebKit은 검증하지 않았습니다.

## 검증과 후속 단계

Vitest에서 입력 경계, 성공 state 사용자/ID, HTTP 검색·생성·이력 갱신 및 다른 사용자 캐시 격리를 검증합니다. Playwright에서 완료/중단 등록, 실패 재시도와 동일 멱등키, 중복 클릭, 한글 조합·빠른 검색·늦은 응답, 빈/오류/로딩·복구, 필터 복원, 더 보기, 409/401을 검증합니다. 기존 인증·추천·상세·라우팅 테스트도 함께 실행합니다.

Mock 새로고침은 세션과 신규 기록을 초기화합니다. 실제 서버 영속성·쿠키 보안·소유권·다중 탭·멱등키 보관 기간은 백엔드 통합 때 검증합니다. P5 수정/삭제를 완료했으며 후속 범위는 P0-4 CI, P6 마이/프로필입니다. 프로덕션 빌드는 단일 JS 청크가 약 525kB(압축 약 162kB)로 Vite의 500kB 경고가 남아 있어 후속 라우트 분할을 검토합니다.

최종 검증: Vitest 32개, Chromium 전체 77개 통과입니다. typecheck/lint/build/api:check/build:check와 diff 공백 검사를 통과했습니다. 실제 기기·WebKit은 미실행이며 Vite 단일 청크 크기 경고는 남아 있습니다.


## P5 수정·삭제 구현

`RecordEditPage`는 ID 기반 조회·작품 요약·뒤로 복원을 담당합니다. `WatchRecordForm`은 등록/수정에서 RHF 초기값, 상태별 Zod 검증, pending 잠금, 필드 오류, 이탈 보호를 공유합니다. 등록의 멱등키는 기존 `RecordForm` 어댑터에, 수정/삭제 Mutation과 원본 version은 편집 세션에 유지합니다. 변경 성공 뒤 이동 콜백을 실행하여 이탈 보호가 성공 이동을 막지 않게 합니다.

`DeleteConfirmation`은 native dialog로 키보드 포커스 가두기·취소·Escape·닫은 뒤 포커스 복원을 제공합니다. 실패하면 입력과 대상을 유지하며, 삭제 중 수정과 중복 삭제를 막습니다. `RecordDonePage`는 기존 ResultView로 등록·수정·삭제 결과를 조합하고 작업 종류·사용자·기록 ID를 검증합니다. 인증된 사용자의 증거 없는 결과 접근은 이력으로 복귀합니다. 비인증 결과 URL은 기존 인증의 안전한 returnTo 정책에 따라 로그인 후 홈으로 복귀합니다.

기존 `getRecord`, `replaceRecord`, `deleteRecord`와 MSW를 사용합니다. PUT/DELETE는 편집 시작 시 version을 `If-Match`로 보내며 PUT 200/DELETE 204 이후에만 완료를 표시합니다. 계약·생성 타입·handler 변경은 없습니다. 412/428 충돌은 입력을 유지하고 최신 기록 불러오기(입력 초기화)로 복구합니다. 타인/미존재 404와 권한 403은 기록 접근 불가 안내입니다.

수정 응답을 detail에 저장하고 이력 전체 prefix(검색·상태·페이지 포함), 집계, 작품, 추천을 무효화합니다. 삭제는 진행 중 기록 조회를 취소하고 일반/무한 목록 캐시에서 해당 행을 제거한 뒤 detail 캐시를 삭제합니다. 따라서 후속 조회 실패 중에도 삭제한 행이 오래된 목록에서 다시 보이지 않습니다. 낙관적 업데이트는 사용하지 않습니다. 로그인·로그아웃의 기존 개인 캐시 정리와 사용자별 키를 유지합니다.

FigCraft MCP로 edit(699), edit-done(741), delete-done(757)의 구조·문구·상호작용 및 렌더를 확인했습니다. 실제 375×812 캡처에서 포스터/필드/삭제 버튼/하단 CTA 위치와 결과 레이아웃을 대조했습니다. 제목은 원본 강제 개행 대신 자연 줄바꿈이고 select 화살표는 브라우저 native 형태입니다. 수정 완료 요약은 고정 5점 예시 대신 실제 응답을 표시합니다. 새 픽셀 MAE나 완전 일치는 주장하지 않습니다. 캡처는 `test-results/record-edit.png`, `record-edit-done.png`, `record-delete-done.png`이며 Git에는 포함하지 않습니다.

테스트는 실제 HTTP CRUD·소유권·버전 충돌·필드 제거, Query 필터/집계/작품/추천 갱신, 삭제 상세 제거, 완료 state의 사용자/작업/ID 격리를 확인합니다. E2E는 폼 초기값·상태 전환·실패 재시도·중복 차단·삭제 취소/성공·삭제 재접근·직접 결과 접근·충돌 복구를 검증합니다. 실제 기기·WebKit·실제 서버 연결은 미실행입니다.


P5 최종 검증: Vitest 35개, Chromium 전체 85개가 통과했습니다. typecheck/lint/build/api:check/build:check, 문서 상대 링크 및 diff 공백 검사를 통과했습니다. 운영 MSW/fixture 제외도 확인했습니다. 실제 기기·WebKit·실제 백엔드는 미실행이며 단일 JS 청크 약 530kB의 Vite 경고는 남아 있습니다.
