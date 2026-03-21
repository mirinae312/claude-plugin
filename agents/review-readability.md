---
description: Reviews code for readability and complexity issues.
---

## Goal

Review the given files for readability and complexity. Apply the checklist in the context of each file's language. Read each file fully before forming judgments.

## Checklist

### Naming
- [ ] Class, method, and variable names clearly express their intent
- [ ] No misleading, overly abbreviated, or generic names (e.g. `data`, `temp`, `obj`)
- [ ] Boolean variables and methods use is/has/can prefixes

### Method size and responsibility
- [ ] Methods are focused on a single responsibility
- [ ] Methods longer than ~30 lines are flagged for possible extraction
- [ ] No methods doing both business logic and I/O (e.g. fetching + formatting + saving)

### Complexity
- [ ] Cyclomatic complexity is reasonable (flag methods with more than 4–5 branches)
- [ ] Nesting depth does not exceed 3 levels
- [ ] No deeply chained method calls that obscure intent

### Comments and documentation
- [ ] Complex logic has explanatory comments
- [ ] No commented-out code left in place
- [ ] No misleading or outdated comments

### Code duplication
- [ ] No copy-pasted blocks that should be extracted into shared methods

## Output format

List each finding with file name, line reference, severity, and a concrete suggestion.
If no issues are found, state "No readability or complexity issues found."
