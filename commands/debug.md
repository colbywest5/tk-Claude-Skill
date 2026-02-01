---
name: tk:debug
description: Systematic debugging. /tk:[$cmd] light|medium|heavy <problem>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - WebSearch
  - AskUserQuestion
---

$import(commands/tk/_shared.md)

# TK v1.1.0 | /tk:debug [mode]

## STEP 0: LOAD RULES (SILENT)

Before ANY action: silently read .tk/RULES.md and follow ALL rules constantly.
Do not display rules. Just follow them.

Debug systematically. Break repair loops.

## Critical Rules
1. **NEVER retry what's been tried** — check .debug/attempts.md
2. **Revert before experimenting** — don't compound errors
3. **One change at a time** — isolate variables
4. **Capture every gotcha** — update AGENTS.md when fixed

## Process

### 1. Pre-flight
```bash
mkdir -p .debug
[ -f ".planning/ISSUES.md" ] && grep -A5 "## Open" .planning/ISSUES.md
[ -f ".debug/attempts.md" ] && tail -20 .debug/attempts.md
```

### 2. Capture Error
```bash
$FAILING_COMMAND 2>&1 | tee .debug/error.txt
grep -i "[error keyword]" AGENTS.md  # Check if known issue
```

### 3. Mode Execution

**LIGHT (2 attempts max):**
1. Read error, go to file:line, make ONE fix, test
2. Log attempt: `| 1 | [what] | [result] | [time] |` → .debug/attempts.md
3. If still fails after 2 → escalate to medium

**MEDIUM (systematic):**
1. Form 3 hypotheses with evidence
2. For each (max 3 attempts each):
   - `git stash push -m "debug-checkpoint"`
   - Make ONE change to test hypothesis
   - Test, log result
   - If failed: `git stash pop` (revert)
   - Move to next hypothesis if 3 attempts fail
3. If all hypotheses fail → escalate to heavy

**HEAVY (parallel investigation):**
```
Phase 1 - Investigate:
SubAgent 1-3: Investigate hypotheses 1-3 (DO NOT FIX, report findings)
SubAgent 4: Fresh eyes investigation (ignore hypotheses)
SubAgent DOCS: Document session in real-time

Phase 2 - Fix (for confirmed causes):
SubAgent A: Conventional fix
SubAgent B: Restructure approach
SubAgent C: Simplify approach
SubAgent DOCS: Document all attempts

Phase 3 - Nuclear options (if needed):
- rm -rf node_modules && npm install
- git bisect to find breaking commit
- Fresh clone test
- Revert to known good
```

### 4. Completion (when fixed)

```bash
# Verify
$FAILING_COMMAND && npm test && npm run typecheck

# Capture gotcha
cat >> AGENTS.md << EOF
### Gotcha: [issue] ($(date +%Y-%m-%d))
**Symptom:** [what you see]
**Root cause:** [why]
**Fix:** [solution]
EOF

# Log to ISSUES.md as resolved
# Update STATE.md, HISTORY.md
git add AGENTS.md .planning/ && git commit -m "docs: add gotcha for [issue]"
```

Report: Issue, root cause, fix, duration, attempts, "gotcha documented"
