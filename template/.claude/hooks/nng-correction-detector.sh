#!/bin/bash

INPUT=$(cat)

PROMPT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('user_prompt',''))" 2>/dev/null)

if [ -z "$PROMPT" ]; then
  echo '{"continue":true}'
  exit 0
fi

PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

PATTERNS=(
  "no,"
  "not that"
  "wrong"
  "revert"
  "undo"
  "you forgot"
  "should be"
  "instead of"
  "don't do"
  "stop doing"
  "shouldn't"
  "that's not"
  "i said"
  "i meant"
  "not what i"
)

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

for pattern in "${PATTERNS[@]}"; do
  if echo "$PROMPT_LOWER" | grep -qF "$pattern"; then
    echo "$pattern" > "$PROJECT_DIR/.correction-detected"
    break
  fi
done

echo '{"continue":true}'
