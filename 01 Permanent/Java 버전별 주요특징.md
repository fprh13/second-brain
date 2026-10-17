---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# Java 버전별 주요 특징

---

## 📄 본문

### Java 버전과 LTS

Java는 일반적으로 6개월 주기로 새로운 기능을 포함한 버전을 출시하며, 그중 일부 버전을 LTS(Long-Term Support)로 지정하여 장기간 유지보수한다.

LTS는 장기 지원 버전을 의미하며, 운영 환경에서 보안 패치와 버그 수정 등을 지속적으로 제공받을 수 있다는 장점이 있다.

2026년 10월 기준 최신 Java 버전은 **Java 27이며, 최신 LTS 버전은 Java 25**이다.

#### 주요 버전

| Java 버전 | 출시 시기   | LTS | 주요 특징                                                               |
| ------- | ------- | --- | ------------------------------------------------------------------- |
| Java 8  | 2014.03 | O   | Lambda, Stream API, Optional, Date/Time API                         |
| Java 11 | 2018.09 | O   | HttpClient 표준화, String API 확장                                       |
| Java 17 | 2021.09 | O   | Sealed Classes, Record 및 Pattern Matching 활용                        |
| Java 21 | 2023.09 | O   | Virtual Threads, Pattern Matching for switch, Sequenced Collections |
| Java 25 | 2025.09 | O   | Scoped Values 정식 지원, Compact Object Headers, 언어 기능 개선               |
| Java 26 | 2026.03 | X   | Java 25 이후의 기능 개선 및 신규 기능 도입                                        |
| Java 27 | 2026.09 | X   | 최신 기능을 포함한 일반 릴리스                                                   |

Java 8, 11, 17, 21, 25가 현재의 주요 LTS 버전이다.

Java 17 이후에는 LTS 출시 주기가 기존 3년에서 2년으로 단축되었다.

이에 따라 Java 17(2021년), Java 21(2023년), Java 25(2025년)가 순차적으로 출시되었으며, 다음 LTS는 **2027년 9월 출시 예정인 Java 29**이다.

