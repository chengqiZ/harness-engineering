#!/usr/bin/env bash

spec_fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

spec_dir() {
  printf '.ai-harness/specs/%s\n' "$1"
}

spec_tasks_file() {
  printf '.ai-harness/specs/%s/03-tasks.md\n' "$1"
}

spec_acceptance_file() {
  printf '.ai-harness/specs/%s/04-acceptance.md\n' "$1"
}

spec_requirements_file() {
  printf '.ai-harness/specs/%s/01-requirements.md\n' "$1"
}

spec_ensure_exists() {
  local spec_id="$1"
  [[ -f "$(spec_requirements_file "$spec_id")" ]] || spec_fail "missing $(spec_requirements_file "$spec_id")"
  [[ -f "$(spec_tasks_file "$spec_id")" ]] || spec_fail "missing $(spec_tasks_file "$spec_id")"
}

spec_list_ids() {
  [[ -d .ai-harness/specs ]] || return 0
  find .ai-harness/specs -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
}

task_ids() {
  local tasks_file="$1"
  awk '
    match($0, /^- Task ID:[[:space:]]*`?([^`[:space:]]+)`?/, m) { print m[1] }
  ' "$tasks_file"
}

task_exists() {
  local tasks_file="$1"
  local task_id="$2"
  task_ids "$tasks_file" | grep -Fxq "$task_id"
}

task_field() {
  local tasks_file="$1"
  local task_id="$2"
  local field="$3"
  awk -v task="$task_id" -v field="$field" '
    function is_field(line) {
      return line ~ /^- (Task ID|Purpose|Inputs|Changes|Validation|Done|Complexity|Depends On):/
    }
    function clean(value) {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
      gsub(/^`|`$/, "", value)
      return value
    }
    /^- Task ID:/ {
      in_task = ($0 ~ ("`" task "`") || $0 ~ (": " task "$"))
      next
    }
    in_task && $0 ~ ("^- " field ":") {
      sub("^- " field ":[[:space:]]*", "")
      value = clean($0)
      while ((getline line) > 0) {
        if (line ~ /^### / || is_field(line) || line ~ /^## /) {
          break
        }
        if (line !~ /^[[:space:]]*$/) {
          value = value (value == "" ? "" : "\n") clean(line)
        }
      }
      print value
      exit
    }
  ' "$tasks_file"
}

task_done() {
  local tasks_file="$1"
  local task_id="$2"
  local done progress

  done="$(task_field "$tasks_file" "$task_id" "Done" | tr '[:upper:]' '[:lower:]')"
  if [[ "$done" =~ (^|[^a-z])(yes|true|done|complete|completed|已完成)([^a-z]|$) ]]; then
    return 0
  fi

  progress="$(awk -v task="$task_id" '
    $0 ~ /^## Progress/ { in_progress=1; next }
    in_progress && $0 ~ /^## / { in_progress=0 }
    in_progress && $0 ~ ("^- \\[[xX]\\][[:space:]]+`?" task "`?([[:space:]]|$)") { print "done"; exit }
  ' "$tasks_file")"
  [[ "$progress" = "done" ]]
}

task_complexity() {
  local value
  value="$(task_field "$1" "$2" "Complexity" | head -n 1)"
  case "$value" in
    S|M|L) printf '%s\n' "$value" ;;
    *) printf 'S\n' ;;
  esac
}

task_dependencies() {
  local tasks_file="$1"
  local task_id="$2"
  task_field "$tasks_file" "$task_id" "Depends On" |
    tr ',，' '\n\n' |
    sed -E 's/`//g; s/^- //; s/^[[:space:]]+|[[:space:]]+$//g' |
    awk 'NF && $0 !~ /^(none|None|NONE|无|N\/A|-|not applicable)$/ { print }'
}

task_dependencies_met() {
  local tasks_file="$1"
  local task_id="$2"
  local dep

  while IFS= read -r dep; do
    [[ -z "$dep" ]] && continue
    task_exists "$tasks_file" "$dep" || spec_fail "dependency task id not found: $dep"
    task_done "$tasks_file" "$dep" || return 1
  done < <(task_dependencies "$tasks_file" "$task_id")

  return 0
}

task_next_ready() {
  local tasks_file="$1"
  local wanted_complexity="${2:-}"
  local task_id complexity

  while IFS= read -r task_id; do
    task_done "$tasks_file" "$task_id" && continue
    complexity="$(task_complexity "$tasks_file" "$task_id")"
    [[ -n "$wanted_complexity" && "$complexity" != "$wanted_complexity" ]] && continue
    if task_dependencies_met "$tasks_file" "$task_id"; then
      printf '%s\n' "$task_id"
      return 0
    fi
  done < <(task_ids "$tasks_file")

  return 1
}

spec_has_open_questions() {
  local spec_id="$1"
  local dir
  dir="$(spec_dir "$spec_id")"
  grep -RiqE 'open questions|待确认|未确认|TBD|TODO|确认问题' "$dir" 2>/dev/null
}

task_is_high_risk() {
  local tasks_file="$1"
  local task_id="$2"
  local body
  body="$(task_field "$tasks_file" "$task_id" "Purpose"; task_field "$tasks_file" "$task_id" "Changes")"
  printf '%s\n' "$body" | grep -iqE 'db|database|migration|auth|permission|billing|risk|权限|认证|鉴权|迁移|账单|风控'
}

task_run_checkpoint_update() {
  local tasks_file="$1"
  local last_command="$2"
  local current_task="$3"
  local current_step="$4"
  local resume_command="$5"
  local last_result="$6"
  local last_error="${7:-}"
  local tmp_file

  last_error="$(printf '%s' "$last_error" | tr '\n' ' ' | sed -E 's/[[:space:]]+/ /g; s/^[[:space:]]+|[[:space:]]+$//g')"
  tmp_file="$(mktemp)"

  awk \
    -v last_command="$last_command" \
    -v current_task="$current_task" \
    -v current_step="$current_step" \
    -v resume_command="$resume_command" \
    -v last_result="$last_result" \
    -v last_error="$last_error" '
    function print_checkpoint() {
      print "## Run Checkpoint"
      print ""
      print "- Last Command: `" last_command "`"
      print "- Current Task: `" current_task "`"
      print "- Current Step: `" current_step "`"
      print "- Resume Command: `" resume_command "`"
      print "- Last Result: `" last_result "`"
      print "- Last Error: " last_error
    }
    /^## Run Checkpoint[[:space:]]*$/ {
      if (!printed) {
        print_checkpoint()
        printed = 1
      }
      skipping = 1
      next
    }
    skipping && /^## / {
      skipping = 0
    }
    !skipping {
      print
    }
    END {
      if (!printed) {
        print ""
        print_checkpoint()
      }
    }
  ' "$tasks_file" > "$tmp_file"

  mv "$tmp_file" "$tasks_file"
}
