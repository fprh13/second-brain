---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# revert 실습

---

## 📄 본문

### 실습 개요

**목적**

`git revert`의 동작 원리를 이해하고, 실무에서 발생할 수 있는 커밋 취소, 충돌 해결, PR 병합 취소, 취소한 기능 재적용을 직접 경험한다.

**실습 환경**

- Repository: `chanmu-dev-lab-playground`
    
- 기존 브랜치: `feature/jym-git-play`
    
- 작업 디렉터리: `jym/practice/revert/`
    
- 실습 방식: 로컬 브랜치와 커밋을 이용한 Git 시뮬레이션
    

**실습 목록**

|단계|실습 내용|학습 명령어|
|---|---|---|
|1|직전 커밋 취소|`git revert HEAD`|
|2|과거 커밋 취소|`git revert <hash>`|
|3|Revert 충돌 해결|`--abort`, `--continue`|
|4|여러 커밋 일괄 취소|`--no-commit`|
|5|Merge Commit 취소|`-m 1`|
|6|Squash Merge 및 재적용|Revert of Revert|

### 0. 실습 환경 준비

기존 Git 실습에 영향을 주지 않도록 별도 브랜치를 생성한다.

```
git switch feature/jym-git-play

git status

git switch -c lab/revert-basic

mkdir -p jym/practice/revert
```

이후 작업은 `lab/revert-basic` 브랜치에서 진행한다.

### 1. 직전 커밋 Revert

**상황**

회원가입 기능과 Redis 캐시 기능을 순서대로 개발했으나, Redis 캐시 기능에 문제가 발생해 최신 커밋을 취소해야 한다.

#### 1-1. 회원가입 기능 커밋

```
echo "회원가입 기능 구현" > jym/practice/revert/signup.md

git add jym/practice/revert/signup.md
git commit -m "feat: 회원가입 기능 구현"
```

실제 커밋:

```
904ed28 feat: 회원가입 기능 구현
```

#### 1-2. Redis 캐시 기능 커밋

```
echo "Redis 캐시 적용" > jym/practice/revert/cache.md

git add jym/practice/revert/cache.md
git commit -m "feat: Redis 캐시 적용"
```

실제 커밋:

```
a819d45 feat: Redis 캐시 적용
```

#### 1-3. 최신 커밋 취소

```
git revert --no-edit HEAD
```

실제 결과:

```
16fab9c Revert "feat: Redis 캐시 적용"
a819d45 feat: Redis 캐시 적용
904ed28 feat: 회원가입 기능 구현
```

**확인**

```
git log --oneline -3
ls jym/practice/revert
git show --stat HEAD
```

**학습 결과**

- `cache.md`는 삭제된다.
    
- `signup.md`는 유지된다.
    
- 캐시 기능을 추가했던 기존 커밋은 삭제되지 않는다.
    
- 캐시 기능의 변경을 취소한 새로운 커밋이 생성된다.
    

### 2. 과거 특정 커밋 Revert

**상황**

로그인 기능을 구현한 이후 JWT 인증과 API 로깅 기능을 추가했다.

이때 중간에 있는 로그인 기능 커밋만 취소한다.

#### 2-1. 로그인 기능 개발

```
echo "로그인 기능 구현" > jym/practice/revert/login.md

git add jym/practice/revert/login.md
git commit -m "feat: 로그인 기능 구현"
```

#### 2-2. JWT 인증 기능 개발

```
echo "JWT 인증 적용" > jym/practice/revert/jwt.md

git add jym/practice/revert/jwt.md
git commit -m "feat: JWT 인증 적용"
```

#### 2-3. API 로깅 기능 개발

```
echo "API 로깅 기능 구현" > jym/practice/revert/logging.md

git add jym/practice/revert/logging.md
git commit -m "feat: API 로깅 기능 구현"
```

실제 커밋 이력:

```
cccce1f feat: API 로깅 기능 구현
b7c1b83 feat: JWT 인증 적용
5fc9c34 feat: 로그인 기능 구현
```

#### 2-4. 로그인 기능만 취소

```
git revert --no-edit 5fc9c34
```

실제 결과:

```
5eeaf48 Revert "feat: 로그인 기능 구현"
cccce1f feat: API 로깅 기능 구현
b7c1b83 feat: JWT 인증 적용
5fc9c34 feat: 로그인 기능 구현
```

**학습 결과**

- `login.md`가 삭제된다.
    
