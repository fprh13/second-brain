# 도키도키 프론트엔드 개발 설계

작성일: 2026-11-05. 상태: **구현 착수용 초안 완성 / 디자인 추가 상태와 백엔드 계약 합의 전**입니다. 최초 설계 작성 당시에는 애플리케이션 구현 없이 계약 검증 도구만 `/tmp`에 설치해 검사했습니다. 이후 P0-1에서 프로젝트를 초기화했으며 현재 앱은 저장소 루트에 있습니다.

## 읽는 순서

1. [화면과 사용자 흐름](01-screens-and-flows.md): 16개 화면, FigCraft 노드, 라우트, 데이터와 행동을 연결합니다.
2. [컴포넌트·스타일·아키텍처](02-architecture.md): 기술 선택, 재사용 경계, 토큰 보정, 상태 소유권을 정의합니다.
3. [API·MSW 운영 설계](03-api-and-msw.md)와 [OpenAPI 계약](openapi.draft.json): 실제 API 없이도 동일한 HTTP 경계로 구현합니다.
4. [구현 작업·검증 계획](04-delivery-plan.md): 의존성과 작업별 완료 기준을 따릅니다.
5. [누락·협의·결정 기록](05-open-questions.md): 확정 근거와 임시 정책을 구분합니다.
6. [스타일 기반 사용 안내](07-style-foundation.md): CSS 변수, 폰트 및 모바일 레이아웃의 구현 규칙입니다.
7. [공통 UI와 FigCraft 매핑](08-shared-ui.md): Props, Variant, 레이아웃 조합과 도메인 분리 기준입니다.
8. [API 기반 사용 안내](09-api-foundation.md): Client·생성 타입·Query·MSW 실행과 검증 및 제한입니다.
9. [인증 구현 안내](10-auth.md): 인증 화면·세션·폼·Mock 제약과 검증입니다.
10. [설계 검증 기록](06-validation.md): 이번 작업에서 확인한 범위와 남은 검증을 기록합니다.
11. [16개 화면 Visual QA](14-visual-qa.md): FigCraft 비교·반응형·접근성 개선, 재현 명령과 남은 디자인 협의 사항입니다.
12. [E2E 전략과 회귀 검증](15-e2e-regression.md): 실행·상태 격리·사용자 흐름·오류·진단 아티팩트와 CI 범위입니다.

## 근거와 적용 우선순위

- 디자인 원본: [dokidoki.figcraft](../designs/dokidoki.figcraft), [토큰](../designs/dokidoki.tokens.css), [HANDOFF-QA](../designs/HANDOFF-QA.md).
- FigCraft MCP `open_file`, `inspect_document`, `get_node`로 4개 페이지, 16개 375×812 Ready for Dev 프레임, 화면 내부 문구·링크·조건부 폼을 읽었습니다. 대표 홈·추천·상세를 MCP `screenshot`으로 시각 확인했습니다. 전체 화면의 새 픽셀 비교는 수행하지 않았습니다.
- MCP에서 변수 83개, 스타일 25개, 내장 이미지 12개를 확인했습니다. 컴포넌트 140개·세트 2개·인스턴스 166개·상호작용 88개는 HANDOFF-QA의 집계값입니다.
- 화면 노드와 링크가 실제 시각·흐름의 기준입니다. 줄바꿈과 로그인 여백의 충돌은 HANDOFF-QA 지침에 따라 `out/screens/*.html`, `out/components.css`를 대조합니다. `.shots`를 우선하지 않습니다.
- `out/prd.md`, `out/journey.md`, `out/screens.json`, `out/app.js`(현재 checkout에는 없는 최초 분석 자료)는 기능 의도와 예시 행동의 보조 근거입니다. 이 코드의 localStorage 저장·가짜 로그인·공통 상세 이동은 운영 요구사항이 아닙니다.
- 문서의 **관찰**은 원본 근거, **채택**은 프론트엔드 설계, **가정/협의**는 백엔드·제품·디자인 결정 전 임시 계약을 뜻합니다. API 초안은 구현된 서버의 명세가 아닙니다.

## 착수 범위

React 모바일 웹 SPA를 저장소 루트에서 개발하고 원본 `out/`, `designs/`, `tools/`는 보존합니다. 로그인, 회원가입, 추천, 작품 상세, 기록 CRUD·검색·필터, 닉네임 수정·로그아웃을 구현합니다. 커뮤니티·영상 재생·찜·관리자·소셜 로그인·알림·결제는 범위에 넣지 않습니다. 추가 상태는 새 제품 기능이 아니라 기존 기능의 로딩·실패·복구 동작으로 설계합니다.

P0-1 초기화, P0-2 App·라우팅, P1-1 토큰·글로벌 스타일과 P1-2 공통 UI 기반을 완료했습니다. 실행 방법은 [프론트엔드 README](../README.md)를 확인하고, P0-3 API client·OpenAPI 타입·MSW 및 HTTP/Query 검증도 완료했습니다. P2 인증, P3 검색을 포함한 탐색, P4 시청 이력·기록 등록을 완료했습니다. [탐색 구현 안내](11-discovery.md)를 확인합니다. P5 기록 수정·삭제도 완료했습니다. P6 마이·프로필도 완료해 16개 화면의 Mock 기반 흐름을 연결했습니다. [마이·프로필 구현 안내](13-profile.md)를 확인합니다. P0-4 CI 구성을 추가했고 P7의 Mock 통합 E2E를 확장했습니다. CI 원격 실행과 실제 기기·접근성 잔여 검증은 남아 있습니다. [시청 기록 구현 안내](12-watch-records.md)를 확인합니다. 인증/추천 미확정 항목은 MSW 계약으로 개발을 진행하되, 실제 서버 연결과 출시 전에 [협의표](05-open-questions.md)의 차단 조건을 해소해야 합니다.

13. [성능·접근성 개선 결과](16-performance-accessibility.md): 전후 측정 수치, route lazy·폰트 서브셋, axe·키보드와 미검증 범위입니다.
14. [운영 빌드·배포 안내](17-production-deployment.md): 환경 변수, 빌드 차단, 호스팅 계약·캐시·헤더, CI와 Spring Boot 연동 조건입니다.
