---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# reflog

---

## 📄 본문

### 개념

`git reflog`는 **HEAD와 브랜치 등의 참조(Reference)가 변경된 이력을 로컬에 기록하고 조회하는 명령어**이다.

`git log`가 커밋의 연결 관계를 보여준다면, `git reflog`는 HEAD나 브랜치 참조가 과거에 어떤 커밋을 가리켰는지 확인할 수 있다.

따라서 `reset`, `rebase`, 브랜치 삭제 등으로 현재 커밋 이력에서 사라진 커밋을 찾고 복구할 때 유용하다.

- `git log`: 현재 커밋에서 도달 가능한 커밋 이력 조회
    
- `git reflog`: 참조가 이동하거나 변경된 이력 조회
    
- `reflog` 자체가 커밋을 복구하는 것은 아니며, **복구할 커밋을 찾는 역할**을 한다.
    

### 동작 원리

예를 들어 다음과 같은 커밋이 있다고 가정한다.

```
A (로그인) → B (JWT 인증) → C (Refresh Token)
                              ↑
                             HEAD
```

다음 명령어를 실행한다.

```
git reset --hard HEAD~1
```

결과:

```
A (로그인) → B (JWT 인증)     C (Refresh Token)
                ↑                ↑
               HEAD          참조되지 않을 수 있음
```

현재 브랜치의 `git log`에서는 C 커밋이 사라지지만, `reflog`에는 과거 HEAD가 C를 가리켰다는 기록이 남을 수 있다.

```
git reflog
```

```
a222222 HEAD@{0}: reset: moving to HEAD~1
b333333 HEAD@{1}: commit: feat: Refresh Token 구현
a222222 HEAD@{2}: commit: feat: JWT 인증 구현
```

`HEAD@{1}`을 통해 reset 이전 커밋을 찾을 수 있다.

### HEAD@{n} 의미

`HEAD@{n}`은 HEAD reflog의 특정 과거 기록을 나타낸다.

|표기|의미|
|---|---|
|`HEAD@{0}`|가장 최근 HEAD 기록|
|`HEAD@{1}`|바로 이전 HEAD 기록|
|`HEAD@{2}`|두 단계 이전 HEAD 기록|
|`HEAD@{n}`|n번째 이전 HEAD 기록|

주의할 점은 커밋 수가 아니라 **reflog 기록의 순서**를 기준으로 한다는 것이다.

또한 새 작업을 수행하면 reflog 순서가 바뀔 수 있다. 복구 대상이 확인되면 커밋 해시를 기록하거나 복구 브랜치를 만들어두는 것이 안전하다.

### 주요 명령어

|명령어|설명|
|---|---|
|`git reflog`|HEAD의 참조 이동 기록 조회|
|`git reflog -10`|최근 10개 기록|
|`git reflog --all`|모든 사용 가능한 참조의 reflog 조회|
|`git reflog show <branch>`|특정 브랜치의 reflog 조회|
|`git reflog --date=iso`|기록 시각 표시|
|`git show 'HEAD@{1}'`|과거 HEAD가 가리킨 커밋 확인|
|`git show <hash>`|특정 커밋 내용 확인|
|`git branch recovery <hash>`|복구 브랜치 생성|
|`git cherry-pick <hash>`|특정 커밋의 변경사항 재적용|
|`git reset --hard <hash>`|현재 브랜치를 특정 커밋으로 이동|

### 실무 활용 시나리오

#### 1. reset --hard로 커밋을 잃어버린 경우

```
git reset --hard HEAD~2
```

잘못된 reset으로 중요한 커밋이 현재 이력에서 사라졌을 때 사용한다.

```
git reflog
git show <복구할-커밋해시>
git branch recovery/reset <복구할-커밋해시>
```

복구 브랜치를 만든 후 필요에 따라 `merge`, `cherry-pick` 또는 `reset`으로 복구한다.

#### 2. Interactive Rebase에서 커밋을 삭제한 경우

`git rebase -i`에서 실수로 `drop`을 지정하거나 커밋을 누락한 상황이다.

```
git reflog
git show <누락된-커밋해시>
git cherry-pick <누락된-커밋해시>
```

전체 브랜치를 이전 상태로 되돌리지 않고 필요한 커밋만 다시 적용할 수 있다.

