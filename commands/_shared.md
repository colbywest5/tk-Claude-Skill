---
name: tk:_shared
description: Core behaviors for ALL /tk:command calls. Read this first.
---

# Shared Behaviors

**TK v1.1.0**

---

## MANDATORY: LOAD RULES FIRST

**THIS IS NOT OPTIONAL. EVERY AGENT, EVERY MODE, EVERY TIME.**

Before doing ANYTHING else - before generating code, before asking questions, before ANY action:

### Step 1: Read Rules

```bash
# ALWAYS check for rules file - EVERY SINGLE TIME
if [ -f ".tk/RULES.md" ]; then
    RULES=$(cat .tk/RULES.md)
    echo "[RULES LOADED] $(wc -l < .tk/RULES.md) rules from .tk/RULES.md"
elif [ -f "$HOME/.claude/tk-rules.md" ]; then
    RULES=$(cat "$HOME/.claude/tk-rules.md")
    echo "[RULES LOADED] Global rules from ~/.claude/tk-rules.md"
else
    echo "[RULES] Using defaults (no custom rules file)"
fi
```

### Step 2: Parse and Apply Rules

Read each rule. Remember each rule. Apply each rule to ALL output.

### Step 3: Confirm Rules Before Proceeding

Display loaded rules to user:

```
ACTIVE RULES:
- [rule 1]
- [rule 2]
- ...
```

### Default Rules (ALWAYS apply, even without RULES.md)

```
1. No placeholder code (TODO, FIXME, "implement later", "add logic here")
2. No hardcoded secrets or API keys
3. No browser alert(), confirm(), prompt() popups  
4. All async operations must have error handling
5. No emojis in code, comments, or output
6. No console.log/print in production code (unless debugging)
```

### Rules Violations = STOP AND FIX

If you're about to generate code that violates a rule:
1. STOP
2. Fix the violation
3. Then continue

Do NOT generate violating code and "fix it later."

---

## Pre-Flight Checklist (EVERY command, EVERY mode)

Run this BEFORE doing any work:

```
[ ] 1. RULES LOADED (see above - this is first)
[ ] 2. Agent ID generated
[ ] 3. Registered in COORDINATION.md
[ ] 4. Created agent log file
[ ] 5. Checked for AGENTS.md context
[ ] 6. Checked for active work (.planning/STATE.md)
```

---

## Multi-Agent Coordination

**TK supports multiple Claude Code instances with parallel agents.**

### Agent Identity

On EVERY command start, generate a unique agent ID:

```bash
AGENT_ID="$(hostname)-$(date +%s)-$$-$RANDOM"
mkdir -p .tk/agents
echo "$AGENT_ID" > .tk/.agent-$AGENT_ID
```

### Register Agent

```bash
mkdir -p .tk
echo "| $AGENT_ID | /tk:$COMMAND $MODE | $(date +%H:%M:%S) | WORKING |" >> .tk/COORDINATION.md
```

### Agent Log File

Each agent writes to its own log (no locks needed):

```bash
cat > ".tk/agents/$AGENT_ID.md" << EOF
# Agent: $AGENT_ID
Command: /tk:$COMMAND $MODE
Started: $(date -Iseconds)

## Rules Loaded
$RULES

## Log
[$(date +%H:%M:%S)] Starting...
EOF
```

---

## File Locking (Prevent Overwrites)

Before writing ANY shared file, acquire a lock:

```bash
acquire_lock() {
    local file="$1"
    local lockdir=".tk/locks/$file.lock"
    mkdir -p .tk/locks
    if mkdir "$lockdir" 2>/dev/null; then
        echo "$AGENT_ID" > "$lockdir/owner"
        return 0
    fi
    return 1
}

release_lock() {
    rm -rf ".tk/locks/$1.lock"
}

# Wait up to 30 seconds for lock
wait_for_lock() {
    local file="$1"
    for i in $(seq 1 30); do
        acquire_lock "$file" && return 0
        sleep 1
    done
    echo "LOCK TIMEOUT: $file"
    return 1
}
```

### Safe Write Pattern

```bash
safe_write() {
    local file="$1"
    local content="$2"
    wait_for_lock "$(basename $file)" || return 1
    echo "$content" >> "$file"  # APPEND, don't overwrite
    release_lock "$(basename $file)"
}
```

---

## Logging (Append-Only)

**NEVER overwrite logs. ALWAYS append with agent ID + timestamp.**

```bash
log() {
    echo "[$AGENT_ID $(date +%H:%M:%S)] $1" >> ".tk/agents/$AGENT_ID.md"
}

# Log to shared history (with lock)
log_shared() {
    safe_write ".planning/HISTORY.md" "[$AGENT_ID $(date +%H:%M:%S)] $1"
}
```

---

## On Completion

```bash
# Update agent status
log "COMPLETED: $OUTCOME"

# Update coordination
echo "| $AGENT_ID | /tk:$COMMAND | $(date +%H:%M:%S) | DONE |" >> .tk/COORDINATION.md

# Merge findings to AGENTS.md if any
if [ -n "$FINDINGS" ]; then
    wait_for_lock "AGENTS.md"
    echo -e "\n## [$AGENT_ID $(date +%Y-%m-%d)]\n$FINDINGS" >> AGENTS.md
    release_lock "AGENTS.md"
fi
```

---

## Mode Behaviors

| Mode | Rules | Questions | SubAgents |
|------|-------|-----------|-----------|
| light | LOAD FIRST | 0-1 max | No |
| medium | LOAD FIRST | 2-3 | Optional |
| heavy | LOAD FIRST | Full interview | Yes + DOCS |

**ALL MODES LOAD RULES FIRST. NO EXCEPTIONS.**

---

## Escalation

- **light → medium:** After 2 failed attempts
- **medium → heavy:** After 3 failed hypotheses

---

## DOCS SubAgent (heavy mode)

Spawn with every parallel group:

```
SubAgent DOCS: "
1. Generate your own agent ID
2. LOAD RULES FIRST
3. Log to your own file
4. Document everything in real-time
5. Merge to shared files ON COMPLETION (with locks)
"
```
