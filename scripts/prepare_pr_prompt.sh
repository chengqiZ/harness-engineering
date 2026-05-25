#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
source "$SCRIPT_DIR/lib/prompt_utils.sh"

if [[ $# -ne 4 ]]; then
  printf 'usage: bash .ai-harness/.ai-standards/scripts/prepare_pr_prompt.sh <spec-id> <task-id> <target-branch> <feature-branch>\n' >&2
  exit 1
fi

SPEC_ID="$1"
TASK_ID="$2"
TARGET_BRANCH="$3"
FEATURE_BRANCH="$4"
HARNESS_DIR=".ai-harness"
STANDARDS_DIR="$HARNESS_DIR/.ai-standards"
SPEC_DIR="$HARNESS_DIR/specs/$SPEC_ID"
TASKS_FILE="$SPEC_DIR/03-tasks.md"
ROOT_DIR="$(repo_root_from_script "$SCRIPT_PATH")"
TEMPLATE="$ROOT_DIR/templates/prompts/pr-preparation.md"

ensure_git_root
ensure_dir "$STANDARDS_DIR" "$STANDARDS_DIR"
ensure_dir "$SPEC_DIR" "$SPEC_DIR"
ensure_task_exists "$TASKS_FILE" "$TASK_ID"

render_template "$TEMPLATE" \
  "SPEC_ID=$SPEC_ID" \
  "TASK_ID=$TASK_ID" \
  "TARGET_BRANCH=$TARGET_BRANCH" \
  "FEATURE_BRANCH=$FEATURE_BRANCH"
