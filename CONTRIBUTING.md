# Contributing to TK

Thanks for your interest in contributing to TK.

## Ways to Contribute

### Report Issues
- Found a bug? Open an issue.
- Have a feature idea? Open an issue.
- Command not working as expected? Open an issue.

### Submit PRs
- Fork the repo
- Create a branch
- Make your changes
- Submit a PR

### Improve Documentation
- Fix typos
- Add examples
- Clarify confusing sections

## Development Setup

```bash
# Clone
git clone https://github.com/colbywest5/Toolkit.git
cd Toolkit

# Install locally to test
mkdir -p ~/.claude/commands/tk
cp tk.md ~/.claude/commands/
cp commands/* ~/.claude/commands/tk/

# Restart Claude Code and test
```

## Project Structure

```
Toolkit/
├── .claude-plugin/      # Plugin metadata
│   └── plugin.json
├── .github/             # GitHub Actions
│   └── workflows/
├── agents/              # SubAgent definitions
├── assets/              # Images, SVGs
├── bin/                 # CLI installer
├── commands/            # Slash commands
│   ├── _shared.md       # Shared behaviors (loaded by all)
│   ├── map.md
│   ├── build.md
│   └── ...
├── hooks/               # Event hooks
├── mcp/                 # MCP integration
├── scripts/             # Build/release scripts
├── tk.md                # Main router
├── package.json         # NPM package
└── README.md
```

## Command Guidelines

When adding or modifying commands:

1. **Load _shared.md** - All commands should import shared behaviors
2. **Support modes** - light/medium/heavy where applicable
3. **Document clearly** - Each command needs clear usage examples
4. **Enforce rules** - Check .tk/RULES.md before generating code
5. **Update help.md** - Add new commands to the help list
6. **Update plugin.json** - Add to the commands array

## Code Style

- Keep prompts concise (we're optimizing for tokens)
- No emojis in code or output
- No placeholder code
- Clear, actionable instructions

## Testing

Test your changes locally before submitting:

```bash
# Test the command in Claude Code
/tk:your-command light
/tk:your-command medium
/tk:your-command heavy
```

## Commit Messages

Use conventional commits:
```
feat: add new command
fix: correct behavior in build
docs: update README
chore: update dependencies
```

## Questions?

Open an issue or discussion.
