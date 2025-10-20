## Web页面显示内容滚动

#### 介绍

本工程主要实现了对以下指南文档中 https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/web/web-focus.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

### Web组件与ArkUI组件焦点控制

#### 介绍

1. 应用侧通用获焦回调接口onFocus，获焦事件回调，绑定该接口的组件获焦时，回调响应。
2. 应用侧通用失焦回调接口onBlur，失焦事件回调，绑定该接口的组件失焦时，回调响应。
3. 应用侧主动申请获焦接口requestFocus，组件主动申请获焦。
4. 设置组件是否可获焦：应用可以通过设置focusable属性，控制Web组件是否能够获取焦点。Web组件默认可获焦。

#### 效果预览
<img src="screenshots/WebFocusManagement.gif" width="250">

#### 使用说明

1. 通过按钮可以分别控制两个网页视图获取焦点，获得焦点的网页边框会变为绿色，失去焦点时恢复红色。

### Web组件内H5元素焦点控制

#### 介绍

1. 加载本地HTML文件并实现H5表单元素的焦点控制

#### 效果预览
<img src="screenshots/img_1.png" width="200">

#### 使用说明

1. 通过加载内置的HTML文件，演示了如何在Web组件中实现表单元素的焦点可视化反馈。当用户点击文本输入框或密码框时，输入框背景会动态变为粉色，提供直观的交互反馈，增强用户体验。

### 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---|---|---WebFocusManagement.ets
|---|---|---WebFocusManagement2.ets
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```

### 相关权限

若使用本地资源，不涉及权限；若使用网络资源，需在module.json中配置网络权限：
{
"module": {
"requestPermissions": [
{
"name": "ohos.permission.INTERNET"
}
]
}
}

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行。
2. 本示例支持API22版本SDK，SDK版本号(API Version 22 Release)。
3. 本示例需要使用DevEco Studio 版本号(6.0.0Release)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkWeb/WebFocusManagement > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples/tree/master/code/DocsSample/ArkWeb
git pull origin master
```