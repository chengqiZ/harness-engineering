# Prompt Templates

This directory stores reusable prompts for the AI-assisted delivery workflow.

## Available Templates

- `spec-preparation.md`
  - Convert an existing PRD or design doc into `01-requirements.md`, `02-design.md`, `03-tasks.md`, and `04-acceptance.md`.

- `task-development.md`
  - Drive development for one `task-id` only, with scope control, validation, and acceptance updates.

- `pr-preparation.md`
  - Prepare a pull request summary and review materials after a single task is complete.

- `serial-task-pipeline.md`
  - Guide Claude Code, OpenClaw, or another repository-capable AI tool to execute tasks under one spec in dependency order, while keeping every `task-id` as an independent validation and PR boundary.

## Execution Modes

- `codex-managed`
  - Default mode for `./ai` automation. The business repo entrypoint invokes Codex and uses these templates as execution constraints.

- `portable-managed`
  - Use this mode when copying prompts to another AI tool that can read and write files in the repository, such as Claude Code, OpenClaw, Gemini CLI, Copilot CLI, or an internal AI program.
  - The AI tool should briefly confirm repository read/write and validation capability, then proceed. It should pause only for capability gaps, high-risk changes, destructive actions, rule conflicts, or missing required input.

- `prompt-only`
  - Use this mode for chat-only tools. The AI must not claim it changed files or ran commands; it should produce patches, checklists, review findings, or PR text only.

## Scenario Routing

| Scenario | Recommended template | Default mode |
| --- | --- | --- |
| Create or refine spec files from a source document | `spec-preparation.md` | `codex-managed` |
| Develop one task only | `task-development.md` | `codex-managed` |
| Prepare PR material for one completed task | `pr-preparation.md` | `codex-managed` |
| Run a Codex-managed automation chain | `automation-run.md` | `codex-managed` |
| Let another repository-capable AI execute tasks in order | `serial-task-pipeline.md` | `portable-managed` |

## Code Exploration Convention

开发/执行类提示词模板（`task-development.md`、`serial-task-pipeline.md`、`automation-run.md`）遵循统一的代码探索约定：

1. 对"如何工作"、架构、定位符号/文件、追踪调用链路、影响分析等问题，优先使用 CodeGraph / MCP 工具，如 `codegraph_explore`。
2. 仅当 CodeGraph 未覆盖具体细节时，才使用 `Read` / `Grep` / `Bash`（`ls`、`grep`、`find`）做确认。
3. 符号查询优先 `codegraph_search`；调用/被调用/影响面问题优先 `codegraph_callers`、`codegraph_callees`、`codegraph_impact`。

该约定位于各模板中 `## Language` 之后。

## Placement Rule

- Put reusable prompt text in `templates/prompts/`.
- Put SOPs, checklists, and explanatory guidance in `docs/`.
- Put executable automation in `scripts/`.
