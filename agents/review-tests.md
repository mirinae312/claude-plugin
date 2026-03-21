---
description: Reviews whether the modified files have adequate test coverage.
---

## Goal

Check whether the given files are adequately covered by tests. Look for corresponding test files and assess coverage quality. Apply conventions appropriate to each file's language.

## Steps

### 1. Locate test files

For each source file, find its corresponding test file using the convention of the detected language. Examples:
- Java: `src/main/java/.../Foo.java` → `src/test/java/.../FooTest.java`
- Python: `foo.py` → `test_foo.py` or `foo_test.py`
- TypeScript/JavaScript: `foo.ts` → `foo.test.ts` or `foo.spec.ts`
- Go: `foo.go` → `foo_test.go`

If the language is not listed above, infer the test file convention from the project structure.

### 2. Checklist

#### Existence
- [ ] A test file exists for every non-trivial class (skip pure DTOs, constants, config)
- [ ] Test file covers all public methods

#### Quality
- [ ] Each test method targets a single behavior
- [ ] Happy path is covered
- [ ] Edge cases are covered (null, empty, boundary values)
- [ ] Error/exception paths are covered
- [ ] Tests use meaningful assertions, not just `assertNotNull`
- [ ] No business logic in test setup that obscures the intent of the test
- [ ] Mocks are used appropriately — not mocking what you're actually testing

#### Completeness
- [ ] New or modified methods have corresponding new or updated tests
- [ ] Deleted methods have their tests removed

## Output format

For each source file:
- State whether a test file exists
- List any missing test cases with a brief description of what should be tested
- Flag any low-quality tests with a suggestion

If coverage is adequate, state "Test coverage is sufficient."
