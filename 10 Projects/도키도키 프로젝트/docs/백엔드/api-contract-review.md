# API 계약 정합성 분석

비교 기준은 [초안 원본](references/frontend/docs/openapi.draft.json), `references/frontend/src/features/*/api.ts`, [공통 client](references/frontend/src/shared/api/client.ts), [MSW handlers](references/frontend/src/mocks/handlers/index.ts)입니다. **초안 파일은 최초 커밋 6092e11 이후 변경 이력이 없고 현재 파일과 바이트가 같습니다.** 백엔드에 전달됐던 `docs/references/fronted-api.draft.json`도 같습니다. 따라서 아래는 초안 파일의 버전 간 변경표가 아니라 초기 기대와 현재 코드의 비교입니다.

## 일치: 경로·메서드·성공 DTO

15개 모두 API 함수와 handler가 존재하며 성공 상태/응답 구조는 초안에 대응합니다. 생성 타입 검사를 통과했습니다. 이 사실이 런타임 응답의 모든 분기나 실제 서버의 계약 준수를 보장하지는 않습니다. `/api/v1` 기준이며 아래 오류는 **초안에 선언된 전체 상태**입니다. 429/503 등은 기본 handler에서 자연 발생하지 않고 시나리오로 주입됩니다.

|메서드·경로|operationId|입력·헤더|성공|초안 오류 상태|
|---|---|---|---|---|
|GET `/auth/csrf`|getCsrfToken|없음|200 CsrfToken|400, 429, 503, default|
|POST `/auth/signup`|signup|SignupInput, X-CSRF-Token (header)|201 User|400, 429, 503, 409, 422, 403, default|
|POST `/auth/login`|login|Credentials, X-CSRF-Token (header)|200 User|400, 429, 503, 401, 422, 403, default|
|POST `/auth/logout`|logout|X-CSRF-Token (header)|204 본문 없음|400, 429, 503, 401, 403, default|
|GET `/me`|getMe|없음|200 User|400, 429, 503, 401, default|
|PATCH `/me`|updateProfile|ProfileInput, X-CSRF-Token (header)|200 User|400, 429, 503, 401, 422, 403, default|
|GET `/anime`|searchAnime|q (query), cursor (query), limit (query)|200 AnimePage|400, 429, 503, 401, default|
|GET `/anime/{animeId}`|getAnime|animeId (path)|200 AnimeDetail|400, 429, 503, 401, 404, default|
|GET `/recommendations`|getRecommendations|없음|200 RecommendationList|400, 429, 503, 401, default|
|GET `/records/summary`|getRecordSummary|없음|200 RecordSummary|400, 429, 503, 401, default|
|GET `/records`|listRecords|q (query), status (query), cursor (query), limit (query)|200 RecordPage|400, 429, 503, 401, default|
|POST `/records`|createRecord|CreateRecordInput, Idempotency-Key (header), X-CSRF-Token (header)|201 Record|400, 429, 503, 401, 404, 409, 422, 403, default|
|GET `/records/{recordId}`|getRecord|recordId (path)|200 Record|400, 429, 503, 401, 404, default|
|PUT `/records/{recordId}`|replaceRecord|ReplaceRecordInput, recordId (path), If-Match (header), X-CSRF-Token (header)|200 Record|400, 429, 503, 401, 404, 412, 422, 428, 403, default|
|DELETE `/records/{recordId}`|deleteRecord|recordId (path), If-Match (header), X-CSRF-Token (header)|204 본문 없음|400, 429, 503, 401, 404, 412, 428, 403, default|

공개는 getCsrfToken/signup/login만이며 나머지는 sessionCookie 보안을 상속합니다. 모든 쓰기에 X-CSRF-Token이 필요합니다. status 전체 조회는 query 생략이고 UI의 `all`을 API enum으로 보내지 않습니다. sort 파라미터는 없습니다.

## 일치: DTO 구조·필수와 nullable

