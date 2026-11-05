---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# cherry-pick 실습

---

## 📄 본문

### 실습 목적

`git cherry-pick`을 이용하여 다른 브랜치의 특정 커밋만 현재 브랜치에 적용하는 방법을 학습한다.

**학습 목표**

- 특정 커밋만 선택하여 가져오기
    
- Cherry-pick으로 생성된 커밋 확인
    
- 의도적인 충돌 발생 및 해결
    
- Cherry-pick 이후 Merge 동작 이해
    
- 커밋 탐색 및 범위 지정 문법 학습
    
- 실무 Hotfix Backport 활용 이해
    

### 실습 환경

- Repository: `chanmu-dev-lab-playground`
    
- 기준 브랜치: `feature/jym-git-play`
    
- 실습 브랜치: `feature/login`, `feature/timeout`
    
- 실습 경로: `jym/practice/cherry-pick/`
    

### 실습 1. 특정 커밋만 Cherry-pick

**1. 기능 브랜치 생성**

```
git switch -c feature/login
```

현재 브랜치에서 분기한 새로운 기능 브랜치를 생성한다.

**2. 로그인 기능 구현 및 커밋**

```
echo "로그인 기능 구현" > jym/practice/cherry-pick/login.md

git add .
git commit -m "feature: 로그인 기능 구현"
```

생성된 커밋:

```
54000d6 feature: 로그인 기능 구현
```

**3. 비밀번호 검증 기능 구현 및 커밋**

```
echo "비밀번호 검증 기능 구현" > jym/practice/cherry-pick/validation.md

git add .
git commit -m "feature: 비밀번호 검증 기능 구현"
```

생성된 커밋:

```
3e45ff2 feature: 비밀번호 검증 기능 구현
```

**4. 기존 브랜치에서 별도 기능 구현**

```
git switch feature/jym-git-play

mkdir -p jym/practice/cherry-pick

echo "메인 브랜치 작업" > jym/practice/cherry-pick/main.md

git add .
git commit -m "feature: 메인 기능 구현"
```

생성된 커밋:

```
3fc2890 feature: 메인 기능 구현
```

현재 커밋 구조:

```
A ─── D                 feature/jym-git-play
 \
  B ─── C               feature/login

A: 공통 조상
B: 로그인 구현 (54000d6)
C: 비밀번호 검증 (3e45ff2)
D: 메인 기능 구현 (3fc2890)
```

**5. 특정 커밋만 적용**

```
git log --oneline feature/jym-git-play..feature/login
```

브랜치 간 커밋 차이를 확인한다.

```
git cherry-pick feature/login~1
```

`feature/login~1`은 해당 브랜치의 최신 커밋에서 첫 번째 부모로 한 단계 이동한 커밋을 의미한다.

따라서 비밀번호 검증 커밋이 아닌 로그인 기능 커밋만 선택된다.

실행 결과:

```
[feature/jym-git-play 1f8ba2f] feature: 로그인 기능 구현
```

**6. 커밋 그래프 확인**

```
git log --oneline --graph --all
```

Cherry-pick 이후 구조:

```
A ─── D ─── B'          feature/jym-git-play
 \
  B ─── C               feature/login

B  : 54000d6
B' : 1f8ba2f
```

**실습 결과**

- 로그인 기능만 현재 브랜치에 반영되었다.
    
- 비밀번호 검증 기능은 가져오지 않았다.
    
- 원본 커밋 `54000d6`과 새로운 커밋 `1f8ba2f`의 해시가 서로 다르다.
    
- Cherry-pick은 원본 커밋을 이동시키지 않고 변경 사항을 새 커밋으로 적용한다.
    

### 실습 2. Cherry-pick 충돌 발생 및 해결

이번에는 같은 파일의 동일한 부분을 서로 다른 브랜치에서 수정하여 의도적으로 충돌을 발생시킨다.

**1. 공통 설정 파일 생성**

```
echo "timeout=30" > jym/practice/cherry-pick/config.md

git add .
git commit -m "chore: 타임아웃 기본값 설정"
```

커밋:

```
2a824ef chore: 타임아웃 기본값 설정
```

**2. 새로운 브랜치에서 설정 수정**

```
git switch -c feature/timeout

echo "timeout=60" > jym/practice/cherry-pick/config.md

git add .
git commit -m "chore: 타임아웃 60초로 변경"
```

커밋:

```
c277429 chore: 타임아웃 60초로 변경
```

**3. 기준 브랜치에서도 같은 파일 수정**

```
git switch feature/jym-git-play

echo "timeout=10" > jym/practice/cherry-pick/config.md

git add .
git commit -m "fix: 타임아웃 10초로 변경"
```

커밋:

```
0962a6f fix: 타임아웃 10초로 변경
```

현재 구조:

```
             B (timeout=60)
            /
A ─────────
            \
             C (timeout=10)

A: timeout=30
B: feature/timeout
C: feature/jym-git-play
```

**4. Cherry-pick으로 충돌 발생**

