# Project Agent Rules

## Scope

- This file is for project-specific exceptions and local execution notes only.
- Shared rules come from `.ai-harness/.ai-standards/AGENTS.md` and `.ai-harness/.ai-standards/standards/*.md`.

## Required Exception Format

- `Reason`
- `Scope`
- `Expiry`

## Example

### Exception 1

- Reason: This project still uses a legacy deployment pipeline that cannot consume squash-only history.
- Scope: Release branch workflow only
- Expiry: Remove after deployment platform migration completes
