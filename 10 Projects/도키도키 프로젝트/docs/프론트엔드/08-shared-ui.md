# 공통 UI와 FigCraft 매핑

2026-11-18 P1-2 구현입니다. 원본 파일은 변경하지 않았습니다. API DTO·Query·세션·URL 검색 정책은 공통 UI에 포함하지 않습니다.

## 원본 확인

FigCraft MCP로 4개 페이지, Components의 2개 Component Set, Screens의 16개 화면, Styles 25개, Variables 83개 및 Auto Layout을 확인했습니다. `Button/Primary` 1212는 Default 187 / Pressed 1213 / Disabled 1215 / Loading 1217입니다. `Form/WatchRecord` 1065의 Completed 1040 / Stopped 1053은 P4/P5에서 구현합니다. 140개 컴포넌트를 그대로 React 컴포넌트 수로 옮기지 않습니다.

|분류·구현|FigCraft 근거|주요 Props·상태|스타일·책임|
|---|---|---|---|
|Shared Button / ButtonLink|187, 1213, 1215, 1217, 248, 411, 726|`variant: primary/secondary`, `fullWidth`; Button만 `disabled/loading`, native button props|56px, r-m, brand/bg; loading은 스피너와 원래 접근 가능한 이름 유지, native disabled로 클릭 차단; 이동은 Link|
|Shared Icon / IconButton|219, 100, 111, 123, 135 및 44px 행동 프레임|Icon `name`; IconButton 필수 `aria-label`, native props|24px 원본 벡터, 44px 터치 영역, currentColor; 장식 SVG는 접근성 트리에서 제외|
|Shared FormField / TextField|172/178/205, Form/Field|`label`, `id`, `hint/error`; input의 value/defaultValue/ref/onChange/disabled 등|56px, 배경 bg, r-m, 내부 16px; useId와 label 연결, 기존 describedby 보존|
|Shared SelectField / TextAreaField|660, 1040/1053의 조건부 입력|동일 필드 Props + native select/textarea props|native 선택 동작 유지; textarea는 내용에 맞춰 가변 높이, 최소 3행은 추가 설계|
|Shared SearchInput|430/528|필수 `label`, input props·composition 이벤트|56px surface, 24px 검색 아이콘+8px 간격; 라벨은 시각적으로 숨기되 접근 가능; URL/debounce는 기능 소유|
|Shared FilterChip|443/447|`selected`, native button props|44px, pill, aria-pressed; 선택 그룹의 값과 단일 선택 정책은 호출부 소유|
|Shared Badge|265/349/363|span props·children|12px/700/1.4, text-1; 배경 없는 텍스트이며 도메인 라벨은 외부에서 전달|
|Shared Card|1041/1054 등 Content/Block|div props·children|surface, r-l, 내부 24px; 클릭·링크·데이터 의미를 가지지 않는 컨테이너|
|Shared Poster|Assets 18, 카드·목록의 이미지|`src/alt`, `aspect: square/portrait/landscape`, img props|1:1 / 3:4 / 4:3, cover; 크기는 부모 소유, 실패 fallback·URL 변경 복구; 출처·저작권 정보는 기능 자산에서 보존|
|Shared LoadingIndicator|1293|`label`|20px 스피너, role=status, reduced-motion; 버튼은 동일 CSS 스피너를 장식으로 재사용|
|Shared EmptyState|추가 설계 D02|`title/description/action`|기존 typography와 간격만 사용; 삽화·새 제품 화면 없음|
|Layout AppHeader|97/217/376|`title`, `onBack`, `action`, `surface: background/surface`|56px+safe top, 가운데 제목, 좌우 44px 슬롯, sticky; 뒤로 목적지 판단은 페이지 소유|
|Layout BottomNavigation|110/122/134/489/501/811|`items: {to,label,icon}[]`|64px+테두리+safe bottom, NavLink의 aria-current; 탭 노출 경로는 app 소유|
|Layout BottomAction / BottomDock|Fixed/CTA 186/695 등|children; 내부 Dock `kind`|기본 88px+safe bottom, surface 그라데이션; ResizeObserver로 실제 높이를 예약해 여러 줄 CTA 대응|
|Layout PageLayout / AppShell|화면의 Scroll/Viewport와 고정 형제|PageLayout `header`, `bottom` 판별 유니온, `surface`|AppShell은 max 480px/main/skip link, PageLayout은 페이지 여백·헤더·하단 하나를 조합|
|Composite ResultView|234/681/741/757/849, Feedback 243/690|`title/description/message/summary/action`|PageLayout 조합, 메시지 role=status; 서버 성공 여부·결과 state 검증은 페이지 책임|

