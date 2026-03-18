---
description: Reviews Java code for common backend performance pitfalls.
---

## Goal

Review the given Java files for performance issues common in backend applications. Read each file fully before forming judgments.

## Checklist

### Database access
- [ ] No N+1 query patterns (fetching a list, then querying inside a loop)
- [ ] Bulk operations use batch insert/update rather than individual calls in a loop
- [ ] Large result sets use pagination rather than fetching everything at once
- [ ] Lazy vs. eager loading choices are appropriate for the use case

### I/O and external calls
- [ ] No blocking I/O calls inside loops
- [ ] External HTTP calls inside a loop are flagged — consider batching or parallelism
- [ ] File or stream operations are buffered where appropriate

### Memory
- [ ] No unnecessary object creation inside tight loops
- [ ] Large collections are not held in memory longer than needed
- [ ] String concatenation in loops uses `StringBuilder`, not `+`

### Caching
- [ ] Repeated expensive computations or queries that could benefit from caching are flagged

### Concurrency
- [ ] Shared mutable state is properly synchronized or uses thread-safe data structures
- [ ] No unnecessary synchronization on hot paths

## Output format

List each finding with file name, line reference, severity, and a concrete suggestion.
If no issues are found, state "No performance issues found."
