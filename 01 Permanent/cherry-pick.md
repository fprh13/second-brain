---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# cherry-pick

---

## 📄 본문

### cherry-pick이란?

`git cherry-pick`은 **다른 브랜치에 존재하는 특정 커밋을 선택하여 현재 브랜치에 적용하는 Git 명령어**이다.

브랜치 전체를 병합하는 `merge`나 커밋의 기반을 변경하는 `rebase`와 달리, 원하는 커밋만 선택적으로 가져올 수 있다.

기존 커밋을 이동시키는 것이 아니라, 해당 커밋의 변경 사항을 현재 브랜치에 적용하여 **새로운 커밋을 생성**한다.

따라서 원본 커밋과 새로 생성된 커밋은 일반적으로 서로 다른 커밋 해시를 가진다.

### 동작 원리

```
[Cherry-pick 이전]

      A --- B --- C    feature
     /
O --- D --- E          main


[main에서 B 커밋 Cherry-pick]

      A --- B --- C    feature
     /
O --- D --- E --- B'   main
```

- `B`: 원본 커밋
    
- `B'`: 동일한 변경 사항을 적용하여 새롭게 생성한 커밋
    
- `C`: 선택하지 않았으므로 main에 반영되지 않음
    

### 기본 사용법

#### 특정 커밋 적용

```
git switch main
git cherry-pick <commit-hash>
```

현재 브랜치에 지정한 커밋의 변경 사항을 적용한다.

#### 여러 커밋 적용

```
git cherry-pick <hash-A> <hash-B>
```

지정한 커밋들을 순서대로 적용한다.

#### 연속된 커밋 적용

```
git cherry-pick A^..B
```

- `A^..B`: A부터 B까지 포함하여 적용
    
- `A..B`: A를 제외하고 B까지 적용
    

단, A와 B는 의도한 조상 관계의 커밋이어야 한다.

#### 원본 커밋 정보 기록

```
git cherry-pick -x <commit-hash>
```

새로운 커밋 메시지에 원본 커밋 해시를 기록한다.

```
(cherry picked from commit abc123...)
```

릴리스 브랜치나 운영 브랜치에 수정 사항을 반영할 때 변경 사항의 출처를 추적하기 좋다.

#### 커밋하지 않고 변경 사항만 적용

```
git cherry-pick --no-commit <commit-hash>
```

- 변경 사항을 현재 작업 트리와 인덱스에 적용
    
- 자동 커밋을 생성하지 않음
    
- 변경 사항을 검토하거나 수정한 후 직접 커밋 가능
    

기존 작업 내용이 섞이지 않도록 깨끗한 작업 트리에서 사용하는 것이 좋다.

### 충돌 해결

Cherry-pick도 `merge`, `rebase`와 마찬가지로 충돌이 발생할 수 있다.

특히 서로 다른 브랜치에서 같은 파일의 동일한 부분을 수정한 경우 충돌 가능성이 높다.

#### 충돌 발생 시

```
git cherry-pick <commit-hash>
```

```
CONFLICT (content): Merge conflict in config.txt
error: could not apply ...
```

충돌이 발생하면 Git이 작업을 중단한다.

#### 해결 과정

1. `git status`로 충돌 파일 확인
    
2. 충돌 파일을 열어 충돌 마커 확인
    
3. 원하는 변경 사항으로 수정
    
4. `git add`로 해결 완료 표시
    
5. `git cherry-pick --continue`로 작업 재개
    

```
git status

# 충돌 파일 수정 후
git add config.txt

git cherry-pick --continue
```

#### Cherry-pick 취소

```
git cherry-pick --abort
```

진행 중인 Cherry-pick 작업을 취소하고 작업 시작 전 상태로 복구한다.

#### 현재 커밋 건너뛰기

```
git cherry-pick --skip
```

여러 커밋을 적용하는 도중 현재 커밋을 건너뛰고 다음 커밋으로 진행한다.

### 주요 명령어 정리

|명령어|설명|
|---|---|
|`git cherry-pick <hash>`|특정 커밋 적용|
|`git cherry-pick A B`|여러 커밋을 순서대로 적용|
|`git cherry-pick A^..B`|A부터 B까지 연속된 커밋 적용|
|`git cherry-pick -x <hash>`|원본 커밋 해시 기록|
|`git cherry-pick -n <hash>`|자동 커밋 없이 변경 사항 적용|
|`git cherry-pick --continue`|충돌 해결 후 작업 재개|
|`git cherry-pick --abort`|작업 취소|
|`git cherry-pick --skip`|현재 커밋 건너뛰기|
|`git log --oneline --all --graph`|전체 브랜치의 커밋 그래프 확인|

### merge, rebase, cherry-pick 비교

|구분|merge|rebase|cherry-pick|
|---|---|---|---|
|목적|브랜치 변경 이력 통합|커밋 기반 변경|특정 커밋 선택 적용|
|적용 범위|병합 대상 브랜치의 변경 이력|선택한 커밋 범위|지정한 커밋|
|기존 이력|보존|재작성 가능|원본 이력 보존|
|새 커밋|병합 커밋이 생길 수 있음|재적용 커밋 생성|새 커밋 생성|
|주요 상황|기능 브랜치 병합|커밋 이력 정리|일부 기능 및 버그 수정 반영|

### 실무 활용 사례

#### 운영 환경 긴급 버그 수정

`develop` 브랜치에서 버그를 수정했지만 해당 브랜치에는 아직 배포할 수 없는 신규 기능들이 포함되어 있는 경우이다.

```
develop
  ├── 신규 기능 A
  ├── 버그 수정 B
  └── 신규 기능 C

release
  └── 버그 수정 B만 반영
```

```
git switch release
git cherry-pick -x <bugfix-commit-hash>
```

신규 기능을 제외하고 필요한 버그 수정만 반영할 수 있다.

#### 다른 기능 브랜치의 일부 변경 사항 활용

다른 개발자의 기능 브랜치에 있는 공통 유틸리티나 특정 수정 사항만 필요한 경우에도 활용할 수 있다.

단, 해당 커밋이 이전 커밋의 변경 사항에 의존한다면 단독으로 적용했을 때 컴파일 오류나 테스트 실패가 발생할 수 있으므로 주의해야 한다.

### 사용 시 주의사항

- Cherry-pick은 기존 커밋을 이동시키는 것이 아니라 새로운 커밋을 생성한다.
    
- 동일한 변경 사항이 서로 다른 커밋으로 존재할 수 있어 이력 관리가 복잡해질 수 있다.
    
- 특정 커밋이 다른 커밋에 의존한다면 필요한 변경 사항을 함께 적용해야 한다.
    
- 동일한 변경 사항을 반복 적용하면 빈 커밋 처리나 충돌이 발생할 수 있다.
    
- 여러 커밋을 옮겨야 하는 상황이라면 `merge` 또는 `rebase`가 더 적합할 수 있다.
    
- 적용 후에는 반드시 빌드와 테스트를 통해 변경 사항이 정상 동작하는지 확인한다.
    

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]