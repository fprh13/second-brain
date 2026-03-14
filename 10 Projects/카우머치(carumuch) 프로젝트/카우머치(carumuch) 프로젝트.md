# 카우머치(carumuch) 프로젝트

## 📄 개요
- AI 기반 차량 사고 분석 및 견적 입찰 서비스
- 사용자가 사고 레포트를 제출하면 AI가 자동으로 수리 견적을 생성하고, 여러 공업사로부터 입찰 제안을 받을 수 있다.
- 캡스톤 디자인 경진대회에서 최우수상을 수상했고, 현재는 백엔드 시스템 전반 리팩토링을 진행 중이다.
- 인원: 총 5명 (백엔드 2명, 프론트엔드 1명, AI 1명, 디자이너 1명)
- V1 기간: 2024.05.01 ~ 2024.11.06
- V2 기간: 2025.11.11 ~ 진행 중

### 기술 스택
- Java, Spring Boot, JPA, QueryDSL, RestDocs + OAS3
- MySQL, Redis
- AWS, Docker Compose, GitHub Actions
- Grafana, Loki, Promtail, Prometheus, RabbitMQ

### 담당 업무
#### V1
- 핵심 도메인 기능 구현
- JWT 인증/인가 및 소셜 로그인 기능
- 프로젝트 배포 및 CI/CD

#### V2
- DDD 기반 아키텍처 재설계
- AOP / Filter 로깅 및 모니터링 환경 구축
- JWT 인증/인가 재설계
- API 문서 자동 생성 및 배포 파이프라인 구축 (RestDocs + OAS3)
- AI 견적서 처리 플로우를 비동기 이벤트 기반으로 재설계

## 📄 메모
현재 관심사는 V2 리팩토링과 백엔드 아키텍처 재설계다.

- GitHub 레포: https://github.com/carumuch/carumuch-backend
- API 문서: https://carumuch-api-docs.vercel.app

## 🏃 다음 액션
- [ ] API 문서 자동 생성 및 배포 파이프라인 작업 노트 작성
- [ ] JWT 인증/인가 재설계 메모 작성
- [ ] AI 견적 비동기 이벤트 처리 플로우 정리


## 🔗 관련 노트 (선택)
- [[Develop]]
