# Project Configuration

> **First time?** Run `/nng-init-nanang-ai` to auto-detect your tech stack and generate project-specific rules.

## Token Efficiency

### Response
- Direct answers, no preambles/acknowledgments
- Elaborate only when asked

### Tools
- Batch tool calls when possible
- Use limits: read (offset/limit), grep (head_limit 50-100)
- Reference context already in window, don't re-read

### Code
- Working, efficient, readable
- No unnecessary comments

### Output
- No confirmations unless destructive
- Reference format: `file.ts:123`

## Memory Auto-Save
- Save memory when user corrects approach → `feedback` type
- Save memory when learning new project context → `project` type
- Save memory when user shares preference/habit → `user` type
- Check existing memory first before creating new — update if already exists

## Self-Improvement
- After completing a complex task (5+ tool calls), check if a learning should be saved
- When a command/rule is wrong or outdated, update it immediately
- After debugging a tricky issue, save pattern to `.claude/learnings/nng-debugging.md`
- Read `.claude/learnings/nng-index.md` when starting work to avoid re-discovering known issues

## On Context Compaction
Always preserve:
- Current task objective
- Files currently being modified (full paths)
- Any test results or validation findings
- Active debugging hypothesis

## Commands

| Command | When to Use |
|---------|-------------|
| `/nng-init-nanang-ai` | First setup — scans workspace, generates project-specific rules |
| `/nng-daily-log` | End of session — generate daily work summary |
| `/nng-health-check` | After changes — run lint + typecheck + test |
| `/nng-explore` | Before implementing — brainstorm and think through approach |
| `/nng-memory-audit` | Periodic — cleanup stale memories and learnings |
| `/nng-reflect` | Weekly — synthesize patterns from daily logs |

<!-- GENERATED SECTION — /nng-init-nanang-ai writes below this line -->
<!-- Do not edit below manually. Re-run /nng-init-nanang-ai to regenerate. -->
