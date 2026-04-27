# 相机项目

### 介绍

相机应用是一个面向 OpenHarmony 电视设备的相机示例工程，覆盖以下核心能力：

- 相机预览、拍照、录像；
- 本地/分布式设备相关能力（远端设备发现与切换）；
- 镜头切换、闪光灯、分辨率/水印等设置项；
- 悬浮窗能力与窗口平滑移动（`FloatWindowManager` + `WindowMoverManager`）。

应用入口位于 `entry/src/main/ets/entryability/EntryAbility.ets`，主页面为
`entry/src/main/ets/pages/Index.ets`，并通过 `entry/src/main/cpp` 下的 Native 模块参与相机能力构建。

使用说明：

1. 安装并启动应用，按提示授予相机、麦克风、媒体文件等权限。
2. 进入首页后可进行预览、拍照、录像、切换镜头和参数调节。
3. 通过设置页可切换水印、分辨率等配置（受具体设备能力影响）。
4. 需要悬浮窗场景时，可通过 `FloatWindowAbility` 启动悬浮窗服务。

### 截图预览
![](./app_pic/auth1.jpg)
![](./app_pic/auth2.jpg)
![](./app_pic/auth3.jpg)
![](./app_pic/preview.jpg)

### 工程目录
```text
entry/src/main/ets/
|---entryability/
|   |---EntryAbility.ets             // 主入口 Ability
|---entryability1/
|   |---EntryAbility1.ets            // 辅助入口 Ability
|---floatwindowability/
|   |---FloatWindowAbility.ets       // 悬浮窗服务 Ability
|---common
|   |---Constants.ets                // 通用常量
|   |---DisplayCalculator.ets        // 显示参数计算
|   |---PointerUtil.ets              // 指针/坐标工具
|---model
|   |---CameraPermissionManager.ets  // 权限管理
|   |---CameraPreviewManager.ets     // 预览管理
|   |---CameraSettingsManager.ets    // 设置管理
|   |---CameraStateManager.ets       // 状态管理
|   |---MediaUtils.ets               // 媒体文件工具
|---models
|   |---CameraModel.ets              // 相机核心模型
|   |---RemoteDeviceModel.ets        // 远端设备模型
|---pages
|   |---Index.ets                    // 相机主页面
|   |---CameraSettingsPage.ets       // 设置页面
|   |---MultiCameraPreviewPage.ets   // 多设备预览页面
|---utils
|   |---FloatWindowManager.ets       // 悬浮窗管理
|   |---WindowMoverManager.ets       // 窗口平滑移动
|   |---PreferenceUtil.ets           // 偏好存储工具
|---views
|   |---ModeSwitchPage.ets           // 模式切换视图

entry/src/ohosTest/ets/test/
|---model/ models/ utils/ pages/...  // Hypium 单元与场景测试
```

### 具体实现

- 主页面能力封装在 [Index.ets](entry/src/main/ets/pages/Index.ets)，负责相机预览与主要交互流程。
- 相机核心逻辑封装在 [CameraModel.ets](entry/src/main/ets/models/CameraModel.ets)：
    * 管理相机初始化、拍照、资源释放；
    * 统一本地拍照与远端拍照分支；
    * 通过回调处理 JPEG 数据并落盘。
- 远端设备能力封装在 [RemoteDeviceModel.ets](entry/src/main/ets/models/RemoteDeviceModel.ets)：
    * 维护发现设备列表与信任列表；
    * 支持设备发现/停止发现与状态同步。
- 悬浮窗与窗口移动能力封装在 [FloatWindowManager.ets](entry/src/main/ets/utils/FloatWindowManager.ets)
  与 [WindowMoverManager.ets](entry/src/main/ets/utils/WindowMoverManager.ets)：
    * 支持悬浮窗创建、显示、销毁；
    * 支持动画平滑移动与位置持久化。
- 偏好数据管理封装在 [PreferenceUtil.ets](entry/src/main/ets/utils/PreferenceUtil.ets)
  与 [PreferencesManager.ets](entry/src/main/ets/utils/PreferencesManager.ets)。

### 相关权限

| 权限名                                              | 权限说明                                 | 级别 |
|--------------------------------------------------|--------------------------------------|------|
| ohos.permission.CAMERA                           | 允许应用访问相机                            | normal |
| ohos.permission.MICROPHONE                       | 允许应用访问麦克风                          | normal |
| ohos.permission.WRITE_IMAGEVIDEO                 | 允许写入公共目录图片/视频                      | system_basic |
| ohos.permission.READ_IMAGEVIDEO                  | 允许读取公共目录图片/视频                      | system_basic |
| ohos.permission.MEDIA_LOCATION                   | 允许读取媒体地理位置信息                        | normal |
| ohos.permission.WRITE_MEDIA                      | 允许写媒体资源                              | normal |
| ohos.permission.READ_MEDIA                       | 允许读媒体资源                              | normal |
| ohos.permission.SYSTEM_FLOAT_WINDOW              | 允许创建系统悬浮窗                            | system_basic |
| ohos.permission.START_ABILITIES_FROM_BACKGROUND  | 允许后台拉起 Ability                      | system_basic |
| ohos.permission.DISTRIBUTED_DATASYNC             | 允许分布式数据同步                            | normal |
| ohos.permission.ACCESS_SERVICE_DM                | 允许访问分布式设备管理服务                      | system_basic |
| ohos.permission.MANAGE_DISTRIBUTED_ACCOUNTS      | 允许管理分布式账号                            | system_basic |
| ohos.permission.GET_BUNDLE_INFO_PRIVILEGED       | 允许获取应用包信息（特权）                      | system_basic |

### 依赖

- OpenHarmony API（ArkUI/AbilityKit/CameraKit/ImageKit/CoreFileKit 等）
- Native 构建链（`CMakeLists.txt` + `libentry.so`）
- 测试框架：Hypium（`entry/src/ohosTest`）

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
echo code/SystemFeature/TV/TVCamera > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
