#!/usr/bin/env bash
# Stop hook: triggers code review when non-documentation files were modified in the session.
set -euo pipefail

INPUT="$(cat)"
CWD="$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // "."')"

# Collect modified files (staged + unstaged), excluding documentation files
MODIFIED_FILES=$(git --no-optional-locks -C "$CWD" diff --name-only HEAD 2>/dev/null || true)
MODIFIED_FILES+=$'\n'$(git --no-optional-locks -C "$CWD" diff --name-only 2>/dev/null || true)
MODIFIED_FILES=$(echo "$MODIFIED_FILES" | sort -u | grep -v '^$' | grep -Ev '\.(md|txt|rst|adoc|asciidoc)$' || true)

if [[ -z "$MODIFIED_FILES" ]]; then
  exit 0
fi

echo "The following files were modified:"
echo "$MODIFIED_FILES" | sed 's/^/  - /'
echo ""
echo "Please run a full code review on these files using the review-orchestrator agent."
