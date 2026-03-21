## Goal

MSA 워크스페이스에 새 마이크로서비스를 추가할 때 표준 CLAUDE.md를 생성하고 워크스페이스 매니페스트를 업데이트한다.

## Precondition

루트에 `msa-workspace.json`이 없으면 "MSA 워크스페이스가 아닙니다."를 출력하고 중단한다.

## Steps

### 1. CLAUDE.md 생성

`init-claude-md` 스킬을 실행해 새 서비스의 `CLAUDE.md`를 생성한다.
MSA 서비스 모드가 자동 감지되므로 MSA 전용 섹션이 포함된다.

### 2. msa-workspace.json 업데이트

`msa-workspace.json`의 `services` 배열에 새 서비스 항목을 추가한다.

```json
{ "name": "{service-name}", "dir": "{service-dir}", "port": {port} }
```

### 3. 워크스페이스 CLAUDE.md 업데이트

`init-claude-md` 스킬을 워크스페이스 루트에서 실행해 서비스 목록을 반영한다.

### 4. 완료 안내

생성 및 수정된 파일 목록을 출력한다.
