#!/bin/bash

INPUT=$(cat)

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

TRANSCRIPT=$(echo "$INPUT" | python3 -c "
import sys, json

data = json.load(sys.stdin)
transcript = data.get('transcript', [])

text = ''
for entry in transcript:
    if isinstance(entry, dict):
        for key in ('content', 'text', 'message'):
            if key in entry:
                val = entry[key]
                text += (val if isinstance(val, str) else json.dumps(val)) + '\n'
    elif isinstance(entry, str):
        text += entry + '\n'

print(text)
" 2>/dev/null || echo "")

FILES=$(echo "$TRANSCRIPT" | grep -oE '[a-zA-Z0-9_/.-]+\.(tsx?|jsx?|py|go|rs|rb|java|kt|css|html|json)' | sort -u | head -20)

CONTEXT=$(echo "$TRANSCRIPT" | grep -iE '(debug|fix|refactor|implement|migrate|test|error|bug|issue)' | head -5)

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat > "$PROJECT_DIR/compaction-state.md" << EOF
# Compaction State (auto-generated)
## Files Being Modified
${FILES:-"none detected"}
## Context Notes
${CONTEXT:-"none detected"}
## Timestamp
${TIMESTAMP}
EOF

echo '{"continue":true}'