- `jwt.md`와 `logging.md`는 유지된다.
    
- 후속 커밋이 존재해도 특정 과거 커밋을 취소할 수 있다.
    

**실무 관점**

실제 인증 시스템이라면 JWT 인증이 로그인 기능에 의존할 수 있다.

따라서 Git 충돌이 발생하지 않더라도 애플리케이션의 기능이 정상 동작하는지 반드시 확인해야 한다.

### 3. Revert 충돌 발생 및 해결

**상황**

캐시 설정을 추가하고 TTL을 순차적으로 수정한 상태에서 중간 커밋을 취소한다.

같은 파일의 동일한 설정 값이 여러 커밋에서 변경되어 충돌이 발생하도록 구성한다.

#### 3-1. 기본 설정 추가

```
printf 'cache.enabled=false\ncache.ttl=60\n' > jym/practice/revert/cache-config.properties

git add jym/practice/revert/cache-config.properties
git commit -m "chore: 캐시 기본 설정 추가"
```

커밋: `40ad43c`

```
cache.enabled=false
cache.ttl=60
```

#### 3-2. Redis 캐시 활성화

```
printf 'cache.enabled=true\ncache.ttl=300\n' > jym/practice/revert/cache-config.properties

git add jym/practice/revert/cache-config.properties
git commit -m "feat: Redis 캐시 활성화 및 TTL 변경"
```

커밋: `53042fa`

```
cache.enabled=true
cache.ttl=300
```

#### 3-3. TTL 최적화

```
printf 'cache.enabled=true\ncache.ttl=600\n' > jym/practice/revert/cache-config.properties

git add jym/practice/revert/cache-config.properties
git commit -m "perf: 캐시 TTL 600초로 최적화"
```

커밋: `8b72cf8`

```
cache.enabled=true
cache.ttl=600
```

#### 3-4. 중간 커밋 Revert 시도

```
git revert 53042fa
```

**충돌 원인**

Revert 대상 커밋에서는 TTL을 60초에서 300초로 변경했다.

하지만 후속 커밋에서 다시 600초로 변경했기 때문에 Git이 어떤 값을 유지해야 하는지 자동으로 결정하기 어렵다.

#### 3-5. Revert 중단

```
git status
git diff

git revert --abort
```

확인:

```
cat jym/practice/revert/cache-config.properties
git status
```

결과:

```
cache.enabled=true
cache.ttl=600
```

Revert 작업 이전의 상태로 돌아간다.

#### 3-6. 충돌 직접 해결

다시 revert를 시도한다.

```
git revert 53042fa
```

이번에는 충돌 파일을 직접 수정한다.

**해결 정책**

- Redis 캐시 활성화 변경은 취소한다.
    
- 후속 커밋에서 적용한 TTL 600초는 유지한다.
    

최종 설정:

```
cache.enabled=false
cache.ttl=600
```

충돌 마커를 제거하고 파일을 저장한 다음 실행한다.

```
git add jym/practice/revert/cache-config.properties

git revert --continue
```

실제 결과:

```
d494bbb Revert "feat: Redis 캐시 활성화 및 TTL 변경"
8b72cf8 perf: 캐시 TTL 600초로 최적화
53042fa feat: Redis 캐시 활성화 및 TTL 변경
40ad43c chore: 캐시 기본 설정 추가
```

**학습 결과**

- `--abort`로 진행 중인 revert를 중단할 수 있다.
    
- `--continue`로 충돌 해결 후 작업을 완료할 수 있다.
    
- Revert 대상 커밋의 변경 중 일부만 반영하도록 직접 충돌을 해결할 수 있다.
    
- 코드 충돌 해결에는 개발자의 판단이 필요하다.
    

### 4. 여러 커밋을 하나로 Revert

**상황**

Redis 캐시 기능을 조회, 무효화, 모니터링 기능으로 나누어 개발했다.

이 세 커밋을 취소하되 하나의 Revert Commit으로 정리한다.

#### 4-1. 캐시 조회 기능

```
mkdir -p jym/practice/revert/batch

echo "Redis 캐시 조회 기능" > jym/practice/revert/batch/cache-read.md

git add jym/practice/revert/batch/cache-read.md
git commit -m "feat: Redis 캐시 조회 구현"
```

커밋: `9a84931`

#### 4-2. 캐시 무효화 기능

```
echo "Redis 캐시 무효화 기능" > jym/practice/revert/batch/cache-evict.md

git add jym/practice/revert/batch/cache-evict.md
git commit -m "feat: Redis 캐시 무효화 구현"
```

