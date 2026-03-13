# OMX

## 요약
- OMX는 Codex CLI 위에 팀 오케스트레이션, 스킬 실행, 메모리, 운영 제어를 얹는 애드온이다.
- 단일 세션 중심 작업을 여러 역할과 단계로 분해해 더 큰 작업을 다루기 쉽게 만든다.
- 포크가 아니라 Codex의 프롬프트, 스킬, MCP, 설정 주입 같은 확장 지점을 활용한다.

## 본문
### 핵심 기능
- 역할 프롬프트와 워크플로 스킬을 통해 반복 가능한 실행 모드를 제공한다.
- `omx team`으로 tmux 기반 병렬 워커를 운영할 수 있다.
- `.omx/` 상태, MCP 메모리, HUD, 취소/검증 명령으로 장기 세션 운영을 지원한다.
- `omx setup`으로 user 또는 project 범위에 프롬프트, 스킬, 설정을 설치한다.

### 빠른 시작
```shell
npm install -g oh-my-codex
omx setup
omx doctor
```

권장 시작 플래그:

```shell
omx --xhigh --madmax
```

### 주요 명령어
```shell
omx
omx setup
omx doctor
omx team ...
omx status
omx cancel
omx hooks ...
```

### 운영 메모
- 팀 모드는 `start -> assign -> monitor -> verify -> shutdown` 흐름으로 이해하면 된다.
- `--madmax`는 Codex의 sandbox 우회 옵션에 대응하므로 신뢰 가능한 환경에서만 써야 한다.
- `omx hooks`는 추가 확장 표면이고, 기존 `omx tmux-hook`을 대체하지 않는다.
- 현재 볼트 기준으로는 [[AI 에이전트 오케스트레이션 정리]]와 함께 보면 역할 분리와 운영 흐름을 비교하기 쉽다.

### 메모
- 원문 README: https://github.com/Yeachan-Heo/oh-my-codex/blob/main/README.ko.md
- 전체 문서: https://yeachan-heo.github.io/oh-my-codex-website/docs.html
- CLI 레퍼런스: https://yeachan-heo.github.io/oh-my-codex-website/docs.html#cli-reference
- 릴리스 노트: https://yeachan-heo.github.io/oh-my-codex-website/docs.html#release-notes

## 관련 노트 (선택)
- [[AI 에이전트 오케스트레이션 정리]]
- [[AI]]
- [[Develop]]
