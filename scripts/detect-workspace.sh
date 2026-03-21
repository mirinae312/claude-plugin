#!/usr/bin/env bash
# Utility: returns 0 if the given directory is an MSA workspace, 1 otherwise.
# Usage: source this file, then call is_msa_workspace [dir]

is_msa_workspace() {
  local dir="${1:-.}"
  [[ -f "$dir/msa-workspace.json" ]]
}
