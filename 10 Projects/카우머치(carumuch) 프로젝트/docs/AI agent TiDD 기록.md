---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - project
---

# AI agent TiDD 기록

---

## 📄 개요
이 문서는 `carumuch-backend` 에서 TiDD 기반 병렬 개발 흐름을 만들기 위해 수행한 작업의 기록입니다.  

---

## ✏️ 메모
  
### 작업 배경  
  
초기 목표는 다음과 같았습니다.  
  
- 사용자가 특정 이슈 번호를 기준으로 실행 가능한 TiDD 티켓을 만든다.  
- 만든 티켓을 기준으로 두 개의 Codex agent가 서로 다른 전략으로 병렬 구현한다.  
- 사용자는 두 결과를 비교한 뒤 `A`, `B`, 또는 `취소`를 선택한다.  
- 선택 결과만 핵심 티켓 브랜치에 반영하고, 나머지 리소스는 정리한다.  
  
핵심 요구는 “내 작업 브랜치와 Codex가 수행하는 티켓 작업을 확실히 분리하는 것”이었습니다.  
  
### 전체 흐름  
  
최종적으로 정리된 TiDD 운영 흐름은 아래와 같습니다.  
  
```text  
GitHub Issue  
  -> TiDD Ticket 생성  -> 핵심 티켓 브랜치 결정  -> 핵심 티켓 worktree 생성  -> agent-a / agent-b worktree 생성  -> cmux pane 2개에서 병렬 작업  -> 사용자 선택(A / B / 취소)  -> finalize  -> 병합 / 테스트 / 정리 / 보고  
```  
  
현재 구조에서 핵심은 아래 두 가지입니다.  
  
1. 사용자의 현재 브랜치는 절대 자동 checkout 하지 않는다.  
2. 병렬 작업은 `브랜치만`이 아니라 `worktree + 브랜치` 조합으로 분리한다.  
  
### 단계별 구축 기록  
  
#### 1. cmux 기반 운영 전제 정리  
  
정리한 핵심 개념은 아래와 같습니다.  
  
- 구조: `window -> workspace -> pane -> surface`  
- 현재 메인 pane은 좌측에 유지  
- 우측 상단 / 우측 하단에 보조 Codex pane 생성  
- `cmux send`, `cmux read-screen`, `cmux notify`로 자동화  
  
이 흐름을 반복 승인 없이 사용하기 위해 [.codex/rules/default.rules](/Users/yeongmujo/Desktop/Repository/carumuch-backend/.codex/rules/default.rules)에 `cmux` allow rule도 추가했습니다.  
  
#### 2. TiDD 티켓 생성 스킬 정리  
  
GitHub 이슈를 바로 구현하지 않고, 먼저 TiDD 티켓으로 구체화하는 흐름이 필요했습니다.  
  
이를 위해 만든 스킬:  
  
- [carumuch-ticket-generator](/Users/yeongmujo/Desktop/Repository/carumuch-backend/.codex/skills/carumuch-ticket-generator/SKILL.md)  
  
역할은 아래와 같습니다.  
  
- 이슈 본문과 현재 코드 구조를 함께 읽음  
- `docs/tickets/TICKET-<issue-number>.md` 형식으로 변환  
- 작업 범위 / 제외 범위 / 예상 변경 파일 / 완료 조건 / 검증 방법 명시  
- 핵심 티켓 브랜치 후보를 `원본 브랜치`로 기록  
  
예시로 남아 있는 티켓은 [docs/tickets/TICKET-144.md](/Users/yeongmujo/Desktop/Repository/carumuch-backend/docs/tickets/TICKET-144.md)입니다.  
  
이 티켓은 아래 정보를 포함합니다.  
  
- 원본 이슈: `#144`  
- 원본 브랜치: `chore/144-improve-bodyshop-keyword-search`  
- 목표: 공업사 검색 API를 키워드 + 조건 기반으로 확장  
  
#### 3. 개발 사이클 스킬 정리  
  
병렬 agent가 각자 제멋대로 구현하지 않도록 공통 개발 절차가 필요했습니다.  
  
이를 위해 만든 스킬:  
  
- [carumuch-dev-cycle](/Users/yeongmujo/Desktop/Repository/carumuch-backend/.codex/skills/carumuch-dev-cycle/SKILL.md)  
  
핵심 규칙은 아래와 같습니다.  
  
- implementer가 코드 수정  
- verifier가 `bash scripts/verify.sh`만 실행  
- reviewer는 verify 성공 이후에만 수행  
- verify 실패 시 최대 3회까지 반복  
  
