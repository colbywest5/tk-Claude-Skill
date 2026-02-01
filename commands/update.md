---
name: tk:update
description: Update TK to the latest version from GitHub
allowed-tools:
  - Bash
---

# /tk:update

Update TK to the latest version.

## Process

```bash
#!/bin/bash

echo "Updating TK..."

# Detect OS and set paths
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    CLAUDE_DIR="$USERPROFILE/.claude/commands"
else
    CLAUDE_DIR="$HOME/.claude/commands"
fi

TK_DIR="$CLAUDE_DIR/tk"
TMP_DIR=$(mktemp -d)
REPO="colbywest5/tk-Claude-Skill"

# Download latest
echo "Downloading latest from GitHub..."
curl -fsSL "https://raw.githubusercontent.com/$REPO/main/tk.md" -o "$TMP_DIR/tk.md"

for cmd in _shared map build design debug qa review clean doc deploy init resume learn opinion rules status tokens help update; do
    curl -fsSL "https://raw.githubusercontent.com/$REPO/main/commands/${cmd}.md" -o "$TMP_DIR/${cmd}.md" 2>/dev/null
done

# Backup current version
if [ -d "$TK_DIR" ]; then
    echo "Backing up current version..."
    cp -r "$TK_DIR" "$TK_DIR.backup.$(date +%Y%m%d%H%M%S)"
fi

# Install new version
echo "Installing..."
mkdir -p "$TK_DIR"
cp "$TMP_DIR/tk.md" "$CLAUDE_DIR/tk.md"
cp "$TMP_DIR/"*.md "$TK_DIR/"

# Cleanup
rm -rf "$TMP_DIR"

# Get version
VERSION=$(curl -fsSL "https://raw.githubusercontent.com/$REPO/main/package.json" 2>/dev/null | grep '"version"' | cut -d'"' -f4)

echo ""
echo "Updated to TK v${VERSION:-latest}"
echo "Run /tk:help to see all commands."
```

## PowerShell (Windows)

```powershell
Write-Host "Updating TK..." -ForegroundColor Cyan

$CLAUDE_DIR = "$env:USERPROFILE\.claude\commands"
$TK_DIR = "$CLAUDE_DIR\tk"
$REPO = "colbywest5/tk-Claude-Skill"
$BASE_URL = "https://raw.githubusercontent.com/$REPO/main"

# Create temp directory
$TMP_DIR = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }

# Download files
Write-Host "Downloading latest from GitHub..."
Invoke-WebRequest -Uri "$BASE_URL/tk.md" -OutFile "$TMP_DIR\tk.md"

$commands = @("_shared", "map", "build", "design", "debug", "qa", "review", "clean", "doc", "deploy", "init", "resume", "learn", "opinion", "rules", "status", "tokens", "help", "update")
foreach ($cmd in $commands) {
    try {
        Invoke-WebRequest -Uri "$BASE_URL/commands/$cmd.md" -OutFile "$TMP_DIR\$cmd.md" -ErrorAction SilentlyContinue
    } catch {}
}

# Backup current
if (Test-Path $TK_DIR) {
    Write-Host "Backing up current version..."
    $backup = "$TK_DIR.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item -Path $TK_DIR -Destination $backup -Recurse
}

# Install
Write-Host "Installing..."
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

## Backup

Before updating, creates a backup at:
```
~/.claude/commands/tk.backup.YYYYMMDDHHMMSS/
```

## Check Current Version

```bash
/tk:help   # Shows version at top
```
