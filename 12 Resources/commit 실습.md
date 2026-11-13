---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# commit 실습

---

## 📄 본문

### 1. 실습 목적

Git의 기본적인 `git commit -m "메시지"` 사용법을 넘어, 백엔드 개발 실무에서 활용하는 커밋 옵션과 메시지 작성 방법을 학습한다.

**실습 환경**

- 저장소: `chanmu-dev-lab-playground`
    
- 브랜치: `lab/commit-practice`
    
- 실습 경로: `jym/practice/commit/`
    
- 실습 도메인: 강의 관리 및 수강 신청
    

**학습 항목**

|명령어|용도|
|---|---|
|`git commit -m`|일반 커밋 생성|
|`git commit -am`|추적 중인 파일의 변경사항 자동 스테이징 및 커밋|
|`git commit --amend -m`|마지막 커밋 메시지 수정|
|`git commit --amend --no-edit`|메시지 변경 없이 마지막 커밋 수정|
|`git commit -m -m`|제목과 본문을 구분해 작성|
|`git commit --fixup`|기존 커밋에 합칠 수정 커밋 생성|
|`git rebase -i --autosquash`|fixup 커밋을 대상 커밋에 병합|

### 2. 실습 ① git commit -am

**시나리오:** 기존에 Git이 추적하는 파일을 수정했으며, 별도의 `git add` 없이 커밋하고 싶다.

먼저 파일을 생성하고 최초 커밋을 작성한다.

```
mkdir -p jym/practice/commit

cat > jym/practice/commit/enrollment.md <<'EOF'
# 수강 신청 서비스

- 신청 상태: PENDING
- 정원 검증: 미구현
EOF

git add jym/practice/commit/enrollment.md
git commit -m "feat: 수강 신청 서비스 초안 구현"
```

기존 파일을 수정하고 새로운 파일을 생성한다.

```
echo "- 인증 검증: 적용" >> jym/practice/commit/enrollment.md

echo "# 수강 신청 테스트" > jym/practice/commit/enrollment-test.md

git status --short
```

예상 결과:

```
 M jym/practice/commit/enrollment.md
?? jym/practice/commit/enrollment-test.md
```

이후 다음 명령어로 커밋한다.

```
git commit -am "feat: 수강 신청 인증 검증 추가"
```

**핵심 학습**

- `-a`: 추적 중인 파일의 수정·삭제를 자동 스테이징한다.
    
- `-m`: 커밋 메시지를 작성한다.
    
- `-am`: `-a -m`을 합친 표현이다.
    
- 새로운 파일(Untracked)은 자동으로 커밋되지 않는다.
    
- 이미 스테이징된 새 파일은 커밋에 포함될 수 있다.
    

따라서 새로운 Java 클래스나 테스트 파일을 생성했다면 `git add`를 별도로 실행해야 한다.

### 3. 실습 ② git commit --amend -m

**시나리오:** 커밋을 생성했지만 메시지를 잘못 작성했다.

```
git log -1 --oneline

git commit --amend -m "feat: 수강 신청 요청자 인증 검증 추가"

git log -1 --oneline
```

**핵심 학습**

- 가장 최근 커밋의 메시지를 수정할 수 있다.
    
- 기존 커밋을 직접 수정하는 것이 아니라 새로운 커밋으로 대체한다.
    
- 따라서 커밋 해시가 변경된다.
    
- 원격에 공유된 커밋에는 신중하게 사용해야 한다.
    

### 4. 실습 ③ git commit --amend --no-edit

**시나리오:** 커밋을 완료했지만 테스트 파일을 추가하지 않은 사실을 발견했다.

```
git status --short

git add jym/practice/commit/enrollment-test.md

git commit --amend --no-edit
```

결과 확인:

```
git show --stat HEAD
git log -1 --oneline
```

**핵심 학습**

- `--amend`: 마지막 커밋을 대체한다.
    
- `--no-edit`: 기존 커밋 메시지를 그대로 사용한다.
    
- 누락된 파일을 마지막 커밋에 추가하는 용도로 활용할 수 있다.
    
- 새로운 커밋이 하나 더 쌓이는 것이 아니다.
    

실무에서는 커밋 직후 누락된 테스트 코드나 설정 파일을 발견했을 때 유용하다.

### 5. 실습 ④ git commit -m -m

**시나리오:** 단순한 제목뿐 아니라 변경 이유와 세부 내용을 함께 기록하고 싶다.

강의 관리 파일을 생성한다.

```
cat > jym/practice/commit/course.md <<'EOF'
# 강의 관리

- 강의 상태: DRAFT, OPEN, CLOSED
- 모집 정원 관리
EOF
```

제목과 본문을 작성한다.

