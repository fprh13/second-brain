---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# worktree 실습

---

## 📄 본문

### 실습 목적

Git Worktree를 사용하여 하나의 Git 저장소에서 여러 브랜치를 독립적인 작업 디렉터리로 관리하고, 각 Worktree에서 작업한 내용을 하나의 브랜치로 병합하는 과정을 학습한다.

**실습 목표**

1. 여러 Worktree 생성 및 관리
2. Worktree별 독립적인 파일 수정과 커밋
3. 서로 다른 브랜치의 변경 사항 병합
4. 동일 파일 수정으로 Merge Conflict 발생 및 해결
5. 실습 종료 후 Worktree와 브랜치 정리

### 1. Worktree 생성

기존 저장소의 `feature/jym-git-play` 브랜치를 기준으로 두 개의 Worktree를 생성한다.

```bash
git worktree list

git worktree add -b feature/first-git-worktree ../first_worktree feature/jym-git-play

git worktree add -b feature/second-git-worktree ../second_worktree feature/jym-git-play
```

**명령어 구성**

| 명령어 | 설명 |
|---|---|
| `git worktree add` | 새로운 작업 디렉터리 생성 |
| `-b` | 새로운 브랜치를 생성하고 체크아웃 |
| `feature/first-git-worktree` | 생성할 브랜치 이름 |
| `../first_worktree` | Worktree가 생성될 디렉터리 경로 |
| `feature/jym-git-play` | 새 브랜치의 시작 커밋을 지정하는 기준 브랜치 |

`../first_worktree`는 현재 디렉터리의 상위 디렉터리에 `first_worktree` 폴더를 생성한다는 의미이다.

**생성 결과**

```text
Repository/
├── chanmu-dev-lab-playground/  # feature/jym-git-play
├── first_worktree/             # feature/first-git-worktree
└── second_worktree/            # feature/second-git-worktree
```

각 Worktree는 동일한 Git 저장소와 커밋 이력을 공유하지만, 작업 파일과 체크아웃된 브랜치는 독립적으로 관리된다.

생성 직후 세 브랜치는 모두 동일한 커밋 `4fe289f`를 가리킨다.

### 2. Worktree 상태 확인

```bash
git worktree list
git worktree list --verbose
git branch --show-current
```

**확인된 결과**

```text
chanmu-dev-lab-playground  4fe289f [feature/jym-git-play]
first_worktree             4fe289f [feature/first-git-worktree]
second_worktree            4fe289f [feature/second-git-worktree]
```

Worktree를 생성한다고 기존 파일이 이동하거나 분할되는 것은 아니다.

각 Worktree에는 해당 커밋에 포함된 프로젝트 파일이 독립적으로 체크아웃된다.

### 3. 독립적인 기능 개발 및 커밋

첫 번째 Worktree에서는 로그인 기능을, 두 번째 Worktree에서는 회원가입 기능을 구현했다고 가정한다.

**첫 번째 Worktree**

```bash
cd ../first_worktree

echo "로그인 기능 구현 완료" > login.txt

git add login.txt
git commit -m "feat: 로그인 기능 추가"
```

**두 번째 Worktree**

```bash
cd ../second_worktree

echo "회원가입 기능 구현 완료" > signup.txt

git add signup.txt
git commit -m "feat: 회원가입 기능 추가"
```

각 Worktree에서 생성한 파일과 커밋은 다른 Worktree의 작업 디렉터리에 즉시 반영되지 않는다.

변경 사항을 통합하려면 브랜치 병합이 필요하다.

### 4. 브랜치 병합

메인 작업 디렉터리로 이동하여 두 브랜치를 순서대로 병합한다.

```bash
cd ../chanmu-dev-lab-playground

git branch --show-current

git merge feature/first-git-worktree
git merge feature/second-git-worktree
```

**병합 결과 확인**

```bash
ls login.txt signup.txt

git log --oneline --graph --all --decorate -10
```

서로 다른 파일을 수정했기 때문에 일반적으로 충돌 없이 병합된다.

첫 번째 병합은 Fast-forward로 진행될 수 있으며, 두 번째 병합은 분기된 커밋 이력을 통합하는 Merge Commit을 생성할 수 있다.

| 병합 방식 | 설명 |
|---|---|
| Fast-forward | 현재 브랜치 포인터만 앞으로 이동 |
| 3-way Merge | 공통 조상을 기준으로 두 브랜치의 변경 사항을 통합 |
| Squash Merge | 여러 커밋의 변경 사항을 하나의 커밋으로 통합 |

### 5. Merge Conflict 발생 실습

두 Worktree에서 동일한 파일의 동일한 부분을 다르게 수정하여 의도적으로 충돌을 발생시킨다.

**① 메인 브랜치에서 공통 파일 생성**

```bash
echo "version=1" > config.txt

git add config.txt
git commit -m "chore: 공통 설정 파일 추가"
```

**② 두 Worktree에 최신 변경 사항 반영**

