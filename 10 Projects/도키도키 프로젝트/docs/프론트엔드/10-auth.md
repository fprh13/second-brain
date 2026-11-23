# P2 인증 구현 안내

로그인 `/login`, 회원가입 `/signup`, 가입 완료 `/signup/done`를 구현했습니다. 기존 `auth/api.ts`, profile의 `/me` 및 `['me']`, HTTP Client, draftSession, MSW handler와 공통 UI를 재사용합니다. OpenAPI 계약 변경은 없습니다.

## 실행과 사용자 흐름

`.env.example`의 mock 설정으로 `npm run dev`를 실행합니다. 공개 테스트 계정은 `doki@example.com` / `mock-password`입니다. 직접 회원가입한 계정도 로그아웃 후 가입 당시 비밀번호로 로그인할 수 있습니다. 실제 개인정보를 넣지 않습니다.

로그인은 원래 요청한 허용된 내부 경로(검색 조건·해시 포함), 없으면 `/`로 이동합니다. 회원가입은 201 응답 뒤 `{kind:'signup', entityId}` state와 함께 완료 화면으로 replace하며 첫 기록 CTA는 `/search`로 이동합니다. 완료 화면은 현재 사용자와 결과의 ID를 대조합니다. 직접 진입은 인증 상태에 따라 `/search` 또는 `/login`으로 replace합니다. 이후 작품·기록 화면은 아직 준비 화면입니다.

인증된 사용자가 로그인·가입 경로로 새로 진입하면 홈으로 복귀합니다. 폼 처리 중 세션이 바뀌었을 때는 폼이 성공 이동을 소유하도록 공개 경로 진입 판정을 분리했습니다. `/my` 준비 화면에서 로그아웃을 실행할 수 있으며 P6 마이 화면 디자인 구현은 별도입니다.

## 책임과 상태

- `pages/LoginPage`, `SignupPage`, `SignupDonePage`: 화면 조합·이동 및 성공 state 검증입니다.
- `features/auth/api.ts`, `model.ts`, `queries.ts`: 기존 API, 생성 DTO 별칭, session query와 로그인·가입·로그아웃 mutation입니다.
- `features/auth/validation.ts`, `useAuthForm.ts`: RHF·Zod 검증, 입력·필드 오류·429 대기 및 제출 잠금입니다.
- `features/auth/ui`: 공통 TextField/Button/BottomAction/Poster를 조합하는 폼과 로그아웃 버튼입니다.
- `app/router/AuthLayout.tsx`: 최초 세션 로딩, 조회 오류·재시도, 공개·보호 경로 접근 제어입니다.

서버 상태는 Query만 사용하며 별도 store나 localStorage 인증을 추가하지 않습니다. 로그인·가입 성공은 진행 중 query를 취소하고 이전 개인 캐시를 제거한 뒤 `['me']`를 설정합니다. 로그아웃 성공 또는 이미 만료된 401은 세션·개인 캐시를 정리합니다. 로그아웃 네트워크 실패는 인증 상태를 유지하고 재시도를 제공합니다. 개인 조회 401은 세션을 비우지만 네트워크/5xx 조회 실패는 비로그인으로 간주하지 않습니다. 재조회는 기존 Query 재시도 정책을 따릅니다.

Mock은 메모리 DB로 **새로고침·새 탭에서 초기화**됩니다. 실제 환경은 서버 쿠키와 `/me`로 복원하며 서버 구현 전에는 지속성을 검증할 수 없습니다. Mock 가입 비밀번호는 평문을 저장하지 않고 메모리 SHA-256 비교값만 보관하며 resetDb에서 제거합니다. 이 비교값은 실제 서버의 안전한 비밀번호 저장 방식을 구현한 것이 아닙니다.

## 폼·오류 처리

