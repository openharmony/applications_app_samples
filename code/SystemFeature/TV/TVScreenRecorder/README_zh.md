# 录屏项目

### 介绍

本示例展示了 TV 形态下的屏幕录制能力，演示如何结合屏幕采集、媒体编码、悬浮窗提示和媒体库写入流程完成录屏功能。

工程同时包含主业务代码与 `ohosTest` 自动化测试代码，可用于验证录屏启动、停止、权限申请、Recent 投影、状态栏联动、异常恢复与性能回归等场景。

使用说明：

1. 启动应用并完成权限授权后，可开始屏幕录制。
2. 录制过程中会显示悬浮计时窗，用于提示当前录屏状态与时长。
3. 结束录制后会弹出结果提示，录制文件会写入系统媒体库。
4. 当分辨率不支持或录屏异常时，会显示对应提示页面或错误状态。

### 截图预览
![](./screenshots/device/main.png)
![](./screenshots/device/recording.png)
![](./screenshots/device/user_grant1.png)
![](./screenshots/device/user_grant2.png)

### 工程目录
```text
entry/src/main/
|---ets
|   |---ServiceExtAbility
|   |   |---ScreenRecorderAbility.ets    // 录屏服务扩展能力入口
|   |---common
|   |   |---Constants.ets                // 录屏状态与常量定义
|   |   |---InputConsumer.ets            // 按键事件消费逻辑
|   |   |---Logger.ets                   // 日志封装
|   |   |---SRManager.ets                // 录屏核心管理逻辑
|   |   |---WindowManager.ets            // 悬浮窗与提示窗管理
|   |---pages
|   |   |---ResolutionNotSupportedDialog.ets // 分辨率不支持提示页
|   |   |---ScreenRecorderDialog.ets     // 录屏完成提示页
|   |   |---ScreenRecorderTimer.ets      // 录屏计时悬浮窗
|   |---utils
|   |   |---SizeCalc.ets                 // TV 场景尺寸换算工具
|---resources
|   |---base                             // 默认资源
|   |---en_US                            // 英文资源
|   |---zh_CN                            // 中文资源
entry/src/ohosTest/ets/
|---TestRunner
|   |---OpenHarmonyTestRunner.ets        // 自动化测试入口
|---test
|   |---foundation                       // 基础断言、Mock 与夹具
|   |---srmanager                        // SRManager 深度回归测试
|   |---ability                          // 生命周期与编排测试
|   |---window                           // 窗口与浮窗测试
|   |---ui                               // UI、无障碍、布局测试
|   |---service                          // 输入与命令流测试
|   |---performance                      // 性能与长稳压测
|   |---contract                         // 契约、安全与持久化测试
```

### 具体实现

- 录屏核心流程封装在 [SRManager.ets](entry/src/main/ets/common/SRManager.ets)
    * 负责录屏创建、启动、停止、状态维护与结果回写；
    * 结合媒体库与屏幕录制能力完成文件输出链路。
- 窗口展示能力封装在 [WindowManager.ets](entry/src/main/ets/common/WindowManager.ets)
    * 负责录屏计时悬浮窗、录屏完成提示窗与异常提示窗的创建和关闭；
    * 配合页面组件展示录制状态、完成提示和分辨率异常提示。
- 页面展示能力封装在 [ScreenRecorderTimer.ets](entry/src/main/ets/pages/ScreenRecorderTimer.ets)、[ScreenRecorderDialog.ets](entry/src/main/ets/pages/ScreenRecorderDialog.ets)、[ResolutionNotSupportedDialog.ets](entry/src/main/ets/pages/ResolutionNotSupportedDialog.ets)
    * `ScreenRecorderTimer` 用于显示录屏状态、红点闪烁和录制时长；
    * `ScreenRecorderDialog` 用于提示录屏已完成并写入媒体库；
    * `ResolutionNotSupportedDialog` 用于提示当前设备分辨率不满足录屏要求。
- 服务与输入能力封装在 [ScreenRecorderAbility.ets](entry/src/main/ets/ServiceExtAbility/ScreenRecorderAbility.ets) 与 [InputConsumer.ets](entry/src/main/ets/common/InputConsumer.ets)
    * 前者提供服务扩展能力入口；
    * 后者处理按键消费与录屏快捷结束场景。
- 自动化测试能力位于 [ListTest.ets](entry/src/ohosTest/ets/test/ListTest.ets)
    * 已覆盖基础能力、状态流转、窗口、性能、契约、安全、无障碍与布局等回归场景；
    * 适合作为 TV 录屏工程的回归验证入口。

### 相关权限

| 权限名                                           | 权限说明                         | 级别 |
|------------------------------------------------|--------------------------------|------|
| ohos.permission.MEDIA_LOCATION                 | 允许访问媒体文件中的位置信息               | -    |
| ohos.permission.MICROPHONE                     | 允许录屏时采集麦克风音频                 | -    |
| ohos.permission.READ_IMAGEVIDEO                | 允许读取图片和视频媒体文件                | -    |
| ohos.permission.WRITE_IMAGEVIDEO               | 允许写入图片和视频媒体文件                | -    |
| ohos.permission.SYSTEM_FLOAT_WINDOW            | 允许显示录屏悬浮计时窗                  | 系统权限 |
| ohos.permission.CAPTURE_SCREEN                 | 允许执行屏幕采集与录制                  | 系统权限 |
| ohos.permission.EXEMPT_CAPTURE_SCREEN_AUTHORIZE | 允许免弹框执行屏幕录制相关授权流程            | 系统权限 |

### 依赖

本工程运行时主要依赖 OpenHarmony 提供的屏幕采集、媒体编码、媒体库访问和窗口管理等系统能力；测试侧依赖 `@ohos/hypium` 作为自动化测试框架。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568, V900。

2.本示例为Stage模型，支持API10版本SDK，SDK版本号(API Version 12 Release),镜像版本号(5.0 Release)

3.本示例需要使用DevEco Studio 版本号(5.0 Release)及以上版本才可编译运行。

4.本示例涉及部分接口需要配置系统应用签名，可以参考[特殊权限配置方法](https://gitcode.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md)
，把配置文件中的“apl”字段信息改为“system_core”。

### 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/SystemFeature/TV/TVScreenRecorder > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
