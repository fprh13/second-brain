---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# push 사용법

---

## 📄 본문

### 1. Git Push란?

`git push`는 **로컬 저장소의 커밋과 참조(브랜치, 태그 등)를 원격 저장소에 전송하는 명령어**이다.

GitHub와 같은 원격 저장소에 개발 내용을 반영하거나, 다른 개발자와 협업하기 위해 사용한다.

일반적인 사용법은 다음과 같다.

```
git push <원격 저장소> <브랜치>
```

```
git push origin develop
```

- `push`: 로컬 저장소의 변경 이력을 원격 저장소에 반영
    
- `origin`: 원격 저장소 이름
    
- `develop`: Push할 로컬 브랜치 이름이자 원격 대상 브랜치 이름
    

**주의:** `git push origin develop`은 현재 체크아웃한 브랜치와 관계없이 로컬 `develop` 브랜치를 원격 `develop` 브랜치로 Push한다.

### 2. 실무에서 자주 사용하는 명령어

|명령어|설명|중요도|
|---|---|---|
|`git push origin develop`|지정한 브랜치를 원격에 반영|⭐⭐⭐|
|`git push -u origin feature/login`|최초 Push 및 upstream 설정|⭐⭐⭐|
|`git push`|upstream에 연결된 브랜치에 Push|⭐⭐⭐|
|`git push origin HEAD`|현재 브랜치를 원격 동일 이름 브랜치로 Push|⭐⭐|
|`git push --force-with-lease`|Rebase 등으로 변경된 커밋 이력 반영|⭐⭐⭐|
|`git push origin --delete feature/login`|원격 브랜치 삭제|⭐⭐|
|`git push origin v1.0.0`|특정 태그 Push|⭐⭐|
|`git push --dry-run origin develop`|실제 반영 없이 Push 동작 확인|⭐⭐|

### 3. 시나리오 1: 새로운 기능 브랜치 최초 Push

**상황:** 로그인 기능 개발을 위해 `feature/login` 브랜치를 생성하고, GitHub에 올려 PR을 생성한다.

```
# 기능 브랜치 생성
git switch -c feature/login

# 개발 후 커밋
git add .
git commit -m "feat: 로그인 기능 구현"

# 최초 Push
git push -u origin feature/login
```

`-u`는 `--set-upstream`의 축약형이다.

로컬 브랜치가 추적할 원격 브랜치를 설정한다.

```
로컬 브랜치                 원격 추적 브랜치
feature/login  ────────▶  origin/feature/login
```

이후부터는 별도의 브랜치 이름을 입력하지 않아도 된다.

```
git push
git pull
```

**실무 포인트**

- 새로운 기능 브랜치를 처음 원격에 올릴 때 `-u` 사용
    
- 이후 동일 브랜치에서는 `git push`로 간편하게 반영
    
- upstream은 단순한 원격 저장소 연결이 아니라 해당 로컬 브랜치가 추적하는 원격 브랜치 설정
    

### 4. 시나리오 2: PR 코드 리뷰 반영

**상황:** 로그인 기능 PR을 생성한 이후 리뷰어가 예외 처리 개선을 요청했다.

```
git switch feature/login

# 코드 수정 후
git add .
git commit -m "fix: 로그인 예외 처리 개선"

# 기존 원격 브랜치에 반영
git push
```

이미 upstream이 설정되어 있기 때문에 `git push`만으로 반영할 수 있다.

```
feature/login
    │
    ├── feat: 로그인 기능 구현
    │       └── 최초 Push → PR 생성
    │
    └── fix: 로그인 예외 처리 개선
            └── 추가 Push → 기존 PR에 자동 반영
```

새로운 PR을 만들 필요 없이 기존 PR에 추가 커밋이 반영된다.

### 5. 시나리오 3: 현재 브랜치를 Push

**상황:** 현재 작업 브랜치 이름이 길어서 직접 입력하기 번거롭다.

```
git branch --show-current
# feature/enrollment-capacity-validation

git push origin HEAD
```

`HEAD`는 현재 체크아웃한 커밋을 가리킨다.

이 명령은 일반적인 브랜치 작업 환경에서 현재 브랜치를 원격의 동일한 이름을 가진 브랜치로 Push하는 데 사용한다.

최초 Push 시 upstream까지 설정하려면 다음과 같이 사용한다.

```
git push -u origin HEAD
```

**명령어 비교**

|명령어|동작|
|---|---|
|`git push origin develop`|로컬 develop을 원격 develop에 반영|
|`git push origin HEAD`|현재 브랜치를 원격 동일 이름 브랜치에 반영|
|`git push -u origin HEAD`|현재 브랜치 Push 및 upstream 설정|
|`git push`|설정된 upstream과 push 정책에 따라 반영|