```bash
cd ../first_worktree
git merge feature/jym-git-play

cd ../second_worktree
git merge feature/jym-git-play
```

**③ 첫 번째 Worktree에서 수정**

```bash
cd ../first_worktree

echo "version=2-first" > config.txt

git add config.txt
git commit -m "feat: 첫 번째 설정 변경"
```

**④ 두 번째 Worktree에서 수정**

```bash
cd ../second_worktree

echo "version=2-second" > config.txt

git add config.txt
git commit -m "feat: 두 번째 설정 변경"
```

**⑤ 메인 브랜치에서 병합**

```bash
cd ../chanmu-dev-lab-playground

git merge feature/first-git-worktree
git merge feature/second-git-worktree
```

두 번째 병합 과정에서 다음과 같은 충돌이 발생한다.

```text
CONFLICT (content): Merge conflict in config.txt
Automatic merge failed; fix conflicts and then commit the result.
```

**충돌이 발생한 파일**

```text
<<<<<<< HEAD
version=2-first
=======
version=2-second
>>>>>>> feature/second-git-worktree
```

- `HEAD`: 현재 브랜치의 변경 내용
- `=======`: 충돌 영역의 구분선
- `>>>>>>>`: 병합하려는 브랜치의 변경 내용

### 6. Merge Conflict 해결

충돌한 파일을 열어 최종적으로 사용할 내용을 직접 결정한다.

```text
version=3-merged
```

충돌 표시를 제거하고 파일을 저장한 뒤 병합을 완료한다.

```bash
git status

git add config.txt
git commit -m "merge: Worktree 설정 충돌 해결"
```

IntelliJ에서는 Merge Conflicts 기능을 통해 양쪽 변경 사항을 비교하고 원하는 내용을 선택할 수 있다.

충돌 해결 시 중요한 것은 단순히 Git 충돌 표시를 제거하는 것이 아니라 **양쪽 브랜치의 의도와 비즈니스 로직이 올바르게 통합되었는지 확인하는 것**이다.

### 7. Worktree 정리

실습을 마치고 모든 변경 사항이 정상적으로 병합되었는지 확인한다.

```bash
git status
git log --oneline --graph --all --decorate -10
git worktree list
```

Worktree를 제거한다.

```bash
git worktree remove ../first_worktree
git worktree remove ../second_worktree
```

Worktree 제거는 작업 디렉터리를 삭제하는 것이며, 브랜치와 커밋 이력은 유지된다.

병합된 브랜치까지 삭제하려면 다음 명령어를 사용한다.

```bash
git branch -d feature/first-git-worktree
git branch -d feature/second-git-worktree
```

`-d`는 병합 여부를 검사하는 안전한 삭제 옵션이다. 강제 삭제 옵션인 `-D`는 미병합 커밋이 있을 수 있으므로 주의해야 한다.

### 8. Worktree와 일반 브랜치의 차이

| 구분 | 일반 브랜치 전환 | Git Worktree |
|---|---|---|
| 작업 디렉터리 | 하나를 공유 | 각각 독립 |
| 브랜치 전환 | `git switch` 필요 | 디렉터리 이동 |
| 동시 작업 | 작업 파일 충돌 가능 | 서로 독립적으로 수정 가능 |
| Git 커밋 이력 | 공유 | 공유 |
| 병합 방식 | `git merge` | `git merge` |
| AI 에이전트 병렬 작업 | 작업 공간 충돌 위험 | 에이전트별 작업 공간 분리 가능 |

Worktree는 독립된 Git 저장소를 여러 개 만드는 기능이 아니다.

하나의 저장소를 공유하면서 작업 디렉터리를 분리하는 기능이다.

따라서 같은 로컬 저장소에 속한 Worktree끼리 병합할 때는 원격 저장소에서 변경 사항을 가져오는 `git fetch`나 `git pull`이 필요하지 않다.

### 9. 실습 커밋 정리 및 삭제

Worktree에서 여러 번 커밋하고 병합하는 실습을 진행하면 커밋 이력이 복잡해질 수 있다.

Git에서는 `reset`, `rebase`, `revert` 등을 이용하여 불필요한 커밋을 삭제하거나 하나로 합칠 수 있다.

#### 커밋 정리 방법

| 명령어 | 설명 | 사용 목적 |
|---|---|---|
| `git reset --hard` | 특정 커밋으로 이동하고 이후 변경 사항 제거 | 실습 기록과 파일 모두 제거 |
| `git reset --soft` | 특정 커밋으로 이동하되 변경 사항은 스테이징 상태로 유지 | 여러 커밋을 하나로 합치기 |
| `git rebase -i` | 커밋을 선택적으로 수정·삭제·합치기 | 커밋 이력 정리 |
| `git revert` | 기존 커밋을 취소하는 새로운 커밋 생성 | 공유된 커밋의 변경 사항 취소 |

#### 1. 실습 전 상태로 되돌리기

먼저 현재 브랜치와 커밋 이력을 확인한다.

```bash
git status
git log --oneline -10
```

필요하다면 백업 브랜치를 생성한다.

