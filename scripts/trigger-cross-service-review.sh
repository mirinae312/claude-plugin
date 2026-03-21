#!/usr/bin/env bash
# Stop hook: triggers cross-service review when multiple services are modified in an MSA workspace.
set -euo pipefail

source "$(dirname "$0")/detect-workspace.sh"

INPUT="$(cat)"
PROJECT_ROOT="$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // "."')"
cd "$PROJECT_ROOT"

if ! is_msa_workspace "$PROJECT_ROOT"; then
  exit 0
fi

# Get service directory names from msa-workspace.json
SERVICE_DIRS=$(jq -r '.services[].dir' "$PROJECT_ROOT/msa-workspace.json" 2>/dev/null || true)

if [[ -z "$SERVICE_DIRS" ]]; then
  exit 0
fi

# Check each service repo independently for changes.
# Directory changes are isolated to a subshell to always return to PROJECT_ROOT.
CHANGED_SERVICES=""
while IFS= read -r SERVICE_DIR; do
  FULL_PATH="$PROJECT_ROOT/$SERVICE_DIR"
  if [[ ! -d "$FULL_PATH/.git" ]]; then
    continue
  fi
  HAS_CHANGES=$(
    cd "$FULL_PATH"
    git --no-optional-locks diff --name-only HEAD 2>/dev/null || true
    git --no-optional-locks diff --name-only 2>/dev/null || true
  )
  if [[ -n "$HAS_CHANGES" ]]; then
    CHANGED_SERVICES+="$SERVICE_DIR"$'\n'
  fi
done <<< "$SERVICE_DIRS"
CHANGED_SERVICES=$(echo "$CHANGED_SERVICES" | grep -v '^$' || true)

SERVICE_COUNT=$(echo "$CHANGED_SERVICES" | grep -c '\S' || true)

if [[ "$SERVICE_COUNT" -le 1 ]]; then
  exit 0
fi

echo "Multiple services were modified:"
echo "$CHANGED_SERVICES" | sed 's/^/  - /'
echo ""
echo "Please run the cross-service-reviewer agent to verify consistency across services."
