# 컴포넌트·스타일·아키텍처

## 기술 결정

로그인 후 개인 데이터 중심이고 공개 검색 유입/SSR 요구가 없으므로 Vite 기반 React + TypeScript SPA를 채택합니다. SSR 요구가 생기기 전 Next.js 서버 계층을 추가하지 않습니다. Vite로 시작할 수 있지만 라우팅·데이터 처리를 직접 구성해야 한다는 [React 안내](https://react.dev/learn/build-a-react-app-from-scratch)를 검토한 선택입니다.

|영역|채택|이유·경계|
|---|---|---|
|앱|React, TypeScript strict, Vite|저장소 루트 단일 앱, npm lockfile, 작은 기능 모듈|
|라우팅|React Router Data Mode|보호 경로·복원·이탈 처리; 서버 데이터 캐시는 Query에 위임|
|서버 상태|TanStack Query|조회·mutation·무효화; Redux/Zustand 추가 없음|
|폼|React Hook Form + Zod|등록/수정 폼 공유, 조건부 입력·필드 오류; 서버 최종 검증 필수|
|HTTP 계약|fetch 기반 얇은 공통 함수 + openapi-typescript 생성 타입|AbortSignal, credentials, 오류 정규화; 거대한 repository 계층 없이 기능별 함수|
|스타일|CSS Modules + 전역 CSS custom properties|기존 토큰을 직접 사용; UI 프레임워크/Tailwind를 추가하지 않음|
|테스트|Vitest, Testing Library/user-event, MSW, Playwright|로직·사용자 동작·HTTP 계약·브라우저 흐름별 역할 분리|
|품질|ESLint, TypeScript, Prettier|접근성 규칙과 import 경계는 필요한 수준에서 적용|

정확한 버전은 P0에서 안정 릴리스와 peer dependency, Vite의 Node 요구사항을 확인하여 `package-lock.json`, `engines`, `.node-version`에 고정합니다. 이 문서는 최신 버전 번호를 추정하지 않습니다. [Vite 공식 시작 안내](https://vite.dev/guide/)와 [React Router 모드](https://reactrouter.com/start/modes)를 기준으로 확인합니다.

## 디렉터리와 의존 방향

```text
dokidoki-frontend/
  src/
    app/             # router, providers, protected layout, error boundary
    pages/           # 16개 화면의 조합, route parameter 처리
    features/
      auth/          # api, queries, login/signup forms
      anime/         # 작품 조회/검색, 카드/포스터/행
      recommendations/ # 추천 query, 추천 화면 블록
      records/       # api, query keys, schema, WatchRecordForm
      profile/       # 내 정보 query, 닉네임 form
    shared/
      api/           # fetch client, ApiError, generated/schema.d.ts
      ui/            # Button, FormField, AppBar, BottomTabs, ResultView
      styles/        # tokens.generated.css, tokens.compat.css, global.css
    mocks/           # fixtures, db, handlers, scenarios, browser, server
    test/            # renderWithProviders, setup
  e2e/
  public/            # 폰트·승인된 이미지·개발용 MSW worker
docs/                # 계약·설계의 원본
```

`app/pages → features → shared`를 기본 방향으로 둡니다. 기능 간 UI 조합은 pages에서 수행하고, 작품 표시처럼 명확한 공용 도메인은 `features/anime`에서 공개합니다. 순환 import는 금지합니다. 모든 폴더에 index barrel이나 추상 service interface를 만들지 않습니다. API DTO는 생성 타입을 사용하고 UI에 필요한 파생 모델만 별도로 만듭니다. Spring의 계층 구분을 프론트엔드에 기계적으로 복제하지 않습니다.

## 재사용 컴포넌트

|컴포넌트|FigCraft 근거|주요 입력·책임|
|---|---|---|
|AppShell / AppBar / BottomTabs / BottomAction|Navigation 11, Fixed/CTA|제목·뒤로·우측 행동, 현재 route, footer slot; 탭과 CTA의 동시 노출 방지|
|Button / ButtonLink|Buttons 12|primary/secondary/danger, pending/disabled; 이동은 link, 실행은 button|
|FormField / TextInput / Select / TextArea|Inputs 13|label/id/error/hint 연결; HTML native select 유지|
|SearchField / StatusFilter|430·528, 443·447|검색값·조합 이벤트, 단일 선택 `aria-pressed`|
|Poster|Assets 18, swap-safe 1219/1256|src/alt, aspect/size, 실패 fallback; 작품별 컴포넌트 금지|
|AnimeCard|Cards 14|anime, recommendation, variant compact/poster; 카드 전체 link|
|FeaturedAnime|홈 38|대표 4:3 이미지와 추천 이유; 카드에 수많은 옵션을 넣지 않음|
|AnimeRow / WatchRecordRow|Lists 15|작품 정보·보조 문구, recordId 분기; 행 최소 높이와 긴 제목|
|WatchRecordForm|Form/WatchRecord 1065|initialValues/onSubmit/pending; 등록·수정 공유, 삭제 행동은 edit page 소유|
|RecommendationLevel / WatchStatus|상·중·하 텍스트, 이력 행|정확한 한글 라벨; 색만으로 의미 전달 금지|
|ResultView|Feedback 17, 결과 5개|title/description/summary/action; 라우트와 도메인 mutation은 외부 소유|
|AsyncState / ConfirmDialog|추가 설계|로딩·오류·빈 상태, 재시도·취소; 초기에는 필요한 변형만|

140개 디자인 컴포넌트에는 작품별 이미지와 문구·측정 높이 변형이 포함됩니다. React에서는 내용 차이를 props로 표현합니다. 중복된 swap-safe 섹션도 별도 제품 기능으로 옮기지 않습니다. 카드 높이를 샘플별 고정 값으로 만들지 않습니다.

## 토큰 변환과 스타일

1. `designs/dokidoki.tokens.css`는 변경하지 않고 앱의 `tokens.generated.css`로 복사합니다. 다음에 `tokens.compat.css`, reset/global, CSS Modules 순으로 적용합니다. 원본 변경 시 diff를 검토하고 복사본을 갱신합니다.
2. **발견된 결함:** 모든 모드의 `--fw-*`가 `700px` 등이고, `--lh-*`가 `1.36px` 등입니다. CSS 변수 자체는 저장되지만 font-weight에 사용하면 무효, line-height에는 지나치게 작은 길이가 됩니다. `:root, [data-doki-semantic]`에 보정값을 선언하여 대안 모드도 덮습니다.
3. 보정표: title `28 / 700 / 1.36`, h2 `20 / 700 / 1.4`, body `16 / 400 / 1.55`, strong `16 / 600 / 1.5`, sub `14 / 400 / 1.5`, caption `12 / 500 / 1.4`입니다(크기 px / 굵기 무단위 / 줄 높이 무단위). `--typography-lineheight-21:21px` 같은 절대 줄 높이는 무단위로 일괄 변환하지 않습니다. 실제 카드 라벨 등 원본의 세부 굵기는 컴포넌트 규칙으로 맞춥니다.
4. `--typography-family`를 실제 font-family에 연결하고 Pretendard, system fallback을 선언합니다. 폰트 파일·라이선스 확보 후 self-host, `font-display:swap`을 기본안으로 둡니다. 원본 CSS의 `--tracking:-0.02em`, 제목 `-0.03em`, `--shadow-1/2`, 맥락별 `--c-fill/--c-track`는 export에 없어 별도 compatibility 항목으로 기록합니다. `--c-text` 미정의 사용은 `--c-text-1`로 수정합니다.
5. 밀리가 기본입니다. 검토용 대안은 `<html data-doki-semantic="리디 · Alternative">` 또는 `Threads · Alternative`로 설정합니다. 대안은 색상뿐 아니라 리디 radius 2/4/4px도 바뀝니다. 사용자용 테마 설정 화면은 추가하지 않습니다.
6. 페이지 24px, 블록 바깥 16px·내부 24px, 간격 8/12/16/32px를 사용합니다. 내보낸 프레임은 일부 자식 폭이 부모보다 크므로 네이티브 x/y를 absolute positioning으로 복제하지 않고 원본 CSS의 여백 관계를 재구성합니다.

## 반응형·접근성

- 375×812를 비교 기준으로 두고 320/375/390/430px를 검증합니다. 데스크톱은 임시로 최대 480px 중앙 모바일 컨테이너입니다. 확장형 데스크톱 UI는 협의 대상입니다. 컨테이너와 fixed footer의 폭을 일치시킵니다.
- 콘텐츠는 자연 높이로 스크롤합니다. 앱바는 sticky, 하단 CTA/탭은 고정입니다. CTA는 버튼 56px + 위아래 16px = 88px에 safe area, 탭은 64px에 safe area를 더하며 콘텐츠 아래 공간도 동일하게 확보합니다. `100dvh`와 fallback을 사용하고 화면 높이 812px를 고정하지 않습니다.
- 추천 2열은 `(가용 폭 - 48px - 8px)/2`입니다. 375px에서 카드 폭 159.5px, 이미지 3:4입니다. 홈 compact 이미지 136×136, 목록 72×72, 홈 대표 4:3, 상세 3:4의 cover crop을 보존합니다.
- 동적 제목에 디자인용 강제 개행을 삽입하지 않습니다. `word-break:keep-all; overflow-wrap:anywhere; min-width:0`을 사용합니다. 카드 제목은 원본의 2줄 제한을 검토하되 상세에서 전문을 제공합니다. 사유·결과 문구는 내용에 따라 늘어납니다.
- 키보드가 열린 모바일에서 입력과 CTA가 겹치지 않도록 스크롤·focus를 검사합니다. 확대 200%, 긴 닉네임/사유, 320px에서 가로 overflow가 없어야 합니다.
- 명시적인 label, 필드 오류 `aria-describedby/aria-invalid`, 오류 요약과 첫 오류 focus, pending `aria-busy`, 결과 `role=status`, 탭 `aria-current=page`를 적용합니다. 터치 영역은 최소 44px입니다. 대화상자는 focus trap·Escape·닫힌 후 focus 복원을 지원합니다.
- 이미지에 고정 비율을 지정해 레이아웃 이동을 줄입니다. 첫 대표 이미지를 우선 로딩하고 아래 포스터는 lazy loading합니다. 행 제목과 중복되는 장식 이미지는 빈 alt, 독립 포스터는 작품명 alt를 사용합니다. 텍스트 대비는 3개 팔레트별로 검사하고 부족한 조합은 디자인 협의로 수정합니다.

## 상태 소유권과 무효화

|상태|소유자 / 키|갱신 규칙|
|---|---|---|
|세션·닉네임|Query `['me']`|로그인/가입 응답으로 설정, 프로필 성공 시 교체|
|개인 추천|`['recommendations', userId]`|기록 CRUD 성공 시 invalidate|
|작품 목록·상세|`['anime', userId, 'list', {q,cursor}]`, `['anime',userId,'detail',id]`|recordId와 개인 추천을 포함하므로 CRUD 시 invalidate|
|이력|`['records',userId,'list',{q,status,cursor}]`, `['records',userId,'detail',id]`|성공 응답 detail 설정 후 목록 invalidate, 삭제는 detail 제거|
|전체 건수|`['record-summary',userId]`|CRUD 성공 시 invalidate|
|검색·필터|URL|뒤로/새로고침 복원, 입력 임시값만 로컬|
|폼·삭제 dialog|RHF / 로컬 state|서버 캐시에 미저장 필드 저장 금지|
|완료 결과|router location.state|작업 성공 시만 생성, 로그아웃 시 비움|

조회는 기본 staleTime 30초, 작품 정보 5분으로 시작하되 개인화 연결은 CRUD 시 강제 무효화합니다. 세션 401은 재시도하지 않고 로그인으로 이동합니다. GET 네트워크/5xx만 1회 재시도하고 mutation 자동 재시도는 끕니다. 쓰기는 비관적 처리로 시작합니다. AbortSignal을 전달해 빠른 검색 시 오래된 응답을 취소합니다. 무효화는 [TanStack Query 공식 동작](https://tanstack.com/query/latest/docs/framework/react/guides/query-invalidation)을 따릅니다.

로그아웃/세션 만료 시 진행 중 query를 취소한 뒤 개인 캐시를 제거합니다. 사용자 전환 뒤 늦게 도착한 응답이 화면에 섞이지 않도록 userId 키와 인증 가드를 같이 씁니다. 토큰·비밀번호·기록·닉네임을 localStorage에 저장하지 않습니다.

## P0-2 구현 상태 (2026-11-05)

- 실제 저장소 루트의 `src/`를 유지합니다. `app`은 Provider·라우트 조합·레이아웃·오류 경계를, `pages`는 화면 조합과 URL parameter 처리를, `shared`는 경로 생성 함수·AppShell·스타일을 담당합니다. `features`는 실제 API/폼 기능을 추가할 때 구현하며 빈 기능 컴포넌트를 만들지 않았습니다.
- `app → pages → features → shared` 방향을 따르고, app은 필요한 shared를 직접 사용할 수 있습니다. ESLint에서 features/shared의 app/pages 참조와 shared의 features 참조를 금지합니다. 기능 간 조합은 pages에서 수행합니다.
- React Router Data Mode의 router는 렌더 밖에서 한 번 생성합니다. `AppProviders`는 마운트 동안 동일한 QueryClient를 유지합니다. 조회 staleTime은 30초, mutation 자동 재시도는 비활성입니다. API 오류 분류가 없는 현재는 query 재시도도 비활성으로 두며 P0-3에서 네트워크/5xx만 1회 허용합니다.
- AppShell은 최대 480px·자연 스크롤·safe area를 지원합니다. TabLayout은 홈/이력/마이에만 적용하며 탭 높이 64px만큼 콘텐츠 공간을 확보합니다. ScrollRestoration은 브라우저 history entry 단위로 동작합니다.
- P0의 중립적인 임시 CSS이며 FigCraft 시각 재현 완료를 의미하지 않습니다. 토큰·compatibility CSS·AppBar·BottomAction·브랜드 Tabs는 P1에서 구현합니다.
- React Router 공식 [Data Mode 설치](https://reactrouter.com/start/data/installation), [RouterProvider](https://reactrouter.com/api/data-routers/RouterProvider)를 확인하여 `react-router`와 `react-router/dom` 진입점을 사용했습니다.

## P1-1 구현 상태

토큰 복사·보정과 폰트·글로벌 스타일·모바일 골격을 구현했습니다. 상세 규칙과 export 누락값의 FigCraft 근거는 [스타일 사용 안내](07-style-foundation.md)를 확인합니다. 공통 UI 컴포넌트는 P1-2 범위입니다.

## P1-2 구현 상태

설계명의 AppBar/BottomTabs는 실제 코드에서 AppHeader/BottomNavigation으로 통일했습니다. Button·입력·Card·Badge·FilterChip·Poster·피드백과 PageLayout/ResultView를 구현했습니다. [매핑 문서](08-shared-ui.md)를 기준으로 사용합니다. AppShell의 페이지 padding은 PageLayout과 준비 화면으로 이동했으며, BottomDock이 fixed 영역의 실제 높이와 safe area를 예약합니다. 도메인 카드·기록 폼은 P3~P5에서 구현합니다.

## P0-3 구현 상태

fetch client와 OpenAPI 생성 타입, 15개 API 함수·MSW handler, Query 옵션과 기록/프로필 mutation을 구현했습니다. 기존 Provider는 createQueryClient를 사용하며 네트워크/5xx 조회만 1회 재시도합니다. 세션 가드와 사용자 전환 시 cache 정리는 P2 연결 작업입니다. [사용 안내](09-api-foundation.md)에 환경 분리·검증·미확정 정책을 기록했습니다.
