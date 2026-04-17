Generate daily log of today's work. Save to `DAILY-LOG/{YYYY-MM-DD}.md`.

Usage: /daily-log

## Steps

1. Resolve today's date (YYYY-MM-DD)
2. `mkdir -p DAILY-LOG`
3. Target: `DAILY-LOG/{YYYY-MM-DD}.md`

4. Collect activity from:
   - **Files modified today** (mtime = today): scan src directories
     ```bash
     find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.rb" -o -name "*.java" -o -name "*.kt" -o -name "*.md" \) -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/dist/*" -not -path "*/.claude/*" -mtime -1 2>/dev/null | head -50
     ```
   - **Git activity** (if repo): `git log --since="today" --oneline`
   - **Conversation context**: this session's requests + actions taken

5. Group by **module / area** (auto-detect from directory structure)

6. Write file:

   ```markdown
   # Daily Log — {YYYY-MM-DD}

   ## Summary
   - {1-3 sentence high-level summary}

   ## {Area 1}
   - {what changed, why}

   ## {Area 2}
   - {...}

   ## Notes / Blockers
   - {open questions, deferred items}
   ```

7. If file already exists → **append** `## Update {HH:MM}` instead of overwrite

## Style
- Outcome-focused: what was achieved, not what file changed
- No file paths, line numbers, or function names
- No code blocks
- Bullet points only, concise
- Skip empty sections

## Anti-Patterns
- Don't list every file modified — describe outcomes
- Don't include implementation details
- Don't duplicate content from learnings
