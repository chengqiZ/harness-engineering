#!/usr/bin/env bash

codex_fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

codex_bin() {
  if [[ -n "${CODEX_BIN:-}" ]]; then
    [[ -x "$CODEX_BIN" ]] && printf '%s\n' "$CODEX_BIN"
    return
  fi
  command -v codex 2>/dev/null || true
}

codex_require() {
  local bin
  bin="$(codex_bin)"
  [[ -n "$bin" ]] || codex_fail "codex executable not found; install Codex CLI or run the prepare_*_prompt.sh scripts manually"
  printf '%s\n' "$bin"
}

codex_log_dir() {
  mkdir -p .ai-harness/logs
  printf '.ai-harness/logs\n'
}

codex_exec_approval_args() {
  local bin="$1"
  if "$bin" exec --help 2>/dev/null | grep -q -- '--ask-for-approval'; then
    printf '%s\n' "--ask-for-approval"
    printf '%s\n' "never"
  else
    printf '%s\n' "-c"
    printf '%s\n' "approval_policy=\"never\""
  fi
}

codex_run_prompt() {
  local repo_dir="$1"
  local prompt="$2"
  local label="$3"
  local bin log_dir log_file approval_args=()

  bin="$(codex_require)"
  log_dir="$(codex_log_dir)"
  log_file="$log_dir/${label}-$(date +%Y%m%d-%H%M%S).log"
  mapfile -t approval_args < <(codex_exec_approval_args "$bin")

  printf 'codex: %s\n' "$bin"
  printf 'log: %s\n' "$log_file"

  "$bin" exec \
    -C "$repo_dir" \
    --sandbox workspace-write \
    "${approval_args[@]}" \
    "$prompt" 2>&1 | tee "$log_file"
}

codex_run_command_output_as_prompt() {
  local repo_dir="$1"
  local label="$2"
  shift 2
  local prompt

  prompt="$("$@")"
  codex_run_prompt "$repo_dir" "$prompt" "$label"
}
