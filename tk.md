---
name: tk
description: "Universal work command. Usage: /tk:task mode [message]"
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
  - WebSearch
  - WebFetch
---

# /tk:task mode [message]

**Tasks:** map, build, design, debug, qa, review, clean, doc, deploy, init, resume, learn, status, help
**Modes:** light (fast), medium (balanced), heavy (comprehensive + parallel SubAgents)

## Parse & Route

1. Extract TASK (first word), MODE (second), MESSAGE (rest)
2. If TASK=help → show help below
3. If TASK=status → run status (no mode needed)
4. Otherwise → Read `commands/_shared.md` for core behaviors, then read `commands/{TASK}.md`

## Help Reference

```
/tk:task mode [message]

TASKS:
  map      Map project, create context (RUN FIRST)
  build    Build/create something
  design   Create distinctive frontend interfaces
  debug    Fix a problem  
  qa       Test something
  review   Review code
  clean    Cleanup codebase
  doc      Generate documentation
  deploy   Deploy to production
  init     Initialize new project
  resume   Resume previous work
  learn    Capture a learning
  status   Show project status
  help     This help

MODES:
  light    Fast, minimal interaction
  medium   Balanced, key decisions
  heavy    Comprehensive, parallel SubAgents + DOCS

EXAMPLES:
  /tk:map heavy This is a Next.js e-commerce app
  /tk:build medium Add user authentication
  /tk:design heavy Landing page for a premium fitness app
  /tk:debug light API returns 500 on large requests
  /tk:qa heavy Test everything before launch
```
