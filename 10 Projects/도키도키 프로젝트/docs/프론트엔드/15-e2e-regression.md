# E2E 전략과 전체 회귀 검증

작성일: 2026-11-21 (Asia/Seoul). 기존 Playwright 107개를 유지하고 사용자 흐름 9개를 추가했습니다. 운영 UI·API 계약·생성 타입은 변경하지 않았습니다.

## 실행

Node/npm은 `.node-version`과 `package.json`의 engines를 따릅니다.

```sh
npm ci
npx playwright install chromium
npm run test:e2e
npm run test:e2e:ui
npm run test:e2e:report
npm run test:e2e:repeat
```

- Playwright가 `127.0.0.1:4173` Vite 개발 서버를 시작하고 종료합니다. 기존 서버를 재사용하지 않으며 포트 충돌은 실패로 처리합니다. 환경은 `VITE_API_MODE=mock`, `VITE_API_BASE_URL=/api/v1`로 고정합니다. 실제 서버나 비밀 환경변수는 필요하지 않습니다.
- 로컬은 2 workers, CI는 1 worker입니다. 재시도는 0회로 설정하여 불안정한 테스트를 재시도 성공으로 숨기지 않습니다. `test:e2e:repeat`는 신규 9개를 3회씩 2 workers에서 실행합니다.
- `npm run test:e2e -- e2e/journeys.spec.ts`처럼 파일을 좁힐 수 있습니다. UI 모드도 동일한 Mock 서버를 사용합니다.
- `npm run test:unit`은 Vitest HTTP 계약·Query·도메인 검증입니다. 컴포넌트 통합은 기존 Playwright `ui.spec.ts`와 기능별 spec에서 실제 DOM으로 검증합니다. 별도 Testing Library 스위트는 없습니다.

## 격리와 Fixture

각 테스트는 Playwright의 새 BrowserContext/page를 사용합니다. 새 앱 문서에서 MSW worker를 시작하고 `db.ts`의 `resetDb()`로 초기 사용자·기록 2개·카탈로그 12개·고정 시각·ID sequence를 만듭니다. QueryClient도 새로 생성됩니다. 같은 테스트의 SPA 이동 중에는 메모리 DB를 유지하므로 등록·수정·삭제 결과가 이어집니다. 각 worker의 DB는 브라우저 문서 메모리에 있고 Vite 서버가 DB를 공유하지 않습니다. storageState나 localStorage 인증은 사용하지 않습니다.

`fixtures/auth.ts`는 공개된 Mock 계정으로 실제 로그인 폼을 조작합니다. 신규 사용자도 가입 폼으로 생성합니다. 실제 계정·비밀번호·개인 입력은 사용하지 않습니다. `fixtures/mock.ts`는 시작된 개발 worker에 오류 handler를 등록/해제할 뿐, handler를 직접 호출하거나 UI 결과를 주입하지 않습니다. `restoreApi()`는 handler만 복원하며 DB를 초기화하지 않습니다.

`page.goto`/새로고침/새 탭은 Mock 데이터와 세션을 초기화합니다. 서버 영속성처럼 해석하면 안 됩니다. 삭제 ID·타인 ID·결과 URL의 같은 세션 재접근에는 `navigateWithinSession()`을 사용합니다. 이는 URL/라우트 가드 검사이며 실제 주소창 새 문서 탐색과 구분합니다. 일부 기존 테스트와 이 도우미의 수동 history 이동은 React Router의 POP 경고를 낼 수 있습니다. 실제 버튼·링크 기반 주요 흐름은 router를 통해 이동합니다.

운영 코드에 테스트 초기화 endpoint·전역 객체·fixture import를 추가하지 않았습니다. MSW는 기존 DEV 조건을 유지하며 `build:check`로 운영 산출물 제외를 확인합니다.

## 흐름과 검증 목적

