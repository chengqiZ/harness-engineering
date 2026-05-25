# Requirements

## Spec ID

- `prompt-automation-extension`

## Goal

- 为任务开发和 PR 准备阶段补充可复用的提示词生成脚本，减少手工替换参数的操作成本。

## In Scope

- 新增任务开发提示词生成脚本。
- 新增 PR 准备提示词生成脚本。
- 抽取共享的提示词模板渲染逻辑，统一占位符替换行为。
- 更新脚本说明文档，给出业务仓库中的直接调用方式。
- 在规范源仓库内完成静态和命令级验证。

## Out Of Scope

- 不接入 CI。
- 不直接调用任何 AI API。
- 不自动创建 Git 分支、commit 或 PR。

## Constraints

- Tech stack: Markdown + POSIX shell scripts
- Performance constraints: 提示词生成应为本地即时执行，无外部网络依赖
- Security/compliance constraints: 不输出 secrets、tokens、PII
- Delivery constraints: 业务仓库通过 `.ai-harness/.ai-standards/scripts/*.sh` 直接调用

## Success Metrics

- Metric 1: 业务仓库可通过命令直接生成任务开发提示词和 PR 准备提示词。
- Metric 2: 使用者不需要手动替换 `spec-id`、`task-id`、分支名等参数。
- Metric 3: 说明文档清楚回答“脚本是否可在业务仓库直接使用”。

## Assumptions

- Assumption 1: 业务仓库已通过 submodule 接入本规范源仓库。
- Assumption 2: 提示词模板继续保存在 `templates/prompts/`，脚本负责参数替换。

## Open Questions

- Q1: 后续是否需要继续扩展为统一的通用 prompt 渲染 CLI？
- Q2: 是否需要为更多阶段补充同类脚本，例如验收复盘提示词？
