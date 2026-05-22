# Requirements

## Spec ID

- `demo-profile-edit`

## 背景

- 用户中心页面需要支持修改昵称与个人简介。
- 当前页面仅展示资料，无法自助编辑，需通过工单处理，影响处理效率。

## 研究问题

- 如何在不影响现有登录与资料展示逻辑的前提下，增加一个低风险的资料编辑能力？
- 前后端如何确保输入校验、错误提示和接口兼容性？

## Goal

- 支持登录用户在个人中心页面编辑昵称与个人简介，并在保存后立即看到最新结果。

## In Scope

- 新增“编辑资料”入口和弹窗/表单。
- 新增保存接口调用。
- 新增昵称、简介的前后端输入校验。
- 更新保存成功、失败、加载中的界面状态。

## Out Of Scope

- 不修改头像上传。
- 不修改账号安全设置。
- 不支持管理员代他人修改资料。

## Constraints

- Tech stack: Vue 3 + TypeScript + Pinia + Java Spring Boot + MySQL
- Performance constraints: 保存接口 P95 小于 500ms
- Security/compliance constraints: 仅允许用户修改自己的资料；日志不记录原始简介全文
- Delivery constraints: 首次试点控制在单个需求、单个业务域内

## Success Metrics

- Metric 1: 用户可成功保存有效昵称与简介，前端立即刷新显示。
- Metric 2: 无效输入可在前端和后端均得到明确拦截和错误提示。

## Assumptions

- Assumption 1: 用户已登录并具备查看个人中心权限。
- Assumption 2: 现有用户表已包含昵称和简介字段，无需新增表结构。

## Open Questions

- Q1: 昵称长度限制是否为 2-20 字符？
- Q2: 简介是否允许换行与 emoji？
