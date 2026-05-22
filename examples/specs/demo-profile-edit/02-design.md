# Design

## Spec ID

- `demo-profile-edit`

## Overview

- 在个人中心页面增加编辑资料入口，前端通过表单提交昵称和简介，后端校验后更新用户资料并返回最新数据。

## Frontend Design (Vue)

- Views/pages affected:
  - `src/views/profile/ProfileView.vue`
- Component changes:
  - 新增 `ProfileEditDialog.vue`
- Store (Pinia) changes:
  - 在 `profileStore` 增加 `updateProfile` action
- Service/API call boundaries:
  - `services/profile.ts` 新增 `updateProfile(payload)`
- UI states: loading / empty / error / success
  - loading: 保存按钮禁用并显示提交中
  - error: 表单字段错误就地提示，接口错误顶部提示
  - success: 关闭弹窗并刷新资料卡片

## Backend Design (Java)

- Controller changes:
  - `PATCH /api/v1/profile`
- Service logic changes:
  - 校验当前用户身份，仅允许修改本人资料
  - 统一处理昵称、简介长度与非法字符规则
- Repository/data access changes:
  - 更新 `user_profile` 或 `users` 表对应字段
- DTO/request-response model changes:
  - `UpdateProfileRequest`
  - `ProfileResponse`
- Exception handling changes:
  - 参数错误返回统一错误码，如 `PROFILE_VALIDATION_ERROR`

## Database Design (MySQL)

- Tables affected:
  - `users`
- Schema changes:
  - 无
- Index changes:
  - 无
- Migration plan:
  - 无
- Rollback plan:
  - 回退代码版本即可

## API Contract

- Endpoint:
  - `/api/v1/profile`
- Method:
  - `PATCH`
- Request schema:
  - `nickname: string`
  - `bio: string`
- Response schema:
  - `id`
  - `nickname`
  - `bio`
  - `updatedAt`
- Error model:
  - `code/message/details/traceId`
- Compatibility strategy:
  - 保持原查询资料接口不变；新增更新接口为增量能力

## Risks And Mitigations

- Risk 1:
  - 前后端校验规则不一致导致重复报错
- Mitigation:
  - 在设计文档中固定字段约束，并增加接口失败测试

## Validation Strategy

- Unit tests:
  - 前端表单校验
  - 后端 service 校验逻辑
- Integration tests:
  - 更新本人资料成功/失败
- API contract checks:
  - 校验成功响应和参数错误响应
