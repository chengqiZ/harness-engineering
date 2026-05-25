# AI Coding Harness 操作指导手册（Submodule 版）

## 1. 使用前提

- 当前仓库是规范源仓库，用于维护统一规则、模板、示例和 SOP。
- 你有一个规范源仓库：`ai-coding-standards`
- 业务仓库通过 submodule 引入到：`/.ai-harness/.ai-standards`
- 业务仓库的规范相关内容统一放在：`/.ai-harness/`
- `/.ai-harness/AGENTS.md` 只放项目特例

建议先阅读：
- 主方案：`AI_CODING_HARNESS_完整方案.md`
- 首次验证 SOP：`docs/业务仓库首次验证SOP.md`
- 项目接入清单：`templates/project-onboarding-checklist.md`

## 2. 一次性初始化（新业务仓库）

```bash
git submodule add <repo-url-of-ai-coding-standards> .ai-harness/.ai-standards
git submodule update --init --recursive
bash .ai-harness/.ai-standards/scripts/bootstrap_repo.sh
git add .gitmodules .ai-harness .github
git commit -m "chore(harness): setup ai coding harness"
```

初始化后需要人工补齐：
- `/.ai-harness/AGENTS.md`
- 业务仓库的首个 `spec-id`

初始化后优先验证：

```bash
./ai status
```

## 3. 日常自动化流程

业务仓库根目录提供单一入口 `./ai`：

```bash
./ai status
./ai spec <spec-id> <source-doc>
./ai next <spec-id>
./ai work <spec-id> <task-id>
./ai pr <spec-id> <task-id> [target-branch]
./ai run <spec-id> <source-doc>
```

推荐日常用法：

1. 从需求文档生成 spec 并自动推进首个 `S` 任务：

```bash
./ai run <spec-id> <source-doc>
```

2. 已有 spec 时，查看下一个可执行任务：

```bash
./ai next <spec-id>
```

3. 只执行一个任务：

```bash
./ai work <spec-id> <task-id>
```

4. 任务完成后整理 MR 材料、提交并推送：

```bash
./ai pr <spec-id> <task-id> main
```

自动化边界：
- `S` 任务可在 spec 检查通过后自动进入开发。
- `M/L`、Open Questions、DB/auth/权限/billing/风险逻辑相关任务会暂停并要求人工确认。
- `./ai work` 开始前会把已有脏工作区保存成 named stash，输出恢复提示；当前 spec 文件如有未提交修改会保留在工作区作为任务上下文。
- `./ai pr` 提交和推送前必须暂停，展示 diff 摘要、测试证据、风险、回滚方案、commit message 和 MR 描述。
- v1 不调用 GitLab API 创建 MR，只生成可粘贴的 MR 材料。

## 4. 高级/排错流程：逐脚本使用

1. 运行 `bash .ai-harness/.ai-standards/scripts/init_spec.sh <spec-id>`
2. 运行 `bash .ai-harness/.ai-standards/scripts/prepare_spec_prompt.sh <spec-id> <source-doc>`
3. 将输出提示词交给 AI，基于需求文档或方案文档补齐 4 个文件：
- `01-requirements.md`
- `02-design.md`
- `03-tasks.md`
- `04-acceptance.md`
4. 你确认 spec、Open Questions 和推荐 task
5. 运行 `bash .ai-harness/.ai-standards/scripts/check_spec.sh <spec-id>`
6. AI 先拆任务，后开发
7. 一次只做一个 `task-id`
8. 每次提交附验证证据

## 5. 可直接复制的提示词（重点）

### 5.1 通用启动提示词（每个需求第一条）

```text
请按以下优先级读取并遵循规范：
1) 当前会话约束
2) .ai-harness/AGENTS.md
3) .ai-harness/.ai-standards/AGENTS.md
4) .ai-harness/.ai-standards/standards/*.md

如果规则冲突，请在输出中明确：
- 冲突点
- 采用的规则来源
- 理由

先不要写代码，先审阅 .ai-harness/specs/<spec-id>/01-requirements.md 并输出缺失项与歧义问题清单。
```

### 5.2 需求澄清提示词

```text
基于 .ai-harness/specs/<spec-id>/01-requirements.md，
请输出：
1) 缺失信息（按高/中/低优先级）
2) 歧义点
3) 可执行的补充建议
要求：仅输出可落地结论，不输出泛化建议。
```

### 5.3 任务拆解提示词

```text
请基于 .ai-harness/specs/<spec-id>/01-requirements.md 和 .ai-harness/.ai-standards 规范生成 .ai-harness/specs/<spec-id>/03-tasks.md。
要求：
1) 每个任务必须包含 Task ID/Purpose/Inputs/Changes/Validation/Done
2) 标注任务依赖关系
3) 每个任务可在一个PR内完成
4) 标记任务复杂度 S/M/L，并说明原因
```

