# 도메인·데이터 모델 후보

이 문서는 필요한 데이터와 관계를 정리하며 테이블/컬럼/DB 제품을 확정하지 않습니다. 근거는 [DTO 비교](api-contract-review.md)와 [원본 타입](references/frontend/src/shared/api/generated/schema.d.ts), [Mock 저장 구조](references/frontend/src/mocks/db.ts)입니다.

|후보|현재 외부 데이터|관계·필요한 제약|미결정/설계 검토|
|---|---|---|---|
|User|id, email, nickname|User 1:N WatchRecord, User 1:N 추천 결과 후보; 세션의 주체|이메일 정규화 후 유일성·닉네임 중복·탈퇴·자격 보관·세션 수명입니다. password는 입력 전용이며 응답 속성이 아닙니다.|
|Anime|id, title, posterUrl nullable|Anime 1:N WatchRecord, Anime 1:N 추천 항목 후보; 제목 대신 ID 참조|외부 데이터셋·ID 정책·포스터 권리·삭제/병합을 결정합니다. recordId는 개인 조회 조합값으로 Anime의 공통 속성에 저장하지 않는 안입니다.|
|WatchRecord|id, anime, entry, version, createdAt, updatedAt|소유 User와 대상 Anime, 상태별 값과 version>=1|사용자+작품 UNIQUE는 A03 승인 때만 확정합니다. 재시청·기록 이력·soft delete 여부에 따라 관계/제약이 바뀝니다.|
|WatchEntry 값 객체|completed+rating 또는 stopped+reason|두 분기 배타적, 완료 정수 1~5, 중단 사유 필수|컬럼 구성/값 객체 구현은 서버 선택입니다. 완료 사유/나중에 보기 A09 전에는 최종 enum을 확정하지 않습니다.|
|Recommendation 결과 후보|status, mode, generatedAt, items|사용자별 결과 묶음과 순서 있는 항목, 항목은 실제 Anime 참조|현재 DTO에 결과 ID/작업 ID가 없으므로 영속 엔티티 필요 여부와 보관 단위를 결정합니다. current snapshot/history/revision은 제안입니다.|
|RecommendationInfo 값 객체|level, reason|작품 상세와 추천 목록에서 사용|high/medium/low는 확률이 아니며 근거·품질 기준은 미정입니다. 사용자/결과 범위에 속합니다.|
|Session·멱등 요청 후보|쿠키/CSRF, 사용자별 Idempotency-Key|세션 주체·만료, 사용자+작업+키와 요청/성공 응답|외부 DTO 엔티티가 아닙니다. 저장 매체/TTL/경쟁 제어/민감정보 처리와 성공 응답 보관은 A01/A04 결정입니다.|

## 작품 식별·언어·시리즈

프론트는 단일 title과 fixture ID만 정의합니다. 한국어·영어·일본어 제목, aliases, externalIds, seriesId, seasonNumber는 현재 API에 없습니다. 사용자 지침과 백엔드 기존 설계는 정확한 매칭을 위해 이 구분을 요구하므로 내부 후보 모델로 검토해야 합니다. 실제 데이터가 있다고 가정하거나 응답에 임의 필수 필드를 추가하지 않습니다.

제안은 안정적인 내부 animeId와 원본 제공자+외부 ID를 연결하고 제목/언어/별칭을 별도 관리하는 것입니다. 시즌/스페셜/리메이크 식별 기준은 원본 데이터셋과 제품 합의로 정합니다. 제목이 같거나 별칭이 중복될 때 후보를 임의 선택하지 않습니다. 기존 원본을 덮어쓰지 않고 적재 재실행·실패·중복 보고가 가능한 절차를 설계합니다. 현재 프론트 스냅샷에는 운영 데이터셋이 없습니다.

## 기록 상태와 전환

|현재 상태|입력|현재 Mock 결과|확정 전 검토|
|---|---|---|---|
|없음|completed+rating|새 기록/version 1|중복 생성 경쟁·재시청 여부입니다.|
|없음|stopped+reason|새 기록/version 1|사유 trim/Unicode/길이 정책입니다.|
|completed|completed+rating|값 교체/version 증가|값이 동일한 PUT도 Mock은 version 증가합니다. 변경 없는 쓰기 정책은 미정입니다.|
|completed|stopped+reason|rating 제거, reason 저장/version 증가|과거 평가 보관·추천 영향입니다.|
|stopped|completed+rating|reason 제거, rating 저장/version 증가|과거 사유 보관 여부입니다.|
|stopped|stopped+reason|사유 교체/version 증가|이력 보관·감사 여부입니다.|
|어느 상태든|DELETE+최신 version|Map 삭제, 이후 404, recordId=null|hard/soft delete, 복구·보관·재등록·기존 멱등 응답입니다.|

이 표는 관찰이며 상태 확장/재시청을 배제하는 승인 기록이 아닙니다. 나중에 보기를 추가하면 입력·추천 제외·집계·필터·상태 전환을 함께 정의해야 합니다.

## 정합성과 트랜잭션 검토안

- 기록 생성·중복 검사·멱등 성공 저장은 경쟁 요청에서도 일관된 결과가 필요합니다. 운영 DB 제약과 트랜잭션 설계는 A03/A04 결정 후 구체화합니다.
- 수정/삭제는 소유자 조건과 읽은 version을 함께 검증합니다. 단순 사전 GET 검사만으로 동시 쓰기를 막았다고 간주하지 않습니다.
- 기록 저장 성공 후 집계·개인 recordId는 저장된 데이터에 맞아야 합니다. recommendation 계산은 별도 수행하고 실패해도 기록 성공을 취소하지 않는 흐름을 검토합니다.
- 추천 계산 중 추가 기록 변경이 일어나면 오래된 계산이 최신 결과를 덮지 않도록 기준 revision/스냅샷 검증을 제안합니다. 작업 큐·worker·테이블은 구현되어 있지 않습니다.
- 목록은 페이지 경계를 정의하고 조회 패턴에 맞게 인덱스·연관 조회를 검토합니다. Mock 배열 정렬을 DB 성능 근거로 삼지 않습니다.
- 본인 기록 상세에 중첩되는 anime는 Mock에서 생성 당시 객체 복사본입니다. 운영에서 작품 제목/포스터 변경을 즉시 반영할지 기록 당시 값을 보존할지 결정해야 합니다.