|파일|검증 목적|
|---|---|
|`auth.spec.ts`|가입 유효성·409·422·429·완료·첫 기록 이동, 로그인 실패/성공, 보호 경로 복귀, 로그아웃과 뒤로 가기, 세션 조회 실패 복구입니다.|
|`discovery.spec.ts`|홈→추천→서로 다른 상세→복귀, 0개/일부/starter/unavailable/지연/오류, polling 종료, 상세 404·네트워크 복구입니다.|
|`records.spec.ts`|검색→등록→목록, 중단 필수 입력·inactive 필드 제거, 멱등 재시도, 중복 제출·409·401, 검색/필터/페이지·복원입니다.|
|`record-edit.spec.ts`|기존 값 표시, 상태 교체, 삭제 확인·취소·실패·404, 버전 충돌과 명시적 최신 조회, 백그라운드 조회 시 입력 보존입니다.|
|`profile.spec.ts`|현재 사용자→수정→결과→마이·재로그인 반영, 잘못된 입력·중복 제출·401/403/422/429/503, 집계와 캐시·입력 보존입니다.|
|`journeys.spec.ts` (신규 2개)|새로 만든 응답 ID를 사용한 등록→중단 수정→완료 수정→삭제, 요청 및 저장 응답의 inactive 필드 제거, 목록·집계·추천·상세 캐시 갱신·삭제 URL 404입니다. 추천 HTTP 응답의 ID/제목/이유를 실제 목록·상세와 대조합니다.|
|`session-isolation.spec.ts` (신규 2개)|실제 폼을 통한 기존 사용자→로그아웃→신규 가입→기존 사용자 재로그인, 개인 기록·프로필·집계 분리 및 타인 ID 404입니다. 별도 테스트에서 초기 상태와 새로고침 초기화를 검증합니다.|
|`resilience.spec.ts` (신규 5개)|프로필 400/403/500/네트워크 실패를 독립 테스트로 분리해 입력·경로 보존과 재시도 성공을 확인합니다. 로그아웃 통신 실패 시 인증 상태를 유지하고 성공 후 보호 경로로 돌아가지 못하는지 검증합니다.|
|`routing.spec.ts`, `ui.spec.ts`, `styles.spec.ts`, `visual.spec.ts`|직접 URL·결과 가드·핵심 라우트·공통 컴포넌트·16개 화면·375×812와 좁은 폭·safe area 회귀를 재사용합니다.|
|`api.spec.ts`, Vitest|브라우저 API transport 및 HTTP 계약·도메인 경계·Query 검증을 유지합니다. API 호출 테스트는 사용자 행동 E2E의 대체물이 아닙니다.|

신규 테스트는 role/name/label과 응답 대기를 사용하며 고정 시간 sleep을 추가하지 않았습니다. 기존 시나리오는 재작성하지 않았고, 기존 검색 조합·지연 역전 테스트의 시간 대기는 남아 있습니다.

## 계약과 요구사항의 차이

- A01: 가입 성공은 자동 로그인 후 첫 기록 `/search`로 이동합니다. 가입 결과에서 로그인 버튼을 새로 만들지 않았습니다. 신규 가입 후 마이에서 로그아웃하여 로그인 화면에 도달하는 흐름을 검증합니다.
- A09: `WatchEntry`는 완료의 정수 평점 1~5 또는 중단의 필수 사유만 허용합니다. 완료 사유 및 나중에 보기는 미합의이므로 구현/테스트 성공으로 표시하지 않습니다.
- 400/401/403/404 및 공통 서버 실패는 기존 계약 범위에서 주입합니다. 불투명 작품 ID에 새로운 형식 제약을 만들지 않았으며 잘못된/없는 ID는 기존 404 검증을 재사용합니다.
- 삭제는 기존 204·목록 제거·재접근 404만 검증합니다. 실제 서버의 물리 삭제/논리 삭제·보관·복구 정책을 확정하지 않습니다.

## 진단 아티팩트와 CI

전체 spec이 `fixtures/test.ts`의 공통 test를 사용합니다. Playwright 기본 error-context에는 합성 입력과 테스트 소스가 포함될 수 있으므로 모든 실행은 Mock 합성 데이터만 사용합니다. 실패 시 input/textarea/select를 마스킹한 PNG를 HTML 리포트에 첨부합니다. 기존 Visual QA 캡처는 계속 생성합니다. 테스트 결과와 리포트는 Git에서 제외합니다.

`signedInPage`를 사용하는 신규 CRUD 및 오류 테스트는 로그인 성공 뒤부터 행동 Trace를 수집하며 실패 시에만 `actions-trace.zip`을 첨부합니다. DOM/network snapshots, screencast, source 수집을 비활성화하여 인증 요청·CSRF·소스의 인증 fixture 값을 수집하지 않습니다. 행동 타임라인·locator·호출 오류를 확인할 수 있으며 DOM 재생과 네트워크 본문은 제공하지 않습니다. 이 fixture에서 재로그인/가입을 수행하면 안 됩니다. 입력값은 합성 E2E 문자열만 사용합니다.

인증·사용자 전환 및 기존 spec의 전체 Trace는 비밀번호 노출 방지를 위해 끈 상태입니다. 이 구간은 실패 마스킹 PNG와 assertion/report로 진단합니다. `--trace on`으로 전역 수집을 켜면 인증 입력까지 남을 수 있으므로 CI에는 사용하지 않습니다. UI 모드의 진단 자료도 외부 공유하지 않습니다.