아래 표는 스냅샷 스키마에서 추출했습니다. `필수`에 포함된 nullable 필드를 JSON에서 생략하면 계약 위반입니다. 객체 스키마는 additionalProperties:false이고 WatchEntry는 oneOf입니다. TypeScript의 `Dto`는 이 스키마의 별칭입니다.

|DTO|필드와 타입|필수 키|
|---|---|---|
|User|id: string (minLength=1, maxLength=128); email: string (format=email); nickname: string (minLength=1, maxLength=16)|id, email, nickname|
|Credentials|email: string (maxLength=254, format=email); password: string (minLength=1, maxLength=128)|email, password|
|SignupInput|email: string (maxLength=254, format=email); password: string (minLength=8, maxLength=128); nickname: string (minLength=1, maxLength=16)|email, password, nickname|
|ProfileInput|nickname: string (minLength=1, maxLength=16)|nickname|
|CsrfToken|token: string (minLength=1)|token|
|Anime|id: string (minLength=1, maxLength=128); title: string (minLength=1); posterUrl: string 또는 null (format=uri-reference); recordId: string 또는 null (minLength=1, maxLength=128)|id, title, posterUrl, recordId|
|RecommendationInfo|level: string [high, medium, low]; reason: string (minLength=1)|level, reason|
|AnimeDetail|id: string (minLength=1, maxLength=128); title: string (minLength=1); posterUrl: string 또는 null (format=uri-reference); recordId: string 또는 null (minLength=1, maxLength=128); recommendation: RecommendationInfo / null|id, title, posterUrl, recordId, recommendation|
|Recommendation|anime: Anime; level: string [high, medium, low]; reason: string (minLength=1)|anime, level, reason|
|RecommendationList|status: string [ready, updating, unavailable]; mode: string [personalized, starter]; items: Recommendation[] (maxItems=10); generatedAt: string 또는 null (format=date-time)|status, mode, items, generatedAt|
|CompletedEntry|status: string = completed; rating: integer (minimum=1, maximum=5)|status, rating|
|StoppedEntry|status: string = stopped; reason: string (minLength=1, maxLength=200)|status, reason|
|WatchEntry|CompletedEntry / StoppedEntry|분기 스키마 참조|
|CreateRecordInput|animeId: string (minLength=1, maxLength=128); entry: WatchEntry|animeId, entry|
|ReplaceRecordInput|entry: WatchEntry|entry|
|Record|id: string (minLength=1, maxLength=128); anime: Anime; entry: WatchEntry; version: integer (minimum=1); createdAt: string (format=date-time); updatedAt: string (format=date-time)|id, anime, entry, version, createdAt, updatedAt|
|RecordSummary|completedCount: integer (minimum=0); stoppedCount: integer (minimum=0); totalCount: integer (minimum=0)|completedCount, stoppedCount, totalCount|
|AnimePage|items: Anime[]; nextCursor: string 또는 null|items, nextCursor|
|RecordPage|items: Record[]; nextCursor: string 또는 null|items, nextCursor|
|Error|code: string; message: string; fieldErrors: object[]; requestId: string; existingRecordId: string (minLength=1, maxLength=128)|code, message|

Error.fieldErrors는 `{field:string,message:string}[]`입니다. optional 필드는 fieldErrors/requestId/existingRecordId이며 null 허용 선언은 없습니다. 날짜는 date-time 문자열입니다. StoppedEntry.reason과 입력 nickname은 `\S` 패턴으로 공백만 있는 입력을 금지합니다. 원시 길이 검사와 trim의 순서는 아래 H04를 참고합니다.

## 불일치·구현 간극: 초기 기대 → 현재 관찰 → 검토안

각 행은 실제 스키마 위반, 동작 문서와의 간극, Mock 한계를 구별합니다. 검토안은 미합의이며 이번에 원본을 수정하지 않았습니다.

