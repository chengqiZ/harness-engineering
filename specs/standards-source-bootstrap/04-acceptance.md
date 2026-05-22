# Acceptance

## Spec ID

- `standards-source-bootstrap`

## Functional Acceptance

- [x] 已补齐执行层模板，覆盖 PR、changelog、升级评估、例外规则、项目接入检查。
- [x] 已提供一个完整示例 spec。
- [x] 已提供业务仓库首次验证 SOP。
- [x] 主方案和操作手册已明确规范源仓库定位及资料入口。
- [x] 业务仓库目录约定已统一为 `.ai-harness/`。
- [x] 已提供业务仓库初始化脚本与 spec 初始化脚本。
- [x] 已提供 spec preparation prompt 模板、prompt 生成脚本和 spec 检查脚本。
- [x] 已提供脚本 README，集中说明脚本用途，避免在脚本内堆叠长说明。

## Non-Functional Acceptance

- [x] 文档不含真实敏感信息
- [x] 文档结构清晰，可复用
- [x] 模板字段与 AGENTS 规则一致

## Testing Evidence

- Commands executed:
  - `rg --files`
  - `find . -maxdepth 3 -type d | sort`
  - `rg --files specs templates examples docs`
  - `git status --short`
  - `chmod +x scripts/bootstrap_repo.sh scripts/init_spec.sh`
  - `bash .ai-harness/.ai-standards/scripts/bootstrap_repo.sh`
  - `bash .ai-harness/.ai-standards/scripts/init_spec.sh demo-order-filter`
  - `find .ai-harness/specs/demo-order-filter -maxdepth 1 -type f | sort`
  - `bash .ai-harness/.ai-standards/scripts/prepare_spec_prompt.sh order-filter source-plan.md`
  - `bash .ai-harness/.ai-standards/scripts/check_spec.sh order-filter`
- Results summary:
  - 新增 `specs/`、`templates/`、`examples/`、`docs/` 资料已落盘
  - 执行层模板、示例 spec、首次验证 SOP 均可被检索到
  - 业务仓库可自动生成 `.ai-harness/` 目录、业务仓库 `AGENTS.md`、PR 模板、changelog README 和 spec 四件套
  - prompt 生成脚本可基于 `spec-id` 和源文档路径输出给 AI 的 spec preparation 提示词
  - spec 检查脚本可识别未填写模板并返回失败摘要
- Regression checks:
  - 本次仅为文档仓库变更，无运行时回归面

## Risk And Rollback

- Known risks:
  - 模板仍需在首个真实业务仓库试点后再做一轮收敛
  - 当前 spec 检查脚本是轻量静态检查，不能替代人工确认和业务验收
- Rollback plan:
  - 删除新增文档并回退两份总览文档到前一版本

## Final Decision

- Merge decision: `YES`
- Reason:
  - 本次交付已覆盖当前识别出的规范源仓库资料缺口，可进入业务仓库首次验证阶段
- Reviewer:
