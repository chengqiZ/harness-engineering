# AGENTS.md 问题确认清单

## 背景

- 当前阶段暂不调整“以规范源仓库 `AGENTS.md` 为主入口”的使用模式。
- 先梳理 `AGENTS.md` 中已经确认存在的错误、矛盾和歧义，待确认后再统一修改。

## 研究问题

- 当前 `AGENTS.md` 中哪些问题已经足够明确，可以进入修复？
- 哪些问题属于后续结构优化，而不是当前试点前必须处理的项？

## 结论摘要

- 当前已确认 5 个需要处理的问题，其中 2 个为 P0，3 个为 P1。
- 当前不做模式调整，不把业务仓库 `.ai-harness/.ai-standards` 规则链直接写入规范源仓库 `AGENTS.md`。
- 后续以“轻量修订”为主，只修冲突、歧义和最低限度不一致。

## 问题清单

### P0-1 Task Card Schema 与模板不一致

- 现状：
  - `AGENTS.md` 要求 `03-tasks.md` 必填字段为 `Task ID/Purpose/Inputs/Changes/Validation/Done`
  - `templates/specs/03-tasks.md` 还要求 `Complexity`、`Depends On`
- 影响：
  - AI 可能按不同结构生成任务卡，导致执行产物不统一。
- 建议修复：
  - 以现有模板为准，将 `Complexity`、`Depends On` 补入 `AGENTS.md` 的强制字段。

### P0-2 规则优先级表达不完整

- 现状：
  - `AGENTS.md` 当前优先级只写到 `session constraints > repo AGENTS.md > global memories`
  - 同文件又引用 `standards/*.md` 作为规则来源
- 影响：
  - `standards/*.md` 的约束地位不明确，容易被当作参考而非规则。
- 建议修复：
  - 在不改变当前模式前提下，明确为：
  - `session constraints > repo AGENTS.md > standards/*.md > global memories`

### P1-1 测试无法执行时的输出要求层级不清

- 现状：
  - `blocking reason/manual verification steps/expected results` 当前是散列 bullet
- 影响：
  - 容易被误读为平级条款，而不是“tests cannot run”时的必填信息。
- 建议修复：
  - 改成完整句式，或改成清晰的子列表。

### P1-2 文案错误与中英混写

- 现状：
  - 存在 `if涉及` 的错误写法
- 影响：
  - 降低规则清晰度和正式性。
- 建议修复：
  - 改成纯中文句式，避免中英混杂。

### P1-3 Exception 最低要求与模板不完全一致

- 现状：
  - `AGENTS.md` 仅要求 `Exception/Reason/Expiry`
  - 模板还包含 `Scope`
- 影响：
  - 执行时不确定 `Scope` 是否属于最低必填项。
- 建议修复：
  - 以模板和当前方案为准，确认 `Scope` 是否纳入最低要求。

## 风险与限制

- 当前仅做问题确认，不直接修改 `AGENTS.md`。
- 若后续决定对 `AGENTS.md` 做瘦身，应作为单独待办处理，不与本轮轻量修订混合。

## 推荐做法

- 先确认本清单中的 5 条问题与优先级。
- 确认后，再对 `AGENTS.md` 做一次轻量修订。
- 等至少 1 个业务仓库完成试点后，再评估是否做 `AGENTS.md` 瘦身。

## 落地步骤

1. 确认 P0/P1 列表是否接受。
2. 确认“以模板为准”的字段对齐策略是否接受。
3. 确认 `standards/*.md` 是否作为主入口后的补充规则层。
4. 确认后再执行 `AGENTS.md` 轻量修订。

## 验收标准

- 已有一份可复用的问题确认清单。
- 已明确当前不调整整体使用模式。
- 已记录 `AGENTS.md` 瘦身为后续独立待办。
