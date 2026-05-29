# AGENTS.md 问题处理记录

## 背景

- 本文记录早期对规范源仓库 `AGENTS.md` 的问题确认结果。
- 当前 `AGENTS.md` 已完成轻量修订，本文不再作为待办清单使用。
- 后续只保留历史背景和剩余结构优化项，避免误导维护者把已修复问题当作当前风险。

## 研究问题

- 哪些早期问题已经修复？
- 哪些内容仍属于后续结构优化，而不是当前必须处理的缺陷？

## 结论摘要

- 早期确认的 Task Card Schema、规则优先级、Exception 字段等问题已经在当前 `AGENTS.md` 中对齐。
- 当前仍保留“以规范源仓库 `AGENTS.md` 为主入口”的模式。
- 剩余工作是评估 `AGENTS.md` 是否需要瘦身，而不是修复已知冲突。

## 已处理问题

### Task Card Schema 与模板不一致

- 当前状态：已处理。
- 当前 `AGENTS.md` 的 Task Card Schema 已包含 `Complexity` 和 `Depends On`。

### 规则优先级表达不完整

- 当前状态：已处理。
- 当前 `AGENTS.md` 已明确优先级为 `session constraints > repo AGENTS.md > standards/*.md > global memories`。

### 测试无法执行时的输出要求层级不清

- 当前状态：已处理。
- 当前 `AGENTS.md` 已明确测试无法运行时必须提供阻塞原因、手工验证步骤和预期结果。

### 文案错误与中英混写

- 当前状态：已处理。
- 当前未在 `AGENTS.md` 中发现该早期记录的 `if涉及` 文案。

### Exception 最低要求与模板不完全一致

- 当前状态：已处理。
- 当前 `AGENTS.md` 已要求 exception 包含 `Exception`、`Reason`、`Scope`、`Expiry`。

## 风险与限制

- 本文是历史记录，不是当前执行规范。
- 当前执行规范以根目录 `AGENTS.md`、`standards/*.md` 和相关 SOP 为准。
- 若后续决定对 `AGENTS.md` 做瘦身，应作为单独任务处理。

## 推荐做法

- 保留本文作为早期决策背景。
- 后续只跟踪 `AGENTS.md` 瘦身和结构优化，不重复记录已修复问题。
- 新问题应进入新的 spec 或 TODO，而不是追加到本文。

## 落地步骤

1. 需要修改 `AGENTS.md` 时，先建立对应 spec。
2. 检查修改是否影响 `standards/*.md`、templates 和 SOP。
3. 修改后同步更新 README 或 TODO 中的导航/状态。

## 验收标准

- 维护者能看出早期问题已经处理。
- 当前待办不再与已修复问题混淆。
- `AGENTS.md` 瘦身仍作为独立后续事项跟踪。
