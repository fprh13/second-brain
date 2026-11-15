---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# blame 실습

---

## 📄 본문

### 실습 목표

실제 백엔드 코드에서 버그 수정 및 기능 추가 이력을 `git blame`으로 추적하고, `git show`로 커밋의 변경 내용을 확인한다.

**학습 내용**

- 여러 커밋으로 파일 변경 이력 생성
    
- `git blame`으로 라인별 커밋 추적
    
- `git show`로 변경 내용 확인
    
- 특정 라인 및 과거 커밋 조회
    
- 공백 변경 무시 및 코드 이동 추적 옵션 이해
    

### 실습 환경

|항목|내용|
|---|---|
|저장소|`chanmu-dev-lab-playground`|
|기준 브랜치|`feature/jym-git-play`|
|실습 브랜치|`lab/blame`|
|실습 경로|`jym/practice/blame/`|
|대상 파일|`EnrollmentService.java`|
|환경|macOS, Git CLI|

### 1. 실습 브랜치 생성

기존 실습 기록과 분리하기 위해 새로운 브랜치를 생성한다.

```
git status --short

git switch -c lab/blame

mkdir -p jym/practice/blame
```

디렉터리 구조:

```
jym/
└── practice/
    ├── blame/
    │   └── EnrollmentService.java
    ├── cherry-pick/
    ├── rebase/
    ├── reflog/
    └── worktree/
```

### 2. 첫 번째 커밋 - 최초 코드 작성

수강 신청 정원 검증 로직을 작성한다.

```
public class EnrollmentService {
    public String enroll(int capacity, int enrolledCount) {
        if (enrolledCount > capacity) {
            return "FULL";
        }
        return "CONFIRMED";
    }
}
```

의도적으로 버그를 포함시켰다.

정원과 현재 신청 인원이 같을 경우에도 신규 신청이 허용된다.

```
if (enrolledCount > capacity)
```

예를 들어 정원이 30명이고 현재 신청 인원이 30명이라면 `30 > 30`은 거짓이므로 `"CONFIRMED"`가 반환된다.

커밋을 생성한다.

```
git add jym/practice/blame/EnrollmentService.java

git commit -m "feat: 수강 신청 처리 로직 작성"
```

**생성된 커밋:** `0aa85e7`

### 3. 두 번째 커밋 - 입력값 검증 추가

정원이 0 이하인 경우 예외를 발생시키는 검증을 추가한다.

```
if (capacity <= 0) {
    throw new IllegalArgumentException("capacity must be positive");
}
```

최종 메서드 구조:

```
public String enroll(int capacity, int enrolledCount) {
    if (capacity <= 0) {
        throw new IllegalArgumentException("capacity must be positive");
    }
    if (enrolledCount > capacity) {
        return "FULL";
    }
    return "CONFIRMED";
}
```

변경 사항을 확인하고 커밋한다.

```
git diff -- jym/practice/blame/EnrollmentService.java

git add jym/practice/blame/EnrollmentService.java

git commit -m "feat: 수강 신청 정원 입력값 검증 추가"
```

**생성된 커밋:** `f46a22a`

### 4. 세 번째 커밋 - 정원 초과 버그 수정

기존 조건문의 `>`를 `>=`로 수정한다.

```
- if (enrolledCount > capacity) {
+ if (enrolledCount >= capacity) {
```

macOS 터미널에서 다음 명령어로 수정했다.

```
sed -i '' 's/enrolledCount > capacity/enrolledCount >= capacity/' \
  jym/practice/blame/EnrollmentService.java
```

변경 사항을 커밋한다.

```
git diff -- jym/practice/blame/EnrollmentService.java

git add jym/practice/blame/EnrollmentService.java

git commit -m "fix: 수강 신청 정원 초과 버그 수정"
```

**생성된 커밋:** `716fcab`

### 5. 커밋 이력 확인

```
git log --oneline -3
```

**실제 결과**

