---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# revert

---

## 📄 본문

### 개념

`git revert`는 **특정 커밋에서 발생한 변경 사항을 반대로 적용하는 새로운 커밋을 생성하는 명령어**이다.

기존 커밋을 삭제하거나 히스토리를 변경하지 않고, 변경 사항을 취소한 새로운 커밋을 추가한다.

따라서 이미 원격 저장소에 공유된 커밋이나 `main`, `develop` 브랜치에 병합된 변경을 취소할 때 유용하다.

**특징**

- 기존 커밋 이력을 삭제하지 않는다.
    
- 변경을 취소하는 새로운 커밋이 생성된다.
    
- 직전 커밋뿐만 아니라 과거 특정 커밋도 취소할 수 있다.
    
- Merge Commit이나 Squash Commit도 되돌릴 수 있다.
    
- 후속 커밋과 의존 관계가 있다면 충돌이나 기능 문제가 발생할 수 있다.
    

**동작 예시**

```
A ── B ── C ── D (HEAD)
     ↑
   취소 대상

git revert B

A ── B ── C ── D ── E (HEAD)
                    ↑
                Revert B
```

B 커밋을 삭제하는 것이 아니라 현재 D까지 반영된 코드에 B가 도입했던 변경을 반대로 적용하여 E 커밋을 생성한다.

### 기본 명령어

|명령어|설명|
|---|---|
|`git revert HEAD`|가장 최근 커밋 취소|
|`git revert <hash>`|특정 커밋 취소|
|`git revert --no-edit HEAD`|편집기 없이 기본 메시지로 revert|
|`git revert --no-commit <hash>`|커밋을 생성하지 않고 변경만 적용|
|`git revert --abort`|진행 중인 revert 취소|
|`git revert --continue`|충돌 해결 후 revert 계속|
|`git revert --skip`|진행 중인 대상 커밋 건너뛰기|
|`git revert -m 1 <hash>`|Merge Commit을 첫 번째 부모 기준으로 취소|

**일반적인 사용법**

```
# 커밋 이력 조회
git log --oneline

# 특정 커밋의 변경 사항 확인
git show <hash>

# 대상 커밋 취소
git revert <hash>

# 결과 확인
git log --oneline -5
git show --stat HEAD
git status
```

### 직전 커밋과 과거 커밋 되돌리기

#### 직전 커밋

```
git revert HEAD
```

현재 HEAD의 변경을 되돌리는 새로운 커밋이 생성된다.

#### 과거 특정 커밋

```
git revert <hash>
```

대상 커밋 이후에 다른 커밋이 존재하더라도 실행할 수 있다.

다만 후속 커밋이 대상 커밋의 변경을 수정하거나 의존하고 있다면 충돌 또는 기능 문제가 발생할 수 있다.

**중요한 점**

- 후속 커밋이 많다는 사실 자체는 문제가 아니다.
    
- Git은 코드의 비즈니스 의존 관계까지 분석하지 않는다.
    
- 충돌이 발생하지 않더라도 애플리케이션이 정상 동작한다는 보장은 없다.
    

### 여러 커밋을 하나의 커밋으로 Revert

여러 커밋에 걸쳐 개발한 기능 전체를 취소하고 싶은 경우 사용한다.

```
# 최신 커밋부터 역순으로 취소
git revert --no-commit HEAD HEAD~1 HEAD~2

# 적용된 변경 확인
git status
git diff --cached

# 하나의 커밋으로 정리
git commit -m "revert: Redis 캐시 기능 전체 취소"
```

`--no-commit`을 사용하면 자동으로 커밋하지 않고 취소 변경을 인덱스와 작업 트리에 적용한다.

이후 직접 커밋하여 여러 변경을 하나의 취소 커밋으로 정리할 수 있다.

**주의사항**

- 위 예시는 연속된 커밋 3개를 취소하는 상황이다.
    
- 커밋이 연속적이지 않다면 취소 대상을 개별적으로 확인해야 한다.
    
