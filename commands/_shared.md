---
name: tk:_shared
description: Core behaviors for ALL /tk:command calls. Read this first.
---

# Shared Behaviors

Every command uses these patterns. Apply them automatically.

## Pre-Flight (run before any task)

```bash
mkdir -p .planning

# Context check
if [ ! -f "AGENTS.md" ]; then
    echo "⚠️ No AGENTS.md. Run /tk:map first or continue degraded."
fi

# Freshness (warn if >7 days old)
[ -f "AGENTS.md" ] && DAYS_OLD=$(( ($(date +%s) - $(stat -c %Y AGENTS.md 2>/dev/null || stat -f %m AGENTS.md)) / 86400 )) && [ $DAYS_OLD -gt 7 ] && echo "⚠️ Context $DAYS_OLD days old"

# Active work check
[ -f ".planning/STATE.md" ] && grep -q "activeTask:.*[^none]" .planning/STATE.md && echo "📋 Active work found - ask resume or fresh start"
```

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
