# API Client·Query·MSW 기반 사용 안내

2026-11-19 P0-3을 완료했습니다. 백엔드 없이 실제 fetch 경계를 통해 초안의 **15개 API 전부**를 검증합니다. 인증 화면·세션 가드·기능 화면 연결은 P2~P6, CI는 P0-4, 실제 서버 통합은 P8에 남아 있습니다.

## 구조와 책임

- `src/shared/api/client.ts`: fetch, JSON/204, query string, 요청 헤더, AbortSignal, 기본 10초 timeout입니다. 네트워크/HTTP/취소/timeout/잘못된 JSON/설정 오류를 `ApiError`로 구분합니다. HTTP 오류의 `detail`, `status`, `retryAfter`를 보존합니다. 자동 쓰기 재시도는 없습니다.
- `config.ts`: `mock|real`과 API 주소를 검증합니다. real 주소 누락은 요청 시 설정 오류입니다. 아직 데이터 요청이 없는 준비 화면의 렌더링은 유지합니다.
- `generated/schema.d.ts`: OpenAPI에서 생성합니다. `dto.ts`는 편의 별칭과 활성 entry 필드 선택만 담당합니다. 화면 전용 모델은 실제 필요가 생길 때 추가합니다.
- `features/*/api.ts`: 기능별 요청 함수 15개입니다. 화면·MSW를 참조하지 않습니다. ID는 인코딩하며 생성 멱등키는 호출자가 작업 수명 동안 유지합니다.
- `features/*/queries.ts`: `queryOptions`와 기록/프로필 mutation hook입니다. `useQuery(meQuery())`처럼 사용합니다. 인증 화면에서 userId를 확인한 뒤 개인 query를 활성화합니다.
- `mocks/handlers`: auth(내 정보 포함), anime, recommendations, records입니다. `contract.ts`는 OpenAPI 3.1 스키마를 Ajv 2020으로 검증합니다. 요청과 테스트 응답이 같은 계약 원본을 사용합니다.
- `mocks/db.ts`: 사용자·기록·세션·CSRF·멱등키·고정 시작 시각을 메모리로 관리합니다. 새로고침하면 초기화됩니다. `server.ts`와 `browser.ts`는 동일 handlers를 사용합니다.

공통 응답 envelope를 새로 만들지 않았습니다. DTO는 `User`, `AnimePage`, `RecordPage` 등 초안의 응답을 그대로 사용합니다. 정렬은 작품 제목/ID, 기록 수정 시각 내림차순/ID이며 별도 sort 파라미터를 발명하지 않습니다.

## 환경과 실행

```sh
cp .env.example .env.local
npm ci
npm run dev
```

개발 mock은 `VITE_API_MODE=mock`, `VITE_API_BASE_URL=/api/v1`입니다. 다른 HTTP(S) 주소도 지정할 수 있습니다. real 전환은 아래 두 값만 바꾼 뒤 개발 서버를 재시작합니다.

```dotenv
VITE_API_MODE=real
VITE_API_BASE_URL=https://실제-백엔드-호스트/api/v1
```

동일 출처 프록시를 구축한 환경에서는 `/api/v1`을 사용할 수 있습니다. 이 저장소가 백엔드 프록시를 자동 제공하지는 않습니다. real의 실패를 성공 fixture로 바꾸지 않습니다. VITE 변수는 공개되므로 비밀값을 넣지 않습니다.

Worker는 DEV+mock에서만 동적 import하고 준비 완료 후 앱을 렌더링합니다. Vite 개발 전용 middleware가 설치된 MSW의 공식 worker 파일을 제공합니다. `public/`에 worker를 복사하지 않아 `dist/`에 남지 않습니다. `npm run build:check`는 운영 JS/HTML의 MSW·fixture 흔적과 worker 파일을 검사합니다. production에 mock을 잘못 지정해도 Worker는 활성화되지 않으며 API 호출은 설정 오류로 차단됩니다.

MSW 3의 `onUnhandledFrame`을 사용합니다. 개발은 설정한 API origin/path의 미처리 요청을 오류로 막고 정적 자산은 통과시킵니다. Node 테스트는 모든 미처리 요청을 차단합니다.

## Query 사용 규칙

조회 staleTime 30초, 작품 조회 5분, 미사용 캐시 GC 5분입니다. 네트워크 오류와 HTTP 5xx 조회만 1회 재시도하고 4xx/timeout/취소 및 mutation은 자동 재시도하지 않습니다.

키는 설계대로 `['me']`, `['anime',userId,...]`, `['records',userId,...]`, `['record-summary',userId]`, `['recommendations',userId]`입니다. 목록 조건(q/status/cursor/limit)을 키에 포함합니다. 기록 mutation 성공 후 상세를 반영하고 이력·집계·작품·추천을 무효화합니다. 삭제는 해당 상세 query 취소/제거 후 관련 조회를 무효화합니다. 실패 시 성공 이동이나 낙관적 데이터 변경을 하지 않습니다.

화면은 query의 `isPending/isError/data`와 mutation의 `isPending/error/isSuccess`를 사용합니다. 성공 응답 이후 결과 화면으로 이동하고 422의 fieldErrors, 409의 existingRecordId, 412/428, 429의 Retry-After를 해당 UI에 연결하는 작업은 P2~P6입니다. `clearSessionCache`는 진행 중 조회 취소 후 캐시를 제거하며 로그인/가입 사용자 전환·로그아웃 성공·세션 만료 시 P2에서 연결합니다. 인증 mutation과 보호 라우트는 아직 연결하지 않았습니다.

## 초안 인증과 Mock 한계

