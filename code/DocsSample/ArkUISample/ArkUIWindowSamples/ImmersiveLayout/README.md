# ImmersiveLayout简介

### 介绍

本示例演示在Stage模型下实现沉浸式布局。应用启动后获取主窗口对象，并设置窗口进入全屏布局模式。

### 效果预览

<img src="screenshots/ImmersiveLayout.png" alt="ImmersiveLayout" width="300">

### 使用说明

1. 启动应用。
2. 应用在创建主窗口后获取Window对象。
3. 调用setWindowLayoutFullScreen接口设置沉浸式布局。

### 工程目录

```
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets
|---entrybackupability
|---pages
|   |---Index.ets
```

### 具体实现

沉浸式布局设置在EntryAbility中实现，源码参考：[EntryAbility.ets](entry/src/main/ets/entryability/EntryAbility.ets)。

目标页面在Index中实现，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行。
2. 本示例为Stage模型。
3. sdk: 23
   deveco: 6.1.0 Release

### 下载

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArkUIWindowSamples/ImmersiveLayout > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
