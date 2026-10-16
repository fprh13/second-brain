---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---
# Spring Boot 4

---

## 📄 본문

### Spring Boot 4

Spring Boot 4와 Spring Framework 7은 2025년 11월에 정식 출시되었다.

이번 메이저 버전에서는 스타터 모듈 구조가 세분화되었으며, REST API 버전 관리 기능이 프레임워크에 내장되었다. 또한 Jackson 3이 기본 JSON 라이브러리로 채택되었고, 재시도 및 동시성 제한 기능이 Spring Framework에 추가되었다.

기존 Spring Framework의 Null 관련 어노테이션도 JSpecify 표준으로 전환되었다.

#### 주요 변경 사항

|항목|Spring Boot 3|Spring Boot 4|
|---|---|---|
|Spring Framework|6.x|7.x|
|Java 최소 버전|17|17|
|Spring Security|6.x|7.x|
|Jackson|2.x|3.x|
|내장 Tomcat|10.1.x|11.x|
|Jakarta Servlet|6.0|6.1|
|REST API 버전 관리|직접 구현 또는 별도 라이브러리|프레임워크 내장|
|재시도 기능|주로 Spring Retry 활용|Spring Framework 자체 지원|
|Null 안정성|Spring 자체 어노테이션|JSpecify 표준|

Spring Boot 4에서도 Java 17을 사용할 수 있으므로 Java 21이나 Java 25로 반드시 업그레이드해야 하는 것은 아니다.

### 의존성 및 모듈 구조 변경

Spring Boot 4는 기존 자동 구성 모듈을 기능별로 세분화하였다.

기존에는 여러 기능이 하나의 스타터에 포함되거나 관련 자동 구성이 함께 제공되었지만, Spring Boot 4에서는 필요한 기능을 보다 명확하게 선택할 수 있도록 모듈 구조가 변경되었다.

#### Starter 의존성 변경

대표적으로 기존 `spring-boot-starter-web` 대신 `spring-boot-starter-webmvc` 사용을 권장한다.

**Spring Boot 3**

```
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
}
```

**Spring Boot 4**

```
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-webmvc'
}
```

Spring Boot 4에서도 기존 `spring-boot-starter-web`은 호환성을 위해 제공되지만, 새로운 프로젝트에서는 `spring-boot-starter-webmvc`를 사용하는 것이 권장된다.

그 밖에도 기능별 스타터가 제공된다.

```
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-webmvc'
    implementation 'org.springframework.boot:spring-boot-starter-restclient'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'

    testImplementation 'org.springframework.boot:spring-boot-starter-webmvc-test'
}
```

- `webmvc`: Spring MVC 기반 웹 애플리케이션
- `restclient`: RestClient 기반 HTTP 클라이언트
- `validation`: Jakarta Bean Validation
- `data-jpa`: Spring Data JPA
- `webmvc-test`: Spring MVC 관련 테스트 지원

기능별 스타터를 사용하는 경우에도 각 스타터에 포함된 전이 의존성을 확인해야 한다. 모든 기능을 개별 스타터로 중복 선언할 필요는 없다.

### REST API 버전 관리

기존에는 REST API 버전을 관리하기 위해 URL에 `/v1`, `/v2`를 직접 구분하거나 별도의 버전 처리 로직을 구현하는 방식이 일반적이었다.

Spring Framework 7부터는 `@RequestMapping` 계열 어노테이션에 `version` 속성이 추가되었다.

이를 통해 동일한 URL에서도 요청한 API 버전에 따라 서로 다른 컨트롤러 메서드를 실행할 수 있다.

```java
@RestController
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;

    // V1: 기본 계좌 정보
    @GetMapping(value = "/accounts/{id}", version = "1")
    public AccountV1 getAccountV1(@PathVariable Long id) {
        return accountService.findBasicById(id);
    }

    // V1.1: 거래 내역을 포함한 상세 정보
    @GetMapping(value = "/accounts/{id}", version = "1.1")
    public AccountV2 getAccountV1_1(@PathVariable Long id) {
        return accountService.findDetailedById(id);
    }
}
```