이 스킬은 이후 `tidd-orchestrator`에서 agent-a, agent-b가 반드시 따르도록 강제되었습니다.  
  
#### 4. TiDD 오케스트레이터 초안  
  
초기 오케스트레이터는 단순히 아래 요구를 만족하는 데서 출발했습니다.  
  
- 좌측 메인 pane 유지  
- 우측 상단 `agent-a`  
- 우측 하단 `agent-b`  
  
처음에는 “각 agent마다 브랜치를 따로 만든다”는 정도의 개념이었지만, 곧 한계가 드러났습니다.  
  
한계는 아래와 같았습니다.  
  
- 브랜치만 나누면 한 작업 디렉터리에서 병렬 실행이 어렵다.  
- 사용자의 현재 브랜치를 실수로 checkout 변경할 위험이 있다.  
- 비교 실험을 위해서는 파일 트리 자체가 분리되어야 한다.  
  
#### 5. branch-only에서 worktree 기반으로 전환  
  
가장 중요한 설계 전환점은 여기였습니다.  
  
처음 질문은 사실상 이거였습니다.  
  
- “브랜치만 나누면 되나?”  
- “아니면 worktree를 써야 하나?”  
  
결론은 아래였습니다.  
  
- 브랜치는 히스토리 분기  
- worktree는 실제 작업 디렉터리 분리  
- 병렬 Codex 실행에는 `worktree + 브랜치`가 필요  
  
그래서 최종 구조를 아래처럼 바꿨습니다.  
  
```text  
현재 사용자 브랜치(worktree) 유지  
  + 별도 핵심 티켓 브랜치 worktree  + 별도 agent-a/<id> worktree  + 별도 agent-b/<id> worktree  
```  
  
이 판단이 중요했던 이유는, 사용자가 `147` 브랜치에서 작업 중일 때 `144` 티켓을 돌려도 현재 브랜치가 바뀌면 안 되기 때문입니다.  
  
#### 6. 핵심 티켓 브랜치 개념 도입  
  
다음 단계에서는 “agent 브랜치의 부모가 무엇인가”를 명확히 했습니다.  
  
최종 정의:  
  
- `docs/tickets/TICKET-<id>.md`의 `원본 브랜치`를 핵심 티켓 브랜치로 사용  
- 핵심 티켓 브랜치가 없으면 `develop` 기준으로 생성  
- `agent-a/<id>`, `agent-b/<id>`는 모두 이 핵심 티켓 브랜치에서 파생  
  
이 구조를 도입한 이유는 아래와 같습니다.  
  
- 병렬 결과의 기준점을 통일할 수 있음  
- 최종 병합 대상을 분명히 할 수 있음  
- 사용자의 현재 작업 브랜치와 완전히 분리 가능  
  
#### 7. agent 전략 분리  
  
두 agent가 같은 티켓을 읽더라도 똑같이 구현하면 비교할 가치가 줄어듭니다.  
  
그래서 전략을 분리했습니다.  
  
- `agent-a`  
  - 최소 변경  
  - 티켓 범위 엄수  
  - 불필요한 리팩터링 금지  
  
- `agent-b`  
  - 같은 티켓 요구사항 충족  
  - 유지보수성 개선 허용  
  - 네이밍, 계층 책임, 테스트 구조 개선 허용  
  
이렇게 함으로써 사용자는 아래 두 결과를 비교할 수 있게 했습니다.  
  
- “가장 안전한 최소 수정안”  
- “조금 더 정리된 유지보수성 우선안”  
  
#### 8. agent 개발 방식에 dev-cycle 강제  
  
이후 요구사항이 한 단계 더 구체화됐습니다.  
  
- `agent-a`, `agent-b`는 단순히 티켓만 읽는 것이 아니라  
- 반드시 `carumuch-dev-cycle`을 따라 구현해야 한다  
  
그래서 `tidd-orchestrator`는 시작 프롬프트에 아래를 포함하게 됐습니다.  
  
- `AGENTS.md`, `docs/architecture.md`, `docs/code-style.md`, `docs/testing-guide.md` 읽기  
- `TICKET-<id>.md` 읽기  
- `carumuch-dev-cycle` 읽기  
- implementer -> verifier -> reviewer 순서 준수  
- verifier 단계는 `bash scripts/verify.sh`만 수행  
  
#### 9. agent 결과 수집 규약 추가  
  
병렬 작업이 끝난 뒤 메인 pane이 무엇을 보여줘야 하는지도 정리했습니다.  
  
