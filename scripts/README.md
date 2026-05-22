# Scripts

这些脚本用于在业务仓库中快速接入 AI Coding Harness，并引导 AI 从需求/方案文档补齐 spec。

## Usage Order

1. 添加规范源仓库 submodule：

```bash
git submodule add <repo-url-of-ai-coding-standards> .ai-harness/.ai-standards
git submodule update --init --recursive
```

2. 初始化业务仓库 Harness 目录：

```bash
bash .ai-harness/.ai-standards/scripts/bootstrap_repo.sh
```

3. 创建 spec 骨架：

```bash
bash .ai-harness/.ai-standards/scripts/init_spec.sh <spec-id>
```

4. 基于需求文档或方案文档生成给 AI 的补全提示词：

```bash
bash .ai-harness/.ai-standards/scripts/prepare_spec_prompt.sh <spec-id> <source-doc>
```

5. 检查 spec 是否仍有明显未填写内容：

```bash
bash .ai-harness/.ai-standards/scripts/check_spec.sh <spec-id>
```

## Script Summary

- `bootstrap_repo.sh`
- 初始化 `.ai-harness/`、业务仓库 `AGENTS.md`、PR 模板和 changelog 目录。

- `init_spec.sh`
- 创建 `.ai-harness/specs/<spec-id>/` 并复制 spec 四件套。

- `prepare_spec_prompt.sh`
- 输出可复制给其他 AI 程序的 spec preparation 提示词。

- `check_spec.sh`
- 检查 spec 四件套是否存在，以及是否仍残留模板占位内容。

- `verify_first_onboarding.sh`
- 聚合验证业务仓库首次接入链路，覆盖 submodule、bootstrap、spec 初始化、prompt 生成和 spec 检查。该脚本用于临时验收引导，不属于业务 SOP。

## Verification Helper

在 WSL 中验证某个业务仓库首次接入流程：

```bash
bash /path/to/ai-coding-standards/scripts/verify_first_onboarding.sh \
  /path/to/business-repo \
  /path/to/ai-coding-standards \
  demo-first-flow
```

如果规范源库使用本地路径，脚本会使用 `protocol.file.allow=always` 处理本地 submodule 添加。

## Notes

- 脚本只做本地文件初始化和检查，不调用任何 AI API。
- `prepare_spec_prompt.sh` 只生成提示词；由使用者把提示词交给 Codex、Cursor、Claude、Gemini CLI 或其他 AI 工具。
- `check_spec.sh` 是轻量静态检查，不等价于人工评审或业务验收。
