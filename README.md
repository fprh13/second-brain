# 개발자용 옵시디언 가이드 (Zettelkasten + PARA)

이 볼트는 개발자가 **생각 정리(제텔카스텐)**와 **업무 관리(PARA)**를 같이 하도록 만든 구조입니다.

## 1. 가장 쉬운 운영 원칙

- 모르면 일단 `00 Inbox`에 캡처
- 완성하려고 쓰지 말고, 사실/문제/느낌만 짧게 기록
- 당일 또는 다음날 트리아지(분류)로 다음 단계로 보냄

## 2. 실제 워크플로우 (추천)

1. `00 Inbox`에 빠르게 기록
2. 하루 1회 트리아지
3. 아래 중 하나로 승격
- `01 Fleeting Notes`: 짧은 생각 스냅샷
- `02 Literature Notes`: 읽은 자료 요약
- `03 Permanent Notes`: 재사용 가능한 지식
- `10 Projects/Active`: 실행이 필요한 업무/문제
- `12 Resources/*`: 참고 자료 보관

트리아지 후에는 인박스 노트에 결과 링크를 남기면 추적이 쉽습니다.

## 3. 어디에 적어야 할지 빠른 기준

- 갑자기 떠오른 생각/할 일: `00 Inbox`
- 문서/강의/블로그 요약: `02 Literature Notes`
- 원칙/패턴/교훈: `03 Permanent Notes`
- 진행 중 업무/실행계획: `10 Projects/Active`
- 장애 원인 분석: `10 Projects/Active` (Debug 템플릿)
- 아키텍처/기술 의사결정: `10 Projects/Active` (ADR 템플릿)
- 자주 쓰는 코드/명령어: `12 Resources/Snippets`
- 공식 문서/레퍼런스 모음: `12 Resources/Docs`

## 4. 프로젝트 노트 관리 방식

- 기본은 `10 Projects/Active`에 **프로젝트당 노트 파일 1개**
- 관련 자료가 많아질 때만 프로젝트 폴더로 승격
- 예시: `10 Projects/Active/프로젝트명/README.md`

즉, 처음부터 전부 폴더로 나누지 않고 커지는 프로젝트만 분리합니다.

## 5. 템플릿 사용법

1. 새 노트 생성
2. 명령 팔레트 열기
3. `Insert template` 실행
4. `14 Templates`에서 선택

주요 템플릿:
- `00 Inbox Template`
- `02 Literature Note Template`
- `03 Permanent Note Template`
- `05 Project Note Template`
- `08 ADR Template`
- `09 Debug Log Template`

## 6. 저에게 요청하는 예시

- `이 Inbox를 어디로 보낼지 분류해줘.`
- `이 문헌노트를 Permanent Note로 승격해줘.`
- `이 문제를 Project Note(목표/DoD/실행계획)로 정리해줘.`
- `이 장애 내용을 Debug Log + 재발방지 노트로 만들어줘.`

## 7. 폴더 구조 요약

- Zettelkasten: `00`~`04`
- PARA: `10`~`13`
- 운영: `14 Templates`, `15 Attachments`
