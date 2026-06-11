# 设置窗口动效

### 介绍

本示例演示在Stage模型下设置窗口显示和隐藏过程中的自定义过渡动画。应用启动后点击按钮创建窗口，并播放显示或隐藏动画。

### 效果预览

| 设置窗口显示/隐藏动效 |
|---|
| ![showAndHideWindow](screenshots/showAndHideWindow.gif) |

### 使用说明

1. 安装并打开应用。
2. 点击“show window”按钮，创建窗口并播放显示动画。
3. 点击“hide window”按钮，播放隐藏动画并销毁窗口。

### 工程目录

```
WindowAnimationSample
|---entry/src/main/ets
|   |---entryability
|   |   |---EntryAbility.ets              // 加载示例页面
|   |---pages
|   |   |---AnimationConfig.ts            // 窗口动效配置
|   |   |---WindowAnimationDemo.ets       // 创建窗口并触发显示/隐藏动效
|   |   |---WindowContent.ets             // 被创建窗口加载的内容页面
|---screenshots
|   |---showAndHideWindow.gif            // 效果预览图
```

### 具体实现

窗口动效配置封装在[AnimationConfig.ts](entry/src/main/ets/pages/AnimationConfig.ts)中：

- 调用`getTransitionController()`获取窗口属性转换控制器。
- 设置`animationForShown`和`animationForHidden`，分别配置显示、隐藏过程的动画回调。
- 调用`showWithAnimation()`和`hideWithAnimation()`播放显示、隐藏动画。

窗口创建和动效触发在[WindowAnimationDemo.ets](entry/src/main/ets/pages/WindowAnimationDemo.ets)中：

- 通过`window.createWindow()`创建`WindowType.TYPE_FLOAT`类型窗口。
- 通过`setUIContent()`加载[WindowContent.ets](entry/src/main/ets/pages/WindowContent.ets)。
- 通过`animateTo()`配置平移、旋转、缩放和透明度变化。
- 在动画结束时调用`completeTransition(true)`完成属性转换。

### 相关权限

| 权限名 | 权限说明 | 级别 |
|---|---|---|
| ohos.permission.SYSTEM_FLOAT_WINDOW | 允许应用使用悬浮窗的能力 | system_basic |

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，工程配置支持设备：phone、tablet。
2. 本示例为Stage模型，支持API Version 20及以上版本SDK。
3. 本示例需要使用DevEco Studio 6.0.0 Release及以上版本才可编译运行。
4. 本示例所配置的权限`ohos.permission.SYSTEM_FLOAT_WINDOW`为system_basic级别，需要配置系统应用签名，可参考[特殊权限配置方法](https://gitcode.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md)。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ArkUIWindowSamples/WindowAnimationSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
