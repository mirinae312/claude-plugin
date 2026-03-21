---
description: Generate unit tests for a Bash script using BATS (Bash Automated Testing System).
---

## Goal

Generate unit tests for the target `.sh` or `.bash` file. Always use BATS if it is already present in the project. Never introduce a new test dependency without asking the user first.

## Steps

### 1. Identify the target

- If a specific file was mentioned, use that.
- Otherwise, use the most recently edited `.sh` or `.bash` file.

### 2. Detect the project's test stack

Look for BATS in the repo: `*.bats` files, `.bats/` directory, or `bats` in `package.json`.

- Framework: BATS (`bats-core`)
- If BATS is not present, note it and ask the user whether to proceed with BATS or skip.

### 3. Read the target script

- Understand the structure: functions and their behavior.
- Identify external commands or side effects that need to be stubbed.

### 4. Determine the test file location

Follow the project's existing test layout if test files are already present. Otherwise use:

```
test/{script}.bats
```

or `tests/{script}.bats`.

### 5. Generate the test file

- Use only BATS.
- Cover for each public function:
  - **Happy path** — normal input produces expected output
  - **Edge cases** — empty input, boundary values
  - **Error cases** — non-zero exit codes
- Write descriptive test names that express intent clearly.
- Keep each test focused on a single behavior.

### 6. Report

- Confirm the framework used (BATS).
- List the generated test cases with a brief description of what each covers.