초기에는 단순히 pane을 띄우는 것이 목적이었지만, 이후 최종 비교를 위해 agent의 종료 메시지 형식이 필요해졌습니다.  
  
그래서 아래 고정 마커를 도입했습니다.  
  
- `TIDD_SUMMARY: ...`  
- `TIDD_RECOMMENDATION: ...`  
  
메인 pane은 각 pane의 scrollback을 읽고 이 두 줄을 회수해 최종 결과를 출력하도록 했습니다.  
  
메인 pane 출력 형식은 개념적으로 아래와 같습니다.  
  
```text  
== Agent Results ==  
  
[agent-a]  
작업 요약: ...  
추천안: ...  
  
[agent-b]  
작업 요약: ...  
추천안: ...  
```  
  
#### 10. TiDD finalizer 도입  
  
병렬 작업 뒤 사용자가 `A` 혹은 `B`를 선택했을 때 수동으로 정리하는 것은 반복 비용이 컸습니다.  
  
그래서 만든 스킬:  
  
- [carumuch-tidd-finalizer](/Users/yeongmujo/Desktop/Repository/carumuch-backend/.codex/skills/carumuch-tidd-finalizer/SKILL.md)  
  
역할은 아래와 같습니다.  
  
- 선택 결과 해석: `A`, `B`, `cancel`  
- 선택한 agent 브랜치를 핵심 티켓 브랜치에 병합  
- 핵심 티켓 브랜치 worktree에서 `bash scripts/verify.sh` 수행  
- `agent-a`, `agent-b` pane 정리  
- agent worktree 정리  
- 최종 보고 출력  
  
#### 11. finalizer의 병합 범위 확정  
  
중요한 판단은 “어디까지 병합할 것인가”였습니다.  
  
선택지는 대략 세 가지였습니다.  
  
- 선택한 agent -> 핵심 티켓 브랜치  
- 선택한 agent -> 핵심 티켓 브랜치 -> 현재 사용자 브랜치  
- 병합 없이 확정만 수행  
  
최종 선택은 아래였습니다.  
  
- `선택한 agent 브랜치(worktree) -> 핵심 티켓 브랜치`까지만 병합  
  
이유는 아래와 같습니다.  
  
- 사용자의 현재 작업 브랜치는 TiDD 결과와 분리돼야 함  
- 사용자가 직접 최종 통합 시점을 결정할 수 있어야 함  
- TiDD 결과를 “티켓 단위 산출물”로 먼저 안정화하는 편이 안전함  
  
#### 12. cancel 경로 추가  
  
마지막으로 `A`나 `B`를 고르지 않고 TiDD 실험 자체를 폐기하는 경우도 필요했습니다.  
  
그래서 `carumuch-tidd-finalizer`에 `cancel` 경로를 넣었습니다.  
  
`cancel`의 의미는 아래와 같습니다.  
  
- 병합하지 않음  
- 테스트하지 않음  
- TiDD가 만든 자원만 전부 삭제  
  
정리 대상:  
  
- 핵심 티켓 브랜치 worktree  
- `agent-a/<id>` worktree  
- `agent-b/<id>` worktree  
- 핵심 티켓 브랜치  
- `agent-a/<id>` 브랜치  
- `agent-b/<id>` 브랜치  
- `agent-a`, `agent-b` pane  
  
중요하게도 아래는 건드리지 않습니다.  
  
- 현재 사용자의 작업 브랜치  
- 현재 사용자의 메인 worktree  
- 현재 메인 pane  
  
### 최종 스킬 구성  
  
현재 프로젝트 전용 TiDD 스킬은 아래 네 개입니다.  
  
#### 1. TiDD 티켓 생성  
  
- [carumuch-ticket-generator](/Users/yeongmujo/Desktop/Repository/carumuch-backend/.codex/skills/carumuch-ticket-generator/SKILL.md)  
- 역할:  
  GitHub 이슈를 `docs/tickets/TICKET-<id>.md`로 구체화  
  
#### 2. 공통 개발 사이클  
  
- [carumuch-dev-cycle](/Users/yeongmujo/Desktop/Repository/carumuch-backend/.codex/skills/carumuch-dev-cycle/SKILL.md)  
- 역할:  
  implementer / verifier / reviewer 기준 개발 절차 제공  
  
#### 3. 병렬 실행 오케스트레이터  
  
