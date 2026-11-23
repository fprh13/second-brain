# 스타일 기반 사용 안내

P1-1 범위입니다. 원본 `designs/`·`tools/`는 수정하지 않았습니다. 공통 UI 구현과 사용법은 [P1-2 매핑 문서](08-shared-ui.md)에 기록합니다. 완성된 기능 화면은 P2 이후 범위입니다.

## 파일과 책임

`src/main.tsx`에서 `global.css`를 한 번 import합니다. CSS 내부 순서는 원본 복사본 `tokens.generated.css` → `tokens.compat.css` → `fonts.css` → `reset.css` → global 규칙입니다. 화면·컴포넌트 배치는 CSS Modules에 둡니다. 준비 화면의 여백과 링크 터치 크기는 `RoutePlaceholder.module.css`에 격리합니다.

- generated: 83개 변수와 3개 모드를 원본 그대로 보존합니다. 직접 편집하지 않습니다. 원본 export 갱신 후 diff를 검토하고 `cp designs/dokidoki.tokens.css src/shared/styles/tokens.generated.css`로 갱신합니다.
- compat: `--fw-*`와 배율 `--lh-*`의 px만 제거합니다. `--fs-*`, `--typography-lineheight-*`, spacing/sizing/radius의 px는 유지합니다. `var(--page-x)`에 다시 `px`를 붙이거나 길이 토큰에 `1px`를 곱하지 않습니다.
- global: 기본 본문·h1/h2 typography, 한국어 개행, focus-visible, 폼 글꼴 상속, body/root 최소 높이입니다. 목록 의미·native 입력·확대를 유지하는 최소 reset을 사용합니다.
- Modules: 컴포넌트 여백·크기·배치·상태입니다. 전역 `li a`나 `button`으로 제품 UI 배치를 지정하지 않습니다.

## 참조 예시

```css
.panel {
  color: var(--c-text-1);
  background: var(--c-surface);
  padding: var(--block-pad);
  border-radius: var(--r-m);
  font-size: var(--fs-sub);
  font-weight: var(--fw-sub);
  line-height: var(--lh-sub);
}
```

색상은 `--c-*`, 글꼴은 `--fs/--fw/--lh-*`, 간격은 `--page-x/--block-*/--stack-*`, 높이는 `--h-*`, radius는 `--r-*`를 직접 참조합니다. 별칭을 대량 생성하지 않습니다. `--typography-face-*`는 설명용 문자열이며 font-weight로 사용하지 않습니다.

기본 밀리, html의 `data-doki-semantic="리디 · Alternative"` 또는 `"Threads · Alternative"`로 검토 모드를 설정합니다. 테마 선택 제품 기능은 추가하지 않습니다. 보정은 `:root, [data-doki-semantic]` 모두에 적용합니다.

## export 누락값과 폰트

FigCraft `Type/Title`은 -0.84px, 나머지 Type 스타일은 -0.32px 자간입니다. body 16px에서 `--tracking:-0.02em`을 계산해 상속하고 제목에만 `--tracking-title:-0.03em`을 적용합니다. 하위 sub/caption에 본문 em 값을 재적용하면 자간이 달라지므로 기본 상속을 유지합니다.

`Shadow/1`(노드 1023, S:24)은 `0 2px 8px #28251a14`, `Shadow/2`(1025, S:25)는 `0 8px 24px #28251a24`입니다. 테마별 그림자 재설계 없이 저장된 값을 보완했습니다. 일반 콘텐츠에는 자동 적용하지 않습니다. overlay는 export의 `--c-overlay`입니다. `--c-fill/--c-track`는 소비처 구현 때 근거를 확인합니다.

Pretendard v1.3.9의 가변 WOFF2 한 개를 `public/fonts/pretendard/`에서 제공합니다. 출처·라이선스는 같은 폴더에 있습니다. `font-display:swap`, 100~900 weight, 시스템·한글 fallback을 사용합니다. 합성 렌더링·안티앨리어싱을 강제하지 않습니다. 약 2MB 전송량이 있으며 subset 최적화는 후속 측정 대상으로 남깁니다.

## 모바일 배치

375×812를 기준으로 page 좌우 24px을 유지하고 폭은 유동적입니다. 앱 정책 변수 `--app-max-width:480px`로 넓은 화면에서 중앙 정렬합니다. 812px 높이를 고정하지 않고 `100vh` → `100dvh`와 문서 자연 스크롤을 사용합니다.

기존 viewport-fit=cover를 유지합니다. `--safe-*`는 env 값을 연결합니다. P1-2부터 AppShell은 폭·main·skip link만 담당하고 PageLayout/AppHeader/BottomDock이 여백과 inset을 처리합니다. 준비 화면은 자체 CSS로 여백을 유지합니다. 탭은 64px+테두리+bottom inset, CTA는 기본 88px+bottom inset이며 BottomDock이 실제 높이를 관찰해 흐름에 동일한 공간을 확보합니다. 긴 CTA나 확대에도 예약 높이가 갱신됩니다.

## 검증 범위

`npm test`는 라우팅 회귀와 세 팔레트의 계산된 typography·폰트 로딩·색상·radius, 키보드 focus, 폰트 실패 fallback, 긴 콘텐츠 및 모의 inset을 검증합니다. 로컬 전달 원본 대조는 원본이 없는 checkout에서 skip합니다. Chromium 자동 검증은 실제 iOS/Android 키보드·safe area 검증을 대신하지 않습니다. 완성된 화면의 픽셀 일치·WebKit·200% 확대 검증은 후속 단계입니다.