|ID·분류|초안/문서의 기대 → 현재 구현|백엔드 검토와 프론트 영향·근거|
|---|---|---|
|H01 인증 Mock 한계|쿠키 doki_session, 가입/로그인 Set-Cookie, 로그아웃 쿠키 만료 → handler는 db.session 사용자 ID만 교체하고 쿠키 헤더를 발급하지 않음|실제 세션·쿠키 속성·만료·다중 탭·CSRF 회전을 A01에서 합의합니다. client는 credentials:include이므로 서버 통합 검증이 필요합니다. auth.ts/db.ts/draftSession.ts 근거입니다.|
|H02 추천 동작 간극|API·MSW 문서는 기록 변경 후 비동기 갱신을 설명 → CRUD는 revision만 증가하고 recommendationStatus를 updating으로 전환하지 않음|기록 변경 후 실제 계산 트리거/완료·실패 상태를 정의합니다. 수동 시나리오의 4초 ready 전환은 운영 SLA가 아닙니다. records.ts/recommendations.ts/scenarios.ts 근거입니다.|
|H03 오류 의미 간극|fieldErrors를 폼 필드에 연결 → 기본 readBody는 field에 SignupInput/CreateRecordInput 등 스키마 이름을 넣음|JSON 구조 자체는 유효하지만 UI의 email/nickname/entry.rating 등에 연결되지 않습니다. 필드 경로와 code 목록을 합의합니다. support.ts와 각 폼의 setError 분기 근거입니다.|
|H04 입력 경계 차이|문서는 trim 후 길이, JSON Schema는 code point 길이 → Zod/쿼리 검증은 JS 길이, 원시 MSW body는 schema 검사 후 trim|이모지·결합문자·앞뒤 공백 경계에서 결과가 달라질 수 있습니다. 예: 닉네임 이모지 9개는 스키마 9자지만 UI 18 code unit입니다. 정규화 순서와 길이 단위를 A02/A03에서 맞춥니다. validation.ts/model.ts/support.ts/auth.ts 근거입니다.|
|H05 경로 검증 누락|animeId/recordId는 1~128자 → MSW 경로는 길이 검증 없이 조회하여 긴 ID도 보통 404|서버의 파라미터 검증과 400/404 경계를 정하고 클라이언트 메시지를 맞춥니다. 각 detail handler와 OpenAPI parameters 근거입니다.|
|H06 커서 의미 추가|문서는 동일 q/status 유효 커서 → Mock은 path/q/status/사용자/global revision+offset을 base64로 묶음|다른 사용자의 쓰기에도 기존 커서가 400이 될 수 있고 서명은 없습니다. 정책을 그대로 복제하지 않고 데이터 변경 중 페이지 일관성을 합의합니다. support.ts/db.ts 근거입니다. limit은 커서 scope에 없습니다.|
|H07 429 UI 간극|API·MSW 문서는 429 Retry-After 동안 제출 차단 → 인증/프로필은 처리하지만 기록 폼에는 대기 분기가 없음|서버는 합의한 Retry-After를 제공하고 프론트 기록 폼도 별도 보완해야 합니다. RecordForm.tsx/useAuthForm.ts/ProfileEditForm.tsx 근거입니다.|
|H08 불명확한 쓰기 복구 간극|문서는 PUT/DELETE 통신 실패 시 GET 확인 후 재시도 → 현재 편집 폼은 같은 version으로 수동 재제출 가능, 412/428 후 명시적 최신 조회 제공|자동 성공 판정/자동 덮어쓰기는 없습니다. 첫 요청이 성공했다면 재시도 412/404가 발생할 수 있으므로 사용자 안내와 조회 복구를 합의합니다. RecordEditPage.tsx/RecordForm.tsx 근거입니다.|
|H09 예시 값 차이·스키마 위반 아님|OpenAPI posterUrl 예시는 /assets/photos/anime-0.jpg → fixture는 /images/auth/*.jpg 또는 /images/anime/*.jpg|uri-reference 타입은 일치합니다. 샘플 경로를 실제 서버 자산 경로로 고정하지 않습니다. catalog.ts 근거입니다.|
|H10 멱등 시간 Mock 한계|24시간 성공 재사용 → db.now는 기록 생성·수정마다 1초 증가하는 가상 시계이며 실제 시간 경과로 만료하지 않음|실제 시간 기준 TTL, 동시 같은 키, 삭제 후 원래 응답 재생을 합의합니다. 현재는 삭제 후에도 유효 키로 과거 생성 응답이 재생됩니다. records.ts/db.ts 근거입니다.|
|H11 추천 상태·상세 간극|목록·상세에 개인 추천 정보 → 상태는 사용자별이 아닌 전역이고 ready 전환은 목록 조회에서만 수행, 미기록 상세는 목록 밖 작품에도 고정 이유 제공|최신 결과에 포함되지 않은 작품의 상세 이유, 사용자별 계산 상태, generatedAt 의미를 합의합니다. 추천 JSON 구조 위반으로 단정하지 않습니다. anime.ts/recommendations.ts 근거입니다.|

## 미결정 계약

A01~A09는 여전히 미합의입니다. [결정 목록](open-decisions.md)에 책임 역할과 착수 조건을 기록했습니다. 특히 If-Match는 version 문자열을 보내지만 응답 ETag가 없고 중첩 작품 변경의 처리도 미정입니다. 헤더 교체/추가는 프론트 합의 없이 진행하지 않습니다. 에러 code는 스키마에서 자유 문자열이며 기존 백엔드 문서의 제안 code를 현재 Mock code로 오인하지 않습니다.

현재 Mock code 예시는 `UNAUTHENTICATED`, `INVALID_CREDENTIALS`, `CSRF_INVALID`, `INVALID_JSON`, `VALIDATION_ERROR`, `INVALID_QUERY`, `INVALID_CURSOR`, `ANIME_NOT_FOUND`, `RECORD_NOT_FOUND`, `EMAIL_ALREADY_EXISTS`, `RECORD_ALREADY_EXISTS`, `IDEMPOTENCY_KEY_REQUIRED`, `IDEMPOTENCY_CONFLICT`, `VERSION_REQUIRED`, `INVALID_VERSION`, `VERSION_CONFLICT`입니다. UI는 EMAIL_ALREADY_EXISTS/RECORD_ALREADY_EXISTS를 직접 분기하므로 이름 변경 시 반드시 인계합니다. requestId는 optional이며 기본 Mock은 발급하지 않습니다.

## 대표 요청·응답

다음은 현재 초안을 설명하는 예시이며 운영 데이터나 승인된 신규 계약이 아닙니다.

```http
POST /api/v1/records
Content-Type: application/json
X-CSRF-Token: <CSRF 응답 token>
Idempotency-Key: 11111111-1111-4111-8111-111111111111

{"animeId":"anime-0","entry":{"status":"completed","rating":5}}
```

```json
{"id":"record-new-2","anime":{"id":"anime-0","title":"호리미야","posterUrl":null,"recordId":"record-new-2"},"entry":{"status":"completed","rating":5},"version":1,"createdAt":"2026-11-25T00:00:00Z","updatedAt":"2026-11-25T00:00:00Z"}
```

수정은 `PUT /records/{recordId}`, `If-Match: "1"`, body `{"entry":{"status":"stopped","reason":"전개가 느려요"}}`이며 version 2의 전체 Record를 받습니다. 삭제는 같은 CSRF와 최신 If-Match를 보내고 204의 빈 본문을 받습니다. 중복 예시는 `{"code":"RECORD_ALREADY_EXISTS","message":"이미 기록한 작품입니다.","existingRecordId":"record-new-2"}`입니다.

프론트 client는 204를 파싱하지 않고 나머지 성공은 JSON Content-Type·JSON 파싱만 검사합니다. 응답 DTO 런타임 검증은 하지 않습니다. 모든 정상 DTO가 스키마를 지키는지는 서버 계약 테스트가 보장해야 합니다.
