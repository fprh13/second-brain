---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# worktree

---

## 📄 본문

### Worktree란?

Git Worktree는 **하나의 Git 저장소에서 여러 작업 디렉터리를 생성하여 서로 다른 브랜치를 동시에 작업할 수 있도록 지원하는 Git 기능**이다.

일반적으로 하나의 작업 디렉터리에서는 하나의 브랜치를 체크아웃하여 개발한다. 다른 브랜치에서 작업하려면 `git switch`를 통해 브랜치를 전환해야 한다.

반면 Worktree를 사용하면 브랜치별 독립적인 작업 디렉터리를 생성하여 브랜치 전환 없이 여러 작업을 동시에 진행할 수 있다.

- 하나의 Git 저장소를 공유한다.
    
- Worktree마다 독립적인 작업 디렉터리와 인덱스(Index), HEAD를 가진다.
    
- 브랜치별 파일 수정이 서로의 작업 디렉터리에 직접 영향을 주지 않는다.
    
- 커밋과 브랜치 등의 Git 데이터는 공유한다.
    
- 작업 완료 후 일반적인 Git Merge 또는 PR을 통해 변경 사항을 통합한다.
    

**Worktree는 별도의 Git 저장소를 복제하는 것이 아니라, 동일한 저장소에 여러 작업 공간을 연결하는 방식이다.**

### Branch와 Worktree의 차이

| 구분       | Branch       | Worktree       |
| -------- | ------------ | -------------- |
| 목적       | 변경 이력 분리     | 작업 디렉터리 분리     |
| 독립 파일 공간 | X            | O              |
| 동시 작업    | 브랜치 전환 필요    | 여러 디렉터리에서 가능   |
| Git 이력   | 공유           | 공유             |
| 주요 명령어   | `git switch` | `git worktree` |

Branch는 변경 이력을 구분하기 위한 개념이고, Worktree는 실제 파일을 수정하는 작업 공간을 분리하는 개념이다.

따라서 **Branch와 Worktree는 서로 대체하는 기능이 아니라 함께 사용하는 기능**이다.

### Git Worktree 구조

예를 들어 로그인 기능과 강의 기능을 동시에 개발하는 상황을 가정한다.

```bash
projects/
├── academy/                  # Main Worktree
│   └── develop
│
├── academy-login/            # Linked Worktree A
│   └── feature/10-login
│
└── academy-course/           # Linked Worktree B
    └── feature/11-course
```

- `academy`: 기존 Git 저장소의 기본 작업 디렉터리
    
- `academy-login`: 로그인 기능을 구현하는 독립 작업 공간
    
- `academy-course`: 강의 기능을 구현하는 독립 작업 공간
    

세 작업 공간은 동일한 Git 저장소의 커밋과 브랜치 정보를 공유하지만 각각 독립적으로 파일을 수정할 수 있다.

참고로 하나의 브랜치를 여러 Worktree에서 동시에 체크아웃하는 것은 기본적으로 Git이 제한한다.

### Git Worktree 사용법

#### 생성

`academy` 저장소의 `develop` 브랜치를 기준으로 새로운 Worktree를 생성한다.

```bash
# 새 브랜치를 생성하면서 Worktree 생성
git worktree add -b feature/10-login ../academy-login develop

# 두 번째 Worktree 생성
git worktree add -b feature/11-course ../academy-course develop
```

|옵션|설명|
|---|---|
|`add`|새로운 Worktree 생성|
|`-b`|새 브랜치 생성|
|`feature/10-login`|생성할 브랜치 이름|
|`../academy-login`|Worktree 생성 경로|
|`develop`|새 브랜치의 시작 커밋을 지정하는 기준 브랜치|

기존 브랜치를 사용하는 경우에는 `-b`를 생략한다.

```bash
git worktree add ../academy-login feature/10-login
```

#### 목록 확인

```bash
git worktree list

# 상세 정보 확인
git worktree list --verbose
```

출력 예시:

```bash
/projects/academy          abc1234 [develop]
/projects/academy-login    def5678 [feature/10-login]
/projects/academy-course   ghi9012 [feature/11-course]
```

#### 작업 디렉터리 이동

```bash
cd ../academy-login

git status
git branch --show-current
```

각 Worktree는 독립된 디렉터리이므로 해당 위치에서 평소와 동일하게 Git 명령어를 사용할 수 있다.

#### 제거

