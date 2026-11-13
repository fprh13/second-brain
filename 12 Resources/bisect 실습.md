---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# bisect 실습

---

## 📄 본문

### 실습 개요

**목표:** 여러 커밋 중 수강 신청 정원 초과 버그를 최초로 발생시킨 커밋을 `git bisect`로 찾아낸다.

실제 Spring Boot 서버 대신 Bash 스크립트를 사용하여 수강 신청 비즈니스 로직과 테스트를 간단하게 재현하였다.

|항목|내용|
|---|---|
|저장소|`chanmu-dev-lab-playground`|
|기존 브랜치|`feature/jym-git-play`|
|실습 브랜치|`lab/bisect-enrollment`|
|실습 경로|`jym/practice/bisect/`|
|실습 시나리오|수강 신청 정원 초과 버그|
|생성 커밋|총 8개|
|버그 발생 커밋|`3303f3e`|
|사용 환경|macOS, Git, Bash|

### STEP 1. 실습 브랜치 생성

기존 작업 브랜치에 영향을 주지 않도록 별도의 실습 브랜치를 생성한다.

```
git status --short

git switch -c lab/bisect-enrollment

mkdir -p jym/practice/bisect
```

### STEP 2. 정상 수강 신청 로직 작성

`jym/practice/bisect/enroll.sh`

```
#!/usr/bin/env bash

capacity=$1
current=$2

# 정원이 가득 찼거나 초과하면 신청 거부
if (( current >= capacity )); then
    echo 409
else
    echo 201
fi
```

- `capacity`: 최대 수강 정원
    
- `current`: 현재 신청 인원
    
- `201`: 신청 가능
    
- `409`: 정원 초과 또는 마감
    

**정원 검증 조건**

```
current >= capacity
```

현재 신청 인원이 정원 이상이면 새로운 신청을 거부한다.

### STEP 3. 검증 테스트 작성

`jym/practice/bisect/test_enroll.sh`

```
#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

check() {
    expected=$1
    capacity=$2
    current=$3

    actual=$(bash "$DIR/enroll.sh" "$capacity" "$current")

    if [[ "$actual" != "$expected" ]]; then
        echo "FAIL: expected=$expected, actual=$actual"
        return 1
    fi

    echo "PASS: expected=$expected, actual=$actual"
}

check 201 3 2
check 409 3 3
check 409 3 4
```

테스트 실행:

```
bash jym/practice/bisect/test_enroll.sh
```

**정상 결과**

```
PASS: expected=201, actual=201
PASS: expected=409, actual=409
PASS: expected=409, actual=409
```

정상 기준점을 커밋한다.

```
git add jym/practice/bisect/
git commit -m "test: bisect 정상 기준점 생성"
```

### STEP 4. 여러 커밋 생성

실제 개발 과정처럼 여러 커밋을 생성하였다.

|순서|커밋 메시지|상태|
|---|---|---|
|1|`test: bisect 정상 기준점 생성`|Good|
|2|`docs: 수강 신청 요구사항 작성`|Good|
|3|`docs: 수강 신청 응답 코드 정리`|Good|
|4|`docs: 수강 신청 정책 정리`|Good|
|5|`refactor: 수강 신청 정원 검증 로직 개선`|최초 Bad|
|6|`docs: 수강 신청 로깅 정책 추가`|Bad|
|7|`docs: 수강 신청 모니터링 추가`|Bad|
|8|`docs: 배포 체크리스트 작성`|Bad|

다섯 번째 커밋에서 의도적으로 버그를 발생시켰다.

**변경 전**

```
if (( current >= capacity )); then
```

**변경 후**

```
if (( current > capacity )); then
```

macOS에서 다음 명령으로 변경하였다.

```
sed -i '' 's/current >= capacity/current > capacity/' \
  jym/practice/bisect/enroll.sh
```

변경 사항을 커밋한다.

```
git add jym/practice/bisect/enroll.sh

git commit -m "refactor: 수강 신청 정원 검증 로직 개선"
```

버그는 다섯 번째 커밋에서 발생했지만 이후에도 여러 커밋이 추가된 상황을 구성하였다.

### STEP 5. 버그 재현

현재 최신 커밋에서 테스트를 실행한다.

```
bash jym/practice/bisect/test_enroll.sh
```

**실제 결과**

```
PASS: expected=201, actual=201
FAIL: expected=409, actual=201
```

정원이 정확히 가득 찬 상황에서 정상적으로 신청이 거부되지 않고 `201`이 반환되었다.

즉, 정원이 3명이고 현재 3명이 신청한 상황에서도 추가 신청이 허용되는 버그가 발생하였다.

### STEP 6. Bisect 탐색 시작

정상 커밋과 문제 커밋을 지정한다.

먼저 커밋 이력을 확인한다.

```
git log --oneline -8
```

실습에서는 첫 번째 정상 커밋을 다음 명령으로 찾아 변수에 저장하였다.

```
GOOD=$(git log -1 --format=%H \
  --grep='^test: bisect 정상 기준점 생성$')

echo "$GOOD"
```

이 스크립트는 필수 명령어가 아니라 **실습에서 정상 기준점의 해시를 편리하게 얻기 위해 사용한 방법**이다.

Bisect 시작:

```
git bisect start
```

현재 HEAD를 문제 커밋으로 지정한다.

```
git bisect bad HEAD
```

정상 커밋 지정:

```
git bisect good "$GOOD"
```

이후 Git이 이진 탐색에 따라 중간 커밋으로 자동 이동한다.

### STEP 7. Good / Bad 반복 판정

중간 커밋에서 테스트를 실행한다.

