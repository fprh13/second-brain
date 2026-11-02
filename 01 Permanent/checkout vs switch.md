---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# checkout vs switch

---

## 📄 본문

### 개념

`git checkout`과 `git switch`는 Git에서 브랜치를 이동할 때 사용하는 명령어이다.

기존 `checkout`은 브랜치 이동과 파일 복원이라는 서로 다른 기능을 담당했지만, Git 2.23(2019년)부터 역할을 분리하기 위해 `switch`와 `restore`가 도입되었다.

- **checkout**: 브랜치 이동 및 파일 복원 등 여러 기능을 제공하는 기존 명령어
- **switch**: 브랜치 생성 및 이동을 목적으로 분리된 명령어
- **restore**: 파일 복원을 목적으로 분리된 명령어

`checkout`은 현재도 정상적으로 사용할 수 있으며 폐기된 명령어는 아니다.

다만 명령어의 목적을 명확하게 표현하기 위해 브랜치 작업에는 `switch`, 파일 복원에는 `restore`를 사용하는 것이 좋다.

### checkout

`git checkout`은 브랜치 이동과 파일 복원 등의 기능을 제공하는 명령어이다.

#### 브랜치 이동

```bash
git checkout develop
```

현재 작업 브랜치를 `develop`으로 변경한다.

#### 브랜치 생성 및 이동

```bash
git checkout -b feature/login
```

새로운 `feature/login` 브랜치를 생성하면서 해당 브랜치로 이동한다.

#### 파일 복원

```bash
git checkout -- README.md
```

Index의 내용을 기준으로 `README.md`의 Working Tree를 복원한다.

스테이징되지 않은 변경 사항이 삭제될 수 있다.

### switch

`git switch`는 브랜치 생성 및 이동을 담당하는 명령어이다.

Git 2.23부터 도입되었으며, 기존 `checkout`의 브랜치 작업 기능을 분리하였다.

#### 브랜치 이동

```bash
git switch develop
```

기존 `develop` 브랜치로 이동한다.

#### 브랜치 생성 및 이동

```bash
git switch -c feature/login
```

새로운 브랜치를 생성하고 동시에 이동한다.

기존 `git checkout -b`와 동일한 목적이다.

#### 특정 브랜치를 기준으로 생성

```bash
git switch -c feature/login develop
```

현재 브랜치와 관계없이 `develop`을 기준으로 새로운 브랜치를 생성한다.

#### 직전 브랜치로 이동

```bash
git switch -
```

이전에 체크아웃했던 브랜치 또는 위치로 이동한다.

#### 원격 브랜치 추적

```bash
git fetch origin

git switch --track origin/feature/login
```

원격 브랜치를 추적하는 로컬 브랜치를 생성하고 이동한다.

동일한 이름의 로컬 브랜치가 이미 있다면 생성에 실패할 수 있다.

#### 특정 커밋으로 이동

```bash
git switch --detach HEAD~1
```

이전 커밋을 확인하기 위해 Detached HEAD 상태로 이동한다.

Detached HEAD는 특정 브랜치가 아닌 커밋을 직접 가리키는 상태이다.

이 상태에서 생성한 커밋은 브랜치에 연결되지 않을 수 있으므로, 작업 내용을 유지하려면 별도 브랜치를 생성해야 한다.

### 주요 옵션

| 옵션 | 설명 |
|---|---|
| `-c` | 새로운 브랜치를 생성하면서 이동 |
| `-C` | 브랜치를 생성하거나 기존 브랜치를 강제로 재설정하며 이동 |
| `--track` | 원격 브랜치 등의 추적 관계 설정 |
| `--detach` | Detached HEAD 상태로 이동 |
| `-` | 이전 브랜치 또는 체크아웃 위치로 이동 |
| `--discard-changes` | 로컬 변경 사항을 버리고 브랜치 이동 |

