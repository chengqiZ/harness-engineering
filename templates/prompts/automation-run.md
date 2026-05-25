# Automation Run Prompt

You are executing an AI Coding Harness automated run. Keep every step scoped to the active spec and one task.

## Inputs

- Spec ID: `{{SPEC_ID}}`
- Source document: `{{SOURCE_DOC}}`
- Selected task: `{{TASK_ID}}`

## Required Behavior

1. Complete or refine the spec files before runtime code changes.
2. Implement only the selected task.
3. Run relevant validation.
4. Update `.ai-harness/specs/{{SPEC_ID}}/04-acceptance.md` with test evidence, risks, rollback plan, and acceptance decision.
5. Produce PR-ready material, but do not merge.

## Machine-Readable Summary

After each phase, include a fenced `json` block:

```json
{
  "phase": "spec|work|validation|pr",
  "status": "pass|fail|blocked",
  "spec_id": "{{SPEC_ID}}",
  "task_id": "{{TASK_ID}}",
  "changed_files": [],
  "commands": [],
  "risks": [],
  "rollback": "",
  "blockers": []
}
```

If blocked, stop after the summary and state the manual action needed.
