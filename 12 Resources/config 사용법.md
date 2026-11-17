---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# config 사용법

---

## 📄 본문

### 개념

`git config`는 **Git의 사용자 정보, 동작 방식, 기본 정책 등을 설정하고 조회하는 명령어**다.

`commit`, `push`, `rebase` 등의 명령어가 Git 작업을 수행한다면, `config`는 해당 작업이 어떤 환경과 규칙으로 실행될지를 결정한다.

백엔드 개발자는 주로 개발 환경 초기 설정, 개인·회사 계정 분리, Git Pull 정책 설정, 명령어 단축어 등록, 설정 오류 해결 등에 사용한다.

### 설정 범위 및 우선순위

Git 설정은 크게 세 가지 범위로 나뉜다.

|범위|옵션|설정 파일|적용 대상|
|---|---|---|---|
|System|`--system`|Git 시스템 설정 파일|컴퓨터의 모든 사용자|
|Global|`--global`|`~/.gitconfig`|현재 OS 사용자의 Git 저장소|
|Local|`--local`|`.git/config`|현재 Git 저장소|

**우선순위: Local > Global > System**

동일한 설정값이 여러 범위에 존재하면 일반적으로 우선순위가 높은 설정이 적용된다.

예를 들어 Global에는 개인 이메일을 설정하고, Local에는 회사 이메일을 설정하면 회사 프로젝트에서만 회사 이메일을 사용한다.

> [!NOTE]  
> `--local`은 Git 저장소 내부에서만 사용할 수 있으며, 기본적인 `git config` 쓰기 명령도 저장소 내부에서는 Local 범위에 적용된다.

### 기본 명령어

|명령어|설명|
|---|---|
|`git config --list`|적용되는 설정 목록 확인|
|`git config --list --show-origin`|설정값과 설정 파일 위치 확인|
|`git config --global <key> <value>`|전역 설정 등록·변경|
|`git config --local <key> <value>`|현재 저장소 설정 등록·변경|
|`git config --get <key>`|특정 설정값 조회|
|`git config --local --unset <key>`|로컬 설정 제거|
|`git config --global --edit`|전역 설정 파일 편집|
|`git config --local --edit`|로컬 설정 파일 편집|

### 시나리오 1. 개발 환경 최초 설정

**상황:** 새로운 MacBook을 지급받거나 Git을 처음 설치한 경우.

Git 커밋 작성자 정보와 기본 동작 방식을 설정한다.

```
# 사용자 이름 설정
git config --global user.name "홍길동"

# 사용자 이메일 설정
git config --global user.email "dev@example.com"

# 기본 브랜치 이름
git config --global init.defaultBranch main

# 원격에서 삭제된 추적 브랜치 참조 자동 정리
git config --global fetch.prune true

# macOS에서 줄바꿈 설정
git config --global core.autocrlf input
```

설정 확인:

```
git config --global --list

git config --get user.name
git config --get user.email
```

- `user.name`: 커밋에 기록되는 작성자 이름
    
- `user.email`: 커밋에 기록되는 작성자 이메일
    
- `init.defaultBranch`: `git init` 시 생성되는 초기 브랜치 이름
    
- `fetch.prune`: Fetch 시 원격에서 삭제된 브랜치의 로컬 추적 참조 정리
    
- `core.autocrlf=input`: 커밋할 때 CRLF를 LF로 정규화하는 설정
    

> [!IMPORTANT]  
> `user.name`과 `user.email`은 GitHub 로그인이나 인증 정보가 아니라 커밋 메타데이터다.
> 
> GitHub 인증은 SSH Key, Credential Manager 등의 별도 인증 수단으로 관리한다.

### 시나리오 2. 개인 프로젝트와 회사 프로젝트 설정 분리

**상황:** 개인 GitHub 프로젝트에서는 개인 이메일을 사용하고, 회사 프로젝트에서는 회사 이메일을 사용해야 한다.

