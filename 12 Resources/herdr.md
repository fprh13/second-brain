---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---
# herdr

---

## 📄 본문

### Herdr란?

**Herdr**는 여러 AI 코딩 에이전트를 하나의 터미널 환경에서 실행하고 관리하기 위한 오픈소스 터미널 워크스페이스 관리자(Terminal Workspace Manager)이다.

Codex, Claude Code, OpenCode 등 다양한 AI 코딩 에이전트를 지원하며, 각 에이전트의 실행 상태를 추적하고 작업 환경을 지속적으로 유지할 수 있다.

기존 터미널 멀티플렉서인 tmux와 유사하지만, AI 코딩 에이전트의 실행 및 관리에 특화되어 있다.

**주요 특징**

- **멀티 에이전트 관리**: 여러 AI 코딩 에이전트를 동시에 실행하고 관리
    
- **상태 모니터링**: 에이전트의 작업 중, 대기 중, 입력 요청 등의 상태 확인
    
- **세션 유지**: 터미널을 종료하거나 SSH 연결이 끊겨도 백그라운드에서 작업 유지
    
- **워크스페이스 관리**: 프로젝트별 탭과 터미널 패널 구성
    
- **CLI 자동화**: 명령어를 통한 에이전트 실행, 입력 전달, 결과 확인
    
- **원격 작업**: SSH 기반 원격 환경 및 여러 머신 관리
    
- **마우스 지원**: 클릭, 드래그, 우클릭 메뉴를 통한 화면 조작
    
- **플러그인 및 Skill**: 외부 워크플로와 AI 에이전트의 Herdr 제어 기능 확장
    

Rust 기반 단일 바이너리로 제공되며 Electron에 의존하지 않는다.

### Herdr의 역할

**Codex가 코드를 작성하고 실행하는 에이전트라면, Herdr는 이러한 에이전트가 동작하는 터미널 환경을 관리하는 도구이다.**

예를 들어 하나의 프로젝트에서 다음과 같이 작업할 수 있다.

|작업|실행 도구|
|---|---|
|기능 구현|Codex|
|코드 리뷰|Codex|
|테스트 실행|Gradle|
|서버 실행|Spring Boot|
|로그 모니터링|Shell|
|전체 작업 환경 관리|Herdr|

각 작업을 별도의 터미널 패널에서 실행하면서 필요한 작업으로 빠르게 전환할 수 있다.

### 핵심 구성 요소

Herdr는 Session, Workspace, Tab, Pane, Agent 구조를 사용한다.

|구성 요소|설명|
|---|---|
|Session|백그라운드에서 유지되는 실행 환경|
|Workspace|프로젝트 또는 작업 단위의 공간|
|Tab|워크스페이스 내부의 화면 구성|
|Pane|실제 Shell 프로세스가 실행되는 터미널 영역|
|Agent|Pane에서 실행되는 AI 코딩 에이전트|

**구조 예시**

```
Herdr Session
│
├── Workspace: Carumuch
│   ├── Tab: Development
│   │   ├── Pane: Codex
│   │   └── Pane: Spring Boot
│   │
│   └── Tab: Testing
│       ├── Pane: Gradle
│       └── Pane: k6
│
└── Workspace: Dokidoki
    └── Tab: Development
        ├── Pane: Codex
        └── Pane: Git
```

프로젝트별로 작업 공간을 분리할 수 있으며, 각 Workspace의 에이전트 상태를 사이드바에서 확인할 수 있다.

### 지원 AI 코딩 에이전트

Herdr는 여러 CLI 기반 AI 코딩 에이전트를 지원한다.

|에이전트|지원|
|---|---|
|OpenAI Codex|O|
|Claude Code|O|
|OpenCode|O|
|Cursor Agent CLI|O|
|GitHub Copilot CLI|O|
|Gemini CLI|O|
|Kimi Code CLI|O|
|Grok CLI|O|
|Qwen Code|O|
|Droid|O|

일부 에이전트는 Herdr가 터미널 화면을 분석하여 상태를 감지하고, 일부는 에이전트가 직접 상태를 보고한다.

