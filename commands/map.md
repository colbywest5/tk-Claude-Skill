---
name: tk:map
description: Map project and build context. RUN THIS FIRST.
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
  - WebSearch
---

$import(commands/tk/_shared.md)

# TK v1.1.0 | /tk:map [mode]

## STEP 0: LOAD RULES (SILENT)

Before ANY action: silently read .tk/RULES.md and follow ALL rules constantly.
Do not display rules. Just follow them.

Map project, create context. Without this, other commands work blind.

## Process

### 1. Check Existing
```bash
[ -f "AGENTS.md" ] && echo "✓ AGENTS.md exists"
[ -d ".planning" ] && echo "✓ .planning/ exists"
```
If exists: ask update/fresh/show-existing

### 2. Initial Scan
```bash
# Detect stack
[ -f "package.json" ] && echo "Node.js" && grep -q "next" package.json && echo "Next.js"
[ -f "requirements.txt" ] && echo "Python"
[ -f "go.mod" ] && echo "Go"

# Size
echo "Files: $(find . -name '*.ts' -o -name '*.js' -o -name '*.py' | grep -v node_modules | wc -l)"
find . -type d -maxdepth 3 | grep -v node_modules | grep -v .git | head -30
```

### 3. Mode Execution

**LIGHT (~5 min):**
- Scan key files (package.json, README, entry points, config)
- Create minimal AGENTS.md with stack, structure, key commands, key files

**MEDIUM (~15 min):**
- Interview user (5-10 questions): What does it do? Who uses it? Current state? Fragile areas? Conventions? Gotchas? Testing? Deployment? External services?
- Full codebase scan (all source, config, tests, schema)
- Create: AGENTS.md (comprehensive), .planning/CODEBASE.md (file map), .planning/ARCHITECTURE.md (with mermaid diagrams)

**HEAVY (~30 min):**
Full interview + spawn 6 parallel mappers:
```
SubAgent 1 (Structure): Map all files/directories, purpose, dependencies
SubAgent 2 (Architecture): System design, components, data flows, diagrams
SubAgent 3 (Patterns): Extract all coding patterns with examples
SubAgent 4 (API/Schema): Document endpoints, database models, types
SubAgent 5 (Config): All env vars, config files, feature flags
SubAgent 6 (Tech Debt): TODOs, FIXMEs, code smells, security concerns
SubAgent DOCS: Synthesize into comprehensive AGENTS.md + all .planning/ files
```

### 4. Core Files Created

```bash
mkdir -p .planning

# STATE.md - work tracking
cat > .planning/STATE.md << 'EOF'
# State
activeCommand: none
activeTask: none
lastContextUpdate: [now]
EOF

# HISTORY.md - work log
cat > .planning/HISTORY.md << 'EOF'
# Work History
## [date]
### [time] - /tk:map $MODE
EOF

# ISSUES.md, DECISIONS.md - initialize empty
```

### 5. Commit
```bash
git add AGENTS.md .planning/
git commit -m "docs: add project context (/tk:map $MODE)"
```

### 6. Report
```
✓ Context created
Files: AGENTS.md, .planning/CODEBASE.md, .planning/ARCHITECTURE.md [+ mode-specific]
Context size: [X] words
Ready: /tk:build, /tk:debug, etc.
```
