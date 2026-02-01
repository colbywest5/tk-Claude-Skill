---
name: tk:opinion
description: Get an honest audit and opinion of your project
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Task
---

$import(commands/tk/_shared.md)

# TK v1.1.0 | /tk:opinion [mode]

Audit the project and give honest, actionable opinions.

## Load Shared

```md
$import(commands/tk/_shared.md)
```

## Phase 1: Discovery Scan

Scan the project to understand what exists:

```
SCAN:
├── README.md / docs/ → Project vision, goals, MVP definition
├── package.json / requirements.txt / go.mod → Dependencies, scripts
├── src/ / lib/ / app/ → Code structure, patterns
├── tests/ / __tests__ / spec/ → Test coverage
├── .github/ / CI config → Automation
├── AGENTS.md / .planning/ → Existing project context
├── TODO.md / ROADMAP.md / MVP.md → Planned work
└── Git history → Activity, contributors, velocity
```

## Phase 2: Ask Questions

Before giving opinions, ask 3-5 questions to understand context:

```
QUESTION TYPES:
- What's the goal? (MVP, production, learning project, side project?)
- Who's the user? (You, team, public, enterprise?)
- What's the timeline? (Shipping soon, long-term, no deadline?)
- What's the constraint? (Time, money, skills, scope?)
- What matters most? (Speed, quality, features, learning?)
```

WAIT for answers before proceeding.

## Phase 3: Audit Categories

After answers, evaluate each area:

### 3.1 Architecture
```
CHECK:
- Is the structure conventional for this stack?
- Are concerns separated properly?
- Is there unnecessary complexity?
- Are there obvious anti-patterns?
- Would a new dev understand it in 10 min?

OPINION: [honest assessment]
```

### 3.2 Code Quality
```
CHECK:
- Consistency (naming, formatting, style)
- Dead code / unused files
- Duplicate logic
- Error handling
- Type safety (if applicable)

OPINION: [honest assessment]
```

### 3.3 Dependencies
```
CHECK:
- Are deps necessary or bloated?
- Are there security vulnerabilities? (npm audit / pip audit)
- Outdated packages?
- Conflicting or redundant deps?

OPINION: [honest assessment]
```

### 3.4 Testing
```
CHECK:
- Does test coverage exist?
- Are tests meaningful or just coverage theater?
- Are critical paths tested?
- Can tests run in CI?

OPINION: [honest assessment]
```

### 3.5 Documentation
```
CHECK:
- Is README useful or boilerplate?
- Can someone new get started?
- Are decisions documented?
- Is there API documentation?

OPINION: [honest assessment]
```

### 3.6 DevOps / CI
```
CHECK:
- Is there CI/CD?
- Are builds reproducible?
- Is deployment documented?
- Are secrets handled properly?

OPINION: [honest assessment]
```

### 3.7 MVP Progress (if MVP.md / ROADMAP.md exists)
```
CHECK:
- What % of MVP is complete?
- What's blocking MVP?
- What's been built that's NOT in MVP? (scope creep)
- What's the critical path to launch?

OPINION: [honest assessment with estimate]
```

## Phase 4: The Opinion

Deliver honest, direct feedback:

```
FORMAT:

## What's Working
[2-3 things that are genuinely good - be specific]

## What's Not Working
[2-3 things that need attention - be direct, not mean]

## What You Should Stop Doing
[Things wasting time or adding complexity without value]

## What You Should Start Doing
[High-impact changes that would help most]

## If I Had to Ship This Tomorrow
[What's the minimum to make it work?]

## If I Had a Month
[What would make the biggest difference?]

## MVP Reality Check (if applicable)
- Current state: [X]% complete
- Blocking issues: [list]
- Scope creep detected: [yes/no, examples]
- Realistic timeline: [estimate]

## Hot Takes
[1-2 spicy but honest opinions - things the dev might not want to hear but needs to]
```

## Modes

### Light Mode
- Quick scan of structure + README
- 2 questions max
- 3-minute opinion
- Focus: Is this on track or not?

### Medium Mode
- Full scan
- 3-5 questions
- Detailed audit of each category
- Focus: What should change?

### Heavy Mode
- Deep analysis with SubAgents
- Compare to similar projects
- Research best practices for stack
- Focus: How to make this excellent?

## Heavy Mode SubAgents

```
SPAWN IN PARALLEL:
├── architecture-auditor → Structure, patterns, complexity
├── code-auditor → Quality, consistency, dead code
├── deps-auditor → Dependencies, security, bloat
├── dx-auditor → DevX, onboarding, documentation
└── DOCS → Document findings in .planning/AUDIT.md
```

## Output

After opinion, offer:

```
NEXT STEPS:
1. /tk:clean - Fix the easy stuff (dead code, formatting)
2. /tk:doc - Improve documentation
3. /tk:qa - Run full test + security scan
4. /tk:build [specific suggestion] - Tackle highest priority

Want me to run any of these?
```

## Rules

1. BE HONEST - Don't sugarcoat. Be kind but direct.
2. BE SPECIFIC - "Code is messy" → "The auth module mixes concerns"
3. BE ACTIONABLE - Every criticism comes with a solution
4. RESPECT CONTEXT - Side project ≠ enterprise expectations
5. NO GATEKEEPING - Don't shame for not knowing things
6. PRIORITIES MATTER - Focus on what helps most, not what's "proper"
