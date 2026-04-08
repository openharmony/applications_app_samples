# CreateMainWindow简介

### 介绍

本示例演示在 Stage 模型下实现窗口沉浸式布局的方法。通过获取主窗口对象，调用 `setWindowLayoutFullScreen(true)` 和 `setWindowDecorVisible(false)`，分别实现 Phone 端全屏布局和 PC 端隐藏标题栏效果，并结合安全区适配保证页面内容正常显示。


### 效果预览


### 使用说明

1.通过 getMainWindowSync 接口获取应用主窗口。
2.通过 setWindowLayoutFullScreen(true) 接口设置主窗口进入沉浸式布局，实现 Phone 端全屏显示效果。
3.通过 setWindowDecorVisible(false) 接口隐藏主窗口标题栏，实现 PC 端沉浸式显示效果。

### 工程目录

```
entry/src/main/ets/
|---main
|   |---ets
|   |   |---entryability
|   |   |   |---EntryAbility.ets           // 创建主窗口
|   |   |---entrybackupability
|   |   |---pages
|   |   |   |---Index.ets                  // 主窗口页面
|   |---resources
|   |---module.json5                       
|---ohosTest
|   |---ets 
|   |   |---test
|   |   |   |---Ability.test.ets           // 自动化测试代码
```

### 具体实现

创建主窗口的方法在EntryAbility中实现，源码参考：[EntryAbility.ets](https://gitcode.com/openharmony/applications_app_samples/blob/master/code/DocsSample/ArkUISample/ArkUIWindowSamples/HideDecorationBar/entry/src/main/ets/entryability/EntryAbility.ets)

- 使用getMainWindowSync 接口获取应用主窗口。
- 使用setWindowLayoutFullScreen(true) 接口设置主窗口进入沉浸式布局，实现 Phone 端全屏显示效果。
- 使用setWindowDecorVisible(false) 接口隐藏主窗口标题栏，实现 PC 端沉浸式显示效果。

目标页面在Index中实现，源码参考：[Index.ets](https://gitcode.com/openharmony/applications_app_samples/blob/master/code/DocsSample/ArkUISample/ArkUIWindowSamples/HideDecorationBar/entry/src/main/ets/pages/Index.ets)


### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：华为手机、平板、PC    。

2.本示例为Stage模型，支持API Version 20及以上版本SDK。

3.本示例需要使用DevEco Studio 6.0.0 Release及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```

```