버튼 size/danger 등 원본에 없는 축은 추가하지 않았습니다. Pressed는 `:active`, Disabled/Loading은 props로 대응합니다. 오류 색·필드 테두리, standalone 로딩 문구, EmptyState, 이미지 fallback은 원본의 완성된 상태가 아닌 최소 접근성·복구 설계입니다. 버튼 pending만으로 임의 form onSubmit을 보호할 수는 없으므로 실제 mutation 핸들러에도 pending 검사를 둡니다.

## 사용과 레이아웃 경계

직접 파일에서 import합니다. React 19의 native ref prop을 입력·버튼으로 전달할 수 있습니다. FormField를 직접 사용하는 경우 제어 요소의 id와 `fieldAccessibility` 반환값도 연결합니다. 오류 요약과 첫 오류 focus는 폼이 담당하며, 공유 필드는 사용자의 포커스를 임의로 이동하지 않습니다.

```tsx
<PageLayout
  header={{ title: '프로필 수정', onBack: handleBack, surface: 'surface' }}
  bottom={{ kind: 'action', content: <Button type="submit" form="profile" loading={pending} fullWidth>저장하기</Button> }}
>
  <form id="profile" onSubmit={handleSubmit}>
    <TextField label="닉네임" value={nickname} onChange={handleChange} error={error} />
  </form>
</PageLayout>
```

AppShell은 앱 루트에서 한 번 사용합니다. PageLayout을 중첩하지 않습니다. TabLayout이 이미 BottomNavigation을 소유하는 홈·이력·마이 페이지에는 추가 bottom을 지정하지 않습니다. PageLayout의 기본 좌우 여백은 24px입니다. 원본 Content/Block의 바깥 16px·내부 24px 배치는 기능 페이지의 CSS Module에서 블록 바깥 여백을 조정합니다. Card 자체에 음수 margin을 숨기지 않습니다. 하단 예약 공간은 BottomDock이 소유하고, 실제 safe area는 각 헤더·하단이 처리합니다.

## 도메인 UI 계획

- P3 `features/anime`: AnimeCard compact/poster, AnimeRow, FeaturedAnime. 제목·포스터 내용은 props이며 동적 animeId 이동은 이 계층에서 조합합니다. RecommendationCard를 중복 생성하지 않고 추천 설명은 recommendations 기능에서 조합합니다.
- P3 `features/recommendations`: RecommendationLevel의 상/중/하 라벨, 추천 설명·대표 추천 블록. Badge는 DTO/enum을 모릅니다.
- P4 `features/records`: WatchRecordRow(HistoryItem), WatchStatus, 검색 상태 필터와 기록 폼. recordId 분기·완료 평가·중단 사유는 기능 책임입니다.
- P5: 등록/수정 공용 WatchRecordForm과 삭제 확인. 공통 UI에서 기록 정책을 미리 추상화하지 않았습니다.

## 독립 검증

`npm run dev` 후 `/e2e/fixtures/ui.html`에서 독립 렌더링합니다. `?view=result`는 결과 조합 비교용입니다. `src/test/ui-main.tsx`, `UiFixture.tsx`, CSS Module 및 HTML은 테스트 진입점이며 운영 router/main에서 import하지 않습니다. 새 의존성이나 Storybook은 추가하지 않았습니다.

`npm run test:e2e -- e2e/ui.spec.ts`는 오류 연결·입력 복원·한글 조합 이벤트 전달·키보드 선택·pending 중복 차단·native select/textarea·이미지 실패/복원·3개 모드·320/375/390/430/1280px와 모의 safe area를 검사합니다. 기존 라우팅/스타일 회귀도 함께 실행합니다. 자동 composition 이벤트 검증은 실제 OS 한글 IME 검증을 대신하지 않습니다.

전체 16개 완성 화면 픽셀 비교, 실제 모바일 키보드·safe area, WebKit 및 스크린리더 실기 검증은 P7에 남깁니다. API·인증·성공 경로는 현재 준비 화면 정책을 유지합니다.
