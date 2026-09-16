---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---

# Spring

---

## 📄 본문
### Spring
Spring은 자바의 오픈소스 어플리케이션 프레임워크이다. 객체를 관리할 수 있는 컨테이너를 제공하며, 의존성 주입과 제어의 역전을 통해 결합도를 낮추게 되는 특징을 가지고 있다.

#### point
##### IoC 제어의 역전
제어의 역전은 프레임워크의 대표적인 특징이다. IoC는 애플리케이션의 제어권이 개발자가 아닌 프레임워크에 있는것이고, 프레임워크가 필요한 시점에 개발자의 코드를 호출하여 실행하는 것을 의미한다.

##### Spring 객체간 결합도
Spring은 의존성 주입 DI를 통해 객체 생성과 의존성 연결을 컨테이너가 관리한다. 그 덕분에 클래스가 구체 구현체가 아닌 인터페이스에 의존하도록 만들 수 있다.
따라서, 구현체의 변경 시에 클라이언트 코드를 수정하지 않고 교체할 수 있어서 객체 간 결합도를 낮출 수 있다.

##### DI 의존성 주입
DI는 의존성 주입을 의미한다. 객체간 의존 관계를 미리 설정해두면 스프링 컨테이너가 의존관계를 자동으로 연결해준다. 덕분에 객체가 직접 의존관계를 생성해 가져올 필요가 없기 때문에 결합도를 낮출 수 있다.

###### @Autowired
Autowired는 의존관계를 자동으로 주입해준다. 스프링컨테이너가 자동으로 해당 스프링 빈을 찾아서 주입할 수 있도록 한다.

###### DI 방법
**생성자 주입 방식**
생성자 호출 시점에 딱 1번만 호출되는 것을 보장하는 방식이다. 불변이나, 필수적인 의존관계에서 사용된다.
생성자가 딱 1개만 있으면 @Autowired를 생략해도 자동 주입이 된다.
```java
public OrderServiceImpl(MemberRepository memberRepository, DiscountPolicy discountPolicy) {
	this.memberRepository = memberRepository;
	this.discountPolicy = discountPolicy;
}
```

**Setter 주입 방식**
필드의 값을 변경하는 setter 메서드를 통해서 의존관계를 주입한다. 선택, 변경 가능성이 있는 의존관계에서 사용된다.
```java
@Autowired
public void setMemberRepository(MemberRepository memberRepository) {
	this.memberRepository = memberRepository;
}

@Autowired
public void setDiscountPolicy(DiscountPolicy discountPolicy) {
	this.discountPolicy = discountPolicy;
}
```

**필드 주입 방식**
필드를 통한 주입 방식이다. 필드에 @Autowried를 달아주며 주입을 한다.
이 방식으로 진행하면, 외부에서 변경이 불가능하기 때문에 테스트를 수행하기 어렵다.
```java
@Autowired
private MemberRepository memberRepository;
@Autowired
private DiscountPolicy discountPolicy;
```

**일반 메서드 주입 방식**
일반 메서드를 통해 주입 받는 방식이다. 한번에 여러 필드를 주입 받을 수 있지만, 메서드 호출 시점에 주입된다는 점에서 객체 생성 시점에 의존성이 확실히 보장되지 않고, 불변성이 보장되지 않기에 잘 사용하지 않는 방식이다.
```java
@Autowired
public void init(MemberRepository memberRepository, DiscountPolicy
discountPolicy) {
this.memberRepository = memberRepository;
this.discountPolicy = discountPolicy;
```