- 취소 순서와 변경의 의존 관계에 따라 충돌이 발생할 수 있다.
    

### 충돌 발생 시 대응

특정 커밋을 revert할 때 후속 커밋에서 동일한 코드를 수정했다면 충돌이 발생할 수 있다.

```
git revert <hash>
```

충돌 발생 시 두 가지 대응 방법이 있다.

#### 방법 1. 충돌 해결 후 계속 진행

```
# 충돌 상태 확인
git status
git diff

# 충돌 파일을 직접 수정

# 해결한 파일 등록
git add <file>

# Revert 계속 진행
git revert --continue
```

충돌 해결 과정에서는 **어떤 변경을 취소하고 어떤 후속 변경을 유지할 것인지** 직접 판단해야 한다.

#### 방법 2. Revert 중단

```
git revert --abort
```

진행 중인 revert 작업을 취소하고 시작 전 상태로 복구한다.

충돌이 복잡하거나 다른 기능에 영향을 미칠 위험이 크다면 `--abort`한 후 직접 수정하는 방법을 검토한다.

단, `--abort`는 revert가 진행 중일 때 사용하는 명령어이며 이미 완료된 revert 커밋을 취소하는 명령어는 아니다.

### Merge Commit Revert

GitHub에서 `Create a merge commit` 방식으로 PR을 병합하면 개별 커밋과 Merge Commit이 히스토리에 남는다.

```
             B ── C ── D (feature)
            /           \
main   A ── E ────────── M ── F
                         ↑
                    Merge PR #42
```

이때 PR의 변경 전체를 되돌리려면 Merge Commit을 revert할 수 있다.

```
git revert -m 1 <merge-commit-hash>
```

`**-m 1**`**의 의미**

- `-m` : mainline parent 지정
    
- `1` : 첫 번째 부모를 기준으로 변경을 취소
    
- 일반적인 GitHub PR 병합에서는 첫 번째 부모가 병합 대상 브랜치이다.
    

부모 관계 확인:

```
git show -s --format="%h %p %s" <merge-hash>
```

**결과**

```
             B ── C ── D
            /           \
main   A ── E ────────── M ── F ── R
                                   ↑
                              Revert M
```

- B, C, D의 개별 커밋은 유지된다.
    
- Merge Commit M도 유지된다.
    
- R은 M이 첫 번째 부모 기준으로 도입한 변경을 취소한다.
    
- 병합 이후의 F 커밋은 유지하려고 시도한다.
    

단, F가 해당 기능에 의존한다면 충돌이나 기능 문제가 발생할 수 있다.

### Squash Merge Revert

`Squash and merge`는 PR의 여러 커밋을 하나의 일반 커밋으로 합쳐 병합하는 방식이다.

```
feature: B ── C ── D

main: A ── S ── F
           ↑
      Squash Commit
```

S는 일반 커밋이므로 다음과 같이 되돌린다.

```
git revert <squash-commit-hash>
```

Merge Commit이 아니기 때문에 `-m 1` 옵션은 필요하지 않다.

### 병합 방식에 따른 Revert 비교

|병합 방식|히스토리|전체 취소 방법|
|---|---|---|
|Merge Commit|개별 커밋 + 병합 커밋|`git revert -m 1 <hash>`|
|Squash Merge|하나의 일반 커밋|`git revert <hash>`|
|Rebase and Merge|개별 커밋이 선형으로 추가|관련 커밋들을 확인하여 revert|

**실무 관점**

PR 전체를 되돌리는 경우에는 Merge Commit과 Squash Merge가 비교적 명확한 취소 지점을 제공한다.

단, PR 병합 이후에 변경된 코드와의 의존 관계는 별도로 확인해야 한다.

### Revert of Revert

한 번 취소한 변경을 다시 적용해야 한다면 Revert Commit 자체를 revert할 수 있다.

