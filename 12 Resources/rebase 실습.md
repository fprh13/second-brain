---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---

# rebase 실습

---

## 📄 본문

### 실습 목표

Interactive Rebase를 사용하여 여러 커밋을 정리하고, 이미 Push한 커밋의 이력을 재작성한 뒤 원격 저장소에 반영하는 과정을 학습한다.

**실습 환경**

- 저장소: `chanmu-dev-lab-playground`
    
- 실습 브랜치: `practice/interactive-rebase`
    
- 실습 커밋: 5개
    
- 실습 방식: 커밋 생성 후 각각 Push
    
- 목표: 5개 커밋을 2개로 정리
    

**학습할 명령어**

- `git rebase -i`
    
- `pick`
    
- `fixup`
    
- `squash`
    
- `reword`
    
- `drop`
    
- `git push --force-with-lease`
    

### 1. 실습 브랜치 생성

기존 브랜치의 커밋 이력을 변경하지 않도록 별도의 실습 브랜치를 생성한다.

```
git switch -c practice/interactive-rebase

mkdir -p rebase-practice
```

### 2. 실습 커밋 생성

#### Commit 1 - 로그인 기능 구현

```
echo "Login feature" > rebase-practice/login.txt

git add rebase-practice/login.txt
git commit -m "feature: 로그인 기능 구현"

git push -u origin practice/interactive-rebase
```

#### Commit 2 - 로그인 오류 수정

```
echo "Login bug fixed" >> rebase-practice/login.txt

git add rebase-practice/login.txt
git commit -m "fix: 로그인 오류 수정"

git push
```

#### Commit 3 - 오타 수정

```
echo "Typo fixed" >> rebase-practice/login.txt

git add rebase-practice/login.txt
git commit -m "fix: 오타 수정"

git push
```

#### Commit 4 - 회원가입 기능 구현

```
echo "Signup feature" > rebase-practice/signup.txt

git add rebase-practice/signup.txt
git commit -m "feat: 회원가입 구현"

git push
```

#### Commit 5 - 임시 디버그 파일

```
echo "Temporary debug" > rebase-practice/debug.txt

git add rebase-practice/debug.txt
git commit -m "chore: 임시 디버그 파일"

git push
```

### 3. 커밋 이력 확인

```
git status

git log --oneline -5
```

예상 결과:

```
e555555 chore: 임시 디버그 파일
d444444 feat: 회원가입 구현
c333333 fix: 오타 수정
b222222 fix: 로그인 오류 수정
a111111 feature: 로그인 기능 구현
```

이 시점에는 로컬과 원격에 동일한 5개 커밋이 존재한다.

### 4. Interactive Rebase 실행

최근 5개 커밋을 정리한다.

```
git rebase -i HEAD~5
```

Vim 편집기가 열리면 다음과 같이 표시된다.

```
pick a111111 feature: 로그인 기능 구현
pick b222222 fix: 로그인 오류 수정
pick c333333 fix: 오타 수정
pick d444444 feat: 회원가입 구현
pick e555555 chore: 임시 디버그 파일
```

다음과 같이 변경한다.

```
pick   a111111 feature: 로그인 기능 구현
fixup  b222222 fix: 로그인 오류 수정
squash c333333 fix: 오타 수정
reword d444444 feat: 회원가입 구현
drop   e555555 chore: 임시 디버그 파일
```

**각 명령어의 목적**

|명령어|작업|
|---|---|
|pick|로그인 기능 커밋 유지|
|fixup|로그인 오류 수정 내용을 첫 커밋에 합침|
|squash|오타 수정 내용을 합치고 메시지 편집|
|reword|회원가입 커밋 메시지 수정|
|drop|임시 디버그 커밋 제거|

### 5. Squash 메시지 편집

Rebase를 진행하면 다음과 같은 편집 화면이 나타난다.

```
# This is a combination of 3 commits.
# This is the 1st commit message:

feature: 로그인 기능 구현

# The commit message #2 will be skipped:

# fix: 로그인 오류 수정

# This is the commit message #3:

fix: 오타 수정
```

**메시지가 주석 처리되는 이유**

- 첫 번째 커밋은 `pick`이므로 메시지가 유지된다.
    
- 두 번째 커밋은 `fixup`이므로 메시지가 주석 처리된다.
    
- 세 번째 커밋은 `squash`이므로 메시지가 편집 대상으로 포함된다.
    

따라서 주석 처리되지 않은 메시지는 첫 번째와 세 번째 커밋 메시지다.

최종 커밋 메시지를 다음과 같이 수정한다.

```
feat: 로그인 기능 구현 및 오류 수정
```

저장하고 종료하면 다음 작업으로 진행한다.

### 6. Reword 메시지 수정

`reword`로 지정한 회원가입 커밋의 메시지 편집 화면이 열린다.

