---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# rebase

---

## 📄 본문

### Rebase란?

Git Rebase는 **현재 브랜치의 커밋을 다른 커밋을 기반으로 다시 적용하여 커밋 이력을 재구성하는 기능**이다.

주로 다음 목적으로 사용한다.

1. Feature 브랜치를 최신 main 또는 develop 기준으로 업데이트
    
2. 커밋 이력을 선형적으로 정리
    
3. 여러 커밋을 하나로 합치기(Squash, Fixup)
    
4. 과거 커밋 메시지 수정(Reword)
    
5. 불필요한 커밋 제거(Drop)
    
6. 과거 커밋의 변경 내용 수정(Edit)
    

Rebase는 커밋을 재적용하는 과정에서 새로운 커밋을 생성할 수 있으며, 이때 기존 커밋 해시가 변경된다.

### Merge와 Rebase의 차이

두 명령어 모두 서로 다른 브랜치의 변경 사항을 통합할 때 사용하지만 커밋 이력을 처리하는 방식이 다르다.

#### Merge

기존 커밋 이력을 유지하면서 두 브랜치를 병합한다.

```
Before

main       A --- B --- C
                  \
feature            D --- E

After (feature에서 main을 merge)

main       A --- B --- C
                  \     \
feature            D --- E --- M
```

- 기존 커밋 해시 유지
    
- 브랜치의 분기 및 병합 이력 보존
    
- 일반적인 분기 병합에서는 Merge Commit 생성
    
- Fast-forward가 가능하면 Merge Commit 없이 병합 가능
    
- 공유 브랜치의 이력을 통합할 때 유용
    

#### Rebase

현재 브랜치의 커밋을 대상 브랜치의 최신 커밋 뒤에 재적용한다.

```
Before

main       A --- B --- C
                  \
feature            D --- E

After (feature에서 main을 rebase)

main       A --- B --- C
                      \
feature                D' --- E'
```

- 재적용한 커밋의 해시 변경
    
- 선형적인 커밋 이력 생성
    
- 일반적으로 Merge Commit을 새로 생성하지 않음
    
- 개인 Feature 브랜치의 이력 정리에 유용
    
- 공유된 커밋을 재작성할 때 주의 필요
    

|비교|Merge|Rebase|
|---|---|---|
|기존 커밋 해시|유지|재적용 커밋 변경|
|커밋 이력|분기 구조 보존|선형 구조|
|Merge Commit|생성 가능|일반적으로 생성하지 않음|
|충돌|병합 시 해결|커밋 재적용 중 해결|
|공유 브랜치|적합|이력 재작성 주의|
|주요 목적|이력 보존 및 통합|기반 변경 및 이력 정리|

### Rebase 사용법

#### 최신 main 브랜치 반영

Feature 브랜치에서 개발하는 동안 main에 새로운 커밋이 추가되었다면 다음과 같이 최신 변경 사항을 반영할 수 있다.

```
git switch feature/login

# 원격 저장소의 최신 정보 가져오기
git fetch origin

# 최신 main 기준으로 커밋 재적용
git rebase origin/main
```

`git fetch`는 원격 추적 브랜치를 업데이트하지만 현재 작업 브랜치에는 변경 사항을 병합하지 않는다.

`git rebase origin/main`은 현재 브랜치의 커밋 중 최신 main에 포함되지 않은 커밋을 재적용한다.

이미 Push한 커밋이 재작성되었다면 원격 브랜치를 갱신하기 위해 강제 Push가 필요할 수 있다.

### Interactive Rebase

`git rebase -i`는 과거 커밋을 직접 편집하거나 정리하는 기능이다.

```
# 최근 3개 커밋 편집
git rebase -i HEAD~3

# 최근 5개 커밋 편집
git rebase -i HEAD~5
```

편집기에는 선택한 커밋들이 오래된 순서부터 표시된다.

|명령어|축약|역할|
|---|---|---|
|pick|p|커밋 유지|
|reword|r|커밋 메시지 수정|
|edit|e|커밋에서 작업 중단, 내용 수정 가능|
|squash|s|이전 커밋에 합치고 메시지 편집|
|fixup|f|이전 커밋에 합치고 해당 메시지 폐기|
|drop|d|커밋 제거|

#### Squash와 Fixup

두 명령어 모두 여러 커밋을 하나로 합치는 기능이다.

**Squash**

```
pick   a111111 feat: 로그인 기능 구현
squash b222222 fix: 로그인 오류 수정
```

두 커밋을 합치면서 최종 커밋 메시지를 편집한다.

**Fixup**

```
pick  a111111 feat: 로그인 기능 구현
fixup b222222 fix: 로그인 오류 수정
```

두 커밋의 변경 내용을 합치지만 `fixup`으로 지정한 커밋의 메시지는 기본적으로 버린다.

따라서 단순한 수정 커밋을 기존 커밋에 포함할 때 유용하다.

#### Reword

과거 커밋 메시지만 변경하고 싶을 때 사용한다.

```
git rebase -i HEAD~3
```

