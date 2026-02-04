---
name: tk:_shared
description: Core behaviors for ALL /tk:command calls. Read this first.
---

# Shared Behaviors

**TK v1.1.0**

---

## TOKEN-EFFICIENT CONTEXT LOADING (Progressive Disclosure)

**Save tokens WITHOUT compromising capabilities.**

Inspired by [claude-mem](https://github.com/thedotmack/claude-mem)'s progressive disclosure pattern. Don't load everything upfront - use layered retrieval for ~10x token savings.

### The 3-Layer Pattern

| Layer | What to Load | Token Cost | When to Use |
|-------|--------------|------------|-------------|
| **L1: Index** | File names, section headers, summaries | ~50-100 tokens | ALWAYS start here |
| **L2: Relevant** | Sections matching current task | ~200-500 tokens | After identifying what's relevant |
| **L3: Full** | Complete file contents | ~500-2000 tokens | Only when actually needed |

### Context Loading Order

**LAYER 1 - Always Load (Minimal Tokens):**
```bash
# Load summaries/indexes only - NOT full content
[ -f "AGENTS.md" ] && head -50 AGENTS.md          # First 50 lines (summary)
[ -f ".tk/VERSION" ] && cat .tk/VERSION            # Small file, always load
[ -f ".tk/RULES.md" ] && cat .tk/RULES.md          # Small file, always load

# Get file LISTS, not contents
ls .planning/ 2>/dev/null                          # What files exist?
ls .tk/agents/ 2>/dev/null                         # What agent logs exist?
```

**LAYER 2 - Load When Relevant (Moderate Tokens):**
```bash
# Load based on current task
# For BUILD tasks:
[ -f ".planning/PATTERNS.md" ] && cat .planning/PATTERNS.md
[ -f ".planning/ARCHITECTURE.md" ] && cat .planning/ARCHITECTURE.md

# For DEBUG tasks:
[ -f ".planning/ISSUES.md" ] && cat .planning/ISSUES.md
[ -f ".planning/HISTORY.md" ] && tail -100 .planning/HISTORY.md

# For REVIEW tasks:
[ -f ".planning/DECISIONS.md" ] && cat .planning/DECISIONS.md
```

**LAYER 3 - Load Only When Needed (High Tokens):**
```bash
# Full file contents - ONLY when you need specific details
cat .planning/CODEBASE.md                          # Full file map
cat .tk/agents/*.md                                # All agent logs
find . -name "*.ts" -exec cat {} \;                # Source files
```

### Task-Specific Loading

| Command | Layer 1 (Always) | Layer 2 (If Relevant) | Layer 3 (If Needed) |
|---------|------------------|----------------------|---------------------|
| `/tk:build` | AGENTS.md summary, VERSION | PATTERNS, ARCHITECTURE | CODEBASE, source files |
| `/tk:debug` | AGENTS.md summary, VERSION | ISSUES, HISTORY tail | Agent logs, full HISTORY |
| `/tk:review` | AGENTS.md summary, VERSION | DECISIONS, PATTERNS | Full file contents |
| `/tk:workflow` | AGENTS.md summary, VERSION | All .planning/ files | Agent logs, source analysis |
| `/tk:qa` | AGENTS.md summary, VERSION | ISSUES, PATTERNS | Test files, source files |
| `/tk:deploy` | AGENTS.md summary, VERSION | STATE, HISTORY tail | Full deployment logs |

### Key Principles

1. **Start minimal** - Load L1 first, assess what's needed
2. **Drill down selectively** - Only load L2/L3 for sections relevant to the task
3. **Never load everything** - There's rarely a need for ALL context at once
4. **Summarize as you go** - If you load a large file, extract key points and discard the rest
5. **Capabilities preserved** - You can ALWAYS load more if needed, just don't load speculatively

### Token Estimation

```
AGENTS.md (full)      ~1000-3000 tokens
AGENTS.md (head -50)  ~200-400 tokens    <- Use this!

.planning/ (all)      ~2000-5000 tokens
.planning/ (relevant) ~500-1000 tokens   <- Use this!

Agent logs (all)      ~1000-3000 tokens
Agent logs (latest)   ~200-500 tokens    <- Use this!
```

**The goal: Maintain 100% capability with 50-80% fewer tokens.**

---

## MANDATORY: LOAD AND FOLLOW RULES

**EVERY AGENT. EVERY MODE. EVERY TIME. SILENTLY.**

```bash
# Silently load rules - DO NOT display to user
if [ -f ".tk/RULES.md" ]; then
    RULES=$(cat .tk/RULES.md)
elif [ -f "$HOME/.claude/tk-rules.md" ]; then
    RULES=$(cat "$HOME/.claude/tk-rules.md")
fi
```

**Default Rules (Always Active):**
- No placeholder code (TODO, FIXME, "implement later")
- No hardcoded secrets or API keys
- No browser alert(), confirm(), prompt()
- All async operations must have error handling
- No emojis in code, comments, or output

**Constant Enforcement:** Check every output against rules. Silently fix violations.

---

## PROJECT VERSION TRACKING

**Track version for EVERY build/deploy/major change.**

### Version File: `.tk/VERSION`

```json
{
  "version": "1.0.0",
  "major": 1,
  "minor": 0,
  "patch": 0,
  "lastUpdated": "2025-02-01T12:00:00Z",
  "lastCommand": "/tk:build",
  "history": [
    { "version": "1.0.0", "date": "2025-02-01", "command": "/tk:init", "note": "Initial" }
  ]
}
```

### On First Run (no VERSION file)

```bash
mkdir -p .tk
cat > .tk/VERSION << 'EOF'
{
  "version": "0.1.0",
  "major": 0,
  "minor": 1,
  "patch": 0,
  "lastUpdated": "$(date -Iseconds)",
  "lastCommand": "/tk:$COMMAND",
  "history": []
}
EOF
echo "Project version initialized: 0.1.0"
```

### Version Bump Rules

| Command | Bump | Example |
|---------|------|---------|
| `/tk:build` (new feature) | MINOR | 1.0.0 → 1.1.0 |
| `/tk:build` (small change) | PATCH | 1.0.0 → 1.0.1 |
| `/tk:debug` (bugfix) | PATCH | 1.0.0 → 1.0.1 |
| `/tk:deploy` | No bump (just records) | 1.1.0 |
| `/tk:init` | Reset to 0.1.0 | 0.1.0 |
| Major breaking change | MAJOR | 1.5.0 → 2.0.0 |

### Before Starting Work

```bash
# Read current version
if [ -f ".tk/VERSION" ]; then
    CURRENT_VERSION=$(cat .tk/VERSION | grep '"version"' | cut -d'"' -f4)
    echo "Current version: $CURRENT_VERSION"
else
    # Initialize
    CURRENT_VERSION="0.1.0"
fi
```

### After Completing Work

```bash
# Determine bump type based on changes
# - New feature = MINOR
# - Bugfix/small change = PATCH
# - Breaking change = MAJOR

# Update VERSION file
# Add to history
# Log: "Version: X.Y.Z → X.Y.Z+1"
```

### Display in Output

Every build/deploy should show:
```
Version: 1.2.3 → 1.2.4
```

---

## Pre-Flight (EVERY command)

```bash
# 1. Load rules (silently)
# 2. Read project version
mkdir -p .tk/agents .tk/locks .planning

# 3. Generate agent ID
AGENT_ID="$(hostname)-$(date +%s)-$$-$RANDOM"

# 4. Register agent
echo "| $AGENT_ID | /tk:$COMMAND $MODE | $(date +%H:%M:%S) | WORKING |" >> .tk/COORDINATION.md

# 5. Create agent log
cat > ".tk/agents/$AGENT_ID.md" << EOF
# Agent: $AGENT_ID
Command: /tk:$COMMAND $MODE
Started: $(date -Iseconds)
Project Version: $CURRENT_VERSION
## Log
EOF

# 6. Check context
[ ! -f "AGENTS.md" ] && echo "No AGENTS.md - run /tk:map first"
```

---

## File Locking

```bash
acquire_lock() {
    mkdir -p .tk/locks
    mkdir ".tk/locks/$1.lock" 2>/dev/null && echo "$AGENT_ID" > ".tk/locks/$1.lock/owner"
}

release_lock() {
    rm -rf ".tk/locks/$1.lock"
}

wait_for_lock() {
    for i in $(seq 1 30); do
        acquire_lock "$1" && return 0
        sleep 1
    done
    return 1
}

safe_write() {
    wait_for_lock "$(basename $1)" || return 1
    echo "[$AGENT_ID $(date +%H:%M:%S)] $2" >> "$1"
    release_lock "$(basename $1)"
}
```

---

## On Completion

```bash
# Log completion
echo "[$(date +%H:%M:%S)] COMPLETED" >> ".tk/agents/$AGENT_ID.md"

# Update version (if applicable)
# build/debug = bump patch or minor
# Record in .tk/VERSION history

# Update coordination
echo "| $AGENT_ID | DONE | $(date +%H:%M:%S) |" >> .tk/COORDINATION.md
```

---

## Mode Behaviors

| Mode | Rules | Questions | SubAgents | Version |
|------|-------|-----------|-----------|---------|
| light | Silent | 0-1 | No | Bump patch |
| medium | Silent | 2-3 | Optional | Bump patch/minor |
| heavy | Silent | Full | Yes + DOCS | Bump minor |

---

## Escalation

- **light → medium:** After 2 failed attempts
- **medium → heavy:** After 3 failed hypotheses