```
A ── B ── R ── RR
     │    │     │
     │    │     └── 취소했던 변경 재적용
     │    └──────── B의 변경 취소
     └───────────── 최초 기능 구현
```

```
git revert <revert-commit-hash>
```

**주의할 점**

Merge Commit을 revert하더라도 Git은 기존 병합 이력을 기억한다.

```
git merge feature/cache
```

이미 해당 브랜치의 커밋들이 병합되어 있다면 다음과 같은 결과가 발생할 수 있다.

```
Already up to date.
```

이는 Git의 조상 관계상 이미 병합된 커밋이기 때문이다.

따라서 취소한 기능을 다시 적용하려면 `Revert of Revert` 또는 새로운 수정 커밋을 검토한다.

### reset, restore, revert 비교

|명령어|주요 목적|기존 커밋 이력|
|---|---|---|
|`restore`|작업 파일 또는 스테이징 상태 복원|유지|
|`reset`|HEAD 이동 또는 인덱스 재설정|이동·변경 가능|
|`revert`|기존 커밋 변경 취소|유지 + 새 커밋|

**일반적인 판단 기준**

- 커밋하지 않은 작업을 취소 → `restore`
    
- 로컬에서만 작성한 커밋을 정리 → `reset`
    
- 이미 공유된 커밋을 취소 → `revert`
    

공유된 브랜치에서 `reset`과 강제 푸시로 히스토리를 변경하는 것은 협업자에게 영향을 줄 수 있으므로 주의한다.

### 백엔드 실무 시나리오

#### 1. JPA 쿼리 최적화 이후 성능 저하

조회 API의 Querydsl 최적화를 적용했지만 일부 검색 조건에서 성능이 악화된 경우.

- 문제 커밋 확인
    
- 후속 커밋의 의존성 확인
    
- 독립적 변경이라면 revert
    
- 쿼리 실행 계획 및 성능 재검증
    

#### 2. Redis 캐시 도입 이후 장애

캐시 직렬화 오류, TTL 정책 문제 등이 발생한 경우.

- Redis 관련 변경 범위 분석
    
- 관련 PR 또는 커밋 revert 검토
    
- 캐시를 사용하는 후속 코드 확인
    
- 테스트 후 배포
    

#### 3. PR 병합 후 인증 기능 오류

신규 인증 기능이 병합된 후 로그인 장애가 발생한 경우.

- PR 병합 방식 확인
    
- Merge Commit 또는 Squash Commit 확인
    
- 해당 변경 전체 revert 검토
    
- CI 테스트 및 배포 검증
    

### 실무에서의 판단 기준

|상황|대응|
|---|---|
|직전 커밋의 독립적인 버그|단일 revert|
|과거 독립적인 커밋의 버그|특정 커밋 revert|
|특정 PR 전체의 문제|PR 단위 revert|
|여러 커밋이 하나의 기능에 속함|관련 커밋 일괄 revert 검토|
|충돌이 단순하고 해결 가능|충돌 해결 후 continue|
|의존 관계가 복잡함|abort 후 직접 수정 검토|
|운영 환경에서 심각한 장애 발생|배포 롤백, 기능 비활성화, revert 중 적절한 방법 선택|

**실무에서는 보호 브랜치에 직접 반영하는 대신 Revert PR을 작성하는 방식도 사용한다.**

```
git switch main
git pull --ff-only origin main

git switch -c revert/redis-cache

git revert <hash>

# 테스트 및 검증
git push -u origin revert/redis-cache
```

이후 PR을 생성하여 CI 검증 및 리뷰를 거쳐 병합한다.

**주의: Git Revert와 배포 롤백은 다르다.**

`git revert`는 소스코드의 변경을 취소하는 Git 작업이고, 배포 롤백은 실제 실행 중인 애플리케이션을 이전 배포 버전으로 복구하는 작업이다.

따라서 Git에서 revert했다고 운영 서버가 즉시 이전 상태로 돌아가는 것은 아니다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]
- [[../12 Resources/revert 실습|revert 실습]]