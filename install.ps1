# TK - Toolkit Installer (PowerShell)
# Works on: Windows PowerShell, PowerShell Core (Windows/Mac/Linux)
# Usage: irm https://raw.githubusercontent.com/colbywest5/Toolkit/main/install.ps1 | iex

param(
    [switch]$Local,
    [switch]$Global,
    [switch]$Uninstall,
    [switch]$Help
)

$VERSION = "1.1.0"
$REPO = "colbywest5/Toolkit"
$BASE_URL = "https://raw.githubusercontent.com/$REPO/main"

function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

if ($Help) {
    Write-Host @"

TK Installer v$VERSION

Usage:
  .\install.ps1 [OPTIONS]
  irm .../install.ps1 | iex

Options:
  -Global      Install globally (default)
  -Local       Install to current project
  -Uninstall   Remove TK
  -Help        Show this help

"@
    exit 0
}

Write-Host ""
Write-Color "TK v$VERSION" "Cyan"
Write-Color "Developer Toolkit for Claude Code" "DarkGray"
Write-Host ""

# Detect Claude directory based on OS
if ($IsWindows -or $env:OS -eq "Windows_NT") {
    $CLAUDE_DIR = Join-Path $env:USERPROFILE ".claude\commands"
} elseif ($IsMacOS) {
    $CLAUDE_DIR = Join-Path $env:HOME ".claude/commands"
} else {
    $CLAUDE_DIR = Join-Path $env:HOME ".claude/commands"
}

if ($Local) {
    $CLAUDE_DIR = Join-Path (Get-Location) ".claude\commands"
}

$TK_DIR = Join-Path $CLAUDE_DIR "tk"

if ($Uninstall) {
    Write-Color "Uninstalling TK..." "Yellow"
    
    $tkMd = Join-Path $CLAUDE_DIR "tk.md"
    if (Test-Path $tkMd) {
        Remove-Item $tkMd -Force
        Write-Color "+ Removed tk.md" "Green"
    }
    
    if (Test-Path $TK_DIR) {
        Remove-Item $TK_DIR -Recurse -Force
        Write-Color "+ Removed tk/ commands" "Green"
    }
    
    Write-Host ""
    Write-Color "Uninstalled TK." "Green"
    exit 0
}

# Create temp directory
$TMP_DIR = Join-Path ([System.IO.Path]::GetTempPath()) "tk-install-$(Get-Random)"
New-Item -ItemType Directory -Path $TMP_DIR -Force | Out-Null

try {
    Write-Color "Downloading from GitHub..." "DarkGray"

    # Download main file
    Invoke-WebRequest -Uri "$BASE_URL/tk.md" -OutFile (Join-Path $TMP_DIR "tk.md") -UseBasicParsing

    # Download command files
    $commandsDir = Join-Path $TMP_DIR "commands"
    New-Item -ItemType Directory -Path $commandsDir -Force | Out-Null

    $commands = @("_shared", "map", "build", "design", "debug", "qa", "review", "clean", "doc", "deploy", "init", "resume", "learn", "opinion", "rules", "status", "tokens", "help", "update")
    foreach ($cmd in $commands) {
        try {
            Invoke-WebRequest -Uri "$BASE_URL/commands/$cmd.md" -OutFile (Join-Path $commandsDir "$cmd.md") -UseBasicParsing -ErrorAction SilentlyContinue
        } catch {
            # Ignore missing files
        }
    }

    # Create directories
    New-Item -ItemType Directory -Path $CLAUDE_DIR -Force | Out-Null
    New-Item -ItemType Directory -Path $TK_DIR -Force | Out-Null

    # Install files
    Copy-Item (Join-Path $TMP_DIR "tk.md") (Join-Path $CLAUDE_DIR "tk.md") -Force
    Write-Color "+ Installed tk.md" "Green"

    Copy-Item (Join-Path $commandsDir "*.md") $TK_DIR -Force
    Write-Color "+ Installed commands/" "Green"

    Write-Host ""
    Write-Color "Installed to: $CLAUDE_DIR" "DarkGray"
    Write-Host ""
    Write-Color "Done! " "Green" -NoNewline
    Write-Host "Run /tk:help in Claude Code to get started."
    Write-Host ""

} finally {
    # Cleanup
    if (Test-Path $TMP_DIR) {
        Remove-Item $TMP_DIR -Recurse -Force -ErrorAction SilentlyContinue
    }
}
