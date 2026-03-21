---
description: Generate unit tests for a Python source file using the test framework and libraries already declared in the project.
---

## Goal

Generate unit tests for the target `.py` file or function. Always use the test framework and libraries already declared in the project. Never introduce a new test dependency without asking the user first.

## Steps

### 1. Identify the target

- If a specific file or function was mentioned, use that.
- Otherwise, use the most recently edited `.py` file.

### 2. Detect the project's test stack

Read `pyproject.toml`, `setup.cfg`, `pytest.ini`, `tox.ini`, or `requirements*.txt` and identify the framework in use.

- Frameworks: pytest (`pytest`), unittest (stdlib — always available), nose2 (`nose2`)
- Mocking: `unittest.mock` (stdlib), `pytest-mock` (`pytest-mock`)

If no test dependencies are found, ask the user which framework to use before proceeding.

### 3. Read the target source file

- Understand the structure: classes, functions, and their signatures.
- Identify external dependencies or side effects that need to be mocked or stubbed.

### 4. Determine the test file location

Follow the project's existing test layout if test files are already present. Otherwise use:

```
tests/test_{module}.py
```

or alongside the source as `{module}_test.py`.

### 5. Generate the test file

- Use only the detected framework and libraries.
- Cover for each public function / method:
  - **Happy path** — normal input produces expected output
  - **Edge cases** — None, empty collections, boundary values
  - **Error cases** — exceptions raised
- Write descriptive test names that express intent clearly.
- Keep each test focused on a single behavior.
- Do not test private functions directly.

### 6. Report

- State the detected framework and mocking library used.
- List the generated test cases with a brief description of what each covers.