먼저 개인 계정을 Global로 설정한다.

```
git config --global user.name "홍길동"
git config --global user.email "personal@example.com"
```

회사 프로젝트 디렉터리에서 Local 설정을 적용한다.

```
cd company-backend

git config --local user.name "홍길동"
git config --local user.email "dev@company.com"
```

설정 확인:

```
git config --show-origin --get user.email
```

|저장소|적용 이메일|
|---|---|
|개인 프로젝트|[personal@example.com](mailto:personal@example.com)|
|회사 백엔드 프로젝트|[dev@company.com](mailto:dev@company.com)|
|Git 실습 저장소|[personal@example.com](mailto:personal@example.com)|

Local 설정은 현재 저장소에서만 적용되므로 다른 프로젝트에는 영향을 주지 않는다.

**실무 활용:** 회사 GitHub Organization 저장소의 커밋 이메일 규칙을 준수하거나, 개인 작업과 업무 작업의 커밋 작성자 정보를 분리할 수 있다.

단, 실제 저장소 접근 권한과 인증 계정은 `git config user.email`만 변경한다고 전환되지 않는다.

### 시나리오 3. Git Pull 정책 설정

**상황:** 팀에서 `git pull`을 실행할 때 적용할 통합 방식을 정해야 한다.

Git Pull은 기본적으로 원격 변경 사항을 가져오는 Fetch와 통합 작업으로 구성된다.

**1. Merge 방식**

```
git config --local pull.rebase false
```

- 원격 브랜치와 로컬 브랜치가 갈라졌다면 Merge 방식으로 통합
    
- 필요한 경우 Merge Commit 생성
    
- 팀에서 Merge 기반 이력 관리를 사용하는 경우 활용
    

**2. Rebase 방식**

```
git config --local pull.rebase true
```

- 로컬 커밋을 가져온 원격 변경 사항 위에 재적용
    
- 불필요한 Merge Commit을 줄일 수 있음
    
- 커밋 해시가 변경될 수 있으므로 공유된 커밋에 주의
    

**3. Fast-forward Only 방식**

```
git config --local pull.ff only
```

- Fast-forward 가능한 경우에만 Pull 성공
    
- 브랜치가 갈라져 별도의 통합이 필요하면 중단
    
- 개발자가 Merge 또는 Rebase를 명시적으로 수행하도록 유도
    

> [!TIP]  
> 세 가지는 의도에 따라 선택하는 설정이다.
> 
> `pull.ff only`와 `pull.rebase true`를 함께 설정하면 Fast-forward가 불가능한 상황에서 자동 Rebase가 수행되지 않을 수 있다. 팀의 Git 정책에 맞게 사용한다.

### 시나리오 4. Git 명령어 단축어 등록

**상황:** 커밋 로그와 브랜치 흐름을 자주 확인하는 백엔드 개발자가 긴 Git 명령어를 간단하게 실행하고 싶다.

Git Alias를 등록한다.

```
# 커밋 그래프 조회
git config --global alias.lg \
"log --oneline --graph --decorate --all"

# Git 상태 조회
git config --global alias.st "status"

# 최근 커밋 조회
git config --global alias.last "log -1"
```

이후 다음처럼 사용한다.

```
git lg
git st
git last
```

**활용 사례**

- 여러 기능 브랜치의 Merge 상태 확인
    
- Rebase 이후 커밋 그래프 확인
    
- Cherry-pick 및 Revert 실습 이후 커밋 이력 확인
    

Alias는 개인 개발 편의를 위한 기능이므로 팀원 모두에게 동일한 설정이 적용되지는 않는다.

### 시나리오 5. Git 설정 문제 해결

**상황:** 커밋 이메일이 예상과 다르거나, Git Pull 동작 방식이 다른 팀원과 다르게 나타난다.

현재 적용되는 설정을 확인한다.

```
git config --list
```

설정이 어느 파일에서 비롯되었는지 확인한다.

```
git config --list --show-origin
```

