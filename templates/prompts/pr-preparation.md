# PR Preparation Prompt

You are preparing a pull request for a completed single task. This prompt is for review readiness and PR drafting, not for direct merge execution.

## Context

- Spec ID: `{{SPEC_ID}}`
- Task ID: `{{TASK_ID}}`
- Target branch: `{{TARGET_BRANCH}}`
- Current branch: `{{FEATURE_BRANCH}}`
- Requirements: `.ai-harness/specs/{{SPEC_ID}}/01-requirements.md`
- Design: `.ai-harness/specs/{{SPEC_ID}}/02-design.md`
- Tasks: `.ai-harness/specs/{{SPEC_ID}}/03-tasks.md`
- Acceptance: `.ai-harness/specs/{{SPEC_ID}}/04-acceptance.md`
- Rule sources: `.ai-harness/AGENTS.md`, `.ai-harness/.ai-standards/standards/frontend.md`, `.ai-harness/.ai-standards/standards/backend.md`, `.ai-harness/.ai-standards/standards/api-contract.md`, `.ai-harness/.ai-standards/standards/testing.md`

## Language

- 默认使用中文生成评审摘要、验证说明和 PR 描述。
- Commands, paths, identifiers, protocol fields, error codes, and fixed commit/PR keywords may remain in their original form.
- Use English as the primary language only when the user explicitly requests it or the target system requires it.

## Checks

1. Verify the current changes only cover `{{TASK_ID}}`. If there are out-of-scope changes, list them explicitly.
2. Check repository constraints:
   - one PR maps to one `task-id`
   - behavior changes have tests
   - bug fixes have regression tests
   - risks and rollback plan are documented
3. Check whether `.ai-harness/specs/{{SPEC_ID}}/04-acceptance.md` has been updated with actual test evidence and the current acceptance decision. If not, list the gap.

## Required Output

Produce a PR-ready summary that includes:
- spec link
- task id
- changed files
- test evidence
- risks
- rollback plan
- pending items

Also report validation details:
- executed commands
- pass/fail summary
- blocker details, if any

Provide a suggested commit message:
- subject format: `<type>(<scope>): <summary>`
- body sections:
  - `Why`
  - `What`
  - `Validation`

Generate a Markdown PR description with this structure:
- `PR readiness summary`
- `scope check`
- `validation result`
- `risks and rollback`
- `suggested commit message`
- `PR description markdown`

## Notes

- `PR` means `Pull Request`, not direct merge.
- Do not merge code as part of this task unless explicitly requested.