기존 V1 API를 유지하면서 개선된 V1.1 API를 추가할 수 있으므로, 기존 클라이언트와의 호환성을 유지하는 데 활용할 수 있다.

다만 모든 기능 개선에 새로운 버전을 추가할 필요는 없다. 기존 클라이언트와의 호환성이 깨지는 변경인지 판단하여 버전 분리 여부를 결정해야 한다.

#### 버전 전략 설정

Spring Framework 7은 다음 네 가지 버전 추출 방식을 제공한다.

- HTTP 요청 헤더
- 쿼리 파라미터
- URL 경로 세그먼트
- 미디어 타입 파라미터

Spring Boot 4에서는 `application.yml`을 통해 버전 추출 방식을 설정할 수 있다.

```yaml
spring:
  mvc:
    apiversion:
      use:
        header: API-Version
      supported:
        - "1"
        - "1.1"
        - "2"
```

이 설정은 클라이언트가 전송한 `API-Version` 헤더를 확인하여 API 버전을 판별한다.

**V1 요청**

```
GET /accounts/1
API-Version: 1
```

**V1.1 요청**

```
GET /accounts/1
API-Version: 1.1
```

두 요청은 URL이 동일하지만 서로 다른 컨트롤러 메서드로 매핑된다.

`supported`는 애플리케이션에서 지원하는 API 버전을 명시하는 설정이다. 지원 버전으로 등록한다고 해당 버전의 컨트롤러가 자동 생성되는 것은 아니다.

또한 Spring Boot는 기본적으로 컨트롤러에 선언된 버전을 감지할 수 있으므로, 단순한 구성에서는 `supported` 설정을 생략할 수 있다.

**쿼리 파라미터 방식**

```yaml
spring:
  mvc:
    apiversion:
      use:
        query-parameter: version
```

```
GET /accounts/1?version=1
GET /accounts/1?version=1.1
```

여러 버전 추출 전략을 조합하거나 별도의 처리 로직이 필요하다면 `WebMvcConfigurer`의 `configureApiVersioning()`을 사용할 수 있다.

### RestClient 버전 관리

Spring Framework 7에서는 RestClient와 WebClient도 API 버전 관리 기능을 지원한다.

RestClient는 외부 API를 호출하는 HTTP 클라이언트이므로, 서버가 요구하는 API 버전을 요청에 포함하는 역할을 한다.

#### 버전 삽입 전략 설정

`ApiVersionInserter`를 사용하여 API 버전을 어떤 방식으로 전달할지 설정할 수 있다.

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.ApiVersionInserter;
import org.springframework.web.client.RestClient;

@Configuration
public class RestClientConfig {

    @Bean
    public RestClient accountRestClient(RestClient.Builder builder) {
        return builder
                .baseUrl("https://api.example.com")
                .apiVersionInserter(
                        ApiVersionInserter.useHeader("API-Version")
                )
                .build();
    }
}
```

`ApiVersionInserter.useHeader("API-Version")`는 API 버전을 HTTP 요청 헤더에 삽입하도록 설정한다.

Spring Boot가 자동 구성한 `RestClient.Builder`를 주입받아 사용하면 기존 HTTP 클라이언트 설정을 활용할 수 있다.

#### API 버전 지정

```
Account account = restClient.get()
        .uri("/accounts/{id}", 1L)
        .apiVersion("1.1")
        .retrieve()
        .body(Account.class);
