Synthesize patterns from daily session logs and learnings.

Usage: /reflect

## When to Run
- Weekly review
- When `.claude/daily/` has 5+ days of logs
- After a complex debugging session
- User explicitly asks to reflect

## Steps

### 1. Gather Data
- Read all files in `.claude/daily/*.md` (skip archive/)
- Read `.claude/learnings/nng-index.md`
- Read each learnings detail file that has entries

### 2. Detect Patterns
For each daily log, look for:
- **Repeated mistakes** — same error/correction 2+ times → create/strengthen feedback memory
- **Debugging patterns** — problem→cause→solution chains → add to `.claude/learnings/nng-debugging.md`
- **Workflow friction** — repeated manual steps → add to `.claude/learnings/nng-workflow.md`
- **Tool/API surprises** — unexpected behavior → add to `.claude/learnings/nng-api-quirks.md`

### 3. Propose Updates (DO NOT auto-apply)
Show a summary table:
| Type | Target File | Change | Confidence |
|------|------------|--------|------------|
| feedback | memory/feedback_X.md | New/Update | High/Medium |
| learning | learnings/debugging.md | New entry | High |
| rule | rules/ or CLAUDE.md | New rule | Low |

For each proposed change, show the exact content that would be added.
Ask user to approve each change before applying.

### 4. Archive Processed Logs
After user approves/rejects changes:
- Move processed daily logs to `.claude/daily/archive/`
- Update `.claude/learnings/nng-index.md` with new entry summaries

### 5. Report
Output:
- Number of daily logs processed
- Patterns found (count by type)
- Changes applied
- Current learnings/nng-index.md line count (warn if >100)

## Output
All output in English.
