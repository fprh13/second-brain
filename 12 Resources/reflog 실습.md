---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# reflog 실습

---

## 📄 본문

### 실습 개요

**목적:** Git 작업 중 실수로 삭제하거나 누락한 커밋 및 브랜치를 `git reflog`를 이용해 복구하는 방법 학습.

실습 시나리오:

1. `reset --hard`로 사라진 커밋 복구
    
2. Interactive Rebase에서 삭제한 커밋 복구
    
3. 강제 삭제한 브랜치 복구
    
4. 복구 후 불필요한 실습 브랜치 정리
    

### 실습 환경

**저장소**

```
~/Desktop/Repository/chanmu-dev-lab-playground
```

**기존 디렉터리**

```
jym/
└── practice/
    ├── cherry-pick/
    ├── rebase/
    ├── reflog/
    └── worktree/
```

**실습 브랜치**

```
feature/jym-git-play  (기존 작업 브랜치)
lab/reflog-reset
lab/reflog-rebase
lab/reflog-delete
```

기존 작업을 보호하기 위해 실습 전용 브랜치를 만들어 작업한다.

---

### 실습 1. reset --hard로 사라진 커밋 복구

**시나리오:** 로그인, JWT 인증, Refresh Token 기능을 순서대로 구현했으나 `git reset --hard`를 잘못 실행하여 마지막 커밋이 사라진 상황.

#### Step 1. 실습 브랜치 생성

```
git status
git switch -c lab/reflog-reset
mkdir -p jym/practice/reflog
```

#### Step 2. 커밋 생성

```
echo "# 로그인 기능" > jym/practice/reflog/reset.md
git add jym/practice/reflog/reset.md
git commit -m "feat: 로그인 기능 구현"
```

```
echo "JWT 인증 기능" >> jym/practice/reflog/reset.md
git add jym/practice/reflog/reset.md
git commit -m "feat: JWT 인증 기능 구현"
```

```
echo "Refresh Token 기능" >> jym/practice/reflog/reset.md
git add jym/practice/reflog/reset.md
git commit -m "feat: Refresh Token 기능 구현"
```

확인:

```
git log --oneline -4
```

커밋 구조:

```
A (로그인) → B (JWT 인증) → C (Refresh Token)
                              ↑
                             HEAD
```

#### Step 3. 의도적으로 마지막 커밋 제거

```
git reset --hard HEAD~1
```

```
git log --oneline -4
cat jym/practice/reflog/reset.md
```

Refresh Token 커밋과 해당 내용이 현재 브랜치에서 사라진 것을 확인한다.

#### Step 4. reflog에서 커밋 찾기

```
git reflog -5
```

예시:

```
a222222 HEAD@{0}: reset: moving to HEAD~1
b333333 HEAD@{1}: commit: feat: Refresh Token 기능 구현
a222222 HEAD@{2}: commit: feat: JWT 인증 기능 구현
```

`HEAD@{1}`이 reset 직전 커밋을 가리킨다.

#### Step 5. 복구 브랜치 생성

```
git branch rescue/reflog-reset 'HEAD@{1}'
```

참고: 위 명령어는 reset 직후의 reflog 구조가 예시와 일치할 때 사용한다. 실제로는 커밋 해시를 먼저 확인하고 지정하는 것이 안전하다.

#### Step 6. 원래 브랜치 복구

```
git merge --ff-only rescue/reflog-reset
```

이번 실습에서는 원래 브랜치가 복구 커밋의 조상이므로 Fast-forward 병합이 가능하다.

검증:

```
git log --oneline -4
cat jym/practice/reflog/reset.md
```

**결과:** reset으로 사라진 커밋과 파일 변경사항 복구.

**배운 점:** reflog로 이전 커밋을 찾고 복구 브랜치를 생성하면 기존 커밋을 안전하게 되살릴 수 있다.

---

### 실습 2. Interactive Rebase에서 삭제한 커밋 복구

**시나리오:** 커밋 이력을 정리하는 과정에서 Security 필터 구현 커밋을 잘못 제거한 상황.

#### Step 1. 브랜치 생성

