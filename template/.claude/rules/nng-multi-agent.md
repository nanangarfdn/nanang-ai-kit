# Multi-Agent Background Execution

## Default Behavior
Every non-trivial task MUST be handled with the following pattern, **unless the user explicitly says otherwise**:

1. **Run in background** — always use `run_in_background: true` when launching the Agent tool.
2. **Multi-agent parallel** — if a task can be decomposed into independent sub-tasks, launch multiple agents simultaneously in a single message.
3. **Notify on completion** — the user will be notified automatically when each agent finishes.

## Decision Table

| Condition | Approach |
|-----------|----------|
| Multiple independent files/areas | Multi-agent parallel, background |
| Single file / sequential logic | Single agent, background |
| Quick read/grep/compare / simple question | Handle directly, no agent |
| User explicitly says "don't use agents" | Handle directly |

## Coordination Rules (Multi-Agent on Same File)
When 2+ agents work on the same file:
1. **Clearly separate scopes** — each agent gets a different section/area, no overlap.
2. **Warning in agent prompt** — inform which other agent is working on which file and section.
3. **Edit conflict handling** — instruct agents: if Edit fails because file changed, re-read and retry with new context.
4. **Scope discipline** — agents MUST NOT touch sections outside their scope, even if they appear related.

## Anti-Patterns
- Do not spawn agents for tasks that can be completed with 1-2 direct tool calls
- Do not overlap scopes between agents (causes conflicts)
- Do not skip verification (lint/typecheck) in agent prompts
