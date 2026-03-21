---
description: Reviews whether a feature spanning multiple services is implemented consistently.
---

> **적용 범위:** 루트에 `msa-workspace.json`이 있는 MSA 워크스페이스에서만 사용.

## Goal

단일 기능이 여러 서비스에 걸쳐 일관성 있게 구현됐는지 검토한다.

## Steps

### 1. 전제 조건 확인

루트에 `msa-workspace.json`이 없으면 "MSA 워크스페이스가 아닙니다."를 출력하고 중단한다.

### 2. 변경된 서비스 파악

프롬프트에 서비스 목록이 주어지면 그것을 사용한다.
없으면 `msa-workspace.json`의 서비스 목록을 순회하며 각 서비스 디렉토리에서
`git diff --name-only HEAD`를 실행해 변경 여부를 확인한다.
각 서비스는 독립 git repo이므로 반드시 해당 서비스 디렉토리 기준으로 실행한다.

### 3. 각 서비스의 변경 파일 읽기

변경된 파일을 모두 읽는다.

### 4. 일관성 체크리스트

#### API 계약 일치
- [ ] 호출자(consumer)의 요청 필드가 제공자(provider) API 스펙과 일치하는가
- [ ] 응답 필드 구조가 호출자가 기대하는 형태와 일치하는가
- [ ] HTTP 메서드, 경로, 상태 코드가 양쪽에서 동일하게 인식되는가

#### 이벤트 계약 일치
- [ ] 발행 이벤트의 페이로드 구조가 구독자가 기대하는 구조와 일치하는가
- [ ] 토픽 이름이 발행자-구독자 간 일치하는가

#### 에러 처리 일관성
- [ ] 에러 응답 형식이 워크스페이스 공통 정책을 따르는가
- [ ] 에러 코드 체계가 서비스 간 일관성이 있는가

#### 트랜잭션 경계
- [ ] 분산 트랜잭션이 필요한 경우 보상 트랜잭션 또는 saga 패턴이 설계됐는가
- [ ] 부분 실패 시나리오가 고려됐는가

## Output Format

```
## Cross-Service Review

### Services Reviewed
- service-a, service-b, ...

### API Contract
{findings}

### Event Contract
{findings}

### Error Handling
{findings}

### Transaction Boundary
{findings}

---
{summary: critical issues to fix before merge}
```

Use severity labels: **[CRITICAL]**, **[MAJOR]**, **[MINOR]**.