지원하지 않는 CLI 도구도 일반 터미널 프로그램으로 실행할 수 있지만, 에이전트 상태 감지 기능은 제공되지 않을 수 있다.

### 에이전트 상태 관리

Herdr는 에이전트가 실행 중인 Pane을 분석하여 상태를 표시한다.

|상태|의미|
|---|---|
|`working`|에이전트가 작업 수행 중|
|`blocked`|사용자 승인 또는 입력을 기다리는 상태|
|`done`|작업 완료 상태|
|`idle`|대기 상태|
|`unknown`|상태를 판단할 수 없는 경우|

예를 들어 여러 Codex를 동시에 실행했을 때, 어떤 에이전트가 작업 중이고 어떤 에이전트가 사용자 승인을 기다리는지 확인할 수 있다.

다만 상태 감지는 항상 완벽한 것은 아니다. 에이전트의 화면 출력이나 통합 방식에 따라 상태가 잘못 감지될 수 있으므로, 자동화 과정에서 `idle`을 사용자 승인으로 간주해서는 안 된다.

### 설치 방법

**macOS - Homebrew**

```
brew install herdr
```

**macOS / Linux - 공식 설치 스크립트**

```
curl -fsSL https://herdr.dev/install.sh | sh
```

설치 확인

```
herdr --version
```

Herdr 실행

```
herdr
```

설치 후 현재 프로젝트 디렉토리에서 실행하면 기본 세션에 연결되고 작업 환경을 구성할 수 있다.

```
cd ~/projects/dokidoki

herdr
```

이미 Herdr 내부에서 실행 중이라면 중첩 실행하지 않는다.

### 기본 사용 방법

**1. 프로젝트 진입**

```
cd ~/projects/dokidoki
```

**2. Herdr 실행**

```
herdr
```

**3. AI 코딩 에이전트 실행**

Herdr의 터미널 Pane에서 기존과 동일하게 실행한다.

```
codex
```

**4. 추가 Pane 생성**

마우스 우클릭 메뉴 또는 분할 기능을 이용하여 터미널을 추가한다.

추가 Pane에서는 다른 Codex, 테스트, 서버 등을 실행할 수 있다.

**5. 세션 분리 및 재연결**

Herdr에서 빠져나오기

```
Ctrl + B → Q
```

다시 연결하기

```
herdr
```

세션에서 분리하더라도 백그라운드 서버가 유지되는 동안 기존 터미널 프로세스는 계속 실행된다.

### 세션 유지와 복원

Herdr는 터미널 화면과 실행 프로세스를 백그라운드 서버에서 관리한다.

|상황|동작|
|---|---|
|Herdr 클라이언트 분리|실행 중인 작업 유지|
|터미널 창 종료|백그라운드 작업 유지|
|SSH 연결 종료|원격 서버의 작업 유지|
|Herdr 서버 재시작|저장된 레이아웃 복원 가능|
|머신 재부팅|기존 프로세스는 종료됨|

서버나 머신이 재시작된 경우 원래 프로세스가 살아남는 것은 아니다.

지원되는 에이전트의 통합 기능을 이용하면 기존 에이전트 세션을 재개할 수 있지만, 이는 프로세스 자체의 지속 실행과는 구분해야 한다.

### CLI 주요 명령어

Herdr는 CLI를 통해 워크스페이스와 에이전트를 제어할 수 있다.

|명령어|설명|
|---|---|
|`herdr`|기본 세션 실행 또는 연결|
|`herdr --version`|버전 확인|
|`herdr status`|실행 상태 확인|
|`herdr agent list`|감지된 에이전트 목록 확인|
|`herdr integration status`|에이전트 통합 상태 확인|
|`herdr --default-config`|기본 설정 출력|
|`herdr server reload-config`|설정 다시 불러오기|
|`herdr update`|직접 설치한 Herdr 업데이트|

**에이전트 상태 확인**

```shell
herdr agent list
```

**에이전트 감지 문제 분석**

