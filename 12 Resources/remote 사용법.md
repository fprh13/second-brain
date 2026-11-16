---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# remote 사용법

---

## 📄 본문

### 1. git remote란?

`git remote`는 **로컬 Git 저장소와 GitHub, GitLab 등 원격 저장소의 연결 정보를 관리하는 명령어**이다.

- `remote`: 원격 저장소의 이름과 URL을 등록하고 관리
    
- `origin`: 원격 저장소의 기본 별칭으로 사용하는 관례적인 이름
    
- `upstream`: 주로 Fork 방식에서 원본 저장소에 붙이는 별칭
    
- `fetch / pull / push`: 등록된 원격 저장소와 데이터를 주고받는 명령어
    

> [!IMPORTANT]  
> `git remote`는 원격 저장소의 연결 정보를 관리하며, 실제 코드를 업로드하거나 다운로드하지는 않는다.
> 
> `origin`과 `upstream`은 특별한 예약어가 아니라 개발자가 지정하는 별칭이다.

### 2. 주요 명령어

|명령어|설명|
|---|---|
|`git remote`|등록된 원격 저장소 이름 확인|
|`git remote -v`|원격 저장소 이름과 URL 확인|
|`git remote add origin URL`|원격 저장소 등록|
|`git remote set-url origin URL`|원격 저장소 URL 변경|
|`git remote remove origin`|원격 저장소 연결 정보 삭제|
|`git remote rename origin backup`|원격 저장소 별칭 변경|
|`git remote show origin`|원격 저장소의 상세 정보 확인|
|`git fetch origin`|원격 변경 사항 가져오기|
|`git push -u origin 브랜치명`|원격 브랜치에 Push하고 추적 관계 설정|

**참고:** `git fetch`, `git push`는 `remote`의 하위 명령어가 아니라 원격 저장소와 통신하는 별도의 Git 명령어이다.

### 3. 시나리오 ① 개인 프로젝트를 GitHub에 연결

**상황:** 로컬에서 먼저 개발한 Spring Boot 프로젝트를 새로 만든 GitHub 저장소에 업로드하려는 경우

```
# 로컬 저장소 초기화 (아직 Git 저장소가 아니라면)
git init

# GitHub 저장소 연결
git remote add origin https://github.com/user/academy.git

# 연결 확인
git remote -v

# 최초 커밋 (커밋이 없는 경우)
git add .
git commit -m "chore: 프로젝트 초기 설정"

# 현재 브랜치가 main이라고 가정
git push -u origin main
```

- `git remote add`: GitHub 저장소 연결
    
- `git push`: 로컬 커밋 업로드
    
- `-u`: 로컬 브랜치의 추적 대상 설정
    

`-u`로 추적 관계를 설정하면 이후에는 일반적으로 `git push`, `git pull`만 사용해도 된다.

### 4. 시나리오 ② 회사 Organization 저장소에서 협업

**상황:** 회사 GitHub Organization의 백엔드 프로젝트를 Clone하여 기능 개발 후 PR을 생성하는 경우

```
# 회사 저장소 복제
git clone https://github.com/company/academy-backend.git

cd academy-backend

# 원격 저장소 확인
git remote -v
```

출력 예시:

```
origin  https://github.com/company/academy-backend.git (fetch)
origin  https://github.com/company/academy-backend.git (push)
```

`git clone`으로 복제하면 일반적으로 `origin`이 자동으로 등록된다.

**실무 개발 흐름**

```
# 원격 저장소의 최신 정보 조회
git fetch origin

# 로컬 develop 브랜치로 이동
git switch develop

# 최신 develop 반영
git pull --ff-only origin develop

# 기능 브랜치 생성
git switch -c feature/enrollment

# 기능 개발 및 커밋
git add .
git commit -m "feat: 수강 신청 기능 구현"

# 회사 저장소에 기능 브랜치 Push
git push -u origin feature/enrollment
```

이후 GitHub에서 PR을 생성하여 코드 리뷰 및 병합을 진행한다.

> [!NOTE]  
> 회사 Organization 저장소라고 해서 특별한 `remote` 명령어가 필요한 것은 아니다.
> 
> 저장소에 대한 접근 권한만 있다면 일반 GitHub 저장소와 동일하게 사용한다.

### 5. 시나리오 ③ Fork 기반 협업 (origin + upstream)

**상황:** 회사 또는 오픈소스 원본 저장소를 직접 수정하지 않고, 내 GitHub 계정으로 Fork하여 작업하는 경우

**저장소 구조**

```
회사 GitHub Organization
└── company/academy-backend
    └── upstream (원본 저장소)

내 GitHub
└── user/academy-backend
    └── origin (Fork 저장소)

내 로컬 저장소
├── origin   → user/academy-backend
└── upstream → company/academy-backend
```

**① Fork 저장소 Clone**

```
git clone https://github.com/user/academy-backend.git

cd academy-backend
```

**② 원본 저장소 등록**

