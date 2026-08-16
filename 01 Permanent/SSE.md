---
created: 2026-03-21
tags:
  - permanent
---

# SSE
---

## 📄 본문

### SSE(Server Sent Event)
서버로부터 클라이언트에 실시간으로 데이터를 전달할 수 있는 기술 중 하나 입니다.
클라이언트가 서버와 HTTP 연결을 맺어두면, 서버에서 데이터의 변화가 있을 때 마다 응답을 보냅니다.
Polling 방식에 비해 SSE를 이용하면 HTTP 연결을 한 번만 맺기 때문에 HTTP 연결에 대한 오버헤드가 줄어듭니다.

### SSE 특징
- 프로토콜: HTTP
- 데이터 전달 방향: server에서 client로 단방향
- 최대 접속 수: 브라우저당 최대 100개 (HTTP/2 기준)
- 기타: 자동 재연결 지원, socket보다 더 적은 메모리 및 CPU 소비

### SSE 구현 예시
Spring Boot를 이용한 SSE 구현 예시 코드입니다.
주기적으로 사용 가능한 토큰을 전송하는 예시입니다.

#### Service
```java
@Service
@RequiredArgsConstructor
public class TokenSseService {

    private final TokenService tokenService;

    private final Map<Long, SseEmitter> emitters = new ConcurrentHashMap<>();
    private final ExecutorService executorService = Executors.newCachedThreadPool();

    public SseEmitter subscribe(Long userId) {
        SseEmitter emitter = new SseEmitter(60L * 1000 * 10); // 10분
        emitters.put(userId, emitter);

        emitter.onCompletion(() -> emitters.remove(userId));
        emitter.onTimeout(() -> emitters.remove(userId));
        emitter.onError((e) -> emitters.remove(userId));

        sendConnectEvent(userId, emitter);
        startPolling(userId, emitter);

        return emitter;
    }

    private void sendConnectEvent(Long userId, SseEmitter emitter) {
        try {
            emitter.send(SseEmitter.event()
                    .name("connect")
                    .data("SSE 연결 완료: userId=" + userId));
        } catch (IOException e) {
            emitters.remove(userId);
            emitter.completeWithError(e);
        }
    }

    private void startPolling(Long userId, SseEmitter emitter) {
        executorService.execute(() -> {
            try {
                while (true) {
                    if (!emitters.containsKey(userId)) {
                        break;
                    }

                    Long remainingToken = tokenService.getRemainingToken(userId);

                    emitter.send(SseEmitter.event()
                            .name("token")
                            .data(remainingToken));

                    Thread.sleep(3000); // 3초마다 조회
                }
            } catch (Exception e) {
                emitters.remove(userId);
                emitter.completeWithError(e);
            }
        });
    }
}
```

#### SSEController
```java
@RestController
@RequiredArgsConstructor
@RequestMapping("/sse/tokens")
public class TokenSseController {

    private final TokenSseService tokenSseService;

    @GetMapping("/{userId}")
    public SseEmitter subscribe(@PathVariable Long userId) {
        return tokenSseService.subscribe(userId);
    }
}
```

#### 예시 코드 해설
- `new SseEmitter(...)`: 이 객체를 통해 서버가 클라이언트에게 이벤트를 보냅니다.
- `emitters.put(userId, emitter)`: 유저별 SSE 연결을 메모리에 저장합니다. 나중에 해당 유저에게 다시 push하거나 정리하기 위함입니다.
- `onCompletion`, `onTimeout`, `onError`: 브라우저가 닫히거나 연결이 끊기면 메모리에서 제거합니다. 메모리 누수 방지를 위한 처리입니다.
- `startPolling(...)`: 별도 스레드에서 무한 루프를 돌리면서 3초마다 DB를 조회하고 SSE로 전송하는 코드입니다.
- `SSEController`: `GET /sse/tokens/1`로 접속하면 SSE 연결이 시작됩니다.


---

## ✏️ 메모

### 프론트 연결 예시
EventSource를 사용한 연결 예시 코드
```javascript
const userId = 1;
const eventSource = new EventSource(`http://localhost:8080/sse/tokens/${userId}`);

eventSource.addEventListener("connect", (event) => {
  console.log("connect:", event.data);
});

eventSource.addEventListener("token", (event) => {
  console.log("token:", event.data);
  document.getElementById("token").innerText = event.data;
});

eventSource.onerror = (error) => {
  console.error("SSE error:", error);
};
```

## 📚 참고 및 링크

---

## 🔗 관련 노트
- [[ ]]
