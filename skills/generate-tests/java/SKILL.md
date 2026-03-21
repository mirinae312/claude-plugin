---
description: Generate unit tests for a Java source file using the test framework and libraries already declared in the project.
---

## Goal

Generate unit tests for the target `.java` file or method. Always use the test framework and libraries already declared in the project. Never introduce a new test dependency without asking the user first.

## Steps

### 1. Identify the target

- If a specific file or method was mentioned, use that.
- Otherwise, use the most recently edited `.java` file.

### 2. Detect the project's test stack

Read `pom.xml`, `build.gradle`, or `build.gradle.kts` and identify the framework in use.

- Frameworks: JUnit 5 (`junit-jupiter`), JUnit 4 (`junit:junit`), TestNG (`testng`), Spock (`spock-core`)
- Mocking: Mockito (`mockito-core`), MockK (`mockk`), EasyMock (`easymock`), PowerMock (`powermock-*`)

If no test dependencies are found, ask the user which framework to use before proceeding.

### 3. Read the target source file

- Understand the structure: classes, methods, and their signatures.
- Identify external dependencies or side effects that need to be mocked or stubbed.

### 4. Determine the test file location

Follow the project's existing test layout if test files are already present. Otherwise use:

```
src/test/java/…/{ClassName}Test.java
```

### 5. Generate the test file

- Use only the detected framework and libraries.
- Cover for each public method:
  - **Happy path** — normal input produces expected output
  - **Edge cases** — null, empty collections, boundary values
  - **Error cases** — exceptions thrown
- Write descriptive test names that express intent clearly.
- Keep each test focused on a single behavior.
- Do not test private methods directly.

### 6. Report

- State the detected framework and mocking library used.
- List the generated test cases with a brief description of what each covers.
