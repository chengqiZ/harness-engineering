# 业务仓库接入与执行 SOP

## 背景

- 当前仓库是 AI Coding Harness 的规范源仓库。
- 本 SOP 面向已决定接入 Harness 的业务仓库，覆盖首次接入、增量需求执行、验收、回滚和复盘。
- 临时接入验证脚本已经完成阶段性用途，日常使用应通过业务仓库根目录的 `./ai` 入口执行。

## 研究问题

- 业务仓库如何稳定接入 `.ai-harness/.ai-standards`？
- 新需求如何按 spec-first 流程推进到单个 task 和 PR？
- 如何留下可复查的验收证据、风险说明和回滚方案？

## 结论摘要

- 新业务仓库先完成 `.ai-harness` 初始化，再确认 `./ai status` 可用。
- 每个需求必须先建立 `spec-id`，每个 PR 只对应一个 `task-id`。
- 日常执行优先使用 `./ai run`，排错和高风险任务使用分步命令。
- 如果使用 Claude Code、OpenClaw 或其他具备仓库读写能力的 AI 程序，不走 `./ai run`；改用 `.ai-harness/.ai-standards/templates/prompts/serial-task-pipeline.md`，按 `portable-managed` 模式执行。
- 合并前必须留下测试证据、风险、回滚方案和 acceptance 结论。

## 方案对比

### 方案 A：一键执行

- 命令：`./ai run <spec-id> <source-doc>`
- 优点：适合低风险、S 级需求，链路最短。
- 限制：失败定位需要回到 checkpoint 和分步命令排查。

### 方案 B：分步执行

- 命令：`./ai status`、`./ai spec`、`./ai next`、`./ai work`、`./ai pr`
- 优点：每一步都有明确输出，适合接入初期、排错和高风险需求。
- 限制：人工操作更多。

### 方案 C：其他 AI 程序串行执行

- 模板：`.ai-harness/.ai-standards/templates/prompts/serial-task-pipeline.md`
- 模式：`Execution Mode: portable-managed`
- 适用：Claude Code、OpenClaw、Gemini CLI、Copilot CLI、内部 AI 程序等具备仓库读写能力的工具。
- 优点：不依赖 Codex 调度入口，可以复用同一套规范和 prompt 模板。
- 限制：AI 程序不得执行 `./ai run`、`./ai spec`、`./ai work`、`./ai pr`，这些命令会调用 Codex；它应直接读取规范、spec 和模板后自行执行。

## 风险与限制

- `M/L` 任务、DB migration、auth、权限、billing、风险逻辑不得直接自动推进，必须先人工确认设计和影响范围。
- `./ai work` 会进入开发动作，执行前应确认工作区没有不应混入的改动。
- `./ai pr` 会整理提交和推送材料，执行前应确认测试证据、风险、回滚方案已经明确。
- 注释、测试、API 契约和异常处理要求以 `.ai-harness/.ai-standards/standards/*.md` 为准。

## 推荐做法

- 新仓库接入后先执行 `./ai status`，确认规范源和业务仓库入口可用。
- 新需求优先从需求文档生成 spec，确认 `01-requirements.md` 和 `03-tasks.md` 后再开发。
- 单次 PR 只执行一个 `task-id`，避免把需求、重构和流程调整混在一起。
- 复杂任务先走分步执行，等流程稳定后再使用 `./ai run`。
- 非 Codex 工具使用 `serial-task-pipeline.md` 时，也必须保持“一次一个 `task-id`、一个 PR 一个 `task-id`”；允许串行继续下一个 task，但每个 task 必须先完成验证、acceptance 记录和 PR 材料。

## 落地步骤

### 1. 接入业务仓库

在业务仓库根目录执行：

```bash
bash /path/to/ai-coding-standards/scripts/init_business_repo.sh <repo-url-of-ai-coding-standards>
```

该命令会添加规范源 submodule、运行 bootstrap，并验证：

```bash
./ai status
```

接入后人工检查：

- `.ai-harness/AGENTS.md` 只保留项目特例。
- `.github/pull_request_template.md` 已存在。
- `.ai-harness/docs/changelog/README.md` 已存在。
- `./ai status` 能输出仓库、分支、规范源和 specs 信息。

### 2. 准备增量需求

准备需求文档，例如：

```text
docs/requirements/<spec-id>.md
```

