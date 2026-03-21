## Goal

현재 프로젝트/서비스의 코드와 구조를 분석해 표준 규격의 `CLAUDE.md`를 생성하거나 업데이트한다.
MSA 워크스페이스 여부를 자동 감지해 해당하는 섹션만 포함한다.

## Steps

### 1. 환경 감지

| 조건 | 모드 |
|------|------|
| 현재 디렉토리 루트에 `msa-workspace.json` 있음 | MSA 워크스페이스 루트 모드 |
| 부모 디렉토리에 `msa-workspace.json` 있음 | MSA 서비스 모드 |
| 그 외 | 단일 프로젝트 모드 |

### 2. 프로젝트 분석

아래 항목을 코드와 설정 파일에서 자동으로 추출한다.

| 항목 | 추출 방법 |
|------|----------|
| 프로젝트/서비스명 | 디렉토리명, `pom.xml`, `package.json`, `build.gradle`, `go.mod` 등 |
| 기술 스택 | 의존성 파일 |
| 포트 | `application.yml`, `application.properties`, `Dockerfile`, `docker-compose.yml` 등 |
| 제공 API | Controller/Router 코드 (엔드포인트 경로와 HTTP 메서드) |
| 서비스 역할 | README, 패키지 구조, 주요 클래스명에서 유추 |

### 3. MSA 전용 항목 추출 (MSA 서비스 모드일 때만)

| 항목 | 추출 방법 |
|------|----------|
| Events Published | 이벤트 발행 코드 (KafkaTemplate, EventBridge, pub/sub 등) |
| Events Consumed | 이벤트 구독 코드 (@KafkaListener, subscriber 등) |
| Dependencies | 다른 서비스 호출 코드 (FeignClient, WebClient, HTTP client, gRPC 등) |

### 4. CLAUDE.md 생성

**단일 프로젝트 모드 / MSA 서비스 모드:**
`skills/init-claude-md/CLAUDE.md.template`을 기반으로 추출한 정보를 채운다.
- 단일 프로젝트 모드: `[MSA only]` 섹션(`## Events Published`, `## Events Consumed`, `## Dependencies`)을 제외한다.
- MSA 서비스 모드: 모든 섹션을 포함한다.

**MSA 워크스페이스 루트 모드:**
`msa-workspace.json`과 각 서비스의 `CLAUDE.md`를 읽어 워크스페이스 수준의 `CLAUDE.md`를 생성한다.
워크스페이스 CLAUDE.md 형식:
```markdown
# {workspace-name} MSA Workspace

## Services
각 서비스의 상세 스펙은 해당 디렉토리의 CLAUDE.md를 참고.

| dir | port |
|-----|------|
| {service-dir} | {port} |

## Common Policies
- 에러 응답 형식: { code, message, traceId }
- 인증 방식:
- 배포 단위:
```

자동으로 추출하지 못한 항목은 `{추출 불가 - 직접 입력 필요}`로 표시한다.

### 5. 완료 안내

생성/업데이트된 파일 경로를 출력하고, `{추출 불가 - 직접 입력 필요}` 항목 목록을 안내한다.
