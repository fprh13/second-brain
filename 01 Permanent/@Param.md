---
created: 2026-03-25
tags:
  - permanent
---

# @Param
---

## 📄 본문
### Spring Data JPA의 @Param

#### 패키지

```java
org.springframework.data.repository.query.Param
```

#### 역할

JPQL 또는 Native Query에서 **쿼리 파라미터를 명시적으로 바인딩**하기 위해 사용합니다.

#### 예시

```java
@Query("select b from BodyShop b where b.name like %:keyword%")
Page<BodyShop> findByKeyword(@Param("keyword") String keyword, Pageable pageable);
```

#### 특징

- `:keyword`와 메서드 파라미터를 매핑
- 컴파일 옵션(`-parameters`)이 없어도 안정적으로 동작
- 명시적 바인딩으로 가독성과 안정성 확보

#### 동작 원리

Spring Data JPA는 다음 순서로 파라미터를 바인딩합니다.

1. `@Param` 기반 매핑
2. (없을 경우) 메서드 파라미터 이름 기반 매핑

### Lettuce의 @Param

#### 패키지

```java
io.lettuce.core.dynamic.annotation.Param
```

#### 역할

Redis Lettuce의 **Dynamic Command Interface**에서  
메서드 파라미터를 Redis 명령어에 매핑하기 위해 사용됩니다.

#### 예시

```java
public interface RedisCommands {

    String set(@Param("key") String key, @Param("value") String value);

    String get(@Param("key") String key);
}
```

#### 특징

- Redis 명령어 구성에 사용
- Spring Data JPA와는 완전히 무관
- 일반적인 Repository에서는 사용되지 않음

### 잘못 import 했는데도 동작하는 이유

만약, Lettuce의 @Param을 import하여 JPA Repository의 쿼리에 파라미터 바인딩을 시도하면 어떻게 될까요?
결과는 적용된다입니다. 이처럼 정상작동을 하기에, 사전에 잘못된 import를 인지하기 어렵습니다.
그럼 왜 정상작동을 하는 걸까요?

#### 원인

Spring Data JPA는 `@Param`이 없어도  
**메서드 파라미터 이름으로 바인딩**을 시도합니다.

```
Page<BodyShop> findByKeyword(String keyword);
```

#### 결과

- Lettuce의 `@Param`은 Spring 입장에서 무시됨
- 대신 `keyword` 이름으로 자동 바인딩
- → “정상 동작처럼 보임”

### 정리

| 구분    | Spring Data JPA        | Lettuce       |
| ----- | ---------------------- | ------------- |
| 패키지   | org.springframework... | io.lettuce... |
| 목적    | JPQL 파라미터 바인딩          | Redis 명령어 매핑  |
| 사용 위치 | Repository             | Redis 인터페이스   |
| 안정성   | 높음                     | 특정 상황에서만 사용   |

---

## ✏️ 메모

## 📚 참고 및 링크

## 🔗 관련 노트
- [[Develop]]
