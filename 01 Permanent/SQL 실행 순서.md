---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---

# SQL 실행 순서

---

## 📄 본문
### SQL 실행 순서
SQL 쿼리는 **FROM -> ON -> JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT** 순으로 처리 된다.

#### 암기
FOJO WGH SDOL

#### 상세
**FROM**
- 각 테이블을 확인한다.

**ON**
- JOIN 조건을 확인한다.

**JOIN**
- JOIN이 실행되어 데이터가 SET으로 모아진다. 서브쿼리도 함께 포함되어 임시 테이블을 만들 수 있게 도와준다.

**WHERE**
- 데이터셋을 형성하게 되면 WHERE의 조건이 개별 행에 적용된다. WHERE절의 제약 조건은 FROM 절로 가져온 테이블에 적용될 수 있다.

**GROUP BY**
- WHERE의 조건 적용 후 나머지 행은 GROUP BY절에 지정된 열의 공통 값을 기준으로 그룹화된다. 쿼리에 집계 기능이 있는 경우에만 이 기능을 사용해야한다.

**HAVING**
- GROUP BY 절이 쿼리에 있을 경우 HAVING 절의 제약조건이 그룹화된 행에 적용된다.

**SELECT**
- SELECT에 표현된 식이 마지막으로 적용된다.

**DISTINCT**
- 표현된 행에서 중복된 행은 삭제

**ORDER BY**
- 지정된 데이터를 기준으로 오름차순, 내림차순 지정

**LIMIT**
- LIMIT에서 벗어나는 행들은 제외되어 출력된다.

---

## 📚 참고 및 링크
- [[ ]]

---

## 🔗 관련 노트
- [[SQL 실행 순서]]