###### DI 의존성 권장 방식
Spring 권장하는 방식인 생성자 주입 방식을 사용하자. 대부분의 의존관계는 주입이 일어나면 종료시점까지 의존관계를 변경할 일이 없다. 오히려 변하지 않게 하는 불변성을 띄어야한다.
생성자 주입 방식은 생성할 때 딱 1번만 호출되므로 불변하게 설계할 수 있지만, 나머지 주입 방식은 모두 생성자 이후에 호출되어 필드에 final 키워드를 사용할 수 없다.
즉, 생성자 주입 방식은 혹시라도 **값이 설정되지 않았을 때 컴파일 시점에 막아주는 장점**이 있다.
- 객체 생성 시점에 의존성이 모두 보장된다.
- 순환 참조를 빨리 발견할 수 있다.
- 테스트에서 Mock 객체를 직접 주입하기 쉽다.

### Spring 싱글톤 컨테이너
스프링 컨테이너는 싱글톤 패턴을 적용하지 않아도, 객체 인스턴스를 싱글톤으로 관리한다. 싱글톤 객체를 생성하고 관리하는 기능을 싱글톤 레지스트리라고 하는데, 스프링 컨테이너는 해당 기능 덕분에 싱글톤의 지저분한 코드가 들어가야하는 등의 단점을 해결하면서 객체를 싱글톤으로 유지할 수 있다.
DIP, OCP, 테스트, private 생성자로부터 자유롭게 싱글톤을 사용할 수 있다.
스프링 컨테이너 덕분에 고객의 요청이 올 때 마다 객체를 생성하는 것이 아니라, 이미 만들어진 객체를 공유해서 효율적으로 재사용할 수 있다.

#### point
##### 싱글톤 패턴
초당 100개의 트래픽이 들어올 경우 초당 100개의 객체가 생성되고 소멸되어야 하기 때문에 메모리 낭비가 심할 것이다. 해당 객체를 딱 1개만 생성하고 고유하도록 설계하는 방식으로 해결할 수 있는데, 이것을 싱글톤 패넡이라고 한다.
즉, 클래스의 인스턴스가 딱 1개만 생성되는것을 보장하는 디자인 패턴이다.

### @Bean
@Bean이 붙은 메서드마다 이미 스프링 빈이 존재하면 존재하는 빈을 반환하고, 스프링 빈이 없으면 생성하여 스프링 빈으로 등록하고 반환하는 코드가 동적으로 만들어진다. 덕분에 싱글톤을 보장할 수 있으면 사용시 꼭 @Configuration과 함께 사용되어야한다.

#### point
##### 스프링 Bean 등록 방법
@Bean과 @Configuration을 함께 사용하여 등록하는 방법이 있다. 그리고 @Conponent를 사용하는 방법이 있다.
@Component를 선언한 클래스는 컴포넌트 스캔 대상이 된다. 따라서 스프링 빈으로 등록 되고 빈 이름 같은 경우에는 클래스명을 사용하되 맨 앞글자만 소문자를 사용한다. 직접 지정할 경우 @Component 뒤에 관호안에 이름을 부여해야한다.

##### @Bean 단독 사용 X
@Bean만 사용해도 스프링 빈으로 등록되지만, 싱글톤을 보장하지 않는다. @Configuration을 붙이면 바이트코드를 조작하는 CGLIB 기술을 통해 싱글톤을 보장한다. 따라서 크게 고민할 것 없이 @Bean 사용시 @Configuration을 사용하면 된다.

##### Bean 중복
###### 이름 매칭
@Autowired는 타입 매칭 결과가 2개 이상일 때 필드명이나 파라미터 명을 빈 이름을 매칭한다. 따라서, 이름을 달리하여 관리할 수 있다.
```java
@Autowired
private DiscountPolicy rateDiscountPolicy
```

###### @Qualifier
@Qualifier를 사용하면 추가 구분자를 붙여준다. @Qualifier는 @Qualifier끼리 빈 이름을 매칭하여 찾는 방식이다.
```java
@Component
@Qualifier("mainDiscountPolicy")
public class RateDiscountPolicy implements DiscountPolicy {}

// ---

@Component
@Qualifier("fixDiscountPolicy")
public class FixDiscountPolicy implements DiscountPolicy {}
```
생성자 자동 주입을 이용한 다면 매개변수 앞에 적어야한다.
```java
@Autowired
public OrderServiceImpl(MemberRepository memberRepository,
@Qualifier("mainDiscountPolicy") DiscountPolicy discountPolicy) {
	this.memberRepository = memberRepository;
	this.discountPolicy = discountPolicy;
}
```