```bash
# 연결된 Worktree 제거
git worktree remove ../academy-login

# 제거된 Worktree의 브랜치 삭제
git branch -d feature/10-login
```

- `worktree remove`는 작업 디렉터리를 제거하지만 브랜치는 삭제하지 않는다.
    
- 기본적으로 미커밋 변경 사항이나 추적되지 않는 파일이 있으면 제거를 거부한다.
    
- `git branch -d`는 병합 여부를 검사하며, 병합되지 않은 브랜치는 삭제를 거부할 수 있다.
    
- 강제 제거 옵션 `--force`는 작업 파일이 유실될 수 있으므로 주의한다.
    

관련 명령어:

|명령어|역할|
|---|---|
|`git worktree add`|Worktree 생성|
|`git worktree list`|Worktree 목록 확인|
|`git worktree remove`|Worktree 제거|
|`git worktree move`|Worktree 경로 이동|
|`git worktree prune`|사라진 Worktree의 관리 정보 정리|
|`git worktree repair`|손상된 Worktree 연결 정보 복구|
|`git worktree lock`|Worktree 이동·제거 및 관리 정보 정리 방지|


### AI 개발에서 Worktree를 사용하는 이유

AI 에이전트를 활용한 개발에서는 여러 에이전트가 독립적인 작업을 병렬로 수행하는 경우가 많다.

하나의 작업 디렉터리에서 여러 AI가 동시에 코드를 수정하면 다음 문제가 발생할 수 있다.

1. 여러 에이전트가 동일한 파일을 수정하면서 변경 사항이 섞인다.
    
2. 한 에이전트의 작업이 다른 에이전트의 테스트 결과에 영향을 준다.
    
3. 작업 중인 파일을 덮어쓰거나 의도하지 않은 변경이 발생한다.
    
4. 어느 에이전트가 어떤 변경을 수행했는지 구분하기 어려워진다.
    

이를 해결하기 위해 **AI 에이전트마다 독립적인 Git Worktree를 할당하는 방식**을 사용한다.

```bash
                  Developer
                      │
                Orchestrator
                      │
          ┌───────────┴───────────┐
          │                       │
       Agent A                 Agent B
       (Codex)              (Antigravity)
          │                       │
    Worktree A               Worktree B
    feature/login            feature/course
          │                       │
          └───────────┬───────────┘
                      │
                 Review / Test
                      │
                    Merge
                      │
                   develop
```

각 에이전트는 독립된 작업 디렉터리에서 코드를 수정하고 테스트한다. 구현이 완료되면 작업 결과를 검증하고 브랜치를 통합한다.

**AI Worktree는 Git Worktree와 별개의 기술이 아니라, AI 에이전트의 작업 격리를 위해 Git Worktree를 활용하는 개발 방식이다.**

단, AI 에이전트의 작업 공간이 반드시 브랜치와 1:1로 대응하는 것은 아니다. Codex처럼 Detached HEAD 상태의 Worktree를 생성하는 방식도 존재한다.

### AI 병렬 개발의 역할 구분

|역할|담당|책임|
|---|---|---|
|Orchestrator|메인 AI 또는 개발자|작업 분배 및 의존성 관리|
|Worker Agent|Codex, Antigravity 등|기능 구현 및 단위 테스트|
|Reviewer Agent|검증 담당 AI|변경 사항 검토 및 테스트|
|Integrator|메인 AI 또는 개발자|브랜치 병합 및 충돌 해결|
|Developer|개발자|최종 검토 및 승인|

일반적인 권장 흐름은 다음과 같다.

1. 개발자가 구현할 작업을 독립적인 단위로 나눈다.
    
2. 각 작업에 브랜치와 Worktree를 할당한다.
    
3. 각각의 AI 에이전트가 구현 및 테스트를 수행한다.
    
4. Reviewer가 결과와 변경 사항을 검증한다.
    
5. Integrator가 변경 사항을 순차적으로 병합한다.
    
6. 통합 테스트가 통과하면 개발자가 최종 승인한다.
    
7. 완료된 Worktree를 정리한다.
    

여기서 중요한 점은 **Worktree가 자동으로 코드 리뷰나 병합을 수행하는 것은 아니라는 것**이다.

병합 작업은 개발자가 직접 수행하거나 AI 에이전트에게 명시적으로 위임해야 한다.

### AI 개발 도구와 Worktree

