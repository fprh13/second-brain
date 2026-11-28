# 도키도키 Backend Handoff Package

2026-11-25(Asia/Seoul)에 실제 React 소스와 MSW를 확인한 인계 자료입니다. **요구사항 분석 완료 / API·제품 정책 미합의 / 실제 서버 연동 미검증** 상태입니다. 이 디렉터리 전체를 복사하면 백엔드 개발 에이전트가 원본 저장소 없이 계약과 핵심 근거를 읽을 수 있습니다.

## 읽는 순서

1. [요구사항](requirements.md): 6개 도메인, 데이터·권한·수용 조건입니다.
2. [API 비교](api-contract-review.md): 15개 작업, 일치·차이·미결정 항목입니다.
3. [프론트엔드·Mock 동작](frontend-behavior.md): 실제 저장·캐시·오류 복구와 Mock 한계입니다.
4. [도메인 후보](domain-model.md): 엔티티 관계와 조건부 제약입니다.
5. [결정 목록](open-decisions.md): A01~A09와 추가 검토 및 착수 게이트입니다.
6. [출처 명세](source-manifest.md), [검증 결과](validation.md)를 확인합니다.

## 해석 규칙

- **요구**는 사용자 지침의 완료 정수 평가 1~5, 중단 사유 필수, 사용자 소유권, 고유 작품 식별 및 실제 카탈로그와 AI 결과 매칭 등입니다.
- **관찰**은 해당 커밋의 코드·문서에서 확인한 동작입니다. 관찰된 Mock 정책이 운영 정책으로 승인된 것은 아닙니다.
- **가정**은 쿠키/CSRF, 가입 자동 로그인, 작품당 기록 1개, 입력 길이, 멱등 보관 시간 등의 프론트 초안입니다.
- **제안**은 서버 구현 검토안이며 **미결정** 항목의 승인 전 운영 스키마·계약으로 확정하지 않습니다.

기존 백엔드 docs는 전달 문서 기반의 설계 제안입니다. 이번 패키지는 실제 프론트 소스를 추가 확인한 자료이며 기존 A/C/T 결정이나 B00~B10 구현 계획을 승인·대체하지 않습니다. 백엔드 README의 DB 설정 부재 설명과 달리 현재 설정에는 환경변수 참조가 있습니다. 실제 환경변수 값·DB 접속·기동은 이번에 검사하지 않았습니다.

## 원본과 전달 범위

[OpenAPI 초안](references/frontend/docs/openapi.draft.json), [API·MSW](references/frontend/docs/03-api-and-msw.md), [미확정 사항](references/frontend/docs/05-open-questions.md), [프론트 개요](references/frontend/docs/README.md)를 원래 상대 경로 그대로 보존했습니다. API client·모듈·생성 타입·모델·폼·Query·MSW·테스트도 `references/frontend/`에 선별 보관했습니다. 이 소스 묶음은 실행 가능한 프론트 배포본이 아닙니다.

초안 수정이나 Spring Boot 구현은 수행하지 않았습니다. 새 서버 에이전트는 결정 목록을 검토하고 API 합의 → 데이터 모델·트랜잭션 설계 → 구현 계획 → 계약/통합 테스트 순으로 진행합니다. 실제 연동 전 프론트 담당자가 변경 계약·생성 타입·MSW·복구 UI를 함께 갱신해야 합니다.
