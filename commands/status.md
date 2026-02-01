---
name: tk:status
description: Project status. No mode needed.
allowed-tools:
  - Read
  - Bash
---

# /tk:[status]

Quick project health overview.

```bash
echo "═══ PROJECT STATUS ═══"

echo "GIT"
echo "  Branch:      $(git branch --show-current)"
echo "  Uncommitted: $(git status --short | wc -l) files"
echo "  Last commit: $(git log -1 --oneline)"

echo "HEALTH"
npm test > /dev/null 2>&1 && echo "  Tests: ✓" || echo "  Tests: ✗"
npm run typecheck > /dev/null 2>&1 && echo "  Types: ✓" || echo "  Types: ✗"
npm run build > /dev/null 2>&1 && echo "  Build: ✓" || echo "  Build: ✗"

echo "DEPS"
echo "  Outdated: $(npm outdated 2>/dev/null | wc -l)"
echo "  Vulns:    $(npm audit --json 2>/dev/null | grep -c '"critical"')"

echo "TODOS"
echo "  Found: $(grep -rn 'TODO\|FIXME' --include='*.ts' 2>/dev/null | grep -v node_modules | wc -l)"
```