### 5.4 设计文档提示词（Vue + Java + MySQL）

```text
请生成 .ai-harness/specs/<spec-id>/02-design.md，遵循 .ai-harness/.ai-standards/standards/*：
1) 前端：页面状态、交互流、错误态、Pinia/store与service边界
2) 后端：controller/service/repository 分层、DTO、异常模型
3) 数据库：MySQL表结构变更、索引策略、迁移与回滚方案
4) API：请求响应契约、错误码、兼容策略
```

### 5.5 单任务开发提示词

```text
现在只实现 .ai-harness/specs/<spec-id>/03-tasks.md 中的 <task-id>。
严格遵循：
- .ai-harness/AGENTS.md
- .ai-harness/.ai-standards/AGENTS.md
- .ai-harness/.ai-standards/standards/*.md

执行步骤：
1) 先输出文件级修改计划（不要改代码）
2) 再实现代码（仅限该 task-id）
3) 输出测试命令与结果
4) 输出风险与回滚方案

限制：
- 不做额外重构
- 不触碰无关模块
- 若需要突破限制，先说明并等待确认
```

### 5.6 代码评审提示词

```text
请按“高风险优先”评审本次改动，基于 .ai-harness/.ai-standards 规范输出：
1) 严重问题（必须修复）
2) 潜在回归风险
3) 缺失测试
4) API/数据库兼容性问题
5) 可选优化项

每条问题给出：
- 影响
- 证据（文件/逻辑点）
- 修复建议
```

### 5.7 PR 说明生成提示词

```text
请为 <task-id> 生成 PR 描述，必须包含：
1) Spec 链接
2) Task ID
3) 变更文件清单
4) 测试命令与结果
5) 风险
6) 回滚方案
7) Exception/Reason/Scope/Expiry（如有例外）
```

### 5.8 发布前验收提示词

```text
请按 .ai-harness/specs/<spec-id>/04-acceptance.md 与 .ai-harness/.ai-standards/standards/testing.md 规范做最终验收。
输出：
1) 通过项
2) 不通过项
3) 阻塞项
4) 是否允许合并（YES/NO）
并给出依据。
```

### 5.9 规范升级提示词（子模块版本升级后）

```text
当前项目已将 .ai-harness/.ai-standards 升级到 <tag-or-sha>。
请扫描本仓库并输出：
1) 新规范可能影响的流程点
2) 需要调整的项目特例（AGENTS.md）
3) 可能导致失败的测试或门禁
4) 建议的修复顺序（P0/P1/P2）
```

## 6. 子模块升级操作

```bash
git submodule update --remote .ai-harness/.ai-standards
cd .ai-harness/.ai-standards && git checkout <tag-or-sha> && cd ../..
git add .ai-harness/.ai-standards
git commit -m "chore(standards): upgrade .ai-harness/.ai-standards to <tag-or-sha>"
```

升级后必须执行：
- 运行“规范升级提示词”
- 提交升级影响评估

## 7. 常见问题

### Q1：AI 没有读取子模块规范怎么办？
- 在第一条提示词里明确列出规范读取顺序（见 5.1）。
- 要求 AI 先“复述已读取的规范来源”。

### Q2：项目需要例外规则怎么办？
- 写在 `/.ai-harness/AGENTS.md`，并加 `Reason/Scope/Expiry`。

### Q3：规范升级后有回归怎么办？
- 回退 `.ai-harness/.ai-standards` 到上一个稳定 tag/SHA，单独提 PR。

## 8. 日常最短使用法（3条）

1. 自动化优先：`./ai run <spec-id> <source-doc>`
2. 单任务开发：`./ai work <spec-id> <task-id>`
3. 合并前整理：`./ai pr <spec-id> <task-id> main`

如果已有需求文档或方案文档，先运行：

```bash
bash .ai-harness/.ai-standards/scripts/prepare_spec_prompt.sh <spec-id> <source-doc>
```

再把输出提示词交给 AI 补齐 spec。

## 9. 规范源仓库维护者补充动作

当你维护当前规范源仓库时，建议同步维护以下资料：
- `templates/*.md`
- `examples/specs/*`
- `docs/业务仓库首次验证SOP.md`
- `docs/changelog/README.md`
- `scripts/*.sh`
- `scripts/README.md`
- `templates/prompts/*.md`

当规范升级时，除更新规则本身外，也应检查：
- 模板是否需要同步补字段
- 示例是否仍符合当前规则
- SOP 是否仍适配当前推荐流程
