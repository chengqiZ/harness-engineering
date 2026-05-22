#!/usr/bin/env bash

set -euo pipefail

# Keep detailed usage in scripts/README.md to reduce script-reading context.
if [[ $# -ne 2 ]]; then
  printf 'usage: bash .ai-harness/.ai-standards/scripts/prepare_spec_prompt.sh <spec-id> <source-doc>\n' >&2
  exit 1
fi

SPEC_ID="$1"
SOURCE_DOC="$2"
HARNESS_DIR=".ai-harness"
STANDARDS_DIR="$HARNESS_DIR/.ai-standards"
SPEC_DIR="$HARNESS_DIR/specs/$SPEC_ID"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE="$ROOT_DIR/templates/prompts/spec-preparation.md"

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

[[ -d .git ]] || fail "current directory is not a git repository root"
[[ -d "$STANDARDS_DIR" ]] || fail "$STANDARDS_DIR not found"
[[ -d "$SPEC_DIR" ]] || fail "$SPEC_DIR not found; run init_spec.sh first"
[[ -f "$SOURCE_DOC" ]] || fail "source document not found: $SOURCE_DOC"
[[ -f "$TEMPLATE" ]] || fail "prompt template not found: $TEMPLATE"

sed \
  -e "s|{{SPEC_ID}}|$SPEC_ID|g" \
  -e "s|{{SOURCE_DOC}}|$SOURCE_DOC|g" \
  "$TEMPLATE"
