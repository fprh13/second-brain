# 검증 기록

2026-11-25에 수행한 문서 패키지 검증입니다. 기존 문서에 적힌 과거 테스트 통과 수치를 이번 실행 결과로 사용하지 않았습니다.

- 프론트 `node scripts/api-types.mjs --check`: 종료 코드 0입니다. 프로젝트 SwaggerParser 검증과 openapi-typescript 재생성 결과의 기존 타입 일치를 확인했습니다. 생성 파일을 수정하지 않았습니다.
- `python3 backend-handoff/verify.py`: 스냅샷 SHA-256, 내부 Markdown 링크, OpenAPI 내부 $ref, operationId 중복/15개 검토 대응, 금지 경로·파일을 검사합니다. 스냅샷 89개, 내부 참조 156개, API 15개와 Markdown 링크 211개를 확인하여 오류 0건입니다. 실행 집계는 [verification-report.json](verification-report.json)에 보관합니다.
- 생성 시 각 snapshot을 프론트 HEAD의 git show blob과 비교했습니다. 초기 OpenAPI와 현재, 백엔드 기존 전달 초안과 현재도 바이트 동일합니다.
- `git diff --check`, `git diff --staged --check`를 통과했고 staged diff를 검토했습니다. 최종 Git 결과는 완료 보고에 별도로 남깁니다.

스냅샷 원본 문서의 상대 링크 중 선택적으로 제외한 자산/도구/원본 과거 자료는 verification-report의 `snapshot_unresolved_links`에 구별합니다. 새로 작성한 분석 문서의 내부 링크 누락은 실패 처리합니다. 원문 보존을 위해 스냅샷 링크를 수정하지 않습니다.

이번 변경은 문서·참조 소스·검증 스크립트만 추가합니다. Spring Boot 구현이나 프론트 코드 변경이 없어 Gradle test/build, Vitest/E2E·프론트 운영 빌드를 실행하지 않았습니다. API client/handler 비교는 소스 검토이며 쿠키·CORS·DB 영속성·실제 AI·운영 장애·동시성 검증은 수행하지 않았습니다. verify.py는 JSON 구조/참조와 패키지 무결성 검사이며 실제 API 실행 테스트 또는 OpenAPI 모든 의미 검증을 대체하지 않습니다.

## 후속 서버 검증 수용 항목

|영역|반드시 확인할 사례|
|---|---|
|인증|가입/로그인/로그아웃/세션 만료, 잘못된 CSRF, 같은 브라우저 사용자 전환, 재시작 지속성|
|기록|평가 0/1/5/6·소수·문자열, 사유 공백/경계, inactive/unknown 필드, 타인 조회/쓰기 404|
|중복·경쟁|동시 같은 키/다른 body, 같은 작품 다른 키, 수정/삭제 버전 충돌, 응답 유실·만료·삭제 후 재생|
|검색|q 공백/길이·Unicode·같은 제목/다른 시즌, limit 경계, 변조/다른 조건/데이터 변경 커서|
|응답|필수 nullable 키, 204 빈 본문, 필드 오류 경로, 429 Retry-After, 집계와 recordId 일치|
|추천|0개/부족/starter/updating/unavailable, 기록 제외, 계산 중 재변경, 허구 작품/모호한 매칭·잘못된 JSON·타임아웃|
|프로필|닉네임 정규화/경계·동시 수정·재로그인 최신값·늦은 응답 사용자 격리|