```
git cherry-pick feature/timeout
```

출력:

```
CONFLICT (content): Merge conflict in
jym/practice/cherry-pick/config.md

error: could not apply c277429...
```

두 브랜치에서 같은 줄을 다르게 수정했으므로 충돌이 발생한다.

충돌 파일에는 다음과 같은 내용이 표시된다.

```
<<<<<<< HEAD
timeout=10
=======
timeout=60
>>>>>>> c277429
```

- `HEAD`: 현재 브랜치의 내용
    
- 구분선 아래: Cherry-pick으로 적용하려는 커밋의 내용
    

**5. 충돌 해결**

이번에는 `timeout=60`을 선택했다.

```
echo "timeout=60" > jym/practice/cherry-pick/config.md

git add .
git cherry-pick --continue
```

실행 결과:

```
[feature/jym-git-play 9844515]
chore: 타임아웃 60초로 변경
```

**6. 결과 확인**

```
git status
git log --oneline --graph --all
```

실행 결과:

```
On branch feature/jym-git-play
nothing to commit, working tree clean
```

**실습 결과**

- 같은 파일을 서로 다르게 수정하여 충돌 발생
    
- 충돌 파일 직접 수정
    
- `git add`로 해결 완료 표시
    
- `git cherry-pick --continue`로 작업 완료
    
- 새로운 커밋 `9844515` 생성
    

### 실습 3. 커밋 탐색 및 범위 지정 문법

Cherry-pick에서는 특정 커밋을 지정할 때 Git Revision Syntax를 활용한다.

#### `~` : 첫 번째 부모를 따라 이동

```
A ─── B ─── C ─── D ─── E
                        ↑
                       HEAD
```

|명령어|선택 커밋|
|---|---|
|`HEAD`|E|
|`HEAD~1`|D|
|`HEAD~2`|C|
|`HEAD~3`|B|
|`HEAD~4`|A|

```
git cherry-pick feature/login~1
```

`feature/login`의 최신 커밋에서 첫 번째 부모로 한 단계 이동한 커밋을 선택한다.

`~2`는 최근 두 커밋을 선택한다는 의미가 아니라 부모 커밋을 두 번 따라간다는 의미이다.

#### `^` : 부모 커밋 지정

|문법|의미|
|---|---|
|`HEAD^`|첫 번째 부모|
|`HEAD^1`|첫 번째 부모|
|`HEAD^2`|두 번째 부모|
|`HEAD~2`|첫 번째 부모를 두 번 따라간 커밋|

`HEAD^2`는 주로 부모가 둘 이상인 Merge Commit에서 사용된다.

#### `..` : 커밋 범위 지정

```
git cherry-pick A..B
```

B에서 도달 가능하지만 A에서는 도달할 수 없는 커밋들을 선택한다.

일반적인 선형 커밋 이력에서는 A를 제외하고 B까지 선택한다고 이해하면 된다.

예시:

```
A ─── B ─── C ─── D ─── E
```

```
git cherry-pick HEAD~2..HEAD
```

- `HEAD~2`: C
    
- `HEAD`: E
    
- 적용 대상: D, E
    

따라서 최신 두 커밋을 적용한다.

#### 불연속 커밋 선택

특정 커밋만 골라 적용할 수도 있다.

```
A ─── B ─── C ─── D ─── E
```

```
git cherry-pick HEAD~3 HEAD~1
```

적용 대상: B, D

또는 커밋 해시로 지정할 수 있다.

```
git cherry-pick <hash-B> <hash-D>
```

커밋 사이에 의존성이 존재할 수 있으므로 적용 순서와 빌드 결과를 확인해야 한다.

### 실습 4. Cherry-pick 이후 Merge 동작 이해

Cherry-pick으로 반영된 변경 사항이 나중에 Merge될 때 어떻게 동작하는지 학습했다.

```
A ─── B ─── C ─── D       develop
 \
  ─── C' ────────────     release
```

- C: Develop 브랜치에서 버그 수정
    
- C': Cherry-pick으로 Release에 동일한 수정 적용
    

이후 Release에서 Develop을 병합한다.

```
git switch release
git merge develop
```

Git은 커밋 해시가 같다는 이유로 중복 적용을 방지하는 것이 아니다.

**공통 조상을 기준으로 양쪽 브랜치의 파일 변경 내용을 비교하는 3-way merge를 수행한다.**

따라서 두 브랜치가 같은 부분을 동일하게 수정했다면 일반적으로 중복이나 충돌 없이 병합된다.

반대로 이후에 같은 부분을 서로 다르게 수정했다면 충돌이 발생할 수 있다.

원본 커밋과 Cherry-pick으로 만들어진 커밋은 별도의 이력으로 남을 수 있다.

### 추가 실습. Hotfix Backport 시나리오

실무에서는 특정 버그 수정 커밋만 운영 브랜치에 반영하기 위해 Cherry-pick을 사용한다.

아래는 학습한 시나리오이며, 별도 실습으로 확장할 수 있다.

