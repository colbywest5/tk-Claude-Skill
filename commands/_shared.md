---
name: tk:_shared
description: Core behaviors for ALL /tk:command calls. Read this first.
---

# Shared Behaviors

Every command uses these patterns. Apply them automatically.

## Version

```
TK_VERSION=1.1.0
```

**On first run or after update:** Save version to `.tk/VERSION`

```bash
mkdir -p .tk
echo "1.1.0" > .tk/VERSION
```

**On each run:** Check if update available (weekly check max)

```bash
# Only check once per week
LAST_CHECK=".tk/.version-check"
if [ ! -f "$LAST_CHECK" ] || [ $(find "$LAST_CHECK" -mtime +7 2>/dev/null) ]; then
    LATEST=$(curl -fsSL "https://raw.githubusercontent.com/colbywest5/tk-Claude-Skill/main/package.json" 2>/dev/null | grep '"version"' | cut -d'"' -f4)
    CURRENT=$(cat .tk/VERSION 2>/dev/null || echo "0.0.0")
    if [ "$LATEST" != "$CURRENT" ] && [ -n "$LATEST" ]; then
        echo "TK update available: $CURRENT -> $LATEST (run /tk:update)"
    fi
    touch "$LAST_CHECK"
fi
```

**Display version:** Show in command output header

```
TK v1.1.0 | /tk:[command] [mode]
```

## Pre-Flight (run before any task)

```bash
mkdir -p .planning
mkdir -p .tk

# Load rules (project > global > defaults)
RULES=""
if [ -f ".tk/RULES.md" ]; then
    RULES=$(cat .tk/RULES.md)
elif [ -f "$HOME/.claude/tk-rules.md" ]; then
    RULES=$(cat "$HOME/.claude/tk-rules.md")
fi

# Context check
if [ ! -f "AGENTS.md" ]; then
    echo "No AGENTS.md. Run /tk:map first or continue degraded."
fi

# Freshness (warn if >7 days old)
[ -f "AGENTS.md" ] && DAYS_OLD=$(( ($(date +%s) - $(stat -c %Y AGENTS.md 2>/dev/null || stat -f %m AGENTS.md)) / 86400 )) && [ $DAYS_OLD -gt 7 ] && echo "Context $DAYS_OLD days old"

# Active work check
[ -f ".planning/STATE.md" ] && grep -q "activeTask:.*[^none]" .planning/STATE.md && echo "Active work found - ask resume or fresh start"
```

## Rules Enforcement

**ALL agents MUST check and follow `.tk/RULES.md` before generating any code or output.**

Default rules (always apply even without RULES.md):
```
- No placeholder code (TODO, FIXME, "implement later")
- No hardcoded secrets or API keys
- No browser alert(), confirm(), prompt() popups
- All async operations must have error handling
- No emojis in code or commit messages
```

If RULES.md exists, parse and apply ALL rules. Violations = fix before completing.

## State Tracking

**On start:**
```bash
cat > .planning/STATE.md << EOF
# State
activeCommand: /tk:[$TASK] [$MODE]
activeTask: $MESSAGE
startedAt: $(date -Iseconds)
mode: $MODE
## Progress
(starting...)
EOF

echo "### $(date +%H:%M) - /tk:[$TASK] [$MODE]" >> .planning/HISTORY.md
echo "Status: IN_PROGRESS" >> .planning/HISTORY.md
```

**On completion:**
```bash
sed -i 's/activeTask:.*/activeTask: none/' .planning/STATE.md
echo "Duration: [time] | Outcome: SUCCESS" >> .planning/HISTORY.md
git add AGENTS.md .planning/ && git commit -m "docs: update after /tk:[$TASK]"
```

## Checkpoints

Before risky operations:
```bash
git add -A && git commit -m "checkpoint: before $STEP" --allow-empty
```

## Learning Loop

After fixing bugs or discovering patterns, auto-update:
```bash
# Gotcha
echo -e "\n### Gotcha: [issue] ($(date +%Y-%m-%d))\n**Symptom:** [x]\n**Fix:** [y]" >> AGENTS.md

# Pattern  
echo -e "\n## [Pattern] ($(date +%Y-%m-%d))\n[description + example]" >> .planning/PATTERNS.md
```

## Escalation

- **light → medium:** After 2 failed attempts or unexpected complexity
- **medium → heavy:** After 3 failed hypotheses or multiple interacting systems

## DOCS SubAgent (heavy mode only)

Spawn with EVERY parallel group:
```
SubAgent DOCS: "Document in parallel:
  - WHAT is being done
  - WHY (rationale)  
  - WHAT changed (files/functions)
  - Gotchas discovered
  Update: AGENTS.md, .planning/CHANGELOG.md, inline comments"
```

## Mode Summary

| Mode | Interaction | SubAgents | Time |
|------|-------------|-----------|------|
| light | Minimal, just do it | No | Fast |
| medium | 2-3 questions, structured | Optional | Balanced |
| heavy | Full interview, research | Yes + DOCS | Thorough |
