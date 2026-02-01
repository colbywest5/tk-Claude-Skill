---
name: tk:build
description: Build something with structured workflow. /tk:[$cmd] light|medium|heavy <what to build>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
  - WebSearch
  - WebFetch
---

$import(commands/tk/_shared.md)

# TK v1.1.0 | /tk:build [mode]

Build what $MESSAGE describes using a structured 7-phase workflow.

## Core Principles
- **Ask clarifying questions**: Identify ambiguities BEFORE implementation
- **Understand before acting**: Read existing code patterns first
- **Read files identified by agents**: Build deep context before proceeding
- **Simple and elegant**: Prioritize readable, maintainable code

## Process

### Phase 1: Discovery
**Goal:** Understand what needs to be built

- Create todo list with all phases
- If unclear, ask: What problem? What should it do? Constraints?
- Summarize understanding and confirm with user

**LIGHT:** Accept $MESSAGE as-is, minimal questions
**MEDIUM:** 2-3 clarifying questions
**HEAVY:** Full requirements gathering

### Phase 2: Codebase Exploration
**Goal:** Understand relevant existing code and patterns

**LIGHT:** Quick scan of related files
**MEDIUM:** Read patterns from AGENTS.md, scan similar features
**HEAVY:** Launch 2-3 code-explorer SubAgents in parallel:
```
SubAgent Explorer 1: "Find features similar to [feature], trace implementation comprehensively. Return 5-10 key files to read."
SubAgent Explorer 2: "Map architecture and abstractions for [area]. Return key files."
SubAgent Explorer 3: "Analyze current implementation of [related feature]. Return key files."
```
After agents return: **READ ALL IDENTIFIED FILES** to build deep understanding.

### Phase 3: Clarifying Questions
**Goal:** Fill gaps and resolve ALL ambiguities before design

**CRITICAL: DO NOT SKIP THIS PHASE**

Review codebase findings + original request. Identify underspecified aspects:
- Edge cases
- Error handling
- Integration points
- Scope boundaries
- Backward compatibility
- Performance needs

**Present ALL questions in organized list. WAIT for answers before Phase 4.**

If user says "whatever you think is best" → provide recommendation, get explicit confirmation.

### Phase 4: Architecture Design
**Goal:** Design implementation approach

**LIGHT:** Quick mental plan, start building
**MEDIUM:** Document approach in .planning/TASKS.md before implementing
**HEAVY:** Launch 2-3 code-architect SubAgents with different focuses:
```
SubAgent Architect 1 (Minimal): "Smallest change, maximum reuse. Design for [feature]."
SubAgent Architect 2 (Clean): "Maintainability, elegant abstractions. Design for [feature]."
SubAgent Architect 3 (Pragmatic): "Balance speed + quality. Design for [feature]."
```

Present comparison with trade-offs. **Form opinion on best fit.** Ask user which approach they prefer.

### Phase 5: Implementation
**Goal:** Build the feature

**DO NOT START WITHOUT USER APPROVAL** (medium/heavy modes)

1. Update STATE.md activeTask
2. Create git checkpoint before starting
3. Read all relevant files from Phase 2
4. Implement following chosen architecture
5. Follow codebase conventions strictly
6. Test: `npm test`, `npm run typecheck`
7. Commit: `git commit -m "feat: $TASK_NAME"`

**HEAVY parallel execution:**
- Group tasks by dependencies
- SubAgent per task group + DOCS SubAgent
- DOCS documents in real-time: what, why, how, what changed

### Phase 6: Quality Review
**Goal:** Ensure code is correct, simple, DRY, elegant

**LIGHT:** Quick self-review
**MEDIUM:** Review against AGENTS.md patterns
**HEAVY:** Launch 3 code-reviewer SubAgents:
```
SubAgent Reviewer 1 (Quality): "Review for simplicity, DRY, elegance. Only report confidence ≥80."
SubAgent Reviewer 2 (Bugs): "Review for bugs, logic errors, edge cases. Only report confidence ≥80."
SubAgent Reviewer 3 (Conventions): "Review for project conventions, patterns. Only report confidence ≥80."
```

Consolidate findings. **Present to user:** fix now, fix later, or proceed as-is.

### Phase 7: Summary
**Goal:** Document what was accomplished

```bash
# Update STATE.md, HISTORY.md
# Capture patterns/gotchas learned → AGENTS.md
git add .planning/ AGENTS.md && git commit -m "docs: update after build"
```

Report:
- What was built
- Key decisions made
- Files modified
- Suggested next steps

## Escalation Triggers
- **LIGHT→MEDIUM:** 2+ failures, unexpected complexity, user confusion
- **MEDIUM→HEAVY:** 3+ failures, security/perf concerns, multiple interacting systems
