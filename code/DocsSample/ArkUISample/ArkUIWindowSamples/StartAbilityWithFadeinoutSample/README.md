# 设置应用内Ability跳转淡入淡出动效

### 介绍

本示例演示在Stage模型下通过`startAbility()`拉起同包名下的其他Ability，并为Ability启动过程配置淡入淡出动效。

### 效果预览

| Ability跳转淡入淡出动效 |
|---|
| ![startAbilityWithFadeInOut](screenshots/startAbilityWithFadeInOut.gif) |

### 使用说明

1. 安装并打开应用。
2. 点击“startAbility”按钮。
3. 应用拉起`FadeInOutAbility`，窗口以淡入淡出动效完成跳转。

### 工程目录

```
StartAbilityWithFadeinoutSample
|---entry/src/main/ets
|   |---entryability
|   |   |---EntryAbility.ets              // 加载首页
|   |   |---FadeInOutAbility.ets          // 加载跳转目标页
|   |---pages
|   |   |---Index.ets                     // 配置启动参数并拉起Ability
|   |   |---FadeInOutPage.ets             // 跳转后的目标页面
|---screenshots
|   |---startAbilityWithFadeInOut.gif    // 效果预览图
```

### 具体实现

Ability跳转淡入淡出动效在[Index.ets](entry/src/main/ets/pages/Index.ets)中实现：

- 构造目标Ability的`Want`，指定`FadeInOutAbility`。
- 构造`StartOptions`，在`windowCreateParams.animationParams`中配置`window.AnimationType.FADE_IN_OUT`。
- 调用`this.context.startAbility(want, options)`拉起目标Ability。

目标Ability在[FadeInOutAbility.ets](entry/src/main/ets/entryability/FadeInOutAbility.ets)中加载[FadeInOutPage.ets](entry/src/main/ets/pages/FadeInOutPage.ets)。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，工程配置支持设备：default、tablet。
2. 本示例为Stage模型，支持API Version 23及以上版本SDK。
3. 本示例需要使用DevEco Studio 6.0.0 Release及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArkUIWindowSamples/StartAbilityWithFadeinoutSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
