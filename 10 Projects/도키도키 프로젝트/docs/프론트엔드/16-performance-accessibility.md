# 성능·접근성 개선 결과

2026-11-21 (Asia/Seoul). 시작 커밋 `b2495e4`, 깨끗한 develop에서 `perf/production-readiness`로 작업했습니다. 기존 E2E 116개·Vitest 38개가 구축되어 있었고, 약 535kB 단일 JS·2MB 폰트·리디 버튼 대비가 확인된 잔여 문제였습니다. 실제 서비스 배포나 P8 완료를 의미하지 않습니다.

## 측정 조건과 결과

Darwin arm64, Node 24.14.0/npm 11.9.0, Lighthouse 13.6.0, Playwright Chromium 156 headless입니다. 운영 minified 빌드를 로컬 HTTP 서버로 제공하며 압축·캐시는 끕니다. 모바일 UA, viewport 375×812, DPR 1, Lighthouse simulate 방식(RTT 150ms, throughput 1638.4Kbps, CPU 4배)으로 각 경로 3회 cold navigation을 측정했습니다. 서버는 `/me`에 비인증 401을 반환하므로 정상 로그인/가입 UI가 표시됩니다. 운영 번들에 MSW를 넣지 않습니다. 측정용 transport는 실제 서버 성능을 재현하지 않습니다.

```sh
VITE_API_MODE=real VITE_API_BASE_URL=/api/v1 npm run build
npm run perf:measure -- after
```

원본은 `artifacts/performance/<이름>.json`, 이번 전후 실행의 번들·환경·개별 3회 수치는 [측정 JSON](performance-measurements.json)에 보존했습니다. 개선 전은 시작 커밋의 소스와 동일 API 빌드 값을 사용했습니다. 당시 측정 도구 설치만 선행했습니다. 아래 수치는 각각 3회 중앙값이며 점수 범위도 함께 표시합니다.

|항목|로그인 전→후|회원가입 전→후|
|---|---|---|
|Lighthouse Performance|75 (67~75) → 77 (76~77)|75 → 79|
|LCP|15,151.94 → 6,500.44ms|14,102.43 → 5,703.05ms|
|CLS|0 → 0|0 → 0|
|TBT|0 → 0ms|22 → 0ms|
|초기 JS 전송(헤더 포함)|535.12 → 509.76kB|535.12 → 508.61kB|
|초기 CSS 전송(헤더 포함)|24.08 → 64.71kB|24.08 → 64.09kB|
|폰트 전송|2,057.87 → 234.73kB (1→9 요청)|2,057.87 → 183.66kB (1→7 요청)|
|전체 전송|2,795.89 → 988.18kB|2,617.93 → 757.37kB|
|전체 요청 수|8 → 29|5 → 22|

폰트 Unicode 선언으로 CSS와 요청 수는 늘었지만 전체 전송량과 LCP는 줄었습니다. 요청 수 감소나 총 JS 감소로 보고하지 않습니다. 로그인에는 RHF/Zod가 필요하므로 분할 후 초기 JS 절감은 약 4.7%입니다. 전체 JS 합계는 534.94→547.88kB, CSS 합계는 23.90→72.03kB입니다. 최대 JS 청크는 534.94→233.12kB가 되어 500kB 경고가 사라졌습니다. gzipSync 기준 전체 JS gzip 합계는 163.08→181.46kB, CSS는 5.35→22.19kB입니다. 이는 전체 경로 합계이며 초기 전송량과 다릅니다. Vite 출력의 gzip 추정과 gzipSync 수치도 구분합니다.

