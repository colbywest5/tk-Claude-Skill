---
name: tk:deploy
description: Deployment. /tk:[$cmd] light|medium|heavy
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
---

# /tk:[$cmd] [mode]

Deploy to production.

## Process

### 1. Pre-flight
```bash
# Must be clean
[ $(git status --porcelain | wc -l) -gt 0 ] && echo "✗ Uncommitted changes - commit first" && exit 1
echo "Branch: $(git branch --show-current)"
mkdir -p .deploy
```

### 2. Mode Execution

**LIGHT (just deploy):**
```bash
# Auto-detect and deploy
[ -f "vercel.json" ] && npx vercel --prod
[ -f "railway.toml" ] && railway up
[ -f "Dockerfile" ] && docker build -t app:$(git rev-parse --short HEAD) . && docker push
```

**MEDIUM (pre-flight + deploy + verify):**
```bash
# Pre-flight checks (all must pass)
npm test && npm run typecheck && npm run build
CRITICAL=$(npm audit --json 2>/dev/null | grep -c '"severity":"critical"')
[ "$CRITICAL" -gt 0 ] && echo "⛔ $CRITICAL critical vulns - blocked" && exit 1

# Deploy
npx vercel --prod 2>&1 | tee .deploy/output.txt
DEPLOY_URL=$(grep -oP 'https://[^\s]+' .deploy/output.txt | tail -1)

# Verify
sleep 10
curl -sf "$DEPLOY_URL/api/health" && echo "✓ Health OK"
curl -sf "$DEPLOY_URL" && echo "✓ Homepage OK"
```

**HEAVY (full pipeline):**
```
Pre-flight (4 parallel):
SubAgent 1 (Tests): Full suite + coverage >70%
SubAgent 2 (Security): npm audit, no secrets in code, auth verified
SubAgent 3 (Build): Build succeeds, bundle size reasonable, env vars documented
SubAgent 4 (Config): Platform config valid, env vars set, SSL configured
SubAgent DOCS: Create .deploy/pre-flight-report.md
→ ALL must pass

Deploy

Post-deploy (4 parallel):
SubAgent 1 (Health): Health endpoint, response time <500ms
SubAgent 2 (Smoke): Homepage, login, core feature, API endpoints
SubAgent 3 (Logs): Check for errors in production logs
SubAgent 4 (Performance): TTFB, page load, Core Web Vitals
SubAgent DOCS: Create .deploy/deployment-report.md
```

### 3. Completion
```bash
VERSION=$(date +%Y.%m.%d-%H%M)
git tag -a "deploy-$VERSION" -m "Deployed to production"
git push origin "deploy-$VERSION"
# Update STATE.md, HISTORY.md
```

Report: URL, commit, pre-flight status, verification status, tag

### 4. Rollback (if verification fails)
```bash
vercel rollback  # or railway rollback, or deploy previous docker tag
```
