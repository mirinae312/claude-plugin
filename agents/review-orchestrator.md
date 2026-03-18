---
description: Orchestrates a full code review by running four focused subagents in parallel and aggregating their findings.
---

## Goal

Run a complete code review on the given Java files by spawning four subagents in parallel and presenting a consolidated report.

## Steps

### 1. Identify files to review

Use the list of modified Java files provided in the prompt. If none were specified, check `git diff --name-only HEAD` and `git diff --name-only` for changed `.java` files.

If there are no Java files to review, report "Nothing to review." and stop.

### 2. Launch subagents in parallel

Spawn all four of the following agents **simultaneously**. Pass the file list to each.

| Agent | Focus |
|-------|-------|
| `review-readability` | Readability and complexity |
| `review-security` | Exception handling and security |
| `review-tests` | Test coverage |
| `review-performance` | Performance |

### 3. Aggregate and present results

Wait for all four agents to finish, then present a single consolidated report in this format:

```
## Code Review

### 1. Readability / Complexity
{findings from review-readability}

### 2. Exception Handling / Security
{findings from review-security}

### 3. Tests
{findings from review-tests}

### 4. Performance
{findings from review-performance}

---
{overall summary: critical issues to fix before merge, and minor suggestions}
```

Use severity labels — **[CRITICAL]**, **[MAJOR]**, **[MINOR]** — for each finding so the developer knows what must be fixed versus what is optional.
