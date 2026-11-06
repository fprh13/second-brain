---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# stash

---

## 📄 본문

### Git Stash란?

**Git Stash는 커밋하지 않은 변경사항을 임시로 보관하고, 작업 디렉터리를 정리하는 Git 기능이다.**

주로 현재 개발 중인 작업을 잠시 중단하고 다른 브랜치에서 작업해야 할 때 사용한다.

- 미완성 코드를 커밋하지 않고 임시 보관
    
- 다른 브랜치에서 긴급 작업 진행
    
- 기존 브랜치로 돌아와 변경사항 복원
    
- 일부 파일만 선택적으로 보관 가능
    

**핵심:** `작업 중 → stash → 다른 작업 → 기존 브랜치 복귀 → pop`

### 동작 원리

Git Stash는 수정된 파일을 별도의 폴더로 옮기거나 RAM에 캐싱하는 기능이 아니다.

Git 내부의 객체 데이터베이스에 **Commit, Tree, Blob 등의 Git 객체로 변경사항을 기록**한다.

```
Working Directory
    │
    │ git stash push
    ▼
.git/
├── objects/        ← 변경사항을 Git 객체로 보관
└── refs/stash      ← 최신 Stash를 가리키는 참조
    │
    │ git stash pop
    ▼
Working Directory (변경사항 복원)
```

- Stash는 로컬 저장소 단위로 관리된다.
    
- 브랜치별로 독립적인 Stash 저장소가 존재하는 것은 아니다.
    
- 브랜치를 변경해도 Stash는 유지된다.
    
- 컴퓨터를 재부팅해도 저장된 Stash는 유지된다.
    
- GitHub에 Push한다고 Stash가 함께 전송되지는 않는다.
    
- `refs/stash`와 Reflog를 통해 보관 이력을 관리한다.
    

### 주요 명령어

|명령어|설명|
|---|---|
|`git stash`|현재 추적 중인 파일의 변경사항 보관|
|`git stash push -m "메시지"`|설명 메시지와 함께 보관|
|`git stash push -u -m "메시지"`|Untracked 파일까지 보관|
|`git stash list`|Stash 목록 확인|
|`git stash pop`|가장 최근 Stash 복원 후 성공 시 제거|
|`git stash apply`|복원 후에도 Stash 유지|
|`git stash show -p`|저장된 변경사항 확인|
|`git stash drop 'stash@{0}'`|특정 Stash 삭제|
|`git stash clear`|전체 Stash 삭제|
|`git stash push -p`|변경사항의 일부를 선택해 보관|

### Stash 옵션

|옵션|의미|설명|
|---|---|---|
|`-m`|`--message`|보관할 Stash의 설명 작성|
|`-u`|`--include-untracked`|새로 생성한 Untracked 파일까지 보관|
|`-a`|`--all`|Ignored 파일까지 포함|
|`-p`|`--patch`|변경사항을 부분적으로 선택|
|`--staged`|`--staged`|Staging Area의 변경사항만 보관|

#### Tracked와 Untracked

```
feature/login/
├── AuthService.java     ← Tracked (수정됨)
└── JwtService.java      ← Untracked (새 파일)
```

일반적인 Stash:

```
git stash push -m "로그인 개발 중"
```

- `AuthService.java`의 변경사항 보관
    
- `JwtService.java`는 작업 디렉터리에 그대로 유지
    

Untracked 파일까지 보관:

```
git stash push -u -m "로그인 개발 중"
```

- `AuthService.java`의 변경사항 보관
    
- `JwtService.java`도 함께 보관
    

**주의:** `-m`은 메시지 옵션이고 `-u`는 보관 범위 옵션이다. 서로 대체하는 관계가 아니다.

Untracked 파일이 남아 있으면 다른 브랜치로 이동할 때 함께 따라갈 수 있다. 단, 해당 브랜치에 자동 커밋되는 것은 아니다.

### pop과 apply 차이

#### pop

```
git stash pop
```

- Stash의 변경사항을 작업 디렉터리에 복원
    
- 정상적으로 적용되면 해당 Stash를 목록에서 제거
    
- 충돌이 발생하면 Stash가 유지될 수 있음
    

#### apply

```
git stash apply 'stash@{0}'
```

- Stash 변경사항을 작업 디렉터리에 복원
    
- Stash 목록에는 그대로 보관
    
- 백업을 유지하면서 복원하려는 상황에 유용
    

|구분|pop|apply|
|---|---|---|
|변경사항 복원|O|O|
|성공 시 Stash 제거|O|X|
|다른 브랜치에서 적용|가능|가능|
|충돌 가능성|있음|있음|

### 특정 파일만 보관하기

전체 파일이 아니라 특정 파일의 변경사항만 보관할 수 있다.

