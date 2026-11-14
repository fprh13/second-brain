---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# blame

---

## 📄 본문

### 개념

`git blame`은 **특정 파일의 각 코드 라인이 마지막으로 변경된 커밋을 추적하는 Git 명령어**다.

각 라인에 대한 커밋 해시, 작성자, 변경 날짜 등을 확인할 수 있다.

```
git blame <file>
```

**특징**

- 파일의 각 라인별 변경 커밋을 확인할 수 있다.
    
- 변경한 작성자와 날짜를 확인할 수 있다.
    
- 특정 라인 범위만 선택해서 추적할 수 있다.
    
- 과거 커밋 시점을 기준으로 조사할 수 있다.
    
- 공백 변경이나 코드 이동을 고려하는 옵션을 제공한다.
    
- 파일을 수정하지 않는 조회 명령어다.
    

> [!IMPORTANT]  
> `git blame`은 기본적으로 각 라인에 마지막으로 영향을 준 커밋을 보여준다. 해당 코드를 최초로 작성한 사람이나 버그를 처음 발생시킨 커밋을 반드시 알려주는 것은 아니다.

### 기본 사용법

```
# 파일 전체의 변경 이력
git blame EnrollmentService.java

# 10~30번 라인만 조사
git blame -L 10,30 -- EnrollmentService.java

# 6번 라인만 조사
git blame -L 6,6 -- EnrollmentService.java

# 공백 변경 무시
git blame -w -- EnrollmentService.java

# 특정 커밋 시점의 파일 분석
git blame <commit-hash> -- EnrollmentService.java
```

`--`는 Git 옵션 및 리비전과 파일 경로를 구분하는 구분자다.

### 출력 결과 이해하기

```
0aa85e78 (Developer 2026-11-04 14:50:12 +0900  1) public class EnrollmentService {
f46a22ad (Developer 2026-11-04 14:50:36 +0900  3) if (capacity <= 0) {
716fcab6 (Developer 2026-11-04 14:50:53 +0900  6) if (enrolledCount >= capacity) {
```

|항목|설명|
|---|---|
|`0aa85e78`|해당 라인을 마지막으로 변경한 커밋 해시|
|`Developer`|커밋 작성자|
|`2026-11-04`|작성 날짜|
|`14:50:12 +0900`|작성 시각 및 시간대|
|`1`|현재 파일의 라인 번호|
|`public class ...`|해당 라인의 코드|

같은 메서드나 코드 블록이라도 각 라인의 마지막 변경 커밋은 다를 수 있다.

### 주요 옵션

|옵션|설명|
|---|---|
|`-L 10,30`|10~30번 라인만 조회|
|`-w`|공백 변경을 무시하고 추적|
|`-M`|동일 파일 내부에서 이동·복사된 코드 추적 시도|
|`-C`|다른 파일에서 복사·이동된 코드 추적 시도|
|`-e`|작성자 이름 대신 이메일 표시|
|`-s`|작성자, 날짜 등의 부가 정보 생략|
|`--show-email`|작성자 이메일 표시|
|`<commit-hash>`|특정 커밋 시점을 기준으로 분석|

#### 공백 변경 무시 (-w)

코드 포맷팅으로 변경된 커밋을 무시하고 실제 로직 변경 커밋을 찾을 때 유용하다.

```
git blame -w -L 6,6 -- EnrollmentService.java
```

예를 들어 조건문에 공백만 추가된 경우 일반 `blame`은 포맷팅 커밋을 보여줄 수 있지만, `-w`는 공백 차이를 무시하여 이전 변경 커밋을 추적한다.

#### 코드 이동 추적 (-M / -C)

리팩토링 과정에서 코드가 이동되었을 때 활용한다.

```
# 동일 파일 내부의 코드 이동 추적
git blame -M -- EnrollmentService.java

# 다른 파일에서 복사된 코드 추적
git blame -C -- EnrollmentService.java
```

Git은 텍스트 유사성과 감지 기준을 사용하므로, 코드가 짧거나 변경이 많다면 이동 이력을 완벽히 찾아내지 못할 수 있다.

### git blame과 git show

두 명령어는 함께 활용하기 좋다.

- `git blame`: 특정 라인을 마지막으로 변경한 커밋 탐색
    
- `git show`: 특정 커밋의 상세 정보 및 변경 내용 확인
    

```
# 1. 문제 코드의 변경 커밋 탐색
git blame -L 20,30 -- EnrollmentService.java

# 2. 해당 커밋의 변경 내용 확인
git show <commit-hash>

# 3. 변경된 파일 및 변경량 요약
git show --stat <commit-hash>

# 4. 해당 커밋에서 특정 파일의 변경만 확인
git show <commit-hash> -- EnrollmentService.java
```

`git show`는 커밋 작성자, 날짜, 메시지, 변경된 파일, 코드 차이 등을 보여준다.

### 다른 Git 명령어와 차이

|명령어|주요 목적|
|---|---|
|`git log`|커밋 기록 탐색|
|`git diff`|두 작업 상태나 커밋 사이의 차이 비교|
|`git blame`|특정 라인의 마지막 변경 커밋 추적|
|`git show`|특정 커밋의 상세 내용 확인|
|`git bisect`|이진 탐색으로 버그 발생 커밋 추적|

### 백엔드 개발자의 실무 활용

#### 1. 버그 발생 원인 조사

Spring Security의 JWT 검증 코드에서 의심스러운 조건문을 발견한 상황.

```
git blame -L 40,60 -- JwtUtil.java
git show <commit-hash>
```

조건문이 언제 변경되었고 어떤 수정이 이루어졌는지 조사한다.

#### 2. JPA 쿼리 최적화 이력 파악

복잡한 `fetch join`이나 인덱스 관련 쿼리가 도입된 배경을 조사한다.

```
git blame -L 30,70 -- EstimateRepositoryImpl.java
git show <commit-hash>
```

커밋 메시지와 변경 내용을 통해 N+1 문제 해결이나 성능 개선 이력을 파악할 수 있다.

#### 3. 설정 변경 의도 파악

RabbitMQ 재시도 횟수, Redis TTL, JWT 만료 시간 등 설정값의 변경 이력을 조사한다.

```
git blame -- RabbitMqConfig.java
```

기존 설정의 변경 이유를 파악한 후 수정 여부를 결정한다.

#### 4. 레거시 코드 분석 및 협업

오래된 서비스의 코드가 왜 작성되었는지 파악할 때 사용한다.

1. `git blame`으로 변경 커밋 확인
    
2. `git show`로 변경 내용 분석
    
3. 관련 PR 및 이슈 확인
    
4. 필요한 경우 작성자에게 변경 의도 문의
    
5. 기존 의도를 고려하여 수정
    

### 주의사항

- `blame`은 버그 책임자를 찾는 명령어가 아니라 코드 변경 이력을 조사하는 도구다.
    
- 코드 포맷팅 커밋이 실제 로직 수정 기록을 가릴 수 있다.
    
- 리팩토링이나 코드 이동으로 원래 변경 이력이 보이지 않을 수 있다.
    
- 커밋 메시지만으로 정확한 변경 의도를 확정할 수 없다.
    
- 버그가 최초 발생한 커밋을 찾는 데에는 `git bisect`가 더 적합할 수 있다.
    
- Git의 페이저 화면에서 `(END)`가 표시되면 `q`로 종료한다.
    

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]