# 개인 지식 관리 시스템 설계 계획서

_Obsidian Vault Architecture_

## 1. 설계 목적
본 Vault는 장기적으로 축적되는 지식, 기록, 프로젝트 자료를 효율적으로 관리하기 위한 개인 지식 관리 시스템이다.

핵심 목표:
- 지식의 장기 축적
- 정보 간 연결을 통한 지식 그래프 형성
- 프로젝트 및 활동 기록 관리
- 구조적으로 확장 가능한 Vault 유지

이를 위해 **Zettelkasten 방식의 지식 연결 구조**와 **PARA 방식의 정보 관리 구조**를 결합한다.

## 2. 전체 구조
Vault는 두 영역으로 구성된다.
- 지식 생성 영역 (Zettelkasten)
- 정보 관리 영역 (PARA)

```text
Vault
├─ 00 Inbox
├─ 01 Permanent
├─ 02 MOCs
├─ 10 Projects
├─ 11 Areas
├─ 12 Resources
└─ 13 Archive
```

숫자 접두어는 정렬 안정성과 영역 구분을 위해 사용한다.

## 3. 각 영역의 역할
| 영역 | 역할 | 특징 |
|---|---|---|
| Inbox | 임시 기록 공간 | 빠른 메모, 구조화 이전 단계 |
| Permanent | 이해 기반 지식 노드 | 개념 간 연결 중심, 지식 그래프 핵심 |
| MOCs | 지식 지도 (Map of Content) | 노드 묶음, 탐색 허브 |
| Projects | 목표 기반 작업 기록 | 기간성 작업, 완료 후 Archive 이동 |
| Areas | 지속 관리 영역 | 종료 시점 없음, 책임 영역 관리 |
| Resources | 참고 자료 저장 | 개념/외부 지식 정리, 자료 보관 |
| Archive | 종료된 정보 저장 | 볼트 정리 유지, 기록 보존 |

## 4. 노드 연결 규칙
그래프 구조 안정성을 위해 다음 원칙을 사용한다.

- 기본 흐름: `Project -> Resource -> Permanent`
- Resource -> Permanent: 개념에서 사고로 연결
- Permanent <-> Permanent: 지식 간 관계 강화
- MOC: 관련 노드를 묶는 허브

## 5. 작성 흐름
```text
Inbox 기록
 -> 분류 (Permanent / Resource / Project 등)
 -> 관련 노드 연결
 -> MOC 구조 반영
```

## 6. 노트 템플릿
### Permanent 템플릿
- 개념
- 핵심 내용
- 관련 노드

### Resource 템플릿
- 정의
- 설명
- 예시

### Project 템플릿
- 목적
- 구현 내용
- 문제 해결
- 관련 노드

## 7. 이미지 및 데이터 관리
이미지 및 첨부 파일은 별도 디렉토리에서 관리하고, 노트에서는 링크로 참조한다.

```text
attachments
├─ diagrams
├─ screenshots
└─ files
```

## 8. 확장 전략
- 지식 노드는 지속적으로 추가 가능
- MOC를 통해 구조적 확장
- Projects 완료 시 Archive로 이동