### 6. 시나리오 4: Rebase 이후 강제 Push

**상황:** 이미 원격에 Push한 기능 브랜치의 커밋 메시지나 순서를 Rebase로 수정했다.

```
git switch feature/login

# 최근 3개 커밋 정리
git rebase -i HEAD~3
```

Rebase를 통해 커밋을 수정하면 커밋 해시가 변경될 수 있다.

```
변경 전
A ── B ── C  (origin/feature/login)

변경 후
A ── B' ── C' (feature/login)
```

이 상태에서는 일반 Push가 거절될 수 있다.

```
git push

# rejected (non-fast-forward)
```

이때 다음 명령어를 사용한다.

```
git push --force-with-lease
```

`--force-with-lease`는 원격 브랜치가 예상한 상태인지 확인한 후 강제 Push한다.

**강제 Push 옵션 비교**

|명령어|설명|
|---|---|
|`git push --force`|원격 변경 이력을 강제로 덮어쓸 수 있음|
|`git push --force-with-lease`|원격 브랜치가 예상 상태와 다르면 일반적으로 거절|

**실무 주의사항**

- 개인 기능 브랜치에서 Rebase 후 사용하는 것이 일반적
    
- 공유 브랜치에는 사용하지 않는 것이 원칙
    
- `main`, `develop`에서는 강제 Push를 피하고 브랜치 보호 규칙을 설정하는 것이 좋음
    
- `--force-with-lease`도 완벽한 보호 장치는 아니며, 다른 개발자의 커밋을 삭제할 위험이 있음
    
- 원격 변경사항을 단순히 수신하지 못한 상황이라면 강제 Push가 아니라 `fetch`, `merge`, `rebase` 등을 먼저 검토
    

### 7. 시나리오 5: 원격 브랜치 삭제

**상황:** 기능 개발을 완료하고 PR이 `develop`에 병합되었다.

더 이상 사용하지 않는 원격 기능 브랜치를 삭제한다.

```
git push origin --delete feature/login
```

원격 브랜치가 삭제된다.

로컬 브랜치도 삭제하려면 다음 명령어를 사용한다.

```
git switch develop

git branch -d feature/login
```

원격에서 삭제된 브랜치의 추적 참조를 정리하려면:

```
git fetch --prune origin
```

**실무 포인트**

- 원격 브랜치 삭제와 로컬 브랜치 삭제는 별도 작업
    
- GitHub에서 PR Merge 이후 자동으로 기능 브랜치를 삭제하도록 설정 가능
    
- 아직 다른 개발자가 작업 중인 공유 브랜치는 삭제하지 않도록 주의
    

### 8. 시나리오 6: 릴리스 태그 Push

**상황:** 백엔드 서비스를 `v1.0.0`으로 릴리스한다.

```
# 태그 생성
git tag -a v1.0.0 -m "Release v1.0.0"

# 태그 Push
git push origin v1.0.0
```

일반적인 `git push`는 모든 태그를 자동으로 Push하지 않는다.

모든 로컬 태그를 전송하려면 다음과 같이 사용한다.

```
git push origin --tags
```

실무에서는 의도하지 않은 태그까지 반영하지 않도록 특정 태그만 Push하는 것을 권장한다.

```
git push origin v1.0.0
```

릴리스 태그는 GitHub Actions 등 CI/CD 파이프라인의 배포 트리거로 활용할 수 있다.

### 9. 시나리오 7: Push 사전 확인

**상황:** 중요한 브랜치에 Push하기 전에 전송 동작을 확인하고 싶다.

```
git push --dry-run origin develop
```

실제 원격 브랜치를 변경하지 않고 Push 동작을 미리 확인한다.

단, 실제 Push에서 실행되는 서버 측 검증이나 CI 작업의 성공까지 보장하지는 않는다.

Push할 커밋을 확인하려면 다음 명령어도 유용하다.

```
# 원격 추적 브랜치 정보 갱신
git fetch origin

# 로컬에만 존재하는 커밋 확인
git log --oneline origin/develop..develop
```

이를 통해 Push 대상 커밋을 사전에 점검할 수 있다.

### 10. 시나리오 8: 서로 다른 이름의 원격 브랜치에 Push

Git Push는 기본적으로 다음 구조를 사용할 수 있다.

```
git push <원격 저장소> <로컬 브랜치>:<원격 브랜치>
```

예를 들어:

```
git push origin feature/login:feature/auth
```

의미:

```
로컬 브랜치              원격 브랜치
feature/login ────────▶ feature/auth
```

서로 다른 이름의 브랜치를 원격에 반영할 때 사용한다.