```
git switch -c lab/reflog-rebase
```

#### Step 2. 두 개의 커밋 생성

```
echo "# Controller 구현" > jym/practice/reflog/rebase-controller.md
git add .
git commit -m "feat: Controller 구현"
```

```
echo "# Security 필터 구현" > jym/practice/reflog/rebase-security.md
git add .
git commit -m "feat: Security 필터 구현"
```

#### Step 3. Interactive Rebase 실행

```
GIT_SEQUENCE_EDITOR=nano git rebase -i HEAD~2
```

변경 전:

```
pick a111111 feat: Controller 구현
pick b222222 feat: Security 필터 구현
```

변경 후:

```
pick a111111 feat: Controller 구현
drop b222222 feat: Security 필터 구현
```

저장 후 종료한다.

#### Step 4. 삭제 확인

```
git log --oneline -5
ls jym/practice/reflog/
```

Security 커밋과 `rebase-security.md` 파일이 현재 브랜치 이력에서 사라진다.

#### Step 5. reflog 조회

```
git reflog -20
```

이전 Security 필터 구현 커밋을 찾는다.

```
b222222 HEAD@{...}: commit: feat: Security 필터 구현
```

복구 대상이 올바른지 확인한다.

```
git show b222222
```

`b222222`는 예시이며 실제 커밋 해시를 사용해야 한다.

#### Step 6. cherry-pick으로 복구

```
git cherry-pick <Security-커밋해시>
```

검증:

```
git log --oneline -5
cat jym/practice/reflog/rebase-security.md
```

**결과:** Interactive Rebase에서 누락한 Security 필터 커밋 재적용.

**배운 점:**

- reflog는 rebase 이전 커밋을 찾는 데 유용하다.
    
- 브랜치 전체를 되돌릴 필요 없이 `cherry-pick`으로 필요한 커밋만 복구할 수 있다.
    
- cherry-pick으로 생성된 새 커밋은 원래 커밋과 해시가 달라질 수 있다.
    

---

### 실습 3. 삭제한 브랜치 복구

**시나리오:** 결제 기능을 개발한 브랜치를 실수로 강제 삭제한 상황.

#### Step 1. 기능 브랜치 생성

```
git switch -c lab/reflog-delete
```

#### Step 2. 결제 기능 커밋

```
echo "# 결제 기능 구현" > jym/practice/reflog/branch-payment.md

git add .
git commit -m "feat: 결제 기능 구현"
```

#### Step 3. 브랜치 강제 삭제

```
git switch lab/reflog-rebase
git branch -D lab/reflog-delete
```

확인:

```
git branch
```

`lab/reflog-delete`가 삭제된 것을 확인한다.

#### Step 4. reflog에서 삭제한 커밋 탐색

```
git reflog --all --oneline -20
```

결제 기능 구현 커밋을 찾는다.

브랜치를 삭제하면 해당 브랜치 자체의 reflog는 제거될 수 있다. 하지만 브랜치에서 작업하며 HEAD가 해당 커밋을 가리킨 기록이 있다면 HEAD reflog에서 찾을 수 있다.

#### Step 5. 브랜치 복구

```
git branch lab/reflog-delete <결제-커밋해시>
git switch lab/reflog-delete
```

검증:

```
git log -1 --oneline
cat jym/practice/reflog/branch-payment.md
```

**결과:** 삭제된 브랜치를 기존 커밋 위치에 재생성.

**배운 점:** 브랜치를 삭제해도 커밋 객체가 즉시 삭제되는 것은 아니다. 기존 커밋 해시를 찾을 수 있다면 브랜치를 다시 생성할 수 있다.

---

### 추가 실습. 실제 삭제한 브랜치 복구

기존 `feature/jym-git-play` 브랜치에서 실습을 종료한 후 실습용 브랜치들을 직접 삭제했다.

#### 실제 실행 기록

```
git branch -D lab/reflog-delete
```

```
Deleted branch lab/reflog-delete (was ef4dc24).
```

```
git branch -D lab/reflog-rebase
```

```
Deleted branch lab/reflog-rebase (was 75085a3).
```

