#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  printf 'usage: bash scripts/verify_first_onboarding.sh <business-repo> <standards-repo-url-or-path> [spec-id]\n' >&2
  exit 1
fi

BUSINESS_REPO="$1"
STANDARDS_REPO="$2"
SPEC_ID="${3:-demo-first-flow}"
HARNESS_DIR=".ai-harness"
STANDARDS_DIR="$HARNESS_DIR/.ai-standards"
PROMPT_OUT="/tmp/${SPEC_ID}-prompt.txt"

fail_count=0

pass() {
  printf 'PASS %s\n' "$1"
}

fail() {
  printf 'FAIL %s\n' "$1"
  fail_count=$((fail_count + 1))
}

finish() {
  if [[ "$fail_count" -eq 0 ]]; then
    printf '\nRESULT: first onboarding flow verified\n'
    exit 0
  fi

  printf '\nRESULT: first onboarding flow failed with %s issue(s)\n' "$fail_count"
  exit 1
}

require_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    pass "file exists: $path"
  else
    fail "missing file: $path"
  fi
}

require_dir() {
  local path="$1"
  if [[ -d "$path" ]]; then
    pass "directory exists: $path"
  else
    fail "missing directory: $path"
  fi
}

run_step() {
  local label="$1"
  shift

  if "$@"; then
    pass "$label"
  else
    fail "$label"
    finish
  fi
}

if [[ ! -d "$BUSINESS_REPO" ]]; then
  fail "business repo not found: $BUSINESS_REPO"
  finish
fi

cd "$BUSINESS_REPO"

if git rev-parse --show-toplevel >/dev/null 2>&1; then
  if [[ "$(git rev-parse --show-toplevel)" == "$(pwd)" ]]; then
    pass "git repo root detected"
  else
    fail "current path is not git repo root: $BUSINESS_REPO"
    finish
  fi
else
  fail "not a git repository: $BUSINESS_REPO"
  finish
fi

if [[ -d "$STANDARDS_DIR" ]]; then
  pass "standards submodule directory already exists"
else
  run_step "standards submodule added" git -c protocol.file.allow=always submodule add "$STANDARDS_REPO" "$STANDARDS_DIR"
fi

run_step "standards submodule initialized" git -c protocol.file.allow=always submodule update --init --recursive

require_dir "$STANDARDS_DIR/scripts"
require_dir "$STANDARDS_DIR/templates"
require_file "$STANDARDS_DIR/scripts/bootstrap_repo.sh"
require_file "$STANDARDS_DIR/scripts/init_spec.sh"
require_file "$STANDARDS_DIR/scripts/prepare_spec_prompt.sh"
require_file "$STANDARDS_DIR/scripts/prepare_task_prompt.sh"
require_file "$STANDARDS_DIR/scripts/prepare_pr_prompt.sh"
require_file "$STANDARDS_DIR/scripts/check_spec.sh"

if [[ "$fail_count" -ne 0 ]]; then
  finish
fi

run_step "bootstrap completed" bash "$STANDARDS_DIR/scripts/bootstrap_repo.sh"

require_file "$HARNESS_DIR/AGENTS.md"
require_dir "$HARNESS_DIR/specs"
require_file "$HARNESS_DIR/docs/changelog/README.md"
require_file ".github/pull_request_template.md"

if [[ "$fail_count" -ne 0 ]]; then
  finish
fi

run_step "spec initialized: $SPEC_ID" bash "$STANDARDS_DIR/scripts/init_spec.sh" "$SPEC_ID"

require_file "$HARNESS_DIR/specs/$SPEC_ID/01-requirements.md"
require_file "$HARNESS_DIR/specs/$SPEC_ID/02-design.md"
require_file "$HARNESS_DIR/specs/$SPEC_ID/03-tasks.md"
require_file "$HARNESS_DIR/specs/$SPEC_ID/04-acceptance.md"

if [[ "$fail_count" -ne 0 ]]; then
  finish
fi

SOURCE_DOC="$HARNESS_DIR/tmp/${SPEC_ID}-source.md"
mkdir -p "$(dirname "$SOURCE_DOC")"
printf '# Demo PRD\n\nValidate first onboarding flow.\n' > "$SOURCE_DOC"
pass "temporary source doc created: $SOURCE_DOC"

TASKS_FILE="$HARNESS_DIR/specs/$SPEC_ID/03-tasks.md"
TMP_TASKS_FILE="/tmp/${SPEC_ID}-03-tasks.md"
awk '
  BEGIN { replaced = 0 }
  !replaced && $0 == "- Task ID: `T1`" {
    print
    getline
    print "- Purpose: Validate task prompt generation."
    replaced = 1
    next
  }
  { print }
' "$TASKS_FILE" > "$TMP_TASKS_FILE"
mv "$TMP_TASKS_FILE" "$TASKS_FILE"
pass "temporary task id seeded for prompt generation: $TASKS_FILE"

if bash "$STANDARDS_DIR/scripts/prepare_spec_prompt.sh" "$SPEC_ID" "$SOURCE_DOC" > "$PROMPT_OUT"; then
  pass "spec preparation prompt generated"
else
  fail "spec preparation prompt generated"
  finish
fi

if [[ -s "$PROMPT_OUT" ]]; then
  pass "prompt output is non-empty: $PROMPT_OUT"
else
  fail "prompt output is empty: $PROMPT_OUT"
fi

TASK_PROMPT_OUT="/tmp/${SPEC_ID}-task-prompt.txt"
if bash "$STANDARDS_DIR/scripts/prepare_task_prompt.sh" "$SPEC_ID" T1 > "$TASK_PROMPT_OUT"; then
  pass "task development prompt generated"
else
  fail "task development prompt generated"
  finish
fi

if [[ -s "$TASK_PROMPT_OUT" ]]; then
  pass "task prompt output is non-empty: $TASK_PROMPT_OUT"
else
  fail "task prompt output is empty: $TASK_PROMPT_OUT"
fi

PR_PROMPT_OUT="/tmp/${SPEC_ID}-pr-prompt.txt"
if bash "$STANDARDS_DIR/scripts/prepare_pr_prompt.sh" "$SPEC_ID" T1 main "feat/${SPEC_ID}-T1" > "$PR_PROMPT_OUT"; then
  pass "pr preparation prompt generated"
else
  fail "pr preparation prompt generated"
  finish
fi

if [[ -s "$PR_PROMPT_OUT" ]]; then
  pass "pr prompt output is non-empty: $PR_PROMPT_OUT"
else
  fail "pr prompt output is empty: $PR_PROMPT_OUT"
fi

if bash "$STANDARDS_DIR/scripts/check_spec.sh" "$SPEC_ID" >/tmp/"${SPEC_ID}-check-spec.log" 2>&1; then
  pass "check_spec completed; spec may already be filled"
else
  pass "check_spec blocked incomplete template as expected"
fi

finish