```
716fcab (HEAD -> lab/blame) fix: 수강 신청 정원 초과 버그 수정
f46a22a feat: 수강 신청 정원 입력값 검증 추가
0aa85e7 feat: 수강 신청 처리 로직 작성
```

총 3개의 커밋으로 코드 변경 이력을 만들었다.

|커밋|작업|
|---|---|
|`0aa85e7`|최초 코드 작성|
|`f46a22a`|정원 입력값 검증 추가|
|`716fcab`|정원 초과 버그 수정|

### 6. git blame 실습

다음 명령어를 실행한다.

```
git blame jym/practice/blame/EnrollmentService.java
```

**실제 결과 (작성자 및 날짜 정보 생략)**

```
0aa85e78 (1) public class EnrollmentService {
0aa85e78 (2)     public String enroll(int capacity, int enrolledCount) {
f46a22ad (3)         if (capacity <= 0) {
f46a22ad (4)             throw new IllegalArgumentException("capacity must be positive");
f46a22ad (5)         }
716fcab6 (6)         if (enrolledCount >= capacity) {
0aa85e78 (7)             return "FULL";
0aa85e78 (8)         }
0aa85e78 (9)         return "CONFIRMED";
0aa85e78 (10)     }
0aa85e78 (11) }
```

#### 결과 분석

|라인|변경 커밋|의미|
|---|---|---|
|1~2|`0aa85e78`|최초 클래스 및 메서드 작성|
|3~5|`f46a22ad`|두 번째 커밋에서 검증 추가|
|6|`716fcab6`|세 번째 커밋에서 조건 수정|
|7~11|`0aa85e78`|최초 작성 이후 해당 라인 변경 없음|

**핵심 확인**

```
if (enrolledCount >= capacity) { // 716fcab6
    return "FULL";               // 0aa85e78
}
```

같은 코드 블록 내부라도 라인마다 마지막 변경 커밋이 다르게 나타난다.

따라서 `blame`은 코드 블록이나 메서드 전체가 아닌 **각 라인의 변경 이력**을 보여준다.

### 7. git show로 변경 내용 분석

`blame`에서 확인한 커밋을 이용하여 상세 내용을 조사한다.

```
# 버그 수정 커밋
git show 716fcab6

# 입력값 검증 추가 커밋
git show f46a22ad

# 최초 작성 커밋
git show 0aa85e78
```

버그 수정 커밋에서 다음 변경 내역을 확인할 수 있다.

```
-        if (enrolledCount > capacity) {
+        if (enrolledCount >= capacity) {
```

추가 명령어:

```
# HEAD 커밋 상세
git show HEAD

# HEAD의 부모 커밋 상세
git show HEAD~1

# 최신 커밋의 변경량 요약
git show --stat HEAD

# 최신 커밋의 변경 파일 목록
git show --name-only HEAD
```

`blame`으로 변경 커밋을 찾고 `show`로 해당 커밋의 실제 변경 내용을 조사하는 방식이다.

### 8. 추가 학습 - 특정 라인 및 과거 시점 조회

다음 명령어는 앞선 실습을 확장할 때 활용할 수 있다.

#### 특정 라인 조회

```
git blame -L 6,6 -- jym/practice/blame/EnrollmentService.java
```

6번 라인의 변경 커밋만 조회한다.

버그 수정 커밋인 `716fcab6`이 표시된다.

#### 과거 시점 조회

```
git blame f46a22ad -- jym/practice/blame/EnrollmentService.java
```

두 번째 커밋 당시의 파일을 기준으로 조사한다.

당시 정원 검증 조건은 다음과 같았다.

```
if (enrolledCount > capacity) {
```

과거 커밋을 기준으로 분석하더라도 현재 작업 디렉터리의 파일은 변경되지 않는다.

### 9. 추가 실습 - 공백 변경 무시 (-w)

실무에서는 코드 포맷팅 변경이 기존 로직 수정 이력을 가리는 경우가 있다.