```
git stash push -m "보안 설정 수정" -- src/main/java/com/example/config/SecurityConfig.java
```

`--` 뒤에는 보관할 파일 경로 또는 Pathspec을 지정한다.

### Stash 목록 및 삭제

```
git stash list
```

예시:

```
stash@{0}: On feature/login: JWT 인증 개발
stash@{1}: On feature/estimate: 견적 API 수정
```

- `stash@{0}`: 가장 최근 Stash
    
- `stash@{1}`: 그 이전 Stash
    
- `On feature/login`: Stash 생성 당시 브랜치 정보
    

특정 Stash 삭제:

```
git stash drop 'stash@{0}'
```

전체 삭제:

```
git stash clear
```

**주의:** `git stash clear`는 특정 브랜치가 아니라 저장소 전체의 Stash를 삭제한다. 삭제 후 복구가 어려울 수 있으므로 주의한다.

---

### 실무 활용 시나리오

#### 1. 긴급 Hotfix 처리

**상황:** 로그인 기능을 개발하던 중 운영 서버의 견적 조회 API에서 오류가 발생했다.

```
feature/login
    │
    ├── 로그인 기능 개발 중 (미커밋)
    │
    ▼
git stash push -u -m "로그인 개발 중"
    │
    ▼
main으로 이동
    │
    ▼
hotfix/estimate-error 생성
    │
    ▼
오류 수정 → 테스트 → 커밋 → PR
    │
    ▼
feature/login 복귀
    │
    ▼
git stash pop
    │
    ▼
로그인 기능 개발 재개
```

가장 대표적인 Stash 활용 사례다.

#### 2. Pull 또는 Rebase 이전 작업 보관

**상황:** 로컬에서 기능을 수정 중인데 원격 브랜치의 최신 변경사항을 반영해야 한다.

```
git stash push -u -m "API 개발 중"

git pull --rebase

git stash pop
```

기존 변경사항을 보관한 후 최신 코드를 반영하고 다시 복원한다.

단, 복원 과정에서 충돌이 발생할 수 있다.

참고로 `git pull --rebase --autostash`를 이용하면 임시 보관과 복원을 자동으로 수행할 수 있다.

#### 3. 실험 코드의 전후 비교

**상황:** Querydsl 조회 성능을 개선하는 과정에서 기존 코드와 수정 코드를 비교하고 싶다.

```
# 최적화 코드 임시 보관
git stash push -m "Querydsl 최적화 실험"

# 기존 코드 테스트
./gradlew test

# 최적화 코드 복원
git stash pop
```

짧은 실험에 적합하다. 여러 개선안을 장기간 비교하려면 별도의 브랜치나 커밋이 더 적합하다.

#### 4. 다른 개발자의 PR 검증

**상황:** 현재 기능을 개발하던 중 팀원의 PR을 로컬에서 확인해야 한다.

```
git stash push -u -m "현재 개발 중인 기능"

# PR 브랜치로 전환하여 테스트
git switch feature/enrollment
./gradlew test

# 원래 브랜치 복귀 후 복원
git switch feature/login
git stash pop
```

---

### Stash와 다른 Git 기능 비교

|기능|목적|사용 시점|
|---|---|---|
|Stash|미커밋 변경사항 임시 보관|잠시 다른 작업으로 전환|
|Commit|변경사항을 이력으로 기록|의미 있는 작업 단위 완료|
|Worktree|독립적인 작업 디렉터리 생성|여러 브랜치 병렬 개발|
|Cherry-pick|특정 커밋 가져오기|일부 변경사항만 다른 브랜치에 적용|
|Rebase|커밋 기반 변경 및 재배치|브랜치 히스토리 정리|

**Stash와 Worktree의 차이**

- Stash는 현재 작업을 잠시 치워두고 다른 일을 수행한다.
    
- Worktree는 별도 디렉터리에서 여러 작업을 동시에 진행한다.
    
- Codex와 Antigravity 같은 AI 에이전트를 병렬 실행할 때는 Worktree가 유용하다.
    
- Worktree를 사용하더라도 각 작업 디렉터리 내부에서 Stash를 사용할 수 있다.
    

### 실무에서 기억할 사항

1. Stash는 임시 보관 수단이지 장기적인 작업 백업 수단은 아니다.
    
2. 새 파일까지 보관하려면 `-u` 옵션이 필요하다.
    
3. 브랜치를 전환하기 전 `git status`로 작업 상태를 확인한다.
    
4. Stash는 저장소 단위로 공유되므로 복원 대상을 확인한다.
    
5. `pop` 과정에서도 충돌이 발생할 수 있다.
    
6. 일반적인 실무에서는 `push`, `list`, `pop`을 중심으로 익히면 충분하다.
    

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]
- [[../12 Resources/stash 실습|stash 실습]]