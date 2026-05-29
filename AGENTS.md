# Agent Rules

## Scope

This directory is for AI coding research and engineering rollout materials, not a runtime app repo.

Priority order:
- `session constraints`
- `repo AGENTS.md`
- `standards/*.md`
- `global memories`

Code standards reference:
- `standards/frontend.md`
- `standards/backend.md`
- `standards/api-contract.md`
- `standards/testing.md`

## Required Outputs

- 后续文档、模板、SOP、报告和面向用户的回复默认使用中文。
- 保留代码标识符、命令、路径、协议字段、错误码、commit/PR 格式关键字等原文；引用英文资料时应给出中文解释或摘要。
- 只有在用户明确要求英文、目标系统强制英文、或模板字段本身必须英文时，才使用英文作为主要表达语言。

Research documents should be reusable and actionable. Prefer:
- SOPs
- templates
- checklists
- decision records

For analysis docs, use:
- 背景
- 研究问题
- 结论摘要
- 方案对比
- 风险与限制
- 推荐做法
- 落地步骤
- 验收标准

## Execution Rules (Mandatory)

### Workflow Gate
- This source repository does not use top-level `specs/` as its own execution log; reusable spec skeletons live in `templates/specs/`.
- For business repository work, no code change before `.ai-harness/specs/<spec-id>/01-requirements.md` and `03-tasks.md` exist.
- For this source repository, keep changes scoped to the user-approved maintenance task and document validation in the final report.
- Business repository PRs map to exactly one `task-id`; source repository maintenance PRs should keep one coherent maintenance topic.
- Out-of-scope refactor is not allowed without explicit approval.
- For FE/BE coding conventions and API constraints, follow `standards/*.md`.

### Task Card Schema
Each task in `03-tasks.md` must include:
- `Task ID`
- `Purpose`
- `Inputs`
- `Changes`
- `Validation`
- `Done`
- `Complexity`
- `Depends On`

### Task Sizing
- `S`: single module, single PR
- `M`: 2-3 modules, requires `02-design.md`
- `L`: cross FE/BE or cross-service, must split

Escalate to `M/L` when the task involves DB migration, auth/permission, billing, risk logic, or shared core SDK/components.

## Git Rules (Mandatory)

### Branch Naming
- `feat/<spec-id>-<task-id>`
- `fix/<spec-id>-<task-id>`
- `chore/<topic>`
- `hotfix/<issue-id>`

### Commit Format
`<type>(<scope>): <summary>`

Commit body must contain:
- `Why`
- `What`
- `Validation`

### PR Constraints
- One PR for one `task-id`
- Recommended max: changed lines `<= 400` (exclude generated/lock files)
- Recommended max: changed files `<= 12`
- If exceeded, split or explain unsplittable reason

### Merge Policy
- No direct push to `main`
- Rebase to latest `main` before merge
- Squash merge by default

## Testing And Validation (Mandatory)

- Behavior changes require tests.
- Bug fixes require regression tests.
- If tests cannot run, provide the blocking reason, manual verification steps, and expected results.

Validation output must include:
- executed commands
- pass/fail summary
- blocker details (if failed)

## Security And Risk (Mandatory)

- Never expose secrets/tokens/PII in code, logs, or docs.
- Explicit confirmation required for destructive data operations, bulk migration, permission model changes.
- High-risk changes must include rollback plan and impact scope.

## PR Output Format (Mandatory)

Every PR/report must include:
- spec link
- task id
- changed files
- test evidence
- risks
- rollback plan
- pending items

## Changelog And Exceptions

- For each merged PR in a business repo, add one entry in `.ai-harness/docs/changelog/` with `spec-id`, `task-id`, affected modules, compatibility impact, rollback method.
- Any exception must declare `Exception`, `Reason`, `Scope`, `Expiry` in PR.
- Without explicit exception note, rules are fully enforced.
