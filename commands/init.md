---
name: tk:init
description: Initialize project. /tk:[$cmd] light|medium|heavy <description>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
  - WebSearch
---

$import(commands/tk/_shared.md)

# TK v1.1.0 | /tk:init [mode]

## STEP 0: LOAD RULES (MANDATORY)

**Before ANYTHING else, load and display rules:**

1. Read .tk/RULES.md (or ~/.claude/tk-rules.md)
2. Display: "RULES LOADED: [count] rules"
3. List each rule
4. Proceed only after rules are confirmed loaded

See _shared.md for full rules loading procedure.

Start a new project from scratch.

## Process

### 1. Check
```bash
[ $(ls -A | grep -v ".git" | wc -l) -gt 0 ] && echo "⚠️ Directory not empty"
```

### 2. Gather Info
Ask: "What are you building?"
**MEDIUM/HEAVY:** Follow up: Primary function? Web/API/CLI/library? Tech preferences?

### 3. Select Stack
**LIGHT/MEDIUM:** Offer options (Next.js, Express, FastAPI, CLI)
**HEAVY:** Research best framework for use case first

### 4. Mode Execution

**LIGHT (scaffold):**
```bash
# Based on selection
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir
# OR
npm init -y && npm install typescript express @types/express && mkdir -p src
# OR
python -m venv venv && pip install fastapi uvicorn

git init
echo "node_modules/\n.env\nvenv/" > .gitignore
git add -A && git commit -m "Initial setup"
```

**MEDIUM (scaffold + tooling):**
- Everything in light, plus:
- Comprehensive .gitignore
- .env.example with documented vars
- README.md with setup instructions
- Basic AGENTS.md
- Testing setup (vitest)
- Commit: `chore: add tooling and configuration`

**HEAVY (full setup):**
```
Research (parallel):
SubAgent 1: Best framework for [description]
SubAgent 2: Best project structure
SubAgent 3: Essential tooling (lint, test, CI)
SubAgent DOCS: Create initial docs structure

Then: Everything in medium, plus:
- GitHub Actions CI (.github/workflows/ci.yml)
- Dockerfile + .dockerignore
- Full .planning/ suite (STATE.md, HISTORY.md, etc.)
- Run /tk:map heavy logic for context
```

### 5. Completion
```bash
mkdir -p .planning
# Create STATE.md, HISTORY.md
git commit -m "feat: initial project setup"
```

Report: Stack created, files generated, next steps (copy .env, npm install, npm run dev)
