---
name: tk:review
description: Code review. /tk:[$cmd] light|medium|heavy
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
---

# /tk:[$cmd] [mode]

Review code changes like a senior engineer.

## Process

### 1. Get Scope
```bash
mkdir -p .review
git diff > .review/changes.diff
git diff --name-only > .review/changed-files.txt
FILES_COUNT=$(wc -l < .review/changed-files.txt)
```
If nothing staged, ask: uncommitted changes? branch vs main? specific files?

### 2. Load Context
```bash
[ -f ".planning/PATTERNS.md" ] && cat .planning/PATTERNS.md
[ -f "AGENTS.md" ] && grep -A50 "## Conventions" AGENTS.md
```

### 3. Mode Execution

**LIGHT (quick scan):**
```bash
for file in $(cat .review/changed-files.txt); do
    grep -n "console.log\|TODO\|FIXME\|password\|secret\|any" "$file"
done
```
Check: obvious bugs, typos, missing error handling, hardcoded values, security flags

**MEDIUM (thorough):**
For each file, check all categories:
- **Correctness:** Logic errors, off-by-one, null handling, edge cases, race conditions
- **Security:** Injection, XSS, auth checks, secrets exposure, input validation
- **Performance:** N+1 queries, unnecessary loops, memory leaks, blocking ops
- **Maintainability:** Naming, types, duplication, complexity, comments
- **Patterns:** Follows project patterns from PATTERNS.md

Create .review/report.md with issues by severity (critical/warning/suggestion)

**HEAVY (4 parallel reviewers):**
```
SubAgent 1 (Correctness): Logic, null handling, edge cases, race conditions
SubAgent 2 (Security): Injection, XSS, CSRF, auth bypass, secrets, input validation
SubAgent 3 (Performance): N+1, re-renders, memoization, bundle size, memory leaks
SubAgent 4 (Maintainability): Naming, types, duplication, complexity, pattern violations
SubAgent DOCS: Merge into .review/final-report.md, update PATTERNS.md with good/anti-patterns
```

### 4. Completion
```bash
# Create final verdict: APPROVED or CHANGES REQUESTED
# Update PATTERNS.md if new patterns found
# Update STATE.md, HISTORY.md
```

Report: Files reviewed, verdict, issues by severity, positive observations

Offer: "Auto-fix safe issues?" or "Show fixes?"
