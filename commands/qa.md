---
name: tk:qa
description: QA testing with security analysis. /tk:[$cmd] [light]|medium|heavy <what to test>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - WebSearch
  - AskUserQuestion
---

# /tk:[$cmd] [mode] <message>

Test systematically. Find bugs AND security vulnerabilities before users do.

## Security Patterns to Check

| Pattern | Risk | Safe Alternative |
|---------|------|------------------|
| `child_process.exec()` | Command injection | Use `execFile()` with array args |
| `new Function()` | Code injection | Avoid dynamic code evaluation |
| `eval()` | Arbitrary code execution | Use `JSON.parse()` for data |
| `dangerouslySetInnerHTML` | XSS | Sanitize with DOMPurify |
| `document.write()` | XSS | Use `createElement()` + `appendChild()` |
| `.innerHTML =` | XSS | Use `textContent` or sanitize |
| `pickle` (Python) | Deserialization attack | Use JSON instead |
| `os.system()` | Command injection | Use `subprocess` with list args |
| GitHub Actions `${{ }}` in `run:` | Command injection | Use `env:` variables instead |

## Process

### 1. Pre-flight
```bash
mkdir -p .qa
npm test --help 2>/dev/null && echo "✓ npm test available"
```

### 2. Mode Execution

**LIGHT (~5 min smoke test + security scan):**
```bash
# Functional
timeout 30 npm run dev & sleep 10 && curl -s localhost:3000 && kill $!
npm test && npm run typecheck && npm run build

# Quick Security Scan
echo "=== SECURITY SCAN ==="
grep -rn "eval(" --include="*.js" --include="*.ts" | grep -v node_modules
grep -rn "innerHTML\s*=" --include="*.js" --include="*.ts" | grep -v node_modules
grep -rn "dangerouslySetInnerHTML" --include="*.tsx" --include="*.jsx" | grep -v node_modules
grep -rn "child_process" --include="*.js" --include="*.ts" | grep -v node_modules
npm audit --audit-level=critical
```
Report pass/fail. Flag any security patterns found.

**MEDIUM (~15 min full coverage + security checklist):**
Everything in light, plus:

**Functional:**
- `npm test -- --coverage`
- Test all API endpoints
- Edge cases: empty strings, long strings, special chars, null, unicode

**Security Checklist:**
```bash
echo "=== FULL SECURITY AUDIT ==="

# JavaScript/TypeScript
grep -rn "eval(" --include="*.js" --include="*.ts" | grep -v node_modules
grep -rn "new Function" --include="*.js" --include="*.ts" | grep -v node_modules
grep -rn "innerHTML" --include="*.js" --include="*.ts" --include="*.tsx" | grep -v node_modules
grep -rn "dangerouslySetInnerHTML" --include="*.tsx" --include="*.jsx" | grep -v node_modules
grep -rn "document.write" --include="*.js" --include="*.ts" | grep -v node_modules
grep -rn "child_process" --include="*.js" --include="*.ts" | grep -v node_modules
grep -rn "exec(" --include="*.js" --include="*.ts" | grep -v node_modules

# Python
grep -rn "pickle" --include="*.py"
grep -rn "os.system" --include="*.py"
grep -rn "eval(" --include="*.py"
grep -rn "exec(" --include="*.py"

# GitHub Actions
find .github/workflows -name "*.yml" -o -name "*.yaml" | xargs grep -l '\${{.*}}' | xargs grep -n 'run:'

# Secrets in code
grep -rn "password\s*=" --include="*.js" --include="*.ts" --include="*.py" | grep -v node_modules
grep -rn "api_key\s*=" --include="*.js" --include="*.ts" --include="*.py" | grep -v node_modules
grep -rn "secret" --include="*.js" --include="*.ts" --include="*.py" | grep -v node_modules

# Dependency audit
npm audit
```

Create .planning/ISSUES.md entries for findings with severity ratings.

**HEAVY (~30 min, 6 parallel specialists):**
```
Spawn simultaneously:

SubAgent 1 (Security Specialist):
  "You are a security expert. Audit this codebase for vulnerabilities.
   
   Check for:
   - Command injection (exec, os.system, child_process)
   - Code injection (eval, new Function)
   - XSS (innerHTML, dangerouslySetInnerHTML, document.write)
   - SQL/NoSQL injection in queries
   - Deserialization attacks (pickle)
   - Hardcoded secrets/credentials
   - GitHub Actions workflow injection
   - CSRF token validation
   - Authentication bypass possibilities
   - Authorization gaps (can user A access user B's data?)
   - npm audit vulnerabilities
   
   For each finding:
   - Severity: CRITICAL/HIGH/MEDIUM/LOW
   - File:line
   - Attack vector
   - Safe alternative
   
   Only report confidence ≥80."

SubAgent 2 (Edge Case Tester):
  "Try to break the application with unusual inputs:
   - Empty strings, 10KB strings
   - Null bytes, special characters
   - Unicode edge cases (RTL, zero-width, emoji)
   - Negative numbers, floats where integers expected
   - Future dates (year 3000), past dates (year 1900)
   - Rapid repeated submissions
   - Concurrent conflicting updates"

SubAgent 3 (Performance Tester):
  "Find bottlenecks:
   - Slow endpoints (>500ms)
   - N+1 database queries
   - Memory leaks
   - Large bundle size
   - Missing indexes"

SubAgent 4 (Accessibility Tester):
  "Check a11y compliance:
   - Tab navigation
   - Focus indicators
   - ARIA labels
   - Alt text
   - Color contrast (4.5:1)
   - Keyboard-only operation"

SubAgent 5 (Chaos/Resilience Tester):
  "Test failure handling:
   - Database connection fails
   - External API timeout/500
   - Session expires mid-action
   - Malformed JSON payload
   - Network loss mid-upload"

SubAgent DOCS:
  "Compile comprehensive report:
   - .qa/full-report.md (all findings by severity)
   - .planning/ISSUES.md (update with issues)
   - AGENTS.md (add security gotchas discovered)"
```

### 3. Completion

Merge findings into .qa/full-report.md:
- Executive summary
- **CRITICAL** issues (blocks release)
- **HIGH** issues (fix before release)
- **MEDIUM** issues (fix soon)
- **LOW** issues (nice to have)
- Security-specific findings section
- Recommendations

```bash
# Update STATE.md, HISTORY.md
git add .qa/ .planning/ AGENTS.md
git commit -m "docs: QA report - [X] issues found"
```

Report: Tests run, issues by severity, security findings, deploy readiness

**Offer:**
- "Fix critical issues now?" → run `/tk:debug` for each
- "Create GitHub issues?"
- "Generate security report for stakeholders?"

## GitHub Actions Security

When reviewing `.github/workflows/*.yml`:

**UNSAFE (command injection risk):**
```yaml
run: echo "${{ github.event.issue.title }}"
```

**SAFE (use env variables):**
```yaml
env:
  TITLE: ${{ github.event.issue.title }}
run: echo "$TITLE"
```

**Risky inputs to flag:**
- `github.event.issue.title/body`
- `github.event.pull_request.title/body`
- `github.event.comment.body`
- `github.event.commits.*.message`
- `github.head_ref`