#### 3. 실수로 브랜치를 삭제한 경우

```
git branch -D feature/login
```

삭제한 브랜치의 마지막 커밋을 찾을 수 있다면 다음과 같이 복원한다.

```
git reflog --all
git branch feature/login <커밋해시>
```

단, 브랜치를 삭제하면 해당 브랜치 자체의 reflog도 삭제될 수 있다. 이 경우 HEAD 등 다른 reflog에 기록이 남아 있는지 확인해야 한다.

#### 4. 잘못된 merge 또는 pull 이후 복구

```
git reflog
```

merge 또는 pull 이전의 커밋을 찾고 복구 브랜치를 생성하여 당시 상태를 확인할 수 있다.

이미 공유된 브랜치라면 `reset`으로 공개 이력을 변경하기보다 `revert` 등 협업에 적합한 복구 방법을 검토한다.

#### 5. 복잡한 Git 작업의 이전 상태 추적

여러 브랜치에서 `switch`, `rebase`, `reset`, `cherry-pick`을 수행한 후 이전 작업 위치를 찾는 경우에도 활용한다.

```
git reflog --date=iso
```

### reflog와 다른 Git 명령어의 차이

|명령어|주요 목적|
|---|---|
|`log`|커밋 이력 확인|
|`reflog`|과거 참조 위치 추적|
|`reset`|HEAD 및 브랜치 위치 변경|
|`revert`|기존 변경을 취소하는 새 커밋 생성|
|`cherry-pick`|특정 커밋의 변경사항 적용|
|`branch`|브랜치 참조 생성 및 관리|
|`rebase`|커밋 재배치 및 이력 재작성|

`reflog`는 다른 명령어들과 달리 **변경된 Git 상태를 조사하고 복구 지점을 찾는 데 중점을 둔다.**

### reflog의 한계 및 주의사항

**1. 로컬 저장소의 기록**

- reflog는 기본적으로 각 로컬 저장소에서 관리된다.
    
- GitHub에 push한다고 로컬 reflog까지 공유되는 것은 아니다.
    
- 다른 개발자의 로컬 reflog를 직접 조회할 수 없다.
    

**2. 영구 보관되지 않음**

Git은 오래된 reflog 기록을 정리할 수 있다.

기본 만료 설정의 일반적인 값:

- `gc.reflogExpire`: 90일
    
- `gc.reflogExpireUnreachable`: 30일
    

이는 기본적인 만료 정책이며 설정과 도달 가능성에 따라 달라진다. 만료된 기록 및 참조되지 않는 커밋 객체는 Git의 정리 작업으로 삭제될 수 있다.

**3. 커밋하지 않은 변경사항은 복구가 보장되지 않음**

`git reset --hard`로 삭제된 미커밋 변경사항은 reflog에 기록되지 않는다.

reflog는 Git 참조의 변경 기록이지 모든 파일 편집 내역을 저장하는 기능이 아니다.

**4. 복구할 때 주의할 점**

```
git status
git reflog
git show <hash>
git branch recovery/<name> <hash>
```

가능하면 먼저 복구 브랜치를 생성하여 커밋을 보존한다.

`git reset --hard`는 현재 작업 디렉터리의 추적 파일 변경사항을 버릴 수 있으므로 신중하게 사용한다.

### 실무 활용 가이드

일반적인 개발 과정에서는 `reflog`를 매일 사용하지 않더라도, Git 작업 중 실수가 발생했을 때 우선적으로 확인할 가치가 있다.

권장 복구 순서:

1. 추가적인 Git 변경 작업을 최소화한다.
    
2. `git status`로 현재 상태를 확인한다.
    
3. `git reflog`로 이전 참조 위치를 조회한다.
    
4. `git show`로 복구할 커밋이 올바른지 확인한다.
    
5. 복구 브랜치를 생성해 커밋을 보존한다.
    
6. 상황에 맞게 `merge`, `cherry-pick`, `reset` 등으로 복구한다.
    
7. 테스트 및 커밋 이력을 검증한다.
    

**핵심: reflog는 Git에서 사라진 커밋을 찾기 위한 로컬 안전망이다.**

---

## 📚 참고 및 링크

- [[]]
---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]
- [[../12 Resources/reflog 실습|reflog 실습]]