```
git remote add upstream https://github.com/company/academy-backend.git
```

**③ 원격 저장소 확인**

```
git remote -v
```

출력:

```
origin    https://github.com/user/academy-backend.git (fetch)
origin    https://github.com/user/academy-backend.git (push)
upstream  https://github.com/company/academy-backend.git (fetch)
upstream  https://github.com/company/academy-backend.git (push)
```

**④ 원본 저장소의 최신 변경 사항 반영**

```
git fetch upstream

git switch main

git merge --ff-only upstream/main
```

내 Fork의 `main`에도 반영하려면:

```
git push origin main
```

**⑤ 기능 브랜치 작업**

```
git switch -c feature/enrollment

# 개발 및 커밋
git add .
git commit -m "feat: 수강 신청 기능 구현"

# 내 Fork 저장소로 Push
git push -u origin feature/enrollment
```

**⑥ PR 생성**

GitHub에서 다음과 같이 PR을 생성한다.

```
base: company/academy-backend (main)
  ↑
head: user/academy-backend (feature/enrollment)
```

> [!IMPORTANT]  
> Fork 방식에서는 일반적으로 `origin`으로 내 작업을 Push하고, `upstream`에서 원본 프로젝트의 최신 변경 사항을 가져온다.
> 
> 원본 저장소에 Push 권한이 없더라도 읽기 권한이 있다면 `git fetch upstream`은 가능하다.

### 6. 시나리오 ④ 원격 저장소 주소 변경

**상황:** GitHub 저장소 이름을 변경하거나 HTTPS에서 SSH로 전환하는 경우

현재 연결 상태 확인:

```
git remote -v
```

**HTTPS → SSH 변경**

```
git remote set-url origin git@github.com:company/academy-backend.git
```

변경 확인:

```
git remote -v
```

이후 SSH 인증 환경이 정상적으로 구성되어 있다면 기존처럼 `git push`, `git pull`을 사용할 수 있다.

저장소를 다른 Organization이나 Git 서버로 이전할 때도 `set-url`을 사용할 수 있다.

### 7. 시나리오 ⑤ 불필요한 원격 저장소 제거 및 이름 변경

**원격 저장소 연결 제거**

```
git remote remove upstream
```

**원격 저장소 별칭 변경**

```
git remote rename origin old-origin
```

**원격 저장소 추가 등록**

```
git remote add origin https://github.com/company/new-backend.git
```

> [!CAUTION]  
> `git remote remove`는 로컬 저장소에 등록된 연결 정보만 제거한다.
> 
> GitHub에 존재하는 실제 원격 저장소나 로컬 커밋이 삭제되는 것은 아니다.

### 8. 시나리오별 명령어 정리

|실무 상황|주요 명령어|
|---|---|
|로컬 프로젝트를 GitHub에 연결|`git remote add origin URL`|
|회사 프로젝트를 Clone|`git clone URL`|
|원격 저장소 연결 상태 확인|`git remote -v`|
|원본 저장소 추가|`git remote add upstream URL`|
|원본 저장소 최신 변경 사항 조회|`git fetch upstream`|
|기능 브랜치를 원격 저장소로 Push|`git push -u origin 브랜치명`|
|GitHub 저장소 주소 변경|`git remote set-url origin URL`|
|원격 저장소 연결 제거|`git remote remove 이름`|
|원격 브랜치 및 추적 관계 확인|`git remote show origin`|

---

## ✏️ 메모

### 실무에서 얼마나 자주 사용할까?

`git remote` 자체는 저장소를 처음 설정하거나 원격 저장소 구성을 변경할 때 주로 사용한다.

반면 `git fetch`, `git pull`, `git push`는 매일 사용하는 명령어에 가깝다.

따라서 **remote의 핵심은 명령어 암기보다 원격 저장소의 연결 구조와 브랜치 추적 관계를 이해하는 것**이다.

### origin과 upstream의 차이

|구분|origin|upstream|
|---|---|---|
|의미|기본 원격 저장소 별칭|주로 원본 저장소 별칭|
|일반적인 대상|Clone한 저장소 또는 내 Fork|Fork의 원본 저장소|
|주요 작업|Push, Fetch, Pull|주로 Fetch|
|자동 등록|Clone 시 일반적으로 자동 등록|직접 추가하는 경우가 많음|

**주의:** `upstream`이라는 원격 저장소 이름과 `git push -u`에서 설정하는 _upstream tracking branch_는 서로 다른 개념이다.

### 로컬에서 확인할 사항

기존 Git 실습 저장소에서 다음 명령어를 실행해 연결 상태를 살펴보자.

```
git remote -v

git remote show origin

git branch -vv
```

- `remote -v`: 어떤 원격 저장소가 등록되어 있는지 확인
    
- `remote show origin`: 원격 저장소 정보와 브랜치 추적 상태 확인
    
- `branch -vv`: 로컬 브랜치가 어떤 원격 브랜치를 추적하는지 확인
    

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]