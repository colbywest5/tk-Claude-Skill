---
name: tk:learn
description: Capture a learning. /tk:learn <type> <description>
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# /tk:[learn]

Capture something learned for future reference.

## Types

Ask: "What kind of learning?"
- Gotcha (trap to avoid)
- Pattern (good way to do something)
- Fix (how to solve specific problem)
- Decision (why X over Y)
- Insight (general codebase knowledge)

## Capture

**Gotcha:** Ask symptom, cause, fix → append to AGENTS.md
```markdown
### Gotcha: [title] (date)
**Symptom:** [x]
**Cause:** [y]
**Fix:** [z]
```

**Pattern:** Ask name, when to use, example → append to .planning/PATTERNS.md
```markdown
## [Name] (date)
**When:** [context]
**Example:** [code]
```

**Fix:** Ask problem, solution, files → append to AGENTS.md troubleshooting

**Decision:** Ask decision, alternatives, rationale → append to .planning/DECISIONS.md
```markdown
### [Title] (date)
**Decision:** [what]
**Alternatives:** [what else]
**Rationale:** [why]
```

**Insight:** Add to appropriate AGENTS.md section

## Commit
```bash
git add AGENTS.md .planning/ && git commit -m "docs: add [type] - [brief]"
```

Confirm: "Learning captured to [file]. Available to all future /tk:commands."
