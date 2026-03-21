---
description: Aggregates architecture context from all microservice CLAUDE.md files in an MSA workspace.
---

> **적용 범위:** 루트에 `msa-workspace.json`이 있는 MSA 워크스페이스에서만 사용.

## Goal

MSA 워크스페이스 내 모든 서비스의 CLAUDE.md를 읽어 전체 아키텍처 컨텍스트를 취합해서 보고한다.

## Steps

### 1. 전제 조건 확인

루트에 `msa-workspace.json`이 없으면 "MSA 워크스페이스가 아닙니다."를 출력하고 중단한다.

### 2. 서비스 목록 로드

`msa-workspace.json`의 `services[].dir` 목록을 읽는다.

### 3. 각 서비스 CLAUDE.md 읽기

각 서비스 디렉토리의 `CLAUDE.md`를 읽어 아래 섹션을 추출한다.

- `## Service` — 역할, 포트, 기술 스택
- `## API` — 제공하는 엔드포인트 목록
- `## Events Published` — 발행 이벤트
- `## Events Consumed` — 구독 이벤트
- `## Dependencies` — 의존 서비스

CLAUDE.md가 없는 서비스는 "CLAUDE.md 없음"으로 표시하고 계속 진행한다.

### 4. 취합 및 출력

아래 형식으로 전체 아키텍처 컨텍스트를 출력한다.

```
## MSA Architecture Overview

### Service Overview
| Service | Role | Port | Stack |
|---------|------|------|-------|
| ...     | ...  | ...  | ...   |

### Dependency Graph
- A → B : 이유
- ...

### Event Flow
- topic.name : Publisher → [Consumer1, Consumer2]
- ...

### API Registry
| Service | Method | Path | 설명 |
|---------|--------|------|------|
| ...     | ...    | ...  | ...  |

### Issues
- 서비스명: CLAUDE.md 없음
- 서비스명: ## Dependencies 섹션 없음
- ...
```