```

실제 요청은 다음과 같다.

```
GET /accounts/1
API-Version: 1.1
```

`apiVersion("1.1")`은 요청에 사용할 API 버전을 지정하고, `ApiVersionInserter`는 해당 버전을 실제 HTTP 요청에 삽입한다.

따라서 서버 측 Spring MVC의 버전 관리 설정과 RestClient의 버전 삽입 설정은 별도로 구성해야 한다.

### Jackson 3 전환

Spring Boot 4는 Jackson 3을 기본 JSON 라이브러리로 채택하였다.

Jackson은 Java 객체를 JSON으로 변환하는 직렬화와 JSON을 Java 객체로 변환하는 역직렬화를 담당한다.

Spring MVC에서는 `HttpMessageConverter`를 통해 Jackson을 사용하므로 일반적인 REST API 개발에서는 별도로 Jackson을 호출하지 않아도 된다.

```java
@PostMapping("/users")
public ResponseEntity<UserResponse> register(
        @Valid @RequestBody UserRequest request
) {
    return ResponseEntity.ok(userService.register(request));
}
```

- `@RequestBody`: JSON을 Java 객체로 역직렬화
- `ResponseEntity<UserResponse>`: Java 객체를 JSON으로 직렬화

#### 주요 변경 사항

Jackson 3에서는 주요 패키지명이 `com.fasterxml.jackson`에서 `tools.jackson`으로 변경되었다.

**Jackson 2**

```java
import com.fasterxml.jackson.databind.ObjectMapper;

ObjectMapper mapper = new ObjectMapper();
```

**Jackson 3**

```java
import tools.jackson.databind.json.JsonMapper;

JsonMapper mapper = JsonMapper.builder().build();
```

Spring Boot 4에서는 Jackson 3의 `JsonMapper`를 기본 JSON 매퍼로 사용한다.

`JsonMapper`는 생성 이후 설정을 변경할 수 없는 불변 객체로 설계되었으며, 빌더 패턴으로 설정을 구성한다. 구성된 인스턴스는 여러 스레드에서 안전하게 공유할 수 있다.

다만 일반적인 Spring Boot 애플리케이션에서는 `JsonMapper`를 직접 생성할 필요가 없다. Spring Boot가 Bean으로 자동 구성하기 때문이다.

참고로 Jackson의 모든 패키지가 변경된 것은 아니다.

```java
import com.fasterxml.jackson.annotation.JsonProperty;
```

`@JsonProperty`를 비롯한 Jackson 어노테이션은 기존 패키지를 유지한다.

#### Jackson 설정 프로퍼티

Jackson의 직렬화 및 역직렬화 규칙은 `application.yml`에서 설정할 수 있다.

```yaml
spring:
  jackson:
    deserialization:
      fail-on-unknown-properties: false
    datatype:
      datetime:
        write-dates-as-timestamps: false
```

**`fail-on-unknown-properties`**

JSON에 DTO에 존재하지 않는 필드가 포함된 경우 오류를 발생시킬지 결정한다.

```java
public record UserRequest(
        String name,
        Integer age
) {}
```

```json
{
  "name": "홍길동",
  "age": 25,
  "address": "서울"
}
```

- `true`: DTO에 존재하지 않는 `address`로 인해 역직렬화 오류 발생
- `false`: `address`를 무시하고 역직렬화 진행

**`write-dates-as-timestamps`**

날짜 및 시간 타입을 JSON으로 직렬화할 때 타임스탬프 형태를 사용할지 결정한다.

`false`인 경우:

```json
{
  "createdAt": "2026-10-15T21:00:00"
}
```

`true`인 경우 `LocalDateTime`은 다음과 같이 배열 형태로 직렬화될 수 있다.

```json
{
  "createdAt": [2026, 10, 15, 21, 0, 0]
}
```

`LocalDateTime`은 타임존 정보가 없는 타입이므로 타임스탬프 설정에 따라 반드시 Unix 타임스탬프 숫자로 변환되는 것은 아니다.

특별한 JSON 변환 요구사항이 없다면 Spring Boot의 기본 설정을 그대로 사용해도 된다.

#### Jackson 어노테이션 변경

Spring Boot 4에서는 커스텀 직렬화 및 역직렬화 구현을 등록하는 어노테이션이 변경되었다.

**Spring Boot 3**

```java
@JsonComponent
public class CustomSerializer extends JsonObjectSerializer<MyEntity> {
    // ...
}
```

**Spring Boot 4**

```java
import org.springframework.boot.jackson.JacksonComponent;
import org.springframework.boot.jackson.ObjectValueSerializer;
import tools.jackson.core.JsonGenerator;
import tools.jackson.databind.SerializationContext;

