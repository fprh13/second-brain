---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# reset vs restore

---

## 📄 본문

### 개념

`git reset`과 `git restore`는 Git에서 변경 사항을 되돌리는 명령어이다.

두 명령어는 스테이징 취소 등의 기능이 일부 겹치지만, 주요 목적과 영향을 미치는 범위가 다르다.

- **reset**: HEAD(커밋 위치)와 Index(Staging Area)를 재설정하는 명령어
- **restore**: Index 또는 Working Tree의 파일 내용을 복원하는 명령어

일반적으로 파일 단위의 복원에는 `restore`, 커밋 이력의 재설정에는 `reset`을 사용한다.

### Git의 3가지 영역

| 영역 | 설명 |
|---|---|
| HEAD | 현재 브랜치가 가리키는 커밋 |
| Index (Staging Area) | 다음 커밋에 포함할 변경 사항 |
| Working Tree | 실제 파일을 수정하는 작업 디렉터리 |

일반적인 작업 흐름은 다음과 같다.

```text
Working Tree
    │
    │ git add
    ▼
Index (Staging Area)
    │
    │ git commit
    ▼
Repository (HEAD)
```

`reset`은 HEAD와 Index를 중심으로 동작하며, `--hard` 옵션에서는 Working Tree까지 변경한다.

`restore`는 파일을 지정한 소스의 상태로 복원하며, 기본적으로 Working Tree에 적용된다.

### reset

`git reset`은 HEAD 또는 Index를 재설정하는 명령어이다.

커밋을 취소하거나 스테이징을 해제할 때 사용한다.

#### 주요 옵션

| 옵션 | HEAD | Index | Working Tree |
|---|---|---|---|
| `--soft` | 변경 | 유지 | 유지 |
| `--mixed` | 변경 | 변경 | 유지 |
| `--hard` | 변경 | 변경 | 변경 |

위 표는 커밋을 대상으로 `git reset <옵션> <commit>`을 실행하는 경우를 기준으로 한다.

#### --soft

```bash
git reset --soft HEAD~1
```

- HEAD를 이전 커밋으로 이동
- Index와 Working Tree 유지
- 취소된 커밋의 변경 사항을 스테이징된 상태로 유지

**사용 상황:** 마지막 커밋을 취소하고 변경 사항을 다시 커밋할 때

#### --mixed

```bash
git reset --mixed HEAD~1

# --mixed는 기본 옵션
git reset HEAD~1
```

- HEAD를 이전 커밋으로 이동
- Index를 해당 커밋 상태로 재설정
- Working Tree 유지
- 취소된 커밋의 변경 사항은 스테이징되지 않은 상태로 남음

**사용 상황:** 커밋을 취소하고 파일을 다시 선택하여 스테이징할 때

#### --hard

```bash
git reset --hard HEAD~1
```

- HEAD를 이전 커밋으로 이동
- Index를 해당 커밋 상태로 재설정
- Working Tree도 해당 커밋 상태로 변경
- 해당 범위의 미커밋 변경 사항이 삭제될 수 있음

**사용 상황:** 커밋과 관련 변경 사항을 모두 폐기할 때

> [!warning] 주의
> `--hard`는 추적 중인 파일의 미커밋 변경 사항을 삭제할 수 있다.
> 이미 원격 저장소에 공유한 커밋에 사용하는 것도 주의해야 한다.

#### 스테이징 취소

```bash
# 전체 스테이징 취소
git reset

# 특정 파일만 스테이징 취소
git reset HEAD README.md
```

파일 경로를 지정하는 형태의 `reset`은 HEAD를 이동시키지 않고 Index만 재설정한다.

### restore

`git restore`는 파일의 변경 사항을 복원하는 명령어이다.

Git 2.23부터 도입되었으며, 기존 `checkout`의 파일 복원 기능을 분리한 명령어이다.

#### 주요 옵션

| 옵션 | 설명 |
|---|---|
| `--staged` | Index의 파일 내용을 복원 |
| `--worktree` | Working Tree의 파일 내용을 복원 |
| `--source` | 복원할 기준 커밋 또는 트리 지정 |

