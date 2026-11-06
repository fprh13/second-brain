---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# stash 실습

---

## 📄 본문

### 실습 목표

백엔드 개발 중 긴급 버그 수정 요청이 발생했을 때 Git Stash를 활용하여 기존 작업을 보관하고, 다른 브랜치에서 수정한 뒤 원래 작업을 재개하는 흐름을 실습한다.

**학습할 내용**

1. 미완성 작업을 Stash에 보관하기
    
2. 다른 브랜치로 이동해 긴급 Hotfix 처리하기
    
3. 원래 브랜치로 복귀하기
    
4. Stash를 복원하고 개발 이어가기
    
5. Untracked 파일의 동작 확인하기
    
6. Stash 목록 확인 및 정리하기
    

### 실습 시나리오

**상황:** 카우머치 프로젝트에서 JWT 로그인 API를 개발하고 있다.

그런데 Slack을 통해 긴급 요청이 들어왔다.

> 운영 서버에서 견적 조회 API가 500 오류를 반환하고 있습니다. 긴급 수정 부탁드립니다.

현재 로그인 개발 코드는 미완성이므로 커밋하고 싶지 않다.

따라서 다음 순서로 진행한다.

```
로그인 API 개발
    ↓
긴급 오류 발생
    ↓
로그인 개발 내용 Stash
    ↓
Hotfix 브랜치 이동
    ↓
견적 조회 오류 수정 및 커밋
    ↓
로그인 브랜치 복귀
    ↓
Stash 복원
    ↓
로그인 API 개발 재개
```

### STEP 1. 실습 환경 준비

기존 저장소:

```
chanmu-dev-lab-playground/
├── README.md
├── common/
│   └── conflict.json
└── jym/
    └── practice/
        ├── cherry-pick/
        ├── rebase/
        ├── worktree/
        └── stash/         ← 새로 생성
            ├── login.md
            └── estimate.md
```

기존 브랜치에서 상태 확인:

```
git switch feature/jym-git-play

git status
git stash list
```

기존 변경사항이 없는 깨끗한 상태에서 시작한다.

실습용 기준 브랜치를 생성한다.

```
git switch -c lab/stash-base
```

실습 디렉터리와 파일 생성:

```
mkdir -p jym/practice/stash

echo "# 로그인 API v1" > jym/practice/stash/login.md
echo "# 견적 조회 API v1" > jym/practice/stash/estimate.md
```

초기 상태 커밋:

```
git add jym/practice/stash/

git commit -m "test: stash 실습 초기 파일 생성"
```

`lab/stash-base`는 실제 `main` 대신 사용하는 실습용 기준 브랜치다.

### STEP 2. 로그인 기능 개발 시작

로그인 기능 개발 브랜치 생성:

```
git switch -c lab/stash-login
```

기존 로그인 파일 수정:

```
echo "JWT 로그인 인증 로직 구현 중" >> jym/practice/stash/login.md
```

새로운 파일도 생성한다.

```
echo "# JWT 토큰 발급 기능" > jym/practice/stash/jwt.md
```

현재 상태 확인:

```
git status
```

예상 결과:

```
Changes not staged for commit:
    modified: jym/practice/stash/login.md

Untracked files:
    jym/practice/stash/jwt.md
```

- `login.md`: 기존에 추적하던 파일을 수정
    
- `jwt.md`: 새로 생성하여 아직 추적하지 않는 파일
    

아직 개발 중이므로 커밋하지 않는다.

### STEP 3. 긴급 Hotfix 발생 — Stash 보관

운영 서버에서 견적 조회 API 오류가 발생했다.

로그인 코드를 임시 보관한다.

```
git stash push -u -m "로그인 API 개발 중" -- jym/practice/stash/
```

명령어 분석:

|옵션|의미|
|---|---|
|`push`|현재 변경사항을 Stash에 저장|
|`-u`|Untracked 파일까지 저장|
|`-m`|Stash 설명 작성|
|`-- jym/practice/stash/`|해당 경로의 변경사항으로 보관 범위 제한|

보관 상태 확인:

```
git status

git stash list

cat jym/practice/stash/login.md
```

예상 결과:

- `login.md`가 기존 커밋 상태로 돌아감
    
- `jwt.md`가 작업 디렉터리에서 사라짐
    
- 변경사항은 Stash 내부에 보관됨
    

**핵심:** 기존 로그인 작업을 잃어버리지 않으면서 다른 브랜치로 이동할 준비가 완료되었다.

### STEP 4. Hotfix 브랜치 생성 및 오류 수정

실제 프로젝트라면 `main`에서 긴급 수정 브랜치를 생성할 수 있다.

이번에는 실제 `main`을 건드리지 않기 위해 `lab/stash-base`를 사용한다.

```
git switch lab/stash-base

git switch -c lab/stash-hotfix
```

현재 브랜치:

```
lab/stash-hotfix
```

견적 조회 API 오류를 수정했다고 가정한다.

```
echo "견적 조회 NullPointerException 방어 로직 추가" >> jym/practice/stash/estimate.md
```

변경사항 확인:

```
git diff
git status
```

긴급 수정 내용 커밋:

```
git add jym/practice/stash/estimate.md

git commit -m "fix: 견적 조회 예외 처리"
```

이제 긴급 수정 내용은 `lab/stash-hotfix` 브랜치에 커밋되었다.

실제 협업이라면 테스트 후 원격 저장소에 Push하고 PR을 생성하는 단계가 이어진다.

### STEP 5. 기존 로그인 개발 브랜치 복귀

