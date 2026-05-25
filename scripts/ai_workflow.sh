#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_DIR="$(pwd)"
HARNESS_DIR=".ai-harness"
STANDARDS_DIR="$HARNESS_DIR/.ai-standards"

source "$SCRIPT_DIR/lib/git_utils.sh"
source "$SCRIPT_DIR/lib/spec_utils.sh"
source "$SCRIPT_DIR/lib/codex_runner.sh"

say() {
  printf '%s\n' "$1"
}

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'USAGE'
usage:
  ./ai status
  ./ai spec <spec-id> <source-doc>
  ./ai next <spec-id>
  ./ai work <spec-id> <task-id>
  ./ai pr <spec-id> <task-id> [target-branch]
  ./ai run <spec-id> <source-doc>
USAGE
}

require_repo() {
  [[ -d .git ]] || fail "current directory is not a git repository root"
  [[ -d "$STANDARDS_DIR" ]] || fail "$STANDARDS_DIR not found; run bootstrap after adding the standards submodule"
}

standards_script() {
  printf '%s/scripts/%s\n' "$STANDARDS_DIR" "$1"
}

confirm_or_stop() {
  local message="$1"
  if [[ "${AI_CONFIRM:-}" = "1" ]]; then
    return 0
  fi
  if [[ ! -t 0 ]]; then
    fail "$message; rerun with AI_CONFIRM=1 after manual confirmation"
  fi
  printf '%s [y/N] ' "$message"
  local answer
  read -r answer
  [[ "$answer" = "y" || "$answer" = "Y" || "$answer" = "yes" || "$answer" = "YES" ]] || fail "stopped by user"
}

task_branch_name() {
  local spec_id="$1"
  local task_id="$2"
  printf 'feat/%s-%s\n' "$spec_id" "$task_id"
}

print_stash_recovery() {
  local stash_name="$1"
  [[ -z "$stash_name" ]] && return 0
  say "stash: $stash_name"
  say "restore: git stash list | grep '$stash_name' && git stash pop stash@{N}"
}

spec_has_dirty_files() {
  local spec_id="$1"
  git status --porcelain -- ".ai-harness/specs/$spec_id" | grep -q .
}

cmd_status() {
  require_repo
  say "repo: $REPO_DIR"
  say "branch: $(git_current_branch)"
  say "remote: $(git_remote_url)"
  say "standards: $STANDARDS_DIR"
  if [[ -d "$STANDARDS_DIR/.git" || -f "$STANDARDS_DIR/.git" ]]; then
    say "standards revision: $(git -C "$STANDARDS_DIR" rev-parse --short HEAD 2>/dev/null || true)"
  fi

  say ""
  say "dirty workspace:"
  if git_is_dirty; then
    git_dirty_summary
  else
    say "clean"
  fi

  say ""
  say "specs:"
  local spec_id tasks_file next_task
  if ! spec_list_ids | grep -q .; then
    say "none"
    return
  fi
  while IFS= read -r spec_id; do
    tasks_file="$(spec_tasks_file "$spec_id")"
    if [[ -f "$tasks_file" ]]; then
      next_task="$(task_next_ready "$tasks_file" "S" || task_next_ready "$tasks_file" "M" || task_next_ready "$tasks_file" "L" || true)"
      say "- $spec_id next=${next_task:-none}"
    else
      say "- $spec_id missing 03-tasks.md"
    fi
  done < <(spec_list_ids)
}

cmd_spec() {
  require_repo
  local spec_id="$1"
  local source_doc="$2"
  [[ -f "$source_doc" ]] || fail "source document not found: $source_doc"

  bash "$(standards_script init_spec.sh)" "$spec_id"
  codex_run_command_output_as_prompt "$REPO_DIR" "spec-$spec_id" bash "$(standards_script prepare_spec_prompt.sh)" "$spec_id" "$source_doc"
  bash "$(standards_script check_spec.sh)" "$spec_id"

  if spec_has_open_questions "$spec_id"; then
    say "warning: possible Open Questions remain; review before development"
  fi
}

cmd_next() {
  require_repo
  local spec_id="$1"
  local tasks_file
  spec_ensure_exists "$spec_id"
  tasks_file="$(spec_tasks_file "$spec_id")"

  local task_id complexity
  for complexity in S M L; do
    task_id="$(task_next_ready "$tasks_file" "$complexity" || true)"
    if [[ -n "$task_id" ]]; then
      say "$task_id"
      say "complexity: $complexity"
      if [[ "$complexity" != "S" ]]; then
        say "warning: $complexity task requires manual confirmation before automation"
      fi
      return
    fi
  done

  fail "no ready task found for spec: $spec_id"
}

cmd_work() {
  require_repo
  local spec_id="$1"
  local task_id="$2"
  local tasks_file branch base_branch stash_name complexity

  spec_ensure_exists "$spec_id"
  bash "$(standards_script check_spec.sh)" "$spec_id"
  tasks_file="$(spec_tasks_file "$spec_id")"
  task_exists "$tasks_file" "$task_id" || fail "task id not found: $task_id"
  task_done "$tasks_file" "$task_id" && fail "task already marked done: $task_id"
  task_dependencies_met "$tasks_file" "$task_id" || fail "dependencies are not complete for task: $task_id"

  complexity="$(task_complexity "$tasks_file" "$task_id")"
  if [[ "$complexity" != "S" ]] || task_is_high_risk "$tasks_file" "$task_id"; then
    confirm_or_stop "Task $task_id is $complexity or high-risk; confirm before development"
  fi

  base_branch="$(git_current_branch)"
  if [[ "${AI_SKIP_WORK_STASH:-}" = "1" ]]; then
    stash_name=""
  elif spec_has_dirty_files "$spec_id"; then
    stash_name="$(git_named_stash_excluding "before-${spec_id}-${task_id}" ".ai-harness/specs/$spec_id")"
    say "dirty spec files detected for $spec_id; keeping them in the worktree for task context"
  else
    stash_name="$(git_named_stash_if_dirty "before-${spec_id}-${task_id}")"
  fi
  branch="$(task_branch_name "$spec_id" "$task_id")"
  git_ensure_branch "$branch"

  say "base branch: $base_branch"
  print_stash_recovery "$stash_name"
  codex_run_command_output_as_prompt "$REPO_DIR" "work-$spec_id-$task_id" bash "$(standards_script prepare_task_prompt.sh)" "$spec_id" "$task_id"
}

