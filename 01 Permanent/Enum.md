---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---

# Enum

---

## 📄 본문
#### Enum
String으로 상태나 카테고리 같은 것을 표기한다면, 잘못된 문자열을 실수로 입력할 가능성이 있다.
해당 문제는 컴파일 오류로 감지할 수 도 없다.

해당 문제를 타입 열거형 패턴을 통해 해결할 수 있다.
타입 열거형 패턴은 상수로 빼고 외부에서 생성자를 선언하지 않도록 private로 지정하는것을 말한다.

자바에서는 타입 열거형을 쉽게 사용할 수 있도록 Enum 타입을 제공한다.
컴파일 단계에서 오류를 식별할 수 있고 간결하고 일관성이 있다.
새로운 상수만 추가하면 되서 높은 확장성을 가지고 있는것이 특징이다.
상수 마지막 괄호를 열고 생성자에 맞는 파라미터를 전달하면 적절한 생산자가 호출되는 방식이다.

#### point
Enum의 주요 메서드
- **values()** : 모든 ENUM 상수를 포함하는 배열을 반환한다.
- **valueOf(String name)** : 주어진 이름과 일치하는 ENUM 상수를 반환한다.
- **name()** : ENUM 상수의 이름을 문자열로 반환한다.
- **toString()** : ENUM 상수의 이름을 문자열로 반환한다. `name()` 메서드와 유사하지만, `toString()` 은 직접 오버라이드 할 수 있다.
```java
public enum Grade {	 
	BASIC(10), GOLD(20), DIAMOND(30);
 
 	private final int discountPercent;
 
 	Grade(int discountPercent) {
 		this.discountPercent = discountPercent;
	}

 	public int getDiscountPercent() {
 		return discountPercent;
    }
    
    //추가
	public int discount(int price) {
 		return price * discountPercent / 100;
    }
}
```

---

## 📚 참고 및 링크
- [[ ]]

---

## 🔗 관련 노트
- [[ ]]
