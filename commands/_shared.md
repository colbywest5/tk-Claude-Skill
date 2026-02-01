---
name: tk:_shared
description: Core behaviors for ALL /tk:command calls. Read this first.
---

# Shared Behaviors

**TK v1.1.0**

---

## MANDATORY: LOAD AND FOLLOW RULES

**EVERY AGENT. EVERY MODE. EVERY TIME. SILENTLY.**

### On Command Start (Before Anything Else)

```bash
# Silently load rules - DO NOT display to user
if [ -f ".tk/RULES.md" ]; then
    RULES=$(cat .tk/RULES.md)
elif [ -f "$HOME/.claude/tk-rules.md" ]; then
    RULES=$(cat "$HOME/.claude/tk-rules.md")
fi
```

### Internalize Rules

Read every rule. Memorize every rule. These rules govern ALL your output.

### Default Rules (Always Active)

```
1. No placeholder code (TODO, FIXME, "implement later", "add logic here")
2. No hardcoded secrets or API keys
3. No browser alert(), confirm(), prompt() popups
4. All async operations must have error handling
5. No emojis in code, comments, or output
6. No console.log/print in production code
```

### Constant Enforcement

- Before generating ANY code: check against rules
- Before ANY output: check against rules
- If you catch yourself about to violate: STOP, fix it, continue
- Do NOT generate violating code with plans to "fix later"

### Silent Compliance

- Do NOT announce rules to user
- Do NOT list rules
- Just follow them. Constantly. Silently.

---

## Pre-Flight (EVERY command)

```bash
# 1. Load rules (silently - see above)

# 2. Create directories
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
## Log
EOF

# 6. Check context
[ ! -f "AGENTS.md" ] && echo "Note: No AGENTS.md - run /tk:map first"
```

---

## Multi-Agent Coordination

### File Locking

Before writing ANY shared file:

```bash
acquire_lock() {
    local file="$1"
    local lockdir=".tk/locks/$file.lock"
    mkdir -p .tk/locks
    mkdir "$lockdir" 2>/dev/null && echo "$AGENT_ID" > "$lockdir/owner"
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
```

### Safe Write (Append Only)

```bash
safe_write() {
    wait_for_lock "$(basename $1)" || return 1
    echo "[$AGENT_ID $(date +%H:%M:%S)] $2" >> "$1"
    release_lock "$(basename $1)"
}
```

### Agent Logging

Each agent logs to its own file (no locks needed):

```bash
log() {
    echo "[$(date +%H:%M:%S)] $1" >> ".tk/agents/$AGENT_ID.md"
}
```

---

## On Completion

```bash
log "COMPLETED"

# Update coordination
echo "| $AGENT_ID | DONE | $(date +%H:%M:%S) |" >> .tk/COORDINATION.md

# Merge findings if any (with lock)
if [ -n "$FINDINGS" ]; then
    wait_for_lock "AGENTS.md"
    echo -e "\n## [$AGENT_ID]\n$FINDINGS" >> AGENTS.md
    release_lock "AGENTS.md"
fi
```

---

## Mode Behaviors

| Mode | Rules | Questions | SubAgents |
|------|-------|-----------|-----------|
| light | Follow silently | 0-1 max | No |
| medium | Follow silently | 2-3 | Optional |
| heavy | Follow silently | Full interview | Yes + DOCS |

---

## Escalation

- **light → medium:** After 2 failed attempts
- **medium → heavy:** After 3 failed hypotheses

---

## DOCS SubAgent (heavy mode)

```
SubAgent DOCS: "
1. Load rules silently
2. Follow rules constantly
3. Log to your own file
4. Merge to shared files on completion
"
```
