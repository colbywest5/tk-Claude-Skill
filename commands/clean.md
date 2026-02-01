---
name: tk:clean
description: Cleanup codebase. /tk:[$cmd] [light]|medium|heavy
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
---

# /tk:[$cmd] [mode]

Clean the codebase.

## Process

### 1. Pre-flight
```bash
mkdir -p .cleanup
git stash push -m "pre-cleanup-$(date +%s)"  # Checkpoint
```

### 2. Mode Execution

**LIGHT (quick wins):**
```bash
# Console.logs
grep -rn "console.log" --include="*.ts" --include="*.tsx" | grep -v node_modules | grep -v "\.test\." > .cleanup/console-logs.txt
# After confirmation, remove them
sed -i '/console\.log/d' [files]

# Unused imports via lint
npm run lint -- --fix

# Count TODOs
grep -rn "TODO\|FIXME" --include="*.ts" | grep -v node_modules > .cleanup/todos.txt

git commit -m "chore: remove console.logs, fix imports"
```

**MEDIUM (full cleanup):**
- Everything in light, plus:
- **Dead code:** `npx ts-prune` for unused exports
- **Dependencies:** `npx depcheck` for unused deps, `npm outdated`, `npm audit`
- **Large files:** Files >500 lines
- Offer to fix each category, atomic commits per fix type

**HEAVY (4 parallel cleaners):**
```
SubAgent 1 (Dead Code): Unused exports, unreachable code, commented-out code, unused variables
SubAgent 2 (Dependencies): Remove unused, update outdated, fix vulns, check duplicates
SubAgent 3 (Refactoring): Extract duplicates, split long functions, flatten nesting, align with PATTERNS.md
SubAgent 4 (Organization): Organize imports, fix naming, create index files, fix circular deps
SubAgent DOCS: Document all changes in .cleanup/report.md, update CODEBASE.md
```

### 3. Verification
```bash
npm run typecheck && npm test && npm run build || (echo "Cleanup broke something - rolling back" && git stash pop)
```

### 4. Completion
```bash
# Update CODEBASE.md with removed files
# Update STATE.md, HISTORY.md
git commit -m "chore: cleanup codebase"
```

Report: Items removed (console.logs, exports, deps), items updated (packages, vulns), items refactored