|도구|주요 역할|
|---|---|
|Git Worktree|독립적인 작업 디렉터리 제공|
|Herdr|Worktree 및 터미널 작업 공간 관리|
|Orca|멀티 에이전트 작업 환경 관리|
|Codex|코드 분석·구현·테스트|
|Antigravity CLI|AI 기반 개발 작업 수행|

Herdr나 Orca는 Git Worktree를 관리하는 개발 환경 도구이며, Codex와 Antigravity CLI는 실제 개발 작업을 수행하는 AI 에이전트로 활용할 수 있다.

다만 도구별 자동화와 통합 기능은 다르므로, 특정 도구가 병합이나 검증까지 자동으로 수행한다고 가정해서는 안 된다.

#### Herdr에서 Worktree 관리

Herdr는 Git Worktree를 생성하고 이를 별도 Workspace로 연결하여 관리할 수 있다.

```bash
# Worktree 생성
herdr worktree create --branch feature/10-login --base develop

# 목록 확인
herdr worktree list

# 기존 Worktree 열기
herdr worktree open --branch feature/10-login
```

Worktree를 제거할 때는 대상 Workspace ID를 지정한다.

```bash
herdr worktree remove --workspace <WORKSPACE_ID>
```

Herdr의 기본 Worktree 명령어는 Git Worktree 기능을 활용한다.

- Worktree 생성 시 Git 체크아웃 디렉터리를 생성한다.
    
- Worktree를 Herdr Workspace로 관리한다.
    
- Workspace를 닫는 것과 Git Worktree를 삭제하는 것은 다르다.
    
- Worktree 제거 시 브랜치는 자동으로 삭제하지 않는다.
    

### Worktree, Workspace, Pane의 차이

|개념|설명|
|---|---|
|Worktree|Git 기반 독립 작업 디렉터리|
|Workspace|도구에서 프로젝트 작업 환경을 관리하는 단위|
|Tab|하나의 작업 환경에 속하는 터미널 탭|
|Pane|분할된 터미널 화면|
|Agent|실제 작업을 수행하는 AI|

**Pane을 나누는 것과 Worktree를 나누는 것은 다르다.**

Pane을 여러 개 생성해도 동일한 작업 디렉터리에서 실행한다면 여러 AI가 같은 파일을 수정할 수 있다.

따라서 독립적인 병렬 개발이 목적이라면 Pane 분할뿐 아니라 Worktree를 통한 작업 디렉터리 분리도 고려해야 한다.

### 작업 결과 검증 및 병합

Worktree에서 수행한 작업은 일반적인 Git Branch와 동일한 방식으로 병합한다.

#### 1. 작업 결과 확인

각 Worktree에서 변경 사항을 확인한다.

```bash
git status

git diff

git log --oneline -5
```

작업이 완료되면 필요한 변경 사항을 커밋한다.

```bash
git add .
git commit -m "feat: 로그인 기능 구현"
```

커밋되지 않은 변경 사항은 일반적인 브랜치 병합만으로 통합되지 않는다.

#### 2. 브랜치 변경 사항 검토

통합 기준인 `develop`에서 변경 사항을 확인한다.

```bash
# 변경된 파일 요약
git diff --stat develop...feature/10-login

# 상세 변경 사항 확인
git diff develop...feature/10-login

# 브랜치 커밋 확인
git log develop..feature/10-login --oneline
```

`...` 형태의 Diff는 두 브랜치의 공통 조상을 기준으로 작업 브랜치의 변경 사항을 보여준다.

#### 3. 브랜치 병합

`develop`이 체크아웃된 메인 Worktree에서 진행한다.

```bash
git switch develop

git merge --no-ff feature/10-login

git merge --no-ff feature/11-course
```

첫 번째 브랜치 병합 이후 두 번째 브랜치를 병합하는 과정에서 충돌이 발생할 수 있다.

충돌이 발생하면 수정한 뒤 관련 파일을 스테이징하고 병합을 완료한다.

#### 4. 통합 테스트

```bash
./gradlew clean test
```

각 Worktree의 테스트가 통과했더라도 병합 후 테스트가 반드시 통과한다는 보장은 없다.

따라서 최종 병합 후에는 통합 테스트를 수행해야 한다.

실무에서는 직접 Merge하는 방식 외에도 각 작업 브랜치를 원격 저장소에 Push한 뒤 PR을 생성하고 리뷰·CI를 거쳐 병합하는 방식이 일반적으로 사용된다.

#### 5. Worktree 정리

