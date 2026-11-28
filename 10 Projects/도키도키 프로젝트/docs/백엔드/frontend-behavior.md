# 프론트엔드와 MSW 실제 동작

## 화면·상태 소유권

[16개 화면 원본](references/frontend/docs/01-screens-and-flows.md)과 `references/frontend/src/pages/`를 대조했습니다. 로그인→가입→가입 결과→검색→등록→등록 결과→이력, 홈→추천→작품 상세→등록/수정, 수정→수정 결과/삭제 확인→삭제 결과, 마이→프로필→결과/로그아웃 흐름입니다. 성공 결과는 응답 이후 router state로 만들고 사용자/기록 ID가 맞지 않으면 목록 등으로 복귀합니다. 이 state는 서버 인증 증거가 아닙니다.

TanStack Query가 서버 상태를, URL이 q/status를, 폼이 편집 값을 소유합니다. `shared/routing/UrlSearchInput.tsx`는 한글 조합을 고려한 300ms 검색이며 AbortSignal로 오래된 조회를 취소합니다. 토큰·기록을 localStorage에 저장하지 않습니다.

|처리|실제 코드 동작|서버 연동 시 의미|
|---|---|---|
|세션 확인|GET /me 401은 null, 네트워크/503은 오류 화면|모든 오류를 미인증으로 반환하지 않습니다.|
|사용자 전환|다른 query 취소·제거, me 교체; 개인 key에 userId 포함|서버 소유권 검사도 별도로 필요합니다.|
|조회|기본 staleTime 30초/gcTime 5분, 작품 5분, network/5xx만 1회 재시도|timeout/decode/4xx 자동 재시도는 없습니다.|
|쓰기|mutation 자동 재시도 없음, 비관적 성공 처리|서버 성공 응답의 최종 값을 반환해야 합니다.|
|생성|같은 폼에서 body가 같으면 UUID 재사용, 바뀌면 새 UUID|페이지를 떠나거나 새로고침하면 키가 유지되지 않습니다.|
|수정|편집 시작 데이터/version 고정, 백그라운드 응답으로 덮지 않음|412 후 사용자가 최신 조회·초기화를 선택합니다.|
|CRUD 성공|기록·집계·작품·추천 invalidate; 삭제 상세 제거·목록 제거|서버 집계와 recordId도 실제 저장 상태와 일치해야 합니다.|
|추천|updating 2초/최대 30초, background polling 꺼짐; 수동 refresh는 GET|새 계산 요청 API는 없으므로 재계산 책임을 합의합니다.|
|프로필|저장 응답 me 반영 전 기존 GET 취소, 사용자 ID 재확인|늦은 다른 사용자 응답을 UI에 반영하지 않습니다.|
|로그아웃|204 또는 이미 만료된 401은 캐시 종료, 네트워크 실패는 유지|로그아웃 재호출·세션 만료 정책을 명시합니다.|

## Mock 정상 흐름과 데이터 변경

[db.ts](references/frontend/src/mocks/db.ts)는 users/records/passwordDigests/idempotency Map과 하나의 session을 보유합니다. resetDb 시 초기 사용자 1명, 작품 12개, 완료 1개(평가 5)·중단 1개(사유)를 구성하며 비로그인 상태입니다. 신규 가입자의 기록은 0개입니다. 사용자별 조회는 ownerId로 분리하지만 하나의 JS 컨텍스트에서 동시 사용자 세션을 재현하는 구조는 아닙니다.