초안대로 로그인은 이메일·비밀번호 필수와 최대 128자, 가입은 비밀번호 8~128자·trim 닉네임 1~16자를 검사합니다. 이메일은 trim하고 비밀번호는 변경하지 않습니다. 길이 계산은 현재 JS 문자열 기준이며 A02의 서버 Unicode 정책 합의가 필요합니다.

필드별 오류는 label과 aria-describedby/aria-invalid로 연결하고 첫 오류에 focus합니다. 401은 자격 오류, 409 이메일 중복은 이메일 필드, 422는 허용된 fieldErrors에 연결합니다. 403은 재제출 안내를 표시하며 다음 제출 때 CSRF를 새로 조회합니다. 429는 Retry-After 초 또는 HTTP 날짜까지 제출을 막습니다. 네트워크·서버 오류 후 입력은 유지합니다. 제출 잠금과 pending 버튼으로 중복 요청을 막고 제출 중 입력을 읽기 전용으로 유지합니다. 제출 중 가입 링크·뒤로 버튼을 막으며 탭 닫기/새로고침은 beforeunload 경고를 요청합니다. 브라우저가 경고를 표시하는지는 해당 브라우저 정책에 따릅니다.

MSW의 기존 handlers를 확장했습니다. `failureScenario`는 network/HTTP 오류, `delayScenario`는 지연 후 기존 handler 실행을 지원합니다. 테스트마다 DB·handler·QueryClient를 초기화합니다. 인증 입력을 수집하지 않도록 Playwright trace를 끄고 화면 캡처는 빈 폼과 개인정보 없는 완료 화면만 사용합니다.

## 시각 근거와 검증 범위

FigCraft MCP로 156·193·234의 트리, 텍스트·크기·이미지·버튼 참조와 스크린샷을 확인했습니다. 375×812에서 좌우 24px, 폼 블록 16px+내부 24px, 입력 295×56px, CTA 327×56px 및 화면 문구를 대조했습니다. 포스터 3장의 원본 바이트와 출처는 [이미지 출처](../public/images/auth/CREDITS.md)에 보존합니다. 공통 ResultView의 설명 글자 크기를 원본 16px로 맞췄으며 다른 결과 화면에서도 동일한 본문 토큰을 사용합니다.

320/375/390/430px, 모의 safe area와 높이 420px에서 가로 넘침·마지막 입력의 CTA 가림·focus를 검증합니다. 기존 팔레트·공통 UI·라우팅 검증도 수행합니다. 실제 기기 키보드·safe area, WebKit 및 최종 디자인 승인은 P7에 남아 있습니다. 기기 키보드를 브라우저 뷰포트 축소로 완전히 검증했다고 보지 않습니다.

## 최종 실행 결과 (2026-11-19)

- `npm run typecheck`, `npm run lint`, `npm run build`: 통과했습니다.
- `npm run test:unit`: 27개 통과했습니다. 인증 검증·캐시·HTTP와 기존 API/Query 회귀를 포함합니다.
- `npm run test:e2e`: Chromium 56개 통과했습니다. 인증 9개와 기존 라우팅·스타일·공통 UI·Worker 회귀를 포함합니다.
- `npm run api:check`, `npm run build:check`, `git diff --check`: 통과했습니다.
- 새 의존성 설치 시 npm audit에서 moderate 9건이 보고되었습니다. 범위를 벗어난 강제 버전 변경은 수행하지 않았습니다.

## 실제 서버 연결 전

A01/A02/A08을 합의한 뒤 쿠키·CSRF·CORS·가입 자동 로그인·세션 만료·비밀번호/이메일 정책·오류 코드와 rate limit을 계약과 함께 갱신해야 합니다. Spring Boot 서버가 인증·소유권을 검증하며 프론트 가드는 UX 역할만 담당합니다. 실제 서버 환경에서 새로고침 복원·만료·다중 탭·로그아웃과 캐시 분리를 다시 검증해야 합니다. CI(P0-4), 작품 탐색(P3), 마이 화면(P6), 실기기 품질(P7), 서버 연결(P8)은 별도 작업입니다.
