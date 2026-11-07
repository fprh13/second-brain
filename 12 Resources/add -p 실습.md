---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# add -p 실습

---

## 📄 본문

### 실습 개요

`git add -p`는 하나의 파일에서 발생한 여러 변경 사항을 **Hunk(변경 묶음) 단위로 선택하여 Staging Area에 추가하는 명령어**이다.

일반적인 `git add 파일명`은 파일 전체를 스테이징하지만, `git add -p`는 필요한 변경 사항만 선택할 수 있다.

**실습 목표**

- 하나의 파일에 여러 변경 사항 생성
    
- `git add -p`로 원하는 변경 사항만 스테이징
    
- 스테이징된 변경과 스테이징되지 않은 변경 구분
    
- 변경 사항을 논리적인 단위로 분리하여 커밋
    
- 대화형 모드의 주요 명령어 학습
    

### 1. 실습 환경

**저장소**

```
~/Desktop/Repository/chanmu-dev-lab-playground
```

**실습 브랜치**

```
git switch -c lab/add-p
```

**실습 파일**

```
jym/practice/add-p/
└── enrollment.md
```

기존 `feature/jym-git-play` 브랜치에서 실습 전용 브랜치를 생성하여 작업한다.

### 2. 기본 파일 생성 및 커밋

```
mkdir -p jym/practice/add-p

cat > jym/practice/add-p/enrollment.md <<'EOF'
# 수강 신청 서비스

## 1. 정원 검증
- 정원 초과 검증: 없음
- 신청 대상: 강의
- 신청 주체: 회원
- 신청 상태: PENDING
- 정원 정보: Course
- 신청 정보: Enrollment
- 데이터 저장: Repository
- 처리 계층: Service
- 트랜잭션 사용: 적용
- 동시성 처리: 별도 고려

## 2. 로그 관리
- 신청 로그: 없음
- 로그 대상: 수강 신청
- 로그 위치: Service
- 로그 저장: 콘솔
- 로그 목적: 추적
- 로그 형식: 텍스트
- 요청 식별: courseId
- 사용자 식별: userId
- 로그 보관: 환경 설정
- 로그 출력: 개발 환경

## 3. 예외 처리
- 정원 초과 메시지: 요청 처리 실패
- 예외 종류: Conflict
- HTTP 상태: 409
- 예외 위치: Service
- 응답 형태: JSON
- 응답 코드: CONFLICT
- 오류 추적: 가능
- 사용자 안내: 필요
- 예외 기록: 활성화
- 전역 처리: 적용
EOF
```

기준이 되는 초기 커밋을 생성한다.

```
git add jym/practice/add-p/enrollment.md
git commit -m "test: add-p 실습 기본 파일 생성"
```

### 3. 하나의 파일에 세 가지 변경 사항 생성

수강 신청 서비스에서 다음 세 가지 작업을 진행했다고 가정한다.

|변경|작업 내용|커밋 종류|
|---|---|---|
|A|정원 초과 검증 추가|fix|
|B|수강 신청 로그 추가|chore|
|C|정원 초과 예외 메시지 개선|fix|

다음 명령어로 하나의 파일에 세 가지 변경 사항을 만든다.

```
python3 - <<'PY'
from pathlib import Path

path = Path("jym/practice/add-p/enrollment.md")
content = path.read_text()

content = content.replace(
    "- 정원 초과 검증: 없음",
    "- 정원 초과 검증: 현재 신청 인원이 정원 이상이면 거부"
)

content = content.replace(
    "- 신청 로그: 없음",
    "- 신청 로그: userId와 courseId를 INFO 레벨로 기록"
)

content = content.replace(
    "- 정원 초과 메시지: 요청 처리 실패",
    "- 정원 초과 메시지: 수강 신청 정원이 초과되었습니다"
)

path.write_text(content)
PY
```

변경 사항을 확인한다.

```
git status
git diff
```

하나의 `enrollment.md` 파일에 서로 다른 세 가지 변경이 발생한 것을 확인할 수 있다.

### 4. git add -p 실행

```
git add -p jym/practice/add-p/enrollment.md
```

Git은 변경된 부분을 Hunk 단위로 보여주며 스테이징 여부를 질문한다.

```
@@ -1,7 +1,7 @@
 # 수강 신청 서비스

 ## 1. 정원 검증
-- 정원 초과 검증: 없음
+- 정원 초과 검증: 현재 신청 인원이 정원 이상이면 거부
 - 신청 대상: 강의
 - 신청 주체: 회원
 - 신청 상태: PENDING
```

