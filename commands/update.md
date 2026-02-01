---
name: tk:update
description: Update TK to the latest version from GitHub
allowed-tools:
  - Bash
---

# /tk:update

Update TK to the latest version. Works on Windows, macOS, and Linux.

## Cross-Platform Update

Detect OS and run appropriate commands:

### macOS / Linux / Git Bash

```bash
echo "Updating TK..."

CLAUDE_DIR="$HOME/.claude/commands"
TK_DIR="$CLAUDE_DIR/tk"
REPO="colbywest5/Toolkit"
TMP_DIR=$(mktemp -d)

# Download latest
echo "Downloading latest from GitHub..."
curl -fsSL "https://raw.githubusercontent.com/$REPO/main/tk.md" -o "$TMP_DIR/tk.md"

for cmd in _shared map build design debug qa review clean doc deploy init resume learn opinion rules status tokens help update; do
    curl -fsSL "https://raw.githubusercontent.com/$REPO/main/commands/${cmd}.md" -o "$TMP_DIR/${cmd}.md" 2>/dev/null || true
done

# Backup current version
if [ -d "$TK_DIR" ]; then
    echo "Backing up current version..."
    cp -r "$TK_DIR" "$TK_DIR.backup.$(date +%Y%m%d%H%M%S)"
fi

# Install new version
mkdir -p "$TK_DIR"
cp "$TMP_DIR/tk.md" "$CLAUDE_DIR/tk.md"
cp "$TMP_DIR/"*.md "$TK_DIR/"

# Cleanup
rm -rf "$TMP_DIR"

echo ""
echo "Updated to latest TK"
echo "Run /tk:help to see all commands."
```

### Windows PowerShell

```powershell
Write-Host "Updating TK..." -ForegroundColor Cyan

$CLAUDE_DIR = "$env:USERPROFILE\.claude\commands"
$TK_DIR = "$CLAUDE_DIR\tk"
$REPO = "colbywest5/Toolkit"
$BASE_URL = "https://raw.githubusercontent.com/$REPO/main"

# Create temp directory
$TMP_DIR = Join-Path ([System.IO.Path]::GetTempPath()) "tk-update-$(Get-Random)"
New-Item -ItemType Directory -Path $TMP_DIR -Force | Out-Null

# Download files
Write-Host "Downloading latest from GitHub..."
Invoke-WebRequest -Uri "$BASE_URL/tk.md" -OutFile "$TMP_DIR\tk.md" -UseBasicParsing

$commands = @("_shared", "map", "build", "design", "debug", "qa", "review", "clean", "doc", "deploy", "init", "resume", "learn", "opinion", "rules", "status", "tokens", "help", "update")
foreach ($cmd in $commands) {
    try {
        Invoke-WebRequest -Uri "$BASE_URL/commands/$cmd.md" -OutFile "$TMP_DIR\$cmd.md" -UseBasicParsing -ErrorAction SilentlyContinue
    } catch {}
}

# Backup current
if (Test-Path $TK_DIR) {
    Write-Host "Backing up current version..."
    $backup = "$TK_DIR.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item -Path $TK_DIR -Destination $backup -Recurse
}

# Install
New-Item -ItemType Directory -Path $TK_DIR -Force | Out-Null
Copy-Item "$TMP_DIR\tk.md" "$CLAUDE_DIR\tk.md" -Force
Copy-Item "$TMP_DIR\*.md" "$TK_DIR\" -Force

# Cleanup
Remove-Item $TMP_DIR -Recurse -Force

Write-Host ""
Write-Host "Updated to latest TK" -ForegroundColor Green
Write-Host "Run /tk:help to see all commands."
```

## What Gets Updated

- `tk.md` (main router)
- All command files in `commands/`
- Preserves your `.tk/RULES.md` (project rules are untouched)

## Backup Location

Before updating, creates a timestamped backup:
```
~/.claude/commands/tk.backup.YYYYMMDDHHMMSS/
```
