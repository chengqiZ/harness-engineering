# Design

## Spec ID

- `prompt-automation-extension`

## Overview

- 在现有 `spec-preparation` 自动化模式上继续扩展，新增两个面向业务仓库使用者的提示词生成入口：
  - `prepare_task_prompt.sh`
  - `prepare_pr_prompt.sh`
- 为避免每个脚本重复维护 `sed` 替换逻辑，新增一个共享 shell 库负责模板路径校验、占位符转义和渲染输出。

## Script Design

- 新增 `scripts/lib/prompt_utils.sh`
  - 提供 `repo_root_from_script` 计算规范源仓库根目录
  - 提供 `fail` 统一错误输出
  - 提供 `ensure_git_root` 检查业务仓库根目录上下文
  - 提供 `ensure_file` 检查模板与输入文件存在
  - 提供 `escape_sed_replacement` 转义替换值中的 `\`、`&`、`|`
  - 提供 `render_template` 执行多变量模板替换

- 保持 `prepare_spec_prompt.sh` 对外命令不变
  - 内部改为复用共享渲染逻辑

- 新增 `prepare_task_prompt.sh <spec-id> <task-id>`
  - 输出 `task-development.md` 的渲染结果

- 新增 `prepare_pr_prompt.sh <spec-id> <task-id> <target-branch> <feature-branch>`
  - 输出 `pr-preparation.md` 的渲染结果

## Documentation Design

- 更新 `scripts/README.md`
  - 增加两个新脚本的用途、参数和示例
  - 明确说明这些脚本在业务仓库中通过 `.ai-harness/.ai-standards/scripts/*.sh` 直接调用
  - 补充一个注意事项：业务仓库需要拉取到包含这些脚本的新 submodule 版本

## Risks And Mitigations

- Risk 1: 模板占位符值包含特殊字符，导致替换失败
- Mitigation: 在共享库中统一做 `sed` replacement 转义

- Risk 2: 使用者在非业务仓库根目录运行脚本
- Mitigation: 统一检查 `.git` 和必要目录，输出明确错误信息

## Validation Strategy

- Unit tests: N/A
- Integration tests:
  - 在当前仓库中对三个脚本分别执行，确认输出包含替换后的关键字段
  - 检查错误用法时是否输出正确 usage
- API contract checks: N/A