커밋: `029951b`

#### 4-3. 캐시 모니터링 기능

```
echo "Redis 캐시 모니터링 기능" > jym/practice/revert/batch/cache-monitor.md

git add jym/practice/revert/batch/cache-monitor.md
git commit -m "feat: Redis 캐시 모니터링 구현"
```

커밋: `3a77d9e`

#### 4-4. 세 커밋을 역순으로 취소

```
git revert --no-commit HEAD HEAD~1 HEAD~2
```

커밋 생성 전 변경 확인:

```
git status
git diff --cached --stat
git log --oneline -4
```

이 시점에는 삭제 변경만 적용되어 있고 새로운 커밋은 아직 생성되지 않았다.

#### 4-5. 하나의 커밋으로 정리

```
git commit -m "revert: Redis 캐시 기능 전체 취소"
```

실제 결과:

```
e1db13d revert: Redis 캐시 기능 전체 취소
3a77d9e feat: Redis 캐시 모니터링 구현
029951b feat: Redis 캐시 무효화 구현
9a84931 feat: Redis 캐시 조회 구현
```

**학습 결과**

- `--no-commit`으로 여러 Revert 변경을 누적할 수 있다.
    
- 여러 커밋의 취소 내용을 하나의 커밋으로 정리할 수 있다.
    
- 기존 커밋은 모두 보존된다.
    

### 5. Merge Commit 전체 Revert

**상황**

실제 GitHub PR 병합과 유사한 환경을 구성한다.

Feature 브랜치에서 Redis 기능을 개발하고, 다른 브랜치에서 별도 작업을 진행한 후 Merge Commit으로 병합한다.

병합 이후 추가 커밋이 존재하는 상태에서 PR 전체를 되돌린다.

#### 5-1. 실습 브랜치 생성

```
git switch lab/revert-basic

git switch -c lab/revert-merge
git switch -c lab/revert-feature-cache

mkdir -p jym/practice/revert/merge
```

`lab/revert-merge`는 실습용 main 브랜치 역할을 한다.

#### 5-2. Feature 브랜치 개발

**Redis 설정 추가**

```
echo "redis.enabled=true" > jym/practice/revert/merge/redis.properties

git add jym/practice/revert/merge/redis.properties
git commit -m "feat: Redis 설정 추가"
```

커밋: `5c43c02`

**조회 캐시 적용**

```
echo "Redis 조회 캐시 적용" > jym/practice/revert/merge/cache-service.md

git add jym/practice/revert/merge/cache-service.md
git commit -m "feat: 조회 API 캐시 적용"
```

커밋: `7bf3243`

**캐시 무효화 적용**

```
echo "Redis 캐시 무효화 적용" > jym/practice/revert/merge/cache-evict.md

git add jym/practice/revert/merge/cache-evict.md
git commit -m "feat: 캐시 무효화 적용"
```

커밋: `278a5ac`

#### 5-3. Main 역할 브랜치에서 별도 작업

```
git switch lab/revert-merge

echo "API 요청 지표 수집" > jym/practice/revert/merge/metrics.md

git add jym/practice/revert/merge/metrics.md
git commit -m "feat: API 요청 지표 수집"
```

커밋: `d710280`

#### 5-4. Merge Commit 생성

```
git merge --no-ff --no-edit lab/revert-feature-cache \
  -m "Merge PR #42: Redis 캐시 기능"
```

실제 Merge Commit:

```
6ebd2df Merge PR #42: Redis 캐시 기능
```

`--no-ff`를 사용하면 fast-forward 가능한 상황에서도 별도의 Merge Commit을 생성한다.

확인:

```
git log --oneline --graph --all --decorate

git show -s --format="%h %p %s" HEAD
```

#### 5-5. 병합 이후 별도 작업 추가

```
echo "API 감사 로그 적용" > jym/practice/revert/merge/audit.md

git add jym/practice/revert/merge/audit.md
git commit -m "feat: API 감사 로그 적용"
```

커밋: `eae4eb3`

현재 구조:

```
             B ─── C ─── D
            /             \
A ─── E ────────────────── M ─── F
```

- B, C, D: Redis 기능 개발
    
- E: API 요청 지표 수집
    
- M: PR #42 병합
    
- F: API 감사 로그 추가
    

#### 5-6. Merge Commit Revert

```
git revert -m 1 6ebd2df
```