#### 공백 변경 커밋 생성

```
sed -i '' 's/if (enrolledCount >= capacity)/if ( enrolledCount >= capacity )/' \
  jym/practice/blame/EnrollmentService.java
```

```
git add jym/practice/blame/EnrollmentService.java

git commit -m "style: 수강 신청 조건문 공백 정리"
```

#### 일반 blame과 비교

```
# 일반 조회
git blame -L 6,6 -- jym/practice/blame/EnrollmentService.java

# 공백 변경 무시
git blame -w -L 6,6 -- jym/practice/blame/EnrollmentService.java
```

예상 결과:

|명령어|표시되는 변경 커밋|
|---|---|
|일반 `blame`|새로 생성한 style 커밋|
|`blame -w`|기존 버그 수정 커밋 `716fcab6`|

`-w`는 공백 변경을 무시하고 실제 로직 변경 이력을 조사할 때 유용하다.

> [!NOTE]  
> 이 단계는 추가 실습 가이드다. 앞서 확인한 실제 실습 기록은 3개의 커밋까지다.

### 10. 추가 학습 - 코드 이동 추적

리팩토링 과정에서 코드가 이동한 경우 다음 옵션을 활용할 수 있다.

```
# 같은 파일 내부 코드 이동 추적
git blame -M -- jym/practice/blame/EnrollmentService.java

# 다른 파일에서 복사된 코드 추적
git blame -C -- jym/practice/blame/EnrollmentService.java
```

Git은 코드의 유사성을 기반으로 추적하므로 모든 이동을 완벽하게 감지하지는 못한다.

짧은 코드보다 충분한 길이의 코드 블록에서 옵션의 차이를 관찰하기 쉽다.

---

## ✏️ 메모

### 실습에서 배운 점

1. `git blame`은 파일의 각 라인을 마지막으로 변경한 커밋을 보여준다.
    
2. 같은 코드 블록에서도 라인별로 서로 다른 커밋이 표시될 수 있다.
    
3. `git show`를 함께 사용하면 변경 전후 코드를 확인할 수 있다.
    
4. 특정 라인 범위나 과거 커밋 시점을 지정하여 조사할 수 있다.
    
5. 공백 변경이 이력을 가리는 경우 `-w`를 활용한다.
    
6. 코드 이동이 발생하면 `-M`, `-C` 옵션을 고려할 수 있다.
    

### 실무 활용 흐름

```
문제가 발생한 코드 발견
        ↓
git blame
        ↓
라인을 변경한 커밋 확인
        ↓
git show
        ↓
변경 전후 코드 및 커밋 메시지 분석
        ↓
관련 PR / 이슈 확인
        ↓
기존 변경 의도 파악
        ↓
원인 분석 및 수정
```

### 백엔드 관점에서의 주의사항

이번 실습의 정원 초과 조건을 `>=`로 변경하는 것은 순차적으로 실행되는 단순 검증 로직의 버그 수정이다.

실제 수강 신청 서비스에서 여러 사용자가 동시에 신청한다면 이 조건문만으로 정원 초과를 방지할 수 없다.

실제 서비스에서는 DB 원자적 업데이트, 락, 트랜잭션 등을 고려해야 한다.

### 실습 종료 후

실습 브랜치를 보존할 경우 현재 상태를 그대로 유지한다.

실습을 마치고 기존 브랜치로 돌아가려면:

```
git switch feature/jym-git-play
```

추후 실습 브랜치가 더 이상 필요 없을 때, 삭제해도 되는지 확인한 후 삭제한다.

```
git branch -D lab/blame
```

`-D`는 병합 여부와 무관하게 브랜치를 강제로 삭제하므로 실습 기록 보존 여부를 먼저 확인한다.

---

## 📚 참고 및 링크

- [[]]
---

## 🔗 관련 노트

- [[../01 Permanent/blame|blame]]