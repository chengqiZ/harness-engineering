# Tasks

## Spec ID

- `prompt-automation-extension`

## Task List

### T1
- Task ID: `T1`
- Purpose: 补充任务开发和 PR 准备提示词的自动化生成入口。
- Inputs:
  - `templates/prompts/task-development.md`
  - `templates/prompts/pr-preparation.md`
  - `scripts/prepare_spec_prompt.sh`
  - `scripts/README.md`
- Changes:
  - 新增共享提示词渲染脚本库。
  - 新增 `prepare_task_prompt.sh`。
  - 新增 `prepare_pr_prompt.sh`。
  - 改造 `prepare_spec_prompt.sh` 复用共享渲染逻辑。
  - 更新 `scripts/README.md` 说明调用方式和业务仓库复用前提。
- Validation:
  - 运行三个脚本，检查输出中是否包含替换后的 `spec-id`、`task-id`、`source-doc`、分支名。
  - 检查脚本 usage 和缺参报错是否正确。
- Done:
  - 使用者可以通过脚本直接生成可复制给 AI 的任务开发和 PR 准备提示词，无需手动替换参数。
- Complexity: `M`
- Depends On:
  - None

## Execution Rules

- One PR maps to one `task-id`.
- Do not implement tasks not listed here.
- Out-of-scope refactor requires explicit approval.

## Progress

- [x] T1
