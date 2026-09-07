---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---

# Boxing

---

## 📄 본문
### 박싱
기본형을 래퍼 클래스로 변경하는 것을 박싱이라고 한다.

`new Integer(10)`를 직접사용하면 안된다.
`Integer.valueOf(10)`을 사용하면 성능 최적화가 있다.
미리 생성해둔 -128 ~ 127 안에 있는 수가 아니라면, 알아서 new를 호출해서 사용하게 된다.

#### point
자바는 객체 지향 언어인데, 기본형 같은 경우에는 객체가 아니기 때문에 메서드를 제공하거나, 컬렉션 프레임워크, 제네릭 같은 기능을 사용할 수 없다. 또한 null을 가질 수 없다.
래퍼클래스는 기본형의 객체 버전이며, 기본적으로 불변 객체이다.

##### 기본형 vs 참조형
기본형은 하나의 값을 여러 변수에서 공유하지 않는다.
참조형은 하나의 객체를 참조값을 통해 여러 변수에서 공유 할 수 있다.
참조형은 참조값 대입을 막을 수 없어 사이드 이펙트가 발생할 수 있다.
그렇기 때문에 불변 객체를 통해 해결해야되는 점이 있다.

기본형은 메모리에서 단순히 그 크기만큼의 공간을 차지하지만
참조형은 객체 자체로 다루기 때문에 더 많은 메모리를 사용한다.

### 언박싱
래퍼 클래스에 들어있는 기본형 값을 다시 꺼내는 메서드이다.
`.intValue()` 가 대표적인 예시이다.

### 오토 박싱, 오토 언박싱
박싱과 언박싱 과정은 빈번하게 일어난다. 따라서 박싱과 언박싱 과정을 생략해도 컴파일 단계에서 박싱과 언박싱을 진행해주는 과정을 추가해준다. 해당 방식을 오토 박싱, 오토 언박싱이라고 한다.
```java
Integer boxedValue = value; //오토 박싱(Auto-boxing) 
Integer boxedValue = Integer.valueOf(value); //컴파일 단계에서 추가 
int unboxedValue = boxedValue; //오토 언박싱(Auto-Unboxing) 
int unboxedValue = boxedValue.intValue(); //컴파일 단계에서 추가
```
#### point
주요 메서드
- `.valueOf()` : 래퍼 타입을 반환한다. 숫자, 문자열을 모두 지원한다.
- `.parseInt()` : 문자열을 기본형으로 변환한다.
- `.compareTo()` : 내 값과 인수로 넘어온 값을 비교한다. 내 값이 크면 1, 같으면 0, 작으면 -1을 반환한다.
- `Integer.sum(), Integer.min(), Integer.max()` : `static` 메서드이다. 간단한 덧셈, 작은 값, 큰 값 연산을 수행한다.
```java
Integer i1 = Integer.valueOf(10);//숫자, 래퍼 객체 반환 
Integer i2 = Integer.valueOf("10");//문자열, 래퍼 객체 반환 
int intValue = Integer.parseInt("10");//문자열 전용, 기본형 반환 //비교 
int compareResult = i1.compareTo(20);
System.out.println("compareResult = " + compareResult); //산술 연산
System.out.println("sum: " + Integer.sum(10, 20));
System.out.println("min: " + Integer.min(10, 20));
System.out.println("max: " + Integer.max(10, 20));
```

##### parseInt() vs valueOf()
원하는 타입에 맞는 메서드를 사용하면 된다.
- `valueOf("10")` 는 래퍼 타입을 반환한다.
- `parseInt("10")` 는 기본형을 반환한다.

---

## 📚 참고 및 링크
- [[ ]]

---

## 🔗 관련 노트
- [[ ]]