> [!warning] 주의
> `-C`는 기존 브랜치가 존재하면 해당 브랜치의 시작점을 강제로 재설정할 수 있다.
> `--discard-changes`는 로컬 변경 사항을 폐기할 수 있으므로 주의해야 한다.

### checkout vs switch 비교

| 목적 | checkout | switch |
|---|---|---|
| 기존 브랜치 이동 | `git checkout develop` | `git switch develop` |
| 브랜치 생성 및 이동 | `git checkout -b feature/login` | `git switch -c feature/login` |
| 브랜치 강제 재설정 및 이동 | `git checkout -B feature/login` | `git switch -C feature/login` |
| 특정 브랜치 기준 생성 | `git checkout -b feature/login develop` | `git switch -c feature/login develop` |
| 직전 브랜치 이동 | `git checkout -` | `git switch -` |
| Detached HEAD 이동 | `git checkout --detach HEAD~1` | `git switch --detach HEAD~1` |
| 파일 복원 | `git checkout -- file` | `git restore file` 사용 |

### checkout 대신 switch를 사용하는 이유

#### 역할 분리

기존 `checkout`은 브랜치 이동과 파일 복원이라는 서로 다른 기능을 제공했다.

```bash
# 브랜치 이동
git checkout develop

# 파일 복원
git checkout -- README.md
```

이러한 기능을 목적에 따라 분리한 것이 `switch`와 `restore`이다.

```bash
# 브랜치 이동
git switch develop

# 파일 복원
git restore README.md
```

명령어만 보더라도 작업 의도를 파악하기 쉽다.

#### 실수 방지

`checkout`은 인자에 따라 브랜치 이동이나 파일 복원으로 동작할 수 있다.

반면 `switch`는 브랜치 작업에 집중하므로 명령어의 의미가 명확하다.

또한 `switch`는 일반적으로 로컬 변경 사항이 손실될 수 있는 브랜치 이동을 거부한다. 단, 강제 변경 옵션을 사용하면 변경 사항이 삭제될 수 있다.

#### 성능 차이

`checkout`과 `switch`를 구분하는 주된 이유는 성능이 아니라 역할의 명확성과 사용 편의성이다.

`switch`가 `checkout`보다 항상 빠르거나 성능상 우수한 것은 아니다.

### 실무 사용 기준

| 상황 | 권장 명령어 |
|---|---|
| develop 브랜치 이동 | `git switch develop` |
| feature 브랜치 생성 | `git switch -c feature/login` |
| develop 기준 feature 브랜치 생성 | `git switch -c feature/login develop` |
| 직전 브랜치로 복귀 | `git switch -` |
| 원격 브랜치 추적 | `git switch --track origin/feature/login` |
| 파일 수정 취소 | `git restore <file>` |
| 스테이징 취소 | `git restore --staged <file>` |

### Git Worktree와의 차이

`switch`는 현재 작업 디렉터리에서 브랜치를 변경한다.

반면 `git worktree`는 하나의 Git 저장소에서 여러 작업 디렉터리를 생성하여 서로 다른 브랜치를 동시에 작업할 수 있도록 한다.

```bash
# 현재 작업 디렉터리에서 브랜치 변경
git switch feature/login

# 별도 작업 디렉터리와 브랜치 생성
git worktree add -b feature/login ../feature-login develop
```

Git Worktree는 여러 기능을 병렬로 개발하거나 AI 코딩 에이전트별로 독립적인 작업 환경을 구성할 때 유용하다.

일반적으로 동일한 브랜치를 여러 Worktree에서 동시에 체크아웃하는 것은 제한된다.

### 정리

- **checkout**: 브랜치 이동과 파일 복원 등을 지원하는 기존 명령어
- **switch**: 브랜치 생성 및 이동
- **restore**: 파일 복원 및 스테이징 취소
- **worktree**: 여러 작업 디렉터리에서 브랜치를 병렬로 작업

브랜치 작업에는 `switch`, 파일 복원에는 `restore`를 우선 사용한다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[Git]]
