---
description: Generate unit tests for a source file using the test framework and libraries already declared in the project. Supports Java, Python, JavaScript, TypeScript, and Bash.
--- 

## Goal

Generate unit tests for the target source file or function. Always use the test framework and libraries that are already declared in the project. Never introduce a new test dependency without asking the user first.

## Steps

### 1. Identify the target

- If a specific file or function was mentioned, use that.
- Otherwise, use the most recently edited source file.
- Determine the language from the file extension.

### 2. Detect the project's test stack

Read the relevant project config files based on the detected language and identify the framework in use.

**Java** (`.java`)
- Config files: `pom.xml`, `build.gradle`, `build.gradle.kts`
- Frameworks: JUnit 5 (`junit-jupiter`), JUnit 4 (`junit:junit`), TestNG (`testng`), Spock (`spock-core`)
- Mocking: Mockito (`mockito-core`), MockK (`mockk`), EasyMock (`easymock`), PowerMock (`powermock-*`)

**Python** (`.py`)
- Config files: `pyproject.toml`, `setup.cfg`, `pytest.ini`, `tox.ini`, `requirements*.txt`
- Frameworks: pytest (`pytest`), unittest (stdlib — always available), nose2 (`nose2`)
- Mocking: `unittest.mock` (stdlib), `pytest-mock` (`pytest-mock`)

**JavaScript / TypeScript** (`.js`, `.ts`, `.jsx`, `.tsx`)
- Config files: `package.json`, `jest.config.*`, `vitest.config.*`, `.mocharc.*`
- Frameworks: Jest (`jest`), Vitest (`vitest`), Mocha (`mocha`) + Chai (`chai`), Jasmine (`jasmine`)
- Mocking: Jest built-in, Sinon (`sinon`), `@vitest/spy`

**Bash** (`.sh`, `.bash`)
- Config files: look for `bats` in the repo (`*.bats` files, `.bats/` directory, or `bats` in `package.json`)
- Framework: BATS (`bats-core`)
- If BATS is not present, note it and ask the user whether to proceed with BATS or skip.

If no test dependencies are found for the language, ask the user which framework to use before proceeding.

### 3. Read the target source file

- Understand the structure: classes, functions, and their signatures.
- Identify external dependencies or side effects that need to be mocked or stubbed.

### 4. Determine the test file location

Follow the project's existing test layout if test files are already present. Otherwise use the convention below.

| Language | Test file location |
|----------|--------------------|
| Java | `src/test/java/…/{ClassName}Test.java` |
| Python | `tests/test_{module}.py` or alongside source as `{module}_test.py` |
| JS/TS | `{source}.test.{ext}` alongside source, or `__tests__/{source}.test.{ext}` |
| Bash | `test/{script}.bats` or `tests/{script}.bats` |

### 5. Generate the test file

- Use only the detected framework and libraries.
- Cover for each public function / method:
  - **Happy path** — normal input produces expected output
  - **Edge cases** — null/None/undefined, empty collections, boundary values
  - **Error cases** — exceptions, non-zero exit codes, rejected promises
- Write descriptive test names that express intent clearly.
- Keep each test focused on a single behavior.
- Do not test private/internal functions directly.

### 6. Report

- State the detected language, framework, and mocking library used.
- List the generated test cases with a brief description of what each covers.