cmd_pr() {
  require_repo
  local spec_id="$1"
  local task_id="$2"
  local target_branch="${3:-main}"
  local feature_branch changed_file_count changed_line_count pr_dir prompt_log message_file

  spec_ensure_exists "$spec_id"
  task_exists "$(spec_tasks_file "$spec_id")" "$task_id" || fail "task id not found: $task_id"
  feature_branch="$(git_current_branch)"

  say "target branch: $target_branch"
  say "feature branch: $feature_branch"
  say "changed files:"
  git_changed_files "$target_branch" || true

  changed_file_count="$(git_changed_files "$target_branch" | sed '/^[[:space:]]*$/d' | wc -l | tr -d ' ')"
  changed_line_count="$(git diff --shortstat "$target_branch"...HEAD 2>/dev/null | sed -E 's/.* ([0-9]+) insertions?.*/\1/' || true)"
  say "changed file count: ${changed_file_count:-0}"
  say "changed line signal: ${changed_line_count:-unknown}"

  confirm_or_stop "Review diff, test evidence, risks, rollback, commit message, and MR text before commit/push"

  codex_run_command_output_as_prompt "$REPO_DIR" "pr-$spec_id-$task_id" bash "$(standards_script prepare_pr_prompt.sh)" "$spec_id" "$task_id" "$target_branch" "$feature_branch"

  pr_dir="$HARNESS_DIR/pr"
  mkdir -p "$pr_dir"
  prompt_log="$pr_dir/${spec_id}-${task_id}-mr.md"
  {
    printf '# MR Material\n\n'
    printf '- Spec: `.ai-harness/specs/%s/`\n' "$spec_id"
    printf '- Task ID: `%s`\n' "$task_id"
    printf '- Source branch: `%s`\n' "$feature_branch"
    printf '- Target branch: `%s`\n\n' "$target_branch"
    printf '## Suggested Title\n\n'
    printf '%s: %s\n\n' "$task_id" "$spec_id"
    printf '## Push Command\n\n```bash\ngit push -u origin %s\n```\n\n' "$feature_branch"
    printf '## MR Description\n\n'
    bash "$(standards_script prepare_pr_prompt.sh)" "$spec_id" "$task_id" "$target_branch" "$feature_branch"
  } > "$prompt_log"
  say "mr material: $prompt_log"

  message_file="$(mktemp)"
  {
    printf 'feat(%s): complete %s\n\n' "$spec_id" "$task_id"
    printf 'Why\n'
    printf '- Implement task %s from spec %s.\n\n' "$task_id" "$spec_id"
    printf 'What\n'
    printf '- See MR material in %s.\n\n' "$prompt_log"
    printf 'Validation\n'
    printf '- See .ai-harness/specs/%s/04-acceptance.md and generated PR material.\n' "$spec_id"
  } > "$message_file"
  git_commit_all "$message_file"
  rm -f "$message_file"
  git_push_current
  say "GitLab MR API was not called; create the MR manually with the generated material."
}

cmd_run() {
  require_repo
  local spec_id="$1"
  local source_doc="$2"
  local next_output task_id complexity tasks_file stash_name

  stash_name="$(git_named_stash_excluding "before-run-${spec_id}" ".ai-harness/specs/$spec_id" "$source_doc")"
  print_stash_recovery "$stash_name"
  cmd_spec "$spec_id" "$source_doc"
  next_output="$(cmd_next "$spec_id")"
  task_id="$(printf '%s\n' "$next_output" | head -n 1)"
  tasks_file="$(spec_tasks_file "$spec_id")"
  complexity="$(task_complexity "$tasks_file" "$task_id")"

  if spec_has_open_questions "$spec_id" || [[ "$complexity" != "S" ]] || task_is_high_risk "$tasks_file" "$task_id"; then
    confirm_or_stop "Spec has open questions or next task needs manual confirmation: $task_id"
  fi

  AI_SKIP_WORK_STASH=1 cmd_work "$spec_id" "$task_id"
  cmd_pr "$spec_id" "$task_id" main
}

main() {
  local cmd="${1:-}"
  case "$cmd" in
    status)
      [[ $# -eq 1 ]] || { usage; exit 1; }
      cmd_status
      ;;
    spec)
      [[ $# -eq 3 ]] || { usage; exit 1; }
      cmd_spec "$2" "$3"
      ;;
    next)
      [[ $# -eq 2 ]] || { usage; exit 1; }
      cmd_next "$2"
      ;;
    work)
      [[ $# -eq 3 ]] || { usage; exit 1; }
      cmd_work "$2" "$3"
      ;;
    pr)
      [[ $# -eq 3 || $# -eq 4 ]] || { usage; exit 1; }
      cmd_pr "$2" "$3" "${4:-main}"
      ;;
    run)
      [[ $# -eq 3 ]] || { usage; exit 1; }
      cmd_run "$2" "$3"
      ;;
    -h|--help|help|"")
      usage
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
