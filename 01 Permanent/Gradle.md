---
created: <% tp.file.creation_date("YYYY-MM-DD") %>
tags:
  - permanent
---

# Gradle

---

## 📄 본문

### Gradle

Gradle은 Java, Kotlin 등을 사용하는 프로젝트에서 빌드 과정을 자동화하는 도구다.

소스 코드 컴파일, 의존성 관리, 테스트 실행, JAR 패키징 등의 작업을 수행한다.

Gradle은 빌드 설정을 작성하기 위해 두 가지 DSL(Domain-Specific Language)을 지원한다.

- **Groovy DSL:** Groovy 언어를 기반으로 빌드 스크립트 작성
- **Kotlin DSL:** Kotlin 언어를 기반으로 빌드 스크립트 작성

두 방식 모두 동일한 Gradle 빌드 시스템을 사용하며, 빌드 스크립트를 작성하는 언어가 다르다.

따라서 Gradle과 Kotlin 중 하나를 선택하는 것이 아니라 **Gradle의 빌드 스크립트를 Groovy와 Kotlin 중 어떤 언어로 작성할지 선택하는 것**이다.

#### 주요 차이점

|항목|Groovy DSL|Kotlin DSL|
|---|---|---|
|파일명|`build.gradle`|`build.gradle.kts`|
|사용 언어|Groovy|Kotlin|
|타입 시스템|동적 타입 기반|정적 타입 기반|
|문법|간결하고 유연함|명시적이고 엄격함|
|IDE 자동완성|지원|타입 기반 지원이 더 강력함|
|오류 확인|일부 오류가 설정 실행 중 발견될 수 있음|타입 오류를 스크립트 컴파일 시점에 확인|
|초기 스크립트 컴파일|상대적으로 빠른 편|상대적으로 느릴 수 있음|
|기존 프로젝트|오래된 프로젝트에서 접할 가능성이 높음|신규 프로젝트에서 우선 검토할 만함|
|Spring Boot 지원|O|O|

Gradle 공식 문서에서는 신규 프로젝트에 Kotlin DSL을 사용하는 것을 권장한다.

특히 Kotlin DSL은 정적 타입 시스템을 활용하므로 IntelliJ IDEA에서 자동완성, 코드 탐색, 리팩토링 등의 지원을 더 효과적으로 사용할 수 있다.

Gradle 8.2부터는 `gradle init`으로 생성하는 프로젝트의 기본 DSL도 Kotlin으로 변경되었다.

