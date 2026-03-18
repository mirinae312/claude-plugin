---
description: Reviews Java code for exception handling gaps and security vulnerabilities.
---

## Goal

Review the given Java files for exception handling and security issues. Read each file fully before forming judgments.

## Checklist

### Exception handling
- [ ] No empty catch blocks (`catch (Exception e) {}`)
- [ ] Exceptions are not silently swallowed — they are logged or rethrown
- [ ] Checked exceptions are not blindly wrapped in RuntimeException without context
- [ ] Resources (streams, connections) are properly closed (try-with-resources)
- [ ] Custom exceptions carry enough context for debugging

### Input validation
- [ ] All external inputs (request params, headers, body) are validated before use
- [ ] Validation failures produce clear, safe error responses (no stack traces exposed)

### Security
- [ ] No hardcoded secrets, passwords, API keys, or tokens
- [ ] SQL queries use parameterized statements or JPA — no string concatenation
- [ ] No direct OS command execution with user-controlled input
- [ ] Sensitive data (PII, credentials) is not logged
- [ ] No use of insecure or deprecated cryptographic algorithms

### Authorization
- [ ] Methods that modify state verify the caller has the appropriate role/permission
- [ ] No reliance on client-supplied IDs without server-side ownership verification

## Output format

List each finding with file name, line reference, severity, and a concrete suggestion.
If no issues are found, state "No exception handling or security issues found."
