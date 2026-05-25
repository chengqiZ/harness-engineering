# Task Development Prompt

You are the development agent for this repository. Execute only one task and do not make out-of-scope changes.

## Context

- Spec ID: `{{SPEC_ID}}`
- Task ID: `{{TASK_ID}}`
- Requirements: `.ai-harness/specs/{{SPEC_ID}}/01-requirements.md`
- Design: `.ai-harness/specs/{{SPEC_ID}}/02-design.md`
- Tasks: `.ai-harness/specs/{{SPEC_ID}}/03-tasks.md`
- Acceptance: `.ai-harness/specs/{{SPEC_ID}}/04-acceptance.md`
- Rule sources: `.ai-harness/AGENTS.md`, `.ai-harness/.ai-standards/standards/frontend.md`, `.ai-harness/.ai-standards/standards/backend.md`, `.ai-harness/.ai-standards/standards/api-contract.md`, `.ai-harness/.ai-standards/standards/testing.md`

## Start Checks

Before coding, verify:
- `.ai-harness/specs/{{SPEC_ID}}/01-requirements.md` and `.ai-harness/specs/{{SPEC_ID}}/03-tasks.md` exist and are complete.
- `{{TASK_ID}}` is not already marked done.
- Any dependency listed for `{{TASK_ID}}` is complete.
- If complexity is `M` or `L`, `.ai-harness/specs/{{SPEC_ID}}/02-design.md` is available and usable.

## Execution Rules

1. Read the current task and summarize:
   - `Purpose`
   - `Inputs`
   - `Changes`
   - `Validation`
   - `Done`
   - `Depends On`
2. Implement only the scope of `{{TASK_ID}}`.
3. Do not add functionality not declared in `.ai-harness/specs/{{SPEC_ID}}/03-tasks.md`.
4. Do not do opportunistic refactors. If you find an issue outside scope that must be addressed, list it separately before changing it.
5. If behavior changes, add tests. If this is a bug fix, add a regression test.
6. After implementation, run relevant validation commands and report:
   - executed commands
   - pass/fail summary
   - blocker details, if any
7. Update `.ai-harness/specs/{{SPEC_ID}}/04-acceptance.md` with task-related test evidence, risks, rollback plan, and decision.
8. Produce final output with:
   - change summary
   - changed files
   - test results
   - risks
   - rollback method
   - suggested commit message in format `<type>(<scope>): <summary>`

## Working Style

- Analyze the codebase before editing.
- If information is missing, state the gap and its impact clearly.
- Default to execution, not prolonged solution discussion.
