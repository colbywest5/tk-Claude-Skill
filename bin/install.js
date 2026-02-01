#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');
const readline = require('readline');

const VERSION = '1.1.0';

// ANSI colors
const colors = {
  reset: '\x1b[0m',
  cyan: '\x1b[36m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  dim: '\x1b[2m',
  bold: '\x1b[1m'
};

const banner = `
${colors.cyan}╔════════════════════════════════════════╗
║              TK v${VERSION}                  ║
║     Token-optimized Claude Commands    ║
╚════════════════════════════════════════╝${colors.reset}
`;

function log(msg, color = '') {
  console.log(`${color}${msg}${colors.reset}`);
}

function success(msg) {
  console.log(`${colors.green}✓${colors.reset} ${msg}`);
}

function getClaudeDir(global = true) {
  if (global) {
    return path.join(os.homedir(), '.claude', 'commands');
  }
  return path.join(process.cwd(), '.claude', 'commands');
}

function getSourceDir() {
  // When installed via npm, files are in the package directory
  return path.resolve(__dirname, '..');
}

function copyRecursive(src, dest) {
  if (!fs.existsSync(src)) {
    return;
  }
  
  const stat = fs.statSync(src);
  
  if (stat.isDirectory()) {
    if (!fs.existsSync(dest)) {
      fs.mkdirSync(dest, { recursive: true });
    }
    const files = fs.readdirSync(src);
    for (const file of files) {
      copyRecursive(path.join(src, file), path.join(dest, file));
    }
  } else {
    fs.copyFileSync(src, dest);
  }
}

function install(global = true) {
  const sourceDir = getSourceDir();
  const destDir = getClaudeDir(global);
  const tkDir = path.join(destDir, 'tk');
  
  // Create directories
  if (!fs.existsSync(destDir)) {
    fs.mkdirSync(destDir, { recursive: true });
  }
  if (!fs.existsSync(tkDir)) {
    fs.mkdirSync(tkDir, { recursive: true });
  }
  
  // Copy tk.md
  const tkMdSrc = path.join(sourceDir, 'tk.md');
  const tkMdDest = path.join(destDir, 'tk.md');
  if (fs.existsSync(tkMdSrc)) {
    fs.copyFileSync(tkMdSrc, tkMdDest);
    success('Installed tk.md');
  }
  
  // Copy commands/
  const commandsSrc = path.join(sourceDir, 'commands');
  if (fs.existsSync(commandsSrc)) {
    copyRecursive(commandsSrc, tkDir);
    success('Installed commands/');
  }
  
  log('');
  log(`Installed to: ${destDir}`, colors.dim);
  log('');
  log(`${colors.green}Done!${colors.reset} Run ${colors.cyan}/tk:help${colors.reset} in Claude Code to get started.`);
  log('');
}

function uninstall(global = true) {
  const destDir = getClaudeDir(global);
  const tkMd = path.join(destDir, 'tk.md');
  const tkDir = path.join(destDir, 'tk');
  
  if (fs.existsSync(tkMd)) {
    fs.unlinkSync(tkMd);
    success('Removed tk.md');
  }
  
  if (fs.existsSync(tkDir)) {
    fs.rmSync(tkDir, { recursive: true });
    success('Removed tk/ commands');
  }
  
  log('');
  log(`${colors.green}Uninstalled TK.${colors.reset}`);
}

async function prompt(question) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });
  
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer.trim().toLowerCase());
    });
  });
}

async function main() {
  const args = process.argv.slice(2);
  
  // Check for flags
  const isAuto = args.includes('--auto');
  const isGlobal = args.includes('--global') || args.includes('-g');
  const isLocal = args.includes('--local') || args.includes('-l');
  const isUninstall = args.includes('--uninstall');
  const showHelp = args.includes('--help') || args.includes('-h');
  
  if (showHelp) {
    console.log(`
TK Installer v${VERSION}

Usage:
  npx tk-claude-skill [options]

Options:
  --global, -g     Install globally (~/.claude/commands/)
  --local, -l      Install locally (./.claude/commands/)
  --uninstall      Remove TK
  --auto           Auto-install globally (for npm postinstall)
  --help, -h       Show this help
`);
    return;
  }
  
  console.log(banner);
  
  if (isUninstall) {
    uninstall(isGlobal || !isLocal);
    return;
  }
  
  if (isAuto || isGlobal) {
    install(true);
    return;
  }
  
  if (isLocal) {
    install(false);
    return;
  }
  
  // Interactive mode
  log('Where would you like to install TK?');
  log('');
  log('  1. Global (all projects) - ~/.claude/commands/');
  log('  2. Local (this project)  - ./.claude/commands/');
  log('');
  
  const answer = await prompt('Enter 1 or 2: ');
  
  if (answer === '1' || answer === 'global' || answer === 'g') {
    install(true);
  } else if (answer === '2' || answer === 'local' || answer === 'l') {
    install(false);
  } else {
    log('Installing globally by default...', colors.dim);
    install(true);
  }
}

main().catch(console.error);
