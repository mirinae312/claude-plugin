## Java + Spring 팀 표준 구조/컨벤션

> **적용 범위:** Java + Spring(Spring Boot) 프로젝트에만 적용. `pom.xml` 또는 `build.gradle`에 `spring` 의존성이 없는 프로젝트에는 적용하지 않는다.

### 아키텍처

레이어드 + 클린 아키텍처 혼합. 레이어는 **Controller → Service → Repository** 3단계.

### 패키지 구조

도메인 기준으로 분리.

```
com.{company}.{project}
└── user/
│   ├── UserController.java
│   ├── UserService.java
│   ├── UserRepository.java
│   ├── User.java
│   ├── UserRequest.java
│   └── UserResponse.java
└── order/
    ├── OrderController.java
    └── ...
```

### 네이밍 패턴

| 유형 | 패턴 | 예시 |
|------|------|------|
| Controller | `{Domain}Controller` | `UserController` |
| Service | `{Domain}Service` | `UserService` |
| Repository | `{Domain}Repository` | `UserRepository` |
| 도메인 모델 | `{Domain}` | `User` |
| 요청 DTO | `{Domain}Request` | `UserRequest` |
| 응답 DTO | `{Domain}Response` | `UserResponse` |
| 예외 | `{Domain}{Reason}Exception` | `UserNotFoundException` |

### Config 클래스

`Config`, `Configuration`, `Properties`, `Interceptor`, `Filter`, `Advice`, `Handler`, `Resolver`, `Converter`, `Serializer`, `Deserializer` suffix를 가진 클래스는 **원칙적으로** 전체 공통 `_config/` 패키지에 위치.

```
com.{company}.{project}
├── _config/
│   ├── SecurityConfig.java
│   ├── WebMvcConfig.java
│   └── ...
└── user/
    └── ...
```

단, 도메인에 특화된 경우(예: `UserExceptionHandler`)는 해당 도메인 패키지에 위치해도 무방.

### 예외 처리

- 도메인별 예외 클래스 정의 (`UserNotFoundException` 등)
- `@ControllerAdvice`로 글로벌 처리

### 테스트

| 유형 | 패턴 | 적용 범위 |
|------|------|------|
| 단위 테스트 | `{Class}Test` | 모든 레이어 (가능한 전부) |
| 통합 테스트 | `{Class}IntegrationTest` | 모든 레이어 (독립 실행 가능한 경우) |
