# Design

## Spec ID

- `standards-source-bootstrap`

## Overview

- 本次设计同时包含文档收敛与轻量脚本自动化。
- 目标是把规范源仓库从“规则说明”升级为“可直接落地并可半自动接入的资料包”。

## Information Architecture

- `templates/`
- 存放可直接复制到业务仓库或平台配置的模板。

- `examples/specs/<example-spec-id>/`
- 存放完整示例 spec，供团队参考写法和颗粒度。

- `docs/`
- 存放 SOP 和说明性文档。

- `scripts/`
- 存放业务仓库初始化、spec 初始化、prompt 生成和 spec 检查脚本。

- `templates/prompts/`
- 存放可复用的 AI 提示词模板。

## Business Repo Layout

- 业务仓库统一使用以下目录：

```text
<project-root>/
  .ai-harness/
    AGENTS.md
    specs/
    docs/
      changelog/
    .ai-standards/
```

- `.ai-harness/.ai-standards/` 是 submodule
- `.ai-harness/AGENTS.md` 是业务仓库特例
- `.ai-harness/specs/` 与 `.ai-harness/docs/changelog/` 是业务执行产物

## Script Design

- `scripts/bootstrap_repo.sh`
  - 检查当前目录是否为 git 仓库
  - 检查 `.ai-harness/.ai-standards` 是否存在
  - 创建 `.ai-harness/specs`、`.ai-harness/docs/changelog`
  - 复制业务仓库 `AGENTS.md` 模板
  - 复制 PR 模板与 changelog README
  - 输出待人工补充项

- `scripts/init_spec.sh <spec-id>`
  - 创建 `.ai-harness/specs/<spec-id>/`
  - 复制 spec 四件套
  - 将 `<spec-id>` 占位符替换为真实值
  - 输出下一步填写提醒

- `scripts/prepare_spec_prompt.sh <spec-id> <source-doc>`
  - 检查 spec 和输入文档是否存在
  - 基于 `templates/prompts/spec-preparation.md` 输出可复制给 AI 的提示词
  - 明确 AI 只补齐 spec，不写代码

- `scripts/check_spec.sh <spec-id>`
  - 检查 spec 四件套是否存在
  - 检查 `<spec-id>` 占位符是否仍残留
  - 检查常见空模板提示是否仍未填写
  - 输出 pass/fail 摘要

## Deliverables

- `templates/pull_request_template.md`
- `templates/changelog-entry.md`
- `templates/standards-upgrade-review.md`
- `templates/exception-rule.md`
- `templates/project-onboarding-checklist.md`
- `templates/business-repo-AGENTS.md`
- `templates/prompts/spec-preparation.md`
- `examples/specs/demo-profile-edit/01-requirements.md`
- `examples/specs/demo-profile-edit/02-design.md`
- `examples/specs/demo-profile-edit/03-tasks.md`
- `examples/specs/demo-profile-edit/04-acceptance.md`
- `docs/业务仓库首次验证SOP.md`
- `scripts/bootstrap_repo.sh`
- `scripts/init_spec.sh`
- `scripts/prepare_spec_prompt.sh`
- `scripts/check_spec.sh`
- `scripts/README.md`

## Update Strategy

- 在主方案中明确“当前仓库为规范源仓库”的定位和资料清单。
- 在操作手册中补充“源仓库维护者工作项”和“业务仓库首次验证步骤”引用。
- 统一文档中的业务仓库目录为 `.ai-harness/`。

## Risks And Mitigations

- Risk 1: 模板过于抽象，业务团队仍不知道如何填写。
- Mitigation: 提供完整示例 spec 和 SOP，而不是只给空模板。

- Risk 2: 文档过多导致入口分散。
- Mitigation: 在主方案和操作手册中增加资料导航与推荐使用顺序。

- Risk 3: 自动化脚本和文档路径不一致，导致使用失败。
- Mitigation: 所有示例、提示词、脚本统一使用 `.ai-harness/` 路径。

## Validation Strategy

- Unit tests: N/A
- Integration tests: N/A
- API contract checks: N/A
- Doc validation:
  - 检查新增文件是否覆盖当前识别出的缺口
  - 检查 spec 流程文件是否齐全
  - 检查操作手册是否能串起首次接入路径
- Script validation:
  - 检查脚本路径与模板路径一致
  - 检查脚本输出的人工待办是否清晰
  - 在临时业务仓库中验证 prompt 生成和 spec 检查脚本