다음과 같은 선택지가 나타난다.

```
(1/3) Stage this hunk [y,n,q,a,d,j,J,g,/,e,?]?
```

`(1/3)`은 현재 표시되는 변경 묶음이 전체 3개 중 첫 번째라는 의미다.

**첫 번째 커밋에서는 정원 초과 검증만 선택한다.**

```
(1/3) Stage this hunk ...? y
(2/3) Stage this hunk ...? n
(3/3) Stage this hunk ...? n
```

- `y`: 현재 변경 사항을 스테이징
    
- `n`: 현재 변경 사항을 스테이징하지 않음
    

실행 후에는 A 변경 사항만 Staging Area에 올라가고, B와 C는 작업 디렉터리에 남는다.

### 5. 스테이징 결과 확인

```
# 스테이징된 변경 사항 확인
git diff --cached

# 스테이징되지 않은 변경 사항 확인
git diff

# 전체 상태 확인
git status
```

`git diff --cached`에는 정원 초과 검증 변경 사항만 출력되어야 한다.

```
-- 정원 초과 검증: 없음
+- 정원 초과 검증: 현재 신청 인원이 정원 이상이면 거부
```

`git diff`에는 나머지 로그 추가와 예외 메시지 개선이 출력된다.

이때 하나의 파일이 Staged와 Unstaged에 동시에 존재할 수 있다.

**이는 Git이 파일 단위가 아닌 변경 내용 단위로 스테이징 상태를 관리할 수 있기 때문이다.**

### 6. 변경 사항을 각각 별도 커밋으로 분리

실습의 최종 목적은 하나의 파일에서 발생한 세 가지 변경 사항을 세 개의 커밋으로 분리하는 것이다.

#### 첫 번째 커밋 — 정원 초과 검증

```
git add -p jym/practice/add-p/enrollment.md
```

```
A: y
B: n
C: n
```

```
git diff --cached
git commit -m "fix: 수강 신청 정원 초과 검증 추가"
```

#### 두 번째 커밋 — 로그 추가

첫 번째 커밋 후에도 나머지 변경 사항은 작업 디렉터리에 그대로 남아 있다.

```
git add -p jym/practice/add-p/enrollment.md
```

```
B: y
C: n
```

```
git diff --cached
git commit -m "chore: 수강 신청 로그 기록 추가"
```

#### 세 번째 커밋 — 예외 메시지 개선

```
git add -p jym/practice/add-p/enrollment.md
```

```
C: y
```

```
git diff --cached
git commit -m "fix: 수강 신청 정원 초과 예외 메시지 개선"
```

최종 커밋 이력을 확인한다.

```
git log --oneline -4
git status
```

**기대하는 커밋 구조**

```
fix: 수강 신청 정원 초과 예외 메시지 개선
chore: 수강 신청 로그 기록 추가
fix: 수강 신청 정원 초과 검증 추가
test: add-p 실습 기본 파일 생성
```

위 구조는 목표 예시이며, 실제 실습에서는 선택한 Hunk와 커밋 횟수에 따라 달라질 수 있다.

### 7. git add -p 주요 명령어

|명령어|설명|
|---|---|
|`y`|현재 Hunk 스테이징|
|`n`|현재 Hunk 제외|
|`q`|대화형 모드 종료|
|`a`|현재 Hunk부터 해당 파일의 나머지 Hunk 모두 스테이징|
|`d`|현재 Hunk부터 해당 파일의 나머지 Hunk 모두 제외|
|`s`|현재 Hunk를 더 작은 Hunk로 분리|
|`e`|패치를 직접 편집|
|`j`|다음 미결정 Hunk로 이동|
|`J`|다음 Hunk로 이동|
|`k`|이전 미결정 Hunk로 이동(표시되는 경우)|
|`K`|이전 Hunk로 이동(표시되는 경우)|
|`g`|특정 Hunk로 이동|
|`/`|정규표현식으로 Hunk 검색|
|`?`|도움말|

Git 버전과 현재 위치에 따라 표시되는 선택지는 달라질 수 있다.

### 8. 실습 중 발생한 상황과 해결 방법

#### 문제 — 대화형 모드 종료 방법을 모르는 경우

실습 도중 다음과 같은 입력을 진행했다.

```
(1/3) Stage this hunk ...?
(1/3) Stage this hunk ...? e
(2/3) Stage this hunk ...?
```

여기서 `e`는 Exit가 아닌 Edit를 의미한다.

종료하려면 다음을 입력한다.

```
Stage this hunk ...? q
```

