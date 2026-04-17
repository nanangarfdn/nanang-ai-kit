# Debugging Discipline

## Iron Rule
NEVER jump straight to a fix without investigating the root cause first.

## Phase 1 — Investigate
- Read the FULL error message, do not skip the stack trace
- Reproduce consistently
- Trace data flow backward from symptom to source

## Phase 2 — Compare
- Find WORKING examples in the codebase (similar files/modules)
- Compare broken vs working — what differs?
- Check learnings files for known issues

## Phase 3 — Hypothesis
- One specific hypothesis, not "maybe this or that"
- Test with MINIMAL changes — one variable at a time
- If hypothesis is wrong, return to Phase 1 with new evidence

## Phase 4 — Fix
- If feasible: write a failing test first that reproduces the bug
- Implement a single fix that addresses the root cause
- Verify the fix doesn't break other tests

## Hard Stop
After 3 failed fix attempts → STOP. Do not attempt a 4th fix.
Ask the user: likely an architectural issue, not a small bug.

## Red Flags (return to Phase 1)
- "Just try changing this" without knowing why
- A fix that suppresses the error but doesn't solve the cause
- Adding workarounds on top of workarounds
