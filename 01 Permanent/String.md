---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---

# String

---

## 📄 본문
### String 클래스
기본형인 char를 통해서 여러 문자를 나열하려면 char[ ]를 사용해야함으로 굉장히 불편하다.
그러므로 참조형인 String 클래스를 주로 사용한다.
문자열은 자주 사용되기 때문에 new 키워드를 통해 String 객체를 생성하는것을 생략하고 쌍따옴표안에 문자열을 적으면 바로 String 객체를 생성할 수 있게 해준다.

String은 자바 9버전 이전에는 char[ ] 안에 문자 하나당 2바이트로 관리되었다.
자바 9버전 이후에는 byte[ ]를 통해 영어와 숫자는 1바이트 나머지는 2바이트로 문자열을 내부에서 관리한다.

#### point
String의 대표적인 기능
- `.length()` : 문자열의 길이를 반환한다.
- `.isEmpty()` : 문자열이 비어 있는지 확인한다. (길이가 0)
- `.isBlank()` : 문자열이 비어 있는지 확인한다. (길이가 0이거나 공백(Whitespace)만 있는 경우), 자바 11
- `.charAt(int index)` : 지정된 인덱스에 있는 문자를 반환한다.

##### 문자열 비교
- `.equals(Object anObject)` : 두 문자열이 동일한지 비교한다.
- `.equalsIgnoreCase(String anotherString)` : 두 문자열을 대소문자 구분 없이 비교한다.
- `.compareTo(String anotherString)` : 두 문자열을 사전 순으로 비교한다.
- `.compareToIgnoreCase(String str)` : 두 문자열을 대소문자 구분 없이 사전적으로 비교한다.
- `.startsWith(String prefix)` : 문자열이 특정 접두사로 시작하는지 확인한다.
- `.endsWith(String suffix)` : 문자열이 특정 접미사로 끝나는지 확인한다.

##### 문자열 검색
- `.contains(CharSequence s)` : 문자열이 특정 문자열을 포함하고 있는지 확인한다.
- `.indexOf(String ch) / indexOf(String ch, int fromIndex)` : 문자열이 처음 등장하는 위치를 반환한다.
- `.lastIndexOf(String ch)` : 문자열이 마지막으로 등장하는 위치를 반환한다.

##### 문자열 조작 및 변환
- `.substring(int beginIndex) / .substring(int beginIndex, int endIndex)` : 문자열의 부분 문자열을 반환한다.
- `.concat(String str)` : 문자열의 끝에 다른 문자열을 붙인다.
- `replace(CharSequence target, CharSequence replacement)` : 특정 문자열을 새 문자열로 대체한다.
- `.replaceAll(String regex, String replacement)` : 문자열에서 정규 표현식과 일치하는 부분을 새 문자열로 대체한다.
- `.replaceFirst(String regex, String replacement)` : 문자열에서 정규 표현식과 일치하는 첫 번째 부분을 새 문자열로 대체한다.
- `.toLowerCase() / toUpperCase()` : 문자열을 소문자나 대문자로 변환한다.
- `.trim()` : 문자열 양쪽 끝의 공백을 제거한다. 단순 Whitespace 만 제거할 수 있다.
- `.strip()` : Whitespace 와 유니코드 공백을 포함해서 제거한다. 자바 11

##### 문자열 분할 및 조합
- `.split(String regex)` : 문자열을 정규 표현식을 기준으로 분할한다.
- `.join(CharSequence delimiter, CharSequence... elements)` : 주어진 구분자로 여러 문자열을 결합한다.

##### 기타 유틸리티
- `.valueOf(Object obj)` : 다양한 타입을 문자열로 변환한다.
- `.toCharArray()` : 문자열을 문자 배열로 변환한다.
- `.format(String format, Object... args)` : 형식 문자열과 인자를 사용하여 새로운 문자열을 생성한다.
- `.matches(String regex)` : 문자열이 주어진 정규 표현식과 일치하는지 확인한다.


### String은 불변 객체이다.
String은 불변 객체라서 생성 이후에 내부의 문자열을 변경할 수 없다.
그렇기 때문에 변경이 필요할 때는 기존 값을 변경하지 않고 새로운 결과를 만들어서 반환한다.
자바는 내부의 상수 pool을 통해서 문자열을 최적화한다.
특정 문자를 참조하는 여러 String이 존재하고 문자열을 변경하면 참조하고 있는 모든 문자가 수정되는 사이드 이펙트가 있기 때문에 String 클래스는 불변으로 설계하게 되었다.

