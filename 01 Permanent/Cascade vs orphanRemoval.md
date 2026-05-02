---
created: 2026-05-02
tags:
  - permanent
---

# Cascade vs orphanRemoval
---

## 📄 본문

### Cascade란?
Cascade는 부모 엔티티의 상태 변화를 연관된 자식 엔티티에 전파하는 옵션입니다.

#### CascadeType
CascadeType은 총 6가지가 있습니다.
- **CascadeType.ALL**: 모든 Cascade를 적용
- **CascadeType.PERSIST**: 엔티티를 영속 상태로 만들면, 매핑된 엔티티도 함께 영속 상태가 됨
- **CascadeType.MERGE**: `merge` 시 연관된 엔티티도 함께 `merge`
- **CascadeType.REMOVE**: 엔티티를 제거하면 매핑된 엔티티도 함께 제거
- **CascadeType.DETACH**: 엔티티를 준영속 상태로 만들면, 매핑된 엔티티도 준영속 상태가 되어 EntityManager가 관리하지 않음
- **CascadeType.REFRESH**: 엔티티를 다시 읽어올 때, 매핑된 엔티티도 함께 다시 읽어옴

### orphanRemoval
orphanRemoval은 연관관계가 끊어진 고아 엔티티를 삭제하는 옵션입니다.
- 특정 엔티티가 단일 소유할 때, 참조하는 곳이 하나일 때 사용
- `@OneToOne`, `@OneToMany`에서만 사용 가능

### 고아 객체
고아 객체는 부모 엔티티와 연관관계가 끊어진 자식 엔티티를 의미합니다.
- 부모 엔티티가 제거될 때 자식 엔티티는 고아 객체가 될 수 있습니다.
- 부모 엔티티와 자식 엔티티 사이의 연관관계를 끊을 때도 자식 엔티티는 고아 객체가 됩니다.

### CascadeType.REMOVE vs orphanRemoval = true (@OneToMany의 고아 객체 처리)

#### 자식(FK를 가진 연관관계 주인) 예시
```java
public class Member {

    @Id @Column(name = "member_id")
    private Long id;

    @Column
    private String username;

    @ManyToOne
    @JoinColumn(name = "team_id")
    private Team team;
}
```

#### CascadeType.REMOVE
```java
public class Team {

    @Id @Column(name = "team_id")
    private Long id;

    @Column
    private String name;

    @OneToMany(
            mappedBy = "team",
            cascade = {CascadeType.REMOVE, CascadeType.PERSIST}
    )
    private List<Member> members = new ArrayList<>();
}
```

부모 엔티티가 삭제되면 자식 엔티티도 삭제됩니다. 즉, 부모 엔티티 삭제가 자식 삭제로 전파됩니다.

##### 부모 엔티티의 삭제가 아닌 부모-자식 사이 연관관계만 제거한다면?
연관관계만 끊으면 자식 엔티티는 DB에서 삭제되지 않습니다.
- FK를 `null`로 둘 수 있으면 `update`가 발생합니다.
- FK가 `null`을 허용하지 않으면 제약조건 문제가 생길 수 있습니다.

#### orphanRemoval = true
```java
public class Team {

    @Id @Column(name = "team_id")
    private Long id;

    @Column
    private String name;

    @OneToMany(
            mappedBy = "team",
            orphanRemoval = true,
            cascade = CascadeType.PERSIST
    )
    private List<Member> members = new ArrayList<>();
}
```

부모 엔티티가 삭제되면 자식 엔티티도 삭제됩니다. 다만 orphanRemoval의 핵심은 부모 삭제 자체보다, 관계가 끊어진 자식을 삭제하는 데 있습니다.

##### 부모 엔티티의 삭제가 아닌 부모-자식 사이 연관관계만 제거한다면?
자식 엔티티는 고아 객체로 취급되어 DB에서 삭제됩니다.
- 컬렉션에서 제거하거나 참조를 끊으면 `delete`가 발생합니다.

#### 핵심 정리
##### 공통점
- 부모 엔티티를 삭제하면 자식 엔티티도 함께 삭제될 수 있습니다.

##### 핵심 차이
- 부모-자식 사이의 연관관계만 제거할 때
- `CascadeType.REMOVE`: 자식 엔티티를 삭제하지 않고 관계만 끊습니다.
- `orphanRemoval = true`: 자식 엔티티를 고아 객체로 보고 삭제합니다.

### orphanRemoval의 false vs true
`team.getMembers().remove(member)`를 호출했을 때:
- `false`: FK를 끊는 `update` 쿼리 발생  
  (`UPDATE member SET team_id = NULL WHERE id = ?`)
- `true`: 자식 엔티티 삭제  
  (`DELETE FROM member WHERE id = ?`)

### 결론

| 특성 | CascadeType.REMOVE | orphanRemoval = true |
| --- | --- | --- |
| 작동 시점 | 부모 삭제 시 | 관계가 끊어질 때 |
| 삭제 트리거 | `em.remove(parent)` | 컬렉션에서 제거하거나 참조 해제 |
| 관계 해제 시 | FK만 끊거나 아무 일도 없음 | 자식 삭제 |
| 부모 삭제 시 | 자식도 삭제됨 | 자식도 삭제됨 |
| 핵심 의미 | 삭제 전파 | 고아 제거 |

#### 한 줄 요약
부모 엔티티 삭제만 전파하고 싶으면 `CascadeType.REMOVE`이고, 부모와의 관계가 끊긴 자식까지 자동 삭제하고 싶으면 `orphanRemoval = true`입니다.

---

## ✏️ 메모

## 📚 참고 및 링크

## 🔗 관련 노트
- [[Develop]]
