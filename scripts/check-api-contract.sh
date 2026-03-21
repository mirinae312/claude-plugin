#!/usr/bin/env bash
# PostToolUse hook: warns when contracts/ files are modified in an MSA workspace.
set -euo pipefail

source "$(dirname "$0")/detect-workspace.sh"

INPUT="$(cat)"
PROJECT_ROOT="$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // "."')"
cd "$PROJECT_ROOT"

if ! is_msa_workspace "$PROJECT_ROOT"; then
  exit 0
fi

# Collect modified contract files (staged + unstaged).
# contracts/ is a workspace-level directory, so git runs from PROJECT_ROOT.
CONTRACT_FILES=$(git --no-optional-locks diff --name-only HEAD 2>/dev/null | grep '^contracts/' || true)
CONTRACT_FILES+=$'\n'$(git --no-optional-locks diff --name-only 2>/dev/null | grep '^contracts/' || true)
CONTRACT_FILES=$(echo "$CONTRACT_FILES" | sort -u | grep -v '^$' || true)

if [[ -z "$CONTRACT_FILES" ]]; then
  exit 0
fi

echo "The following API contract files were modified:"
echo "$CONTRACT_FILES" | sed 's/^/  - /'
echo ""
echo "Please run the msa-impact-analyzer agent to identify affected downstream services."