###### @Primary
우선 순위를 정하는 방법이다. @Autowried시 여러 빈이 매칭되면 @Primary가 우선권을 가진다. 우선권을 가지는 빈 말고 다른 빈을 주입하고 싶다면 생성자에 Qualifier를 진행해야지 우선권을 다시 가져올 수 있다.
```java
@Component
@Primary
public class RateDiscountPolicy implements DiscountPolicy {}

// ---

@Component
public class FixDiscountPolicy implements DiscountPolicy {}
```

##### 컴포넌트 스캔
스프링이 스프링 빈으로 등록될 준비 된 클래스들을 스캔해 빈으로 등록해주는 과정이다.
컴포넌트 스캔 대상은 다음과 같다.
- @Component
- @Controller
- @Service
- @Repository
- @Configuration

##### 스프링 Bean의 생명주기
**스프링 컨테이너 생성**
-> **의존관계 주입**
-> **초기화 콜백** (빈이 생성되고, 빈의 의존관계 주입이 완료된 후 호출)
-> **사용** (할 일을 완료 후 스프링을 종료해야될 때)
-> **소멸전 콜백** (빈이 소멸되기 직전에 호출되며, 자원 정리를 하기 위한)
-> **스프링 종료**

###### 초기화 콜백, 소멸전 콜백
인터페이스, 설정 정보에 초기화 종료 메서드를 지정하는 방법이 있으며, @PostConstruct, @PreDestroy를 사용하는 방법이 있다.
```java
@PostConstruct 
public void init() {
	System.out.println("NetworkClient.init");
	connect();
	call("초기화 연결 메시지");
}
@PreDestroy
public void close() {
	System.out.println("NetworkClient.close");
	disConnect();
}
```

##### 스프링 Bean 스코프
스프링 빈 스코프는 빈이 존재할 수 있는 범위를 뜻한다. 싱글톤, 프로토타입 그리고 웹 관련 스코프가 존재한다.

**싱글톤**은 기본 스코프이다. 스프링 컨테이너의 시작과 종료까지 유지되는 가장 넓은 범위의 스코프이다.

**프로토타입**은 스프링 컨테이너가 프로토타입 빈의 생성과 의존관계 주입까지만 관여하고 더는 관리하지 않는 매우 짧은 범위의 스코프이다.

웹 관련된 스코프는 다음과 같다.
- request: 하나의 http 요청이 들어오고 응답이 나갈 때까지 유지되는 스코프
- session: 하나의 http 세션이 생성되고 종료될 때까지 유지되는 스코프
- application: 웹 어플리케이션의 sevletContext와 동일한 범위로 유지되는 스코프

### Spring Framework vs Spring Boot
스프링 프레임워크는 자바 기반에 오픈소스 어플리케이션 프레임워크이다. 스프링 부트는 그 스프링 프레임워크를 더 쉽고 빠르게 사용할 수 있도록 도와주는 도구이다.
스프링 부트를 사용하면 yaml이나 properties를 통해 자동 설정인 오토 컨피규레이션이 가능하다. 예를 들어, 데이터 소스 url을 적으면 DataSource Bean을 자동으로 생성해준다.
그리고 일일히 라이브러리를 관리할 필요가 없이, spring-starter 같은 의존성을 통해 손쉽게 필요한 라이브러리를 관리할 수 있다.
또한, 내장 톰켓을 지원하면서 jar 파일을 통해 손쉽게 WAS를 실행할 수 있게되면서 모든 환경에 일관된 톰켓 환경을 제공하다는 차이를 가지고 있다.

---

## 📚 참고 및 링크
- [[ ]]

---

## 🔗 관련 노트
- [[../02 MOCs/Spring|Spring]]
