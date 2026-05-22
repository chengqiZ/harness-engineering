# Tasks

## Spec ID

- `demo-profile-edit`

## Task List

### T1
- Task ID: `T1`
- Purpose: 完成前端资料编辑 UI 和提交逻辑。
- Inputs:
  - `01-requirements.md`
  - `02-design.md`
- Changes:
  - 新增编辑入口、表单组件、store action、service API 调用。
- Validation:
  - 组件测试覆盖加载/成功/失败状态。
  - 手工验证资料刷新。
- Done:
  - 用户可在页面发起编辑并看到正确反馈。
- Complexity: `S`
- Depends On:
  - None

### T2
- Task ID: `T2`
- Purpose: 完成后端更新资料接口与校验逻辑。
- Inputs:
  - `01-requirements.md`
  - `02-design.md`
- Changes:
  - 新增 `PATCH /api/v1/profile` controller/service/repository 逻辑与 DTO。
- Validation:
  - JUnit 覆盖成功保存、越权、非法输入三类场景。
- Done:
  - 接口通过测试并返回统一错误模型。
- Complexity: `S`
- Depends On:
  - None

### T3
- Task ID: `T3`
- Purpose: 做前后端联调、验收和文档补齐。
- Inputs:
  - `T1`
  - `T2`
- Changes:
  - 更新 `04-acceptance.md`
  - 记录测试证据和风险回滚方案
- Validation:
  - 完成联调与验收清单
- Done:
  - 可提交 PR 并具备合并证据。
- Complexity: `S`
- Depends On:
  - `T1`, `T2`

## Execution Rules

- One PR maps to one `task-id`.
- Do not implement tasks not listed here.
- Out-of-scope refactor requires explicit approval.

## Progress

- [ ] T1
- [ ] T2
- [ ] T3
