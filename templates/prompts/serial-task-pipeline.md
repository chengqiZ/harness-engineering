# Serial Task Pipeline Prompt

你现在位于一个已接入 AI Coding Harness 的业务代码仓库根目录中。

## Inputs

- Spec ID: `{{SPEC_ID}}`
- Source document: `{{SOURCE_DOC}}`
- Target branch: `{{TARGET_BRANCH}}`

如果 source document 为空或不可用，但当前 spec 目录已经存在，请基于当前 spec 继续执行。

## Execution Mode

- Default: `codex-managed`
- Current: `portable-managed`

Mode rules:
- `codex-managed`: 由 `./ai` 调度 Codex，默认可读写仓库、运行命令、执行验证，并按单 task 边界执行。
- `portable-managed`: 用于其他具备仓库读写能力的 AI 工具。开始时只需简要确认可读取文件、可修改文件、可运行必要验证；若能力满足任务要求，直接继续。只有能力不足、高风险操作、破坏性操作、规则冲突或缺少关键输入时，才暂停等待人工确认。
- `prompt-only`: 不修改文件、不运行命令、不声称已验证；只输出可执行步骤、patch、检查清单、评审意见或 PR 文案。

## Rule Sources

请按以下优先级读取并遵循规范：
1. 当前会话约束
2. `.ai-harness/AGENTS.md`
3. `.ai-harness/.ai-standards/AGENTS.md`
4. `.ai-harness/.ai-standards/standards/*.md`
5. `.ai-harness/.ai-standards/templates/prompts/*.md`

如果规则冲突，请输出冲突点、采用的规则来源和理由。

## Language

- 默认使用中文回复、更新文档和输出报告。
- Commands, paths, identifiers, protocol fields, error codes, and fixed commit/PR keywords may remain in their original form.
- Use English as the primary language only when the user explicitly requests it or the target system requires it.

## Prohibited Actions

- 不要执行 `./ai run`、`./ai spec`、`./ai work`、`./ai pr`，这些是 Codex 调度入口。
- 不要把多个 `task-id` 混在一个 PR、commit 或未隔离的变更集中。
- 不要做超出当前 `task-id` 的额外重构或功能。
- 不要直接合并到目标分支。
- 不要执行破坏性命令，除非人工明确确认。
- 不要在验证未执行时声称测试已经通过。

## Goal

按当前 spec 的 `03-tasks.md` 依赖顺序串行执行 task，并保持每个 `task-id` 独立闭环。

如果 spec 四件套不存在或不完整，请先参考 `spec-preparation.md` 创建或完善：
- `01-requirements.md`
- `02-design.md`
- `03-tasks.md`
- `04-acceptance.md`

创建或完善 spec 后，先输出推荐的第一个 ready task，并暂停等待人工确认是否开始开发。

## Startup Checks

开始时执行以下检查并简要报告结果：
1. 确认当前仓库根目录。
2. 确认 `.ai-harness/.ai-standards` 存在。
3. 读取相关 `AGENTS.md` 和 `standards`。
4. 检查当前 spec 目录是否存在。
5. 检查 `git status`。
6. 判断当前是否可以进入第一个 ready task。

## Serial Execution Rules

1. 一次只执行一个 `task-id`。
2. 每个 `task-id` 必须独立完成闭环：
   - 读取该 task 的 `Purpose`、`Inputs`、`Changes`、`Validation`、`Done`、`Complexity`、`Depends On`
   - 只实现该 `task-id` 范围
   - 为类/模块、公开方法、重要字段/状态、复杂条件分支、边界处理、外部假设和风险逻辑补充必要注释
   - 注释必须解释职责、意图、业务含义、约束或不变量，不要只复述显而易见的语法
   - 运行相关验证命令
   - 更新 `04-acceptance.md`，记录测试证据、风险、回滚方案、comment review result 和验收结论
   - 输出 changed files、test evidence、risks、rollback、comment review result、pending items
   - 准备 PR 材料和建议 commit message
3. 完成一个 `task-id` 后必须暂停，输出当前状态，并等待人工确认是否继续下一个 task。
4. 如果人工明确回复“继续下一个 task”，再按依赖顺序选择下一个 ready task。
5. 如果人工明确授权“自动继续 S 级 task”，也只能自动继续满足以下条件的 task：
   - `Complexity` 为 `S`
   - `Depends On` 已完成
   - 非 DB migration、auth/permission、billing、risk logic、shared core SDK/components 等高风险任务
   - 当前验证通过
   - 工作区状态清晰
6. 遇到以下情况必须暂停：
   - 下一个 task 是 `M` 或 `L`
   - 高风险变更
   - 验证失败
   - Open Questions 未解决
   - 规则冲突
   - 需要 rebase、merge 或处理复杂冲突
   - 工作区存在不属于当前 task 的改动
   - 无法确认上一个 task 的 PR、commit 或变更边界

## PR And Commit Rules

- 一个 PR 只对应一个 `task-id`。
- Commit subject format: `<type>(<scope>): <summary>`
- Commit body must contain:
  - `Why`
  - `What`
  - `Validation`
- 如果你可以提交和推送，提交或推送前必须先展示 diff 摘要、测试证据、风险、回滚方案和 commit message，并等待人工确认。
- 如果你不能提交或推送，只生成 PR-ready 材料，不要声称已提交或已推送。

## Output After Each Task

每个 `task-id` 完成后的输出必须包含：
- spec link
- task id
- changed files
- test evidence
- risks
- rollback plan
- comment review result
- pending items
- suggested commit message
- PR description markdown
- next ready task, if any
- 是否建议继续：`YES/NO`，并说明原因