다만 **Groovy DSL이 폐지되거나 더 이상 지원되지 않는 것은 아니다.** 두 방식 모두 Gradle에서 공식적으로 지원한다. [Gradle Documentation](https://docs.gradle.org/current/userguide/best_practices_general.html?utm_source=chatgpt.com)

### 한국 개발 시장에서의 사용 현황

2026년 10월 기준, 국내 Java/Spring 백엔드 프로젝트 전체를 대상으로 Groovy DSL과 Kotlin DSL의 사용 비율을 직접 비교한 신뢰할 만한 공개 통계는 확인하기 어렵다.

따라서 어느 쪽이 몇 퍼센트 더 많이 사용된다고 단정하기는 어렵다.

다만 국내 기술 자료와 프로젝트의 특성을 고려하면 다음과 같이 이해할 수 있다.

|구분|사용 경향|
|---|---|
|기존 Java/Spring 백엔드|Groovy DSL을 접할 가능성이 높음|
|신규 Java/Spring 백엔드|Kotlin DSL을 선택할 근거가 충분함|
|Kotlin 기반 Spring Boot|Kotlin DSL이 자연스러운 선택|
|Android 개발|Kotlin DSL이 기본 선택지|
|레거시 시스템 유지보수|기존 Groovy DSL 유지 가능성이 높음|

이는 국내 시장점유율을 측정한 결과가 아니라 기존 프로젝트의 역사와 도구의 변화에 근거한 경향 분석이다.

국내에서도 Kotlin DSL이 최근에 등장한 기술은 아니다.

예를 들어 우아한형제들은 2019년부터 Gradle Kotlin DSL을 기술 블로그에서 소개했으며, 2020년에는 Groovy와 Kotlin DSL을 모두 활용한 Gradle 설정 사례를 공유했다. [우아한형제들 기술블로그 배달의민족을 만드는 기술 이야기 |](https://techblog.woowahan.com/2625/?utm_source=chatgpt.com)

또한 Gradle 자체가 신규 빌드에 Kotlin DSL을 권장하면서 신규 프로젝트에서는 Kotlin DSL을 선택할 이유가 더욱 명확해졌다.

**Java/Spring 백엔드 취업을 준비하는 입장에서는 Groovy DSL을 읽고 수정할 수 있는 능력을 갖추되, 신규 개인 프로젝트에서는 Kotlin DSL을 사용하는 방향이 합리적이다.**

기존 프로젝트가 Groovy DSL을 사용하고 있다면 단순히 Kotlin DSL이 최신 권장 방식이라는 이유로 전환할 필요는 없다.

### Kotlin DSL의 장점

#### 정적 타입 검사

Groovy는 동적 타입 언어이므로 일부 설정 오류가 빌드 스크립트 실행 과정에서 발견될 수 있다.

반면 Kotlin DSL은 정적 타입 시스템을 활용하여 잘못된 타입이나 존재하지 않는 속성 접근 등을 스크립트 컴파일 시점에 검출할 수 있다.

예를 들어 Gradle이 제공하는 `JavaVersion` 객체의 속성이나 메서드를 사용할 때 IntelliJ IDEA에서 타입 정보를 확인할 수 있다.

#### IDE 지원

Kotlin DSL은 IntelliJ IDEA에서 다음 기능을 활용하기 좋다.

- Gradle API 자동완성
- 메서드 및 속성 정의로 이동
- 타입 오류 확인
- 코드 리팩토링
- API 문서 및 매개변수 정보 확인

단, 모든 설정 요소에 자동완성 기능이 제공되는 것은 아니다.

Gradle은 플러그인 적용 과정에서 빌드 모델을 구성하므로, 동적으로 생성한 설정 요소에는 Kotlin DSL의 타입 안전 접근자가 제공되지 않을 수 있다.

#### 유지보수

Kotlin DSL은 명시적인 문법과 타입 정보를 사용하므로 복잡한 빌드 설정을 작성하거나 수정할 때 실수를 줄이는 데 도움이 된다.

다만 모든 프로젝트에서 Kotlin DSL이 더 간결하거나 이해하기 쉬운 것은 아니다.

기존에 Groovy DSL을 사용하던 팀에서는 익숙한 문법을 유지하는 것이 생산성 측면에서 유리할 수 있다.

#### 단점

Kotlin DSL은 빌드 스크립트를 컴파일하는 과정에서 초기 설정 시간이 더 길어질 수 있다.

특히 처음 프로젝트를 내려받거나 CI 환경에서 빌드 캐시를 재사용하지 못하는 경우 Groovy DSL보다 스크립트 컴파일 비용이 커질 수 있다.

이는 Kotlin DSL을 사용하면 애플리케이션의 실제 컴파일이나 테스트 실행이 항상 느려진다는 의미는 아니다.

또한 Kotlin 문법을 알아야 하므로 Groovy DSL만 사용한 개발자에게는 초기 학습 비용이 발생한다. [Gradle Documentation](https://docs.gradle.org/current/userguide/kotlin_dsl.html?utm_source=chatgpt.com)

### Groovy DSL과 Kotlin DSL 문법 비교

두 DSL은 사용하는 Gradle API가 동일하기 때문에 설정의 목적과 동작 방식은 대부분 같다.

차이는 해당 API를 호출하는 문법에서 발생한다.

#### 1. 플러그인 선언

플러그인은 Gradle에 새로운 기능이나 Task를 추가한다.

**Groovy DSL**

```
plugins {
    id 'java'
    id 'org.springframework.boot' version '4.1.1'
    id 'io.spring.dependency-management' version '1.1.7'
}
```

**Kotlin DSL**

```
plugins {
    java
    id("org.springframework.boot") version "4.1.1"
    id("io.spring.dependency-management") version "1.1.7"
}
```

- `java`: Java 프로젝트에 필요한 컴파일 및 테스트 Task 제공
- `org.springframework.boot`: Spring Boot 실행 및 실행 가능한 JAR 패키징 지원
- `io.spring.dependency-management`: BOM 기반 의존성 버전 관리 지원

Kotlin DSL에서는 Gradle의 기본 Java 플러그인을 `java`라는 타입 안전 접근자로 선언할 수 있다.

`id("java")`로 작성하는 것도 가능하다.

#### 2. 의존성 선언

의존성은 프로젝트에서 사용하는 외부 라이브러리를 의미한다.

**Groovy DSL**

```
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-webmvc'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'

    runtimeOnly 'com.mysql:mysql-connector-j'

    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}
```

**Kotlin DSL**

```
dependencies {
    implementation("org.springframework.boot:spring-boot-starter-webmvc")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")

    runtimeOnly("com.mysql:mysql-connector-j")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
}
```

Groovy DSL에서는 메서드 호출 시 괄호를 생략할 수 있다.

Kotlin DSL에서는 일반적인 Kotlin 함수 호출 문법을 사용한다.

위 예시는 Spring Boot 4를 기준으로 작성했다.

Spring Boot 4에서는 기존 `spring-boot-starter-web` 대신 `spring-boot-starter-webmvc`를 사용하는 것이 권장된다.

#### 3. 의존성 구성(Configuration)

Gradle에서는 라이브러리가 필요한 시점과 목적에 따라 의존성을 구분한다.

|Configuration|설명|
|---|---|
|`implementation`|컴파일과 실행에 필요한 의존성|
|`compileOnly`|컴파일 시점에만 필요한 의존성|
|`runtimeOnly`|실행 시점에만 필요한 의존성|
|`annotationProcessor`|어노테이션 프로세서 실행에 필요한 의존성|
|`testImplementation`|테스트 컴파일 및 실행에 필요한 의존성|
|`testRuntimeOnly`|테스트 실행 시점에만 필요한 의존성|

예를 들어 Lombok은 컴파일 과정에서 어노테이션을 처리하므로 다음과 같이 선언할 수 있다.

**Groovy DSL**

```
dependencies {
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'
}
```

**Kotlin DSL**

```
dependencies {
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
}
```

이러한 Configuration의 의미는 Groovy와 Kotlin DSL에서 동일하다.

참고로 Java 라이브러리를 개발할 때는 `java-library` 플러그인이 제공하는 `api` Configuration도 사용할 수 있다.

`api`는 라이브러리를 사용하는 다른 프로젝트의 컴파일 클래스패스에도 필요한 의존성을 공개할 때 사용한다.

#### 4. Java 버전 설정

Gradle에서는 Java Toolchain을 통해 프로젝트의 컴파일 및 테스트 등에 사용할 JDK 버전을 지정할 수 있다.

**Groovy DSL**

```
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}
```

**Kotlin DSL**

```
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}
```

이 경우 두 DSL의 작성 방식은 같다.

다만 Java Toolchain으로 설정한 JDK 버전과 Gradle 자체를 실행하는 JVM 버전은 서로 구분해야 한다.

또한 Java 25를 사용하려면 Gradle 버전의 호환성도 확인해야 한다.

공식 호환성 문서에 따르면 Java 25는 Gradle 9.1.0부터 Toolchain과 Gradle 실행 환경에서 모두 정식 지원된다. [Gradle Documentation](https://docs.gradle.org/current/userguide/compatibility.html?utm_source=chatgpt.com)

#### 5. 변수 선언

**Groovy DSL**

```
def javaVersion = 25

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(javaVersion)
    }
}
```

**Kotlin DSL**

```
val javaVersion = 25

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(javaVersion)
    }
}
```

Groovy에서는 `def`를 사용할 수 있다.

Kotlin에서는 `val`, `var`를 사용한다.

- `val`: 변수를 다시 할당할 수 없음
- `var`: 변수에 새로운 값을 다시 할당할 수 있음

단, `val`이 참조하는 객체의 내부 상태까지 불변으로 만드는 것은 아니다.

#### 6. Task 설정

Task는 Gradle에서 실행되는 작업 단위다.

예를 들어 `compileJava`, `test`, `bootJar` 등이 있다.

**Groovy DSL**

```
tasks.named('test') {
    useJUnitPlatform()
}
```

**Kotlin DSL**

```
tasks.named<Test>("test") {
    useJUnitPlatform()
}
```

`tasks.named()`는 이미 등록된 Task를 이름으로 찾아 설정할 때 사용한다.

Kotlin DSL에서는 `<Test>`를 통해 Task 타입을 명시할 수 있다.

다음과 같이 작성할 수도 있다.

```
tasks.test {
    useJUnitPlatform()
}
```

단, `tasks.test`와 같은 타입 안전 접근자는 관련 플러그인이 적절한 시점에 적용되어 있어야 사용할 수 있다.

#### 7. 새로운 Task 생성

Gradle에서는 필요한 작업을 직접 Task로 등록할 수 있다.

**Groovy DSL**

```
tasks.register('hello') {
    doLast {
        println 'Hello Gradle'
    }
}
```

**Kotlin DSL**

```
tasks.register("hello") {
    doLast {
        println("Hello Gradle")
    }
}
```

등록된 Task는 다음 명령어로 실행할 수 있다.

```
./gradlew hello
```

출력:

```
Hello Gradle
```

`tasks.register()`는 Task를 지연 등록하는 방식이다.

Gradle은 실제로 필요한 Task만 구성하는 Configuration Avoidance 방식을 권장한다.

따라서 특별한 이유가 없다면 새로운 Task를 작성할 때 `tasks.create()`보다 `tasks.register()`를 사용하는 것이 좋다.

### Gradle 프로젝트 구조

Gradle 프로젝트는 일반적으로 다음 구조로 구성된다.

**Groovy DSL**

```
project/
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   └── test/
│       └── java/
├── build.gradle
├── settings.gradle
├── gradle.properties
├── gradlew
└── gradlew.bat
```

**Kotlin DSL**

```
project/
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   └── test/
│       └── java/
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
├── gradlew
└── gradlew.bat
```

두 방식의 기본 프로젝트 구조는 같다.

차이는 빌드 설정을 작성하는 파일의 확장자다.

#### 주요 파일

|파일|역할|
|---|---|
|`build.gradle(.kts)`|플러그인, 의존성, Task 등 빌드 설정|
|`settings.gradle(.kts)`|프로젝트 이름 및 멀티 모듈 구성|
|`gradle.properties`|Gradle 실행과 관련된 속성 관리|
|`gradlew`|macOS/Linux에서 Gradle Wrapper 실행|
|`gradlew.bat`|Windows에서 Gradle Wrapper 실행|
|`gradle-wrapper.properties`|프로젝트에서 사용할 Gradle 배포판 버전 설정|

#### settings.gradle

`settings.gradle`은 프로젝트의 기본 설정을 담당한다.

**Groovy DSL**

```
rootProject.name = 'gradle-study'

include 'api', 'core'
```

**Kotlin DSL**

```
rootProject.name = "gradle-study"

include("api", "core")
```

위 코드는 프로젝트 이름을 `gradle-study`로 설정하고 `api`, `core`라는 하위 프로젝트를 포함하도록 구성한다.

단일 모듈 프로젝트에서는 `include` 설정이 필요하지 않다.

### Gradle Wrapper

Gradle Wrapper는 프로젝트에서 사용할 Gradle 버전을 지정하고 실행하기 위한 기능이다.

개발자가 시스템에 Gradle을 별도로 설치하지 않아도 프로젝트에서 지정한 버전을 사용할 수 있다.

```
./gradlew build
```

이 명령어는 프로젝트에 포함된 Wrapper 설정을 기준으로 Gradle을 실행한다.

사용할 Gradle 버전은 `gradle-wrapper.properties`에서 확인할 수 있다.

```
distributionUrl=https\://services.gradle.org/distributions/gradle-9.1.0-bin.zip
```

이는 Gradle 9.1.0을 사용하도록 설정한 예시다.

Gradle 버전을 업그레이드할 때는 Wrapper Task를 사용할 수 있다.

```
./gradlew wrapper --gradle-version 9.1.0
```

실제 사용하는 Gradle 버전을 확인하려면 다음 명령어를 실행한다.

```
./gradlew --version
```

**Gradle 프로젝트에서는 시스템에 설치된 `gradle` 명령어보다 `./gradlew` 사용을 권장한다.**

이를 통해 팀원이나 CI 환경에서도 프로젝트가 지정한 Gradle 버전을 사용할 수 있다. [Gradle Documentation](https://docs.gradle.org/current/userguide/gradle_wrapper.html?utm_source=chatgpt.com)

### Gradle 빌드 실행

Gradle은 프로젝트에 등록된 Task를 실행하여 컴파일, 테스트, 패키징 등을 수행한다.

대표적인 명령어는 다음과 같다.

|명령어|설명|
|---|---|
|`./gradlew tasks`|실행 가능한 주요 Task 확인|
|`./gradlew clean`|빌드 결과물 삭제|
|`./gradlew compileJava`|Java 소스 코드 컴파일|
|`./gradlew test`|테스트 실행|
|`./gradlew build`|빌드 및 검증 작업 수행|
|`./gradlew bootRun`|Spring Boot 애플리케이션 실행|
|`./gradlew bootJar`|실행 가능한 Spring Boot JAR 생성|
|`./gradlew dependencies`|의존성 트리 조회|
|`./gradlew --version`|Gradle 및 실행 JVM 정보 확인|

`bootRun`과 `bootJar`는 Spring Boot 플러그인을 적용했을 때 사용할 수 있는 Task다.

#### 빌드 과정

Gradle은 일반적으로 다음 세 단계로 빌드를 수행한다.

1. **Initialization:** 프로젝트 구조와 설정 파일 확인
2. **Configuration:** 빌드 스크립트를 평가하고 Task 구성
3. **Execution:** 요청된 Task와 필요한 의존 Task 실행

Groovy DSL과 Kotlin DSL은 모두 동일한 Gradle 빌드 생명주기를 사용한다.

DSL 선택은 빌드 스크립트의 작성과 평가 방식에 영향을 주지만, Gradle의 전체 빌드 구조를 변경하지는 않는다.

### Spring Boot 4 - Groovy DSL 예시

Java 25와 Spring Boot 4.1.1을 사용하는 프로젝트를 가정한다.

**build.gradle**

```
plugins {
    id 'java'
    id 'org.springframework.boot' version '4.1.1'
    id 'io.spring.dependency-management' version '1.1.7'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-webmvc'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'

    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'

    runtimeOnly 'com.h2database:h2'

    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'org.springframework.boot:spring-boot-starter-webmvc-test'

    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

### Spring Boot 4 - Kotlin DSL 예시

위 설정을 Kotlin DSL로 작성하면 다음과 같다.

**build.gradle.kts**

```
plugins {
    java
    id("org.springframework.boot") version "4.1.1"
    id("io.spring.dependency-management") version "1.1.7"
}

group = "com.example"
version = "0.0.1-SNAPSHOT"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-webmvc")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")

    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")

    runtimeOnly("com.h2database:h2")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.boot:spring-boot-starter-webmvc-test")

    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<Test>().configureEach {
    useJUnitPlatform()
}
```

두 코드는 동일한 목적의 Spring Boot 프로젝트를 구성한다.

또한 두 예시 모두 Spring Boot의 Dependency Management 플러그인을 사용하므로 Spring Boot BOM에서 관리하는 라이브러리는 버전을 생략할 수 있다.

Spring Boot 4에서는 Gradle 자체의 BOM 지원 기능도 사용할 수 있으며, 두 의존성 관리 방식의 차이를 이해하고 선택하면 된다. [Home](https://docs.spring.io/spring-boot/gradle-plugin/managing-dependencies.html?utm_source=chatgpt.com)

#### Kotlin DSL을 사용하면 Kotlin으로 개발해야 하는가?

그렇지 않다.

`build.gradle.kts`는 빌드 스크립트를 Kotlin으로 작성한다는 의미일 뿐, 애플리케이션 소스 코드를 Kotlin으로 작성해야 한다는 의미가 아니다.

따라서 다음과 같은 구성이 가능하다.

```
build.gradle.kts
    ↓
Gradle Kotlin DSL

src/main/java/
    ↓
Java 25

Spring Boot 4
    ↓
Java 기반 백엔드 애플리케이션
```

Java 프로젝트에서 Kotlin DSL을 사용하기 위해 `org.jetbrains.kotlin.jvm` 플러그인을 추가할 필요도 없다.

Kotlin DSL 자체는 Gradle이 지원하므로 Java 플러그인만으로 Java 애플리케이션을 빌드할 수 있다.

### Groovy DSL에서 Kotlin DSL로 변경

기존 Groovy DSL 프로젝트를 Kotlin DSL로 변경하려면 파일 확장자와 스크립트 문법을 변경해야 한다.

대표적인 변경 사항은 다음과 같다.

|Groovy DSL|Kotlin DSL|
|---|---|
|`build.gradle`|`build.gradle.kts`|
|`settings.gradle`|`settings.gradle.kts`|
|`id 'java'`|`id("java")`|
|`implementation 'group:artifact'`|`implementation("group:artifact")`|
|`def name = 'example'`|`val name = "example"`|
|`tasks.register('hello')`|`tasks.register("hello")`|
|`include 'api'`|`include("api")`|

단, 단순히 확장자를 `.gradle.kts`로 변경한다고 기존 Groovy 문법이 자동으로 Kotlin으로 변환되는 것은 아니다.

복잡한 플러그인 설정, 동적으로 생성한 속성, 커스텀 Task 등은 별도의 수정이 필요할 수 있다.

Gradle은 하나의 멀티 프로젝트 빌드에서 Groovy DSL과 Kotlin DSL을 함께 사용할 수 있도록 지원한다.

따라서 반드시 모든 모듈을 동시에 전환할 필요는 없다. [Gradle Documentation](https://docs.gradle.org/current/userguide/migrating_from_groovy_to_kotlin_dsl.html?utm_source=chatgpt.com)

### Kotlin DSL 선택 시 주의 사항

#### 플러그인 적용 순서

Kotlin DSL은 플러그인이 제공하는 속성이나 Configuration에 접근하기 위해 타입 안전 접근자를 생성한다.

이 접근자들은 일반적으로 `plugins {}` 블록을 평가한 이후 사용할 수 있다.

```
plugins {
    java
}

dependencies {
    implementation("org.apache.commons:commons-lang3:3.17.0")
}
```

위 예시에서는 Java 플러그인이 `implementation` Configuration을 제공하므로 타입 안전 접근자를 사용할 수 있다.

반면 스크립트 본문에서 동적으로 생성한 Configuration은 동일한 방식의 접근자가 제공되지 않을 수 있다.

이 경우 문자열을 이용한 API 호출 등을 사용해야 한다.

#### 빌드 스크립트와 Kotlin 애플리케이션의 차이

Kotlin DSL은 Kotlin 문법을 사용하지만 Gradle의 빌드 API를 바탕으로 동작한다.

따라서 일반 Kotlin 애플리케이션에서 사용하는 라이브러리와 Gradle 빌드 스크립트에서 사용하는 API를 구분해야 한다.

또한 Gradle이 내부적으로 사용하는 Kotlin 버전과 애플리케이션에서 사용하는 Kotlin 버전은 반드시 동일하지 않다.

#### 기존 Groovy DSL을 유지해야 하는 경우

기존 프로젝트에서 Groovy DSL을 사용하고 있다면 다음 사항을 고려한다.

- 빌드 설정이 안정적으로 동작하는지
- 사용하는 플러그인이 Kotlin DSL을 지원하는지
- 팀원들이 Kotlin DSL에 익숙한지
- 전환으로 얻을 유지보수상의 이점이 충분한지

Kotlin DSL의 장점이 존재하더라도 단순한 문법 변경을 위해 불필요한 마이그레이션 비용을 발생시킬 필요는 없다.

### Gradle DSL 선택 가이드

|상황|권장 방식|
|---|---|
|신규 Java/Spring Boot 프로젝트|Kotlin DSL|
|신규 Kotlin/Spring Boot 프로젝트|Kotlin DSL|
|기존 Groovy DSL 프로젝트 유지보수|Groovy DSL 유지|
|복잡한 빌드 설정과 IDE 지원이 중요한 경우|Kotlin DSL 우선 검토|
|Groovy 기반 커스텀 빌드 로직이 많은 프로젝트|기존 구조와 전환 비용 검토|
|Java/Spring 백엔드 취업 준비|두 DSL 모두 학습|
|Java 25 + Spring Boot 4 신규 프로젝트|Kotlin DSL|

현재 Java/Spring 백엔드 개발을 기준으로 한다면 **기존 프로젝트의 Groovy DSL을 이해하는 능력과 신규 프로젝트에서 Kotlin DSL을 활용하는 능력을 함께 갖추는 것이 좋다.**

특히 IntelliJ IDEA를 주로 사용한다면 Kotlin DSL의 타입 안전성과 자동완성 지원을 활용할 수 있다.

반면 기존 프로젝트를 유지보수하는 상황에서는 빌드 스크립트를 다른 DSL로 변경하는 것보다 현재 구성의 동작을 정확히 이해하는 것이 우선이다.

### 핵심 정리

Gradle은 빌드 자동화 도구이며, Groovy DSL과 Kotlin DSL은 Gradle 설정을 작성하기 위한 두 가지 방식이다.

주요 차이점은 다음과 같다.

- **Groovy DSL:** 간결하고 유연한 문법을 제공하며 기존 프로젝트에서 활용된다.
- **Kotlin DSL:** 정적 타입 시스템을 활용해 IDE 자동완성과 타입 검사를 지원한다.
- **빌드 동작:** 두 DSL 모두 동일한 Gradle API와 빌드 시스템을 사용한다.
- **공식 권장:** Gradle은 신규 프로젝트에서 Kotlin DSL 사용을 권장한다.
- **국내 시장:** 정확한 사용 비율은 확인하기 어렵지만, Groovy DSL을 사용하는 기존 프로젝트와 Kotlin DSL을 선택하는 신규 프로젝트를 모두 고려해야 한다.

Spring Boot 4와 Java 25로 새로운 프로젝트를 개발한다면 Kotlin DSL을 사용하는 것이 합리적인 선택이다.

다만 Kotlin DSL을 선택하더라도 애플리케이션 자체는 Java로 개발할 수 있으며, Kotlin 관련 애플리케이션 의존성을 추가할 필요는 없다.

---

## 📚 참고 및 링크

- [Gradle 공식 문서 - Build File Basics](https://docs.gradle.org/current/userguide/build_file_basics.html?utm_source=chatgpt.com)
- [Gradle 공식 문서 - Kotlin DSL](https://docs.gradle.org/current/userguide/kotlin_dsl.html?utm_source=chatgpt.com)
- [Gradle 공식 문서 - Best Practices](https://docs.gradle.org/current/userguide/best_practices_general.html?utm_source=chatgpt.com)
- [Gradle 공식 문서 - Groovy에서 Kotlin DSL로 마이그레이션](https://docs.gradle.org/current/userguide/migrating_from_groovy_to_kotlin_dsl.html?utm_source=chatgpt.com)
- [Gradle 공식 문서 - Java 호환성](https://docs.gradle.org/current/userguide/compatibility.html?utm_source=chatgpt.com)
- [Gradle 공식 문서 - Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html?utm_source=chatgpt.com)
- [Spring Boot - Gradle Plugin](https://docs.spring.io/spring-boot/gradle-plugin/?utm_source=chatgpt.com)
- [우아한형제들 - Gradle Kotlin DSL 이야기](https://techblog.woowahan.com/2625/?utm_source=chatgpt.com)
- [JetBrains - 새로운 Gradle 빌드의 기본 언어로 채택된 Kotlin DSL](https://blog.jetbrains.com/ko/kotlin/2023/05/kotlin-dsl-is-the-default-for-new-gradle-builds/?utm_source=chatgpt.com)

---

## 🔗 관련 노트

- [[../02 MOCs/Spring|Spring]]
