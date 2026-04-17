#!/bin/bash

INPUT=$(cat)

RESPONSE=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for key in ('assistant_response', 'response', 'content', 'text', 'message'):
    if key in data and isinstance(data[key], str):
        print(data[key])
        sys.exit(0)
print(json.dumps(data))
" 2>/dev/null || echo "")

if [ ${#RESPONSE} -lt 500 ]; then
  echo '{"continue":true}'
  exit 0
fi

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DAILY_DIR="$PROJECT_DIR/daily"
mkdir -p "$DAILY_DIR"

TODAY=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M")

SUMMARY=$(echo "$RESPONSE" | head -c 200 | tr '\n' ' ')

cat >> "$DAILY_DIR/${TODAY}.md" << EOF
### ${TIME}
${SUMMARY}
---
EOF

echo '{"continue":true}'