#### point
불변 객체(Immutable Object)란 객체가 생성된 이후 내부 상태를 변경할 수 없는 객체를 의미한다.

필드를 `final`로 선언하고 setter와 같이 상태를 변경하는 메서드를 제공하지 않으며, 생성자를 통해 객체의 초기 상태를 설정한다.

또한 참조 타입의 필드를 가지는 경우 외부에서 해당 객체의 내부 상태를 변경할 수 없도록 방어적 복사 등의 방법을 고려해야 한다.

##### 방어적 복사
방어적 복사(Defensive Copy)란 외부에서 전달받거나 외부로 반환하는 가변 객체를 그대로 참조하지 않고 복사본을 사용하여, 외부의 변경이 객체 내부 상태에 영향을 주지 않도록 하는 방법이다.
```java
public class Person {
    private final List<String> hobbies;

    public Person(List<String> hobbies) {
        this.hobbies = new ArrayList<>(hobbies); // 방어적 복사
    }

    public List<String> getHobbies() {
        return new ArrayList<>(hobbies); // 방어적 복사
    }
}
```

##### 가변 객체 vs 불변 객체
가변 객체는 처음 만든 이후 상태가 변할 수 있는 객체이다.
불변은 처음 만든 이후 상태가 변하지 않는 객체이다.
따라서 불변 객체의 값을 변경해야한다면, 값이 변경된 새로운 객체를 만들어서 반환해야한다.

### StringBuilder
불변 String 클래스의 단점은 문자를 더하거나 변경하려는 경우 발생한다.
문자를 더하거나 변경할 때 새로운 객체를 계속 생성해야한다.
그 만큼 더 많은 GC를 해야한다.
결과적으로는 CPU, 메모리 리소스를 더 많이 사용하게 된다.
그래서 가변 String이라고 불리는 StringBuilder를 사용하고 연산 후 안전하게 불변 String으로 변경하는 방식으로 사용한다.

#### point
StringBuilder의 대표기능
- `.append()` 메서드를 사용해 여러 문자열을 추가한다.
- `.insert()` 메서드로 특정 위치에 문자열을 삽입한다.
- `.delete()` 메서드로 특정 범위의 문자열을 삭제한다.
- `.reverse()` 메서드로 문자열을 뒤집는다.
- `.toString()` 메소드를 사용해 `StringBuilder` 의 결과를 기반으로 `String` 을 생성해서 반환한다.

##### 코드로 이해하기
```java
StringBuilder sb = new StringBuilder();
sb.append("A");
sb.append("B");
sb.append("C");
sb.append("D");
System.out.println("sb = " + sb);
        
sb.insert(4, "Java");
System.out.println("insert = " + sb);

sb.delete(4, 8);
System.out.println("delete = " + sb);

sb.reverse();
System.out.println("reverse = " + sb);

//StringBuilder -> String
String string = sb.toString();
System.out.println("string = " + string);

// 메소드 체이닝 가능, append하고 this 반환하는 느낌
String string = sb.append("A").append("B").append("C").append("D")
		.insert(4, "Java")
        .delete(4, 8)
        .reverse()
        .toString();
```

### 자바의 String 최적화
자바는 문자열 리터널을 더하는 부분을 자동으로 합쳐준다. 따라서 런타임에 별도의 문자열 결합 연산을 수행하지 않기 때문에 성능이 향상된다.
`"Hello, " + "World!" -(컴파일 전, 후)-> "Hello, World!"`

문자열 변수의 경우 그 안에 어떤 값이 들어가있는지 컴파일 시점에 알 수 없기 때문에 단순하게 합칠 수 없다.
이때 자바에서는 StringBuilder를 사용하는데, StringBuilder로 변환하여 문자열을 더한 뒤 다시 불변 String으로 변환하여 최적화를 수행한다.
`str1 + str2 -(컴파일 전, 후)-> new StringBuilder().append(str1).append(str2).toString()`

### StringBuffer
내부에 동기화가 되어 있어, 멀티 스레드 환경에서 안전하다.
하지만 동기화 오버헤드로 인해 성능이 상대적으로 느리다.


---

## 📚 참고 및 링크
- [[ ]]

---

## 🔗 관련 노트
- [[ ]]