첫 번째 부모인 `lab/revert-merge` 쪽을 기준으로 병합 변경을 되돌린다.

실제 결과:

```
4faba62 Revert "Merge PR #42: Redis 캐시 기능"
```

최종 히스토리:

```
* 4faba62 Revert "Merge PR #42: Redis 캐시 기능"
* eae4eb3 feat: API 감사 로그 적용
*   6ebd2df Merge PR #42: Redis 캐시 기능
|\
| * 278a5ac feat: 캐시 무효화 적용
| * 7bf3243 feat: 조회 API 캐시 적용
| * 5c43c02 feat: Redis 설정 추가
* | d710280 feat: API 요청 지표 수집
|/
* e1db13d revert: Redis 캐시 기능 전체 취소
```

**최종 파일 확인**

```
git ls-files jym/practice/revert/merge
```

예상 파일:

```
audit.md
metrics.md
```

**학습 결과**

- Feature 브랜치의 커밋 3개는 그대로 유지된다.
    
- Merge Commit도 유지된다.
    
- 하나의 Revert Commit으로 병합 변경 전체를 취소한다.
    
- 병합 전후의 독립적인 개발 내용은 유지된다.
    

### 6. Squash Merge 및 Revert of Revert

**상황**

JWT 인증 기능을 커밋 3개로 개발한 후 Squash Merge 방식으로 병합한다.

이후 기능 전체를 취소하고, 다시 Revert of Revert로 복구한다.

#### 6-1. 실습 브랜치 생성

```
git switch lab/revert-merge

git switch -c lab/revert-squash
git switch -c lab/revert-squash-feature

mkdir -p jym/practice/revert/squash
```

#### 6-2. Feature 브랜치 커밋 생성

**JWT 토큰 발급**

```
echo "JWT 토큰 발급 기능" > jym/practice/revert/squash/jwt.md

git add jym/practice/revert/squash/jwt.md
git commit -m "feat: JWT 토큰 발급 구현"
```

커밋: `81810ff`

**Refresh Token 재발급**

```
echo "Refresh Token 재발급 기능" > jym/practice/revert/squash/refresh.md

git add jym/practice/revert/squash/refresh.md
git commit -m "feat: Refresh Token 재발급 구현"
```

커밋: `52193ab`

**JWT 인증 테스트**

```
echo "JWT 인증 통합 테스트" > jym/practice/revert/squash/auth-test.md

git add jym/practice/revert/squash/auth-test.md
git commit -m "test: JWT 인증 통합 테스트 추가"
```

커밋: `da5a8f6`

#### 6-3. Squash Merge

```
git switch lab/revert-squash

git merge --squash lab/revert-squash-feature

git status
git diff --cached --stat
```

Feature 브랜치의 변경이 현재 브랜치에 스테이징된다.

하나의 커밋으로 정리한다.

```
git commit -m "feat: JWT 인증 기능 구현 (#43)"
```

실제 커밋:

```
59f770b feat: JWT 인증 기능 구현 (#43)
```

이 커밋은 Merge Commit이 아닌 일반 커밋이다.

#### 6-4. Squash Commit 취소

```
git revert --no-edit HEAD
```

실제 결과:

```
4f9b689 Revert "feat: JWT 인증 기능 구현 (#43)"
59f770b feat: JWT 인증 기능 구현 (#43)
```

Squash로 병합된 전체 변경이 취소된다.

#### 6-5. Revert of Revert

취소한 JWT 인증 기능을 다시 적용한다.

```
git revert --no-edit HEAD
```

실제 결과:

```
30494bf Revert "Revert "feat: JWT 인증 기능 구현 (#43)""
4f9b689 Revert "feat: JWT 인증 기능 구현 (#43)"
59f770b feat: JWT 인증 기능 구현 (#43)
```

확인:

```
git ls-files jym/practice/revert/squash
```

복구된 파일:

```
auth-test.md
jwt.md
refresh.md
```

**학습 결과**

- Squash Commit도 일반 커밋처럼 revert할 수 있다.
    
- Revert Commit을 다시 revert하면 취소했던 변경을 재적용할 수 있다.
    
- 기존 커밋과 취소 이력이 모두 보존된다.
    

### 7. Merge Revert 이후 재병합 확인

**상황**

5단계에서 이미 병합한 Redis 기능을 revert한 상태이다.

이때 원래 Feature 브랜치를 다시 병합하면 변경이 복구되는지 확인한다.

