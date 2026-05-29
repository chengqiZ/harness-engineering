#!/usr/bin/env bash

set -euo pipefail

HARNESS_DIR=".ai-harness"
STANDARDS_DIR="$HARNESS_DIR/.ai-standards"
TARGET_REF="${1:-}"

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
  bash scripts/update_business_standards.sh [tag-or-sha]

Run this from a business repository root after AI Coding Harness has already
been initialized. Without an argument, it updates .ai-harness/.ai-standards to
the configured remote tracking revision. With an argument, it checks out that
tag or commit SHA inside the standards submodule.
USAGE
}

if [[ $# -gt 1 ]]; then
  usage
  exit 1
fi

[[ -d .git ]] || fail "current directory is not a git repository root"
[[ -e "$STANDARDS_DIR" ]] || fail "$STANDARDS_DIR not found; run init_business_repo.sh first"

before_rev="$(git -C "$STANDARDS_DIR" rev-parse --short HEAD 2>/dev/null || true)"

say "standards before: ${before_rev:-unknown}"

if [[ -n "$TARGET_REF" ]]; then
  say "fetch standards refs"
  git -C "$STANDARDS_DIR" -c protocol.file.allow=always fetch --tags origin

  say "checkout standards ref: $TARGET_REF"
  git -C "$STANDARDS_DIR" checkout "$TARGET_REF"
else
  say "update standards submodule from configured remote"
  git -c protocol.file.allow=always submodule update --remote --init --recursive "$STANDARDS_DIR"
fi

after_rev="$(git -C "$STANDARDS_DIR" rev-parse --short HEAD 2>/dev/null || true)"
say "standards after: ${after_rev:-unknown}"

say "run bootstrap to ensure local harness files exist"
bash "$STANDARDS_DIR/scripts/bootstrap_repo.sh"

say "verify daily entry"
./ai status

say ""
say "standards update complete"
say "next:"
say "1. Review the standards diff and generated status output."
say "2. If acceptable, commit the submodule pointer and any bootstrap-created files:"
say "   git add .ai-harness .github ai"
say "   git commit -m \"chore(standards): upgrade ai coding standards\""
say "3. If the update causes issues, check out the previous standards tag/SHA and rerun this script."
