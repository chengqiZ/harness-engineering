# Acceptance

## Spec ID

- `prompt-automation-extension`

## Functional Acceptance

- [x] 任务开发提示词可通过脚本直接生成
- [x] PR 准备提示词可通过脚本直接生成
- [x] 业务仓库调用路径和前提条件说明清楚

## Non-Functional Acceptance

- [x] 脚本无外部依赖
- [x] 错误提示清晰
- [x] 现有 spec preparation 提示词生成功能不回归

## Testing Evidence

- Commands executed:
  - `bash scripts/prepare_task_prompt.sh`
  - `bash scripts/prepare_pr_prompt.sh`
  - `git init` in `/tmp/prompt-automation-WhGVyS`
  - `bash .ai-harness/.ai-standards/scripts/init_spec.sh video-knowledge-extraction-phase1`
  - `bash .ai-harness/.ai-standards/scripts/prepare_spec_prompt.sh video-knowledge-extraction-phase1 video_knowledge_extraction_phase1_prd_cn.md`
  - `bash .ai-harness/.ai-standards/scripts/prepare_task_prompt.sh video-knowledge-extraction-phase1 T1`
  - `bash .ai-harness/.ai-standards/scripts/prepare_pr_prompt.sh video-knowledge-extraction-phase1 T1 main feat/video-knowledge-extraction-phase1-T1`
- Results summary:
  - 缺参调用会输出正确 usage 并以非零状态退出。
  - 在临时业务仓库中，三个脚本都能成功输出渲染后的提示词。
  - 输出内容已确认包含替换后的 `spec-id`、`task-id`、`source-doc`、`target-branch` 和 `feature-branch`。
- Regression checks:
  - `prepare_spec_prompt.sh` 改为复用共享渲染逻辑后，输出仍保持原有结构和语义。

## Risk And Rollback

- Known risks:
  - 当前只覆盖固定占位符集合；后续新增模板变量时，需要同步更新对应脚本参数。
- Rollback plan:
  - 回滚新增脚本与 `scripts/lib/prompt_utils.sh`。
  - 将 `prepare_spec_prompt.sh` 恢复为原始单文件 `sed` 实现。

## Final Decision

- Merge decision: `YES`
- Reason: 脚本与文档已更新，并在临时业务仓库完成命令级验证。
- Reviewer: `Codex`
