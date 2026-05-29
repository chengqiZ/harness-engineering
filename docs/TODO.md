# TODO

- [ ] 评估并执行 `AGENTS.md` 瘦身：仅保留主入口级强约束，把说明性和流程性内容下沉到方案、操作手册和 SOP；前提是至少完成 1 个业务仓库真实试点并完成复盘。
- [x] 收敛规范源库入口文档：README 作为导航入口，主方案/操作手册统一推荐 `init_business_repo.sh`，并明确业务仓库 spec 骨架只保留在 `templates/specs/`。
- [x] 重构业务仓库 SOP：从临时验证口径调整为稳定使用 SOP，只保留“首次接入流程”和“增量需求流程”，验证演练仅作为临时引导，不沉淀进 SOP。
- [x] 清理首次接入临时聚合验证入口和脚本文档中的临时验证助手说明；2026-05-22 已在 `/mnt/d/gitcode/harness-test` 通过首次接入聚合验证。
- [ ] 设计长期多需求管理能力：评估是否新增 `.ai-harness/specs/README.md` 索引、spec 状态字段、增量需求操作入口。
- [x] 设计业务仓库日常快捷入口：本次目标是提供 `./ai` wrapper，封装 `status/spec/next/work/pr/run`，把日常流程收敛为单入口。
- [ ] v2：评估 GitLab MR API 自动化；前提是确认可用 token、权限边界、失败回滚和审计记录。
- [ ] 补齐 changelog 自动化：评估是否新增 `scripts/create_changelog_entry.sh` 或等价入口，降低每个 PR 合并后的手工记录成本。
- [ ] 完成规范源库版本化发布准备：确认所有规范、模板、脚本、示例和文档均纳入 Git，并打 tag 供业务仓库 submodule 锁定。