개선 후에도 LCP는 충분히 빠르지 않습니다. 실제 호스팅의 HTTP/2·Brotli/gzip·CDN·백엔드 지연을 적용한 staging 재측정이 필요합니다. 로컬 동시 작업과 CPU 변동의 영향을 받으며 이 점수를 배포 환경의 점수로 사용하지 않습니다. 보호 화면의 Lighthouse와 실제 사용자 p75 CWV는 측정하지 않았습니다. Lighthouse navigation은 INP를 측정하지 않으며 TBT를 INP로 대체하지 않았습니다. [Web Vitals 안내](https://web.dev/articles/vitals)를 따릅니다.

## 구현과 유지한 정책

- [React Router lazy](https://reactrouter.com/start/data/route-object)로 화면별 Component를 동적 로드합니다. path와 보호 레이아웃은 정적으로 유지하고 최초 로딩 안내·기존 오류 경계를 유지합니다. 서버 상태를 route loader에 중복 저장하지 않습니다. 결과 화면의 kind별 성공 가드도 유지합니다.
- Pretendard는 공식 동일 1.3.9의 variable Unicode 서브셋 92개를 자체 호스팅합니다. 화면에서 쓰는 범위만 다운로드하고 전체 문자 범위를 보존하므로 사용자 입력을 고정 글자 집합으로 제한하지 않습니다. 폰트 출처·OFL·재현 방법은 [폰트 안내](../public/fonts/pretendard/README.md)에 기록했습니다. 오래된 2MB 단일 파일은 제거했습니다. 모든 굵기를 별도 파일로 나누거나 전체 preload하지 않습니다.
- 기존 포스터 12개는 모두 550×780 JPEG이며 375px 화면에서 로그인 약 108px·목록 72px·상세 327×436px로 표시됩니다. 작은 카드에는 해상도 여유가 있지만 상세의 DPR도 고려해야 합니다. 로그인 3개 합계 약 178kB이며 폰트보다 영향이 작았습니다. 공통 Poster의 CSS aspect-ratio로 공간을 확보하고 목록 lazy·홈 대표/상세/auth eager·대체 텍스트/장식 이미지 정책을 유지합니다. 원본 이미지와 출처는 변경하지 않았습니다. 서버 이미지의 responsive source/AVIF/WebP 변형은 실제 이미지 API 계약 후 추가 검증 대상입니다.
- Query의 staleTime 30초(작품 5분), 취소 신호, 사용자별 키, mutation 이후 무효화, 제한된 polling을 검토했습니다. 기존 캐시·검색 debounce·경합·재시도 회귀를 재사용했습니다. 운영 최초 보호 URL 진입에서 `/me` 1회도 검증합니다. 조회 신선도를 낮춰 성능 수치를 만드는 변경은 없습니다.
- RHF 로컬 폼/URL 검색/Query 서버 상태를 유지합니다. 대규모 리팩토링·새 store·무근거 memo는 추가하지 않았습니다. TBT 감소는 위 표 범위이며 React Profiler의 컴포넌트별 commit 횟수·비용은 별도로 측정하지 않았습니다. 불필요한 리렌더링이 해결되었다고 주장하지 않습니다.

## 접근성과 디자인 차이

WCAG 2.2 AA를 목표로 axe의 wcag2a/wcag2aa/wcag21aa/wcag22aa 규칙을 사용합니다. 기본 11개 화면은 `accessibility.spec.ts`, HTTP 성공 후 결과 5개는 기존 Visual QA에 검사를 통합했습니다. [Playwright 접근성 지침](https://playwright.dev/docs/accessibility-testing)처럼 자동 검사와 키보드 검증을 함께 사용하며 WCAG 적합성 인증으로 해석하지 않습니다.

- 가입 화면은 앱바의 h1을 유지하고 소개 문구를 h2로 바꿨습니다. FigCraft 193의 구조를 MCP로 다시 확인했으며 28px·줄높이·자간은 유지했습니다.
- 페이지 pathname이 바뀌면 본문에 `preventScroll` 포커스를 둡니다. 새 화면에서 키보드 탐색을 시작할 수 있고 쿼리 검색어 변경에는 포커스를 이동하지 않습니다. 기존 ScrollRestoration을 유지합니다.
- 리디 대안의 버튼 배경 `#0F97FF`와 pressed `#1089E5`를 유지하고 전경만 `#FFFFFF`→`#111111`로 compatibility CSS에서 보정했습니다. 원본/generated 토큰은 보존했습니다. 기본 약 6.2:1·pressed 약 5.1:1이며 axe로 세 테마의 기본/누름 상태를 검사합니다. 이 변경은 원본과 다른 접근성 보정이며 최종 디자인 승인을 뜻하지 않습니다.
- 신규 키보드 테스트는 Tab/Enter만으로 본문 바로가기·이메일·비밀번호·로그인·마이 메뉴를 이동합니다. 기존 카드 순회, 오류 첫 필드 focus/aria-describedby, select, 삭제 dialog Escape·복원, 실패 alert·결과 heading·터치 영역 검증을 유지합니다.
- 16개 화면의 320/375/390/430/1280px, 375×500·모의 safe area, 폰트 실패를 재검증합니다. 가입 화면과 리디 홈 캡처를 육안으로 확인했습니다. 자동 PNG는 승인된 픽셀 기준이 아니며 원본 전체를 다시 수동 픽셀 비교했다고 보고하지 않습니다.

실제 iOS/Android 키보드·노치, WebKit/Firefox, VoiceOver/NVDA 실사용과 브라우저 200% 확대는 미실행입니다. 추가 복구 UI의 디자인 승인과 이미지 상용 권리는 기존 출시 조건입니다.

## 의존성과 검증

초기 npm audit은 moderate 9건(ESLint/typescript-eslint 간접 minimatch glob 입력 DoS)이었습니다. 운영 dependencies 경로가 아닌 개발 도구 경로였습니다. ESLint 10.14→10.15, typescript-eslint 8.72.1→8.73으로 동일 메이저 업데이트 후 audit 0건입니다. `--force`나 메이저 업데이트는 사용하지 않았습니다. 운영 패키지는 유지하고 axe·Lighthouse·chrome-launcher는 devDependencies로 정확히 고정했습니다. 사용 중인 React/RHF/Zod/Query/router의 임의 제거는 하지 않았습니다.

최종 검증 결과는 아래에 기록합니다. 운영 환경·CI·실서버 연결 전 조건은 [배포 안내](17-production-deployment.md)를 확인합니다.


검증 중 최초 전체 실행은 130개 통과·1개 실패였습니다. route lazy 도입으로 검색 결과 링크 클릭 직후 기존 화면이 잠시 유지되는데, 기존 테스트가 새 등록 화면 대신 이전 검색 화면의 뒤로 버튼을 눌렀습니다. 등록 제목 표시를 기다리도록 보정하고 해당 테스트를 3회 반복해 통과했습니다. 실패를 retry 설정으로 숨기지 않았습니다.

최종 실행: **Mock Chromium 131개 전부 통과(3.5분, retries 0), production smoke 2개 통과, Vitest 38개 통과**입니다. 기본 16개 화면 axe 위반 0건이며 세 테마 대비·키보드·반응형 검증도 통과했습니다. typecheck, lint, 운영 build, api:check, build:check, 잘못된 운영 설정 5개 차단, npm audit 0건, diff 공백 및 문서 상대 링크 검사를 통과했습니다. 브라우저에 주입한 의도적 렌더 오류와 기존 수동 history 이동의 POP 경고는 오류 복구 테스트의 알려진 진단입니다.

커밋은 성능 변경, 품질·배포 자동화, 결과 문서로 나눴습니다. 원격 push·Actions 실행·실제 운영 배포는 수행하지 않았습니다.
