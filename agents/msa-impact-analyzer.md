---
description: Analyzes which downstream services are affected by a change in a given service or contract file.
---

> **적용 범위:** 루트에 `msa-workspace.json`이 있는 MSA 워크스페이스에서만 사용.

## Goal

변경된 서비스 또는 계약 파일을 기준으로 영향받는 downstream 서비스를 분석하고 호환성 문제를 보고한다.

## Steps

### 1. 전제 조건 확인

루트에 `msa-workspace.json`이 없으면 "MSA 워크스페이스가 아닙니다."를 출력하고 중단한다.

### 2. 변경 대상 파악

프롬프트에 변경된 서비스 또는 파일 목록이 주어지면 그것을 사용한다.
없으면 각 서비스 디렉토리에서 `git diff --name-only HEAD`와 `git diff --name-only`를 실행해 변경된 파일을 확인한다.
각 서비스는 독립 git repo이므로 반드시 해당 서비스 디렉토리 기준으로 실행한다.

### 3. 의존 관계 수집

각 서비스의 CLAUDE.md `## Dependencies` 섹션을 읽어 의존 관계 그래프를 구성한다.

### 4. Downstream 서비스 탐색

변경된 서비스를 직접 또는 간접적으로 의존하는 서비스를 모두 찾는다 (BFS).

### 5. 호환성 검토

각 downstream 서비스에 대해:
- `contracts/` 디렉토리의 해당 서비스 스펙 파일을 읽는다.
- downstream 서비스의 코드에서 변경된 API/이벤트를 실제로 사용하는 부분을 찾는다.
- 변경 내용과 사용 코드를 비교해 호환성 문제 여부를 판단한다.

### 6. 출력

```
## Impact Analysis

### Changed: {service-name}

### Directly Affected Services
| Service | Dependency Type | Risk |
|---------|----------------|------|
| ...     | HTTP / Event   | HIGH / MEDIUM / LOW |

### Indirectly Affected Services
| Service | Via | Risk |
|---------|-----|------|

### Compatibility Issues
- [CRITICAL] service-name: {구체적인 문제 설명}
- [MAJOR]    service-name: {구체적인 문제 설명}
- [MINOR]    service-name: {구체적인 문제 설명}

### No Issues Found
- service-name: 호환성 문제 없음
```
