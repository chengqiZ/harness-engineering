# Tasks

## Spec ID

- `standards-source-bootstrap`

## Task List

### T1
- Task ID: `T1`
- Purpose: 补齐规范源仓库缺失的执行层模板。
- Inputs:
  - `AGENTS.md`
  - `AI_CODING_HARNESS_完整方案.md`
  - `AI_CODING_HARNESS_操作指导手册.md`
- Changes:
  - 新增 PR 模板、changelog 模板、规范升级评估模板、例外规则模板、项目接入检查清单。
- Validation:
  - 检查模板字段是否覆盖仓库规则中的强制项。
  - 检查模板命名和用途是否清晰可复用。
- Done:
  - `templates/` 下存在新增模板，且内容可直接复制使用。
- Complexity: `S`
- Depends On:
  - None

### T2
- Task ID: `T2`
- Purpose: 补齐业务仓库首次验证所需的示例和 SOP。
- Inputs:
  - `templates/specs/*`
  - `AI_CODING_HARNESS_完整方案.md`
  - `AI_CODING_HARNESS_操作指导手册.md`
- Changes:
  - 新增完整示例 spec。
  - 新增业务仓库首次验证 SOP。
  - 更新主方案和操作手册，补充规范源仓库定位与资料导航。
- Validation:
  - 检查示例 spec 是否覆盖 requirements/design/tasks/acceptance 闭环。
  - 检查 SOP 是否包含首次接入、首次任务验证、验收、回滚四类动作。
- Done:
  - 团队成员可按 SOP 在业务仓库开展首次试点。
- Complexity: `M`
- Depends On:
  - `T1`

### T3
- Task ID: `T3`
- Purpose: 统一业务仓库目录结构到 `.ai-harness/` 并补充自动化脚本。
- Inputs:
  - `AI_CODING_HARNESS_完整方案.md`
  - `AI_CODING_HARNESS_操作指导手册.md`
  - `docs/业务仓库首次验证SOP.md`
  - `templates/specs/*`
- Changes:
  - 更新所有业务仓库使用文档中的路径约定为 `.ai-harness/`
  - 新增业务仓库 `AGENTS.md` 模板
  - 新增 `bootstrap_repo.sh` 与 `init_spec.sh`
- Validation:
  - 检查文档、模板、脚本的路径口径一致
  - 检查脚本能输出初始化完成后的下一步提示
- Done:
  - 业务仓库可通过脚本自动生成 `.ai-harness/` 基础结构和 spec 骨架
- Complexity: `M`
- Depends On:
  - `T1`
  - `T2`

### T4
- Task ID: `T4`
- Purpose: 增加 spec preparation 自动化入口，引导 AI 基于需求/方案文档补齐 spec，并提供检查脚本。
- Inputs:
  - `scripts/bootstrap_repo.sh`
  - `scripts/init_spec.sh`
  - `templates/specs/*`
  - `AI_CODING_HARNESS_操作指导手册.md`
- Changes:
  - 新增 `templates/prompts/spec-preparation.md`
  - 新增 `scripts/prepare_spec_prompt.sh`
  - 新增 `scripts/check_spec.sh`
  - 新增 `scripts/README.md`
  - 更新方案、手册和 SOP，说明 spec preparation 流程
- Validation:
  - 在临时业务仓库中验证 prompt 生成脚本能读取 source doc 并输出提示词
  - 验证 check 脚本能识别未填写模板并输出失败摘要
- Done:
  - 用户可通过脚本生成给其他 AI 的提示词，并在确认前检查 spec 完整度
- Complexity: `M`
- Depends On:
  - `T3`

## Execution Rules

- One PR maps to one `task-id`.
- Do not implement tasks not listed here.
- Out-of-scope refactor requires explicit approval.

## Progress

- [x] T1
- [x] T2
- [x] T3
- [x] T4
