---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---

# Optional

---

## 📄 본문
### Optional
값이 없을 수 있다는 상황을 프로그래머가 명시적으로 처리하도록 유도하고 런타임 NullPointerException을 사전에 예방하기 위해 도입되었다. 값이 없을 수도 있는 상황에서 사용되고 항상 값이 있어야하는 상황에서는 예외를 던지는 방향이 좋을 수 있다.
- **Optional.of(T value)**: 내부 값이 확실히 null이 아닐 때 사용, null을 전달하면 NullPointerException 발생
- **Optional.foNullable(T value)**: 값이 null일 수 도 있고 아닐 수도 있을 때 사용, null이면 Optional.emplty()를 반환한다.
- **Optional.empty()**: 명시적으로 값이 없음을 표현 할 때 사용한다.

#### point
##### 사용법
Optional은 주로 메서드의 반환 값에 대해 값이 없을 수도 있음을 표현하기 위해 도입되었기 때문에 반환 타입으로만 사용하고 필드에는 가급적 쓰지 않습니다.
그리고 자바 공식 문서에 Optional은 메서드의 반환 값으로 사용하기를 권장하고 매개변수로 사용하지 말라고 명시되어있다.
메서드 매개변수로는 사용하지 않고 그 부분은 오버로드로 처리하며, 컬렉션이나 배열 타입은 Optional로 감싸지 않아야한다.
컬렉션 자체는 비어있는 상태를 표현할 수 있기 때문에 이중 표현이 되기 때문이다.
추가적으로 isPresent와 get을 조합해서 사용하지 않아야한다.

##### orElse() vs orElseGet()
비용이 크지 않은 대체값이라면 간단하게 orElse()를 사용한다.
복잡하고 비용이 큰 객체 생성이 필요한 경우, 그리고 Optional 값이 이미 존재할 가능성이 높다면 orElseGet()을 사용한다.
- **orElse 즉시평가**: 값을 바로 생성하거나 계산해 버리는 것
- **orElseGet() 지연평가**: 람다를 통해서 값이 실제로 필요할 때 까지 계산을 미룬다.

##### Optional 값 획득 방법
1. `isPresent()` , `isEmpty()`
    - 값이 있으면 `true`
    - 값이 없으면 `false` 를 반환. 간단 확인용.
    - `isEmpty()` : 자바 11 이상에서 사용 가능, 값이 비어있으면 `true` , 값이 있으면 `false` 를 반환
2. `get()`
    - 값이 있는 경우 그 값을 반환
    - 값이 없으면 `NoSuchElementException` 발생.
    - 직접 사용 시 주의해야 하며, 가급적이면 `orElse` , `orElseXxx` 계열 메서드를 사용하는 것이 안전
3. `orElse(T other)`
    - 값이 있으면 그 값을 반환
    - 값이 없으면 `other` 를 반환.
4. `orElseGet(Supplier<? extends T> supplier)`
    - 값이 있으면 그 값을 반환
    - 값이 없으면 `supplier` 호출하여 생성된 값을 반환.
5. `orElseThrow(...)`
    - 값이 있으면 그 값을 반환
    - 값이 없으면 지정한 예외를 던짐.
6. `or(Supplier<? extends Optional<? extends T>> supplier)`
    - 값이 있으면 해당 값의 `Optional` 을 그대로 반환
    - 값이 없으면 `supplier` 가 제공하는 다른 `Optional` 반환
    - 값 대신 `Optional` 을 반환한다는 특징


---

## 📚 참고 및 링크
- [[ ]]

---

## 🔗 관련 노트
- [[../02 MOCs/Java|Java]]
