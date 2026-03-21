## MSA 워크스페이스 기능 유지보수 규칙

MSA 전용 기능은 **루트에 `msa-workspace.json`이 있을 때만 활성화**된다.
단일 컴포넌트 워크스페이스에서는 모든 MSA 전용 훅과 에이전트가 자동으로 비활성화된다.

### 워크스페이스 타입 감지

모든 MSA 전용 스크립트는 `scripts/detect-workspace.sh`의 `is_msa_workspace()` 함수를 사용한다.

```bash
source "$(dirname "$0")/detect-workspace.sh"
if ! is_msa_workspace "$CWD"; then exit 0; fi
```

### 서비스 CLAUDE.md 규격

각 마이크로서비스 레포의 `CLAUDE.md`는 아래 섹션을 반드시 포함해야 한다.
`skills/msa-service-init/CLAUDE.md.template`을 기준으로 작성한다.

| 섹션 | 필수 여부 | 설명 |
|------|----------|------|
| `## Service` | 필수 | 역할, 포트, 기술 스택 |
| `## API` | 필수 | 외부 제공 엔드포인트 |
| `## Events Published` | 필수 | 발행 이벤트 (없으면 "없음") |
| `## Events Consumed` | 필수 | 구독 이벤트 (없으면 "없음") |
| `## Dependencies` | 필수 | 의존 서비스 (없으면 "없음") |

### 스크립트 디렉토리 규칙

MSA 전용 스크립트는 항상 `PROJECT_ROOT`를 기준으로 실행된다.

```bash
PROJECT_ROOT="$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // "."')"
cd "$PROJECT_ROOT"
```

스크립트 실행 중 서비스 디렉토리로 이동이 필요한 경우 **반드시 서브쉘로 격리**한다.
서브쉘이 종료되면 자동으로 `PROJECT_ROOT`로 복귀하므로 이후 명령에 영향을 주지 않는다.

```bash
# 올바른 방법: 서브쉘로 격리
RESULT=$(
  cd "$PROJECT_ROOT/$SERVICE_DIR"
  git diff --name-only HEAD
)

# 잘못된 방법: 현재 셸에서 cd
cd "$PROJECT_ROOT/$SERVICE_DIR"  # 이후 명령이 서비스 디렉토리에서 실행됨
git diff --name-only HEAD
```

### 새 MSA 전용 스크립트 추가 시

1. 스크립트 앞부분에 `detect-workspace.sh` 소스 및 `is_msa_workspace` 체크를 추가한다.
2. `hooks/hooks.json`에 훅을 등록한다.
3. 이 문서의 관련 섹션을 업데이트한다.

### 새 MSA 전용 에이전트/스킬 추가 시

파일 상단에 아래 적용 범위 안내를 추가한다.

```markdown
> **적용 범위:** 루트에 `msa-workspace.json`이 있는 MSA 워크스페이스에서만 사용.
```
