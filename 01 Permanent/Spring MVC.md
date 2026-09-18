---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---

# Spring MVC

---

## 📄 본문
### WS
HTML, CSS, JS, 이미지, 영상 등 정적 리소스를 제공한다. NGINX, APACHE가 대표적이며 HTTP 기반으로 동작한다.

### WAS
WS 기능을 포함하면서 정적 리소스를 제공한다. 동적 HTML이나 API, 서블릿, JSP, 스프링 MVC 같은 프로그램 코드를 실행해서 어플리케이션 로직을 수행한다. 톰캣이 대표적이며 HTTP 기반으로 동작한다.

#### point
WAS에 WS가 포함되어 있어도 WS를 따로 띄우는 경우가 있다. 장점은 다음과 같다.
**성능 향상**
- 캐싱
- 정적 파일 처리 성능이 더 좋음
	- 정적 파일은 Nginx가 처리하는 게 효율적
        - Nginx → 매우 빠름  
		- Tomcat → 상대적으로 느림
**부하 분산**
- 로드 벨런싱 → 트래픽 분산
**보안**
- WAS 포트를 외부에 직접 노출 안함 → 해킹 위험 감소

##### WS vs WAS
WS는 HTML, CSS, 이미지 같은 정적 리소스를 제공하는 서버이고, WAS는 Java, Spring 같은 애플리케이션 로직을 실행하여 동적인 응답을 생성하는 서버이다. 일반적으로 Web Server는 정적 리소스를 처리하고, WAS는 비즈니스 로직과 데이터 처리를 담당하도록 역할을 분리하여 사용한다.

### 서블릿
서블릿은 비즈니스 로직 실행의 전 후의 HTTP 요청, 응답을 처리한다. HTTP 요청이 들어오면 WAS는 Request, Response 객체를 생성하고 서블릿을 호출한다. 개발자는 해당 객체를 통해 요청 정보를 편리하게 사용하고 응답 정보를 작성할 수 있다.
이후 WAS는 Response 객체에 담긴 내용을 기반으로 HTTP 응답을 생성하여 클라이언트에게 전달한다.

#### point
##### 서블릿 컨테이너
Tomcat처럼 서블릿을 지원하는 WAS를 서블릿 컨테이너라고 한다. 서블릿 컨테이너는 서블릿 객체를 생성, 초기화, 호출, 종료하는 생명주기를 관리한다. 서블릿 객체는 싱글톤으로 관리되며, JSP 또한 서블릿으로 변환되어 사용된다. 동시 요청을 위한 멀티쓰레드 처리도 지원한다.

##### Thread Pool
Thread Pool은 요청이 들어올 때마다 새로운 Thread를 생성하는 대신, 미리 생성해둔 Thread를 재사용하는 방식의 관리 매커니즘이다. Thread를 생성하고 제거하는 과정은 비용이 크기 때문에, 매 요청마다 Thread를 생성하면 성능 저하와 시스템 부담이 발생할 수 있다.
이를 해결하기 위해 Thread Pool을 통해 일정 개수의 Thread를 미리 생성해 두고, 작업이 들어오면 Thread를 할당하여 작업을 수행하고, 작업이 끝나면 다시 Pool로 반환하여 재사용한다.

###### JAVA의 Thread Pool 구성 요소
Java에서는 ThreadPoolExecutor로 구현된다.
- **corePoolSize**
    → 항상 유지되는 최소 Thread 수
- **maximumPoolSize**
    → 최대 생성 가능한 Thread 수
- **queue (작업 큐)**
    → Thread가 모두 사용 중일 때 작업을 대기시키는 공간
- **keepAliveTime**
    → 초과 생성된 Thread를 유지하는 시간

### MVC 패턴
JSP, 서블릿으로 개발을 진행하면 비즈니스 로직이나 화면을 처리하는 부분을 한 곳에서 처리해야만 했다. 한 곳에 너무 많은 역할이 부여 됐기 때문에 Controller, View라는 영역으로 서로의 역할을 나누면서 MVC 패턴이 등장했다.

#### point
##### Controller
HTTP요청을 받아서 파라미터를 검증하고 비즈니스로직을 실행한다. View에 전달할 데이터를 Model에 담는 역할도 수행한다. 물론 Controller에 비즈니스 로직을 위치 시킬 수 있지만, Controller에 너무 많은 역할이 부여되는것을 방지하기 위해 일반적으로는 Service 계층을 별도로 추가하여 처리한다.

##### Model
View에 출력할 데이터를 담아두는 역할을 한다.

##### View
Model에 담겨있는 데이터를 사용해서 화면을 그리는일을 한다. 즉, HTML을 생성하는 부분이다.

### Spring MVC
MVC 패턴 기반으로 웹 어플리케이션을 개발하기 위해 스프링 프레임워크에서 제공하는 웹 프레임워크이다.