```
git add jym/practice/commit/course.md

git commit -m "feat(course): 강의 관리 기능 추가" -m "강의 상태와 모집 정원 관리 규칙을 정의함."
```

저장되는 커밋 메시지:

```
feat(course): 강의 관리 기능 추가

강의 상태와 모집 정원 관리 규칙을 정의함.
```

**핵심 학습**

- 첫 번째 `-m`은 제목으로 사용할 수 있다.
    
- 두 번째 `-m`은 본문으로 사용할 수 있다.
    
- 여러 `-m` 인수의 내용은 빈 줄로 구분된다.
    
- `-m`은 두 개 이상 사용할 수 있다.
    

### 6. 실습 ⑤ 제목, 본문, Footer 작성

실무에서 사용하는 커밋 메시지 형식은 다음과 같다.

```
<type>(<scope>): <subject>

<body>

<footer>
```

각 요소의 역할:

|구분|역할|필수 여부|
|---|---|---|
|Subject|무엇을 변경했는지 요약|필수|
|Body|변경 이유와 구현 내용 설명|선택|
|Footer|관련 이슈, Breaking Change 등|선택|

**제목 + 본문 + Footer**

```
feat(course): 강의 관리 기능 추가

강의 상태(DRAFT, OPEN, CLOSED)를 정의함.
모집 정원 관리 규칙을 추가함.

Refs: #42
```

**제목 + Footer**

본문이 없어도 작성할 수 있다.

```
feat(course): 강의 관리 기능 추가

Refs: #42
```

**작성 규칙**

- 제목과 본문 사이에는 빈 줄 하나를 둔다.
    
- 본문과 Footer 사이에도 빈 줄 하나를 둔다.
    
- 본문 내부에서는 일반적인 줄바꿈이 가능하다.
    
- 본문과 Footer는 상황에 따라 생략할 수 있다.
    
- `Refs: #42`와 같이 이슈 번호를 참조할 수 있다.
    
- Git은 `-m`의 순서만으로 본문과 Footer를 구별하는 것이 아니라, 메시지의 내용과 규약을 통해 구분한다.
    

한 줄 명령어로 작성하려면 다음과 같이 실행한다.

```
git commit -m "feat(course): 강의 관리 기능 추가" -m "강의 상태와 정원 관리 규칙을 정의함." -m "Refs: #42"
```

### 7. 실습 ⑥ 따옴표를 닫지 않고 여러 줄 입력

**시나리오:** `-m` 하나만 사용하면서 제목, 본문, Footer를 여러 줄로 작성하고 싶다.

실습한 명령어:

```
git commit -am "test: 커밋 메세지 작성 테스트

따옴표를 닫지 않은 상태에서 엔터를 누른다.
각 제목, 본문, 푸터에는 줄바꿈을 하는것이 좋다.
해당 작업 시 잘 못입력한다면 컨트롤 + C로 취소하고 진행하는 것이 좋다.
실수가 잦을 수 있으니 -m -m 명령어를 입력하는것을 추천한다.

Refs: 42"
```

첫 번째 줄에서 따옴표를 닫지 않고 Enter를 누르면 다음과 같은 안내 문구가 나타난다.

```
dquote>
```

이것은 오류가 아니다.

zsh에서 큰따옴표(Double Quote)가 닫히지 않아 입력을 계속 기다리는 상태다.

실제 터미널 입력 예시:

```
git commit -am "test: 커밋 메시지 테스트
dquote>
dquote> 첫 번째 본문 내용
dquote> 두 번째 본문 내용
dquote>
dquote> Refs: #42"
```

마지막에 `"`를 입력해 따옴표를 닫은 다음 Enter를 누르면 명령어가 실행된다.

**핵심 학습**

- `dquote>`는 커밋 메시지의 일부가 아니다.
    
- 따옴표가 닫히지 않으면 Enter를 눌러도 명령어가 실행되지 않는다.
    
- 입력한 실제 줄바꿈은 커밋 메시지에 포함된다.
    
- 제목과 본문 사이에 빈 줄을 만들려면 제목 입력 후 Enter를 두 번 누른다.
    
- 마지막 큰따옴표를 닫은 뒤 Enter를 눌러야 커밋이 실행된다.
    

### 8. 실습 ⑦ 터미널 입력 실수 처리

여러 줄을 작성하다가 실수하는 경우를 확인했다.

|입력|동작|
|---|---|
|`Enter`|다음 줄 입력|
|`Backspace`|현재 줄의 문자 삭제|
|`Ctrl + U`|현재 입력 줄 삭제(zsh 기본 설정)|
|`Ctrl + C`|입력을 취소하고 프롬프트로 복귀|
|`"`|열린 큰따옴표 닫기|