이러한 변경은 새로운 언어 기능과 JVM 개선 사항을 장기 지원 버전에서도 더 빠르게 사용할 수 있도록 하기 위한 것이다. [Oracle](https://www.oracle.com/kr/java/technologies/java-se-support-roadmap.html?utm_source=chatgpt.com)

#### LTS와 일반 릴리스의 차이

|구분|LTS|일반 릴리스(Non-LTS)|
|---|---|---|
|출시 주기|약 2년|약 6개월|
|지원 기간|장기 지원|상대적으로 짧음|
|주요 목적|장기적인 운영 및 유지보수|최신 기능 도입 및 검증|
|운영 환경|일반적으로 권장|빠른 업그레이드가 가능한 환경에 적합|
|대표 버전|17, 21, 25|22, 23, 24, 26, 27|

LTS라고 해서 일반 릴리스보다 코드의 품질이나 성능이 무조건 우수한 것은 아니다.

LTS의 가장 큰 차이는 장기적인 보안 업데이트와 유지보수 지원을 받을 수 있다는 점이다.

또한 LTS 지원 기간은 JDK 배포사에 따라 다르다.

대표적인 JDK 배포사로는 Oracle JDK, Eclipse Temurin, Amazon Corretto 등이 있으며, 동일한 Java 버전이라도 지원 종료 시점과 라이선스 정책은 다를 수 있다.

따라서 실제 운영 환경에서는 Java 버전뿐 아니라 **어떤 JDK 배포판을 사용하는지도 확인해야 한다.**

### Java 8 (LTS)

Java 8은 함수형 프로그래밍을 지원하는 주요 기능이 도입된 버전이다.

대표적으로 Lambda 표현식, Stream API, Optional, 새로운 날짜 및 시간 API가 추가되었다.

현재 Java 개발에서도 널리 사용되는 기능들이 이 버전에서 도입되었다.

#### 주요 변경 사항

|기능|설명|
|---|---|
|Lambda|익명 함수를 간결하게 표현|
|Stream API|컬렉션 데이터의 필터링, 변환, 집계|
|Optional|값이 없을 수 있음을 표현|
|Date/Time API|`LocalDate`, `LocalDateTime` 등 새로운 날짜 API|
|Interface Default Method|인터페이스에 기본 구현 메서드 선언 가능|

#### Lambda와 Stream API

기존에는 컬렉션 데이터를 처리할 때 반복문을 직접 사용하는 방식이 일반적이었다.

Java 8부터는 Stream API를 통해 데이터 처리 과정을 선언적으로 표현할 수 있다.

```java
List<String> names = List.of("Kim", "Lee", "Park");

List<String> result = names.stream()
        .filter(name -> name.startsWith("K"))
        .map(String::toUpperCase)
        .toList();
```

위 코드에서 사용한 `filter`, `map`은 Java 8에서 도입되었지만, `Stream.toList()`는 Java 16에서 추가된 메서드다.

따라서 Java 8에서는 다음과 같이 작성해야 한다.

```java
List<String> result = names.stream()
        .filter(name -> name.startsWith("K"))
        .map(String::toUpperCase)
        .collect(Collectors.toList());
```

또한 `List.of()`는 Java 9에서 추가되었으므로 Java 8에서는 `Arrays.asList()` 등을 사용해야 한다.

이처럼 Java의 언어 기능뿐 아니라 **표준 라이브러리 API가 어느 버전에서 추가되었는지도 구분해야 한다.**

#### 사용 시점

Java 8은 기존 레거시 시스템을 유지보수하거나 오래된 라이브러리 및 애플리케이션 서버와의 호환성이 필요한 경우 사용한다.

새로운 Spring Boot 프로젝트에서는 일반적으로 선택할 이유가 적다.

특히 Spring Boot 3부터는 Java 17 이상이 필수이므로 Java 8을 사용할 수 없다.

### Java 11 (LTS)

Java 11은 Java 8 이후의 주요 LTS 버전이다.

Java 9에서 도입된 모듈 시스템과 Java 10의 지역 변수 타입 추론 기능을 포함하며, Java 11에서는 표준 HTTP 클라이언트와 여러 편의 API가 추가되었다.

#### 주요 변경 사항

|기능|최초 도입 버전|설명|
|---|---|---|
|Java Platform Module System|9|모듈 단위 의존성 및 접근 제어|
|`var`|10|지역 변수 타입 추론|
|HttpClient|11|표준 HTTP 클라이언트 API|
|String API 확장|11|`isBlank()`, `strip()`, `lines()`, `repeat()`|
|파일 읽기/쓰기 API|11|`Files.readString()`, `Files.writeString()`|

#### var

Java 10부터 지역 변수에 `var`를 사용할 수 있다.

```java
var name = "홍길동";
var age = 25;
```

컴파일러가 초기화 표현식을 바탕으로 타입을 추론한다.

따라서 `var`는 동적 타입이 아니며, 컴파일 시점에 타입이 결정된다.

```java
var name = "홍길동";

name = 10; // 컴파일 오류
```

`var`는 지역 변수 등에 사용할 수 있지만 클래스 필드나 일반적인 메서드 매개변수 타입을 대체할 수는 없다.

#### HttpClient

Java 11에서는 HTTP 요청을 처리하는 `HttpClient` API가 정식으로 도입되었다.

```java
HttpClient client = HttpClient.newHttpClient();

HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create("https://api.example.com/users"))
        .GET()
        .build();

HttpResponse<String> response = client.send(
        request,
        HttpResponse.BodyHandlers.ofString()
);
```

별도의 HTTP 클라이언트 라이브러리 없이 외부 API를 호출할 수 있다.

다만 Spring Boot 환경에서는 일반적으로 `RestClient`, `WebClient` 등 Spring에서 제공하는 HTTP 클라이언트도 선택할 수 있다.

#### 사용 시점

Java 11은 Java 8 기반 시스템을 개선했거나 Java 17 이상의 도입이 어려운 기존 시스템에서 사용한다.

신규 Spring Boot 3 또는 4 프로젝트에서는 사용할 수 없다.

### Java 17 (LTS)

Java 17은 현대적인 Java 백엔드 개발에서 중요한 기준이 되는 버전이다.

Java 12~16에서 추가된 언어 기능을 포함하며, Java 17에서는 Sealed Classes가 정식 기능으로 도입되었다.

특히 **Spring Boot 3와 Spring Boot 4의 최소 Java 버전이 17**이므로 Spring 기반 백엔드 개발에서 중요한 의미를 가진다.

#### 주요 변경 사항

|기능|최초 정식 도입 버전|설명|
|---|---|---|
|Switch Expressions|14|`switch`를 표현식으로 사용|
|Text Blocks|15|여러 줄 문자열 작성|
|Records|16|데이터 전달용 클래스 간결화|
|Pattern Matching for instanceof|16|타입 검사와 형변환 간소화|
|Sealed Classes|17|클래스 및 인터페이스 상속 제한|

Java 17에서 위 기능들이 모두 처음 도입된 것은 아니다.

이전 버전에서 정식 도입된 기능을 Java 17에서도 안정적으로 사용할 수 있다는 의미다. [Oracle Documentation](https://docs.oracle.com/en/java/javase/25/language/java-language-changes-summary.html?utm_source=chatgpt.com)

#### Records

Record는 데이터를 전달하기 위한 클래스를 간결하게 선언할 수 있도록 지원한다.

기존에는 DTO를 작성할 때 생성자, Getter, `equals()`, `hashCode()`, `toString()` 등을 직접 구현하거나 Lombok을 사용했다.

```java
public record UserResponse(
        Long id,
        String name
) {
}
```

Record는 다음 특징을 가진다.

- 필드에 해당하는 컴포넌트는 변경할 수 없도록 구성된다.
- 생성자와 접근자 등이 자동 생성된다.
- `equals()`, `hashCode()`, `toString()`이 자동 구현된다.

다만 Record가 참조하는 객체까지 자동으로 불변이 되는 것은 아니다.

따라서 Record는 얕은 불변성을 제공하며, 가변 객체를 컴포넌트로 사용하는 경우 방어적 복사 등을 고려해야 한다.

Spring Boot에서는 요청 및 응답 DTO에 활용하기 좋다.

#### Pattern Matching for instanceof

기존에는 `instanceof`로 타입을 확인한 뒤 명시적으로 형변환해야 했다.

**기존 방식**

```java
if (value instanceof String) {
    String text = (String) value;
    System.out.println(text);
}
```

**변경된 방식**

```java
if (value instanceof String text) {
    System.out.println(text);
}
```

타입 검사와 형변환을 하나의 표현식으로 처리할 수 있다.

#### Sealed Classes

Sealed Classes는 특정 클래스나 인터페이스를 상속 또는 구현할 수 있는 타입을 제한한다.

```java
public sealed interface PaymentResult
        permits Success, Failure {
}

public record Success(Long paymentId)
        implements PaymentResult {
}

public record Failure(String reason)
        implements PaymentResult {
}
```

`PaymentResult`를 구현할 수 있는 타입을 `Success`, `Failure`로 제한한다.

도메인에서 허용되는 결과나 상태의 종류를 명확하게 정의할 때 활용할 수 있다.

#### 사용 시점

Java 17은 Spring Boot 3 또는 4를 사용하면서 기존 라이브러리 및 실행 환경과의 호환성을 중요하게 고려하는 프로젝트에 적합하다.

특히 기존 시스템이 Java 17을 기준으로 구축되어 있다면 반드시 Java 21이나 25로 업그레이드할 필요는 없다.

다만 신규 프로젝트에서는 Java 21이나 25를 우선 검토할 수 있다.

### Java 21 (LTS)

Java 21은 Java 17 이후 출시된 LTS 버전으로, 동시성 처리와 언어 표현력 측면에서 중요한 변화가 있었다.

가장 대표적인 기능은 **Virtual Threads**다.

기존 플랫폼 스레드 기반의 동시성 처리 방식에서 발생하던 스레드 생성 및 관리 비용을 줄일 수 있도록 개선되었다.

#### 주요 변경 사항

|기능|설명|
|---|---|
|Virtual Threads|경량 스레드 기반 동시성 처리|
|Pattern Matching for switch|타입 패턴 기반 분기 처리|
|Record Patterns|Record 내부 데이터 구조 분해|
|Sequenced Collections|순서가 있는 컬렉션에 대한 공통 API|
|Generational ZGC|객체 세대 구분을 통한 ZGC 개선|

#### Virtual Threads

기존 Java 애플리케이션에서는 일반적으로 플랫폼 스레드를 이용해 요청을 처리했다.

플랫폼 스레드는 운영체제 스레드와 연결되어 동작하기 때문에 많은 스레드를 생성하면 메모리 사용량과 스케줄링 비용이 증가할 수 있다.

Virtual Thread는 JVM이 관리하는 경량 스레드로, 많은 동시 작업을 상대적으로 적은 플랫폼 스레드로 처리할 수 있도록 설계되었다.

```java
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    executor.submit(() -> {
        System.out.println("Virtual Thread 실행");
    });
}
```

`newVirtualThreadPerTaskExecutor()`는 작업마다 새로운 Virtual Thread를 생성하는 Executor를 제공한다.

Virtual Thread는 특히 외부 API 호출, 네트워크 요청, 데이터베이스 조회 등 **I/O 대기 시간이 많은 작업**에서 유용하다.

반면 CPU 연산이 많은 작업에서는 Virtual Thread를 사용한다고 처리 성능이 무조건 향상되는 것은 아니다.

또한 Virtual Thread를 사용하더라도 DB 커넥션 풀이나 외부 서비스의 처리 용량이 증가하는 것은 아니다.

따라서 기존 플랫폼 스레드를 무조건 대체하기보다는 애플리케이션의 작업 특성에 따라 선택해야 한다.

#### Spring Boot에서 Virtual Thread 사용

Spring Boot 3.2부터 Virtual Thread를 지원한다.

Java 21 이상에서 다음 설정을 사용할 수 있다.

```java
spring:
  threads:
    virtual:
      enabled: true
```

이 설정을 활성화하면 Spring Boot가 자동 구성하는 일부 작업 실행기와 스케줄러 등에 Virtual Thread를 적용한다.

Spring MVC의 내장 웹 서버도 Virtual Thread를 활용하도록 구성할 수 있다.

다만 개발자가 별도로 생성한 모든 Executor가 자동으로 변경되는 것은 아니다.

Virtual Thread를 활성화하면 기존 스레드 풀 관련 설정 중 일부는 적용되지 않을 수 있다.

또한 Virtual Thread는 데몬 스레드이므로 스케줄러 등에 의해 애플리케이션이 실행 상태를 유지해야 하는 경우 다음 설정을 고려할 수 있다.

```java
spring:
  main:
    keep-alive: true
```

Spring Boot 공식 문서에서는 Virtual Thread 사용 시 Java 24 이상을 권장하고 있다. Java 24에서 Virtual Thread의 pinning 문제를 개선했기 때문이다. [Home](https://docs.spring.io/spring-boot/reference/features/spring-application.html?utm_source=chatgpt.com)

#### Pattern Matching for switch

Java 21부터 `switch`에서 타입 패턴을 정식으로 사용할 수 있다.

```java
public String describe(Object value) {
    return switch (value) {
        case Integer number -> "숫자: " + number;
        case String text -> "문자열: " + text;
        case null -> "null";
        default -> "기타 타입";
    };
}
```

기존에는 여러 개의 `instanceof` 조건문으로 처리하던 코드를 `switch`로 표현할 수 있다.

#### 사용 시점

Java 21은 현대적인 Java 기능을 사용하면서도 라이브러리 및 프레임워크 호환성을 중요하게 고려하는 경우 적합하다.

특히 Virtual Thread를 활용하는 Spring Boot 애플리케이션을 개발하려는 경우 Java 21 이상을 고려할 수 있다.

Java 25로 업그레이드할 필요성이 명확하지 않거나 기존 의존성의 호환성 검증이 충분하지 않다면 Java 21도 합리적인 선택이다.

### Java 25 (LTS)

Java 25는 2025년 9월 출시된 LTS 버전으로, Java 21 이후의 언어 기능과 JVM 개선 사항을 포함한다.

Java 25의 주요 특징은 새로운 언어 기능뿐 아니라 기존 Java 애플리케이션의 메모리 효율과 시작 성능을 개선하기 위한 JVM 수준의 변화가 함께 이루어졌다는 점이다.

**Java 25는 출시 당시부터 LTS로 지정된 버전이며, 현재 최신 LTS 버전이다.**

#### 주요 변경 사항

|기능|상태|설명|
|---|---|---|
|Scoped Values|정식|스레드 실행 범위 내에서 데이터 공유|
|Compact Object Headers|정식 기능|객체 헤더 크기 축소|
|Flexible Constructor Bodies|정식|생성자에서 `super()` 이전 코드 실행 허용|
|Module Import Declarations|정식|모듈에 포함된 패키지 일괄 import|
|Compact Source Files|정식|간결한 Java 프로그램 작성|
|AOT 개선|정식|애플리케이션 시작 성능 최적화 지원|
|Structured Concurrency|Preview|관련 동시 작업의 구조적 관리|
|Primitive Types in Patterns|Preview|기본형에 대한 패턴 매칭 확장|

여기서 Preview 기능은 정식 기능과 구분해야 한다.

Preview 기능은 향후 변경되거나 제거될 수 있으며, 일반적으로 사용을 위해 별도 활성화 옵션이 필요하다. [Oracle Documentation](https://docs.oracle.com/en/java/javase/25/migrate/significant-changes-jdk-25.html?utm_source=chatgpt.com)

#### Scoped Values

Scoped Values는 특정 실행 범위 내에서 데이터를 공유할 수 있도록 지원하는 기능이다.

기존 Java에서는 현재 스레드와 관련된 데이터를 여러 메서드에서 접근해야 할 때 `ThreadLocal`을 사용하기도 했다.

하지만 `ThreadLocal`은 명시적으로 값을 제거하지 않으면 스레드에 데이터가 남을 수 있으며, 호출된 메서드에서도 값을 변경할 수 있다.

Scoped Values는 정해진 실행 범위에서 값을 바인딩하고 해당 범위를 벗어나면 바인딩이 자동으로 해제된다.

```java
public class RequestContext {

    private static final ScopedValue<String> REQUEST_ID =
            ScopedValue.newInstance();

    public static void main(String[] args) {
        ScopedValue.where(REQUEST_ID, "request-123")
                .run(RequestContext::process);
    }

    private static void process() {
        System.out.println(REQUEST_ID.get());
    }
}
```

실행 결과:

```java
request-123
```

`ScopedValue.where()`는 지정된 값이 바인딩된 상태로 작업을 실행하도록 구성한다.

`run()`의 실행 범위가 종료되면 해당 바인딩이 해제된다.

Scoped Values는 특히 Virtual Thread와 함께 사용할 때 유용하다.

다만 `ThreadLocal`의 모든 사용 사례를 대체하는 기능은 아니다.

`ThreadLocal`은 값의 변경이 필요한 경우에도 사용할 수 있지만, Scoped Values는 실행 범위 내에서 값을 안전하게 전달하는 목적에 적합하다.

또한 일반적으로 `ScopedValue`에는 불변 객체를 바인딩하는 것이 권장된다. [Oracle Documentation](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/lang/ScopedValue.html?utm_source=chatgpt.com)

#### Compact Object Headers

Java 객체는 실제 데이터 외에도 객체의 상태와 타입 정보 등을 관리하기 위한 헤더를 포함한다.

Java 25에서는 Compact Object Headers 기능이 정식으로 제공되어 객체 헤더 크기를 줄일 수 있게 되었다.

기존 HotSpot JVM의 일반적인 객체 헤더는 구성에 따라 96비트 또는 128비트였지만, Compact Object Headers를 사용하면 64비트로 축소할 수 있다.

이를 통해 객체가 많은 애플리케이션에서 힙 메모리 사용량을 줄일 수 있다.

Java 25에서는 이 기능이 기본적으로 비활성화되어 있으며, 다음 JVM 옵션으로 활성화할 수 있다.

```
java -XX:+UseCompactObjectHeaders -jar app.jar
```

단, 객체 수와 메모리 사용 패턴에 따라 실제 효과가 달라질 수 있으므로 적용 전후의 성능과 메모리 사용량을 측정하는 것이 좋다. [Oracle](https://www.oracle.com/java/technologies/javase/25all-relnotes.html?utm_source=chatgpt.com)

#### Flexible Constructor Bodies

기존 Java에서는 생성자에서 `super()`나 `this()`를 명시적으로 호출하는 경우 반드시 첫 번째 문장에 작성해야 했다.

Java 25부터는 객체가 생성되기 전 단계에서 허용되는 작업을 `super()` 호출보다 먼저 수행할 수 있다.

```java
public class User extends Person {

    public User(String name) {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("이름은 필수입니다.");
        }

        super(name);
    }
}
```

이 기능을 통해 부모 생성자를 호출하기 전에 매개변수 검증 등을 수행할 수 있다.

다만 `super()` 호출 이전에는 생성 중인 객체의 인스턴스 상태에 접근하는 등의 제약이 존재한다.

#### Compact Source Files

Java 25에서는 간단한 Java 프로그램을 작성하기 위한 문법도 개선되었다.

기존에는 Java 프로그램을 실행하기 위해 클래스와 `main` 메서드를 명시적으로 작성해야 했다.

**기존 방식**

```java
public class Main {

    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
```

**Java 25**

```java
void main() {
    IO.println("Hello, Java 25!");
}
```

간단한 프로그램에서는 클래스 선언 없이 실행 코드를 작성할 수 있다.

이 기능은 주로 Java 학습이나 작은 프로그램을 작성할 때 유용하다.

일반적인 Spring Boot 백엔드 애플리케이션에서 기존의 클래스 및 패키지 구조를 대체하기 위한 기능은 아니다.

#### AOT 개선

Java 25에서는 AOT(Ahead-of-Time) 관련 기능도 개선되었다.

일반적인 JVM은 애플리케이션 실행 중 클래스 로딩, 메서드 실행 정보 수집, JIT 컴파일 등의 작업을 수행한다.

AOT 관련 기능은 이전 실행에서 수집한 정보를 활용하여 애플리케이션 시작 과정의 일부 작업을 최적화할 수 있도록 지원한다.

Java 25에서는 다음과 같은 개선이 이루어졌다.

- AOT 캐시를 생성하는 명령어 사용성 개선
- 이전 실행에서 수집한 메서드 프로파일 정보 재사용
- 애플리케이션 시작 성능 최적화 지원

단, AOT 개선이 모든 Java 애플리케이션의 시작 시간을 자동으로 단축한다는 의미는 아니다.

또한 일반적인 JVM의 AOT 캐시 기능과 GraalVM Native Image는 서로 다른 기술이므로 구분해야 한다.

#### Structured Concurrency (Preview)

Structured Concurrency는 여러 동시 작업을 하나의 논리적인 작업 단위로 관리하기 위한 기능이다.

예를 들어 사용자 상세 정보를 조회하는 과정에서 다음 작업이 필요하다고 가정한다.

- 사용자 기본 정보 조회
- 사용자 주문 내역 조회
- 사용자 포인트 조회

기존에는 각각의 비동기 작업을 실행하고 완료 여부와 예외를 개별적으로 관리해야 했다.

Structured Concurrency는 관련 작업의 실행, 완료 대기, 실패 및 취소 처리를 하나의 구조 안에서 관리할 수 있도록 지원한다.

특히 Virtual Thread와 함께 사용하면 여러 I/O 작업을 병렬로 실행하는 코드를 구조화하는 데 유용하다.

다만 **Java 25에서는 아직 Preview 기능**이므로 일반적인 운영 코드에 도입하기 전에 API 안정성과 지원 상태를 확인해야 한다.

#### 사용 시점

Java 25는 새로운 Spring Boot 프로젝트에서 우선 검토할 만한 LTS 버전이다.

특히 다음과 같은 경우 적합하다.

- 신규 Spring Boot 4 프로젝트를 개발하는 경우
- 최신 Java 언어 기능을 사용하려는 경우
- Virtual Thread와 JVM 개선 기능을 활용하려는 경우
- 장기적인 운영을 고려하여 최신 LTS를 선택하려는 경우

다만 기존 애플리케이션이 Java 17이나 Java 21에서 안정적으로 동작하고 있다면 Java 25로 즉시 업그레이드할 필요는 없다.

### Spring Boot와 Java 버전 호환성

Spring Boot 버전을 선택할 때는 해당 버전에서 요구하는 최소 Java 버전과 공식 호환 범위를 함께 확인해야 한다.

특히 **Spring Boot 버전과 Java 버전은 반드시 동일한 시기에 출시된 버전을 사용할 필요가 없다.**

Spring Boot 4에서도 Java 17을 사용할 수 있으며, Java 25를 사용한다고 반드시 Spring Boot 4로 업그레이드해야 하는 것도 아니다.

#### 주요 호환성

2026년 10월 기준 공식 문서에서 확인되는 대표 버전은 다음과 같다.

|Spring Boot|최소 Java|공식 호환 상한|비고|
|---|---|---|---|
|2.7.18|8|21|기존 레거시 프로젝트|
|3.5.16|17|25|Spring Framework 6|
|4.0.8|17|26|Spring Framework 7|
|4.1.1|17|26|Spring Framework 7|

공식 호환 범위는 Spring Boot의 세부 버전과 유지보수 릴리스에 따라 변경될 수 있다.

현재 Java 27이 출시되었더라도 위 Spring Boot 4 공식 요구사항에는 Java 26까지만 명시되어 있으므로, Java 27을 운영 환경에 도입하려면 별도의 호환성 확인이 필요하다. [Home](https://docs.spring.io/spring-boot/docs/2.7.x/reference/html/getting-started.html?utm_source=chatgpt.com)

#### Spring Boot 3와 Java 25

Spring Boot 3라고 해서 Java 25를 사용할 수 없는 것은 아니다.

예를 들어 Spring Boot 3.5는 Java 25를 공식 지원한다.

따라서 기존 프로젝트가 Spring Boot 3.5를 사용하고 있다면 Spring Boot 4로 업그레이드하지 않고도 Java 25를 사용할 수 있다.

다만 Spring Boot 3.0 등 초기 버전까지 Java 25의 호환성이 공식적으로 보장되는 것은 아니다.

실제 사용하는 Spring Boot의 세부 버전을 기준으로 확인해야 한다.

#### Spring Boot 4와 Java 25

Spring Boot 4는 Java 17을 최소 버전으로 유지하면서 Java 25에 대한 공식 지원을 제공한다.

따라서 다음 조합을 사용할 수 있다.

|구성|사용 가능 여부|
|---|---|
|Spring Boot 4 + Java 17|가능|
|Spring Boot 4 + Java 21|가능|
|Spring Boot 4 + Java 25|가능|
|Spring Boot 4 + Java 26|가능|
|Spring Boot 4 + Java 11|불가능|

Spring Boot 4.0 출시 당시에도 Java 25에 대한 지원은 주요 특징 중 하나로 소개되었다. [Home](https://spring.io/blog/2025/11/20/spring-boot-4-0-0-available-now/?utm_source=chatgpt.com)

### Java 버전 선택 가이드

Java 버전은 단순히 최신 버전이라는 이유만으로 선택하지 않는다.

프로젝트의 운영 기간, 프레임워크 호환성, 라이브러리 지원 여부, 배포 환경 등을 종합적으로 고려해야 한다.

#### 신규 프로젝트

새로운 Spring Boot 백엔드 애플리케이션을 개발한다면 Java 25 LTS를 우선 검토할 수 있다.

현재 Spring Boot 4는 Java 25를 공식 지원하며, 최신 LTS를 사용하면 향후 장기적인 유지보수 측면에서 유리할 수 있다.

**권장 조합**

```java
Java 25 LTS
    +
Spring Boot 4.x
```

단, 사용하는 라이브러리가 Spring Boot 4와 Java 25를 지원하는지 확인해야 한다.

특히 JPA 관련 라이브러리, QueryDSL, Spring Security, 테스트 프레임워크, 빌드 도구 등의 호환성을 확인하는 것이 좋다.

#### 기존 Spring Boot 3 프로젝트

기존 Spring Boot 3 프로젝트에서는 Java 17이나 Java 21을 유지하는 것도 합리적인 선택이다.

Java 25의 기능이 필요하고 사용 중인 Spring Boot 및 라이브러리가 이를 지원한다면 Java만 업그레이드하는 방법도 고려할 수 있다.

이 경우 Spring Boot 4로의 마이그레이션과 Java 버전 업그레이드를 반드시 동시에 진행할 필요는 없다.

#### 레거시 프로젝트

기존 Java 8 또는 11 기반 프로젝트에서는 현재 사용 중인 프레임워크와 라이브러리의 호환성이 우선이다.

특히 Spring Boot 2에서 3 이상으로 업그레이드하는 경우 Java 버전뿐 아니라 `javax.*`에서 `jakarta.*`로의 전환 등 여러 변경 사항을 함께 고려해야 한다.

따라서 단순한 JDK 교체만으로 업그레이드가 완료되는 것은 아니다.

#### 선택 기준 정리

|상황|추천 Java 버전|
|---|---|
|신규 Spring Boot 4 프로젝트|**25 LTS**|
|라이브러리 호환성이 중요한 신규 프로젝트|21 LTS|
|기존 Spring Boot 3 프로젝트|17 또는 21 LTS|
|Spring Boot 3.5 기반에서 최신 LTS 도입|25 LTS|
|오래된 레거시 시스템 유지보수|기존 8 또는 11|
|최신 Java 기능 검증|27|
|장기간 운영할 신규 서비스|21 또는 25 LTS|

현재 시점에서는 Java 17을 최소 기준으로 이해하고, Java 21의 Virtual Thread와 Java 25의 주요 변경 사항을 학습하는 것이 좋다.

### Java 버전 업그레이드 시 주의 사항

Java 버전을 업그레이드할 때는 언어 기능뿐 아니라 JVM과 빌드 환경의 호환성도 함께 확인해야 한다.

#### 컴파일 버전과 실행 버전

Java는 소스 코드를 컴파일하여 바이트코드로 변환하고 JVM에서 실행한다.

따라서 소스 코드를 컴파일할 때 사용한 Java 버전과 실행하는 JVM 버전의 호환성을 고려해야 한다.

예를 들어 Java 25를 대상으로 컴파일한 바이트코드는 일반적으로 Java 17 JVM에서 실행할 수 없다.

이 경우 `UnsupportedClassVersionError`가 발생할 수 있다.

반면 Java 17을 대상으로 컴파일한 애플리케이션은 호환성이 유지되는 Java 25 JVM에서 실행할 수 있다.

단, 사용하는 라이브러리와 런타임 동작까지 완전히 호환된다는 의미는 아니다.

#### Gradle Toolchain

Gradle에서는 Java Toolchain을 사용하여 프로젝트의 JDK 버전을 지정할 수 있다.

**Java 25**

```java
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}
```

**Java 21**

```java
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}
```

Toolchain은 컴파일 및 테스트 등에 사용할 JDK를 선택할 수 있도록 지원한다.

다만 **프로젝트의 Toolchain 버전과 Gradle 자체를 실행하는 JVM 버전은 구분해야 한다.**

또한 Gradle 버전별로 지원하는 Java 버전이 다르다.

공식 호환성 문서 기준 Java 25는 Gradle 9.1.0 이상에서 정식 지원된다.

따라서 Spring Boot 4와 Java 25를 사용하는 경우 Gradle 9.1 이상을 선택하는 것이 좋다. [Gradle Documentation](https://docs.gradle.org/current/userguide/compatibility.html?utm_source=chatgpt.com)

#### 실행 버전보다 낮은 Java 버전으로 컴파일

Java 25 JDK를 사용하면서 Java 17을 대상으로 컴파일해야 하는 경우 `--release` 옵션을 사용할 수 있다.

```java
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}

tasks.withType(JavaCompile).configureEach {
    options.release = 17
}
```

이 설정은 Java 25 컴파일러를 사용하되 Java 17의 언어 기능과 표준 API를 기준으로 컴파일하도록 한다.

따라서 Java 25에서 추가된 기능은 사용할 수 없다.

단, 외부 라이브러리까지 Java 17과 호환되도록 자동으로 제한하는 것은 아니다.

### 핵심 정리

Java는 약 6개월 주기로 새로운 버전을 출시하며, 장기적인 운영을 위한 LTS 버전도 제공한다.

2026년 10월 기준 최신 LTS는 Java 25다.

주요 LTS 버전의 특징은 다음과 같다.

- **Java 8:** Lambda, Stream API, Optional 등 현대적인 Java 개발의 기본 기능 도입
- **Java 11:** 표준 HttpClient와 편의 API 확장
- **Java 17:** Record, Pattern Matching, Sealed Classes 등 언어 기능 개선
- **Java 21:** Virtual Thread를 통한 동시성 처리 개선
- **Java 25:** Scoped Values, JVM 메모리 및 시작 성능 개선, 언어 기능 확장

Spring Boot 3와 4는 Java 17 이상을 요구한다.

특히 Spring Boot 4는 Java 25를 공식 지원하므로 새로운 프로젝트에서는 Java 25 LTS를 우선 검토할 수 있다.

다만 Java 버전 선택에서 가장 중요한 것은 최신 버전 사용 자체가 아니라 **프로젝트에서 사용하는 프레임워크, 라이브러리, 빌드 도구 및 실행 환경의 호환성을 확보하는 것**이다.

---

## 📚 참고 및 링크

- [Oracle Java SE Support Roadmap](https://www.oracle.com/java/technologies/java-se-support-roadmap.html)
- [Java 17 언어 변경 사항](https://docs.oracle.com/en/java/javase/17/language/java-language-changes-release.html?utm_source=chatgpt.com)
- [Java 21 주요 변경 사항](https://docs.oracle.com/en/java/javase/21/migrate/significant-changes-jdk-release.html?utm_source=chatgpt.com)
- [Java 25 주요 변경 사항](https://docs.oracle.com/en/java/javase/25/migrate/significant-changes-jdk-25.html?utm_source=chatgpt.com)
- [Java 25 언어 변경 사항](https://docs.oracle.com/en/java/javase/25/language/java-language-changes-summary.html?utm_source=chatgpt.com)
- [Spring Boot 시스템 요구사항](https://docs.spring.io/spring-boot/system-requirements.html?utm_source=chatgpt.com)
- [Spring Boot Virtual Threads](https://docs.spring.io/spring-boot/reference/features/spring-application.html#features.spring-application.virtual-threads)
- [Gradle Java 호환성](https://docs.gradle.org/current/userguide/compatibility.html?utm_source=chatgpt.com)
- [Eclipse Temurin 지원 정책](https://adoptium.net/support/)

---

## 🔗 관련 노트

- [[../02 MOCs/Java|Java]]
