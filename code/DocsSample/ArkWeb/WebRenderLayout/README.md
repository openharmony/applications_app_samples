# Web组件渲染模式

## RenderMode

### 介绍

1. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-render-mode.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\RenderModeWebComp.png" width="360;" /> |

使用说明

1. 使用renderMode设置渲染模式为 ASYNC_RENDER (同步渲染模式)。
# Web组件大小自适应页面内容布局

## FitPageContent

### 介绍

1. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-fit-content.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

### 效果预览

| 主页                                                      |
| --------------------------------------------------------- |
| <img src="screenshots\FitPageContent.png" width="360;" /> |

使用说明

1. 使用Web组件大小自适应页面内容布局模式layoutMode(WebLayoutMode.FIT_CONTENT)时，能使Web组件的大小根据页面内容自适应变化。

## 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---|---|---FitPageContent.ets
|---|---|---RenderMode.ets
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```

## 相关权限

[ohos.permission.INTERNET](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)

## 依赖

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例支持API14版本SDK，SDK版本号(API Version 14 Release)。
3. 本示例需要使用DevEco Studio 版本号(5.0.1Release)才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkWeb/WebRenderLayout > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```