```
A ──────────────────── release/1.0
 \
  B ─── C ─── D ────── develop

B: 알림 기능 개발
C: 로그인 버그 수정
D: 관리자 기능 개발
```

운영 중인 `release/1.0`에 로그인 버그가 발생했지만 Develop의 신규 기능들은 아직 배포할 수 없는 상황이다.

이때 수정 커밋 C만 가져온다.

```
git switch release/1.0

git cherry-pick -x <fix-commit-hash>
```

결과:

```
A ─── C' ───────────── release/1.0
 \
  B ─── C ─── D ────── develop
```

`-x` 옵션을 사용하면 원본 커밋 출처를 메시지에 기록할 수 있다.

```
(cherry picked from commit ...)
```

이후 릴리스 브랜치에서 테스트와 CI 검증을 진행하고 PR 리뷰 및 배포 절차를 따른다.

---

## ✏️ 메모

### 실습 중 발생했던 오류

**1.** `**git switch**` **명령어 오타**

```
git switch - c feature/login
```

오류:

```
fatal: only one reference expected
```

올바른 명령어:

```
git switch -c feature/login
```

`-c`는 하나의 옵션이다.

**2. 브랜치 전환 후 디렉터리 없음**

```
zsh: no such file or directory
```

브랜치를 전환하면 해당 브랜치의 추적 파일 상태로 작업 트리가 변경된다. 다른 브랜치에서만 생성된 디렉터리는 사라질 수 있다.

파일을 만들기 전에 디렉터리를 생성한다.

```
mkdir -p jym/practice/cherry-pick
```

**3.** `**git log**` **옵션 오타**

잘못된 명령어:

```
git log --oneline --graph -all
```

올바른 명령어:

```
git log --oneline --graph --all
```

`--all`은 긴 옵션이므로 하이픈 두 개를 사용한다.

**4. 커밋 범위 지정 시 공백 주의**

잘못 작성한 형태:

```
git log --oneline feature/jym-git-play ..feature/login
```

올바른 형태:

```
git log --oneline feature/jym-git-play..feature/login
```

`A..B`는 하나의 Revision Range 표현식이므로 공백 없이 작성해야 한다.

### 주요 명령어 정리

|명령어|설명|
|---|---|
|`git cherry-pick <hash>`|특정 커밋 적용|
|`git cherry-pick A B`|지정한 커밋들을 순서대로 적용|
|`git cherry-pick A..B`|A에 없고 B에서 도달 가능한 커밋 적용|
|`git cherry-pick -x <hash>`|원본 커밋 출처 기록|
|`git cherry-pick -n <hash>`|자동 커밋 없이 변경 사항만 적용|
|`git cherry-pick --continue`|충돌 해결 후 재개|
|`git cherry-pick --abort`|진행 중인 작업 취소|
|`git cherry-pick --skip`|현재 커밋 적용 건너뛰기|
|`git log --oneline --graph --all`|커밋 그래프 확인|
|`git rev-parse HEAD~2`|두 단계 이전 조상의 해시 확인|

### 실습 브랜치 정리

실습용 브랜치가 필요 없어졌다면 삭제할 수 있다.

```
git switch feature/jym-git-play

git branch -D feature/login feature/timeout
```

`-D`는 병합되지 않은 커밋이 있어도 강제로 브랜치를 삭제한다.

Cherry-pick으로 가져온 커밋은 Git의 이력상 일반적인 병합으로 처리되지 않으므로, 원본 브랜치를 삭제할 때 `-d`가 거부될 수 있다.

반드시 해당 브랜치에 보존할 커밋이 없는지 확인한 후 삭제한다.

실습으로 생성한 커밋까지 제거하려면 다음처럼 확인한다.

```
git log --oneline origin/feature/jym-git-play..HEAD
```

원격 브랜치를 기준으로 복구하려는 경우:

```
git reset --hard origin/feature/jym-git-play
```

이 명령은 로컬 커밋과 추적 파일의 미커밋 변경 사항을 버리므로 실제 작업 브랜치에서는 특히 주의해야 한다.

### 핵심 학습 내용

1. Cherry-pick은 다른 브랜치의 특정 커밋을 선택적으로 적용한다.
    
2. 적용된 커밋은 원본과 다른 해시를 갖는 새로운 커밋이 된다.
    
3. 같은 파일을 서로 다르게 수정하면 충돌이 발생할 수 있다.
    
4. 충돌 해결 후 `git cherry-pick --continue`로 작업을 완료한다.
    
5. Merge는 Cherry-pick 이력 자체가 아니라 공통 조상과 파일 변경 사항을 기준으로 병합한다.
    
6. `~`, `^`, `..` 문법을 이용하면 원하는 커밋과 커밋 범위를 선택할 수 있다.
    
7. 실무에서는 Hotfix Backport에 활용하며, 적용 후 반드시 테스트를 수행해야 한다.
    

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[Git]]
- [[cherry-pick]]