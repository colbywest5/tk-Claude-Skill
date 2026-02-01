# TK - Token Killer

**~79% token reduction** while maintaining full capabilities.

---

## Why TK Exists

**The Problem:** AI coding skills are bloated. Most prompt engineering for Claude Code, Cursor, and similar tools uses verbose, redundant instructions that eat through your context window fast. When your context fills up, quality degrades — Claude starts forgetting things, making inconsistent decisions, and producing worse code. This is called **context rot**.

**The Bigger Problem:** The best AI coding workflows — like [Get Shit Done](https://github.com/glittercowboy/get-shit-done), [Ralph](https://github.com/snarktank/ralph), and Anthropic's official plugins — are genuinely excellent. But they're written for readability and documentation, not token efficiency. Running them burns through tokens unnecessarily.

**The Solution:** TK takes the best patterns from 5 different AI coding systems, strips out the redundancy, condenses the prompts, and delivers the same capabilities with ~79% fewer tokens. Same power, way less cost, longer before context rot kicks in.

**What you get:**
- All the structure of spec-driven development
- Multi-agent orchestration with parallel SubAgents
- Security scanning, code review, and quality checks
- Fresh context patterns that prevent degradation
- 14 commands covering the full development lifecycle

**What you save:**
- Tokens (directly = money if you're paying per token)
- Context window space (indirectly = better quality output)
- Time (less waiting, faster responses)

---

## Quick Start

```bash
/tk:map heavy           # Map your project first (creates context)
/tk:build medium        Add user authentication
/tk:debug light         The API returns 500 errors
```

---

## Commands

| Command | Purpose |
|---------|---------|
| `/tk:map` | Map project, create context **(RUN FIRST)** |
| `/tk:build` | Build/create something |
| `/tk:design` | Create distinctive frontend interfaces |
| `/tk:debug` | Fix a problem |
| `/tk:qa` | Test something + security scan |
| `/tk:review` | Code review |
| `/tk:clean` | Cleanup codebase |
| `/tk:doc` | Generate documentation |
| `/tk:deploy` | Deploy to production |
| `/tk:init` | Initialize new project |
| `/tk:resume` | Resume interrupted work |
| `/tk:learn` | Capture a learning |
| `/tk:status` | Show project status |
| `/tk:help` | Show help |

## Modes

| Mode | When to use | SubAgents |
|------|-------------|-----------|
| `light` | Quick fixes, simple tasks | No |
| `medium` | Standard features, balanced approach | Optional |
| `heavy` | Complex features, thorough analysis | Yes + DOCS |

**Rule of thumb:** Start with `light`, escalate if needed. The system auto-suggests escalation when complexity warrants it.

---

## Heavy Mode SubAgents

Every heavy mode operation includes a dedicated **DOCS SubAgent** that documents in real-time:

| Command | SubAgents |
|---------|-----------|
| map | 6 mappers + DOCS |
| build | 3 explorers + 3 architects + 3 reviewers + DOCS |
| design | 3 research + 4 specialists + DOCS |
| debug | 4 investigators + 3 fixers + DOCS |
| qa | 6 specialists (incl. Security) + DOCS |
| review | 4 reviewers + DOCS |
| clean | 4 cleaners + DOCS |
| deploy | 4 pre-flight + 4 post-deploy + DOCS |

---

## Integrated Skills

TK combines patterns from multiple best-in-class AI coding systems:

### From [Get Shit Done](https://github.com/glittercowboy/get-shit-done)
- **Context engineering** - solves context rot
- **Multi-agent orchestration** - thin orchestrator spawns specialized agents
- **Atomic git commits** - each task gets its own commit
- **Fresh context per execution** - full context purely for implementation

### From [Ralph](https://github.com/snarktank/ralph)
- **Each iteration = fresh context** - memory via git, progress files, state
- **Small atomic tasks** - right-sized for single context window
- **AGENTS.md updates** - learnings persist across iterations
- **Feedback loops** - typecheck, tests, CI must stay green

### From [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev)
7-phase structured workflow (in `/tk:build`):
1. Discovery → 2. Codebase Exploration → 3. Clarifying Questions (MANDATORY) → 4. Architecture Design → 5. Implementation → 6. Quality Review → 7. Summary

### From [security-guidance](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance)
Security scanning (in `/tk:qa`): command injection, code injection, XSS, deserialization attacks, GitHub Actions injection, hardcoded secrets, npm audit

### From [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design)
Distinctive UI (in `/tk:design`): bold aesthetics, unique typography, motion design, spatial composition — no generic "AI slop"

---

## Key Files Created

```
AGENTS.md              # Master project knowledge
.planning/
├── STATE.md           # Current work state
├── HISTORY.md         # Work log
├── ISSUES.md          # Known issues
├── PATTERNS.md        # Discovered patterns
├── DECISIONS.md       # Decision log
├── CODEBASE.md        # File map
└── ARCHITECTURE.md    # System design
```

---

## Installation

```bash
# Clone the repo
git clone https://github.com/colbywest5/tk-Claude-Skill.git

# Global install (all projects)
cp tk-Claude-Skill/tk.md ~/.claude/commands/
cp -r tk-Claude-Skill/commands/ ~/.claude/commands/tk/

# Or local install (current project only)
mkdir -p .claude/commands
cp tk-Claude-Skill/tk.md .claude/commands/
cp -r tk-Claude-Skill/commands/ .claude/commands/tk/
```

Then restart Claude Code and run `/tk:help` to verify.

---

## Tips for Best Results

1. **Always run `/tk:map` first** on a new project — it creates the context that all other commands rely on

2. **Start with `light` mode** — escalate to `medium` or `heavy` only when needed

3. **Let the system escalate** — if `light` fails twice, it suggests `medium`. Trust it.

4. **Use `/tk:learn`** — when you discover a gotcha or pattern, capture it immediately

5. **Check `/tk:status`** — quick health check before starting work

6. **Resume interrupted work** — if you stop mid-task, `/tk:resume` picks up where you left off

---

## Troubleshooting

**Commands not found?**
- Restart Claude Code after installation
- Verify files are in `~/.claude/commands/` or `.claude/commands/`

**Context still filling up fast?**
- Use `light` mode more often
- Run `/tk:clean` to remove dead code bloating context
- Split large features into smaller `/tk:build` calls

**SubAgents not spawning?**
- Make sure you're using `heavy` mode
- Check that your Claude Code version supports SubAgents

---

## File Structure

```
tk.md                  # Main router
commands/
├── _shared.md         # Shared behaviors (loaded by all commands)
├── map.md             # Map project
├── build.md           # Build features (7-phase workflow)
├── design.md          # Frontend design
├── debug.md           # Debug problems
├── qa.md              # QA + security scanning
├── review.md          # Code review
├── clean.md           # Cleanup
├── doc.md             # Documentation
├── deploy.md          # Deployment
├── init.md            # New project
├── resume.md          # Resume work
├── learn.md           # Capture learnings
├── status.md          # Project status
└── help.md            # Help reference
```

---

## Credits

Built by combining and optimizing patterns from:

| Project | Author | Contribution |
|---------|--------|--------------|
| [Get Shit Done](https://github.com/glittercowboy/get-shit-done) | @glittercowboy | Context engineering, multi-agent orchestration |
| [Ralph](https://github.com/snarktank/ralph) | @snarktank | Autonomous loop patterns, fresh context |
| [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev) | Anthropic | 7-phase workflow, specialized agents |
| [security-guidance](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance) | Anthropic | Security vulnerability scanning |
| [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design) | Anthropic | Distinctive UI design principles |

---

## Contributing

Found a way to reduce tokens further without losing capability? PRs welcome.

## License

MIT
