#!/usr/bin/env bash
set -euo pipefail

# Directories
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
DATA_DIR="${CLAUDE_PLUGIN_DATA:-$PLUGIN_ROOT/.checkstyle-data}"
mkdir -p "$DATA_DIR"

CHECKSTYLE_VERSION="10.21.4"
CHECKSTYLE_JAR="$DATA_DIR/checkstyle-${CHECKSTYLE_VERSION}-all.jar"
CHECKSTYLE_XML="$DATA_DIR/google_checks.xml"

# Read hook input JSON from stdin
INPUT="$(cat)"
TOOL_NAME="$(echo "$INPUT" | jq -r '.tool_name // empty')"
FILE_PATH="$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')"

# Only process Edit / Write tool calls on .java files
if [[ "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "Write" ]]; then
  exit 0
fi

if [[ -z "$FILE_PATH" || "${FILE_PATH##*.}" != "java" ]]; then
  exit 0
fi

if [[ ! -f "$FILE_PATH" ]]; then
  exit 0
fi

# Download checkstyle jar if missing
if [[ ! -f "$CHECKSTYLE_JAR" ]]; then
  echo "[checkstyle] Downloading checkstyle ${CHECKSTYLE_VERSION}..." >&2
  curl -fsSL -o "$CHECKSTYLE_JAR" \
    "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${CHECKSTYLE_VERSION}/checkstyle-${CHECKSTYLE_VERSION}-all.jar"
fi

# Download Google Java Style config if missing
if [[ ! -f "$CHECKSTYLE_XML" ]]; then
  echo "[checkstyle] Downloading google_checks.xml..." >&2
  curl -fsSL -o "$CHECKSTYLE_XML" \
    "https://raw.githubusercontent.com/checkstyle/checkstyle/checkstyle-${CHECKSTYLE_VERSION}/src/main/resources/google_checks.xml"
fi

echo "[checkstyle] Checking $FILE_PATH ..." >&2
java -jar "$CHECKSTYLE_JAR" -c "$CHECKSTYLE_XML" "$FILE_PATH"
