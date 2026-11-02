---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# diff

---

## 📄 본문

### Git Diff란?

`git diff`는 Git에서 파일이나 브랜치 간의 **변경 사항을 비교하고 확인하는 명령어**이다.

코드의 추가, 삭제, 수정 내용을 확인할 수 있으며, 코드 리뷰, 리팩터링, 커밋 전 검토, 브랜치 병합 등에 활용한다.

- `git status`: 어떤 파일이 변경되었는지 확인
- `git diff`: 파일의 어떤 내용이 변경되었는지 확인
- `git log`: 어떤 커밋이 기록되었는지 확인

### Git의 세 가지 영역

Git은 파일의 상태를 크게 세 가지 영역으로 관리한다.

| 영역 | 설명 |
|---|---|
| Working Directory | 현재 작업 중인 파일이 존재하는 영역 |
| Staging Area (Index) | 다음 커밋에 포함할 변경 사항을 준비하는 영역 |
| Repository (HEAD) | 마지막 커밋을 기준으로 기록된 파일 상태 |

`git diff`는 비교 대상에 따라 서로 다른 영역의 변경 사항을 확인한다.

### 주요 명령어

| 명령어 | 설명 |
|---|---|
| `git diff` | Working Directory와 Staging Area 비교 |
| `git diff --staged` | Staging Area와 HEAD 비교 |
| `git diff HEAD` | Working Directory와 HEAD 비교 |
| `git diff --stat` | 변경된 파일과 추가·삭제 줄 수 요약 |
| `git diff --name-only` | 변경된 파일 이름만 출력 |
| `git diff --check` | 공백 오류 등 확인 |
| `git diff A B` | 두 브랜치 또는 커밋의 파일 상태 비교 |
| `git diff A...B` | 공통 조상부터 B까지의 변경 사항 비교 |
| `git diff HEAD~1 HEAD` | 최근 두 커밋 사이의 변경 사항 비교 |
| `git diff -- 파일경로` | 특정 파일의 변경 사항만 확인 |

#### 스테이징 전후 비교

```bash
# 스테이징되지 않은 변경 사항
git diff

# 파일 스테이징
git add CourseService.java

# 스테이징된 변경 사항
git diff --staged

# 마지막 커밋 이후 전체 변경 사항
git diff HEAD
```

**주의 사항**

- `git diff`는 스테이징하지 않은 추적 파일의 변경 사항을 보여준다.
- `git add` 이후에는 해당 변경 사항이 `git diff --staged`에 나타난다.
- 새로 생성한 Untracked 파일은 기본 `git diff`에 나타나지 않는다.
- 변경 사항이 없으면 일반적으로 아무것도 출력되지 않는다.

### Diff 결과 해석

```diff
- if (course.getCapacity() <= 0) {
-     throw new RuntimeException("정원 초과");
- }
+ if (course.isFull()) {
+     throw new ConflictException("정원 초과");
+ }
```

| 기호 | 의미 |
|---|---|
| `+` | 추가된 코드 |
| `-` | 삭제된 코드 |
| `@@` | 변경된 코드 영역(Hunk)의 위치 |
| `---` | 비교 대상의 이전 파일 |
| `+++` | 비교 대상의 새로운 파일 |

수정된 코드는 일반적으로 기존 코드의 삭제(`-`)와 새로운 코드의 추가(`+`)로 표현된다.

### 브랜치 간 변경 사항 비교

서로 다른 브랜치에서 작업한 코드를 비교할 때 사용한다.

```bash
# 두 브랜치의 현재 파일 상태 비교
git diff develop feature/login

# 공통 조상부터 feature/login까지의 변경 사항
git diff develop...feature/login

# 변경된 파일 목록만 확인
git diff --name-only develop...feature/login

# 변경 통계 확인
git diff --stat develop...feature/login
```

#### 두 점(..)과 세 점(...)의 차이

| 구문 | 의미 |
|---|---|
| `git diff A B` | A와 B의 현재 파일 상태를 비교 |
| `git diff A..B` | `git diff A B`와 동일 |
| `git diff A...B` | A와 B의 공통 조상을 기준으로 B의 변경 사항 비교 |

기능 브랜치에서 어떤 코드를 변경했는지 확인할 때는 `git diff develop...feature/login` 형태가 유용하다.

단, 브랜치 비교는 커밋된 상태를 기준으로 하므로 아직 커밋하지 않은 변경 사항은 해당 Worktree에서 별도로 확인해야 한다.

### Worktree 및 AI 에이전트 개발에서 활용

Git Worktree를 이용하면 여러 에이전트가 서로 다른 브랜치에서 독립적으로 작업할 수 있다.

각 에이전트의 작업이 완료되면 병합하기 전에 변경 사항을 검토한다.

```bash
# Agent A 변경 사항 확인
git diff develop...feature/refactor-a

# Agent B 변경 사항 확인
git diff develop...feature/refactor-b

# 각 에이전트의 변경 파일 목록 확인
git diff --name-only develop...feature/refactor-a
git diff --name-only develop...feature/refactor-b
```

변경된 파일 목록과 코드 차이를 비교하여 중복 수정, 의도하지 않은 변경, 잠재적인 충돌 등을 검토한다.

**Git Diff는 변경 사항을 비교하는 명령어이며, 실제 병합이나 충돌 해결을 수행하지는 않는다.**

### 실무 사용 흐름

```bash
# 1. 작업 상태 확인
git status

# 2. 변경 사항 검토
git diff

# 3. 스테이징
git add .

# 4. 커밋 대상 최종 검토
git diff --staged

# 5. 커밋
git commit -m "refactor: 강의 서비스 로직 개선"
```

AI 에이전트가 코드를 수정한 경우에도 동일한 흐름을 적용할 수 있다.

특히 커밋이나 병합 전에 `git diff`를 확인하면 의도하지 않은 코드 변경을 발견하는 데 도움이 된다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[Git]]