특정 설정값과 출처를 확인한다.

```
git config --show-origin --get user.email
```

잘못된 설정을 수정한다.

```
git config --local user.email "correct@example.com"
```

Local 설정을 제거한다.

```
git config --local --unset user.email
```

Local 설정을 제거하면 해당 키에 대해 Global 또는 System 설정이 다시 적용될 수 있다.

**실무 활용:** 새로운 프로젝트에 참여했거나, 개발 환경을 이전하거나, 팀원과 Git 동작이 달라졌을 때 설정 충돌을 진단한다.

### 시나리오 6. 프로젝트별 Git Hook 설정

**상황:** 백엔드 프로젝트에서 커밋 전에 코드 포맷이나 테스트를 검사하도록 Git Hook을 관리한다.

```
git config --local core.hooksPath .githooks
```

저장소 내부의 `.githooks` 디렉터리를 Hook 실행 경로로 사용한다.

예시 구조:

```
company-backend/
├── .githooks/
│   ├── pre-commit
│   └── pre-push
├── src/
├── build.gradle
└── settings.gradle
```

활용 예시:

- `pre-commit`: 코드 스타일·포맷 검사
    
- `pre-push`: 테스트 실행 또는 정적 분석
    
- 커밋 메시지 정책 검증은 `commit-msg` Hook 사용
    

> [!NOTE]  
> `core.hooksPath` 설정은 프로젝트 저장소에 자동 공유되지 않는다. 팀원마다 별도 설정하거나 프로젝트 초기화 스크립트로 적용해야 한다.
> 
> Git Hook은 사용자가 우회할 수 있으므로 중요한 품질 검증은 CI에서도 수행하는 것이 좋다.

### 사용 빈도 및 중요도

|작업|실무 사용 빈도|중요도|
|---|---|---|
|사용자 이름·이메일 설정|최초 설정 시|높음|
|개인·회사 프로젝트 설정 분리|프로젝트 참여 시|높음|
|Pull 정책 설정|팀 정책 적용 시|높음|
|설정 조회 및 오류 해결|필요시|높음|
|Alias 등록|선택적|보통|
|Git Hook 경로 설정|프로젝트 환경에 따라|보통|
|System 설정 변경|드묾|낮음|

`git config`는 매일 실행하는 명령어는 아니지만, **개발 환경을 구성하고 팀의 Git 작업 규칙을 관리하는 데 필요한 기본 명령어**다.

---

## ✏️ 메모

### 꼭 기억할 사항

- `--global`은 현재 사용자의 전체 Git 저장소에 적용된다.
    
- `--local`은 현재 Git 저장소에만 적용된다.
    
- 설정 우선순위는 기본적으로 `Local > Global > System`이다.
    
- `user.email`은 인증 정보가 아니라 커밋 작성자 정보다.
    
- 프로젝트별 Git 정책은 팀의 합의에 맞게 적용해야 한다.
    
- 문제 발생 시 `git config --list --show-origin`을 활용한다.
    
- `.git/config`는 일반적으로 Git으로 버전 관리되지 않는다.
    

### 추천 기본 설정

macOS에서 개인 개발용으로 사용할 수 있는 기본 설정 예시:

```
git config --global user.name "홍길동"
git config --global user.email "personal@example.com"
git config --global init.defaultBranch main
git config --global fetch.prune true
git config --global core.autocrlf input

git config --global alias.lg \
"log --oneline --graph --decorate --all"
```

`pull.rebase`와 `pull.ff`는 작업 방식이나 팀 정책에 따라 따로 설정하는 것이 좋다.

### 확인용 명령어

```
# 현재 적용된 설정 전체 확인
git config --list

# 각 설정의 출처 확인
git config --list --show-origin

# 특정 설정값 확인
git config --get user.email

# 현재 저장소의 설정 확인
git config --local --list

# 전역 설정 파일 편집
git config --global --edit
```

---

## 📚 참고 및 링크

- 

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]