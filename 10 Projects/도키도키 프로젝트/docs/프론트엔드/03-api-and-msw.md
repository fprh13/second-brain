# API 계약과 MSW 전략

## 계약 범위

[openapi.draft.json](openapi.draft.json)은 OpenAPI 3.1.1 형식의 실행 가능한 계약 초안입니다. 서버 구현 사실이 아니며 A01~A08 합의에 따라 수정합니다. JSON을 사용해 별도 YAML 도구 없이 파싱할 수 있습니다. 스키마와 operationId가 타입 생성의 원본이고, 이 문서는 동작 규칙의 원본입니다. [OpenAPI 3.1.1 명세](https://spec.openapis.org/oas/v3.1.1.html)의 `oneOf`로 완료/중단 입력을 구분합니다.

|HTTP / 경로 (`/api/v1` 기준)|operationId|주요 소비 화면|
|---|---|---|
|GET `/auth/csrf`|getCsrfToken|로그인·가입 전, 앱 부팅|
|POST `/auth/signup`|signup|가입 → 가입 완료|
|POST `/auth/login`|login|로그인|
|POST `/auth/logout`|logout|마이|
|GET `/me`|getMe|인증 가드·마이·프로필|
|PATCH `/me`|updateProfile|프로필 수정|
|GET `/anime`|searchAnime|작품 검색, q 빈 값은 초기 목록|
|GET `/anime/{animeId}`|getAnime|상세·등록 작품 요약|
|GET `/recommendations`|getRecommendations|홈·추천 목록|
|GET `/records/summary`|getRecordSummary|마이 전체 건수|
|GET `/records`|listRecords|이력 검색·상태 필터|
|POST `/records`|createRecord|기록 등록|
|GET `/records/{recordId}`|getRecord|수정 초기화|
|PUT `/records/{recordId}`|replaceRecord|완료/중단 전환을 포함한 전체 교체|
|DELETE `/records/{recordId}`|deleteRecord|기록 삭제|

## 공통 규칙과 인증 가정

- ID는 불투명 문자열, 날짜는 UTC ISO 8601입니다. enum은 `completed|stopped`, `high|medium|low`이고 화면 표시만 한글로 매핑합니다. 오류는 `{code,message,fieldErrors?,requestId?,existingRecordId?}`입니다. `message`를 HTML로 렌더링하지 않습니다.
- 같은 origin의 `/api/v1` 프록시 + HttpOnly/Secure/SameSite=Lax 세션 쿠키 `doki_session`을 제안합니다. fetch는 `credentials:'include'`입니다. GET `/auth/csrf`는 비인증 세션에서도 사용할 수 있고 `Cache-Control:no-store`로 응답합니다. 모든 쓰기는 반환 토큰을 `X-CSRF-Token`으로 전달합니다. 로그인/가입 뒤 세션 회전에 맞춰 토큰을 다시 읽습니다. cross-origin 배포는 credentials CORS·cookie 정책을 재협의합니다.
- 가입 201/로그인 200은 User와 Set-Cookie를 반환합니다. 가입 성공 자동 로그인은 첫 기록 CTA를 유지하기 위한 가정입니다. 세션 확인은 `/me`이고 refresh JWT 체계는 도입하지 않습니다. 만료 401이면 캐시 제거·로그인 복귀, CSRF 403이면 재발급 후 사용자가 재제출하도록 안내합니다.
- 로그아웃 204는 쿠키 만료를 포함합니다. 네트워크 실패 때 로그인 화면만 표시하고 세션 종료가 성공했다고 주장하지 않습니다. 실패 안내·재시도를 제공합니다.
- 로그인은 이메일 형식/빈 비밀번호만 로컬 검증하고 가입 정책의 최소 길이로 기존 계정을 막지 않습니다. 가입 비밀번호 8~128자는 임시 정책이며 trim하지 않습니다. 닉네임은 trim 후 1~16자, 사유는 trim 후 1~200자입니다. 서버의 길이 계산(Unicode code point 등)은 협의 대상입니다.

## 조회·추천·기록 동작

- 목록은 cursor 방식, 기본 limit 20·최대 50입니다. `items`, nullable `nextCursor`를 반환합니다. q는 trim, 최대 100자, 제목 부분 검색이며 정렬은 작품 `title,id`, 기록 `updatedAt desc,id`로 고정합니다. 커서는 서버가 생성하고 동일 q/status에만 유효합니다. UI는 더 보기로 시작하고 무한 스크롤·가상화는 실제 필요 시 도입합니다.
- 작품 조회는 nullable `recordId`를 반드시 포함하여 수정/신규를 판단합니다. 작품 상세는 nullable 개인 추천 정보를 포함합니다. 카탈로그 줄거리·제작사·OTT 등은 원본에 없어 필수 필드로 요구하지 않습니다.
- 추천 응답은 `status=ready|updating|unavailable`, `mode=personalized|starter`, `items` 최대 10개, `generatedAt` nullable입니다. ready여도 후보 부족으로 0~9개일 수 있습니다. 프론트는 실제 개수로 제목을 표시하고 가짜 항목으로 10개를 채우지 않습니다. starter는 이력 없는 사용자용 비개인화 안내를 사용합니다. unavailable/빈 결과는 이유 안내와 기록 추가 CTA를 제공합니다.
- 저장 트랜잭션과 추천 계산을 분리합니다. 기록 변경 후 추천 invalidate; updating이면 2초 간격 최대 30초, 보이는 화면에서만 재조회합니다. 시간 초과 시 마지막 결과와 갱신 중 안내·수동 재시도를 유지합니다. 서버의 최신 추천에는 기록된 작품을 제외합니다. 이전 결과를 반환할 때도 이미 기록된 작품은 제외하되 최신 개인화가 끝났다고 표시하지 않습니다. polling 대신 job/SSE가 필요하면 별도 합의합니다.
- 사용자당 작품당 기록 하나입니다. POST 중복은 409 `RECORD_ALREADY_EXISTS` + `existingRecordId`입니다. 클라이언트는 덮어쓰지 않고 수정 경로를 안내합니다.
- 쓰기 body는 `{animeId,entry}` 또는 `{entry}`입니다. entry는 `{status:'completed',rating:5}` **또는** `{status:'stopped',reason:'전개가 느려요'}`이며 다른 상태의 필드는 허용하지 않습니다. PUT은 기존 inactive 필드를 서버에서 제거합니다.
- 기록 응답은 `id,anime,entry,version,createdAt,updatedAt`입니다. PUT/DELETE는 읽은 version을 `If-Match` 문자열로 보내고 불일치는 412, 누락은 428입니다. 충돌 시 입력을 유지하며 최신 값 재조회/비교 후 다시 저장합니다. 무조건 자동 덮어쓰기는 금지합니다.
- 생성에는 `Idempotency-Key` UUID를 씁니다. 서버는 사용자+키+body 조합의 성공 결과를 24시간 재사용하고, 같은 키의 다른 body는 409입니다(가정). timeout 뒤 같은 작업을 재전송할 때 같은 키, 입력 변경으로 새 작업을 만들 때 새 키를 씁니다. PUT/DELETE의 불명확한 네트워크 결과는 GET으로 확인한 뒤 재시도합니다.
- 204 응답은 JSON 파싱하지 않습니다. 401/403/404/409/412/422/428/429/5xx를 구분합니다. 429는 Retry-After 동안 제출을 막습니다. form 422는 fieldErrors에 연결, 404는 목록 복귀, 5xx는 입력 유지·재시도입니다. 삭제 재시도에서 404는 이미 사라진 리소스 안내로 처리합니다.
- 소유권은 서버에서 검증합니다. 다른 사용자의 기록 ID는 존재 노출 방지를 위해 404로 반환하는 안입니다. 프론트 가드는 보안 경계가 아닙니다.

## MSW 구현안

브라우저는 `setupWorker`, Vitest는 `setupServer`를 사용하며 동일한 handlers를 공유합니다. HTTP 경계를 유지해 UI가 mock 객체를 직접 import하지 않습니다. [브라우저 설정](https://mswjs.io/guides/integrations/browser), [Node 설정](https://mswjs.io/guides/integrations/node)을 기준으로 구현합니다.

```text
mocks/
  fixtures/      # 작품 12개, 초기 기록 2개, 사용자·추천 예시
  db.ts          # 사용자별 Map, ID/clock, version, 세션/CSRF, 멱등키 상태
  handlers/      # auth, anime, recommendations, records, profile
  scenarios.ts   # 명명된 상태와 오류 주입
  browser.ts     # setupWorker
  server.ts      # setupServer
```

- `import.meta.env.DEV && VITE_API_MODE==='mock'`일 때만 동적 import하고 worker 시작 완료 후 렌더링합니다. CI E2E도 이 개발 서버를 사용합니다. production은 mock import가 제거되는지 검증하고 실제 배포 산출물에서 worker를 제외합니다. 운영 API로 우연히 넘어가지 않게 미처리 `/api/v1/*` 요청은 테스트 실패, 개발에서는 명시적 오류로 처리합니다. 이미지·폰트 요청은 통과시킵니다.
- db는 메모리 기반으로 새로고침 시 초기화하며 이 제한을 개발 문서에 표시합니다. 테스트마다 db·clock·handler·QueryClient를 초기화합니다. `resetHandlers`만으로 데이터가 초기화된다고 가정하지 않습니다. 무작위 실패는 금지하고 지연은 개발 300ms, 테스트는 결정적 값으로 설정합니다.
- fixture ID는 `anime-0`~`anime-11`, `record-10`, `record-11` 등 명시 문자열입니다. 원본 index와 매핑표를 둡니다. 초기 완료 1개(청춘 돼지 5점), 중단 1개(니세코이, 전개가 느려요), 추천 10개를 보존합니다. 신규 가입 시 기록은 0개입니다. 실제 닉네임/건수와 CRUD 결과를 db에서 계산합니다.
- 등록/수정/삭제는 실제 db를 변경하고 version 증가·중복·조건부 입력·cursor·검색·필터·권한을 검증합니다. 추천은 정적 순서를 기반으로 기등록 작품 제외를 모사합니다. 12개뿐이므로 후보 부족을 정상 테스트합니다. 실제 추천 알고리즘을 만들지 않습니다.
- fake session/CSRF는 네트워크 요청·응답 분기를 검증하지만 실제 HttpOnly·브라우저 cookie 보안과 동일하다고 주장하지 않습니다. 이 부분은 서버 통합 E2E에서 별도로 검증합니다. 실제 비밀번호·사용자 데이터는 fixture로 쓰지 않습니다.

|시나리오|주입 상태|검증 목적|
|---|---|---|
|returning-user|초기 2개 기록·10개 추천|16개 기본 화면|
|new-user|0개 기록·starter 추천|첫 기록과 빈 이력|
|completed / stopped|조건부 entry|평가 경계·빈 사유·상태 전환|
|search-empty / paginated|0건 / 21건 이상|필터·더 보기·cursor reset|
|recommendation-updating / unavailable|대기 후 ready / 실패|재조회 종료·저장 성공과 분리|
|duplicate / stale-version|409 / 412|기존 수정 이동·입력 보존|
|auth-expired / forbidden|401 / 403|캐시 제거·CSRF 복구|
|validation / rate-limited|422 / 429|필드 매핑·Retry-After|
|network-error / server-error / slow-save|네트워크 차단 / 503 / 3초 지연|입력 보존·중복 제출 방지|
|missing-anime / missing-record / image-error|404 / 이미지 실패|잘못된 링크·fallback|

## 계약 검증과 실제 서버 전환

P0에서 OpenAPI validator를 개발 의존성으로 고정하고 스펙 lint → 타입 생성 → 타입 검사 → MSW 요청/응답 JSON Schema 검증을 CI에 연결합니다. 생성 타입만으로 런타임 HTTP 응답이 검증되지는 않습니다. fixture와 handler 응답을 3.1 대응 validator로 검사하고 request의 잘못된 분기도 테스트합니다. Zod 폼 규칙과 계약의 경계값은 같은 테스트 케이스로 비교합니다.

백엔드 합의 후 문서·OpenAPI·생성 타입·MSW·계약 테스트를 같은 변경으로 갱신합니다. 실제 연결은 base URL/proxy 설정과 mock 비활성화로 전환하고 UI 코드에 real/mock 분기를 넣지 않습니다. staging에서 인증 쿠키·CSRF·CORS·세션 만료·소유권·중복/버전 충돌·추천 최종 일관성을 확인합니다.

## P0-3 구현 결과

15개 operationId의 API 함수·MSW handler·HTTP 계약 테스트를 구현했습니다. 실행법, 현재 동작과 초안의 제한은 [API 기반 사용 안내](09-api-foundation.md)를 확인합니다. worker는 public 복사 대신 Vite 개발 전용 middleware로 제공하며 MSW 3의 onUnhandledFrame으로 미처리 API를 차단합니다. CI 연결은 P0-4, 인증 가드는 P2, 추천 polling은 P3에 남아 있습니다.

## P2 현재 상태

인증 세 화면·보호 라우트·성공 결과 state·Query 세션·로그아웃을 연결했습니다. 가입 성공 CTA는 `/search`, 로그인은 허용된 내부 복귀 경로 또는 `/`로 이동합니다. API 계약 초안은 변경하지 않았으며 구현·검증·Mock 메모리 세션의 제한은 [인증 구현 안내](10-auth.md)를 확인합니다.
