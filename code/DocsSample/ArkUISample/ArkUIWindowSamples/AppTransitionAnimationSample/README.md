# 设置主窗口销毁时的转场动画

### 介绍

本示例演示在Stage模型下为主窗口销毁过程配置转场动画。应用在自由窗口状态下关闭主窗口时，可观察窗口透明度转场效果。

### 效果预览

| 主窗口销毁转场动画 |
|---|
| ![appDestroyAnimation](screenshots/appDestroyAnimation.gif) |

### 使用说明

1. 安装并打开应用。
2. 在自由窗口状态下关闭应用主窗口。
3. 观察主窗口销毁时的透明度转场动画。

### 工程目录

```
AppTransitionAnimationSample
|---entry/src/main/ets
|   |---entryability
|   |   |---EntryAbility.ets              // 配置主窗口销毁时的转场动画
|   |---entrybackupability
|   |   |---EntryBackupAbility.ets        // 备份恢复能力
|   |---pages
|   |   |---Index.ets                     // 示例页面
|---screenshots
|   |---appDestroyAnimation.gif          // 效果预览图
```

### 具体实现

主窗口销毁转场动画配置在[EntryAbility.ets](entry/src/main/ets/entryability/EntryAbility.ets)中实现：

- 通过`windowStage.getMainWindow()`获取主窗口。
- 通过`getWindowTransitionAnimation()`查询窗口销毁时的转场动画配置。
- 配置`WindowAnimationConfig`和`TransitionAnimation`。
- 通过`setWindowTransitionAnimation()`设置窗口销毁时的转场动画。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，工程配置支持设备：default、tablet。
2. 本示例为Stage模型，支持API Version 23及以上版本SDK。
3. 本示例需要使用DevEco Studio 6.0.0 Release及以上版本才可编译运行。
4. 本示例用于自由窗口状态下验证主窗口销毁转场动画。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArkUIWindowSamples/AppTransitionAnimationSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
