---
name: tk:help
description: Show command reference
allowed-tools:
  - Bash
---

# /tk:help

```
╔═══════════════════════════════════════════════════════════════╗
║  /tk:task mode [message]                                  ║
╚═══════════════════════════════════════════════════════════════╝

CONTEXT (run first!)
  /tk:map       Map project, create AGENTS.md and .planning/

BUILD
  /tk:build     Build/create something
  /tk:design    Create distinctive frontend interfaces
  /tk:init      Initialize new project

QUALITY
  /tk:qa        Run tests + security scan
  /tk:review    Code review
  /tk:clean     Cleanup codebase

TROUBLESHOOTING
  /tk:debug     Fix problems systematically

UTILITIES
  /tk:doc       Generate documentation
  /tk:deploy    Deploy to production
  /tk:status    Project health (no mode)
  /tk:resume    Resume interrupted work
  /tk:learn     Capture gotcha/pattern/decision
  /tk:opinion   Get honest project audit + opinions
  /tk:rules     Set global rules for all agents
  /tk:tokens    Token usage estimates
  /tk:help      This help

MODES
  light     Fast, minimal interaction
  medium    Balanced, key decisions
  heavy     Comprehensive, parallel SubAgents + DOCS

HEAVY MODE SUBAGENTS
  map:    6 mappers + DOCS
  build:  3 explorers + 3 architects + 3 reviewers + DOCS
  design: 3 research + 4 specialists + DOCS
  debug:  4 investigators + 3 fixers + DOCS
  qa:     6 specialists (incl. Security) + DOCS
  review: 4 reviewers + DOCS
  clean:  4 cleaners + DOCS
  deploy: 4 pre-flight + 4 post-deploy + DOCS

KEY FILES
  AGENTS.md              Master project knowledge
  .planning/STATE.md     Current work state
  .planning/HISTORY.md   Work log
  .planning/ISSUES.md    Known issues
  .planning/PATTERNS.md  Discovered patterns

EXAMPLES
  /tk:map heavy This is a Next.js e-commerce app
  /tk:build medium Add user authentication
  /tk:debug light API returns 500 errors
  /tk:qa heavy Test everything before launch
```
