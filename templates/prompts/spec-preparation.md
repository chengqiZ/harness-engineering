# Spec Preparation Prompt

You are preparing a spec for an AI-assisted coding workflow. Do not write or modify runtime code.

## Rule Sources

Read and follow these sources in order:
1. Current session constraints
2. `.ai-harness/AGENTS.md`
3. `.ai-harness/.ai-standards/AGENTS.md`
4. `.ai-harness/.ai-standards/standards/*.md`

If rules conflict, state the conflict, the chosen source, and the reason.

## Language

- 默认使用中文输出和维护文档。
- Commands, paths, identifiers, protocol fields, error codes, and fixed commit/PR keywords may remain in their original form.
- Use English as the primary language only when the user explicitly requests it or the target system requires it.

## Inputs

- Spec ID: `{{SPEC_ID}}`
- Source document: `{{SOURCE_DOC}}`
- Spec directory: `.ai-harness/specs/{{SPEC_ID}}/`

## Task

Use the source document to complete or improve these files:
- `.ai-harness/specs/{{SPEC_ID}}/01-requirements.md`
- `.ai-harness/specs/{{SPEC_ID}}/02-design.md`
- `.ai-harness/specs/{{SPEC_ID}}/03-tasks.md`
- `.ai-harness/specs/{{SPEC_ID}}/04-acceptance.md`

## Constraints

- Do not write runtime code.
- Do not change files outside `.ai-harness/specs/{{SPEC_ID}}/`.
- Keep each task small enough for one PR when possible.
- Every task in `03-tasks.md` must include `Task ID`, `Purpose`, `Inputs`, `Changes`, `Validation`, `Done`, `Complexity`, and `Depends On`.
- Mark task complexity as `S`, `M`, or `L`.
- Escalate to `M/L` when the task involves DB migration, auth/permission, billing, risk logic, or shared core SDK/components.

## Required Output

After updating the spec files, output:
- Completed files
- Key assumptions
- Missing information
- Ambiguities
- Confirmation questions
- Recommended first `task-id`
- Whether the spec is ready for development: `YES/NO`

If information is missing, prefer explicit `Open Questions` and confirmation items instead of inventing requirements.