@JacksonComponent
public class CustomSerializer extends ObjectValueSerializer<MyEntity> {

    @Override
    protected void serializeObject(
            MyEntity value,
            JsonGenerator generator,
            SerializationContext context
    ) {
        generator.writeStringProperty("name", value.getName());
    }
}
```

`@JacksonComponent`는 개발자가 구현한 커스텀 Serializer 또는 Deserializer를 Jackson에 자동으로 등록하는 역할을 한다.

기본 JSON 변환 규칙으로 처리하기 어려운 요구사항이 있을 때 사용한다.

일반적인 DTO 직렬화와 역직렬화에서는 별도로 구현할 필요가 없다.

### @Retryable 내장 지원

Spring Framework 7부터 재시도 기능이 프레임워크에 직접 포함되었다.

기존에는 주로 Spring Retry 라이브러리의 `@Retryable`을 사용했지만, Spring Framework 7에서는 별도의 Spring Retry 의존성 없이 재시도 기능을 사용할 수 있다.

단, 기존 Spring Retry의 `@Retryable`과 Spring Framework 7의 `@Retryable`은 서로 다른 API이므로 속성과 동작을 구분해야 한다.

#### 재시도 기능 활성화

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.resilience.annotation.EnableResilientMethods;

@Configuration
@EnableResilientMethods
public class ResilienceConfig {
}
```

`@EnableResilientMethods`는 `@Retryable`, `@ConcurrencyLimit` 등의 선언적 기능을 활성화한다.

#### @Retryable 사용

```java
import org.springframework.resilience.annotation.Retryable;
import org.springframework.stereotype.Service;

@Service
public class PaymentService {

    @Retryable(
            maxRetries = 3,
            delay = 1000,
            multiplier = 2
    )
    public PaymentResult processPayment(PaymentRequest request) {
        return paymentGateway.charge(request);
    }
}
```

`@Retryable`은 메서드 실행 중 예외가 발생했을 때 설정된 정책에 따라 재시도한다.

- `maxRetries`: 최대 재시도 횟수
- `delay`: 최초 재시도 전 대기 시간
- `multiplier`: 재시도 간 대기 시간 증가 배율

위 설정에서는 최초 실행을 제외하고 최대 3회 재시도하므로 총 실행 횟수는 최대 4회이다.

재시도 대기 시간은 1초, 2초, 4초로 증가한다.

별도의 설정이 없다면 기본적으로 모든 예외에 대해 최대 3회 재시도하며, 재시도 사이에는 1초의 고정 지연을 적용한다.

또한 `includes`, `excludes` 속성으로 재시도할 예외와 제외할 예외를 지정할 수 있다.

**주의 사항**

재시도는 일시적인 네트워크 오류나 외부 서비스 장애 등에 활용할 수 있지만, 모든 작업에 무조건 적용해서는 안 된다.

특히 결제처럼 중복 실행이 문제가 되는 작업에는 멱등성 보장이나 외부 API의 중복 요청 방지 정책을 함께 고려해야 한다.

또한 선언적 재시도는 Spring AOP 기반으로 동작하므로 일반적인 프록시 방식의 제약을 받는다. 같은 객체 내부에서 메서드를 직접 호출하는 경우에는 재시도가 적용되지 않을 수 있다.

### @ConcurrencyLimit

Spring Framework 7에서는 `@ConcurrencyLimit`을 통해 메서드의 동시 실행 수를 제한할 수 있다.

