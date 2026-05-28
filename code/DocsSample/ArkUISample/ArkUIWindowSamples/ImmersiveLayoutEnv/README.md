# ImmersiveLayoutEnv简介

### 介绍

本示例演示在Stage模型下结合系统环境变量进行沉浸式布局适配。页面通过窗口避让区环境变量布局内容，应用启动后设置窗口全屏布局。

### 效果预览

<img src="screenshots/ImmersiveLayoutEnv.png" alt="ImmersiveLayoutEnv" width="300">

### 使用说明

1. 启动应用。
2. 应用在创建主窗口后设置全屏布局。
3. 页面根据WINDOW_AVOID_AREA环境变量适配顶部、底部和挖孔区域。

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

窗口全屏布局在EntryAbility中实现，源码参考：[EntryAbility.ets](entry/src/main/ets/entryability/EntryAbility.ets)。

避让区布局在Index中实现，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行。
2. 本示例为Stage模型。

### 下载

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArkUIWindowSamples/ImmersiveLayoutEnv > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