일반적인 기능 개발에서는 같은 이름의 브랜치를 사용하는 경우가 많으므로 자주 필요하지는 않다.

### 11. 실무 협업에서의 Push 흐름

**기본적인 GitHub Flow 또는 develop 기반 기능 브랜치 협업 예시**

```
# 1. develop 최신화
git switch develop
git pull --ff-only origin develop

# 2. 기능 브랜치 생성
git switch -c feature/login

# 3. 개발 및 커밋
git add .
git commit -m "feat: 로그인 기능 구현"

# 4. 최초 Push
git push -u origin feature/login

# 5. GitHub에서 PR 생성

# 6. 코드 리뷰 반영
git add .
git commit -m "fix: 로그인 예외 처리 개선"
git push

# 7. PR Merge 완료 후 develop 최신화
git switch develop
git pull --ff-only origin develop

# 8. 로컬 기능 브랜치 삭제
git branch -d feature/login

# 9. 원격 브랜치 삭제 (필요한 경우)
git push origin --delete feature/login
```

실무에서는 팀의 브랜치 전략과 보호 규칙에 따라 `main` 또는 `develop`에 직접 Push하는 대신 PR을 통해 병합하는 방식을 많이 사용한다.

### 12. 자주 발생하는 오류

**1. non-fast-forward 거절**

```
! [rejected] feature/login -> feature/login (non-fast-forward)
```

원격 브랜치에 로컬에서 반영하지 않은 이력이 존재하거나, Rebase 등으로 커밋 이력이 달라졌을 때 발생할 수 있다.

해결 방향:

```
git fetch origin
git log --oneline --graph --left-right HEAD...origin/feature/login
```

이력 차이를 확인한 후 상황에 맞게 `merge`, `rebase`, `--force-with-lease` 등을 선택한다.

**2. upstream이 설정되지 않은 경우**

```
fatal: The current branch feature/login has no upstream branch.
```

최초 Push에서 upstream을 설정한다.

```
git push -u origin feature/login
```

**3. 인증 또는 권한 문제**

```
Permission denied (publickey).
```

또는:

```
remote: Permission to repository denied
```

SSH 키, HTTPS 인증, 저장소 접근 권한 등을 확인해야 한다.

**4. 보호 브랜치 Push 거절**

`main` 또는 `develop`에 대한 직접 Push가 조직 정책에 의해 차단될 수 있다.

이 경우 기능 브랜치에 Push하고 PR을 통해 병합해야 한다.

### 13. 핵심 정리

|상황|추천 명령어|
|---|---|
|새 기능 브랜치 최초 Push|`git push -u origin feature/login`|
|추가 개발사항 Push|`git push`|
|현재 브랜치 Push|`git push origin HEAD`|
|Rebase 이후 이력 갱신|`git push --force-with-lease`|
|원격 브랜치 정리|`git push origin --delete 브랜치명`|
|릴리스 태그 등록|`git push origin v1.0.0`|
|Push 미리 확인|`git push --dry-run origin 브랜치명`|

백엔드 개발자라면 특히 다음 세 가지를 확실하게 이해해야 한다.

1. `**-u**`: 최초 Push 시 upstream 설정
    
2. `**git push**`: 기존 원격 브랜치에 추가 커밋 반영
    
3. `**--force-with-lease**`: Rebase 이후 원격 커밋 이력 갱신
    

---

## ✏️ 메모

### Push와 Commit의 차이

- `commit`: 로컬 저장소에 변경 이력 기록
    
- `push`: 로컬 커밋 이력을 원격 저장소에 전송
    

`git push`는 작업 파일을 직접 업로드하는 명령어가 아니다. 커밋되지 않은 변경사항은 Push되지 않는다.

### upstream 확인 방법

```
git branch -vv
```

출력 예시:

```
* feature/login a1b2c3d [origin/feature/login] feat: 로그인 기능
  develop       e4f5g6h [origin/develop] chore: 프로젝트 설정
```

원격 추적 브랜치가 연결되어 있는지 확인할 수 있다.

### 주의할 점

- `git push`는 원격 브랜치 이력을 변경하는 작업이므로 대상 브랜치를 확인할 것
    
- Rebase 이후 강제 Push 전에는 다른 개발자의 작업이 없는지 확인할 것
    
- 중요한 공유 브랜치는 GitHub의 Branch Protection 또는 Rulesets를 적용할 것
    
- `git push --all`은 모든 로컬 브랜치를 Push할 수 있으므로 일반적인 기능 개발에서는 사용을 신중히 할 것
    
- `git push --mirror`는 원격 참조를 삭제하거나 덮어쓸 수 있어 일반적인 개발 작업에서는 사용하지 않을 것
    

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]