기본적으로 `git restore <file>`은 Index의 내용을 기준으로 Working Tree를 복원한다.

`--staged`를 사용하면 기본 복원 기준은 HEAD가 된다.

#### Working Tree 복원

```bash
git restore README.md
```

- 지정한 파일의 스테이징되지 않은 변경 사항을 취소
- Index 상태를 기준으로 Working Tree 복원
- 스테이징된 변경 사항은 유지

#### 스테이징 취소

```bash
git restore --staged README.md

# 전체 스테이징 취소
git restore --staged .
```

- Index를 HEAD 상태로 복원
- Working Tree의 수정 내용은 유지
- HEAD의 커밋 위치는 변경하지 않음

#### 특정 커밋 기준으로 복원

```bash
git restore --source=HEAD~1 README.md
```

- 이전 커밋의 파일 내용을 Working Tree에 복원
- HEAD 자체는 이동하지 않음
- Index는 변경하지 않음

#### 스테이징과 파일 수정 모두 취소

```bash
git restore --source=HEAD --staged --worktree README.md
```

- Index와 Working Tree를 HEAD의 파일 내용으로 복원
- 해당 파일의 스테이징된 변경 사항과 작업 중인 변경 사항을 모두 폐기
- HEAD의 커밋 위치는 유지

### reset vs restore 비교

| 목적 | reset | restore |
|---|---|---|
| 스테이징 취소 | `git reset HEAD file` | `git restore --staged file` |
| Working Tree 복원 | `git reset --hard HEAD` | `git restore file` |
| 특정 파일을 HEAD 상태로 복원 | 경로 지정 reset과 추가 복원 필요 | `git restore --source=HEAD --staged --worktree file` |
| 마지막 커밋 취소 | `git reset --soft HEAD~1` | 불가능 |
| 커밋 취소 + 스테이징 취소 | `git reset HEAD~1` | 불가능 |
| 커밋과 변경 사항 모두 취소 | `git reset --hard HEAD~1` | 불가능 |

> [!note] 차이
> `git reset --hard HEAD`는 추적 파일 전체에 영향을 줄 수 있지만, `git restore file`은 지정한 파일의 Working Tree만 복원한다. 두 명령어는 영향 범위가 다르다.

### 실무 사용 기준

| 상황 | 권장 명령어 |
|---|---|
| `git add` 취소 | `git restore --staged .` |
| 수정 중인 파일 복원 | `git restore <file>` |
| 특정 파일의 모든 변경 사항 취소 | `git restore --source=HEAD --staged --worktree <file>` |
| 마지막 커밋 취소, 스테이징 유지 | `git reset --soft HEAD~1` |
| 마지막 커밋 취소, 수정 내용 유지 | `git reset HEAD~1` |
| 마지막 커밋과 변경 사항 폐기 | `git reset --hard HEAD~1` |
| 공유된 커밋을 안전하게 취소 | `git revert <commit>` |

### reset vs revert

`reset`과 `revert`도 커밋을 취소한다는 점에서 비슷하지만 방식이 다르다.

- **reset**: 브랜치가 가리키는 커밋 위치를 이동하여 이력을 재설정
- **revert**: 기존 커밋의 변경 사항을 반대로 적용하는 새로운 커밋 생성

```bash
# 커밋 이력을 재설정
git reset --soft HEAD~1

# 기존 이력을 유지하면서 변경 사항 취소
git revert HEAD
```

원격 저장소에 이미 공유한 커밋은 일반적으로 `revert`를 사용하는 것이 안전하다.

### 정리

- **restore**: 파일 복원 및 스테이징 취소
- **reset**: 커밋 위치 재설정 및 Index 초기화
- **revert**: 기존 이력을 유지하면서 커밋 변경 사항 취소

파일 단위의 작업에는 `restore`, 커밋 자체를 되돌리는 작업에는 `reset`을 우선 고려한다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[Git]]