긴급 수정 작업을 완료했으므로 원래 브랜치로 돌아간다.

```
git switch lab/stash-login
```

현재 상태 확인:

```
git status

cat jym/practice/stash/login.md
```

아직 Stash를 복원하지 않았기 때문에 `login.md`는 초기 버전이다.

새로 생성했던 `jwt.md`도 보이지 않는다.

### STEP 6. Stash 복원하기

Stash 목록 확인:

```
git stash list
```

예상 결과:

```
stash@{0}: On lab/stash-login: 로그인 API 개발 중
```

실습에서 생성한 Stash가 맞는지 확인한 후 복원한다.

```
git stash pop 'stash@{0}'
```

복원 결과 확인:

```
git status

git diff

cat jym/practice/stash/login.md

cat jym/practice/stash/jwt.md
```

예상 결과:

- `login.md`에 JWT 로그인 인증 로직 내용이 다시 나타남
    
- `jwt.md`가 다시 생성됨
    
- 기존에 수정하던 작업 상태가 복원됨
    
- 정상적으로 복원되었다면 해당 Stash는 목록에서 제거됨
    

**핵심:** 긴급 Hotfix 작업을 완료한 뒤 원래 개발하던 미완성 코드로 돌아왔다.

### STEP 7. Stash 복원 후 개발 마무리

이제 로그인 개발을 완료했다고 가정한다.

```
echo "JWT 인증 기능 구현 완료" >> jym/practice/stash/login.md
```

로그인 기능 커밋:

```
git add jym/practice/stash/

git commit -m "feat: JWT 로그인 기능 구현"
```

확인:

```
git status

git log --oneline -5

git stash list
```

브랜치별 작업 결과:

```
lab/stash-base
    │
    ├── lab/stash-login
    │       └── feat: JWT 로그인 기능 구현
    │
    └── lab/stash-hotfix
            └── fix: 견적 조회 예외 처리
```

각 작업이 서로 다른 브랜치에 커밋되었다.

Stash는 이 과정에서 미완성 코드를 임시 보관하는 역할만 수행했다.

Hotfix의 수정사항은 아직 로그인 브랜치에 병합되지 않았으며, 실무에서는 별도의 PR·병합 과정이 필요하다.

---

### 추가 실습 1. pop과 apply 차이

기존 파일에 새 변경사항을 만든다.

```
echo "추가 로그인 검증 구현" >> jym/practice/stash/login.md
```

Stash 저장:

```
git stash push -m "추가 검증 로직"
```

`apply`로 복원:

```
git stash apply 'stash@{0}'
```

확인:

```
git diff

git stash list
```

변경사항은 복원되지만 Stash는 남아 있다.

실습에서 생성한 Stash가 맞는지 확인한 후 삭제:

```
git stash drop 'stash@{0}'
```

### 추가 실습 2. 특정 파일만 Stash

두 개의 파일을 수정한다.

```
echo "로그인 API 변경" >> jym/practice/stash/login.md

echo "견적 API 변경" >> jym/practice/stash/estimate.md
```

`login.md`만 보관한다.

```
git stash push -m "로그인 작업 보관" -- jym/practice/stash/login.md
```

변경사항 확인:

```
git status
git diff
```

예상 결과:

- `login.md`: 변경사항 보관됨
    
- `estimate.md`: 변경사항 유지됨
    

복원:

```
git stash pop
```

기존에 수정한 `login.md`의 변경사항이 복원된다.

---

## ✏️ 메모

### 이번 실습의 핵심

Stash는 단순한 파일 임시 저장 기능이 아니라, **현재 업무를 중단하고 다른 업무를 수행하기 위한 작업 전환 수단**이다.

```
기존 업무
→ stash
→ 긴급 업무
→ 기존 업무 복귀
→ pop
```

### 주의사항

- `git stash`만 사용하면 Untracked 파일은 보관되지 않는다.
    
- `git stash -u`는 Untracked 파일까지 포함한다.
    
- Stash는 브랜치별로 독립 관리되지 않는다.
    
- 다른 브랜치에서도 Stash를 적용할 수 있다.
    
- Stash 복원 시 충돌이 발생할 수 있다.
    
- `git stash clear`는 다른 브랜치에서 생성한 Stash까지 모두 삭제한다.
    
- 실습용으로 생성한 브랜치는 원본 브랜치와 독립적으로 유지된다.
    

### 실습 종료 후 정리

```
# 현재 브랜치와 변경사항 확인
git branch --show-current
git status

# Stash 목록 확인
git stash list

# 기존 브랜치 복귀
git switch feature/jym-git-play
```

추가 실습에서 만든 미커밋 변경사항이 남아 있다면 먼저 정리해야 한다.

실습 브랜치를 보존하면 나중에 Git 이력과 파일 구조를 다시 확인할 수 있다.

### 실무 판단 기준

**Q. 언제 Stash를 사용하는가?**

현재 개발 중인 코드를 커밋하고 싶지 않은데, 잠시 다른 브랜치에서 작업해야 할 때 사용한다.

**Q. 무조건 Stash를 사용해야 하는가?**

아니다. 별도 Worktree를 생성하여 독립적으로 작업할 수도 있다.

**Q. Stash를 깊게 학습해야 하는가?**

일반적인 백엔드 협업에서는 `push`, `list`, `pop`, `apply`를 이해하면 대부분의 상황에 대응할 수 있다.

추가적으로 충돌 해결 방법을 익히면 좋다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../01 Permanent/stash|stash]]