# 业务仓库首次验证 SOP

## 背景

- 当前仓库是规范源仓库。
- 首次验证目标不是证明“所有规则都完美”，而是确认一套业务仓库能完成从接入到一次真实任务闭环的最小可行流程。

## 研究问题

- 业务仓库如何低风险接入 `.ai-harness/.ai-standards`？
- 第一次试点应该选什么任务，如何控制范围？
- 如何判断这套 Harness 已经“能用”而不是只有文档？

## 结论摘要

- 先选一个低风险、用户可感知、无迁移的需求做试点。
- 首轮试点只做一个 `spec-id`，并把实现限制在一个或多个清晰的 `task-id`。
- 必须留下 requirements、design、tasks、测试证据、验收结论，才能判断接入成功。

## 方案对比

### 方案 A：直接在复杂需求上试点

- 优点：更接近真实复杂场景
- 风险：一旦流程问题和业务问题交织，很难判断失败原因

### 方案 B：先用低风险需求做试点

- 优点：更容易验证规范、模板和协作路径是否可执行
- 风险：不能覆盖高风险场景

## 风险与限制

- 如果试点需求涉及 auth、billing、DB migration，容易把 Harness 问题和业务风险混在一起。
- 如果没有固定 PR 模板和验收证据，试点完成后难以复盘。

## 推荐做法

- 采用方案 B。
- 第一轮只选一个 S 级或接近 S 级任务。
- 避免首轮就引入跨前后端多个团队的复杂协同。

## 落地步骤

### 1. 选择试点仓库

- 选一个活跃但风险较低的业务仓库。
- 确认仓库允许通过 submodule 引入共享标准。

### 2. 接入规范源仓库

```bash
git submodule add <repo-url-of-ai-coding-standards> .ai-harness/.ai-standards
git submodule update --init --recursive
bash .ai-harness/.ai-standards/scripts/bootstrap_repo.sh
```

- 维护 `/.ai-harness/AGENTS.md`，仅写项目特例。
- 参考 `templates/project-onboarding-checklist.md` 完成接入检查。

### 3. 选择首个试点需求

- 建议满足以下条件：
  - 用户可见
  - 不涉及权限模型重构
  - 不涉及大规模数据迁移
  - 能在 1-3 个 task 内完成

- 推荐示例：
  - 列表页新增筛选项
  - 详情页补充错误提示
  - 简单资料编辑能力

### 4. 建立 spec

- 在业务仓库执行：
```bash
bash .ai-harness/.ai-standards/scripts/init_spec.sh <spec-id>
```

- 如果已有需求文档或方案文档，继续执行：
```bash
bash .ai-harness/.ai-standards/scripts/prepare_spec_prompt.sh <spec-id> <source-doc>
```

- 将输出提示词交给 AI，要求 AI 只补齐：
  - `.ai-harness/specs/<spec-id>/01-requirements.md`
  - `.ai-harness/specs/<spec-id>/02-design.md`
  - `.ai-harness/specs/<spec-id>/03-tasks.md`
  - `.ai-harness/specs/<spec-id>/04-acceptance.md`

- 确认 AI 输出的 Open Questions、缺失信息和推荐首个 `task-id`。

- 开发前执行：
```bash
bash .ai-harness/.ai-standards/scripts/check_spec.sh <spec-id>
```

- 可参考：
  - `.ai-harness/.ai-standards/examples/specs/demo-profile-edit/`

### 5. 启动 AI 协作

- 第一条消息使用操作手册中的“4.1 通用启动提示词”
- 任务拆解使用“4.3 任务拆解提示词”
- 单任务开发使用“4.5 单任务开发提示词”
- 验收使用“4.8 发布前验收提示词”

### 6. 执行首个 task

- 一次只做一个 `task-id`
- 在 PR 中带上：
  - spec link
  - task id
  - changed files
  - test evidence
  - risks
  - rollback plan

- 可直接使用：
  - `.github/pull_request_template.md` 或 `.ai-harness/.ai-standards/templates/pull_request_template.md`

### 7. 完成验收与复盘

- 更新 `.ai-harness/specs/<spec-id>/04-acceptance.md`
- 在 `.ai-harness/docs/changelog/` 新增一条记录
- 记录首次试点复盘：
  - 哪些步骤最顺
  - 哪些模板不够用
  - 哪些提示词需要收敛

## 验收标准

- 业务仓库已成功初始化 `.ai-harness`
- 至少 1 个 `spec-id` 建立完成
- 至少 1 个 `task-id` 完成开发与测试
- `04-acceptance.md` 有明确 YES/NO 结论
- `.ai-harness/docs/changelog/` 留下变更记录
