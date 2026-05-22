# AI Coding Harness 完整方案（Submodule 统一规范版）

## 1. 目标

- 建立跨项目统一的 AI 编程规范，不再到处复制文件。
- 通过 Git Submodule 锁定规范版本，保证可追溯、可升级、可灰度。
- 在需求理解、任务拆解、开发、测试、评审、发布全流程统一执行。
- 当前仓库定位为“规范源仓库”，负责维护规则、模板、示例和 SOP，不直接承载业务实现。
- 业务仓库初始化后，AI 先基于需求文档或方案文档补齐 spec，经确认后再进入开发。

## 2. 核心设计

### 2.1 仓库角色

1. 规范源仓库：`ai-coding-standards`
- 存放统一规范与模板：
  - `AGENTS.md`
  - `standards/frontend.md`
  - `standards/backend.md`
  - `standards/api-contract.md`
  - `standards/testing.md`
  - `templates/specs/*`

2. 业务仓库：`project-*`
- 在 `/.ai-harness/` 下统一管理规范相关内容
- 通过子模块引入规范源仓库到 `/.ai-harness/.ai-standards`
- `/.ai-harness/AGENTS.md` 仅存放项目特例
- 需求文件放在 `/.ai-harness/specs/<spec-id>/`

3. 资料角色划分
- 规范源仓库提供：
  - 核心规则：`AGENTS.md`、`standards/*`
  - 基础模板：`templates/specs/*`
  - 执行模板：`templates/*.md`
  - 示例：`examples/specs/*`
  - SOP：`docs/*.md`
- 业务仓库负责：
  - 引入 `/.ai-harness/.ai-standards`
  - 编写 `/.ai-harness/AGENTS.md`
  - 在 `/.ai-harness/specs/`、`/.ai-harness/docs/changelog/` 中留下执行产物

### 2.2 版本锁定机制

- `.gitmodules` 记录子模块路径和 URL。
- 父仓库提交中记录子模块指向的 commit SHA（gitlink）。
- 业务仓库升级规范，本质是把 `/.ai-harness/.ai-standards` 指针从旧 SHA 更新到新 SHA/tag。

### 2.3 规则优先级

- `session constraints > .ai-harness/AGENTS.md > .ai-harness/.ai-standards/AGENTS.md > .ai-harness/.ai-standards/standards/*.md`

## 3. 目标目录结构

```text
ai-coding-standards/                     # 规范源仓库
  AGENTS.md
  standards/
  templates/

project-a/                               # 业务仓库
  .github/
    pull_request_template.md
  .ai-harness/
    .ai-standards/                       # submodule -> ai-coding-standards@<sha>
    AGENTS.md                            # 仅项目特例
    specs/
      <spec-id>/
        01-requirements.md
        02-design.md
        03-tasks.md
        04-acceptance.md
    docs/
      changelog/
```

## 4. Git Submodule 落地流程

### 4.1 首次接入

```bash
git submodule add <repo-url-of-ai-coding-standards> .ai-harness/.ai-standards
git submodule update --init --recursive
bash .ai-harness/.ai-standards/scripts/bootstrap_repo.sh
git add .gitmodules .ai-harness .github
git commit -m "chore(harness): bootstrap ai harness"
```

### 4.2 规范升级（按版本）

```bash
git submodule update --remote .ai-harness/.ai-standards
cd .ai-harness/.ai-standards && git checkout v1.2.0 && cd ../..
git add .ai-harness/.ai-standards
git commit -m "chore(standards): upgrade ai standards to v1.2.0"
```

### 4.3 升级门禁

- 升级 PR 必须说明：
  - 变更摘要
  - 是否影响当前项目流程
  - 回退方式（回到旧 tag/SHA）

## 5. 开发流程（Spec 驱动）

1. 运行 `bash .ai-harness/.ai-standards/scripts/init_spec.sh <spec-id>`
2. 运行 `bash .ai-harness/.ai-standards/scripts/prepare_spec_prompt.sh <spec-id> <source-doc>`
3. 将输出提示词交给 AI，补齐 `01-requirements.md`、`02-design.md`、`03-tasks.md`、`04-acceptance.md`
4. 人工确认 spec 和待确认问题
5. 运行 `bash .ai-harness/.ai-standards/scripts/check_spec.sh <spec-id>`
6. 一次只实现一个 `task-id`
7. 更新 `04-acceptance.md`
8. PR 合并

## 6. 规范执行边界

### 6.1 统一规则放哪里

- 通用规则只改 `ai-coding-standards` 仓库。
- 业务仓库不直接改 `/.ai-harness/.ai-standards` 内容。
- 项目差异写在 `/.ai-harness/AGENTS.md`。

### 6.2 项目特例要求

- 每条特例必须包含：
  - `Reason`
  - `Scope`
  - `Expiry`

## 7. 风险与回滚

### 7.1 常见风险

- 业务仓库规范版本不一致
- 规范升级导致旧项目流程不兼容
- AI 忽略子模块规则，仅按项目局部规则执行

### 7.2 回滚策略

- 规范升级失败时，回退子模块到上一个稳定 tag/SHA
- 升级 PR 独立提交，禁止与业务功能改动混合

## 8. 提示词规范（统一入口）

每次任务必须显式引用规范来源：
- `.ai-harness/AGENTS.md`
- `.ai-harness/.ai-standards/AGENTS.md`
- `.ai-harness/.ai-standards/standards/*.md`

冲突处理必须在输出中声明采用的规则层级。

## 9. 验收标准

- 至少 1 个业务仓库完成 submodule 接入
- 至少 1 个真实需求完成 spec->task->code->test->acceptance 闭环
- 至少 1 次规范升级演练（含回滚）
- 团队成员可复用同一套提示词完成任务推进

## 10. 附加资料

- 业务仓库首次验证 SOP：`docs/业务仓库首次验证SOP.md`
- 项目接入检查清单：`templates/project-onboarding-checklist.md`
- 业务仓库 AGENTS 模板：`templates/business-repo-AGENTS.md`
- PR 模板：`templates/pull_request_template.md`
- Changelog 模板：`templates/changelog-entry.md`
- 规范升级评估模板：`templates/standards-upgrade-review.md`
- 例外规则模板：`templates/exception-rule.md`
- 完整示例 spec：`examples/specs/demo-profile-edit/`
- Prompt 模板：`templates/prompts/spec-preparation.md`
- 自动化脚本：`scripts/bootstrap_repo.sh`、`scripts/init_spec.sh`、`scripts/prepare_spec_prompt.sh`、`scripts/check_spec.sh`
- 脚本说明：`scripts/README.md`
