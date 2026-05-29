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

- `AGENTS.md`: mandatory agent rules for this standards source repository.
- `standards/`: reusable FE, BE, API, and testing standards.
- `templates/`: business repo templates, the reusable spec skeleton in `templates/specs/`, prompt templates, and PR/changelog templates.
- `scripts/`: onboarding, spec, prompt, workflow, and validation helpers.
- `docs/`: SOPs, TODOs, changelog notes, and decision/reference documents.

## Maintenance Rules

- Follow `AGENTS.md` before changing this repository.
- Use Chinese by default for future documents, templates, SOPs, reports, and user-facing replies; keep commands, paths, identifiers, protocol fields, error codes, and fixed PR/commit keywords in their original form.
- Do not add source-repo maintenance records under top-level `specs/`; use `docs/TODO.md`, decision records, changelog notes, or PR/report evidence instead.
- Business repositories should create execution specs under `.ai-harness/specs/<spec-id>/`.
- Keep source-repo maintenance PRs scoped to one coherent maintenance topic.
- Do not commit secrets, tokens, PII, or business-only execution artifacts.
