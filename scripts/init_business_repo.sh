#!/usr/bin/env bash

set -euo pipefail

HARNESS_DIR=".ai-harness"
STANDARDS_DIR="$HARNESS_DIR/.ai-standards"

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
  bash scripts/init_business_repo.sh <standards-repo-url-or-path>

Run this from a business repository root. It adds the standards repository as
.ai-harness/.ai-standards, runs bootstrap_repo.sh, then verifies ./ai status.
USAGE
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

STANDARDS_REPO="$1"

[[ -d .git ]] || fail "current directory is not a git repository root"

if [[ -e "$STANDARDS_DIR" ]]; then
  say "skip: $STANDARDS_DIR already exists"
else
  say "add submodule: $STANDARDS_REPO -> $STANDARDS_DIR"
  if [[ "$STANDARDS_REPO" = /* || "$STANDARDS_REPO" = ./* || "$STANDARDS_REPO" = ../* ]]; then
    git -c protocol.file.allow=always submodule add "$STANDARDS_REPO" "$STANDARDS_DIR"
  else
    git submodule add "$STANDARDS_REPO" "$STANDARDS_DIR"
  fi
fi

say "update submodule"
git submodule update --init --recursive

say "bootstrap harness"
bash "$STANDARDS_DIR/scripts/bootstrap_repo.sh"

say "verify daily entry"
./ai status

say ""
say "init complete"
say "next:"
say "1. Review .ai-harness/AGENTS.md and keep only project-specific exceptions."
say "2. Commit .gitmodules, .ai-harness, .github, and ai."
say "3. Run './ai run <spec-id> <source-doc>' for a new request."