```shell
herdr agent explain <target> --json
```

**특정 에이전트 이름 변경**

```shell
herdr agent rename w1:p1 reviewer
```

`w1:p1`은 예시 Pane ID이며 실제 환경의 ID를 사용해야 한다.

### Codex 연동

Herdr는 Codex를 지원하며, 일반 터미널에서 Codex를 실행하는 것과 동일한 방식으로 사용할 수 있다.

```
herdr
```

Herdr 내부에서

```
codex
```

에이전트 감지 외에도 Codex 통합 기능을 설치할 수 있다.

```shell
herdr integration install codex
```

통합 상태 확인

```shell
herdr integration status
```

통합 기능은 에이전트 종류에 따라 세션 복원이나 상태 보고 등의 기능을 제공한다.

**Herdr와 Codex의 역할 구분**

|기능|담당|
|---|---|
|코드 작성 및 수정|Codex|
|코드 분석 및 리뷰|Codex|
|테스트 실행 지시|Codex|
|에이전트 프로세스 관리|Herdr|
|터미널 분할|Herdr|
|에이전트 상태 모니터링|Herdr|
|에이전트 간 작업 조율|Herdr CLI / Skill|
|프로젝트 개발 규칙|AGENTS.md|

Herdr를 설치한다고 Codex의 코드 생성 능력이나 모델 성능이 향상되는 것은 아니다.

### 멀티 에이전트 자동화

Herdr는 단순히 여러 터미널을 보여주는 것뿐 아니라 CLI를 통해 에이전트의 작업을 조율할 수 있다.

대표적으로 다음 작업을 수행할 수 있다.

- 새로운 Pane 생성
    
- 특정 Pane에서 에이전트 실행
    
- 에이전트에 프롬프트 전달
    
- 에이전트 상태 대기
    
- 실행 결과 읽기
    
- 다른 에이전트에 후속 작업 전달
    

**예시: Codex 리뷰 에이전트 실행**

```shell
herdr agent start reviewer \
  --kind codex \
  --pane w1:p2
```

기존에 생성된 `w1:p2` Pane에서 Codex를 실행하고 `reviewer`라는 이름으로 관리한다.

**리뷰 요청**

```shell
herdr agent prompt reviewer \
  "Review the current diff" \
  --wait \
  --timeout 120000
```

**결과 확인**

```shell
herdr agent read reviewer \
  --source recent-unwrapped \
  --lines 120
```

**에이전트 대기**

```shell
herdr agent wait reviewer \
  --until blocked \
  --timeout 120000
```

이를 이용하면 구현 에이전트와 리뷰 에이전트를 별도로 실행하고, 특정 에이전트의 상태에 따라 다음 작업을 진행하는 자동화 구조를 구성할 수 있다.

단, 여러 에이전트가 동일한 파일을 동시에 수정하면 충돌이 발생할 수 있으므로 Git Worktree 또는 작업 영역 분리 전략을 함께 고려해야 한다.

### Herdr Skill

Herdr는 AI 코딩 에이전트가 Herdr를 직접 조작하도록 돕는 Skill을 제공한다.

**설치**

```shell
npx skills add herdrdev/herdr --skill herdr -g
```

해당 Skill을 지원하는 에이전트에 설치하면 에이전트가 Herdr CLI를 활용하여 다음 작업을 수행하도록 안내할 수 있다.

- 터미널 Pane 생성
    
- 별도 Pane에서 명령 실행
    
- 다른 에이전트 실행 및 관리
    
- 출력 결과 읽기
    
- 다른 에이전트의 상태 대기
    

Skill은 에이전트에게 Herdr 사용법을 제공하는 것이며, 별도의 AI 모델을 추가하는 기능은 아니다.

### 설정 파일

macOS 및 Linux에서 기본 설정 파일 경로는 다음과 같다.

```shell
~/.config/herdr/config.toml
```

설정 파일이 없어도 기본 설정으로 실행할 수 있다.

기본 설정 확인

```shell
herdr --default-config
```

주요 설정 영역