GitHub Actions `quality.yml`은 PR, main/develop push, 수동 실행에서 타입·린트·계약·Vitest·운영 빌드·Mock 제외·전체 Chromium E2E를 실행합니다. 읽기 전용 권한, 동일 ref의 이전 실행 취소, 20분 제한, Chromium만 설치하여 비용을 제한합니다. HTML 리포트와 실패 첨부 파일을 7일 보관하고 환경 파일·토큰·trace 원본 전체를 별도로 업로드하지 않습니다. 원격 push나 Actions 실행은 이번 작업에서 수행하지 않습니다.

설정 근거: [Playwright 격리와 locator 권장 사항](https://playwright.dev/docs/best-practices), [CI 가이드](https://playwright.dev/docs/ci), [Trace API](https://playwright.dev/docs/api/class-tracing).

## 실행 결과

|검증|결과|
|---|---|
|`npm run typecheck`, `npm run lint`|통과했습니다.|
|`npm run test:unit`|6개 파일, 38개 통과했습니다.|
|`npm run test:e2e`|Chromium 116개 통과, 재시도 0회, 약 3.2분입니다.|
|`npm run test:e2e:repeat`|신규 9개 × 3회 = 27개 통과, 2 workers, 약 1.4분입니다.|
|`npm run api:check`|OpenAPI와 생성 타입이 일치합니다.|
|`npm run build`, `npm run build:check`|통과했습니다. 운영 MSW/fixture 제외를 확인했습니다. 약 535kB 단일 JS 청크 경고는 남아 있습니다.|
|문서 상대 링크, `git diff --check`, CI YAML 구문|통과했습니다.|
|진단 실패 주입|임시 테스트를 의도적으로 1회 실패시켜 HTML PNG 첨부와 행동 Trace 생성을 확인했습니다. PNG 입력 마스킹을 육안 확인했고 Trace ZIP의 인증 계정/비밀번호/CSRF 문자열·network body·source 부재를 검사했습니다. 임시 테스트는 제거했습니다.|
|원격 GitHub Actions, UI 모드 수동 조작|미실행입니다. 설정/스크립트와 headless 실행 결과를 구분합니다.|

전체 실행의 16개 화면 Visual QA 및 기존 컴포넌트·라우트 검증을 포함합니다. 새 픽셀 기준 이미지를 승인하거나 새 원본 육안 대조를 수행한 것은 아닙니다. 기존 FigCraft 16개 프레임·HANDOFF-QA·Visual QA 보고서를 확인하고 기능 흐름을 재검증했습니다. 의존성 변경이 없어 lockfile은 변경하지 않았습니다.

## 제한과 실제 서버 재검증

제품 동작을 테스트 통과 목적으로 변경하지 않았습니다. 신규 테스트 작성 중 E2E NodeNext 프로젝트에서 앱의 Dto import를 직접 사용하는 타입 오류를 발견해 생성 schema 타입을 참조하도록 테스트만 수정했습니다.

실제 HttpOnly/Secure/SameSite 쿠키·CSRF/CORS·세션 지속성/만료·다중 탭·서버 소유권/권한·DB 트랜잭션·동시 수정·멱등 보관 시간·추천 최종 일관성·배포 fallback은 P8에서 재검증해야 합니다. Mock의 사용자별 404 성공은 실제 서버 보안 검증이 아닙니다.

WebKit/Firefox·실제 iOS/Android·스크린리더·200% 확대는 미실행입니다. [Visual QA](14-visual-qa.md)의 리디 버튼 대비 V05와 번들 500kB 초과 경고, 픽셀 기준 이미지 승인 및 자산 권리는 남아 있습니다. P7 전체 완료 또는 출시 준비 완료로 표시하지 않습니다.

## 후속 품질 확장 (2026-11-21)

접근성 15개 테스트를 추가하여 전체 Mock E2E는 131개입니다. 기존 성공 화면 5개 Visual QA에도 axe를 통합했습니다. route lazy 전환 시 등록 화면이 표시된 후 뒤로 이동하도록 검색 회귀 테스트를 보정했습니다. 최종 전체 131개 통과(retries 0) 및 해당 검색 3회 반복 통과입니다. 별도 production config의 smoke 2개도 통과했습니다. 최신 측정·제약은 [품질 결과](16-performance-accessibility.md), 실행과 CI는 [배포 안내](17-production-deployment.md)를 확인합니다.