기존 메시지:

```
feat: 회원가입 구현
```

변경 메시지:

```
feat: 회원가입 기능 구현
```

저장 후 Rebase를 계속 진행한다.

### 7. Rebase 결과 확인

```
git log --oneline -5

git status
```

정상적으로 완료되었다면 실습 커밋 5개가 2개로 정리된다.

```
xxxxxxx feat: 회원가입 기능 구현
yyyyyyy feat: 로그인 기능 구현 및 오류 수정
```

**파일 확인**

```
ls rebase-practice

cat rebase-practice/login.txt
```

예상 결과:

```
login.txt
signup.txt
```

`debug.txt`는 `drop`으로 커밋을 제거했기 때문에 최종 작업 트리에서 사라진다.

### 8. 원격 저장소와 커밋 이력 비교

이미 5개 커밋을 GitHub에 Push한 상태이므로 Rebase 이후에는 로컬과 원격의 커밋 이력이 달라진다.

```
git status
```

로컬과 원격이 서로 다른 커밋을 보유하고 있다는 메시지가 나타날 수 있다.

커밋 이력을 비교하려면 다음 명령어를 사용한다.

```
git log --oneline --graph --decorate --all
```

또는 로컬에만 존재하는 커밋과 원격에만 존재하는 커밋을 구분할 수 있다.

```
# 로컬에만 존재하는 커밋
git log --oneline origin/practice/interactive-rebase..HEAD

# 원격 추적 브랜치에만 존재하는 커밋
git log --oneline HEAD..origin/practice/interactive-rebase
```

### 9. 일반 Push 시도

```
git push origin practice/interactive-rebase
```

Rebase로 기존 커밋 이력이 변경되었기 때문에 일반 Push는 `non-fast-forward` 오류로 거부된다.

이는 원격 브랜치의 기존 이력을 단순히 앞으로 이동시키는 방식으로 업데이트할 수 없기 때문이다.

### 10. Force-with-lease Push

실습용 개인 브랜치의 원격 커밋 이력을 재작성한다.

```
git push --force-with-lease origin practice/interactive-rebase
```

`--force-with-lease`는 예상한 원격 브랜치 상태가 유지되는지 확인한 후 강제 Push를 수행한다.

**주의**

- 다른 개발자가 함께 사용하는 브랜치에서는 신중하게 사용
    
- 원격의 기존 커밋 이력이 재작성됨
    
- 원격 브랜치에 다른 사람의 새로운 커밋이 있다면 덮어쓰지 않도록 확인
    
- `--force-with-lease`도 모든 협업 충돌을 자동으로 예방하는 것은 아님
    

### 11. 원격 반영 결과 확인

```
git fetch origin

git status

git log --oneline --graph --decorate -5
```

정상적으로 원격에 반영되었다면 로컬과 원격 브랜치가 동일한 커밋을 가리킨다.

```
xxxxxxx (HEAD -> practice/interactive-rebase,
         origin/practice/interactive-rebase)
         feat: 회원가입 기능 구현

yyyyyyy feat: 로그인 기능 구현 및 오류 수정
```

### 12. 실습 브랜치 정리

실습을 마쳤다면 원래 브랜치로 돌아간다.

```
git switch feature/jym-git-play
```

실습 브랜치가 더 이상 필요 없다면 삭제할 수 있다.

```
# 로컬 실습 브랜치 삭제
git branch -D practice/interactive-rebase

# 원격 실습 브랜치 삭제
git push origin --delete practice/interactive-rebase
```

`-D`는 병합되지 않은 브랜치도 강제로 삭제하므로 필요한 이력이 남아 있지 않은지 확인한 뒤 실행한다.

### 13. Rebase를 이용한 과거 커밋 메시지 수정

이미 생성한 커밋의 메시지를 수정할 때 `git rebase -i`의 `reword` 명령어를 사용한다.

가장 최근 커밋은 `git commit --amend`로 수정할 수 있지만, 과거 커밋은 Interactive Rebase를 사용해야 한다.

#### 1. 현재 커밋 이력 확인

```
git log --oneline -5
```

예시:

```
d444444 test: 로그인 테스트 추가
c333333 feat: JWT 인증 구현
b222222 fix: 회원가입 검증 오류
a111111 feat: 회원가입 API 구현
```

여기서 `fix: 회원가입 검증 오류`라는 메시지를 `fix: 회원가입 입력값 검증 및 예외 처리 개선`으로 변경한다.

#### 2. Interactive Rebase 실행

수정할 커밋이 최근 3개 안에 있으므로 다음 명령어를 실행한다.

```
git rebase -i HEAD~3
```

Vim 편집기가 열리면 다음과 같이 표시된다.

```
pick b222222 fix: 회원가입 검증 오류
pick c333333 feat: JWT 인증 구현
pick d444444 test: 로그인 테스트 추가
```