```bash
git branch backup/jym-git-play
```

실습 시작 전 커밋인 `4fe289f`로 되돌린다.

```bash
git reset --hard 4fe289f
```

- 현재 브랜치가 지정한 커밋으로 이동한다.
- 이후 커밋의 변경 사항이 현재 작업 디렉터리에서 제거된다.
- 다른 브랜치나 Worktree가 참조하는 커밋은 유지된다.
- 미커밋 변경 사항도 삭제될 수 있으므로 주의해야 한다.

#### 2. 여러 커밋을 하나로 합치기

실습 결과 파일은 유지하고 커밋 이력만 정리하려면 `--soft` 옵션을 사용한다.

```bash
git reset --soft 4fe289f
git commit -m "test: Git Worktree 실습"
```

`4fe289f` 이후의 변경 사항이 스테이징 상태로 유지되므로 하나의 새로운 커밋으로 정리할 수 있다.

#### 3. 특정 커밋만 선택적으로 정리하기

```bash
git rebase -i 4fe289f
```

편집기에서 커밋별 작업을 지정한다.

| 명령 | 역할 |
|---|---|
| `pick` | 커밋 유지 |
| `reword` | 커밋 메시지 변경 |
| `edit` | 커밋 수정 |
| `squash` | 이전 커밋과 합치고 메시지 편집 |
| `fixup` | 이전 커밋과 합치고 메시지 폐기 |
| `drop` | 커밋 제거 |

단, Merge Commit이 포함된 이력은 일반적인 `rebase -i` 과정에서 병합 구조가 재작성될 수 있다. 병합 구조까지 유지하려면 `--rebase-merges` 옵션을 검토한다.

#### 4. 원격 저장소에 Push한 경우

이미 원격 저장소에 공유된 커밋은 이력을 재작성하기보다 `git revert`로 변경 사항을 취소하는 것이 안전하다.

개인 실습 브랜치에서 이력을 정리하고 원격에도 반영해야 한다면 다음 명령어를 사용할 수 있다.

```bash
git push --force-with-lease origin feature/jym-git-play
```

`--force-with-lease`는 예상하지 못한 원격 변경 사항을 덮어쓰는 위험을 줄여주지만, 공유 브랜치의 이력을 재작성한다는 점은 동일하다.

#### 주의 사항

- `reset`은 현재 체크아웃된 브랜치에 영향을 준다.
- `reset --hard` 실행 전 `git status`로 미커밋 변경 사항을 확인한다.
- 다른 Worktree의 브랜치와 커밋은 자동으로 삭제되지 않는다.
- 브랜치를 삭제하기 전에 필요한 변경 사항이 병합되었는지 확인한다.
- 협업 브랜치에서는 이력 재작성보다 `revert`를 우선 고려한다.

---

## ✏️ 메모

### 실습에서 기억할 내용

- Worktree를 생성하면 프로젝트 전체가 별도의 디렉터리에 체크아웃된다.
- 각 Worktree는 독립적인 브랜치와 작업 파일을 가진다.
- 다른 Worktree의 커밋은 자동으로 현재 작업 파일에 반영되지 않는다.
- Worktree에서 작업한 변경 사항도 일반 Git 브랜치와 동일하게 병합한다.
- 동일 파일을 수정했다고 반드시 충돌하는 것은 아니며, 동일한 영역을 서로 다르게 수정했을 때 충돌할 가능성이 높다.
- Worktree를 제거해도 커밋과 브랜치는 자동으로 삭제되지 않는다.
- 여러 Worktree에서 같은 로컬 브랜치를 동시에 체크아웃하는 것은 기본적으로 제한된다.

### AI 에이전트 병렬 개발 활용

Herdr와 Codex, Antigravity를 이용하여 다음과 같은 구조로 확장할 수 있다.

```text
Main Worktree
  └── Integrator
       ├── Worktree A → Codex (기능 A 구현)
       └── Worktree B → Antigravity (기능 B 구현)
```

각 에이전트가 독립된 Worktree에서 개발하고 커밋한 뒤 통합 담당자가 브랜치를 병합하고 테스트를 수행한다.

이때 Git Worktree는 파일 작업 공간을 분리하지만, 공유 DB나 Docker 컨테이너, 서버 포트 같은 외부 실행 환경까지 자동으로 분리하지는 않는다.

### 추가 실습 과제

- [ ] 서로 다른 파일을 수정하고 병합
- [ ] 동일 파일의 동일한 줄을 수정해 충돌 발생
- [ ] IntelliJ Merge Conflicts로 충돌 해결
- [ ] `git merge --no-ff`로 Merge Commit 생성
- [ ] `git merge --squash`로 변경 사항 통합
- [ ] `git rebase`와 `git merge` 결과 비교
- [ ] Herdr에서 Worktree별 AI 에이전트 실행
- [ ] 병합 후 Gradle 테스트 실행

---

## 📚 참고 및 링크
- [[]]

---

## 🔗 관련 노트
- [[../01 Permanent/worktree|worktree]]