동시에 많은 요청이 유입될 때 외부 API나 데이터베이스와 같은 제한된 리소스에 과도한 요청이 전달되는 것을 방지하는 데 활용할 수 있다.

```java
import org.springframework.resilience.annotation.ConcurrencyLimit;
import org.springframework.stereotype.Service;

@Service
public class ExternalApiService {

    @ConcurrencyLimit(10)
    public ApiResponse request() {
        return externalApiClient.call();
    }
}
```

위 코드는 해당 메서드의 동시 실행 수를 최대 10개로 제한한다.

이미 10개의 호출이 실행 중이라면 추가 호출은 실행 가능한 자리가 생길 때까지 대기한다.

특히 Virtual Thread 환경에서 유용하다.

Virtual Thread는 많은 동시 작업을 효율적으로 처리할 수 있지만, DB 커넥션 풀이나 외부 API가 무제한 요청을 처리할 수 있는 것은 아니기 때문이다.

단, `@ConcurrencyLimit`은 일정 시간 동안의 요청 수를 제한하는 Rate Limiting과는 다르다.

- `@ConcurrencyLimit`: 동시에 실행 중인 작업 수 제한
- Rate Limiting: 일정 시간 동안 허용하는 요청 수 제한

또한 애플리케이션 인스턴스별로 적용되는 제한이므로 여러 서버에 걸친 전역 동시 실행 수를 제한하는 기능은 아니다.

### JSpecify로 null 안정성 표준화

Spring Framework 7은 null 안정성을 표현하기 위해 JSpecify 표준 어노테이션을 사용한다.

기존 Spring의 `@Nullable`은 주로 필드, 메서드 반환값, 매개변수에 null이 허용될 수 있음을 명시했다.

JSpecify에서는 타입 사용 위치를 지원하므로 제네릭 내부 타입과 배열 요소까지 null 허용 여부를 구분할 수 있다.

#### @Nullable

```java
import org.jspecify.annotations.Nullable;

public class UserService {

    // 필드
    private @Nullable String nickname;

    // 메서드 반환값
    public @Nullable String findNickname() {
        return null;
    }

    // 매개변수
    public void updateNickname(@Nullable String nickname) {
        // ...
    }

    // 제네릭 내부 요소
    private List<@Nullable String> nicknames;
}
```

기존과 달리 제네릭 내부 타입에 대한 null 허용 여부도 명시할 수 있다.

```java
// 리스트 자체가 null일 수 있음
@Nullable List<String> names;

// 리스트 내부 요소가 null일 수 있음
List<@Nullable String> names;

// 리스트와 내부 요소 모두 null일 수 있음
@Nullable List<@Nullable String> names;
```

배열의 경우에도 배열 자체와 배열 내부 요소를 구분할 수 있다.

```java
// 배열 자체가 null일 수 있음
String @Nullable [] names;

// 배열 내부 요소가 null일 수 있음
@Nullable String[] names;

// 배열과 내부 요소 모두 null일 수 있음
@Nullable String @Nullable [] names;
```

단, 별도의 Non-Null 기본 규칙이 적용되지 않은 범위에서는 `@Nullable`이 없다는 이유만으로 반드시 null을 금지한다고 해석할 수는 없다.

#### @NullMarked 활용

`@NullMarked`는 특정 범위에서 별도로 null 허용 여부를 선언하지 않은 참조 타입을 기본적으로 Non-Null로 취급하도록 지정하는 어노테이션이다.

**1. @NullMarked가 없는 경우**

```java
public class UserService {

    public String findName() {
        return null;
    }
}
```

위 코드에서는 `String`의 null 허용 여부가 명확하게 선언되지 않았다.

Java의 참조 타입은 null을 가질 수 있으므로 컴파일 자체에는 문제가 없다.

**2. @NullMarked가 있는 경우**

```java
@NullMarked
public class UserService {

    public String findName() {
        return null; // null 계약 위반
    }
}
```