```
bash jym/practice/bisect/test_enroll.sh
```

테스트가 통과하면:

```
git bisect good
```

버그가 재현되면:

```
git bisect bad
```

Git은 결과를 바탕으로 다음 중간 커밋으로 이동한다.

이 과정을 반복하여 최초 버그 발생 커밋을 좁혀 나간다.

**실습 중 실제 확인한 터미널 출력**

```
➦ 3303f3e <B>

$ bash jym/practice/bisect/test_enroll.sh

PASS: expected=201, actual=201
FAIL: expected=409, actual=201
```

해당 커밋에서도 버그가 발생했으므로 Bad로 판정하였다.

```
git bisect bad
```

**최종 결과**

```
3303f3e818b7c98be7dfe06d2bfa9818ae407f98
is the first bad commit

commit 3303f3e818b7c98be7dfe06d2bfa9818ae407f98

    refactor: 수강 신청 정원 검증 로직 개선

 jym/practice/bisect/enroll.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

**최초 버그 발생 커밋:** `**3303f3e**`

Git이 문제의 원인이 된 리팩토링 커밋을 정확하게 찾아냈다.

### STEP 8. 원인 커밋 분석

다음 명령으로 문제 커밋의 변경 내용을 확인할 수 있다.

```
git show 3303f3e

git show 3303f3e -- jym/practice/bisect/enroll.sh
```

문제 발생 원인:

```
- if (( current >= capacity )); then
+ if (( current > capacity )); then
```

`>=`가 `>`로 변경되면서 정원이 정확히 가득 찬 상황에 대한 검증이 누락되었다.

**학습한 내용**

- 커밋 메시지만으로는 버그 발생 여부를 판단할 수 없다.
    
- `git bisect`는 테스트 결과를 기준으로 커밋을 탐색한다.
    
- 최초 문제 커밋을 특정한 뒤 `git show`로 변경 내용을 분석할 수 있다.
    

### STEP 9. Bisect 종료

```
git bisect reset
```

해당 명령어는 탐색을 종료하고 기본적으로 시작 전 체크아웃 상태로 돌아간다.

복귀 상태 확인:

```
git status
git branch --show-current
```

정상적으로 복귀했다면 브랜치는 다음과 같아야 한다.

```
lab/bisect-enrollment
```

실제로 복귀했는지는 위 명령어로 확인한다.

### STEP 10. 자동 탐색 실습 (선택)

수동으로 Good/Bad를 입력하지 않고 테스트 스크립트를 자동 실행할 수도 있다.

기존 Bisect를 종료한 후 아래 명령을 실행한다.

```
git bisect start HEAD "$GOOD"

git bisect run bash jym/practice/bisect/test_enroll.sh

git bisect reset
```

테스트 성공 여부를 바탕으로 Git이 자동으로 중간 커밋을 탐색한다.

이 과정은 수동 실습 이후 추가로 수행할 수 있는 선택 실습이다.

### STEP 11. 실무에서 더 간단하게 사용하는 방법

실습에서는 `GOOD` 변수를 사용했지만 실제로는 정상 커밋 해시나 배포 태그를 직접 지정하면 된다.

**커밋 해시 이용**

```
git bisect start HEAD abc1234
```

**배포 태그 이용**

```
git bisect start HEAD v1.2.0
```

**자동 테스트 이용**

```
git bisect run ./gradlew test
```

단, 정상 커밋이나 태그가 실제로 정상 동작하는지 확인되어 있어야 한다.

### 실습 결과 요약

|검증 항목|결과|
|---|---|
|정상 수강 신청 로직 구현|완료|
|버그 유발 커밋 생성|완료|
|정원 초과 버그 재현|완료|
|Bisect 이진 탐색 진행|완료|
|최초 문제 커밋 탐색|완료|
|발견한 커밋|`3303f3e`|
|자동 탐색|선택 실습|
|Bisect 종료 및 복귀|확인 필요|

---

## ✏️ 메모

### 실습하면서 알게 된 점

- `git bisect`는 버그를 직접 수정하지 않고 버그가 처음 발생한 커밋을 찾아준다.
    
- `good`과 `bad`는 커밋 메시지나 코드 품질이 아니라 **현재 조사하는 버그의 발생 여부**를 의미한다.
    
- 정상 커밋 해시를 찾기 위해 복잡한 스크립트를 작성할 필요는 없다.
    
- 실무에서는 커밋 해시, 배포 태그, 브랜치의 특정 시점을 기준으로 사용할 수 있다.
    
- Bisect 중 `detached HEAD`가 발생하는 것은 정상적인 동작이다.
    
- 탐색을 마친 후 `git bisect reset`으로 원래 작업 상태에 복귀한다.
    
- `git bisect run`은 테스트 코드가 존재하고 실행 환경이 안정적인 경우 유용하다.
    

### 실무 적용 예시

Spring Boot 프로젝트에서 JPA 쿼리 최적화 이후 특정 API 응답 시간이 급격하게 증가한 경우:

1. 성능이 정상인 과거 커밋을 확인한다.
    
2. 성능 저하가 발생한 최신 커밋을 확인한다.
    
3. 재현 가능한 성능 측정 스크립트를 준비한다.
    
4. `git bisect`로 성능 회귀가 발생한 최초 커밋을 찾는다.
    
5. `git show`로 JPA 쿼리 또는 인덱스 변경 사항을 분석한다.
    
6. 원인을 수정하고 회귀 테스트를 추가한다.
    

단, 성능 테스트는 실행 환경 및 측정 오차의 영향을 받으므로 정확한 기준이 필요하다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../01 Permanent/bisect|bisect]]