이미 Enter로 입력을 완료한 이전 줄까지 수정하기 번거롭다면 `Ctrl + C`로 취소하고 다시 작성하는 편이 간단하다.

**개인적으로 정리한 권장 방식**

```
git commit -am "test: 커밋 메시지 작성 테스트" -m "첫 번째 본문 내용
두 번째 본문 내용" -m "Refs: #42"
```

또는 편집기를 사용한다.

```
git commit -a
```

편집기에서는 긴 본문을 수정하거나 줄바꿈하기가 더 편하다.

### 9. 실습 ⑧ 역슬래시를 이용한 여러 줄 명령어 작성

처음에 다음과 같이 작성하면서 명령어 오류가 발생했다.

```
git commit \ -m "제목" \ -m "본문"
```

이 방식은 잘못된 입력이다.

`\`는 바로 다음 문자를 이스케이프하기 때문에, 공백 뒤에서 사용하는 방식과 줄바꿈 용도로 사용하는 방식은 다르다.

올바른 사용법:

```
git commit \
  -m "feat(course): 강의 관리 기능 추가" \
  -m "강의 상태와 모집 정원 관리 규칙을 정의함."
```

한 줄로 작성해도 동일하게 동작한다.

```
git commit -m "feat(course): 강의 관리 기능 추가" -m "강의 상태와 모집 정원 관리 규칙을 정의함."
```

**핵심 학습**

- 줄바꿈에 사용하는 `\`는 줄의 마지막에 위치해야 한다.
    
- `\` 바로 뒤에서 Enter를 누르면 명령어를 이어서 작성할 수 있다.
    
- 반드시 여러 줄로 작성해야 하는 것은 아니다.
    
- 짧은 명령어는 한 줄로 작성하는 편이 간단하다.
    

### 10. 추가 실습 예정: fixup과 autosquash

기존 커밋에 리뷰 수정사항을 병합하는 방법도 학습 대상이다.

```
# 기존 커밋의 해시 확인
git log --oneline

# 변경사항 스테이징
git add .

# 특정 커밋에 합칠 fixup 커밋 생성
git commit --fixup <commit-hash>

# fixup 커밋을 자동 정리
git rebase -i --autosquash HEAD~3
```

`HEAD~3`은 예시이므로 실제로 정리할 커밋 범위에 맞춰 조정해야 한다.

이 방식은 코드 리뷰 수정사항을 별도 커밋으로 만들었다가 원래 기능 커밋에 합칠 때 유용하다.

---

## ✏️ 메모

### 실습에서 배운 핵심

**1.** `**-am**`**은 편리하지만 주의가 필요하다.**

Git이 추적 중인 파일의 수정·삭제를 자동 스테이징하므로, 의도하지 않은 변경사항까지 포함할 수 있다.

특히 `git add -p`로 일부만 스테이징한 상황에서는 `-am`이 나머지 수정사항까지 포함할 수 있으므로 주의한다.

**2. 커밋 메시지는 항상 길게 작성할 필요가 없다.**

단순한 작업은 제목만 작성하고, 버그 원인이나 설계 의도를 설명해야 하는 작업은 본문을 추가한다.

**3.** `**-m -m**`**이 여러 줄 작성에 편리하다.**

따옴표를 열어둔 상태에서 직접 Enter를 누르는 방식도 가능하지만, 입력 실수를 줄이려면 `-m`을 여러 번 사용하거나 편집기를 여는 편이 낫다.

**4.** `**--amend**`**는 커밋 해시를 변경한다.**

푸시하기 전 로컬 커밋을 정리하는 상황에서 사용하고, 이미 다른 개발자와 공유한 커밋에는 신중하게 적용한다.

### 커밋 전후 확인 명령어

```
# 작업 상태 확인
git status

# 추적 중인 파일의 스테이징 전 변경사항 확인
git diff

# 스테이징된 변경사항 확인
git diff --cached

# 가장 최근 커밋 확인
git log -1 --oneline

# 커밋 메시지 전체 확인
git log -1 --format=%B

# 마지막 커밋에 포함된 파일 확인
git show --stat HEAD
```

### 개인 권장 실무 흐름

```
git status
git diff

git add -p

git diff --cached

git commit -m "fix(enrollment): 정원 초과 검증 오류 수정" -m "정원 초과 시 409 Conflict를 반환하도록 변경함."

git log -1 --format=%B
git status
```

**최종 정리:** 커밋은 단순히 변경사항을 저장하는 행위가 아니라, 나중에 다른 개발자가 변경 목적과 이유를 이해할 수 있도록 이력을 남기는 과정이다.

---

## 📚 참고 및 링크

- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]