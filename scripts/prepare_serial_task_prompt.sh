#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
source "$SCRIPT_DIR/lib/prompt_utils.sh"

if [[ $# -lt 1 || $# -gt 3 ]]; then
  printf 'usage: bash .ai-harness/.ai-standards/scripts/prepare_serial_task_prompt.sh <spec-id> [source-doc] [target-branch]\n' >&2
  exit 1
fi

SPEC_ID="$1"
SOURCE_DOC="${2:-}"
TARGET_BRANCH="${3:-}"
HARNESS_DIR=".ai-harness"
STANDARDS_DIR="$HARNESS_DIR/.ai-standards"
ROOT_DIR="$(repo_root_from_script "$SCRIPT_PATH")"
TEMPLATE="$ROOT_DIR/templates/prompts/serial-task-pipeline.md"

ensure_git_root
ensure_dir "$STANDARDS_DIR" "$STANDARDS_DIR"

if [[ -z "$TARGET_BRANCH" ]]; then
  TARGET_BRANCH="$(git symbolic-ref --quiet --short HEAD || git rev-parse --short HEAD)"
fi

if [[ -n "$SOURCE_DOC" ]]; then
  ensure_file "$SOURCE_DOC" "source document"
else
  SOURCE_DOC="not provided; continue from existing spec if available"
fi

render_template "$TEMPLATE" \
  "SPEC_ID=$SPEC_ID" \
  "SOURCE_DOC=$SOURCE_DOC" \
  "TARGET_BRANCH=$TARGET_BRANCH"
