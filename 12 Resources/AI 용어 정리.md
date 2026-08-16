---
created: 2026-03-30
tags:
  - resource
---

# AI 용어 정리

## 📄 개요
AI 학습 및 실습을 진행하기 위한 프로젝트

## ✏️ 메모

### 1. 전체 구조

AI 개발을 “도구”로 보면 계속 꼬입니다.  
반드시 “시스템 계층”으로 이해해야 합니다.

```text
[System Layer]        → Spring, DB
[Orchestration Layer] → 흐름 설계 (workflow, event)
[Harness Layer]       → 실행 제어 (반복, 규칙, 자동화, omx, AGENTS.md)
[Agent Layer]         → AI (Codex, Claude, Gemini)
[Execution Layer]     → 실행 환경 (tmux, shell, container)
[Interface Layer]     → UI/UX (cmux, IDE)
```

핵심 정의:

- Agent → 작업 수행
- Harness → 통제
- Orchestration → 연결
- System → 실제 서비스
- Execution → 실행 환경
- Interface → 사람이 다루는 영역

### 2. 핵심 개념

#### Agent

> “작업을 수행하는 AI 단위”

예:

- 코드 생성 Agent
- 테스트 생성 Agent
- 리뷰 Agent

### Assistant vs Agent

| 구분 | Assistant | Agent |
| --- | --- | --- |
| 역할 | 응답 생성 | 목표 달성 |
| 트리거 | 사용자 요청 | 스스로 실행 |
| 상태 | 거의 없음 | 있음 |
| 행동 | 단발성 | 연속적 |

정의:

- Assistant → 내가 쓰는 도구
- Agent → 나 대신 일하는 시스템

핵심 한 줄:

> Assistant는 “대답”, Agent는 “행동”

### Persona

> Agent의 “역할 + 성격 정의”

예:

```text
너는 10년차 Spring 백엔드 개발자다.
테스트 커버리지 80% 이상을 유지한다.
```

결과 품질을 결정하는 핵심 요소

### Sub-Agent / Agent Team

> 여러 역할을 나눠 협업하는 구조

예:

```text
PM → Backend → QA → Reviewer
```

실제 조직과 동일한 구조

### Harness

> Agent를 “제어 가능한 시스템”으로 만드는 틀

구성:

- 입력
- 실행 순서
- 상태 관리
- 실패 처리
- 재시도 전략
- 반복 로직

예:

```text
요구사항 → 코드 생성 → 테스트 → 실행 → 실패 → 수정 → 반복
```

핵심:

> Harness가 없으면 Agent는 단순한 함수에 불과하다

### Loop (Feedback Loop)

> AI가 반복하면서 개선하는 구조

기본 형태:

```text
generate → execute → evaluate → fix → repeat
```

### RALPH Loop

```text
Reason → Act → Learn → Plan → Handle
```

의미:

- Reason → 문제 분석
- Act → 실행
- Learn → 결과 학습
- Plan → 다음 전략 수립
- Handle → 예외 처리

핵심:

> 단순 반복이 아니라 “의사결정 루프”

### Orchestration

> 여러 Agent / 시스템 / 작업을  
> 순서 + 조건 + 이벤트 기반으로 연결하는 것

중요:

> 도구가 아니라 “흐름 설계 능력”

구성 방식:

- Sequential (순차 실행)  
- Parallel (병렬 실행)  
- Event-driven (이벤트 기반)  
- Conditional (조건 분기)

### Tool / Tool Calling

> AI가 외부 기능을 사용하는 것

예:

- 파일 생성
- 테스트 실행
- API 호출
- Git 작업

### Memory

> 상태 저장

- Short-term → 현재 작업 context
- Long-term → DB, Vector DB

### Execution / Interface 관련

#### tmux

> 실행 환경 (Execution Layer)

- 하나의 터미널에서 여러 작업 실행
- 병렬 처리 가능
- 가장 기본적인 실행 인프라

#### omx (oh-my-codex)

> Harness Layer에 해당

- Agent 실행 흐름 정의
- 작업 분배
- 자동 실행 (PR, 테스트 등)

역할:

> “어떻게 실행할지”를 정의하는 시스템

#### cmux

> Interface Layer

- 작업 환경을 시각적으로 관리
- workspace / session 관리
- 실행 흐름을 사람이 보기 쉽게 구성

역할:

> “보여주고 정리하는 도구”

### cmux vs tmux + omx

#### 1. 구조 차이

```text
cmux
→ Interface 중심 (UI 기반 관리)

tmux + omx
→ Execution + Harness 기반 (자동 실행 시스템)
```

#### 2. 역할 차이

| 구분 | cmux | tmux + omx |
| --- | --- | --- |
| 성격 | 작업 공간 관리 | Agent 실행 인프라 |
| 추상화 | UI 중심 | 시스템 중심 |
| 자동화 | 낮음 | 높음 |
| Agent 연동 | 간접적 | 직접적 |

#### 3. 핵심 한 줄

- cmux → “개발 환경 정리 도구”
- tmux + omx → “AI 자동 실행 시스템”

#### 4. 언제 무엇을 쓰는가

- cmux  
  → 여러 프로젝트를 동시에 관리  
  → 시각적으로 정리하고 싶을 때
- tmux + omx  
  → Agent 병렬 실행  
  → 자동화 (테스트, PR, 반복 루프)  
  → AI 기반 개발 시스템 구축

---

## 🔗 관련 노트
- [[하네스 공식문서 100번 읽은 것처럼 만들어드림 정리]]
