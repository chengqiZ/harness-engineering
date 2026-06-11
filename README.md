# AI Coding Harness Engineering

This repository is the reusable standards source for AI-assisted coding rollout. It is not a runtime application repository.

## Repository Role

- Maintain shared agent rules, coding standards, templates, scripts, examples, and SOPs.
- Provide business repositories with a versioned `.ai-harness/.ai-standards` submodule.
- Keep business execution artifacts in business repositories, not in this source repository.

## Start Here

- Full design: `AI_CODING_HARNESS_完整方案.md`
- Operation guide: `AI_CODING_HARNESS_操作指导手册.md`
- Business repository SOP: `docs/业务仓库接入与执行SOP.md`
- Script usage: `scripts/README.md`
- Current TODOs: `docs/TODO.md`

## Business Repository Onboarding

Run from the business repository root:

```bash
bash /path/to/ai-coding-standards/scripts/init_business_repo.sh <repo-url-of-ai-coding-standards>
```

Then verify:

```bash
./ai status
```

Daily business repository commands:

```bash
./ai run <spec-id> <source-doc>
./ai work <spec-id> <task-id>
./ai pr <spec-id> <task-id> main
```

Upgrade standards in an already initialized business repository:

```bash
bash .ai-harness/.ai-standards/scripts/update_business_standards.sh [tag-or-sha]
```

## Source Repository Structure

本仓库是 AI Coding Harness 的规范源仓库，只维护可复用规则、标准、模板、脚本和 SOP；业务需求、任务执行记录、验收记录应留在业务仓库的 `.ai-harness/` 下。目录职责以 `AGENTS.md`、`standards/`、`templates/`、`scripts/` 和 `docs/` 的分工为准，README 仅保留导航和入口说明。

```text
harness-engineering/
├── AGENTS.md                         # 本规范源仓库的强制执行规则
├── README.md                         # 仓库导航、接入入口和结构说明
├── AI_CODING_HARNESS_完整方案.md       # 总体设计、角色划分、版本锁定和流程边界
├── AI_CODING_HARNESS_操作指导手册.md   # 完整操作指南和可复制提示词
├── standards/                        # 可复用工程标准
│   ├── frontend.md                   # FE 规范
│   ├── backend.md                    # BE 规范
│   ├── api-contract.md               # API 契约规范
│   └── testing.md                    # 测试与验收规范
├── templates/                        # 写入业务仓库或供 AI 读取的模板
│   ├── ai                            # 业务仓库根目录 `./ai` 入口模板
│   ├── business-repo-AGENTS.md       # 业务仓库 `.ai-harness/AGENTS.md` 模板
│   ├── pull_request_template.md      # PR 模板
│   ├── changelog-entry.md            # 业务仓库 changelog 条目模板
│   ├── exception-rule.md             # 例外规则模板
│   ├── project-onboarding-checklist.md
│   ├── standards-upgrade-review.md
│   ├── specs/                        # 业务仓库 `.ai-harness/specs/<spec-id>/` 四件套骨架
│   │   ├── 01-requirements.md
│   │   ├── 02-design.md
│   │   ├── 03-tasks.md
│   │   └── 04-acceptance.md
│   └── prompts/                      # 面向 Codex 或其他 AI 程序的执行提示词模板
│       ├── README.md
│       ├── spec-preparation.md
│       ├── task-development.md
│       ├── pr-preparation.md
│       ├── serial-task-pipeline.md
│       └── automation-run.md
├── scripts/                          # 业务仓库接入、执行和验证脚本
│   ├── README.md                     # 脚本使用说明
│   ├── init_business_repo.sh         # 一键接入业务仓库
│   ├── bootstrap_repo.sh             # 初始化 `.ai-harness/`、PR 模板和 `./ai`
│   ├── update_business_standards.sh  # 升级业务仓库中的规范源 submodule
│   ├── ai_workflow.sh                # `./ai status/spec/next/work/pr/run` 编排器
│   ├── init_spec.sh                  # 创建 spec 四件套
│   ├── check_spec.sh                 # 检查 spec 是否仍有明显占位内容
│   ├── prepare_*_prompt.sh           # 渲染不同阶段的 AI 提示词
│   └── lib/                          # Git、spec 解析、prompt 渲染和 Codex 调用封装
├── docs/                             # SOP、简明流程、TODO 和 changelog 说明
│   ├── 业务仓库接入与执行SOP.md
│   ├── 业务仓库执行流程简明版.md
│   ├── TODO.md
│   └── changelog/README.md
└── .gitignore                        # 本地忽略规则
```

## Notes

- 这份 README 只承担仓库导航和入口说明，不再展开逐文件审计。
- 需要了解各文件的职责时，以对应目录下的说明文档为准。

## Maintenance Rules

- Follow `AGENTS.md` before changing this repository.
- Use Chinese by default for future documents, templates, SOPs, reports, and user-facing replies; keep commands, paths, identifiers, protocol fields, error codes, and fixed PR/commit keywords in their original form.
- Do not add source-repo maintenance records under top-level `specs/`; use `docs/TODO.md`, decision records, changelog notes, or PR/report evidence instead.
- Business repositories should create execution specs under `.ai-harness/specs/<spec-id>/`.
- Keep source-repo maintenance PRs scoped to one coherent maintenance topic.
- Do not commit secrets, tokens, PII, or business-only execution artifacts.
