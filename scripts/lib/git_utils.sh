#!/usr/bin/env bash

git_fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

git_current_branch() {
  git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null || printf 'HEAD\n'
}

git_is_dirty() {
  [[ -n "$(git status --porcelain)" ]]
}

git_dirty_summary() {
  git status --short
}

git_remote_url() {
  git remote get-url origin 2>/dev/null || true
}

git_ensure_branch() {
  local branch="$1"
  if [[ "$(git_current_branch)" = "$branch" ]]; then
    printf 'branch: already on %s\n' "$branch"
    return
  fi
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git switch "$branch"
  else
    git switch -c "$branch"
  fi
}

git_named_stash_if_dirty() {
  local label="$1"
  local stamp stash_name

  if ! git_is_dirty; then
    return 0
  fi

  stamp="$(date +%Y%m%d-%H%M%S)"
  stash_name="ai-harness-${label}-${stamp}"
  git stash push -u -m "$stash_name" >/dev/null
  printf '%s\n' "$stash_name"
}

git_named_stash_excluding() {
  local label="$1"
  shift
  local stamp stash_name exclude pathspecs=(".")

  if ! git_is_dirty; then
    return 0
  fi

  for exclude in "$@"; do
    [[ -n "$exclude" ]] || continue
    pathspecs+=(":(exclude)$exclude")
  done

  stamp="$(date +%Y%m%d-%H%M%S)"
  stash_name="ai-harness-${label}-${stamp}"
  if git stash push -u -m "$stash_name" -- "${pathspecs[@]}" >/dev/null; then
    if git stash list -n 1 | grep -Fq "$stash_name"; then
      printf '%s\n' "$stash_name"
    fi
  fi
}

git_commit_all() {
  local message_file="$1"
  git add -A
  if git diff --cached --quiet; then
    printf 'commit: no staged changes\n'
    return 0
  fi
  git commit -F "$message_file"
}

git_push_current() {
  local branch
  branch="$(git_current_branch)"
  git push -u origin "$branch"
}

git_changed_files() {
  local target_branch="$1"
  git diff --name-only "$target_branch"...HEAD 2>/dev/null || git diff --name-only HEAD
}
