#!/usr/bin/env bash
# Stop hook: instructs Claude to update CLAUDE.md and README.md when code files are modified.
set -euo pipefail

source "$(dirname "$0")/detect-workspace.sh"

INPUT="$(cat)"
PROJECT_ROOT="$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // "."')"
cd "$PROJECT_ROOT"

# Collect modified code files (exclude documentation)
MODIFIED=$(git --no-optional-locks diff --name-only HEAD 2>/dev/null || true)
MODIFIED+=$'\n'$(git --no-optional-locks diff --name-only 2>/dev/null || true)
MODIFIED=$(echo "$MODIFIED" | sort -u | grep -v '^$' | grep -Ev '(^CLAUDE\.md$|^README\.md$|\.(md|txt|rst|adoc|asciidoc)$)' || true)

if [[ -z "$MODIFIED" ]]; then
  exit 0
fi

echo "Code changes detected. Please update CLAUDE.md and README.md using the init-claude-md skill."

# If this project is a service inside an MSA workspace, also update the workspace CLAUDE.md
PARENT_DIR="$(cd "$PROJECT_ROOT/.." && pwd)"
if is_msa_workspace "$PARENT_DIR"; then
  echo "This project is part of an MSA workspace."
  echo "Also update the workspace CLAUDE.md at: $PARENT_DIR using the init-claude-md skill."
fi
