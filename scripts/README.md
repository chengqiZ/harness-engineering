# Scripts

这些脚本用于在业务仓库中快速接入 AI Coding Harness。日常使用优先走业务仓库根目录的 `./ai` 单入口，底层脚本保留为排错和高级入口。

## Daily Entry

初始化后，在业务仓库根目录使用：

```bash
./ai status
./ai spec <spec-id> <source-doc>
./ai next <spec-id>
./ai work <spec-id> <task-id>
./ai pr <spec-id> <task-id> [target-branch]
./ai run <spec-id> <source-doc>
```

推荐日常路径：

- 新需求一键推进到首个可执行任务：`./ai run <spec-id> <source-doc>`
- 已有 spec，只执行一个任务：`./ai work <spec-id> <task-id>`
- 任务完成后生成 MR 材料并提交推送：`./ai pr <spec-id> <task-id> main`

`./ai run` 会在 `.ai-harness/specs/<spec-id>/03-tasks.md` 的 `Run Checkpoint` 中记录当前 task、当前步骤和恢复命令。失败后优先查看 `Resume Command`，例如 `./ai work <spec-id> <task-id>` 或 `./ai pr <spec-id> <task-id> main`。

`./ai` 会自动调用 `codex exec -C <business-repo> --sandbox workspace-write`，并将 approval policy 设为 `never`（按本机 Codex CLI 支持情况选择 `--ask-for-approval never` 或等价配置）。它不会使用危险的 sandbox 绕过参数，也不会直接调用 GitLab API 创建 MR。

## Bootstrap

推荐从业务仓库根目录执行一条初始化命令：

```bash
bash /path/to/ai-coding-standards/scripts/init_business_repo.sh <repo-url-of-ai-coding-standards>
```

该命令会添加 submodule、执行 bootstrap，并运行 `./ai status` 验证入口。

手动等价步骤如下：

1. 添加规范源仓库 submodule：

```bash
git submodule add <repo-url-of-ai-coding-standards> .ai-harness/.ai-standards
git submodule update --init --recursive
```

2. 初始化业务仓库 Harness 目录：

```bash
bash .ai-harness/.ai-standards/scripts/bootstrap_repo.sh
```

3. 初始化后验证入口：

```bash
./ai status
```

## Standards Upgrade

业务仓库已经接入 Harness 后，推荐从业务仓库根目录执行：

```bash
bash .ai-harness/.ai-standards/scripts/update_business_standards.sh [tag-or-sha]
```

- 不传参数：更新 `.ai-harness/.ai-standards` 到 submodule 配置的远端跟踪版本。
- 传入 `tag-or-sha`：拉取规范源 tag 后，将 submodule 锁定到指定 tag 或 commit SHA。

脚本会执行 bootstrap 和 `./ai status`，但不会自动提交。确认无误后手工提交：

```bash
git add .ai-harness .github ai
git commit -m "chore(standards): upgrade ai coding standards"
```

## Advanced Script Usage

底层脚本仍可单独调用：

1. 创建 spec 骨架：

```bash
bash .ai-harness/.ai-standards/scripts/init_spec.sh <spec-id>
```

2. 基于需求文档或方案文档生成给 AI 的补全提示词：

```bash
bash .ai-harness/.ai-standards/scripts/prepare_spec_prompt.sh <spec-id> <source-doc>
```

3. 基于当前 task 生成开发提示词：

```bash
bash .ai-harness/.ai-standards/scripts/prepare_task_prompt.sh <spec-id> <task-id>
```

4. 基于当前 task 和分支生成 PR 准备提示词：

```bash
bash .ai-harness/.ai-standards/scripts/prepare_pr_prompt.sh <spec-id> <task-id> <target-branch> <feature-branch>
```

5. 检查 spec 是否仍有明显未填写内容：

```bash
bash .ai-harness/.ai-standards/scripts/check_spec.sh <spec-id>
```

## Script Summary

- `ai_workflow.sh`
- `./ai` 的统一编排器，承载 `status/spec/next/work/pr/run` 子命令。

- `bootstrap_repo.sh`
- 初始化 `.ai-harness/`、业务仓库 `AGENTS.md`、PR 模板、changelog 目录和根目录 `./ai`。

- `init_business_repo.sh`
- 从业务仓库根目录执行的一键初始化入口，负责添加规范源 submodule、运行 bootstrap，并验证 `./ai status`。

- `update_business_standards.sh`
- 从业务仓库根目录执行的规范升级入口，负责更新规范源 submodule、运行 bootstrap，并验证 `./ai status`。

- `init_spec.sh`
- 创建 `.ai-harness/specs/<spec-id>/` 并复制 spec 四件套。

- `prepare_spec_prompt.sh`
- 输出可复制给其他 AI 程序的 spec preparation 提示词。

- `prepare_task_prompt.sh`
- 输出可复制给其他 AI 程序的单任务开发提示词。

- `prepare_pr_prompt.sh`
- 输出可复制给其他 AI 程序的 PR 准备提示词。

- `check_spec.sh`
- 检查 spec 四件套是否存在，以及是否仍残留模板占位内容。

- `lib/git_utils.sh`
- 封装分支、脏工作区 stash、commit、push 和 diff 信息。

- `lib/spec_utils.sh`
- 解析 `03-tasks.md` 中的 task id、复杂度、依赖和完成状态。

- `lib/codex_runner.sh`
- 封装 `codex exec` 调用和日志路径。

## Notes

- `./ai work` 开始前会将已有脏工作区保存为带时间戳的 named stash，并在输出中给出恢复提示；目标 spec 文件的未提交修改会保留在工作区。
- `./ai pr` 会在提交和推送前暂停，要求人工确认 diff、测试证据、风险、回滚方案、commit message 和 MR 描述。
- 当前 v1 不自动创建 GitLab MR；只生成 MR 材料和推送分支。
- `prepare_spec_prompt.sh`、`prepare_task_prompt.sh` 和 `prepare_pr_prompt.sh` 只生成提示词，适合 prompt-only 或排错场景。
- `check_spec.sh` 是轻量静态检查，不等价于人工评审或业务验收。
- 这些脚本加在规范源仓库后，业务仓库可以直接通过 `.ai-harness/.ai-standards/scripts/*.sh` 调用；前提是业务仓库的 submodule 已更新到包含这些脚本的版本。