- auth: 등록된 이메일을 정확한 문자열로 비교합니다. SHA-256 digest 비교는 개발용으로 운영 비밀번호 해시 요구를 만족하는 구현으로 보지 않습니다. 로그인/가입 시 세션 사용자와 가상 CSRF를 회전합니다. 쿠키는 만들지 않습니다.
- anime: 12개 title 부분 검색, localeCompare 정렬, 현재 사용자의 기록에서 recordId를 조합합니다. 다국어/시리즈 데이터는 없습니다.
- records: 생성은 소유자+작품 중복 확인 후 Map 저장/version=1, 수정은 body 파싱 이후에도 version을 다시 검사하고 entry를 교체/version 증가, 삭제는 Map에서 제거합니다. DB 트랜잭션·프로세스 간 경쟁을 검증하지는 않습니다.
- summary: 현재 사용자 전체 기록을 매번 계산합니다. 검색 필터/현재 페이지와 무관합니다.
- recommendations: 정적 카탈로그 순서에서 본인 기록 작품을 빼고 최대 10개, ID별 고정 level/reason을 조합합니다. 이력 유무만 mode에 반영합니다. 신규 사용자는 12개 중 앞 10개, 기본 사용자는 기록 2개를 뺀 10개입니다. 기록 삭제는 후보 복귀로 나타납니다.
- profile: nickname을 trim하여 users Map에 저장하고 GET/재로그인에서 최신 값을 읽습니다. 변경 횟수·중복 닉네임·version 검사는 없습니다.

## 오류와 경계 조건

공통 route는 테스트 외 300ms 지연 후 보호 API의 인증을 먼저 확인하고 쓰기 CSRF를 확인합니다. 미인증 쓰기+잘못된 CSRF는 401이 먼저입니다. 공개 로그인/가입도 CSRF는 필요합니다. 잘못된 JSON 400, body 스키마 검증 실패 422, 없는/타인 기록 404, 중복 409, 버전 누락 428/문법 400/충돌 412를 재현합니다.

AJV는 OpenAPI 스키마로 body를 검사하고 일부 HTTP 테스트가 성공 응답을 검사합니다. handler의 모든 응답을 자동으로 schema 검증하는 middleware는 없습니다. q/status/limit/cursor는 수동 검사이며 모든 query/path/header를 OpenAPI로 일괄 검증하지 않습니다. 초과 평점·소수·빈 사유·inactive 필드·잘못된 커서·타인 기록·멱등 재전송은 [HTTP 테스트](references/frontend/src/test/api.test.ts)에 사례가 있습니다.

[scenarios.ts](references/frontend/src/mocks/scenarios.ts)의 returning-user/new-user/auth-expired/recommendation-updating/recommendation-unavailable는 resetDb를 수행하는 테스트 편의 기능입니다. updating은 4초 후 다음 추천 목록 조회 때 ready로 바뀝니다. `failureScenario`는 network/지연 후 503/지정 HTTP 상태를 주입하며 429는 Retry-After:10입니다. `delayScenario`는 기본 3초 지연 후 원래 handler로 넘깁니다. 실제 요청 제한·장애율·AI 시간 기준이 아닙니다.

## 운영 요구로 복제하지 않을 항목

메모리 새로고침 초기화, 공개 테스트 자격, index 기반 fixture ID, SHA-256 단순 digest, global session/CSRF/recommendationStatus/revision, base64 offset 커서, 기록 생성·수정마다 1초 증가하는 가상 시계, 정적 추천 문구/순위, 오류 주입·reset 시나리오는 Mock 전용입니다. fixture 소스의 `mock-password` 등은 공개 테스트 상수이며 실제 비밀값은 수집하지 않았습니다.

중복/상태/멱등성/삭제 정책은 테스트에서 관찰되지만 승인된 비즈니스 정책은 아닙니다. 테스트 재현만으로 운영 DB 영속성·쿠키 보안·다중 인스턴스 경쟁·실제 추천 품질이 검증되었다고 보고하지 않습니다. 문서와 코드 간 구체적 간극은 [H01~H11](api-contract-review.md)을 확인합니다.

## 실제 연결 인계

기본 API 모드는 real이고 주소 누락은 설정 오류입니다. 운영 빌드는 명시적 API base와 real을 요구하며 MSW를 제외하는 구성이 있습니다. 권장 동일 출처 `/api/v1` 프록시와 cross-origin 선택은 A01에서 결정합니다. `/api/*` 오류에 SPA HTML을 반환하면 client에서 decode 오류가 됩니다. 개인 응답 캐시·쿠키·CORS·CSRF·실제 저장 후 조회는 staging에서 검증해야 합니다. 이번 작업은 호스팅이나 운영 빌드를 실행하지 않았습니다.