`@NullMarked`를 선언하면 해당 클래스에서 별도로 표시하지 않은 `String`은 null을 허용하지 않는 타입으로 취급된다.

따라서 `return null`은 null 계약 위반에 해당하며, JSpecify를 지원하는 정적 분석 도구가 이를 감지할 수 있다.

단, Java 컴파일러 자체가 자동으로 오류를 발생시키는 것은 아니다.

**3. null을 허용해야 하는 경우**

```java
@NullMarked
public class UserService {

    public String findName() {
        return "홍길동";
    }

    public @Nullable String findNickname() {
        return null;
    }
}
```

|메서드|null 반환|
|---|---|
|`findName()`|허용하지 않음|
|`findNickname()`|허용함|

`@NullMarked`를 사용하면 모든 메서드에 일일이 `@NonNull`을 선언할 필요 없이 null이 허용되는 부분에만 `@Nullable`을 명시할 수 있다.

**4. 패키지 단위 적용**

`@NullMarked`는 클래스뿐 아니라 패키지 단위로도 적용할 수 있다.

`package-info.java`

```java
@NullMarked
package com.carumuch.capstone.user;

import org.jspecify.annotations.NullMarked;
```

해당 패키지에서는 별도로 표시하지 않은 참조 타입을 기본적으로 Non-Null로 취급한다.

단, 하위 패키지에는 자동 적용되지 않으므로 각각 선언해야 한다.

**5. 정적 분석 도구**

JSpecify 어노테이션 자체는 런타임에 null을 검사하거나 예외를 발생시키지 않는다.

IntelliJ IDEA, NullAway, Checker Framework 등 JSpecify를 지원하는 정적 분석 도구에서 null 계약 위반을 검사할 수 있다.

따라서 Jakarta Validation의 `@NotNull`과는 목적이 다르다.

|구분|JSpecify|Jakarta Validation|
|---|---|---|
|주요 어노테이션|`@Nullable`, `@NullMarked`|`@NotNull`, `@NotBlank`|
|목적|Null 허용 여부 명시|데이터 유효성 검증|
|검사 시점|정적 분석 시점|런타임|
|예외 발생|어노테이션 자체는 발생시키지 않음|검증 실행 시 발생 가능|

Spring Framework 6에서도 `@NonNullApi`, `@NonNullFields`를 통해 기본 Non-Null 규칙을 선언할 수 있었다.

Spring Framework 7에서는 이를 JSpecify 표준으로 전환하고, 제네릭 내부 타입까지 null 허용 여부를 표현할 수 있도록 개선한 것이다.

### 테스트 관련 변경 사항

Spring Boot 4에서는 자동 구성 모듈이 세분화되면서 테스트 관련 모듈과 일부 어노테이션의 패키지도 변경되었다.

대표적으로 `@WebMvcTest`의 import 경로가 변경되었다.

**Spring Boot 3**

```java
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
```

**Spring Boot 4**

```java
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
```

Spring MVC 관련 테스트 기능은 `spring-boot-webmvc-test` 모듈에서 제공한다.

```
dependencies {
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'org.springframework.boot:spring-boot-starter-webmvc-test'
}
```

`spring-boot-starter-test`는 JUnit, AssertJ 등 일반적인 테스트 기능을 제공하고, `spring-boot-starter-webmvc-test`는 Spring MVC 관련 테스트 기능을 제공한다.

#### @WebMvcTest

```java
@WebMvcTest(AccountController.class)
class AccountControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private AccountService accountService;
}
```

`@WebMvcTest`는 전체 애플리케이션 컨텍스트를 로드하지 않고 Spring MVC 관련 구성 요소를 중심으로 테스트한다.

컨트롤러의 요청 매핑, HTTP 응답 상태, JSON 응답 등을 검증하는 데 활용한다.

Spring Boot 3에서 작성한 기존 테스트 코드를 Spring Boot 4로 마이그레이션할 때는 테스트 어노테이션의 import와 필요한 테스트 의존성을 함께 확인해야 한다.

