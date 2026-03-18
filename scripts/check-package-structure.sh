#!/usr/bin/env bash
# Checks Java package structure rules on every Edit/Write tool call.
# Violations are printed to stdout so Claude can see and fix them immediately.
set -euo pipefail

INPUT="$(cat)"
TOOL_NAME="$(echo "$INPUT" | jq -r '.tool_name // empty')"
FILE_PATH="$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')"

# Only process Edit / Write on .java files
if [[ "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "Write" ]]; then exit 0; fi
if [[ -z "$FILE_PATH" || "${FILE_PATH##*.}" != "java" ]]; then exit 0; fi
if [[ ! -f "$FILE_PATH" ]]; then exit 0; fi

VIOLATIONS=()
CLASS_NAME=$(basename "$FILE_PATH" .java)
NORM_PATH="${FILE_PATH//\\//}"

# ── Rule 1: No layer-based top-level packages ─────────────────────────────────
# Controller, Service, Repository for a feature must live in the SAME package.
# Standalone layer directories (e.g. .../controller/, .../service/) are forbidden.
for layer in controller service repository dao mapper; do
  if echo "$NORM_PATH" | grep -qE "/src/main/java/[^/]+(/[^/]+)?/${layer}/[^/]+\.java$"; then
    VIOLATIONS+=("Layer-based package '${layer}/' detected. Controller, Service, and Repository must reside in the same feature package.")
  fi
done

# ── Rule 2: Config-like classes must be in _config or common ──────────────────
if echo "$CLASS_NAME" | grep -qiE '(Config|Configuration|Properties|Interceptor|Filter|Advice|Handler|Resolver|Converter|Serializer|Deserializer)$'; then
  if ! echo "$NORM_PATH" | grep -qE '/(_config|common)/'; then
    VIOLATIONS+=("'${CLASS_NAME}' looks like a configuration class but is not under '_config' or 'common' package.")
  fi
fi

# ── Rule 3: Business classes must not be in _config ───────────────────────────
if echo "$NORM_PATH" | grep -qE '/_config/'; then
  if echo "$CLASS_NAME" | grep -qiE '(Controller|Service|Repository|Dao|Mapper)$'; then
    VIOLATIONS+=("'${CLASS_NAME}' is a business class inside '_config'. Business logic must not be placed in '_config'.")
  fi
fi

# ── Rule 4: Unnecessary public access modifiers ───────────────────────────────
# Flags public methods/classes whose names suggest internal use.
# (Heuristic: inner helpers, private-use utilities — final judgment left to Claude)
public_count=$(grep -cE '^\s+public\s+(static\s+)?(void|[A-Z][a-zA-Z]+|[a-z][a-zA-Z]+)\s+[a-z]' "$FILE_PATH" 2>/dev/null || echo 0)
if [[ "$public_count" -gt 0 ]]; then
  VIOLATIONS+=("Found ${public_count} public method(s) in '${CLASS_NAME}'. Verify each is intentionally public (called from outside the package); downgrade to package-private if not.")
fi

# ── Report ────────────────────────────────────────────────────────────────────
if [[ "${#VIOLATIONS[@]}" -gt 0 ]]; then
  echo "[package-structure] Violations in ${FILE_PATH}:"
  for v in "${VIOLATIONS[@]}"; do
    echo "  ✗ ${v}"
  done
  echo ""
  echo "Fix the violations above before proceeding."
fi