这里的需求文档就是普通业务需求文档，可以是 PRD、方案说明、缺陷描述、验收口径或用户故事，不要求预先写成 Harness spec 格式。AI 会基于该文档生成或完善 `.ai-harness/specs/<spec-id>/` 下的四件套。

需求文档至少包含：

- 要解决的问题
- 用户触发路径
- 期望结果
- 明确不做的范围
- 验收方式

### 3. 生成并确认 spec

推荐一键生成并推进：

```bash
./ai run <spec-id> <source-doc>
```

需要分步排查时执行：

```bash
./ai spec <spec-id> <source-doc>
./ai next <spec-id>
```

开发前必须确认：

- `.ai-harness/specs/<spec-id>/01-requirements.md` 已补齐关键需求。
- `.ai-harness/specs/<spec-id>/03-tasks.md` 至少有一个可执行 `task-id`。
- `M/L` 任务已补齐设计或拆小。
- Open Questions 不阻塞当前 task。

### 4. 执行单个 task

执行任务：

```bash
./ai work <spec-id> <task-id>
```

执行时要求：

- 只实现当前 `task-id`。
- 不做无关重构。
- 行为变化必须补测试。
- 复杂逻辑、业务规则、边界条件和风险逻辑必须补详细注释。

### 5. 准备 PR 和验收

任务完成后执行：

```bash
./ai pr <spec-id> <task-id> main
```

PR/report 必须包含：

- spec link
- task id
- changed files
- test evidence
- risks
- rollback plan
- pending items

同时更新：

- `.ai-harness/specs/<spec-id>/04-acceptance.md`
- `.ai-harness/docs/changelog/` 中的 changelog entry

### 6. 失败恢复

如果 `./ai run` 中断，优先查看：

```text
.ai-harness/specs/<spec-id>/03-tasks.md
```

文件底部的 `Run Checkpoint` 会给出恢复命令，例如：

```text
Resume Command: `./ai work <spec-id> <task-id>`
```

如需回退规范源版本，按业务仓库 PR 中记录的 submodule tag/SHA 回退，并单独提交。

### 7. 使用其他 AI 程序串行执行 task

在 Claude Code、OpenClaw 或其他具备仓库读写能力的 AI 程序中，进入业务仓库根目录后，复制下面的启动方式：

**也可以先生成已替换占位符的提示词（执行该脚本，输出指导提示词）：**

```bash
bash .ai-harness/.ai-standards/scripts/prepare_serial_task_prompt.sh <spec-id> [source-doc] [target-branch]
```

该脚本只输出 prompt，不调用 Codex。`target-branch` 可省略，默认使用当前所在 git 分支；`source-doc` 可省略，表示基于已有 spec 继续执行。

```text
请读取并使用：
.ai-harness/.ai-standards/templates/prompts/serial-task-pipeline.md

请将模板输入替换为：
- Spec ID: <spec-id>
- Source document: <source-doc 或留空>
- Target branch: <target-branch 或当前所在分支>

Execution Mode 使用 portable-managed。
不要执行 ./ai run、./ai spec、./ai work、./ai pr。
请先完成模板中的 Startup Checks，然后按当前 spec 的 03-tasks.md 依赖顺序串行执行 task。
每完成一个 task-id 后暂停，输出验证证据、风险、回滚方案、PR 材料和 next ready task，等待我确认是否继续。
```

如果 spec 尚不存在，AI 程序应先按模板创建或完善 spec 四件套，不写业务代码；spec 完成后输出推荐的第一个 ready task，并等待人工确认是否开始开发。

如果 spec 已存在，AI 程序应直接读取当前 spec，选择依赖满足的 ready task。除非人工明确授权“自动继续 S 级 task”，否则每完成一个 `task-id` 都必须暂停。

## 验收标准

- `./ai status` 可以正常输出仓库和规范源信息。
- 至少 1 个 `spec-id` 建立完成。
- 当前 PR 只对应 1 个 `task-id`。
- 非 Codex 工具执行时，使用 `serial-task-pipeline.md`，且没有调用 Codex 调度入口。
- 行为变化有测试证据。
- `04-acceptance.md` 有明确 YES/NO 结论。
- PR/report 包含风险、回滚方案和 pending items。
- `.ai-harness/docs/changelog/` 留下变更记录。