`@SpringBootTest`를 사용하는 통합 테스트도 의존성 및 자동 구성 변경에 따른 영향을 확인해야 한다.

### Spring Security 7

Spring Boot 4는 Spring Security 7과 함께 사용된다.

Spring Security 7에서는 기존에 deprecated 처리되었던 일부 API가 제거되고 설정 방식이 정리되었다.

특히 Spring Security 6에서 7로 전환하는 경우 다음 항목을 확인해야 한다.

- `SecurityFilterChain` 설정의 호환성
- 기존 deprecated API 제거 여부
- OAuth2 Client 및 Resource Server 설정
- JWT 인증 관련 구성
- Jackson 3을 사용하는 Security 직렬화 설정

기존의 `SecurityFilterChain` 기반 인증 및 인가 설정 방식은 Spring Security 7에서도 사용할 수 있다.

다만 기존 설정 코드에서 제거된 API를 사용하고 있다면 수정이 필요하다.

Spring Security의 변경 사항은 인증 및 인가 구성에 직접적인 영향을 줄 수 있으므로 별도 학습 노트에서 자세히 정리한다.

### 핵심 정리

Spring Boot 4는 Spring Framework 7을 기반으로 하며, 기존 기능을 유지하면서 프레임워크 구조와 일부 API가 변경된 메이저 버전이다.

주요 변경 사항은 다음과 같다.

- **모듈 구조:** 기능별 Starter 및 자동 구성 모듈 세분화
- **REST API:** `@RequestMapping`의 `version` 속성을 이용한 API 버전 관리 지원
- **HTTP 클라이언트:** RestClient와 WebClient의 API 버전 지정 기능 지원
- **JSON 처리:** Jackson 3을 기본 라이브러리로 채택하고 `JsonMapper` 사용
- **재시도:** Spring Framework 자체 `@Retryable` 지원
- **동시성:** `@ConcurrencyLimit`을 통한 메서드 동시 실행 수 제한
- **Null 안정성:** JSpecify를 통한 null 허용 여부 표준화
- **테스트:** 테스트 모듈 세분화 및 일부 어노테이션 패키지 변경
- **보안:** Spring Security 7 적용

기존 Spring Boot 3 애플리케이션을 Spring Boot 4로 전환할 때는 새로운 기능뿐 아니라 의존성, 패키지 경로, 설정 프로퍼티, 테스트 구성의 호환성을 함께 확인해야 한다.

---

## 📚 참고 및 링크

- [Spring Boot 4.0 공식 문서](https://docs.spring.io/spring-boot/4.0/reference/)
- [Spring Boot 4.0 시스템 요구사항](https://docs.spring.io/spring-boot/4.0/system-requirements.html?utm_source=chatgpt.com)
- [Spring Boot Starter 의존성](https://docs.spring.io/spring-boot/4.0/reference/using/build-systems.html?utm_source=chatgpt.com)
- [Spring Framework 7 API 버전 관리](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-config/api-version.html?utm_source=chatgpt.com)
- [Spring Framework REST Client](https://docs.spring.io/spring-framework/reference/integration/rest-clients.html)
- [Spring Boot Jackson 설정](https://docs.spring.io/spring-boot/4.0/reference/features/json.html?utm_source=chatgpt.com)
- [Spring Framework Resilience 기능](https://docs.spring.io/spring-framework/reference/core/resilience.html)
- [Spring Framework Null Safety](https://docs.spring.io/spring-framework/reference/core/null-safety.html?utm_source=chatgpt.com)
- [Spring Boot 테스트](https://docs.spring.io/spring-boot/4.0/reference/testing/index.html?utm_source=chatgpt.com)
- [Spring Security 7 마이그레이션](https://docs.spring.io/spring-security/reference/migration/?utm_source=chatgpt.com)

---

## 🔗 관련 노트
- [[../02 MOCs/Spring|Spring]]