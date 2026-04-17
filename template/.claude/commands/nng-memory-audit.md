Audit and cleanup memory files + learnings health check.

Usage: /memory-audit

## Steps

### Memory Audit
1. Find the project memory directory (check `~/.claude/projects/` for matching project path)
2. Read `MEMORY.md` index
3. Read each indexed memory file
4. For each memory, evaluate:
   - Still relevant? (check if project context is still valid)
   - Duplicates? (same info in 2+ memory files)
   - Outdated? (>30 days without update = flag for review)
   - Mergeable? (small memories with overlapping topics)
   - Contradictions? (memory says X but codebase says Y)

### Learnings Health Check
5. Read `.claude/learnings/nng-index.md`
6. For each learnings file:
   - Count entries
   - Check for stale entries (>60 days, may no longer apply)
   - Check for entries that should graduate to rules (appeared 3+ times)
7. Check `.claude/daily/` for unprocessed logs (suggest running /nng-reflect)

### Report
8. Output health score (0-100):
   - 100: All memories current, no duplicates, learnings growing
   - Deductions: -5 per stale memory, -10 per contradiction, -5 per unprocessed daily log, -10 if learnings index >100 lines
9. Recommendations:
   - Keep as-is
   - Needs update (with suggested changes)
   - Stale/duplicate (recommend removal)
   - Missing memories (recommend creation)
   - Learnings ready to graduate to rules

Output in English.