```
reword a111111 feat: 로그인 기능
pick   b222222 test: 로그인 테스트
pick   c333333 fix: 예외 처리
```

저장하면 메시지 편집기가 열리며 새로운 메시지를 입력할 수 있다.

```
feat: JWT 기반 로그인 API 구현
```

메시지를 수정한 커밋과 그 이후에 재적용되는 커밋들의 해시가 변경된다.

#### Amend

가장 최근 커밋을 수정할 때는 Interactive Rebase 없이 `git commit --amend`를 사용할 수 있다.

```
# 최근 커밋 메시지 수정
git commit --amend -m "feat: JWT 로그인 API 구현"

# 최근 커밋 메시지를 편집기로 수정
git commit --amend
```

Amend도 기존 커밋을 새 커밋으로 대체하므로 해시가 변경된다.

### Rebase 충돌 해결

Rebase 과정에서 충돌이 발생하면 Git이 작업을 중단한다.

```
# 충돌 파일 확인
git status

# 충돌 해결 후 스테이징
git add <file>

# Rebase 계속 진행
git rebase --continue
```

기타 명령어:

```
# Rebase 작업 취소 및 시작 전 상태 복원
git rebase --abort

# 현재 재적용 중인 커밋 건너뛰기
git rebase --skip
```

`--skip`은 해당 커밋의 변경 사항이 누락될 수 있으므로 신중하게 사용한다.

### Push 이후 Rebase

이미 원격 저장소에 Push한 커밋도 Rebase할 수 있다.

다만 Rebase로 기존 커밋 이력을 재작성하면 로컬과 원격의 커밋 해시가 달라질 수 있다.

이 경우 일반적인 Push는 `non-fast-forward` 오류로 거부될 수 있다.

```
git push --force-with-lease origin feature/login
```

`--force-with-lease`는 예상한 원격 브랜치 상태가 유지되고 있을 때만 강제 Push를 허용한다.

일반적인 `--force`보다 안전하지만, 공유 브랜치의 이력을 재작성해도 된다는 의미는 아니다.

**주의 사항**

- Push하지 않은 개인 커밋은 비교적 자유롭게 Rebase 가능
    
- Push한 개인 브랜치는 이력 변경 후 강제 Push가 필요할 수 있음
    
- 여러 개발자가 공유하는 브랜치는 Rebase 전에 협의 필요
    
- main, develop처럼 공용으로 사용하는 브랜치의 공개된 이력은 일반적으로 재작성하지 않음
    

### 실무 Git 워크플로

실무에서는 모든 커밋을 로컬에 모아두었다가 마지막에 Push할 필요가 없다.

보통 다음과 같은 흐름을 사용한다.

```
Issue 생성
    ↓
Feature 브랜치 생성
    ↓
기능 구현
    ↓
Commit + Push 반복
    ↓
Draft PR 또는 PR 생성
    ↓
CI 및 코드 리뷰
    ↓
Merge
```

#### PR 병합 전략

|방식|특징|적합한 상황|
|---|---|---|
|Create a merge commit|개별 커밋과 병합 이력 보존|상세 이력 추적|
|Squash and merge|PR의 변경을 하나의 커밋으로 통합|PR 단위 관리|
|Rebase and merge|개별 커밋을 재적용하여 선형 이력 생성|커밋 단위 관리|

**Squash Merge 중심 워크플로**

개발 중 여러 번 Commit과 Push를 진행하고, PR 병합 시 GitHub에서 Squash and merge를 선택한다.

```
Feature 브랜치

A --- B --- C --- D

Squash Merge 이후 main

A --- S
```

`S`는 PR의 변경 사항을 통합한 새로운 커밋이다.

이 방식에서는 PR을 병합하기 전에 매번 Interactive Rebase를 수행할 필요가 없다.

다만 Feature 브랜치 자체의 커밋 이력이 정리되는 것은 아니다.

**Merge Commit 중심 워크플로**

개별 커밋의 이력을 유지하고 Merge Commit을 생성한다.

```
main       A ------------- M
            \             /
feature      B --- C --- D
```

각 커밋이 독립적으로 의미 있는 변경 사항이라면 상세 이력을 보존하는 장점이 있다.

### 개발 시 권장 사항

- 기능이나 변경 목적에 따라 의미 있는 단위로 Commit
    
- 작업 중간에도 Push하여 원격 백업 및 CI 활용
    
- 필요하면 Draft PR을 생성하여 진행 상황 공유
    
- PR은 가능한 한 작은 작업 단위로 작성
    
- Interactive Rebase는 필요한 경우에만 수행
    
- 개인 브랜치와 공유 브랜치의 이력 재작성 정책 구분
    
- 팀에서 정한 Merge 전략을 일관되게 사용
    

**Rebase를 많이 사용하는 것이 좋은 Git 사용법을 의미하지는 않는다.**

중요한 것은 변경 사항을 추적할 수 있는 커밋 이력과 리뷰하기 좋은 PR을 유지하는 것이다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]
- [[../12 Resources/rebase 실습|rebase 실습]]