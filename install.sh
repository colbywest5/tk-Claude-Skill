#!/bin/bash

# TK - Token Killer Installer
# Works on: macOS, Linux, Windows (Git Bash, WSL, MSYS2)
# Usage: curl -fsSL https://raw.githubusercontent.com/colbywest5/tk-Claude-Skill/main/install.sh | bash

set -e

VERSION="1.1.0"
REPO="colbywest5/tk-Claude-Skill"
CYAN='\033[0;36m'
GREEN='\033[0;32m'
DIM='\033[2m'
RESET='\033[0m'

echo ""
echo -e "${CYAN}TK v${VERSION}${RESET}"
echo -e "${DIM}Token-optimized Claude Commands${RESET}"
echo ""

# Detect OS and set Claude commands directory
detect_claude_dir() {
    case "$(uname -s)" in
        Linux*)
            echo "$HOME/.claude/commands"
            ;;
        Darwin*)
            echo "$HOME/.claude/commands"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            # Windows via Git Bash, MSYS2, Cygwin
            if [ -n "$USERPROFILE" ]; then
                echo "$(cygpath -u "$USERPROFILE")/.claude/commands"
            else
                echo "$HOME/.claude/commands"
            fi
            ;;
        *)
            echo "$HOME/.claude/commands"
            ;;
    esac
}

CLAUDE_DIR=$(detect_claude_dir)
TK_DIR="$CLAUDE_DIR/tk"

# Parse arguments
for arg in "$@"; do
    case $arg in
        --local|-l)
            CLAUDE_DIR="./.claude/commands"
            TK_DIR="./.claude/commands/tk"
            ;;
        --global|-g)
            # Already set to global
            ;;
        --uninstall)
            echo "Uninstalling TK..."
            rm -f "$CLAUDE_DIR/tk.md" 2>/dev/null || true
            rm -rf "$TK_DIR" 2>/dev/null || true
            echo -e "${GREEN}+${RESET} Uninstalled TK"
            exit 0
            ;;
        --help|-h)
            echo "Usage: install.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --global, -g     Install globally (default)"
            echo "  --local, -l      Install to current project"
            echo "  --uninstall      Remove TK"
            echo "  --help, -h       Show this help"
            exit 0
            ;;
    esac
done

# Create temp directory (cross-platform)
TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'tk-install')
trap "rm -rf '$TMP_DIR'" EXIT

echo -e "${DIM}Downloading from GitHub...${RESET}"

# Download main file
curl -fsSL "https://raw.githubusercontent.com/$REPO/main/tk.md" -o "$TMP_DIR/tk.md"

# Download command files
mkdir -p "$TMP_DIR/commands"
COMMANDS="_shared map build design debug qa review clean doc deploy init resume learn opinion rules status tokens help update"
for cmd in $COMMANDS; do
    curl -fsSL "https://raw.githubusercontent.com/$REPO/main/commands/${cmd}.md" -o "$TMP_DIR/commands/${cmd}.md" 2>/dev/null || true
done

# Create directories
mkdir -p "$CLAUDE_DIR"
mkdir -p "$TK_DIR"

# Install files
cp "$TMP_DIR/tk.md" "$CLAUDE_DIR/tk.md"
echo -e "${GREEN}+${RESET} Installed tk.md"

cp "$TMP_DIR/commands/"*.md "$TK_DIR/" 2>/dev/null || cp $TMP_DIR/commands/*.md "$TK_DIR/"
echo -e "${GREEN}+${RESET} Installed commands/"

echo ""
echo -e "${DIM}Installed to: $CLAUDE_DIR${RESET}"
echo ""
echo -e "${GREEN}Done!${RESET} Run /tk:help in Claude Code to get started."
echo ""
