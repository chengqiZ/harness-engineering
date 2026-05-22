#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf 'usage: bash .ai-harness/.ai-standards/scripts/init_spec.sh <spec-id>\n' >&2
  exit 1
fi

SPEC_ID="$1"
HARNESS_DIR=".ai-harness"
STANDARDS_DIR="$HARNESS_DIR/.ai-standards"
TARGET_DIR="$HARNESS_DIR/specs/$SPEC_ID"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

say() {
  printf '%s\n' "$1"
}

copy_template() {
  local name="$1"
  local src="$ROOT_DIR/templates/specs/$name"
  local dest="$TARGET_DIR/$name"

  if [[ -e "$dest" ]]; then
    say "skip: $dest already exists"
    return
  fi

  sed "s/<spec-id>/$SPEC_ID/g" "$src" > "$dest"
  say "create: $dest"
}

if [[ ! -d .git ]]; then
  say "error: current directory is not a git repository root"
  exit 1
fi

if [[ ! -d "$STANDARDS_DIR" ]]; then
  say "error: $STANDARDS_DIR not found"
  say "hint: run bootstrap after adding the submodule"
  exit 1
fi

mkdir -p "$TARGET_DIR"
copy_template "01-requirements.md"
copy_template "02-design.md"
copy_template "03-tasks.md"
copy_template "04-acceptance.md"

say ""
say "spec initialized: $TARGET_DIR"
say "manual follow-up:"
say "1. Fill $TARGET_DIR/01-requirements.md first."
say "2. Ask AI to review missing information before generating tasks."
say "3. Do not implement code before $TARGET_DIR/03-tasks.md is finalized."
