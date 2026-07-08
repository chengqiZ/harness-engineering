#!/usr/bin/env bash

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

repo_root_from_script() {
  local script_path="$1"
  local script_dir
  script_dir="$(cd "$(dirname "$script_path")" && pwd)"

  if [[ "$(basename "$script_dir")" = "lib" ]]; then
    cd "$script_dir/../.." && pwd
  else
    cd "$script_dir/.." && pwd
  fi
}

ensure_git_root() {
  [[ -d .git ]] || fail "current directory is not a git repository root"
}

ensure_file() {
  local path="$1"
  local label="$2"
  [[ -f "$path" ]] || fail "$label not found: $path"
}

ensure_dir() {
  local path="$1"
  local label="$2"
  if [[ ! -d "$path" ]]; then
    mkdir -p "$path"
    printf 'create: %s\n' "$path"
  fi
}

ensure_task_exists() {
  local tasks_file="$1"
  local task_id="$2"

  ensure_file "$tasks_file" "tasks file"

  if ! grep -Fq -- "- Task ID: \`$task_id\`" "$tasks_file"; then
    fail "task id not found in $tasks_file: $task_id"
  fi
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[|&\\]/\\&/g'
}

render_template() {
  local template="$1"
  shift

  ensure_file "$template" "prompt template"

  local sed_args=()
  local pair key value escaped_value

  for pair in "$@"; do
    key="${pair%%=*}"
    value="${pair#*=}"
    escaped_value="$(escape_sed_replacement "$value")"
    sed_args+=(-e "s|{{$key}}|$escaped_value|g")
  done

  sed "${sed_args[@]}" "$template"
}
