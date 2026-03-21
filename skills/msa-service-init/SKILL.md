## Goal

MSA 워크스페이스에 새 마이크로서비스를 추가할 때 표준 CLAUDE.md를 생성하고 워크스페이스 매니페스트를 업데이트한다.

## Precondition

루트에 `msa-workspace.json`이 없으면 "MSA 워크스페이스가 아닙니다."를 출력하고 중단한다.

## Steps

### 1. 정보 수집

사용자에게 아래 정보를 확인한다. 프롬프트에 이미 제공된 경우 다시 묻지 않는다.

- 서비스 이름 (디렉토리명과 동일하게)
- 서비스 역할 (한 줄 설명)
- 포트
- 기술 스택

### 2. CLAUDE.md 생성

`skills/msa-service-init/CLAUDE.md.template`을 읽어 수집한 정보로 치환한 뒤
`{service-dir}/CLAUDE.md`로 저장한다.

### 3. msa-workspace.json 업데이트

`msa-workspace.json`의 `services` 배열에 새 서비스 항목을 추가한다.

```json
{ "name": "{service-name}", "dir": "{service-dir}", "port": {port} }
```

### 4. 완료 안내

생성된 파일 목록을 출력하고, CLAUDE.md의 `## API`, `## Events`, `## Dependencies` 섹션을
실제 내용으로 채워달라고 안내한다.