```bash
git worktree list

git worktree remove ../academy-login
git worktree remove ../academy-course

git branch -d feature/10-login
git branch -d feature/11-course
```

Worktree를 제거하기 전 모든 필요한 변경 사항이 커밋되거나 병합되었는지 확인한다.

### AI 병렬 개발 시 주의사항

#### 작업 단위 분리

여러 AI에게 작업을 분배할 때는 독립적으로 구현할 수 있는 작업 단위를 선정해야 한다.

좋은 예시:

- Agent A: 회원 인증 기능
    
- Agent B: 강의 조회 기능
    
- Agent C: 테스트 코드 및 문서 검증
    

주의할 예시:

- Agent A: User 엔티티 구조 변경
    
- Agent B: 동일한 User 엔티티 변경
    
- Agent C: 해당 User 엔티티를 사용하는 인증 로직 수정
    

작업 디렉터리가 분리되어 있더라도 최종 병합 과정에서 파일 충돌이나 도메인 규칙 충돌이 발생할 수 있다.

가급적 수정 파일 범위가 겹치지 않도록 작업을 분배하고, 공유 인터페이스나 데이터 모델을 변경해야 한다면 사전에 계약을 정의하는 것이 좋다.

#### 실행 환경 분리

Worktree는 Git 파일 작업을 분리하지만 실행 중인 프로세스나 외부 인프라까지 분리하지 않는다.

Spring Boot 기반 개발에서는 다음 사항을 고려해야 한다.

|항목|주의사항|
|---|---|
|서버 포트|여러 서버가 동일 포트를 사용하면 충돌|
|MySQL|동일 DB 사용 시 데이터 및 스키마 충돌 가능|
|Redis|동일 키 공간을 공유할 수 있음|
|RabbitMQ|동일 Queue를 사용하는 Consumer 간 메시지 경쟁 가능|
|Docker|컨테이너 이름, 포트, Volume 충돌 가능|
|환경변수|Worktree별 설정 파일 준비 필요|
|Flyway|서로 다른 Migration 추가 시 버전 충돌 가능|

개발 단계에서는 작업 목적에 따라 다음과 같이 분리할 수 있다.

```bash
Worktree A
 ├── Spring Boot : 8081
 └── Database    : academy_a

Worktree B
 ├── Spring Boot : 8082
 └── Database    : academy_b
```

각 Worktree는 추적 대상 파일을 체크아웃하지만 `.env`와 같은 Git Ignore 파일이나 로컬 실행 결과물을 자동으로 복제하지는 않는다.

따라서 Worktree를 새로 생성했다면 필요한 환경설정과 실행 의존성을 별도로 준비해야 한다.

#### AI 에이전트 작업 규칙

병렬 개발 시에는 `AGENTS.md`와 같은 프로젝트 지침 문서에 공통 작업 규칙을 정의하는 것이 유용하다.

예를 들어 다음과 같은 규칙을 둘 수 있다.

- 각 에이전트는 자신에게 할당된 Worktree에서만 작업한다.
    
- 지정된 작업 범위 외의 파일은 임의로 수정하지 않는다.
    
- 공통 인터페이스를 변경해야 한다면 먼저 보고한다.
    
- 작업 완료 시 변경 파일과 테스트 결과를 정리한다.
    
- 검증되지 않은 변경 사항을 임의로 `develop`에 병합하지 않는다.
    
- 병합은 통합 담당자 또는 개발자의 승인 후 수행한다.
    

이러한 규칙은 에이전트 간 충돌을 줄이고 변경 사항에 대한 책임을 명확하게 한다.

### Worktree 사용이 적합한 경우

**적합한 경우**

- 여러 AI 에이전트가 서로 다른 기능을 병렬 구현하는 경우
    
- 기능 개발과 버그 수정을 동시에 진행하는 경우
    
- 기존 작업을 유지한 상태에서 별도의 실험을 진행하는 경우
    
- 여러 브랜치의 테스트 환경을 독립적으로 유지하려는 경우
    
- 한 에이전트가 구현하는 동안 다른 에이전트가 별도 작업을 수행하는 경우
    

**불필요할 수 있는 경우**

- 간단한 단일 기능만 구현하는 경우
    
- 여러 작업이 동일한 파일에 강하게 의존하는 경우
    
- 변경 규모보다 분리 및 병합 관리 비용이 더 큰 경우
    

---

## 📚 참고 및 링크
- [[]]

---

## 🔗 관련 노트

- [[../02 MOCs/Git|Git]]