A01의 쿠키 `credentials:include` 가정을 앱 어댑터에 격리했습니다. 공통 client는 credentials/getHeaders 확장 지점만 제공합니다. 쓰기 직전 `/auth/csrf`를 조회하므로 로그인/가입 회전 뒤 토큰을 오래 보관하지 않습니다. refresh JWT, localStorage, CSRF 실패 시 자동 재제출을 도입하지 않았습니다.

Mock은 한 브라우저 탭/Node 서버 인스턴스의 메모리 세션이며 실제 Set-Cookie·HttpOnly·Secure·SameSite·다중 탭 세션을 모사하지 않습니다. 시작은 비로그인입니다. 공개 검증 계정 `doki@example.com / mock-password`로 로그인할 수 있습니다. 가입은 자동 로그인·빈 기록을 제공하며 입력 비밀번호를 DB에 저장하지 않습니다. **Mock 재로그인은 가입 시 입력한 값과 무관하게 공개 검증 비밀번호만 사용**합니다. 인증 자격 증명/쿠키 보안 검증은 실제 서버에서 수행해야 합니다.

기록 생성·전체 교체·삭제는 DB, version, 집계, 작품 recordId, 추천 제외 목록을 변경합니다. 409 중복, 412 충돌, 428 누락, 사용자별 소유권 404를 검증합니다. 멱등키는 사용자+정규화 body로 성공 결과를 24시간 보관하며 mock 시계는 고정 시각에서 쓰기마다 증가합니다. 실제 시간 경과는 테스트에서 `db.now`로 제어합니다. cursor는 검색/필터/사용자/DB revision에 묶이며 변경되면 400으로 응답합니다. 이 추가 Mock 제약은 실제 서버의 cursor 보장으로 간주하지 않습니다.

초기 작품은 12개, 기록은 완료 1개/중단 1개, 추천은 10개입니다. `anime-0=호리미야`, `anime-10=청춘 돼지`, `anime-11=니세코이`, `record-10/11`을 계약 예시와 맞췄습니다. P3에서 12개 제목·이미지 매핑을 FigCraft 원본으로 맞추고 내장 자산을 앱에 복사했습니다. 상용 권리 확인은 별도입니다. [탐색 구현 안내](11-discovery.md)를 확인합니다.

추천은 정적 순서에서 기록한 작품을 제외합니다. 후보가 부족하면 10개 미만을 반환합니다. `setScenario`의 returning-user/new-user/auth-expired/recommendation-updating/recommendation-unavailable과 `failureScenario`의 network/slow/HTTP status를 `server.use` 또는 `worker.use`로 주입할 수 있습니다. 테스트마다 DB·시계·handlers·QueryClient를 초기화합니다. 검색 빈 결과는 q로, 21개 이상 페이지는 테스트 전용 확장 fixture로 재현합니다. P3에서 추천 updating→ready 시나리오 전이·보이는 화면에서 최대 30초 polling을 구현했으며 실제 추천 알고리즘은 구현하지 않았습니다.

## 계약 생성과 검증

```sh
npm run api:generate  # OpenAPI validator + 타입 생성
npm run api:check     # 스펙 검증 + 생성 파일 최신 여부
npm run typecheck
npm run lint
npm run test:unit
npm run test:e2e
npm run build
npm run build:check
```

`npm test`는 Vitest와 Playwright를 순서대로 실행합니다. 특정 E2E는 `npm run test:e2e -- e2e/api.spec.ts`로 실행합니다. 생성 파일은 직접 수정하지 않습니다. 명세가 바뀌면 API 함수·handlers·테스트·설계를 함께 갱신합니다. 운영 client는 타입 단언만 하며 모든 서버 응답의 런타임 스키마 검증을 수행하지 않습니다. HTTP 응답 스키마는 계약 테스트에서 검사합니다.

현재 openapi-typescript 7.13.0의 TypeScript peer 범위가 5.x이므로 프로젝트의 TS 6을 유지하고 `.npmrc`에 legacy-peer-deps를 기록했습니다. lockfile과 생성/타입/실행 테스트로 현재 조합을 확인했습니다. peer 범위 공식 지원이 확대되면 이 설정을 제거하고 일반 설치를 재검증해야 합니다. 최초 설치 때 사용자 npm 캐시 소유권 오류가 있어 `/private/tmp/dokidoki-npm-cache`를 사용했습니다. 설치 결과 moderate 취약점 9건이 보고되어 별도 의존성 점검이 남습니다.

## 완료·후속 범위

[API 목록](03-api-and-msw.md)의 15개 operationId는 전부 호출 함수·handler·성공 HTTP 테스트를 제공합니다. 미구현 API operation은 없습니다. P2 인증과 P3 홈·추천·상세/polling은 구현했습니다. P0-4 CI, P3 검색, P4~P6 기록·프로필 UI와 복구, P7 통합 시각 QA, P8 서버 보안·CORS·추천 일관성 검증은 완료한 것으로 처리하지 않습니다.

A01~A08은 여전히 미확정입니다. 서버 연결 전 base URL/proxy·쿠키/CSRF·가입 자동 로그인·입력 정책·소유권·If-Match·멱등키 수명·cursor·에러 형식·추천 갱신 의미를 합의해야 합니다.

검증 결과는 [검증 기록](06-validation.md)의 P0-3 항목을 확인합니다. 참고한 공식 문서는 [MSW 브라우저 통합](https://mswjs.io/guides/integrations/browser), [openapi-typescript Node API](https://openapi-ts.dev/node), [Query mutation 무효화](https://tanstack.com/query/latest/docs/framework/react/guides/invalidations-from-mutations)입니다. MSW 세부 옵션은 설치한 3.0.7 타입 정의에 맞췄습니다.
