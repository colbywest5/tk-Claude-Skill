---
name: tk:resume
description: Resume interrupted work. No mode needed.
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
---

# /tk:resume

Resume work from .planning/STATE.md.

## Process

### 1. Check State
```bash
[ ! -f ".planning/STATE.md" ] && echo "No active work. Start with /tk:build, etc." && exit 0
cat .planning/STATE.md
```
Extract: activeCommand, activeTask, mode, progress, last checkpoint

### 2. Verify Context
```bash
[ -f "AGENTS.md" ] && echo "✓ AGENTS.md"
git status --short
```
If damaged: offer restore from checkpoint or /tk:map light

### 3. Show Status
```
RESUMING: /tk:build medium
Task: Implement user authentication
Progress:
  ✓ Task 1: Setup schema
  → Task 3: Add middleware  <-- here
  ○ Task 4: Write tests
Last checkpoint: def456 (2h ago)

Resume?
```

### 4. Resume
- Read original command's .md file
- Skip to current task
- Continue with same mode
- Log resume to HISTORY.md