|설정|설명|
|---|---|
|`[keys]`|키보드 단축키|
|`[theme]`|테마|
|`[ui]`|사이드바 및 UI|
|`[terminal]`|터미널 및 Shell|
|`[update]`|업데이트 채널|

설정 변경 후 적용

```
herdr server reload-config
```

세부 설정 키는 버전에 따라 달라질 수 있으므로 공식 설정 문서를 기준으로 작성한다.

### 원격 개발 환경

Herdr는 SSH를 이용한 원격 개발 환경에서도 사용할 수 있다.

**원격 서버에 SSH 접속 후 Herdr 실행**

```
ssh user@server
herdr
```

원격 서버에서 실행되는 Herdr는 해당 서버의 터미널 세션을 관리한다.

**로컬 클라이언트에서 원격 연결**

```
herdr --remote <host>
```

또한 여러 원격 머신을 연결하여 로컬과 원격 환경의 에이전트 상태를 함께 관리하는 기능을 제공한다.

### cmux, Orca와 비교

Herdr, cmux, Orca는 AI 코딩 에이전트의 작업 환경을 효율적으로 관리하려는 목적에서 비교할 수 있다.

Herdr의 차별점은 다음과 같다.

- 터미널 멀티플렉서 기반의 백그라운드 세션 유지
    
- 에이전트 실행 상태 감지 및 사이드바 표시
    
- CLI와 Socket API를 통한 자동화
    
- AI 에이전트가 다른 에이전트를 제어하는 워크플로
    
- macOS, Linux, Windows 지원
    
- Rust 기반 단일 바이너리
    

각 도구의 운영체제 지원, UI, 에이전트 연동 방식 및 개발 환경에 따라 적합한 선택이 달라진다.

### 백엔드 프로젝트 활용 예시

Spring Boot 프로젝트에서 다음과 같이 구성할 수 있다.

```
Workspace: Dokidoki
│
├── Tab: Development
│   ├── Pane 1: Codex (기능 구현)
│   └── Pane 2: Codex (코드 리뷰)
│
├── Tab: Application
│   ├── Pane 1: Spring Boot
│   └── Pane 2: Application Logs
│
└── Tab: Testing
    ├── Pane 1: Gradle Test
    └── Pane 2: Git
```

성능 테스트가 필요한 경우 k6를 실행하는 Pane을 추가할 수 있다.

**활용 시 고려사항**

1. 하나의 에이전트가 구현을 담당하고 다른 에이전트가 검증하도록 역할 분리
    
2. 여러 에이전트가 동일한 파일을 수정하지 않도록 작업 범위 지정
    
3. 필요하다면 Git Worktree를 이용하여 작업 디렉토리 분리
    
4. 테스트와 애플리케이션 로그를 별도 Pane에서 모니터링
    
5. 승인 요청이 필요한 에이전트를 사이드바에서 확인
    

---

## ✏️ 메모

### 학습 순서

1. Herdr 설치 및 기본 실행
    
2. Session, Workspace, Tab, Pane 구조 이해
    
3. 마우스를 이용한 Pane 분할 및 탭 관리
    
4. Codex 실행 및 상태 모니터링
    
5. 세션 분리와 재연결
    
6. Codex 통합 설치
    
7. CLI를 통한 에이전트 제어
    
8. Herdr Skill 설치
    
9. Git Worktree와 멀티 에이전트 개발 환경 구성
    
10. 원격 개발 및 자동화 워크플로 실습

### 추후 학습 주제

- Codex 멀티 에이전트와 Herdr의 역할 차이
    
- Codex Subagent와 독립 Codex 프로세스 비교
    
- Git Worktree 기반 병렬 개발
    
- Herdr CLI 자동화 스크립트
    
- Herdr Skill과 AGENTS.md의 역할 구분
    
- cmux / Orca / Herdr 실제 사용성 비교
    

---

## 📚 참고 및 링크
- [Herdr 공식 문서](https://herdr.dev/docs/)

---

## 🔗 관련 노트

- [[../02 MOCs/AI|AI]]