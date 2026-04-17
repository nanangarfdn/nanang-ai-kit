# nanang-ai-kit

**A drop-in toolkit that makes AI coding assistants learn, remember, and improve over time.**

[![npm version](https://img.shields.io/npm/v/nanang-ai-kit.svg)](https://www.npmjs.com/package/nanang-ai-kit)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![npm downloads](https://img.shields.io/npm/dm/nanang-ai-kit.svg)](https://www.npmjs.com/package/nanang-ai-kit)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/nanangarfdn/nanang-ai-kit)

---

## The Problem

AI coding assistants are powerful, but they suffer from fundamental limitations:

| Problem | What happens |
|---------|-------------|
| **No memory** | You correct the same mistake three times in one week. The assistant never learns. |
| **Token waste** | The assistant restates your question, adds filler phrases, re-reads files it already has in context. You burn tokens on nothing. |
| **Context loss** | Mid-session, the context window compacts. Your assistant forgets what files it was editing and what it was trying to do. |
| **Shotgun debugging** | The assistant tries random fixes without investigating the root cause. Three failed attempts later, the code is worse than before. |
| **No project awareness** | Every new session starts from zero. The assistant doesn't know your tech stack, conventions, or project structure. |

These problems compound. A session that should take 10 minutes takes 40. Tokens that should cost $2 cost $8. Fixes that should be one attempt take five.

## The Solution

**nanang-ai-kit** is a portable, framework-agnostic toolkit that gives any AI coding assistant:

- **Persistent memory** that captures corrections and turns them into lasting behavioral changes
- **Token efficiency rules** that cut waste by 40-60% without losing output quality
- **Structured debugging discipline** that prevents random fix attempts
- **Project-aware initialization** that auto-detects your tech stack on first run
- **Self-improving feedback loops** where daily logs become weekly learnings become permanent rules

Copy it into any project. Run one command. The assistant gets smarter from day one -- and keeps getting smarter.

---

## Features

### Smart Init (`/nng-init-nanang-ai`)

One command scans your entire workspace and generates project-specific configuration:

```
/nng-init-nanang-ai
```

The init command detects:

- **Package managers & languages** -- `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `pom.xml`, `Gemfile`, `composer.json`, `pubspec.yaml`, `*.csproj`
- **Frameworks** -- React, Next.js, Vue, Svelte, Angular, Express, FastAPI, Django, and more
- **Linters & formatters** -- ESLint, Prettier, Biome, Ruff, RuboCop, Rustfmt
- **Test frameworks** -- Vitest, Jest, Pytest, Go test, RSpec, PHPUnit
- **Build tools** -- Vite, Webpack, Turborepo, Nx, Make, Docker
- **Infrastructure** -- TypeScript config, Docker Compose, Vercel, Netlify, GitHub Actions

It then generates three project-specific files:

| Generated file | Contents |
|---------------|----------|
| `.claude/rules/nng-code-style.md` | Naming conventions, formatting rules, import patterns extracted from your linter config |
| `.claude/rules/nng-testing.md` | Test runner commands, file patterns, mocking conventions for your framework |
| `.claude/commands/nng-verify.md` | A single verify command wired to your project's lint, typecheck, and test scripts |

It also appends your detected tech stack, project structure, and run commands to `CLAUDE.md`.

These generated files are `.gitignore`'d by default -- they are machine-specific and regenerated per workspace.

---

### Self-Learning Memory System

The core innovation of nanang-ai-kit. Three hooks work together to create a feedback loop where the assistant genuinely improves over time.

```
 USER CORRECTS ASSISTANT          ASSISTANT WORKS             SESSION ENDS
         |                              |                          |
         v                              v                          v
 +-----------------+           +------------------+       +------------------+
 | Correction      |           | Session Digest   |       | Daily Log        |
 | Detector Hook   |           | Hook (PostResp)  |       | Command          |
 +-----------------+           +------------------+       +------------------+
         |                              |                          |
         v                              v                          v
 .correction-detected          .claude/daily/YYYY-MM-DD.md   DAILY-LOG/YYYY-MM-DD.md
         |                              |
         v                              |
 Memory auto-save                       |
 (feedback type)                        |
                                        v
                              +------------------+
                              | /nng-reflect     |
                              | (weekly)         |
                              +------------------+
                                        |
                         +--------------+--------------+
                         |              |              |
                         v              v              v
                   learnings/     learnings/     learnings/
                   debugging.md   workflow.md    api-quirks.md
                         |
                         v
                   Patterns graduate
                   to permanent rules
```

**How each piece works:**

**Correction Detector** (`UserPromptSubmit` hook) -- Monitors every user prompt for correction signals: "no,", "wrong", "revert", "you forgot", "should be", "instead of", "don't do", "i meant", and more. When detected, it writes a `.correction-detected` flag. The assistant reads this flag and auto-saves the correction context as a feedback memory, so the same mistake is never repeated.

**Session Digest** (`PostResponse` hook) -- After each substantial assistant response (500+ characters), appends a timestamped summary to `.claude/daily/YYYY-MM-DD.md`. This creates a raw activity log without any manual effort.

**Precompact Guard** (`PreCompact` hook) -- Before the context window compresses, saves the current working state -- files being modified, active debugging context, timestamp -- to `compaction-state.md`. When the session resumes post-compaction, the assistant reads this file to restore context instead of starting from scratch.

**Reflect Command** (`/nng-reflect`) -- Processes accumulated daily logs, detects patterns (repeated mistakes, debugging chains, workflow friction, API surprises), and proposes updates to learnings files. Changes are shown in a summary table with confidence levels and require explicit user approval before being applied. Processed logs are archived.

---

### Token Efficiency

Rules in `nng-token-efficiency.md` that train the assistant to stop wasting tokens:

**Response discipline:**
- No preambles ("Sure!", "Certainly!", "I'd be happy to...")
- No trailing summaries restating what was just done
- No restating the user's question before answering
- Elaborate only when explicitly asked

**Tool discipline:**
- Batch independent tool calls into a single message
- Use `offset`/`limit` for large file reads, `head_limit` for grep
- Never re-read files already in the context window
- Use Glob/Grep for simple searches, Agent only for deep exploration

**Code output discipline:**
- No unnecessary comments on unchanged code
- No over-engineering beyond what was asked
- No unsolicited "improvement" suggestions

**Measured impact:** In real-world usage across multi-session projects, these rules consistently reduce token consumption by 40-60% compared to unconfigured assistants performing identical tasks.

---

### Multi-Agent Orchestration

Rules in `nng-multi-agent.md` that enable parallel background execution for complex tasks:

```
                    User assigns task
                          |
              +-----------+-----------+
              |                       |
     Independent areas?          Sequential?
              |                       |
     +--------+--------+        Single agent
     |        |        |        (background)
   Agent A  Agent B  Agent C
   (bg)     (bg)     (bg)
     |        |        |
     +--------+--------+
              |
        User notified
        on completion
```

**Decision table:**

| Condition | Approach |
|-----------|----------|
| Multiple independent files or areas | Multi-agent parallel, all in background |
| Single file or sequential logic | Single agent, background |
| Quick read, grep, or simple question | Handle directly, no agent |
| User says "don't use agents" | Handle directly |

**Conflict resolution for same-file edits:**
1. Each agent gets a clearly separated scope (no overlap)
2. Agent prompts include warnings about which other agents are touching which files
3. If an edit fails because the file changed, the agent re-reads and retries
4. Agents never touch sections outside their assigned scope

---

### Debugging Discipline

A 4-phase structured methodology in `nng-debugging.md` that prevents the most common AI debugging failure mode: random fix attempts.

```
Phase 1: INVESTIGATE          Phase 2: COMPARE
+------------------------+    +------------------------+
| - Read FULL error msg  |    | - Find WORKING example |
| - Reproduce it         |--->| - Diff broken vs work  |
| - Trace data flow      |    | - Check known issues   |
|   backward             |    |                        |
+------------------------+    +------------------------+
                                         |
Phase 4: FIX                  Phase 3: HYPOTHESIS
+------------------------+    +------------------------+
| - Write failing test   |    | - ONE specific theory  |
| - Single root-cause fix|<---| - MINIMAL change test  |
| - Verify no regressions|    | - Wrong? Back to Ph.1  |
+------------------------+    +------------------------+
```

**The Hard Stop rule:** After 3 failed fix attempts, the assistant stops and asks the user. No 4th attempt. This prevents the destructive spiral where each "fix" makes the code worse.

**Red flags that force a return to Phase 1:**
- "Just try changing this" without understanding why
- A fix that suppresses the error without solving the cause
- Adding workarounds on top of workarounds

---

### Explore Mode (`/nng-explore`)

A dedicated thinking-partner mode for brainstorming before writing code.

```
/nng-explore [topic]
```

In explore mode, the assistant:

- Asks clarifying questions and challenges assumptions
- Maps existing architecture by reading the actual codebase
- Builds comparison tables for multiple approaches
- Draws ASCII diagrams for system architecture, data flows, state machines
- Surfaces risks, unknowns, and gaps in understanding

**The critical guardrail:** Explore mode never writes code. It reads, searches, investigates, diagrams, and discusses -- but implementation happens only after exiting explore mode. This prevents the common failure of jumping into code before understanding the problem.

When things crystallize, the session ends with a structured summary: the problem (crystallized), the approach (if one emerged), open questions, and concrete next steps.

---

### Health Check (`/nng-health-check`)

One command to run your project's full verification pipeline:

```
/nng-health-check
```

Auto-detects and runs the appropriate commands for your stack:

| Check | Node.js | Python | Go | Rust |
|-------|---------|--------|----|------|
| Lint | `npm run lint` / `npx eslint .` / `npx biome check .` | `ruff check .` / `flake8` | `golangci-lint run` | `cargo clippy` |
| Typecheck | `npx tsc --noEmit` | `mypy .` / `pyright` | `go vet ./...` | `cargo check` |
| Test | `npm test` / `npx vitest run` | `pytest` | `go test ./...` | `cargo test` |

Stops on first failure. Shows the first 20 lines of errors, not a wall of output. If `/nng-init-nanang-ai` has been run, uses the project-specific commands from `nng-verify.md` instead of auto-detection.

---

### Memory Audit (`/nng-memory-audit`)

Periodic maintenance for your assistant's accumulated knowledge:

```
/nng-memory-audit
```

Checks for:
- **Stale memories** (>30 days without update)
- **Duplicate entries** (same information in multiple files)
- **Contradictions** (memory says X but codebase says Y)
- **Mergeable memories** (small files with overlapping topics)
- **Unprocessed daily logs** (suggests running `/nng-reflect`)
- **Learnings ready to graduate** (patterns that appeared 3+ times become permanent rules)

Outputs a health score (0-100) with specific recommendations: keep, update, merge, or remove.

---

### Daily Log (`/nng-daily-log`)

Generates an outcome-focused summary of the day's work:

```
/nng-daily-log
```

Collects activity from modified files, git history, and conversation context. Groups by module or area. Writes to `DAILY-LOG/YYYY-MM-DD.md`. Appends if the file already exists.

The daily log is deliberately high-level: what was achieved, not which files changed. No file paths, no line numbers, no code blocks. Written for a team lead, not a compiler.

---

## How It Works

The complete feedback loop from first correction to permanent behavioral improvement:

```
DAY 1                          DAY 2-4                        WEEK 1+
=====                          =======                        =======

User corrects assistant        Session digest logs            /nng-reflect processes
         |                     daily activity                 daily logs
         v                            |                            |
Correction detector fires              v                            v
         |                     .claude/daily/                  Detects patterns:
         v                     2024-01-15.md                   - Repeated mistakes
.correction-detected           2024-01-16.md                   - Debugging chains
         |                     2024-01-17.md                   - Workflow friction
         v                                                          |
Memory auto-saved                                                   v
(feedback type)                                               Proposes updates to:
         |                                                    learnings/debugging.md
         v                                                    learnings/workflow.md
Next session: assistant                                       learnings/api-quirks.md
reads memories, avoids                                              |
repeating the mistake                                               v
                                                              3+ occurrences =
                                                              graduates to
                                                              permanent rule
```

The system is designed so that **no manual maintenance is required for basic operation**. Hooks fire automatically. Memories save automatically on corrections. The only manual steps are running `/nng-reflect` weekly and `/nng-memory-audit` periodically.

---

## Quick Start

### Option 1: npm (recommended)

```bash
npx nanang-ai-kit init
```

### Option 2: Manual

1. Copy `template/.claude/` and `template/CLAUDE.md` into your project root
2. Make hooks executable: `chmod +x .claude/hooks/*.sh`

### Then

Run `/nng-init-nanang-ai` in your AI assistant to auto-detect your tech stack.

The toolkit is now active. Hooks fire automatically. Rules are loaded on every session. Run commands as needed:

```
/nng-explore authentication     # Think before implementing
/nng-health-check               # After making changes
/nng-daily-log                  # End of session
/nng-reflect                    # Weekly review
/nng-memory-audit               # Monthly cleanup
```

---

## Directory Structure

```
your-project/
  CLAUDE.md                              # Main config -- token rules, memory, commands reference
  .claude/
    settings.local.json                  # Hook registrations (correction, precompact, digest)
    rules/
      nng-debugging.md                   # 4-phase debugging discipline
      nng-multi-agent.md                 # Parallel background execution patterns
      nng-token-efficiency.md            # Token waste reduction rules
      nng-code-style.md                  # [generated] Project-specific style rules
      nng-testing.md                     # [generated] Project-specific test conventions
    commands/
      nng-init-nanang-ai.md              # Auto-detect tech stack, generate config
      nng-daily-log.md                   # Generate daily work summary
      nng-health-check.md               # Run lint + typecheck + test
      nng-explore.md                     # Thinking partner mode
      nng-memory-audit.md               # Audit memory + learnings health
      nng-reflect.md                     # Synthesize daily logs into learnings
      nng-verify.md                      # [generated] Project-specific verify command
    hooks/
      nng-correction-detector.sh         # Detects user corrections, flags for memory
      nng-precompact-guard.sh            # Saves state before context compaction
      nng-session-digest.sh              # Logs session activity for daily/reflect
    learnings/
      nng-index.md                       # Learnings index with stats
      debugging.md                       # [grows] Problem-cause-solution patterns
      workflow.md                        # [grows] Process improvements
      api-quirks.md                      # [grows] Unexpected API behaviors
    daily/                               # [auto] Session activity logs
      archive/                           # [auto] Processed logs moved here by /reflect
    compaction-state.md                  # [auto] Context saved before compaction
    .correction-detected                 # [auto] Flag file, ephemeral
  DAILY-LOG/                             # [auto] Human-readable daily summaries
```

Files marked `[generated]` are created by `/nng-init-nanang-ai` and `.gitignore`'d.
Files marked `[grows]` accumulate entries over time via `/nng-reflect`.
Files marked `[auto]` are created and managed by hooks automatically.

---

## Commands Reference

| Command | Purpose | When to use | What it does |
|---------|---------|-------------|--------------|
| `/nng-init-nanang-ai` | Project setup | First time in a new project | Scans workspace for `package.json`, `pyproject.toml`, `go.mod`, etc. Detects frameworks, linters, test runners, build tools. Generates `nng-code-style.md`, `nng-testing.md`, `nng-verify.md`. Updates `CLAUDE.md` with detected stack. |
| `/nng-daily-log` | Daily summary | End of each session | Collects modified files (mtime today), git log, and conversation context. Groups by module. Writes outcome-focused summary to `DAILY-LOG/YYYY-MM-DD.md`. Appends if file exists. |
| `/nng-health-check` | Verification | After making changes | Auto-detects lint/typecheck/test commands for your stack. Runs in sequence, stops on first failure. Shows first 20 lines of errors. Uses `nng-verify.md` if it exists. |
| `/nng-explore` | Brainstorming | Before implementing anything complex | Enters thinking-partner mode. Reads code, asks questions, draws diagrams, compares approaches. Never writes code. Ends with structured summary of findings. |
| `/nng-memory-audit` | Maintenance | Monthly or when things feel stale | Reads all memory files + learnings. Checks for staleness (>30d), duplicates, contradictions, merge candidates. Outputs health score 0-100 with recommendations. |
| `/nng-reflect` | Pattern synthesis | Weekly or after 5+ daily logs | Reads `.claude/daily/*.md`, detects repeated mistakes, debugging patterns, workflow friction, API surprises. Proposes updates with confidence levels. Requires user approval. Archives processed logs. |

---

## Hooks Reference

All hooks are registered in `.claude/settings.local.json` and fire automatically.

### Correction Detector

| Property | Value |
|----------|-------|
| **File** | `.claude/hooks/nng-correction-detector.sh` |
| **Trigger** | `UserPromptSubmit` -- fires on every user message |
| **What it does** | Scans the user's prompt for correction patterns |
| **Output** | Writes matched pattern to `.claude/.correction-detected` |

Detected patterns: `"no,"`, `"not that"`, `"wrong"`, `"revert"`, `"undo"`, `"you forgot"`, `"should be"`, `"instead of"`, `"don't do"`, `"stop doing"`, `"shouldn't"`, `"that's not"`, `"i said"`, `"i meant"`, `"not what i"`.

The assistant checks for this flag file at session start and auto-saves a feedback memory with the correction context.

### Precompact Guard

| Property | Value |
|----------|-------|
| **File** | `.claude/hooks/nng-precompact-guard.sh` |
| **Trigger** | `PreCompact` -- fires before context window compression |
| **What it does** | Extracts file paths and debugging context from the transcript |
| **Output** | Writes `compaction-state.md` with files, context notes, timestamp |

This prevents the most frustrating AI assistant failure: losing track of what it was doing mid-task. After compaction, the assistant reads `compaction-state.md` to resume seamlessly.

### Session Digest

| Property | Value |
|----------|-------|
| **File** | `.claude/hooks/nng-session-digest.sh` |
| **Trigger** | `PostResponse` -- fires after each assistant response |
| **What it does** | For responses over 500 characters, appends a timestamped summary to the daily log |
| **Output** | Appends to `.claude/daily/YYYY-MM-DD.md` |

This creates the raw material that `/nng-reflect` later processes into learnings. No manual logging required.

---

## Customization

### Adding your own rules

Create any `.md` file in `.claude/rules/` and it will be automatically loaded:

```markdown
# My Custom Rule

## Database
- Always use parameterized queries
- Never use SELECT *

## API Design
- Return 404 for missing resources, not empty 200
```

Prefix with `nng-` if you want to distinguish kit rules from your own project rules.

### Adding your own commands

Create a `.md` file in `.claude/commands/`:

```markdown
Deploy to staging environment.

Usage: /my-deploy

## Steps
1. Run `npm run build`
2. Run `npm run deploy:staging`
3. Report deployment URL
```

The filename (without `.md`) becomes the command name.

### Adding your own hooks

Add entries to `.claude/settings.local.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "type": "command",
        "command": "bash .claude/hooks/my-custom-hook.sh"
      }
    ]
  }
}
```

Available hook triggers: `UserPromptSubmit`, `PreCompact`, `PostResponse`.

Hooks receive JSON input on stdin and must output `{"continue":true}` to allow the operation to proceed.

### Sharing learnings with your team

By default, learnings files are `.gitignore`'d (they contain individual workflow patterns). To share them:

1. Edit `.gitignore` and uncomment `!.claude/learnings/*.md`
2. Commit the learnings files
3. Team members benefit from accumulated debugging patterns and API quirks

---

## Supported Tech Stacks

`/nng-init-nanang-ai` auto-detects the following:

| Category | Detected technologies |
|----------|----------------------|
| **Languages** | JavaScript, TypeScript, Python, Go, Rust, Java, Kotlin, Ruby, PHP, Dart, C# |
| **Frontend** | React, Vue, Svelte, Angular, Next.js, Nuxt, SvelteKit |
| **Backend** | Express, Fastify, Hono, NestJS, Django, Flask, FastAPI |
| **Mobile** | React Native, Expo, Flutter |
| **Linters** | ESLint, Biome, Prettier, Ruff, RuboCop, Rustfmt |
| **Test runners** | Vitest, Jest, Pytest, Go test, RSpec, PHPUnit |
| **Build tools** | Vite, Webpack, Turborepo, Nx, Make, Docker |
| **Deployment** | Vercel, Netlify, Docker Compose, GitHub Actions |
| **Config** | TypeScript (strict mode, paths), environment variables |

If your stack is not listed, `/nng-init-nanang-ai` generates sensible defaults and you can customize the generated rule files.

---

## Philosophy

### Init once, adapt always

`/nng-init-nanang-ai` reads your workspace and generates rules that match your stack. You run it once. From that point on, the system adapts through corrections, daily logs, and reflections -- not through manual configuration.

### Token-efficient by design

Every rule, hook, and command is designed to minimize wasted tokens. No filler phrases. No re-reading files. No restating questions. No unsolicited suggestions. The assistant does exactly what was asked, in the fewest tokens possible.

### Self-improving

Corrections become memories. Daily logs become weekly learnings. Patterns that appear three or more times graduate to permanent rules. The assistant today is measurably better than the assistant last month -- on your specific project, with your specific conventions.

### No lock-in

nanang-ai-kit is a collection of markdown files and shell scripts. There is no runtime dependency. No package to install. No API key. No cloud service. It works with any AI coding assistant that supports the `.claude/` convention. If you stop using it, delete the `.claude/` directory and nothing breaks.

---

## Contributing

Contributions are welcome. The most valuable contributions are:

- **New detection targets** for `/nng-init-nanang-ai` (additional languages, frameworks, build tools)
- **Correction patterns** for the correction detector hook (phrases in other languages, additional English patterns)
- **Rule templates** for specific tech stacks or domains
- **Bug reports** with reproduction steps

Please open an issue before submitting large changes.

---

## License

MIT
