# Requirements

## 背景

- 当前仓库定位为 AI Coding Harness 的规范源仓库，用于沉淀统一规则、模板和 SOP，不承载业务功能开发。
- 现有资料已具备主方案、操作手册、规范文件和基础 specs 模板，但还需要统一业务仓库目录结构，并降低首次接入的人工操作成本。

## 研究问题

- 规范源仓库还缺哪些资料，才能支持业务仓库低成本接入和首次验证？
- 首次试点时，团队成员需要哪些固定模板和 SOP，才能减少执行偏差？
- 如何把业务仓库中的规范相关文件集中到单一目录，并通过脚本自动完成初始化？
- 如何引导其他 AI 程序基于需求文档或方案文档补齐 spec 模板，并在确认后进入开发？

## Goal

- 补齐规范源仓库的落地资料包，使其能够直接支持业务仓库首次接入、首次闭环验证和后续规范升级。
- 统一业务仓库的规范目录为 `.ai-harness/`，并提供最小自动化脚本以减少手工复制模板。
- 提供 spec intake/preparation 自动化入口，引导 AI 从原始文档补齐 spec 四件套。

## In Scope

- 新增 PR 模板、changelog 模板、规范升级评估模板、例外规则模板、项目接入检查清单。
- 新增一个完整示例 spec，演示 requirements/design/tasks/acceptance 的闭环写法。
- 新增面向业务仓库的首次验证 SOP。
- 补充主方案和操作手册，明确当前仓库是规范源仓库，并链接新增资料。
- 统一文档中的业务仓库路径约定为 `.ai-harness/`。
- 新增业务仓库初始化脚本与 spec 初始化脚本。
- 新增 spec preparation prompt 模板、prompt 生成脚本与 spec 完整性检查脚本。
- 新增 `scripts/README.md`，集中说明脚本用途、参数和执行顺序。

## Out Of Scope

- 不新增 CI 校验。
- 不改动现有 standards 的技术规则本身。
- 不直接接入任何真实业务仓库。

## Constraints

- Tech stack: Markdown + POSIX shell scripts
- Performance constraints: N/A
- Security/compliance constraints: 不包含真实仓库地址、密钥、PII
- Delivery constraints: 保持脚本轻量、无外部依赖、可在常见 bash 环境执行

## Success Metrics

- Metric 1: 规范源仓库具备业务仓库首次接入所需的核心模板与 SOP。
- Metric 2: 新成员可通过 1-2 条命令完成业务仓库初始化与 spec 初始化。
- Metric 3: 新成员可用一条命令生成给 AI 的 spec preparation 提示词，并用检查脚本判断是否可进入开发。

## Assumptions

- Assumption 1: 业务仓库会通过 Git submodule 在 `/.ai-harness/.ai-standards` 引入本仓库。
- Assumption 2: 团队会使用 Spec 驱动流程推进需求和单任务开发。

## Open Questions

- Q1: 后续是否需要增加 CI/PR 自动检查以强制执行模板？
- Q2: 是否需要针对不同技术栈再提供多套 design 示例？
- Q3: 业务仓库是否还需要 repo-level 快捷命令封装以隐藏 `.ai-harness/scripts/*` 路径？