수정하려는 커밋의 `pick`을 `reword`로 변경한다.

```
reword b222222 fix: 회원가입 검증 오류
pick   c333333 feat: JWT 인증 구현
pick   d444444 test: 로그인 테스트 추가
```

Vim에서 `Esc` → `:wq`를 입력하여 저장하고 종료한다.

#### 3. 커밋 메시지 수정

Git이 해당 커밋의 메시지를 수정할 수 있도록 편집기를 다시 실행한다.

기존 메시지:

```
fix: 회원가입 검증 오류
```

변경 메시지:

```
fix: 회원가입 입력값 검증 및 예외 처리 개선
```

수정 후 저장하면 Rebase가 진행된다.

#### 4. 변경 결과 확인

```
git log --oneline -5
```

예상 결과:

```
xxxxxxx test: 로그인 테스트 추가
yyyyyyy feat: JWT 인증 구현
zzzzzzz fix: 회원가입 입력값 검증 및 예외 처리 개선
a111111 feat: 회원가입 API 구현
```

**주의할 점**

- `reword`는 커밋 메시지만 수정하며 파일 변경 내용은 유지한다.
    
- 메시지를 수정한 커밋과 이후 재적용되는 커밋의 해시가 변경된다.
    
- 수정 범위 이전의 커밋 해시는 유지된다.
    

#### 5. 이미 Push한 커밋이라면

원격 저장소에 이미 Push한 커밋을 수정했다면 로컬과 원격의 이력이 달라진다.

```
# 로컬과 원격 커밋 차이 확인
git status

# 개인 실습 브랜치의 원격 이력 갱신
git push --force-with-lease origin <브랜치명>
```

공유 브랜치에서는 다른 개발자에게 영향을 줄 수 있으므로 주의해야 한다.

#### 6. 가장 최근 커밋 메시지만 수정하는 경우

가장 최근 커밋은 Rebase 없이 `amend`를 사용할 수 있다.

```
# 메시지를 직접 지정
git commit --amend -m "feat: JWT 로그인 기능 구현"

# 편집기에서 메시지 수정
git commit --amend
```

`amend` 역시 기존 커밋을 새로운 커밋으로 대체하므로 커밋 해시가 변경된다.

|상황|명령어|
|---|---|
|가장 최근 커밋 메시지 수정|`git commit --amend`|
|과거 커밋 메시지 수정|`git rebase -i HEAD~N` → `reword`|
|여러 커밋 메시지 수정|여러 커밋을 `reword`로 지정|
|이미 Push한 개인 브랜치|수정 후 `git push --force-with-lease`|

**핵심:** `amend`는 가장 최근 커밋을 수정할 때, `reword`는 과거 커밋의 메시지를 수정할 때 사용한다.

---

## ✏️ 메모

### 실습에서 이해한 핵심

**1. Push한 커밋도 Rebase할 수 있다.**

원격 저장소에 이미 Push한 커밋이라도 로컬에서 Interactive Rebase를 수행할 수 있다.

다만 원격 이력을 갱신할 때 강제 Push가 필요할 수 있다.

**2. Fixup과 Squash는 메시지 처리 방식이 다르다.**

- Fixup: 변경 내용만 합치고 해당 커밋 메시지 폐기
    
- Squash: 변경 내용을 합치고 커밋 메시지 편집
    

**3. Rebase는 커밋 이력을 재작성한다.**

기존 커밋을 수정하면 새로운 커밋 해시가 생성될 수 있으며, 이후 커밋도 재작성될 수 있다.

**4. 개발 중 수시로 Push해도 된다.**

실무에서는 커밋을 모두 로컬에 쌓아두었다가 마지막에 Push해야 하는 것은 아니다.

PR에서 Squash Merge를 사용하는 경우에는 로컬 Interactive Rebase 없이도 PR의 변경 사항을 하나의 커밋으로 통합할 수 있다.

### Vim 단축키

|명령어|설명|
|---|---|
|`i`|입력 모드 진입|
|`Esc`|일반 모드 전환|
|`dd`|현재 줄 삭제|
|`5dd`|5줄 삭제|
|`:%d`|전체 줄 삭제|
|`ggVGd`|전체 선택 후 삭제|
|`u`|실행 취소|
|`:wq`|저장 후 종료|
|`:q!`|저장하지 않고 종료|

### 추가 학습할 내용

- `git rebase -i`의 `edit`을 이용한 과거 커밋 수정
    
- Rebase 중 충돌 발생 및 해결
    
- `git rebase --abort`로 작업 취소
    
- `git reflog`를 이용한 이전 커밋 복구
    
- GitHub Squash Merge와 Interactive Rebase 비교
    
- `git bisect`를 이용한 문제 커밋 추적
    

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../01 Permanent/rebase|rebase]]