#### point
##### 처리 과정
![[../attachments/screenshots/SpringMVC.png]]
HTTP 요청이 들어오면 FrontContller 역할을 하는 DispatcherServlet에 들어오게 된다.
이후 순서는 다음과 같다.
1. 핸들러 조회: 핸들러 매핑을 통해 요청 URL에 매핑된 핸들러를 조회한다.
2. 핸들러 어뎁터 조회: 핸들러를 실행할 수 있는 핸들러 어댑터를 조회한다.
3. 핸들러 어댑터 실행: 핸들러 어탭터를 실행한다.
4. ModelAndView 반환: 핸들러 어댑터는 핸들러가 반환하는 정보를 ModelAndView로 변환해서 반환한다.
5. viewResolver 호출: 뷰 리졸버를 찾고 실행한다.
6. View 반환: 뷰 리졸버는 View의 논리 이름을 물리 이름으로 바꾸고 랜더링 역할을 담당하는 뷰 객체를 반환한다.
7. View 랜더링: 뷰를 통해서 뷰를 랜더링 한다.

##### @Controller
스프링 MVC에서 어노테이션 기반으로 컨트롤러를 인식하기 위해 사용된다. 내부에 @Component가 있어서 컴포넌트 스캔의 대상이 되기 때문에 스프링이 자동으로 스프링 빈으로 등록하여 사용된다. 스프링 부트 3.0 이후에는 @RequestMapping만 있어서는 안되고 @Controller가 있어야지만 스프링 컨트롤러로 인식된다.

##### @RequestMapping
요청 정보를 매핑한다. 해당 URL이 호출되면 그에 맞는 특정 메서드가 호출이 된다. 클래스 레벨에 선언해서 사용하면 메서드 레벨과 조합이 되기 때문에 중복되는 부분을 줄일 수 있다. 
```java
@RequestMapping(value = "/save", method = RequestMethod.POST)
public void example_1() {
	return;
}

@PostMapping("/save") // 어노테이션 내부에 @RequestMapping이 있다.
public void example_2() {
	return;
}
```

##### @RestController
view가 아니라 문자열 같은 정보를 메세지 바디에 넣어서 반환할 수 있게 해준다. @ResponseBody는 해당 메서드에서만 가능하지만, 해당 어노테이션은 클래스레벨에서 가능하다. (내부적으로 @ResponseBody가 존재)

##### @RequestBody
클라이언트가 전송하는 JSON 형태의 HTTP Body의 내용을 MessageConverter를 통해서 Java Object로 변환시켜주는 역할을 수행한다.

##### @PathVariable
@PathVariable을 사용하면 매칭되는 부분을 편리하게 조회할 수 있다.

##### @RequestHeader
HTTP 헤더를 조회한다.

##### @RequestParam
스프링은 HTTP 요청 파라미터를 @RequestParam으로 받을 수 있다.
```java
@RequestParam("username") // request.getParam("username")
```
한 개의 요청 파라미터를 받기위해 사용한다. 필수 여부는 디폴트로 true이기에 반드시 파라미터가 전송되어야한다.

##### @ModelAttribute
요청 파라미터를 자바 객체에 바인딩할 때 사용하며, Setter, 생성자를 통해 값을 주입한다. 반면 JSON 같은 HTTP BODY는 @RequsetBody가 처리한다.
```java
public String modelAttributeV1(@ModelAttribute HelloData helloData)
```

##### @ResponseBody
String 타입으로 변환하면 뷰리졸버가 해당 문자열의 뷰를 찾지만 @ResponseBody를 두면 해당 메세지가 바디로 들어가게 된다.

### 인터셉터
필터가 서블릿에서 제공하는 기능이라면, 스프링 인터셉터는 스프링 MVC가 제공하는 기술이다. Http 요청 -> WAS -> 필터 -> 서블릿 -> 스프링 인터셉터 -> 컨트롤러 요청의 흐름을 가지고 있다. 스프링 인터셉터는 디스패처 서블릿과 컨틀롤러 사이에서 호출이된다. 스프링 인터셉터는 체인으로 구성이되어 중간에 인터셉터를 자유룝게 추가할 수 있다.
```java
public interface HandlerInterceptor { 
    default boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {} 

    default void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable ModelAndView modelAndView) throws Exception {}

    default void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws Exception {} 
}
```

#### point
##### 필터
필터는 서블릿이 제공하는 기술이다. 여러 로직에서 공통으로 관심이 있는 것을 공통 관심사라고 하는데 웹과 관련된 공통 관심사는 서블릿 필터, 스프링 인터셉터로 해결할 수 있다. Http 요청 -> WAS -> 필터 -> 서블릿 -> 컨트롤러 흐름을 가지고 있다. 디스패처 서블릿 이전에 실행되며, 필터는 체인으로 구성되고 중간에 필터를 자유롭게 추가할 수 있다.


---

## 📚 참고 및 링크
- [[ ]]

---

## 🔗 관련 노트
- [[../02 MOCs/Java|Java]]
