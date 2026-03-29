---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - resource
---

# Codex CLI 및 터미널 입력 단축키

---

## 📄 요약
Codex CLI를 진행하기 위해서 유용한 단축키를 정리했습니다.

## 📄 본문

### 1. 기본 입력 제어

- Ctrl + J: 줄바꿈
- Esc: 현재 입력 취소
- Ctrl + C: 실행 중단 (두 번 입력 시 세션 종료)

### 2. 커서 이동

- Ctrl + A: 문장 시작으로 이동
- Ctrl + E: 문장 끝으로 이동
- Option + B: 이전 단어로 이동
- Option + F: 다음 단어로 이동

### 3. 텍스트 편집

- Ctrl + U: 커서 앞 전체 삭제
- Ctrl + K: 커서 뒤 전체 삭제
- Ctrl + W: 이전 단어 삭제

### 4. 명령어 히스토리

- ↑ / ↓: 이전 / 다음 명령어 탐색
- Ctrl + R: 히스토리 검색

### 5. Codex CLI 주요 기능

#### 슬래시 명령어

- /new: 새 세션 시작
- /model: 모델 변경
- /status: 상태 확인
- /compact: 대화 압축
- /diff: 변경사항 확인
- /quit: 종료

#### Bash 명령 실행

- `!명령어` 형태로 실행
    - 예: `!ls`, `!git status`

#### 파일 컨텍스트 전달

- `@파일명` 형태로 입력
    - 예: `@Controller.java`

### 6. 세션 관리

- `codex resume --last`: 마지막 세션 이어서 진행

## ✏️ 메모


## 📚 참고 및 링크
- [[ ]]

## 🔗 관련 노트
- [[ ]]
