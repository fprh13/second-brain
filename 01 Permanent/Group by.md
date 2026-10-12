---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---

# Group by

---

## 📄 본문
### Group by
GROUP BY는 이름 그대로, 특정 컬럼의 값이 같은 행들을 하나의 그룹으로 묶어주는 역할을 한다.  전체에 대한 집계가 아닌 "각 그룹에 대한 집계"를 한다.

즉, 그룹을 만들고 각 그룹을 집계한다는 의미이다.

#### 활용하기
"존도" 사용자에 대해 주문 횟수를 조회하는 상황

##### WEHRE
```sql
SELECT 
	customer_name,
	COUNT(*) AS `주문 횟수`
FROM
	order_stat
GROUP BY 
	customer_name;
```
오로지 order_stat를 조회하는 것이아니다.

예를 들어, "존도"라는 고객이 "게임칩"을 구매한 상황이라고 가정하겠다.

"존도" - "포켓몬스터 레전드 아르세우스"
"존도" - "젤다의 전설 왕국의 눈물"
"존도" - "몬스터헌터 라이즈"

즉, "customer_name=존도, 주문 횟수=3" 이다.

이렇게 "존도"는 총 3개의 게임칩 주문 이력이 존재한다. 만약에 "존도"라는 사용자의 주문 이력만 보고 싶다면 "WHERE"문을 걸면 된다. WHERE 절은 그룹화가 이루어지기 전, 테이블의 개별 행 하나하나에 대해 조건을 검사하기 때문이다.

##### HAVING
2차 필터링이며, 그룹화다. "존도"가 아닌 다른 사용자는 게임칩을 2개 이하로 구매하여 "존도"가 구매 이력이 1등이라고 가정하겠다.
```sql
SELECT 
	customer_name,
	COUNT(*) AS order_count
FROM 
	order_stat
GROUP BY 
	customer_name
HAVING 
	COUNT(*) >= 3;
```
GROUP BY를 통해 사용자 명 별로 묶었고, 주문 횟수가 3인것을 또 묶었다. 그렇다면 "존도"만 조회되게 될것 이다.

##### WHERE vs HAVING
| 구분           |                            |                           |
| ------------ | -------------------------- | ------------------------- |
|              | `WHERE`                    | `HAVING`                  |
| **작동 시점**    | `GROUP BY` 이전`GROUP BY` 이후 |                           |
| **필터링 대상**   | 개별 행 (Row)                 | 그룹 (Group)                |
| **사용 가능 함수** | 집계 함수 사용 불가                | 집계 함수 사용 가능               |
| **역할**       | 개별 행을 선택                   | 그룹화된 결과 중에서 조건에 맞는 그룹만 선택 |
예시를 보면 모두 "존도" 사용자의 구매이력을 조회할 수 있었다. 그렇다면 언제 WHERE를 사용하고 언제 HAVING을 사용할까?

예를 들어, "가격이 5만원 이상인 상품중에서만, 카테고리로 묶어서, 그 상품이 2건 이상 구매한 고객은 누구인가"라고 한다면 아래와 같은 쿼리가 완성될 것이다.
```sql
SELECT
	category,
	COUNT(*) AS premium_order_count
FROM
	order_stat
WHERE
	price >= 50,000  -- 1. 먼저 개별 행을 가격으로 필터링한다.
GROUP BY
	category -- 2. 필터링된 행들을 카테고리별로 그룹화한다.
HAVING
	COUNT(*) >= 2; -- 3. 그룹화된 결과 중, 건수가 2개 이상인 그룹만 필터링한다.
```

즉, 가장 큰 차이는 작동 시점이라고 볼 수 있다.

#### 추가 예시
```sql
SELECT
	customer_name,
	COUNT(*) AS `총 주문 횟수`,
	SUM(quantity) AS `총 구매 수량`,
	SUM(price * quantity) AS `총 구매 금액`
FROM
	order_stat
GROUP BY
	customer_name
ORDER BY
	`총 구매 금액` DESC; -- 백틱 사용 주의!
```

---

## 📚 참고 및 링크
- [[ ]]

---

## 🔗 관련 노트
- [[../02 MOCs/Database|Database]]