#### 7-1. 별도 실습 브랜치 생성

```
git switch -c lab/revert-merge-reapply lab/revert-merge
```

#### 7-2. 기존 Feature 브랜치 재병합

```
git merge lab/revert-feature-cache
```

실제 결과:

```
Already up to date.
```

**원인**

Merge Commit을 revert하더라도 Git의 커밋 조상 관계에서는 기존 Feature 브랜치의 커밋들이 이미 병합된 상태이기 때문이다.

따라서 같은 Feature 브랜치를 단순히 다시 병합한다고 해서 취소했던 변경이 복구되지 않는다.

#### 7-3. Revert of Revert로 복구

```
git revert --no-edit 4faba62
```

실제 결과:

```
cc6b2cb Revert "Revert "Merge PR #42: Redis 캐시 기능""
```

이 명령어로 이전에 취소한 Redis 기능의 변경을 다시 적용한다.

### 최종 실습 결과

**생성한 브랜치**

```
lab/revert-basic
lab/revert-merge
lab/revert-feature-cache
lab/revert-squash
lab/revert-squash-feature
lab/revert-merge-reapply
```

**주요 실습 커밋**

|커밋 해시|실습 내용|
|---|---|
|`16fab9c`|직전 Redis 캐시 커밋 취소|
|`5eeaf48`|과거 로그인 커밋 취소|
|`d494bbb`|충돌 해결 후 Revert|
|`e1db13d`|Redis 기능 3개 커밋 일괄 취소|
|`6ebd2df`|PR #42 Merge Commit 생성|
|`4faba62`|Merge Commit Revert|
|`59f770b`|PR #43 Squash Commit 생성|
|`4f9b689`|Squash Commit Revert|
|`30494bf`|Squash Revert of Revert|
|`cc6b2cb`|Merge Revert of Revert|

**핵심 학습 내용**

1. Revert는 기존 커밋을 삭제하지 않고 취소 커밋을 추가한다.
    
2. 과거 커밋을 되돌릴 때 후속 커밋이 반드시 사라지는 것은 아니다.
    
3. 변경이 겹쳐 충돌이 발생한다면 개발자가 직접 해결해야 한다.
    
4. 여러 커밋의 변경을 하나의 Revert Commit으로 정리할 수 있다.
    
5. Merge Commit을 기준으로 PR 전체의 변경을 취소할 수 있다.
    
6. Squash Commit은 일반 커밋처럼 취소할 수 있다.
    
7. Merge Commit을 revert하더라도 병합 이력은 유지된다.
    
8. Revert of Revert로 취소했던 변경을 재적용할 수 있다.
    

---

## ✏️ 메모

### 실습 후 브랜치 정리

이번 실습은 기존 `feature/jym-git-play` 브랜치에서 분기하여 진행했기 때문에 원래 브랜치의 커밋 이력에는 영향을 주지 않았다.

실습 브랜치를 보존하면 나중에 Git 히스토리를 다시 살펴볼 수 있다.

**실습 결과 확인**

```
git branch -v

git log --oneline --graph --all --decorate
```

**기존 브랜치 복귀**

```
git switch feature/jym-git-play
```

**실습 브랜치 삭제가 필요하다면**

```
git branch -D lab/revert-basic
git branch -D lab/revert-merge
git branch -D lab/revert-feature-cache
git branch -D lab/revert-squash
git branch -D lab/revert-squash-feature
git branch -D lab/revert-merge-reapply
```

`-D`는 병합되지 않은 브랜치도 강제로 삭제하므로, 실습 기록을 더 이상 유지할 필요가 없을 때만 사용한다.

커밋이 다른 브랜치에서 참조되지 않는다면 이후 Git의 가비지 컬렉션 과정에서 제거될 수 있다.

### 실무 적용 시 주의사항

- Revert 전에 반드시 대상 커밋의 변경 범위를 확인한다.
    
- Merge Commit의 부모 관계를 확인한 후 `-m` 옵션을 사용한다.
    
- 충돌이 없더라도 테스트를 통해 기능 정상 여부를 검증한다.
    
- 여러 커밋을 일괄 취소할 때는 의존 관계를 확인한다.
    
- 공유 브랜치에서는 팀의 PR 및 브랜치 보호 정책을 따른다.
    
- 실제 운영 장애에서는 Git Revert와 배포 롤백을 구분한다.
    

---

## 📚 참고 및 링크

- [[]]
---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]