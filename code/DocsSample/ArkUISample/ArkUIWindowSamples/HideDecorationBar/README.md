# HideDecorationBar简介

### 介绍

本示例演示在Stage模型下隐藏窗口标题栏并设置沉浸式布局。应用启动后获取主窗口对象，设置窗口全屏布局并隐藏装饰栏。

### 效果预览

<img src="screenshots/HideDecorationBar.png" alt="HideDecorationBar" width="300">

### 使用说明

1. 启动应用。
2. 应用在创建主窗口后获取Window对象。
3. 调用setWindowLayoutFullScreen和setWindowDecorVisible接口完成窗口显示设置。

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

隐藏装饰栏的方法在EntryAbility中实现，源码参考：[EntryAbility.ets](entry/src/main/ets/entryability/EntryAbility.ets)。

目标页面在Index中实现，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)。

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
echo code/DocsSample/ArkUISample/ArkUIWindowSamples/HideDecorationBar > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
