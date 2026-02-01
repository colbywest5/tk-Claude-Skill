---
name: tk:doc
description: Generate documentation. /tk:[$cmd] light|medium|heavy
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
---

# /tk:[$cmd] [mode]

Generate or update documentation.

## Process

### 1. Analyze
```bash
mkdir -p docs
[ -f "package.json" ] && echo "Node.js"
find . -path "*/api/*" -name "*.ts" | grep -v node_modules | head -10  # API routes
find . -name "*.tsx" | grep -v node_modules | wc -l  # Components
```

### 2. Mode Execution

**LIGHT (README only):**
Generate README.md:
- Project name + description
- Quick start (prerequisites, install, config, run)
- Scripts list
- License

```bash
git add README.md && git commit -m "docs: update README"
```

**MEDIUM (README + API + Architecture):**
- Everything in light, plus:
- docs/API.md: All endpoints (method, path, body, response, example curl)
- docs/ARCHITECTURE.md: Overview, mermaid diagram, key components, data flow
- Update AGENTS.md if exists

**HEAVY (4 parallel generators):**
```
SubAgent 1 (README): Comprehensive - features, prerequisites, install, config, usage, dev guide, testing, deploy, contributing
SubAgent 2 (API): All endpoints + OpenAPI spec if possible
SubAgent 3 (Architecture): System overview, component diagrams, data flow, design decisions, tech debt
SubAgent 4 (Code Commenter): Add JSDoc/TSDoc to exported functions, explain complex logic
SubAgent DOCS: Create docs/INDEX.md, verify consistency, cross-link, check for outdated info
```

### 3. Completion
```bash
git add README.md docs/ AGENTS.md
git commit -m "docs: generate/update documentation"
```

Report: Files generated (README, API.md, ARCHITECTURE.md), inline comments added
