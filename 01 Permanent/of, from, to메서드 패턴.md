---
created: 2026-03-15
tags:
  - permanent
---

# of, from, to 메서드 패턴

---

## 📄 본문

### of 메서드
of 메서드는 정적 메서드로 구현되며, 여러 개의 인자를 받아 DTO 객체를 생성하는 역할을 합니다.
주로 생성자에 필요한 인자들을 파라미터로 받아서 DTO 객체를 생성하는 용도로 사용합니다.

```java
public static UserDTO of(String username, String email) {
    return UserDTO.builder()
            .username(username)
            .email(email)
            .build();
}
```

### from 메서드
from 메서드는 보통 정적 메서드로 구현되며, 다른 객체를 기반으로 DTO를 생성하는 역할을 합니다.
주로 엔티티나 다른 DTO를 변환하여 현재 DTO로 변환하는 용도로 사용합니다.

```java
public static UserDTO from(User user) {
    return UserDTO.builder()
            .username(user.getUsername())
            .email(user.getEmail())
            .build();
}
```

### fromList 메서드
fromList 메서드는 보통 정적 메서드로 구현되며, 다른 리스트를 기반으로 리스트 DTO로 변환할 때 사용합니다.

```java
public static List<UserDTO> fromList(List<User> users) {
    return users.stream()
            .map(UserDTO::from)
            .toList();
}
```

### to 메서드
from이 다른 객체 -> 현재 객체였다면, to는 현재 객체 -> 다른 객체로 변환하는 메서드입니다.
to 메서드는 정적 메서드가 아닌 인스턴스 메서드로 작성됩니다.
DTO를 Entity 객체로 변환할 때 사용하는 toEntity 메서드가 대표적입니다.

```java
private String username;
private String email;

public User toEntity() {
    return User.builder()
            .username(username)
            .email(email)
            .build();
}
```

---

## ✏️ 메모
### 객체 + 추가 파라미터 형식의 네이밍은?
객체를 기반으로 하지만 추가 파라미터가 필요할 때도 from을 씁니다.
값 기반 생성 시 of를 쓰고, 객체를 변환하는 역할이라면 from을 쓰면 됩니다.

## 📚 참고 및 링크
- [[ ]]

---

## 🔗 관련 노트
- 