`q`를 입력하면 대화형 스테이징 모드가 종료된다.

이미 `y`로 스테이징한 변경 사항은 그대로 유지된다.

#### 문제 — 잘못 스테이징한 변경 사항 초기화

특정 파일의 스테이징만 취소하려면 다음 명령어를 사용한다.

```
git restore --staged jym/practice/add-p/enrollment.md
```

전체 스테이징을 취소하려면:

```
git restore --staged .
```

두 명령어 모두 실제 작업 파일의 변경 사항은 유지한다.

#### 문제 — 모든 변경 사항을 하나의 커밋으로 만든 경우

`git add -p`를 사용했더라도 모든 변경 사항을 스테이징한 뒤 `git commit`을 한 번만 실행하면 하나의 커밋으로 기록된다.

`git add -p`는 커밋을 자동으로 분리하는 명령어가 아니다.

**스테이징할 변경 사항을 선택하는 명령어이며, 커밋을 분리하려면** `**git commit**`**도 각각 실행해야 한다.**

### 9. 심화 — Hunk를 더 작게 분리하기

Git은 변경 사항이 가까운 위치에 있으면 여러 변경을 하나의 Hunk로 묶을 수 있다.

```
- 정원 초과 검증: 없음
+ 정원 초과 검증: 적용
- 신청 로그: 없음
+ 신청 로그: 활성화
```

이때 다음 명령어를 사용할 수 있다.

```
Stage this hunk ...? s
```

`s`는 해당 Hunk를 가능한 경우 더 작은 Hunk로 분리한다.

분리할 수 없는 경우에는 `e`로 패치를 직접 편집할 수도 있지만, 패치 문법을 잘못 수정하면 적용에 실패할 수 있으므로 주의해야 한다.

### 10. IntelliJ IDEA에서 동일한 작업 수행

IntelliJ에서도 `git add -p`와 유사한 부분 스테이징이 가능하다.

**Staging Area 활성화**

```
Settings (⌘,)
→ Version Control
→ Git
→ Enable staging area
```

활성화하면 Commit 창에서 Staged와 Unstaged 변경 사항을 구분하여 확인할 수 있다.

작업 순서:

1. 변경된 파일의 Diff를 연다.
    
2. 변경 블록을 선택한다.
    
3. 원하는 부분만 Stage한다.
    
4. Staged 변경 사항을 확인한다.
    
5. 커밋한다.
    
6. 나머지 변경 사항을 같은 방식으로 반복한다.
    

별도의 Staging Area를 사용하지 않는 기본 Changelist 모드에서도 변경 블록을 선택해 부분 커밋할 수 있다.

### 11. 실무 활용 상황

**상황 1 — 기능 구현과 로그 추가가 섞인 경우**

하나의 서비스 파일에서 비즈니스 로직 수정과 로깅 변경을 동시에 작업했을 때 서로 다른 커밋으로 분리한다.

**상황 2 — 버그 수정과 리팩터링이 섞인 경우**

버그 수정 커밋과 코드 정리 커밋을 분리하여 변경 이력을 명확하게 관리한다.

**상황 3 — 코드 리뷰를 위한 커밋 정리**

하나의 커밋에 여러 목적의 변경 사항이 포함되지 않도록 논리적인 단위로 분리한다.

**주의 사항**

변경 사항을 무조건 잘게 분리하는 것이 좋은 것은 아니다. 각 커밋이 가능하면 독립적으로 빌드되고 테스트를 통과할 수 있도록 구성하는 것이 중요하다.

---

## ✏️ 메모

### 핵심 개념

- `git add 파일명`: 파일 전체 스테이징
    
- `git add -p`: 변경 묶음 단위로 선택적 스테이징
    
- `git diff`: 아직 스테이징되지 않은 변경 확인
    
- `git diff --cached`: 스테이징된 변경 확인
    
- `git restore --staged`: 스테이징 취소
    
- `git commit`: 현재 스테이징된 내용을 커밋으로 기록
    

### 실무 권장 흐름

```
git status
git diff
git add -p
git diff --cached
git commit -m "fix: 변경 사항 설명"
```

### 기억할 점

> `git add -p`의 목적은 단순히 파일을 쪼개는 것이 아니라, 하나의 파일에서 발생한 서로 다른 목적의 변경 사항을 논리적인 커밋으로 분리할 수 있도록 만드는 것이다.

> 스테이징은 커밋이 아니다. 변경 사항을 선택한 후 어떤 단위로 `git commit`을 실행하느냐에 따라 최종 커밋 이력이 결정된다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]