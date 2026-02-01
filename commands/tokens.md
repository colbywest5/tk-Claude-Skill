---
name: tk:tokens
description: Show TK command file sizes
allowed-tools:
  - Bash
---

# /tk:tokens

Show actual file sizes for TK commands.

## Process

```bash
echo "TK Command File Sizes"
echo "====================="
echo ""

# Find TK commands directory
if [ -d "$HOME/.claude/commands/tk" ]; then
    TK_DIR="$HOME/.claude/commands/tk"
elif [ -d "${USERPROFILE}/.claude/commands/tk" ]; then
    TK_DIR="${USERPROFILE}/.claude/commands/tk"
else
    TK_DIR=".claude/commands/tk"
fi

# List files by size
ls -lhS "$TK_DIR"/*.md 2>/dev/null | awk '{print $9, $5}' | while read file size; do
    name=$(basename "$file" .md)
    printf "%-15s %s\n" "$name" "$size"
done

echo ""
echo "---------------------"
total=$(du -sh "$TK_DIR" 2>/dev/null | cut -f1)
echo "Total: $total"
```

## What This Shows

File sizes on disk. That's it. No fake token estimates.
