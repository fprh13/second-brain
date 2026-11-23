# 홈·추천·작품 상세 구현

2026-11-19, P3 중 홈·추천·상세 범위를 구현했습니다. 검색과 기록 등록·이력은 2026-11-20 후속 작업에서 구현했습니다. [시청 기록 구현 안내](12-watch-records.md)를 확인합니다.

## 화면과 재사용

- `/`: 대표 추천, 가로 카드, 전체 보기, 검색·기록 진입, 기존 하단 Navigation입니다.
- `/recommendations`: 실제 응답 개수, 서버 순서를 보존한 2열 목록, 예상도 상/중/하와 이유입니다. starter·updating·unavailable·0개·오류·로딩을 구분합니다.
- `/anime/:animeId`: ID 기반 상세·포스터·추천 이유, 404·재시도입니다. 홈/추천 카드에서 진입하면 history로 복귀하여 스크롤을 복원하고 직접 접근 시 추천 목록으로 복귀합니다.
- `recordId`가 있으면 기존 수정 경로, 없으면 신규 등록 경로를 연결합니다. 기록 폼은 P4/P5 준비 화면이며 저장 동작을 추가하지 않았습니다.

AppHeader, BottomNavigation, Card, Badge, Poster, Button/ButtonLink, PageLayout, EmptyState, LoadingIndicator를 재사용합니다. AnimeCard는 poster/compact/featured 표시를 공유하고 DTO 전체 대신 필요한 표시 props를 받습니다. RecommendationFeedback은 추천 상태, QueryFeedback은 범용 조회 실패·로딩을 담당합니다. 빈 이미지 URL도 Poster fallback으로 처리합니다.

## HTTP와 캐시

기존 `getRecommendations`와 `getAnime`를 그대로 사용합니다. 홈 전용 API는 계약에 없으므로 홈과 목록이 `['recommendations', userId]`를 공유합니다. 상세는 기존 `['anime', userId, 'detail', id]`를 사용합니다. 기본 staleTime 30초·상세 5분, 네트워크/5xx 1회 재시도 정책을 유지합니다. 401 처리와 사용자 캐시 제거는 기존 인증 QueryClient가 담당합니다.

추천 updating은 보이는 화면에서 2초 간격, 갱신 시작부터 최대 30초입니다. 이후 마지막 결과·갱신 안내·수동 재조회 버튼을 유지합니다. ready 또는 HTTP 실패 시 자동 polling을 종료합니다. 수동 재조회는 제한 시간을 다시 시작합니다. Mock `recommendation-updating` 시나리오는 4초 뒤 다음 조회에서 ready로 전환합니다. 이는 실제 추천 계산이 아닙니다.

원본 12개 작품의 ID/제목/포스터를 맞추고 목록·상세의 추천 이유를 동일 fixture로 구성했습니다. `anime-0`, 초기 기록 `anime-10/11`을 보존하며 P0-3 임시 제목 매핑은 원본으로 교체했습니다. 앱은 fixture를 직접 읽지 않고 MSW HTTP를 사용합니다. 이미지 3개는 인증 자산을 재사용하고 나머지 9개는 FigCraft 내장 바이트를 복사했습니다. [출처와 해시](../public/images/anime/CREDITS.md)를 확인합니다.

OpenAPI·생성 타입은 변경하지 않았습니다. 장르·줄거리·제작사·점수·명시적 순위·관련 작품·필터·정렬 API는 현재 계약/원본에 없으므로 임의 생성하지 않았습니다. 목록은 서버 제공 순서를 표시하며 예상도를 확률/평점으로 바꾸지 않습니다. 찜 기능도 추가하지 않았습니다.

## 디자인 검토

FigCraft MCP로 home 35, recommendations 253, detail 397의 실제 트리·크기·문구·이동을 읽고 screenshot으로 확인했습니다. 원본 문구와 Asset Manifest 1170도 대조했습니다. `designs/`, `tools/`는 수정하지 않았습니다.

375×812 Chromium 스크린샷과 원본을 직접 비교했습니다. 홈 대표 4:3·가로 카드 136px, 추천 159.5×212.66px·열 간격 8px, 상세 327×436px·24px 여백, 헤더·하단 탭을 맞췄습니다. 홈의 상위 제목 스타일이 카드 제목에 적용되던 문제를 수정했습니다. 텍스트의 강제 개행을 복사하지 않으므로 긴 제목·추천 이유는 폭에 따라 원본과 줄바꿈이 다를 수 있습니다. 이미지 렌더러의 리샘플링·글꼴 안티앨리어싱 차이는 남으며 픽셀 완전 일치/MAE 측정은 주장하지 않습니다.

로딩·실패·빈 결과 UI는 원본에 없는 최소 추가 상태이며 디자인 승인 완료로 간주하지 않습니다. 좁은 폭·대안 팔레트·모의 safe area·이미지 실패도 Chromium에서 검증합니다. 실제 기기 safe area와 WebKit은 미검증입니다.

## 후속 범위와 제약

P3 검색과 URL 검색 복원, P4 기록 등록·이력을 완료했으며 다음은 P5 수정·삭제입니다. P0-4 CI는 별도로 남아 있습니다. 실제 백엔드 연결 전 A01/A05/A06/A08, 추천 최종 일관성·세션 지속성·이미지 권리를 협의해야 합니다. Mock 새로고침은 기존처럼 메모리 세션을 초기화합니다.

운영 빌드는 성공하나 단일 JS 청크가 약 500.4kB로 Vite의 500kB 경고가 발생합니다. 기능별 라우트 분할은 성능 측정과 함께 후속 검토합니다. MSW·fixture는 production JS에 포함하지 않습니다.

검증 결과: Vitest 29개, Chromium 전체 68개가 통과했습니다. typecheck, lint, build, api:check, build:check, diff 공백 검사가 통과했습니다. Chromium 스크린샷을 직접 확인했으며 실제 기기/WebKit은 실행하지 않았습니다.