```
git branch -D lab/reflog-reset
```

```
Deleted branch lab/reflog-reset (was 4d3b063).
```

삭제 당시 커밋:

|브랜치|커밋 해시|
|---|---|
|`lab/reflog-delete`|`ef4dc24`|
|`lab/reflog-rebase`|`75085a3`|
|`lab/reflog-reset`|`4d3b063`|

#### Step 1. reflog 조회

```
git reflog --all --oneline -30
```

삭제 전 커밋 기록을 찾는다.

해시를 이미 알고 있으므로 다음 명령어로 직접 확인할 수도 있다.

```
git show --stat ef4dc24
```

#### Step 2. 삭제한 브랜치 복구

```
git branch lab/reflog-delete ef4dc24
```

```
git switch lab/reflog-delete
```

#### Step 3. 복구 검증

```
git log -1 --oneline
```

`ef4dc24`가 HEAD인지 확인한다.

```
cat jym/practice/reflog/branch-payment.md
```

파일과 결제 기능 내용이 존재하는지 확인한다.

#### Step 4. 복구한 브랜치 다시 정리

```
git switch feature/jym-git-play
git branch -D lab/reflog-delete
```

이렇게 하면 복구 실습을 마친 뒤 불필요한 브랜치를 다시 정리할 수 있다.

---

### 실습 결과 정리

|실습|사고 원인|복구 방법|
|---|---|---|
|1|잘못된 `reset --hard`|`reflog` → 복구 브랜치 → `merge`|
|2|`rebase -i`에서 커밋 drop|`reflog` → `cherry-pick`|
|3|`branch -D`로 브랜치 삭제|`reflog` → `branch`|
|추가|실습 브랜치 정리 중 삭제|커밋 확인 → 브랜치 재생성|

### 실무 사고 발생 시 복구 절차

```
# 1. 현재 상태 확인
git status

# 2. 과거 참조 기록 확인
git reflog --all --oneline -30

# 3. 복구 대상 커밋 확인
git show <hash>

# 4. 안전한 복구 브랜치 생성
git branch recovery/<name> <hash>

# 5. 상황에 맞는 복구 작업 선택
# git merge --ff-only recovery/<name>
# git cherry-pick <hash>
# git switch recovery/<name>

# 6. 결과 검증
git log --oneline -10
git status
```

`git reset --hard <hash>`도 복구에 사용할 수 있지만, 현재 브랜치의 이력을 변경하고 추적 파일의 미커밋 변경사항을 버릴 수 있으므로 신중하게 선택한다.

---

## ✏️ 메모

### 기억할 핵심

- `git reflog`는 실수로 사라진 커밋을 추적할 때 사용한다.
    
- `git branch -D`는 브랜치 참조를 삭제하지만 커밋 객체를 즉시 삭제하지는 않는다.
    
- 삭제한 브랜치의 reflog는 사라질 수 있지만 HEAD reflog에 기록이 남아 있을 수 있다.
    
- `HEAD@{n}`은 고정된 커밋이 아니므로 복구 작업에서는 커밋 해시를 사용하는 것이 안전하다.
    
- 이미 공유된 브랜치의 이력을 복구할 때는 협업 중인 개발자에게 미칠 영향도 고려한다.
    
- reflog는 영구 보관되지 않으므로 복구가 필요하다면 오래 방치하지 않는다.
    

### 추가 확인 사항

실습 후 다음 상태를 확인했다.

```
On branch feature/jym-git-play

Your branch is ahead of
'origin/feature/jym-git-play' by 11 commits.

nothing to commit, working tree clean
```

이는 현재 로컬 브랜치에 원격 브랜치보다 11개의 커밋이 더 있다는 의미이다.

실습 브랜치를 삭제했다는 사실과는 별개이며, 브랜치 삭제만으로 커밋 11개가 생성되거나 삭제되는 것은 아니다.

확인 명령어:

```
git log --oneline origin/feature/jym-git-play..HEAD
```

불필요한 커밋을 정리할 필요가 있다면 우선 이력을 분석한 후 `rebase`, `reset` 등 적절한 방법을 검토한다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]