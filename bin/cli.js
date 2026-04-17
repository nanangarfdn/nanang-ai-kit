#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const TEMPLATE_DIR = path.join(__dirname, '..', 'template');
const TARGET_DIR = process.cwd();

const args = process.argv.slice(2);
const command = args[0];

function copyDir(src, dest) {
  fs.mkdirSync(dest, { recursive: true });
  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      if (fs.existsSync(destPath)) {
        console.log(`  SKIP  ${path.relative(TARGET_DIR, destPath)} (already exists)`);
        continue;
      }
      fs.copyFileSync(srcPath, destPath);
      console.log(`  ADD   ${path.relative(TARGET_DIR, destPath)}`);
    }
  }
}

function makeExecutable(dir) {
  if (!fs.existsSync(dir)) return;
  const files = fs.readdirSync(dir);
  for (const file of files) {
    if (file.endsWith('.sh')) {
      const filePath = path.join(dir, file);
      fs.chmodSync(filePath, 0o755);
    }
  }
}

function showHelp() {
  console.log(`
nanang-ai-kit — AI-assisted development toolkit

Usage:
  npx nanang-ai-kit init     Scaffold .claude/ config into current project
  npx nanang-ai-kit help     Show this help message

After init, run /nng-init-nanang-ai in your AI assistant to auto-detect
your tech stack and generate project-specific rules.
`);
}

function init() {
  console.log('\nnanang-ai-kit — initializing...\n');

  // Check if .claude already exists
  const claudeDir = path.join(TARGET_DIR, '.claude');
  if (fs.existsSync(claudeDir)) {
    console.log('WARNING: .claude/ directory already exists.');
    console.log('Existing files will NOT be overwritten.\n');
  }

  // Copy template
  copyDir(TEMPLATE_DIR, TARGET_DIR);

  // Make hooks executable
  makeExecutable(path.join(TARGET_DIR, '.claude', 'hooks'));

  console.log('\nDone! Next steps:');
  console.log('  1. Open your AI coding assistant in this project');
  console.log('  2. Run /nng-init-nanang-ai to detect your tech stack');
  console.log('  3. Start coding\n');
}

switch (command) {
  case 'init':
    init();
    break;
  case 'help':
  case '--help':
  case '-h':
    showHelp();
    break;
  default:
    if (!command) {
      showHelp();
    } else {
      console.error(`Unknown command: ${command}`);
      console.error('Run "nanang-ai-kit help" for usage.');
      process.exit(1);
    }
}
