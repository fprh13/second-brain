---
created: 2026-03-16
tags:
  - resource
---

# Tmux

---

## 📄 요약
- tmux는 하나의 터미널 안에서 세션, 윈도우, pane을 나눠 여러 작업을 동시에 관리하게 해주는 터미널 멀티플렉서입니다.
- SSH 연결이 끊겨도 작업을 유지할 수 있어 원격 서버 운영, 로그 모니터링, 테스트 실행, AI CLI 병렬 작업에 특히 유용합니다.
- 시작은 `tmux`, 분리는 `Ctrl + b d`, 재접속은 `tmux attach`를 기억하면 기본 사용 흐름을 빠르게 익힐 수 있습니다.

---

## 📄 본문

### 1. tmux란 무엇인가

tmux는 **Terminal Multiplexer**의 약자로, 하나의 터미널 안에서 여러 터미널 세션을 관리할 수 있게 해주는 도구입니다.

일반 터미널과의 차이는 아래처럼 정리할 수 있습니다.

일반 터미널
- 창 하나 = 작업 하나
- 창을 닫으면 작업 종료
- SSH가 끊기면 작업 종료

tmux
- 창 하나 안에 여러 터미널
- 세션 분리(detach) 가능
- SSH가 끊겨도 작업 유지

개발 환경에서는 다음과 같은 상황에서 특히 유용합니다.

- 여러 CLI 도구를 동시에 실행
- 로그 모니터링
- 빌드와 테스트를 병렬 실행
- AI CLI 에이전트를 병렬 실행
- 원격 서버 작업 유지

### 2. 설치 (macOS 기준)

Homebrew가 설치되어 있다면 가장 간단합니다.

설치

```shell
brew install tmux
```

설치 확인

```shell
tmux -V
```

출력 예시

```text
tmux 3.4
```

### 3. 기본 개념

tmux에는 세 가지 핵심 개념이 있습니다.

#### Session

작업 환경 전체입니다.

예

- 개발 세션
- 서버 운영 세션

#### Window

세션 안의 탭입니다.

예

- backend
- logs
- database

#### Pane

윈도우 안의 분할 터미널입니다.

예

- build
- test
- codex cli

구조 예

```text
Session
 ├ Window 1
 │   ├ Pane
 │   └ Pane
 └ Window 2
     └ Pane
```

### 4. tmux 시작하기

tmux 실행

```shell
tmux
```

그러면 새로운 세션이 생성됩니다.

상단 또는 하단에 상태바가 나타나면 정상입니다.

### 5. Prefix 키

tmux 명령은 **prefix 키**를 먼저 누르고 다음 키를 누르는 방식입니다.

기본 prefix

```text
Ctrl + b
```

예

```text
Ctrl + b → %
```

### 6. 가장 많이 사용하는 단축키

#### Pane 분할

세로 분할

```text
Ctrl + b %
```

가로 분할

```text
Ctrl + b "
```

#### Pane 이동

```text
Ctrl + b + 방향키
```

#### Pane 닫기

현재 pane에서 아래 중 하나를 실행합니다.

```shell
exit
```

또는

```text
Ctrl + d
```

#### Pane 전체 화면

```text
Ctrl + b z
```

#### tmux 세션 분리

```text
Ctrl + b d
```

이 명령은 tmux를 종료하지 않고 **백그라운드로 분리**합니다.

### 7. 세션 관리

현재 세션 확인

```shell
tmux ls
```

출력 예시

```text
0: 1 windows
```

세션 접속

```shell
tmux attach
```

특정 세션 접속

```shell
tmux attach -t 0
```

세션 종료

```shell
tmux kill-session -t 0
```

### 8. 개발자 실전 사용 예

개발 환경에서 자주 사용하는 tmux 구조 예입니다.

예: 백엔드 개발

```text
tmux

pane1  backend server
pane2  build process
pane3  test runner
pane4  logs
```

예: AI CLI 작업

```text
tmux

pane1  codex cli
pane2  gemini cli
pane3  docker logs
pane4  editor
```

이렇게 하면 여러 작업을 동시에 관리할 수 있습니다.

### 9. SSH 환경에서의 장점

서버 작업 시 가장 큰 장점입니다.

일반 SSH

```text
ssh server
build 실행
SSH 끊김 → 작업 종료
```

tmux 사용

```text
ssh server
tmux
build 실행
SSH 끊김 → 작업 계속 진행
```

다시 접속

```shell
tmux attach
```

### 10. tmux 사용 패턴 (추천)

개발자들이 많이 사용하는 조합입니다.

```text
tmux
+ git worktree
+ AI CLI
```

예

```text
tmux
 ├ backend
 ├ logs
 ├ codex agent
 └ test runner
```

### 11. tmux가 특히 유용한 상황

다음 작업에서는 tmux 사용이 특히 유용합니다.

- 서버 운영
- 로그 모니터링
- CI 테스트 실행
- Docker 관리
- AI CLI 병렬 실행

### 정리

핵심 장점

- 여러 작업 병렬 실행
- SSH 연결이 끊겨도 작업 유지
- 개발 환경 정리
- CLI 기반 작업 관리

개발자 환경에서는 tmux를 통해 **하나의 터미널을 작업 대시보드처럼 사용할 수 있습니다.**

---

## ✏️ 메모
- 처음에는 `tmux`, `Ctrl + b d`, `tmux attach`, `tmux ls` 네 가지만 익혀도 기본 사용 흐름을 빠르게 잡을 수 있습니다.
- AI CLI를 함께 쓸 때는 역할별로 pane을 나누면 로그 확인과 결과 비교가 쉬워집니다.

## 📚 참고 및 링크
- https://github.com/tmux/tmux/wiki
- https://github.com/tmux/tmux/wiki/Getting-Started

## 🔗 관련 노트
- [[OMX]]
- [[Develop]]
