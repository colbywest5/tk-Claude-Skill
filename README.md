# TK - Token Killer

**~79% token reduction** while maintaining full capabilities.

A token-optimized command system for Claude Code and AI coding assistants. Dramatically reduces token consumption without losing any functionality.

## Quick Start

```bash
/tk:map heavy    # Map your project first (creates context)
/tk:build medium Add user authentication
/tk:debug light  The API returns 500 errors
```

## Commands

| Command | Purpose |
|---------|---------|
| `/tk:map` | Map project, create context **(RUN FIRST)** |
| `/tk:build` | Build/create something |
| `/tk:design` | Create distinctive frontend interfaces |
| `/tk:debug` | Fix a problem |
| `/tk:qa` | Test something |
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

| Mode | Description | SubAgents |
|------|-------------|-----------|
| `light` | Fast, minimal interaction | No |
| `medium` | Balanced, key decisions | Optional |
| `heavy` | Comprehensive, parallel work | Yes + DOCS |

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
Context engineering and spec-driven development:
- **Solves context rot** - quality degradation as context fills
- **Multi-agent orchestration** - thin orchestrator spawns specialized agents
- **XML prompt formatting** - structured tasks with verification steps
- **Atomic git commits** - each task gets its own commit
- **Fresh context per execution** - 200k tokens purely for implementation

### From [Ralph](https://github.com/snarktank/ralph)
Autonomous agent loop patterns:
- **Each iteration = fresh context** - memory via git, progress files, state
- **Small atomic tasks** - right-sized for single context window
- **AGENTS.md updates** - learnings persist across iterations
- **Feedback loops** - typecheck, tests, CI must stay green
- **Stop conditions** - clear completion criteria

### From [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev)
7-phase structured workflow (in `/tk:build`):
1. **Discovery** - Understand requirements
2. **Codebase Exploration** - code-explorer agents trace existing patterns
3. **Clarifying Questions** - MANDATORY - resolve all ambiguities
4. **Architecture Design** - code-architect agents propose approaches
5. **Implementation** - Build with approval
6. **Quality Review** - code-reviewer agents check quality (confidence >= 80)
7. **Summary** - Document what was built

### From [security-guidance](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance)
Security vulnerability scanning (in `/tk:qa`):
- Command injection (`exec`, `os.system`, `child_process`)
- Code injection (`eval`, `new Function`)
- XSS (`innerHTML`, `dangerouslySetInnerHTML`, `document.write`)
- Deserialization attacks (`pickle`)
- GitHub Actions workflow injection
- Hardcoded secrets
- npm audit vulnerabilities

### From [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design)
Distinctive UI creation (in `/tk:design`):
- **Bold aesthetic direction** - no generic "AI slop"
- **Typography** - distinctive fonts, no Inter/Arial/Roboto
- **Color & theme** - CSS variables, dominant + accent palettes
- **Motion** - CSS animations, staggered reveals, hover states
- **Spatial composition** - asymmetry, overlap, grid-breaking

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

## Installation

Copy `tk.md` and the `commands/` folder to your Claude Code commands directory:

```bash
# Global install
cp tk.md ~/.claude/commands/
cp -r commands/ ~/.claude/commands/tk/

# Or local install
cp tk.md .claude/commands/
cp -r commands/ .claude/commands/tk/
```

## File Structure

```
tk.md                  # Main router
commands/
├── _shared.md         # Shared behaviors
├── map.md             # Map project
├── build.md           # Build features
├── design.md          # Frontend design
├── debug.md           # Debug problems
├── qa.md              # QA + security
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

**Token optimized** - condensed prompts, removed redundancy, lazy-loading patterns

---

## Credits

Built by combining and optimizing patterns from:

| Project | Author | What we took |
|---------|--------|--------------|
| [Get Shit Done](https://github.com/glittercowboy/get-shit-done) | @glittercowboy | Context engineering, multi-agent orchestration, atomic commits |
| [Ralph](https://github.com/snarktank/ralph) | @snarktank | Autonomous loop patterns, fresh context per iteration, AGENTS.md updates |
| [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev) | Anthropic | 7-phase workflow, code-explorer/architect/reviewer agents |
| [security-guidance](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance) | Anthropic | Security pattern scanning, vulnerability detection |
| [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design) | Anthropic | Distinctive UI principles, anti-AI-slop guidelines |

## License

MIT
