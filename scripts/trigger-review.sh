#!/usr/bin/env bash
# Stop hook: triggers code review when Java files were modified in the session.
set -euo pipefail

INPUT="$(cat)"
CWD="$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // "."')"

# Collect modified Java files (staged + unstaged)
JAVA_FILES=$(git --no-optional-locks -C "$CWD" diff --name-only HEAD 2>/dev/null | grep '\.java$' || true)
JAVA_FILES+=$'\n'$(git --no-optional-locks -C "$CWD" diff --name-only 2>/dev/null | grep '\.java$' || true)
JAVA_FILES=$(echo "$JAVA_FILES" | sort -u | grep -v '^$' || true)

if [[ -z "$JAVA_FILES" ]]; then
  exit 0
fi

echo "The following Java files were modified:"
echo "$JAVA_FILES" | sed 's/^/  - /'
echo ""
echo "Please run a full code review on these files using the review-orchestrator agent."
