# 운영 빌드와 배포 준비

2026-11-21. 실제 배포와 원격 push는 수행하지 않았습니다. 플랫폼은 미정이며 루트 경로(`/`)에 배포하는 정적 SPA를 기준으로 합니다. 실제 API 계약은 초안입니다.

## 환경과 재현

Node/npm은 `.node-version`과 `package.json`을 따릅니다. `npm ci`로 lockfile을 설치합니다.

|환경|설정|동작|
|---|---|---|
|Local|`.env.example` → `.env.local`, `npm run dev`|DEV + mock에서만 MSW가 시작됩니다. 메모리 세션은 새로고침 시 초기화됩니다.|
|E2E|`npm run test:e2e`|Playwright가 mock 및 `/api/v1`을 지정합니다. 매 테스트 새 컨텍스트, worker별 독립 메모리 DB입니다.|
|Production|real + 실제 API URL을 빌드 때 지정|MSW/fixture는 제거됩니다. API 누락·mock·HTTP 절대 주소는 빌드를 실패시킵니다.|

```sh
npm ci
npm run lint
npm run api:check
npm run test:unit
VITE_API_MODE=real VITE_API_BASE_URL=/api/v1 npm run build
npm run build:config-check
npm run build:check
npx playwright install chromium
npm run test:e2e
npm run test:production
```

`build`에 typecheck가 포함됩니다. 별도 타입 확인은 `npm run typecheck`입니다. `.env.production.example`을 `.env.production.local`로 복사해도 됩니다. CI는 명령 환경 변수로 지정하여 개발용 `.env.local`의 mock 값 유입을 막습니다. 운영 설정 없이 `npm run build`하면 의도적으로 실패합니다.

`VITE_API_MODE`, `VITE_API_BASE_URL`은 브라우저에 공개되는 **빌드 시점** 설정입니다. 배포 후 서버 환경 변수만 바꿔서는 번들이 바뀌지 않으므로 재빌드해야 합니다. 비밀번호·토큰·서버 비밀키는 `VITE_*`에 넣지 않습니다. [Vite 환경 변수 문서](https://vite.dev/guide/env-and-mode)를 따릅니다.

권장 초기 연결은 동일 출처 `/api/v1` 프록시입니다. 별도 출처라면 HTTPS URL과 서버의 정확한 Origin 허용, credentials, 쿠키 Domain/SameSite/Secure, CSRF 정책을 함께 합의해야 합니다. 현재 client의 credentials는 include이며 프론트 변경만으로 CORS나 인증이 해결되지 않습니다.

## 호스팅 계약

배포 단위는 `dist/` 전체입니다. `vite preview`와 측정용 서버는 운영 서버가 아닙니다. 다음 규칙을 선택 플랫폼의 정적 호스팅/CDN/프록시에 적용합니다.

1. `/api/*`는 Spring Boot로 전달하거나 API 오류를 반환합니다. `index.html`로 fallback하지 않습니다.
2. `/assets/*`, `/fonts/*`, `/images/*`는 파일이 없으면 404를 반환합니다. JS 대신 HTML이 반환되면 동적 import가 실패합니다.
3. `/login`, `/my/profile`, `/records/:id/edit` 등 앱 경로는 `index.html`로 fallback합니다. 새로고침·직접 주소 접근을 staging에서 확인합니다.
4. HTML은 `Cache-Control: no-cache`로 재검증합니다. 해시가 있는 `/assets/*`와 버전 경로 `/fonts/pretendard/v1.3.9/*`는 `public, max-age=31536000, immutable`을 사용할 수 있습니다. 버전 없는 이미지에는 immutable을 적용하지 않고 재검증/짧은 TTL을 사용합니다.
5. 인증·개인 API 응답은 서버에서 `Cache-Control: no-store`를 적용합니다. 정적 CDN 캐시와 섞지 않습니다.
6. JS/CSS/HTML에는 Brotli 또는 gzip, 올바른 MIME을 적용합니다. WOFF2/JPEG는 이미 압축된 형식입니다.
7. 새 해시 에셋 업로드 후 HTML을 교체하는 원자적 배포를 사용합니다. 열린 이전 탭의 lazy import를 위해 이전 해시 에셋을 일정 기간 유지합니다. 이전 release의 HTML·에셋 묶음으로 rollback합니다. 청크 로드 오류는 기존 RouteErrorBoundary의 새로고침 복구를 사용합니다.

루트 외 하위 경로 배포는 현재 지원을 검증하지 않았습니다. router basename, Vite base, 절대 이미지·폰트 경로를 함께 변경하고 검증해야 합니다.

## HTTPS와 헤더

TLS 종료·HTTP→HTTPS 리다이렉트는 호스팅 계층에서 설정합니다. `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy: camera=(), microphone=(), geolocation=()`를 권장합니다. HSTS는 HTTPS와 하위 도메인 운영을 확인한 후 적용하며 preload를 자동 신청하지 않습니다.

CSP는 배포 출처와 이미지 서버가 확정된 후 **Report-Only로 먼저 검증**합니다. 출발점은 `default-src 'self'; base-uri 'self'; object-src 'none'; frame-ancestors 'none'; script-src 'self'; font-src 'self'; img-src 'self' data: <승인한 이미지 출처>; connect-src 'self' <API 출처>; style-src 'self' 'unsafe-inline'`입니다. 현재 ScrollRestoration의 인라인 script와 런타임 style 처리를 검토하여 nonce/hash 또는 대체 구현을 결정해야 합니다. 이 예시를 그대로 강제하면 스크롤 복원에 영향을 줄 수 있습니다. 허용 출처를 `*`로 확장하여 해결하지 않습니다. 미검증 CSP를 앱 meta에 강제하지 않았습니다.

## CI와 출시 전 확인

기존 `.github/workflows/quality.yml`을 유지합니다. 설치 → 브라우저 → lint → 계약 → unit → build(타입 포함) → 잘못된 설정 차단 → mock 제외 → 전체 Mock E2E(axe 포함) → production smoke 순서입니다. 중복 typecheck는 제거했습니다. HTML/실패 진단은 7일 보관하고, 인증 요청/비밀번호가 포함되는 전역 Trace는 켜지 않습니다. Lighthouse는 변동성·실행 비용 때문에 수동 측정 명령으로 둡니다.

`test:production`은 운영 산출물을 preview로 열고 테스트 transport에서 `/me`에 401만 반환합니다. 실제 API 호출 경계·깊은 URL·가입 새로고침·리소스 오류·worker 미등록과 지연 청크 실패 후 새로고침 복구를 확인하며 정상 인증이나 백엔드 통합을 주장하지 않습니다. 실제 호스팅 fallback·캐시·헤더 설정은 staging에서 별도 확인해야 합니다.

출시 전에는 [미확정 계약 A01~A09](05-open-questions.md), 실제 쿠키·CSRF·세션 만료·소유권·409/412·추천 수렴·프로필 동시 수정·서버 영속성, 작품 이미지 권리, 실제 기기/스크린리더, 실사용 CWV를 확인해야 합니다. P8을 완료 처리하지 않습니다. 원격 Actions는 push하지 않았으므로 실행 결과를 확인하지 않았습니다.
