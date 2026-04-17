# Token Efficiency

## Response
- Direct answers, no preambles or acknowledgments
- No filler: "Sure!", "Certainly!", "I'd be happy to..."
- Elaborate only when asked
- Skip trailing summaries of what was just done

## Tool Usage
- Batch independent tool calls into a single message
- Use read limits: offset/limit for large files, head_limit for grep
- Never re-read files already in context window
- Use Glob/Grep directly for simple searches, Agent only for deep exploration

## Code Output
- No unnecessary comments or docstrings on unchanged code
- No over-engineering: solve what was asked, nothing more
- No "improvement" suggestions unless requested

## Context Management
- Use `/clear` between unrelated tasks to reset context
- Use subagent for: parallel research, deep codebase exploration, isolated tasks
- Don't use subagent for: simple file reads, single grep, quick edits

## Anti-Patterns
- Reading the same file twice in one conversation
- Adding explanatory comments to self-evident code
- Wrapping output in unnecessary formatting
- Restating the user's question before answering