- [carumuch-tidd-orchestrator](/Users/yeongmujo/Desktop/Repository/carumuch-backend/.codex/skills/carumuch-tidd-orchestrator/SKILL.md)  
- 역할:  
  티켓 분석 -> 핵심 티켓 worktree 생성 -> agent worktree 생성 -> 병렬 작업 -> 결과 수집  
  
#### 4. 마무리 스킬  
  
- [carumuch-tidd-finalizer](/Users/yeongmujo/Desktop/Repository/carumuch-backend/.codex/skills/carumuch-tidd-finalizer/SKILL.md)  
- 역할:  
  선택 결과 병합 / 테스트 / pane 정리 / worktree 정리 / 최종 보고 / cancel 정리  
  
### 현재 최종 운영 구조  
  
현재 정리된 TiDD 운영 구조는 아래와 같습니다.  
  
```text  
1. issue -> ticket  
   GitHub issue를 TICKET-<id>.md로 구체화  
2. ticket -> orchestrator  
   ticket의 원본 브랜치를 읽어 핵심 티켓 브랜치 결정  
3. isolation  
   현재 사용자 브랜치는 그대로 유지   핵심 티켓 브랜치 worktree 생성   agent-a/<id>, agent-b/<id> worktree 생성  
4. parallel execution  
   agent-a: 최소 변경 전략   agent-b: 유지보수성 우선 전략   둘 다 carumuch-dev-cycle 준수  
5. result collection  
   TIDD_SUMMARY / TIDD_RECOMMENDATION 회수  
6. finalize  
   A 또는 B 선택 시:     선택한 agent -> 핵심 티켓 브랜치 병합     verify     pane/worktree 정리  
   cancel 선택 시:     핵심 티켓 브랜치와 agent 자원 전부 정리  
```  
  
### 핵심 판단 요약  
  
이번 작업에서 중요한 설계 판단은 아래와 같습니다.  
  
#### 1. 브랜치만으로는 부족하다  
  
병렬 Codex 실행에는 브랜치만으로 부족하고, worktree가 필요하다고 판단했습니다.  
  
#### 2. 사용자의 현재 브랜치는 건드리면 안 된다  
  
TiDD 자동화는 사용자의 현재 작업을 침범하면 안 되므로, 핵심 티켓 브랜치도 별도 worktree로 분리했습니다.  
  
#### 3. 병렬 비교는 전략 차이가 있어야 한다  
  
`agent-a`와 `agent-b`는 동일 티켓을 읽되, 다른 구현 철학을 가져야 비교 가치가 있습니다.  
  
#### 4. 공통 개발 사이클이 필요하다  
  
단순 병렬 구현만으로는 품질 편차가 커지므로 `carumuch-dev-cycle`을 공통 프로토콜로 강제했습니다.  
  
#### 5. finalize는 현재 사용자 브랜치까지 자동 병합하면 안 된다  
  
핵심 티켓 브랜치까지만 병합하도록 제한해 TiDD 결과를 독립 산출물로 유지했습니다.  
  
#### 6. cancel 경로가 반드시 필요하다  
  
비교 실험이 항상 채택으로 끝나는 것은 아니므로, TiDD 자원만 안전하게 폐기하는 경로가 필요했습니다.  
  
### 운영 시 유의사항  
  
- `cmux` 자동 허용 rule이 없는 환경에서는 pane 제어가 매번 막힐 수 있습니다.  
- TiDD 스킬은 현재 메인 pane 브랜치를 절대 checkout 변경하면 안 됩니다.  
- 최종 검증 기준은 항상 `bash scripts/verify.sh`입니다.  
- agent 결과 수집은 `TIDD_SUMMARY`, `TIDD_RECOMMENDATION` 마커 출력에 의존합니다.  
- dirty worktree는 자동 정리 대상에서 제외하거나, 취소 경로에서만 명시적으로 정리해야 합니다.  
  
### 결론  
  
이번 작업으로 `carumuch-backend`에는 아래 특성을 가진 TiDD 병렬 개발 체계가 구축되었습니다.  
  
- 이슈 -> 티켓 -> 병렬 구현 -> 선택 -> 확정/취소까지 이어지는 닫힌 흐름  
- 사용자 현재 브랜치를 보호하는 worktree 기반 격리  
- 최소 변경안과 유지보수성 우선안을 비교하는 이중 전략  
- `carumuch-dev-cycle` 기반 검증 중심 구현  
- finalize 및 cancel까지 포함한 운영형 스킬 체계  

## 📚 참고 및 링크
- [[ ]]

## 🔗 관련 노트
- [[ ]]
