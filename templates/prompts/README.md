# Prompt Templates

This directory stores reusable prompts for the AI-assisted delivery workflow.

## Available Templates

- `spec-preparation.md`
  - Convert an existing PRD or design doc into `01-requirements.md`, `02-design.md`, `03-tasks.md`, and `04-acceptance.md`.

- `task-development.md`
  - Drive development for one `task-id` only, with scope control, validation, and acceptance updates.

- `pr-preparation.md`
  - Prepare a pull request summary and review materials after a single task is complete.

## Placement Rule

- Put reusable prompt text in `templates/prompts/`.
- Put SOPs, checklists, and explanatory guidance in `docs/`.
- Put executable automation in `scripts/`.
